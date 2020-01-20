/*
 * "Hello World" example.
 *
 * This example prints 'Hello from Nios II' to the STDOUT stream. It runs on
 * the Nios II 'standard', 'full_featured', 'fast', and 'low_cost' example
 * designs. It runs with or without the MicroC/OS-II RTOS and requires a STDOUT
 * device in your system's hardware.
 * The memory footprint of this hosted application is ~69 kbytes by default
 * using the standard reference design.
 *
 * For a reduced footprint version of this template, and an explanation of how
 * to reduce the memory footprint for a given application, see the
 * "small_hello_world" template.
 *
 */
#include <stdio.h>
#include <system.h>
#include "io.h"
#include <stdlib.h>
#include <unistd.h>
#include "functions.h"
#include <inttypes.h>

int main()
{

  int Test_LT24 = 1;
  int Test_DMA = 0;

  if (Test_LT24 == 1){
  init_LCD();
  write_cmd();
  Test();
  }

  if (Test_DMA == 1){
  test_DMA(HPS_0_BRIDGES_BASE);
  init_LCD();
  Init_DMA();
  DMA_START_ADRESS(HPS_0_BRIDGES_BASE);
  write_cmd();
  }


}

void Init_DMA (){

	DMA_RESTART();
	DMA_LENGTH();
	DMA_BURST();

}

void Test(){

	int i;
	for (i = 0; i < 76800; i++){

		LCD_WR_DATA(0x0000F800);

	}
}
void write_cmd(){
	LCD_WR_REG(0x0400002C);
}

void test_DMA(int* addr0) {

	for (int i=0;i<153600;i=i+4) {
		IOWR_32DIRECT(addr0,i,0xF800F800);
	}
}

void init_LCD() {

	LCD_RESET_UP();
	usleep(1000);

	LCD_RESET_DOWN();
	usleep(10000);
	LCD_RESET_UP();
	usleep(120000);

	LCD_WR_REG(0x0011);
	LCD_WR_REG(0x00CF | 0x00400000);
	LCD_WR_DATA(0x0000 | 0x00400000);
	LCD_WR_DATA(0x0081 | 0x00400000);
	LCD_WR_DATA(0X00c0);

	LCD_WR_REG(0x00ED | 0x00400000);
	LCD_WR_DATA(0x0064 | 0x00400000);
	LCD_WR_DATA(0x0003 | 0x00400000);
	LCD_WR_DATA(0X0012 | 0x00400000);
	LCD_WR_DATA(0X0081);

	LCD_WR_REG(0x00E8 | 0x00400000);
	LCD_WR_DATA(0x0085 | 0x00400000);
	LCD_WR_DATA(0x0001 | 0x00400000);
	LCD_WR_DATA(0x00798);

	LCD_WR_REG(0x00CB | 0x00400000);
	LCD_WR_DATA(0x0039 | 0x00400000);
	LCD_WR_DATA(0x002C | 0x00400000);
	LCD_WR_DATA(0x0000 | 0x00400000);
	LCD_WR_DATA(0x0034 | 0x00400000);
	LCD_WR_DATA(0x0002);

	LCD_WR_REG(0x00F7 | 0x00400000);
	LCD_WR_DATA(0x0020);

	LCD_WR_REG(0x00EA | 0x00400000);
	LCD_WR_DATA(0x0000 | 0x00400000);
	LCD_WR_DATA(0x0000);

	LCD_WR_REG(0x00B1 | 0x00400000);
	LCD_WR_DATA(0x0000 | 0x00400000);
	LCD_WR_DATA(0x001b);

	LCD_WR_REG(0x00B6 | 0x00400000);
	LCD_WR_DATA(0x000A | 0x00400000);
	LCD_WR_DATA(0x00A2);

	LCD_WR_REG(0x00C0 | 0x00400000);
	LCD_WR_DATA(0x0005);

	LCD_WR_REG(0x00C1 | 0x00400000);
	LCD_WR_DATA(0x0011);

	LCD_WR_REG(0x00C5 | 0x00400000);
	LCD_WR_DATA(0x0045 | 0x00400000);
	LCD_WR_DATA(0x0045);

	LCD_WR_REG(0x00C7 | 0x00400000);
	LCD_WR_DATA(0X00a2);

	LCD_WR_REG(0x0036 | 0x00400000);
	LCD_WR_DATA(0x0008);

	LCD_WR_REG(0x00F2 | 0x00400000);
	LCD_WR_DATA(0x0000);

	LCD_WR_REG(0x0026 | 0x00400000);
	LCD_WR_DATA(0x0001);

	LCD_WR_REG(0x00E0 | 0x00400000);
	LCD_WR_DATA(0x000F | 0x00400000);
	LCD_WR_DATA(0x0026 | 0x00400000);
	LCD_WR_DATA(0x0024 | 0x00400000);
	LCD_WR_DATA(0x000b | 0x00400000);
	LCD_WR_DATA(0x000E | 0x00400000);
	LCD_WR_DATA(0x0008 | 0x00400000);
	LCD_WR_DATA(0x004b | 0x00400000);
	LCD_WR_DATA(0X00a8 | 0x00400000);
	LCD_WR_DATA(0x003b | 0x00400000);
	LCD_WR_DATA(0x000a | 0x00400000);
	LCD_WR_DATA(0x0014 | 0x00400000);
	LCD_WR_DATA(0x0006 | 0x00400000);
	LCD_WR_DATA(0x0010 | 0x00400000);
	LCD_WR_DATA(0x0009 | 0x00400000);
	LCD_WR_DATA(0x0000);

	LCD_WR_REG(0X00E1 | 0x00400000);
	LCD_WR_DATA(0x0000 | 0x00400000);
	LCD_WR_DATA(0x001c | 0x00400000);
	LCD_WR_DATA(0x0020 | 0x00400000);
	LCD_WR_DATA(0x0004 | 0x00400000);
	LCD_WR_DATA(0x0010 | 0x00400000);
	LCD_WR_DATA(0x0008 | 0x00400000);
	LCD_WR_DATA(0x0034 | 0x00400000);
	LCD_WR_DATA(0x0047 | 0x00400000);
	LCD_WR_DATA(0x0044 | 0x00400000);
	LCD_WR_DATA(0x0005 | 0x00400000);
	LCD_WR_DATA(0x000b | 0x00400000);
	LCD_WR_DATA(0x0009 | 0x00400000);
	LCD_WR_DATA(0x002f | 0x00400000);
	LCD_WR_DATA(0x0036 | 0x00400000);
	LCD_WR_DATA(0x000f);

	LCD_WR_REG(0x002A | 0x00400000);
	LCD_WR_DATA(0x0000 | 0x00400000);
	LCD_WR_DATA(0x0000 | 0x00400000);
	LCD_WR_DATA(0x0000 | 0x00400000);
	LCD_WR_DATA(0x00ef);

	LCD_WR_REG(0x002B | 0x00400000);
	LCD_WR_DATA(0x0000 | 0x00400000);
	LCD_WR_DATA(0x0000 | 0x00400000);
	LCD_WR_DATA(0x0001 | 0x00400000);
	LCD_WR_DATA(0x003f);

	LCD_WR_REG(0x003A | 0x00400000);
	LCD_WR_DATA(0x0055);

	LCD_WR_REG(0x00f6 | 0x00400000);
	LCD_WR_DATA(0x0001 | 0x00400000);
	LCD_WR_DATA(0x0030 | 0x00400000);
	LCD_WR_DATA(0x0000);

	LCD_WR_REG(0x0029);



}
