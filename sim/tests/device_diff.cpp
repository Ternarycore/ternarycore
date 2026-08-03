#include <cstdio>
#include <cstdint>
#include <cstdlib>

#define VLEN 8

static uint32_t lcg_next(uint32_t *state) {
    *state = *state * 1103515245 + 12345;
    return *state;
}

static int decode_weight(uint8_t enc) {
    switch (enc) {
        case 0b01: return +1;
        case 0b10: return -1;
        default:   return 0;
    }
}

static int8_t activation_quant(int8_t x) {
    int inv = 41615;
    int64_t prod = (int64_t)x * inv;
    int q = (int)((prod + (1 << 14)) >> 15);
    if (q > 127) q = 127;
    if (q < -127) q = -127;
    return (int8_t)q;
}

static int32_t scale_q15(int32_t acc, int alpha) {
    int64_t prod = (int64_t)acc * alpha;
    int32_t trunc = (int32_t)(prod & 0x7FFF);
    int round = (trunc != 0) ? 1 : 0;
    return (int32_t)(prod >> 15) + round;
}

int main(int argc, char **argv) {
    if (argc < 2) { fprintf(stderr, "usage: %s <seed>\n", argv[0]); return 1; }
    uint32_t seed = (uint32_t)atol(argv[1]);
    uint32_t rng = seed;

    int8_t act[2 * VLEN];
    int wenc[2 * VLEN];
    for (int i = 0; i < 2 * VLEN; i++) {
        rng = lcg_next(&rng);
        act[i]  = (int8_t)((int32_t)(rng % 256) - 128);
        rng = lcg_next(&rng);
        wenc[i] = (int)(rng % 3);
    }

    int alpha = 32768;
    int32_t results[2], scaled[2];

    for (int v = 0; v < 2; v++) {
        int32_t acc = 0;
        for (int i = 0; i < VLEN; i++) {
            int idx = v * VLEN + i;
            int8_t q = activation_quant(act[idx]);
            int w = decode_weight(wenc[idx]);
            acc += (int32_t)q * w;
        }
        results[v] = acc;
        scaled[v] = scale_q15(acc, alpha);
    }

    printf("RESULT: %d %d %d %d\n", results[0], scaled[0], results[1], scaled[1]);
    return 0;
}
