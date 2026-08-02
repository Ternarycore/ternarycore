/* Minimal newlib stubs for the bare-metal LMB build (see DEVKIT.md).
 * The firmware carries its own UART driver; these satisfy the linker. */
void outbyte(char c) { (void)c; }
char inbyte(void) { return 0; }
