/* 7セグメントLED表示ライブラリ                            */
/*                                                         */
/*   The MIT License (MIT)                                 */
/*   Copyright (c) 2015 J-7SYSTEM WORKS LTD.               */
/*   http://opensource.org/licenses/mit-license.php        */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <system.h>
#include <io.h>
#include <sys/alt_alarm.h>
#include "playwav.h"

#define led7seg_enc(a,b,c,d,e,f,g)	((((a)&1)<<0)|(((b)&1)<<1)|(((c)&1)<<2)|(((d)&1)<<3)|(((e)&1)<<4)|(((f)&1)<<5)|(((g)&1)<<6))


// アラームハンドラ 

static alt_alarm hal_alarm;


// 1/32秒毎に呼び出されるコールバック関数 

alt_u32 hal_alarm_callback(void *context)
{
	const alt_u32 dev_7seg0 = LED_7SEG_0_BASE;
	const alt_u32 dev_7seg1 = LED_7SEG_1_BASE;
	const alt_u32 dev_7seg2 = LED_7SEG_2_BASE;

	const int ptn_disc[4] = {
				((1<<0)|(1<<1)) | (((1<<3)|(1<<4))<<8),		// a0,b0, d1,e1
				((1<<1)|(1<<2)) | (((1<<4)|(1<<5))<<8),		// b0,c0, e1,f1
				((1<<2)|(1<<3)) | (((1<<5)|(1<<0))<<8),		// c0,d0, f1,a1
				((1<<3)|(1<<0)) | (((1<<0)|(1<<3))<<8) 		// d0,a0, a1,d1
			};
	const int ptn_number[11] = {
				led7seg_enc(1,1,1,1,1,1,0),		// 0:a,b,c,d,e,f
				led7seg_enc(0,1,1,0,0,0,0),		// 1:  b,c
				led7seg_enc(1,1,0,1,1,0,1),		// 2:a,b,  d,e,  g
				led7seg_enc(1,1,1,1,0,0,1),		// 3:a,b,c,d,    g
				led7seg_enc(0,1,1,0,0,1,1),		// 4:  b,c,    f,g
				led7seg_enc(1,0,1,1,0,1,1),		// 5:a,  c,d,  f,g
				led7seg_enc(1,0,1,1,1,1,1),		// 6:a,  c,d,e,f,g
				led7seg_enc(1,1,1,0,0,1,0),		// 7:a,b,c,    f
				led7seg_enc(1,1,1,1,1,1,1),		// 8:a,b,c,d,e,f,g
				led7seg_enc(1,1,1,1,0,1,1),		// 9:a,b,c,d,  f,g
				led7seg_enc(0,0,0,0,0,0,0)		// 10:dimmer
			};

	int point,sec,min,min1,min10;
	static int disccnt = 0;

	point = play_status() / (48000*4);
	if (point) {
		if (point > 99*60+59) point = 99*60+59;

		sec = point % 60;
		min = point / 60;
		min1 = min % 10;
		min10 = min / 10;
		if (min10 == 0) min10 = 10;

		IOWR(dev_7seg0, 0, ~((ptn_number[sec/10]<<8) | ptn_number[sec%10]) );
		IOWR(dev_7seg1, 0, ~((ptn_number[min10]<<8) | ptn_number[min1]) );
		IOWR(dev_7seg2, 0, ~ptn_disc[disccnt>>2] );
		disccnt = (disccnt+1) & 15;

	} else {
		IOWR(dev_7seg0, 0, ~((1<<6)|(1<<(6+8))) );
		IOWR(dev_7seg1, 0, ~((1<<6)|(1<<(6+8))) );
		IOWR(dev_7seg2, 0, ~ptn_disc[disccnt>>2] );

	}

	return alt_ticks_per_second()/32;
}


// LED表示開始 

int disp7seg(void)
{
	return alt_alarm_start(&hal_alarm, alt_ticks_per_second()/32, hal_alarm_callback, NULL);
}

