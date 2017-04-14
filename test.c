// NEED .code16gcc
// This tells gcc to use `call` and `retl`, which will use 32 bit values for
// the return pointer stored on the stack.
// We need this because gcc assumes 32 bit values when looking for arguments
// stored on the stack in printString() irrespective of what values it has put
// on the stack.
// See here for the difference between .code16gcc and .code16
// https://sourceware.org/binutils/docs/as/i386_002d16bit.html
__asm__(".code16gcc\n");
__asm__("jmpl $0x000, $main\n");

void printString(const char* pStr)
{
    while (*pStr) {
        __asm__ __volatile__(
            "int $0x10" : : "a"(0x0e00 | *pStr), "b"(0x0007)
        );
        pStr++;
    }
}

void main() {
    printString("Hello, World");
}
