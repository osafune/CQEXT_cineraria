/* WAV�t�@�C�������擾                                     */
/*                                                         */
/*   The MIT License (MIT)                                 */
/*   Copyright (c) 2015 J-7SYSTEM WORKS LTD.               */
/*   http://opensource.org/licenses/mit-license.php        */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "mmcfs/fatfs/ff.h"


// �f�B���N�g���I�u�W�F�N�g 

static DIR fatfs_dir;					// FatFs�f�B���N�g���I�u�W�F�N�g 
static FILINFO fatfs_fno;				// FatFs�t�@�C�����I�u�W�F�N�g 
static char fslfn[_MAX_LFN + 1];		// �����O�t�@�C���l�[���i�[�p 


// �g���q��".WAV"���ǂ������ׂ� 

static int check_extwav(const char *fn)
{
	int i;

	i = strlen(fn);
	if (i == 0) return 0;

	fn += i-1;		// ��ԍŌ�̕����ֈړ� 

	if ( *fn != 'v' && *fn != 'V') return 0;
	fn--;
	if ( *fn != 'a' && *fn != 'A') return 0;
	fn--;
	if ( *fn != 'w' && *fn != 'W') return 0;
	fn--;
	if ( *fn != '.') return 0;

	return 1;
}


// �f�B���N�g���̃I�[�v�� 

int open_wavdir(const char *path)
{
	FRESULT res;

	fatfs_fno.lfname = fslfn;
	fatfs_fno.lfsize = sizeof(fslfn);

	res = f_opendir(&fatfs_dir, path);
	if (res != FR_OK) return -1;

	return 0;
}


// �f�B���N�g����WAV�t�@�C�����P�擾 

char *get_wavfilename(void)
{
	FRESULT res;
	char *fn = NULL;

	for(;;) {
		res = f_readdir(&fatfs_dir, &fatfs_fno);
		if (res != FR_OK || fatfs_fno.fname[0] == 0) {	// �G���[�܂��͂����t�@�C�����Ȃ� 
			fn = NULL;
			break;
		}

		if (fatfs_fno.fname[0] == '.') continue;		// �h�b�g�G���g���̏ꍇ�̓��g���C 

		if (fatfs_fno.fattrib & AM_DIR) continue;		// �f�B���N�g���̏ꍇ�����g���C 

		fn = *fatfs_fno.lfname ? fatfs_fno.lfname : fatfs_fno.fname;
		if ( !check_extwav(fn) )	continue;			// .wav�t�@�C���łȂ���΃��g���C 

		break;
	}

	return fn;
}


