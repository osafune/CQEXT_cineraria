/* BMPファイルロードライブラリ                             */
/*                                                         */
/*   The MIT License (MIT)                                 */
/*   Copyright (c) 2015 J-7SYSTEM WORKS LTD.               */
/*   http://opensource.org/licenses/mit-license.php        */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <system.h>
#include <alt_types.h>
#include "nd_lib/nd_egl.h"
#include "mmcfs/fatfs/ff.h"


// 指定のBMPファイルをフレームバッファに読み込む 

int loadbmp(const char *bmpname, alt_u16 *pFrameBuffer)
{
	FIL fbmp;
	FRESULT res;
	UINT readsize;

	unsigned char bmp_h[54];
	int xsize,ysize,bpp,line;
	int x,y,x_offs,y_offs,width,height;
	unsigned char *pbmp, bmp_pixel[4*window_xsize];
	alt_u16 *ppix,*pline;


	// BMPファイルを開く 

	res = f_open(&fbmp, bmpname, FA_READ);

	if (res != FR_OK) {
		printf("[!] file open failure. (code:%d)\n", res);
		return -1;
	}


	// ファイルヘッダの読み出し 

	res = f_read(&fbmp, bmp_h, 54, &readsize);		// ヘッダ読み出し 
	if (res == FR_OK && readsize == 54) {
		if ((bmp_h[0x00] == 'B') && (bmp_h[0x01] == 'M')) {

			bpp = bmp_h[0x1c];
			if ( !(bpp==32 || bpp==24 || bpp==16) ) {
				printf("[!] This color type cannot display.\n");
				f_close(&fbmp);
				return -2;
			}

			xsize = (bmp_h[0x13] << 8) | bmp_h[0x12];
			ysize = (bmp_h[0x17] << 8) | bmp_h[0x16];

			line = (xsize * bpp) / 8;
			if ((line % 4) != 0) line = ((line / 4) + 1) * 4;

		} else {
			printf("[!] '%s' is not supported.\n", bmpname);
			f_close(&fbmp);
			return -3;
		}
	}

	// BMP画像データをロード 

	printf("bmpfile : %s\n   %d x %d pix, %dbpp, %dbyte/line\n",bmpname,xsize,ysize,bpp,line);

	x_offs = 0;
	y_offs = 0;
	if (xsize+x_offs > window_xsize) width  = window_xsize-x_offs; else width  = xsize;
	if (ysize+y_offs > window_ysize) height = window_ysize-y_offs; else height = ysize;

	pline = pFrameBuffer + (y_offs * (na_VRAM_linesize/2));

	for(y=0 ; y<height ; y++) {
		f_lseek(&fbmp, 54 + line*(ysize-(y+1)));			// ファイルポインタを行の先頭へ移動 
		ppix = pline;										// ピクセルポインタをラインの先頭へ移動 
		pbmp = bmp_pixel;

		if (bpp == 32) {
			res = f_read(&fbmp, bmp_pixel, width*4, &readsize);
			if (res != FR_OK) break;
			for(x=0 ; x<width ; x++,pbmp+=4) *ppix++ = set_pixel(*(pbmp+2), *(pbmp+1), *(pbmp+0));

		} else if(bpp == 24) {
			res = f_read(&fbmp, bmp_pixel, width*3, &readsize);
			if (res != FR_OK) break;
			for(x=0 ; x<width ; x++,pbmp+=3) *ppix++ = set_pixel(*(pbmp+2), *(pbmp+1), *(pbmp+0));

		} else if(bpp == 16) {
			res = f_read(&fbmp, bmp_pixel, width*2, &readsize);
			if (res != FR_OK) break;
			for(x=0 ; x<width ; x++,pbmp+=2) *ppix++ = (*(pbmp+1)<<8)|(*(pbmp+0));
		}

		pline += (na_VRAM_linesize/2);
	}

	f_close(&fbmp);

	return 0;
}

