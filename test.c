// NOTE need .code16gcc
// This tells gcc to use `call` and `retl`, which will use 32 bit values for
// the return pointer stored on the stack.
// We need this because gcc assumes 32 bit values when looking for arguments
// stored on the stack in printString() irrespective of what values it has put
// on the stack.
// See here for the difference between .code16gcc and .code16
// https://sourceware.org/binutils/docs/as/i386_002d16bit.html
__asm__(".code16gcc\n");
__asm__("jmpl $0x0000, $main\n");

// NOTE
//  I inline these functions in order to save space in the code segment (by
//  avoiding setup/handling of call frames). There is no downside to this
//  because the only function that is used in more than one place is
//  drawPixel(), and this is already inlined by gcc.
//      (See this by looking at the disassembly of the code created ... there
//      are 4 loops in the initGraphics() function with `int    $0x10` in them
//      and either incrementing/decrementing %cx or %dx).
//
//  The interrupt codes that are "usually" available are documented here
//  http://wiki.osdev.org/BIOS
//  This makes it much easier to see what each function here is doing.
//
//  The processor is originally in "real mode". This defaults to 16 bit
//  arguments, but is *not* limited to them.
//  The prefix byte (0x66) to use 32 bit values/registers is perfectly valid in
//  real mode.

#define MAX_COLS     320 // maximum columns of the screen
#define MAX_ROWS     200 // maximum rows of the screen

// function to print string onto the screen
// input ah = 0x0e
// input al = <character to print>
// interrupt: 0x10
// we use interrupt 0x10 with function code 0x0e to print
// a byte in al onto the screen
// this function takes string as an argument and then
// prints character by character until it founds null
// character
inline void printString(const char* pStr) {
     while(*pStr) {
         // The constraints here ("a", and "b") are marking what registers the
         // arguments have to be in.
         // we want 0x0e00 in the "a" register, and 0x0007 in the "b" register.
          __asm__ (
               "int $0x10" : : "a"(0x0e00 | *pStr), "b"(0x0007)
          );
          ++pStr;
     }
}

// function to get a keystroke from the keyboard
// input ah = 0x00
// input al = 0x00
// interrupt: 0x10
// we use this function to hit a key to continue by the
// user
inline void getch() {
    // Zero register %ax, and interrupt 0x16
    //  n.b. I suspect this statement isn't correctly formed.
    //  For one thing, it clearly affects the value stored in %ax, but doesn't
    //  mention it to the compiler in the "output argument" option.
    //  For another, I expect it stores the character read from the keyboard
    //  somewhere, so wherever it's stored should also be mentioned to the
    //  compiler.
     __asm__ (
          "xorw %ax, %ax\n"
          "int $0x16\n"
     );
}

// function to print a colored pixel onto the screen
// at a given column and at a given row
// input ah = 0x0c
// input al = desired color
// input cx = desired column
// input dx = desired row
// interrupt: 0x10
inline void drawPixel(unsigned char color, int col, int row) {
     __asm__ (
          "int $0x10" : : "a"(0x0c00 | color), "c"(col), "d"(row)
     );
}

// function to clear the screen and set the video mode to
// 320x200 pixel format
// function to clear the screen as below
// input ah = 0x00
// input al = 0x03
// interrupt = 0x10
// function to set the video mode as below
// input ah = 0x00
// input al = 0x13
// interrupt = 0x10
inline void initEnvironment() {
     // clear screen
     __asm__ (
          "int $0x10" : : "a"(0x03)
     );
     __asm__ (
          "int $0x10" : : "a"(0x0013)
     );
}

// function to print rectangles in descending order of
// their sizes
// I follow the below sequence
// (left, top)     to (left, bottom)
// (left, bottom)  to (right, bottom)
// (right, bottom) to (right, top)
// (right, top)    to (left, top)
inline void initGraphics() {
     int i = 0, j = 0;
     int m = 0;
     int cnt1 = 0, cnt2 =0;
     unsigned char color = 10;

     for(;;) {
          if(m < (MAX_ROWS - m)) {
               ++cnt1;
          }
          if(m < (MAX_COLS - m - 3)) {
               ++cnt2;
          }

          if(cnt1 != cnt2) {
               cnt1  = 0;
               cnt2  = 0;
               m     = 0;
               if(++color > 255) color= 0;
          }

          // (left, top) to (left, bottom)
          j = 0;
          for(i = m; i < MAX_ROWS - m; ++i) {
               drawPixel(color, j+m, i);
          }
          // (left, bottom) to (right, bottom)
          for(j = m; j < MAX_COLS - m; ++j) {
               drawPixel(color, j, i);
          }

          // (right, bottom) to (right, top)
          for(i = MAX_ROWS - m - 1 ; i >= m; --i) {
               drawPixel(color, MAX_COLS - m - 1, i);
          }
          // (right, top)   to (left, top)
          for(j = MAX_COLS - m - 1; j >= m; --j) {
               drawPixel(color, j, m);
          }
          m += 6;
          if(++color > 255)  color = 0;
     }
}

// function is boot code and it calls the below functions print a message to
// the screen to make the user hit the key to proceed further and then once the
// user hits then it displays rectangles in the descending order
void main() {
     printString("Now in bootloader...hit a key to continue\n\r");
     getch();
     initEnvironment();
     initGraphics();
}
