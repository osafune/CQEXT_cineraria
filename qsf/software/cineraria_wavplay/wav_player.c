/* DE0/DE0-nano拡張基板サンプル：WAVファイルプレイヤー     */
/*                                                         */
/*   The MIT License (MIT)                                 */
/*   Copyright (c) 2015 J-7SYSTEM WORKS LTD.               */
/*   http://opensource.org/licenses/mit-license.php        */

// usage:
//  SDカードの /de0cv/wall.bmp を壁紙に表示する。 
//  BMPファイルは640x480ピクセルの32bppまたは24bppカラーに対応。 
//  SDカードの /de0cv フォルダ以下のwavファイルを順に再生する。 
//  WAVファイルは16bitデータ、2チャネルステレオ、48kHzサンプリングのみ対応。 

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include <system.h>
#include <io.h>
#include <sys/alt_cache.h>

#include "mmcfs/mmcfs.h"
#include "nd_lib/nd_egl.h"
#include "loadbmp.h"
#include "playwav.h"
#include "disp7seg.h"
#include "drawwave.h"
#include "getfilename.h"


// ファイルが格納されているディレクトリパス 

#define BMPFILE_DIR		"/de0cv"
#define WAVFILE_DIR		"/de0cv"


// WAVプレイヤー 

int main(void)
{
	alt_u16 *pfb, *pbuff;
	char *fn;
	char playfile[256 + sizeof(WAVFILE_DIR) + 1];


	// システム初期化 

	nd_GsVgaInit();
	play_init();
	mmcfs_setup();


	// VGA初期化 

	pfb = (alt_u16 *)alt_uncached_malloc(na_VRAM_size);
	if (pfb == NULL) {
		printf("[!] Framebuffer allocation failure.\n");
		return -1;
	}

	nd_GsVgaSetBuffer((nd_u32)pfb);
	nd_GsEglPage((nd_u32)pfb, (nd_u32)pfb, 0);

	nd_color(nd_COLORGRAY, 0, 256);
	nd_boxfill(0, 0, window_xmax, window_ymax);

	nd_GsVgaScanOn();


	// 画面初期化 

	disp7seg();
	play_setvol(0x4000,0x4000);

	loadbmp(BMPFILE_DIR "/wall.bmp", pfb);

	pbuff = (alt_u16 *)malloc(640*176*2);
	drawwave_init(pbuff, 480-176);


	// wavファイルの連続再生 

	while(1) {
		fn = get_wavfilename();
		if (fn == NULL) {
			if ( open_wavdir(WAVFILE_DIR) ) {
				printf("[!] Directory open fail.\n");
				break;
			}
			continue;
		}

		strcpy(playfile, WAVFILE_DIR "/");
		strcat(playfile, fn);
		play_wav(playfile);

		while( play_status() ) {
			nd_wait_vsync();
			drawwave();

			if ( !(IORD(PSW_BASE, 0) & (1<<0)) ) {
				play_stop();
				while( !(IORD(PSW_BASE, 0) & (1<<0)) ) {}
			}
		}
	}


	// 終了処理 

	nd_GsVgaScanOff();
	free(pbuff);
	alt_uncached_free(pfb);

	return 0;
}

