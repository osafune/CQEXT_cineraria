/* DE0/DE0-nano�g����T���v���FWAV�t�@�C���v���C���[     */
/*                                                         */
/*   The MIT License (MIT)                                 */
/*   Copyright (c) 2015 J-7SYSTEM WORKS LTD.               */
/*   http://opensource.org/licenses/mit-license.php        */

// usage:
//  SD�J�[�h�� /de0cv/wall.bmp ��ǎ��ɕ\������B 
//  BMP�t�@�C����640x480�s�N�Z����32bpp�܂���24bpp�J���[�ɑΉ��B 
//  SD�J�[�h�� /de0cv �t�H���_�ȉ���wav�t�@�C�������ɍĐ�����B 
//  WAV�t�@�C����16bit�f�[�^�A2�`���l���X�e���I�A48kHz�T���v�����O�̂ݑΉ��B 

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


// �t�@�C�����i�[����Ă���f�B���N�g���p�X 

#define BMPFILE_DIR		"/de0cv"
#define WAVFILE_DIR		"/de0cv"


// WAV�v���C���[ 

int main(void)
{
	alt_u16 *pfb, *pbuff;
	char *fn;
	char playfile[256 + sizeof(WAVFILE_DIR) + 1];


	// �V�X�e�������� 

	nd_GsVgaInit();
	play_init();
	mmcfs_setup();


	// VGA������ 

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


	// ��ʏ����� 

	disp7seg();
	play_setvol(0x4000,0x4000);

	loadbmp(BMPFILE_DIR "/wall.bmp", pfb);

	pbuff = (alt_u16 *)malloc(640*176*2);
	drawwave_init(pbuff, 480-176);


	// wav�t�@�C���̘A���Đ� 

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


	// �I������ 

	nd_GsVgaScanOff();
	free(pbuff);
	alt_uncached_free(pfb);

	return 0;
}

