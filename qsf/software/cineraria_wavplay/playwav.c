/* WAV�t�@�C���Đ����C�u����                               */
/*                                                         */
/*   The MIT License (MIT)                                 */
/*   Copyright (c) 2015 J-7SYSTEM WORKS LTD.               */
/*   http://opensource.org/licenses/mit-license.php        */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <system.h>
#include <io.h>
#include <sys/alt_irq.h>
#include "mmcfs/fatfs/ff.h"


// PCM�Đ��y���t�F������` 

#define pcm_samplefreq					(48000)
#define pcm_status_irqenable_mask		(1<<31)
#define pcm_status_play_mask			(1<<2)
#define pcm_status_irq_mask				(1<<1)
#define pcm_status_fiforst_mask			(1<<0)
#define pcm_status_irqenable			(1<<31)
#define pcm_status_irqdisable			(0<<31)
#define pcm_status_fiforst				(1<<0)
#define pcm_volume_muteenable			(1<<31)


// �Đ�FIFO���荞�ݏ��� 

static unsigned int g_wavsize = 0;		// �Đ�WAV�t�@�C���̃f�[�^�� 
static unsigned int g_playsize = 0;		// �Đ������f�[�^�� 
static FIL g_fsobj;						// �Đ����̃t�@�C����FatFS�I�u�W�F�N�g 
static alt_u32 g_datbuff[256];			// ���[�h�f�[�^�o�b�t�@ 

static void isr_handle_pcmfifofill(void *context)
{
	const alt_u32 dev_pcm = PCM_BASE;
	FRESULT res;
	UINT readsize;
	int i,n,eof=0,err=0;

	// ���荞�ݗv���}�X�N 
	IOWR(dev_pcm, 0, pcm_status_irqdisable);

	// �f�[�^�ǂݍ��� 
	n = (g_wavsize - g_playsize) >> 2;
	if (n <= 256) {									// �f�[�^�t�@�C���̍Ŋ� 
		eof = 1;
	} else {
		n = 256;
	}

	res = f_read(&g_fsobj, g_datbuff, (n<<2), &readsize);
	if (res != FR_OK || readsize < n) {				// �Đ����Ƀ��[�h�G���[ 
		err = 1;
		eof = 1;
	}

	// �f�[�^�]�� 
	if (!err) {
		for(i=0 ; i<n ; i++) IOWR(dev_pcm, 2, g_datbuff[i]);
		g_playsize += (n << 2);
	}

	// �t�@�C���N���[�Y 
	if (eof) {
		f_close(&g_fsobj);							// �Đ��I�� 
		g_wavsize = 0;
	} else {
		IOWR(dev_pcm, 0, pcm_status_irqenable);		// ���̊��荞�݃Z�b�g 
	}
}


// �y���t�F���������� 

int play_init(void)
{
	const alt_u32 dev_pcm = PCM_BASE;

	IOWR(dev_pcm, 1, 0);
	IOWR(dev_pcm, 0, pcm_status_irqdisable | pcm_status_fiforst);

	g_wavsize = 0;
	g_playsize = 0;

	alt_ic_isr_register(PCM_IRQ_INTERRUPT_CONTROLLER_ID, PCM_IRQ, isr_handle_pcmfifofill, NULL, 0);

	return 0;
}


// �Đ��X�e�[�^�X�擾 

int play_status(void)
{
	const alt_u32 dev_pcm = PCM_BASE;

	if ( IORD(dev_pcm, 0) & pcm_status_play_mask ) {
		return g_playsize;	// �Đ��� 
	} else {
		return 0;			// ��~�� 
	}
}

alt_u32 play_getbuffdata(int buffpos)
{
	return g_datbuff[buffpos & 0xff];
}


// ���ʐݒ� 

int play_setvol(int vol_l, int vol_r)
{
	const alt_u32 dev_pcm = PCM_BASE;

	if (vol_l > 0x4000) vol_l = 0x4000; else if (vol_l < 0) vol_l = 0;
	if (vol_r > 0x4000) vol_r = 0x4000; else if (vol_r < 0) vol_r = 0;

	IOWR(dev_pcm, 1, (vol_r<<16) | vol_l);

	return 0;
}


// �Đ���~ 

int play_stop(void)
{
	const alt_u32 dev_pcm = PCM_BASE;

	IOWR(dev_pcm, 0, pcm_status_irqdisable);

	if (g_wavsize) {
		f_close(&g_fsobj);
		g_wavsize = 0;
	}

	while( play_status() ) {}

	return 0;
}


// WAV�t�@�C���Đ��J�n 

int play_wav(const char *wavname)
{
	FIL fwav;
	FRESULT res;
	UINT readsize;
	unsigned char wavbuff[44];
	unsigned int wavfreq,wavsize;
	int stmono,samplebit,err;


	// WAV�t�@�C�����J�� 

	res = f_open(&fwav, wavname, FA_READ);

	if(res != FR_OK) {
		printf("[!] file open failure. (code:%d)\n", res);
		return -1;
	}


	// WAV�w�b�_�̉��(�ȈՔ�) 

	err = 1;
	res = f_read(&fwav, wavbuff, 44, &readsize);		// �w�b�_�ǂݏo�� 

	if (res == FR_OK && readsize == 44) {
		if (wavbuff[8]=='W' && wavbuff[9]=='A' && wavbuff[10]=='V' && wavbuff[11]=='E' && 	// WAV�`�����N 
				wavbuff[20] == 0x01) {	// ���j�APCM 

			stmono    =  wavbuff[22];		// ���m����=1,�X�e���I=2
			wavfreq   = (wavbuff[25]<< 8)| wavbuff[24];
			samplebit =  wavbuff[34];		// �T���v��������̃r�b�g�� 16/8
			wavsize   = (wavbuff[43]<<24)|(wavbuff[42]<<16)|(wavbuff[41]<< 8)| wavbuff[40];

			if (stmono == 2 && samplebit == 16 && wavfreq == pcm_samplefreq) err = 0;
		}
	}
	if (err) {
		printf("[!] '%s' is not supported.\n", wavname);
		f_close(&fwav);
		return -1;
	}


	// �Đ��J�n 

	printf("wavfile : %s\n   freq %dHz / time %dsec\n",wavname, wavfreq, wavsize/(wavfreq*4));

	if (g_wavsize) play_stop();			// �����Đ����̃t�@�C��������Β�~������ 
	g_fsobj = fwav;
	g_wavsize = wavsize;
	g_playsize = 0;

	isr_handle_pcmfifofill(NULL);		// �Đ�FIFO���荞�݂��L�b�N 

	return wavsize;						// WAV�t�@�C���T�C�Y��Ԃ� 
}


