/*  TernaryCore power meter — ESP32-S3 + INA226 + SSD1306.
 *
 *  Measures the Arty's 12 V barrel feed through the R100 shunt, integrates
 *  energy in software (the INA226 has no hardware accumulator -- that is
 *  the INA228; ours converts continuously and we trapezoid at ~50 Hz),
 *  shows it on the OLED, and serves it over Wi-Fi:
 *
 *      GET  /power   {"v":12.08,"i":0.154,"w":1.86,"j":124.5,"ms":123456}
 *      POST /zero    reset the energy counter, returns the joules it held
 *      POST /tok     ?n=14&jpt=6.2   -> shown on the OLED bottom line
 *      GET  /        a tiny live page with the same numbers
 *
 *  The inference wrapper on the host polls /power at position boundaries,
 *  so per-token joules need no MARK wire: the host knows when a position
 *  starts and ends because it is the one driving the UART. GPIO4 still
 *  counts MARK edges if you ever wire it -- the code just doesn't need it.
 *
 *  Board: "ESP32S3 Dev Module" (Arduino core 3.x). Libraries: Adafruit
 *  SSD1306 + Adafruit GFX (Library Manager). Wiring per the rig sheet:
 *  SDA=GPIO8, SCL=GPIO9, INA226 at 0x40, OLED at 0x3C, MARK=GPIO4.
 *
 *  SPDX-License-Identifier: CERN-OHL-S-2.0
 */

#include <WiFi.h>
#include <WebServer.h>
#include <ESPmDNS.h>
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>

/*  Wi-Fi credentials live in secrets.h, which is gitignored.
 *  Copy secrets.h.example to secrets.h and fill it in.                 */
#include "secrets.h"

#define PIN_SDA   8
#define PIN_SCL   9
#define PIN_MARK  4
#define INA_ADDR  0x40
#define OLED_ADDR 0x3C

/*  INA226 calibration, from the rig sheet's yellow card:
 *  R = 0.1 ohm, current_LSB = 25 uA  ->  CAL = 0.00512/(25e-6*0.1) = 2048.
 *  Power LSB = 25 * current_LSB = 625 uW.  Full scale 81.92 mV -> 0.82 A,
 *  9.8 W at 12 V -- the board peaks near 0.4 A, so half scale.        */
#define INA_CAL       2048
#define CURRENT_LSB   25e-6f
#define POWER_LSB     625e-6f
/*  Config 0x4127: AVG=4, VBUSCT=1.1ms, VSHCT=1.1ms, continuous shunt+bus.
 *  ~8.8 ms per fresh reading; we integrate every 20 ms.               */
#define INA_CONFIG    0x4127

Adafruit_SSD1306 oled(128, 64, &Wire, -1);
WebServer server(80);

/*  The meter state. joules is the accumulator the host brackets.       */
volatile double joules = 0.0;
float volts = 0, amps = 0, watts = 0;
uint32_t lastIntegrateUs = 0;
volatile uint32_t markEdges = 0;

/*  What the host tells us about tokens, for the OLED only.             */
int   tokCount = 0;
float jPerTok  = 0;

/*  60-second sparkline, one bin per second.                            */
float sparkW[60] = {0};
uint8_t sparkHead = 0;
float sparkAccum = 0; uint16_t sparkN = 0;
uint32_t sparkLastMs = 0;

/* ---- INA226 ----------------------------------------------------------- */
void inaWrite(uint8_t reg, uint16_t val) {
  Wire.beginTransmission(INA_ADDR);
  Wire.write(reg); Wire.write(val >> 8); Wire.write(val & 0xFF);
  Wire.endTransmission();
}
uint16_t inaRead(uint8_t reg) {
  Wire.beginTransmission(INA_ADDR);
  Wire.write(reg);
  Wire.endTransmission(false);
  Wire.requestFrom((int)INA_ADDR, 2);
  uint16_t v = Wire.read() << 8; v |= Wire.read();
  return v;
}
bool inaInit() {
  Wire.beginTransmission(INA_ADDR);
  if (Wire.endTransmission() != 0) return false;
  inaWrite(0x00, INA_CONFIG);
  inaWrite(0x05, INA_CAL);
  return true;
}
void inaSample() {
  volts = inaRead(0x02) * 1.25e-3f;                 /* bus LSB 1.25 mV  */
  int16_t rawI = (int16_t)inaRead(0x04);
  amps  = rawI * CURRENT_LSB;
  watts = inaRead(0x03) * POWER_LSB;
  uint32_t now = micros();
  if (lastIntegrateUs != 0)
    joules += (double)watts * (now - lastIntegrateUs) * 1e-6;
  lastIntegrateUs = now;
}

/* ---- MARK (optional) -------------------------------------------------- */
void IRAM_ATTR onMark() { markEdges++; }

