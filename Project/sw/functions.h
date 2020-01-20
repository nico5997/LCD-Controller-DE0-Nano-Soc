/*
 * functions.h
 *
 *  Created on: 20 déc. 2019
 *      Author: lefebure
 */

#ifndef FUNCTIONS_H_
#define FUNCTIONS_H_

#include <stdio.h>
#include <system.h>
#include "io.h"
#include <stdlib.h>
#include <unistd.h>

// LCD Registers
#define LCD_WR_REG(REG)  IOWR_32DIRECT(NEW_COMPONENT_0_BASE, 16, REG) // Command address (DCX == 0)
#define LCD_WR_DATA(REG) IOWR_32DIRECT(NEW_COMPONENT_0_BASE, 16, REG | 0x00100000) // Command data (DCX == 1)
#define WRITE_CMD_TO_LCD() IOWR_32DIRECT(NEW_COMPONENT_0_BASE, 16, 0x4000002c) // Memory Write LCD
#define LCD_ON_UP() IOWR_32DIRECT(NEW_COMPONENT_0_BASE, 16, 0x000E0000) // LCD_On up
#define LCD_ON_DOWN() IOWR_32DIRECT(NEW_COMPONENT_0_BASE, 16, 0x000C0000) // LCD_On down
#define LCD_RESET_UP() \
	IOWR_32DIRECT(NEW_COMPONENT_0_BASE, 16, 0x000E0000) // LCD_Reset up
#define LCD_RESET_DOWN() IOWR_32DIRECT(NEW_COMPONENT_0_BASE, 16, 0x000A0000) // lcd_rESET Down

// DMA Registers
#define DMA_START_ADRESS(Address) IOWR_32DIRECT(NEW_COMPONENT_0_BASE, 0, Address)
#define DMA_LENGTH() IOWR_32DIRECT(NEW_COMPONENT_0_BASE, 4, 0x12C0) // Length = 4800
#define DMA_BURST() IOWR_32DIRECT(NEW_COMPONENT_0_BASE, 8, 0x8) // burst = 8
#define DMA_START() IOWR_32DIRECT(NEW_COMPONENT_0_BASE, 12, 0x1) // start = 1
#define DMA_RESTART() IOWR_32DIRECT(NEW_COMPONENT_0_BASE, 12, 0x2) // restart = 1
//#define LENGTH() IORD_32DIRECT(NEW_COMPONENT_0_BASE, 12)


void init_LCD();
void Test();
void write_cmd();
void Init_DMA ();

void test_DMA(int* addr0);

#endif /* FUNCTIONS_H_ */
