/* WAV�t�@�C���Đ� */

#include <alt_types.h>

// �y���t�F���������� 
int play_init(void);

// �Đ��X�e�[�^�X�擾 
int play_status(void);
alt_u32 play_getbuffdata(int buffpos);

// �Đ���~ 
int play_stop(void);

// WAV�t�@�C���Đ��J�n 
int play_wav(const char *wavname);

// ���ʐݒ� 
int play_setvol(int vol_l, int vol_r);

