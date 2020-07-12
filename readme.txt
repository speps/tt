Torus Trooper  readme.txt
for Windows98/2000/XP(要OpenGL)
ver. 0.22
(C) Kenta Cho

速さを、もっと速さを。
弾幕の波間を疾走する、Torus Trooper。


○ インストール方法

tt0_22.zipを適当なフォルダに展開してください。
その後、'tt.exe'を実行してください。


○ 操作方法

- 自機の移動        矢印キー, テンキー, [WASD] / ジョイステック
 
上移動キーを押しっぱなしにすると、自機のスピードが上がります。

- ショット          [Z][左Ctrl][.]             / トリガ1, 4, 5, 8

押しっぱなしで連射されます。

- チャージショット  [X][左Alt][左Shift][/]     / トリガ2, 3, 6, 7
 
チャージショットキーを押しっぱなしにするとエネルギーが貯まります。
チャージショットはキーを放すと発射されます。
チャージショットは敵を貫通し、敵弾を消し去ります。
スコア倍率は破壊した敵および敵弾の数に応じて上昇します。
チャージショットは回生ブレーキとして働きます。

- ポーズ            [P]


○ 遊び方

タイトル画面でゲームのグレード(Normal, Hard, Extreme)と開始するレベルを
選択してください。ショットキーを押すとゲームを開始します。
エスケープキーを押すとゲームを終了します。

自機を操作し敵を破壊してください。タイムがなくなるとゲームオーバーです。

残りタイムは左上に表示されます。残りタイムは被弾したり一定スコアに
到達することで変化します。

- 自機破壊（-15秒）

自機は敵弾に当たると破壊されます。

- ボーナスタイム（+15秒）

一定のスコアに到達するとボーナスタイムが加算されます。
獲得に必要なスコアは右上に表示されます。

- ボス破壊（+30または45秒）

一定数（左下に表示）の敵を破壊もしくは追い抜くとボスが出現します。
ボスを破壊するとボーナスタイムを獲得できます。


○ リプレイモード

タイトル画面でチャージショットキーを押すと最後のプレイのリプレイを
見ることができます。左右キーで視点の変更、上下キーでステータスの
表示/非表示の切り替えができます。


○ オプション

以下のオプションが指定できます。

 -brightness n  画面の明るさを指定します(n = 0 - 100, デフォルト100)
 -luminosity n  発光エフェクトの強さを指定します(n = 0 - 100, デフォルト0)
 -res x y       画面の解像度を(x, y)にします。
 -nosound       音を出力しません。
 -window        ウィンドウモードで起動します。
 -reverse       ショットとチャージショットのキーを入れ替えます。


○ ご意見、ご感想

コメントなどは、cs8k-cyu@asahi-net.or.jp までお願いします。


○ ウェブページ

Torus Trooper webpage:
http://www.asahi-net.or.jp/~cs8k-cyu/windows/tt.html


○ 謝辞

Torus TrooperはD言語(ver. 0.110)で書かれています。
 プログラミング言語D
 http://www.kmonos.net/alang/d/

BulletMLファイルのパースにlibBulletMLを利用しています。
 libBulletML
 http://shinh.skr.jp/libbulletml/

メディアハンドリングにSimple DirectMedia Layerを利用しています。
 Simple DirectMedia Layer
 http://www.libsdl.org/

BGMとSEの出力にSDL_mixerとOgg Vorbis CODECを利用しています。
 SDL_mixer 1.2
 http://www.libsdl.org/projects/SDL_mixer/
 Vorbis.com
 http://www.vorbis.com/

D - portingのOpenGL, SDL, SDL_mixerヘッダファイルを利用しています。
 D - porting
 http://shinh.skr.jp/d/porting.html

乱数発生器にMersenne Twisterを利用しています。
 Mersenne Twister: A random number generator (since 1997/10)
 http://www.math.sci.hiroshima-u.ac.jp/~m-mat/MT/mt.html


○ ヒストリ

2005  1/ 9  ver. 0.22
            ボスを追い抜いたときの問題修正。
            replayディレクトリが展開されない問題修正。
2005  1/ 2  ver. 0.21
            リプレイデータの保存に失敗したときの問題修正。
2005  1/ 1  ver. 0.2
            リプレイモード追加。
            トーラスカラー変更機能追加(thanks to h_sakurai)。
            回生ブレーキ追加。
            コース端での不正な自機ハンドリングの修正。
            オプション読み込みの問題修正。
            ノーマルおよびハードモードの難易度調整。
2004 11/13  ver. 0.1
            最初のリリースバージョン。


○ ライセンス

Torus TrooperはBSDスタイルライセンスのもと配布されます。

License
-------

Copyright 2004 Kenta Cho. All rights reserved. 

Redistribution and use in source and binary forms, 
with or without modification, are permitted provided that 
the following conditions are met: 

 1. Redistributions of source code must retain the above copyright notice, 
    this list of conditions and the following disclaimer. 

 2. Redistributions in binary form must reproduce the above copyright notice, 
    this list of conditions and the following disclaimer in the documentation 
    and/or other materials provided with the distribution. 

THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, 
INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND 
FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL 
THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; 
OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR 
OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF 
ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. 
