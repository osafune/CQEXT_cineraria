/* WAVîgå`ï`âÊ                                             */
/*                                                         */
/*   The MIT License (MIT)                                 */
/*   Copyright (c) 2015 J-7SYSTEM WORKS LTD.               */
/*   http://opensource.org/licenses/mit-license.php        */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <system.h>
#include <io.h>
#include "nd_lib/nd_egl.h"
#include "playwav.h"


// ì‡ïîèàóùóp 

static alt_u16 *g_pbuff;
static int g_ypos;

static void sub_lineblend(alt_u16 *ppix, int c)
{
	int x, r,g,b;

	for(x=0 ; x<640 ; x++,ppix++) {
		r = (get_red  (*ppix) * c) >> 8;
		g = (get_green(*ppix) * c) >> 8;
		b = (get_blue (*ppix) * c) >> 8;
		*ppix = set_pixel(r, g, b);
	}
}


// ï`âÊÉEÉBÉìÉhÉEèâä˙âª 

void drawwave_init(alt_u16 *pbuff, int ypos)
{
	const int ysize = 176;
	int i,x,y,c;
	alt_u32 *pd, *ps;
	g_pbuff = pbuff;
	g_ypos = ypos;

	pd = (alt_u32 *)g_pbuff;
	for(y=ypos ; y<ypos+ysize ; y++) {
		ps = (alt_u32 *)(nd_GsEglDrawBuffer + y*na_VRAM_linesize);
		for(x=0 ; x<640/2 ; x++) *pd++ = *ps++;
	}

	for(i=0 ; i<8 ; i++) {
		c = 256-i*16;
		sub_lineblend(g_pbuff + i*640, c);
		sub_lineblend(g_pbuff + (ysize-1-i)*640, c);
	}
	for(i=0 ; i<80 ; i++) {
		c = 128-i;
		sub_lineblend(g_pbuff + (i+8)*640, c);
		sub_lineblend(g_pbuff + (ysize-1-i-8)*640, c);
	}
}


// îgå`ï`âÊ 

void drawwave(void)
{
	static unsigned char dbuff[160][640];
	int x,y,a, r,g,b, ypos;
	int ldata,rdata;
	alt_u32 buffdata;
	alt_u16 *ppix, *pfb;
	alt_u32 *pd, *ps;


	for(y=0 ; y<=79-1 ; y++) {
		for(x=0 ; x<640 ; x++) {
			a = (dbuff[y][x] >> 1) + (dbuff[y+1][x] >> 1) - 6;
			if (a < 0) a = 0; else if (a > 255) a = 255;
			dbuff[y][x] = a;
		}
	}
	for(y=159 ; y>=80-1 ; y--) {
		for(x=0 ; x<640 ; x++) {
			a = (dbuff[y][x] >> 1) + (dbuff[y-1][x] >> 1) - 6;
			if (a < 0) a = 0; else if (a > 255) a = 255;
			dbuff[y][x]= a;
		}
	}
	for(x=0 ; x<640 ; x++) {
		buffdata = play_getbuffdata(x/3);

		ldata = (alt_16)(buffdata & 0xffff);
		rdata = (alt_16)((buffdata>>16)& 0xffff);
		if (ldata < 0) ldata = -ldata;
		if (rdata < 0) rdata = -rdata;

		dbuff[79-(ldata>>9)][x] = (ldata > 128)? (ldata>>9)+128+64 : ldata;
		dbuff[80+(rdata>>9)][x] = (rdata > 128)? (rdata>>9)+128+64 : rdata;
	}


	ypos = g_ypos;
	ps = (alt_u32 *)(g_pbuff + 0*640);
	for(y=ypos ; y<ypos+8 ; y++) {
		pd = (alt_u32 *)(nd_GsEglDrawBuffer + y*na_VRAM_linesize);
		for(x=0 ; x<640/2 ; x++) *pd++ = *ps++;
	}

	ypos = g_ypos + 8;
	ppix = g_pbuff + 8*640;
	for(y=0 ; y<160 ; y++) {
		pfb = (alt_u16 *)(nd_GsEglDrawBuffer + (ypos+y)*na_VRAM_linesize);

		for(x=0 ; x<640 ; x++,ppix++) {
			r = get_red  (*ppix) + dbuff[y][x];
			g = get_green(*ppix) + dbuff[y][x];
			b = get_blue (*ppix) + dbuff[y][x];
			if (r > 255) r = 255;
			if (g > 255) g = 255;
			if (b > 255) b = 255;

			*pfb++ = set_pixel(r, g, b);
		}
	}

	ypos = g_ypos + 168;
	ps = (alt_u32 *)(g_pbuff + 168*640);
	for(y=ypos ; y<ypos+8 ; y++) {
		pd = (alt_u32 *)(nd_GsEglDrawBuffer + y*na_VRAM_linesize);
		for(x=0 ; x<640/2 ; x++) *pd++ = *ps++;
	}

}