/* ---- OLED ------------------------------------------------------------- */
void drawScreen() {
  oled.clearDisplay();
  oled.setTextColor(SSD1306_WHITE);
  oled.setTextSize(1);
  oled.setCursor(0, 0);
  oled.printf("TernaryCore   %5.2fV", volts);
  oled.setTextSize(2);
  oled.setCursor(0, 12);
  oled.printf("%5.2f W", watts);
  oled.setTextSize(1);
  oled.setCursor(92, 19);
  oled.printf("%4.0fmA", amps * 1000);
  oled.setCursor(0, 32);
  if (tokCount > 0) oled.printf("tok %-4d  %5.2f J/tok", tokCount, jPerTok);
  else              oled.printf("%7.1f J total", joules);
  /* sparkline: last 60 s of power along the bottom 16 px */
  float mx = 0.5f;
  for (int i = 0; i < 60; i++) if (sparkW[i] > mx) mx = sparkW[i];
  for (int i = 0; i < 60; i++) {
    float v = sparkW[(sparkHead + i) % 60];
    int h = (int)(v / mx * 14);
    if (h > 0) oled.drawFastVLine(4 + i * 2, 62 - h, h, SSD1306_WHITE);
  }
  oled.display();
}

/* ---- HTTP ------------------------------------------------------------- */
void handlePower() {
  char buf[128];
  snprintf(buf, sizeof buf,
           "{\"v\":%.3f,\"i\":%.4f,\"w\":%.3f,\"j\":%.4f,\"ms\":%lu,"
           "\"mark\":%lu}",
           volts, amps, watts, joules, (unsigned long)millis(),
           (unsigned long)markEdges);
  server.send(200, "application/json", buf);
}
void handleZero() {
  char buf[48];
  snprintf(buf, sizeof buf, "{\"was\":%.4f}", joules);
  joules = 0.0;
  server.send(200, "application/json", buf);
}
void handleTok() {
  if (server.hasArg("n"))   tokCount = server.arg("n").toInt();
  if (server.hasArg("jpt")) jPerTok  = server.arg("jpt").toFloat();
  server.send(200, "text/plain", "ok");
}
void handleRoot() {
  server.send(200, "text/html",
    "<!doctype html><meta name=viewport content='width=device-width'>"
    "<body style='background:#0e1113;color:#d8dee2;font:16px monospace;"
    "padding:2em'><h3 style='color:#63c8a8'>TernaryCore power</h3>"
    "<pre id=o>...</pre><script>setInterval(async()=>{let r=await "
    "fetch('/power');let d=await r.json();o.textContent="
    "`${d.v.toFixed(2)} V\\n${d.w.toFixed(2)} W   ${(d.i*1000).toFixed(0)}"
    " mA\\n${d.j.toFixed(1)} J since zero`;},500)</script>");
}

/* ---- setup / loop ----------------------------------------------------- */
void setup() {
  Serial.begin(115200);
  Wire.begin(PIN_SDA, PIN_SCL, 400000);
  pinMode(PIN_MARK, INPUT);
  attachInterrupt(PIN_MARK, onMark, RISING);

  bool haveOled = oled.begin(SSD1306_SWITCHCAPVCC, OLED_ADDR);
  if (haveOled) { oled.clearDisplay(); oled.display(); }

  if (!inaInit())
    Serial.println("INA226 not answering at 0x40 -- check SDA/SCL");

  WiFi.mode(WIFI_STA);
  WiFi.begin(WIFI_SSID, WIFI_PASS);
  for (int i = 0; i < 40 && WiFi.status() != WL_CONNECTED; i++)
    delay(250);
  if (WiFi.status() == WL_CONNECTED) {
    Serial.print("IP: "); Serial.println(WiFi.localIP());
    MDNS.begin("tc-power");                 /* http://tc-power.local */
  } else {
    Serial.println("wifi failed; meter still runs, HTTP does not");
  }

  server.on("/",      handleRoot);
  server.on("/power", handlePower);
  server.on("/zero",  HTTP_POST, handleZero);
  server.on("/tok",   HTTP_POST, handleTok);
  server.begin();
}

void loop() {
  static uint32_t lastSample = 0, lastDraw = 0;
  uint32_t now = millis();

  if (now - lastSample >= 20) {             /* integrate at 50 Hz */
    lastSample = now;
    inaSample();
    sparkAccum += watts; sparkN++;
  }
  if (now - sparkLastMs >= 1000) {          /* one sparkline bin per second */
    sparkLastMs = now;
    sparkW[sparkHead] = sparkN ? sparkAccum / sparkN : 0;
    sparkHead = (sparkHead + 1) % 60;
    sparkAccum = 0; sparkN = 0;
  }
  if (now - lastDraw >= 250) {              /* 4 Hz display refresh */
    lastDraw = now;
    drawScreen();
  }
  server.handleClient();
}
