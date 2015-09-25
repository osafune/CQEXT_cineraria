DE0/DE0-nano拡張ボード用 サンプル
=================================

DE0-CVボードとDE0/DE0-nano拡張ボードでWAVファイルを再生するサンプルデモです。


対象ボード
==========

- Terasic DE0-CV
- CQ出版社 DE0/DE0-nano拡張ボード


準備と実行方法
==============

1. DE0-CVのGPIO1にDE0/DE0-nano拡張基板を接続します。

2. DE0/DE0-nano拡張基板のHDMI出力またはDE0-CV本体のVGA出力をPCモニタへDE0/DE0-nano拡張基板のLINE出力をアンプスピーカーへ接続します。

3. DE0-CVとPCをUSBケーブルで接続します。このとき、他のUSB-Blaster、ボード類はすべて外しておきます。

4. misroSDカードをDE0-CVのスロットに装着します。

5. NiosII Command Shellを立ち上げます。

6. do_wavplay.shに実行パーミッションが与えられていない場合は `$ chmod a+x do_wavplay/sh` としてパーミッションを追加しておきます。

7. DE0-CVの電源を入れます。DE0-CVボードのSW10はRUN側にセットします。

8. NiosII Command Shellでdo_wavplay.shのあるフォルダへ移動します。

9. do_wavplay.shを実行します。sofファイルとelfファイルがダウンロードされ、de0/cvフォルダのwavファイルを連続再生します。


操作
====

- FPGA_RESETボタン
システムリセットを行います。再度実行する場合は手順9を行います。

- KEY0ボタン
次のwavファイルへ移動します。

それ以外のボタン、スイッチは使用しません。


再生できるファイル
==================

壁紙は`wall.bmp`という名前のBMPファイルです。サイズは640x480、フォーマットは32bpp/24bppの画像を`de0cv`フォルダ以下に置きます。

オーディオファイルは任意名のWAVファイルです。48kサンプリング、16ビットデータ、ステレオのWAVファイルを`de0cv`フォルダ以下から検索して連続再生します。


ライセンス
=========

特に注記のないファイルはMIT Licenseで扱われる。
[MIT License](http://opensource.org/licenses/mit-license.php)
