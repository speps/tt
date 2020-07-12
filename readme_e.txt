Torus Trooper  readme.txt
for Windows98/2000/XP(OpenGL required)
ver. 0.22
(C) Kenta Cho

Speed! More speed!
Speeding ship sailing through barrage, 'Torus Trooper'.


- How to install.

Unpack tt0_22.zip, and execute 'tt.exe'.


- How to operate.

-- Movement     Arrow / Num / [WASD]   / Joystick

Hold an up key to increase speed.

-- Shot         [Z][L-Ctrl][.]         / Trigger 1, 4, 5, 8

Hold a shot key to open automatic fire.

-- Charge shot  [X][L-Alt][L-Shift][/] / Trigger 2, 3, 6, 7

Hold a charge shot key to charge energy.
A charge shot is released when you release a key.
A charge shot penetrates enemies and wipes out bullets.
A score multiplier is increased according to a number of
destroying enemies and bullets. 
A charge shot acts as a regenerative break.

-- Pause        [P]


- How to play.

At the title screen, select a grade(Normal, Hard, Extreme) and a starting level.
Press a shot button to start a game. Press an escape key to quit a game.

Drive a ship forward and destroy enemies. When time runs out, game is over.

Remaining time is displayed at the left up corner. 
Remaining time varies according to events:

-- Ship was destroyed(-15 sec.)

You ship is destroyed when it is hit by a bullet.

-- Bonus time(+15 sec.)

You can earn bonus time when you reach a certain score.
The point you have to get is displayed at the right up corner.

-- Destroy the boss(+30 or 45 sec.)

The boss enemies appear when you destroy or overtake
a certain number(displayed at the left down corner) of enemies,
and you can earn bonus time by destroying them.


- Replay mode

At the title screen, press a charge shot key to see a replay of
your last game. Press a left/right key to change a view and
an up/down key to change displayed/undisplayed of a status display.


- Options

These options are available:

 -brightness n  Set the brightness of the screen.(n = 0 - 100, default = 100)
 -luminosity n  Set the luminous intensity.(n = 0 - 100, default = 0)
 -res x y       Set ths screen resolution to (x, y).
 -nosound       Stop the sound.
 -window        Launch the game in the window, not use the full-screen.
 -reverse       Reverse a shot key and a charge shot key.


- Comments

If you have any comments, please mail to cs8k-cyu@asahi-net.or.jp


- Webpage

Torus Trooper webpage:
http://www.asahi-net.or.jp/~cs8k-cyu/windows/tt_e.html


- Acknowledgement

Torus Trooper is written in the D Programming Language(ver. 0.110).
 D Programming Language
 http://www.digitalmars.com/d/index.html

libBulletML is used to parse BulletML files.
 libBulletML
 http://shinh.skr.jp/libbulletml/index_en.html

Simple DirectMedia Layer is used for media handling.
 Simple DirectMedia Layer
 http://www.libsdl.org

SDL_mixer and Ogg Vorbis CODEC are used for playing BGMs/SEs.
 SDL_mixer 1.2
 http://www.libsdl.org/projects/SDL_mixer/
 Vorbis.com
 http://www.vorbis.com

D Header files at D - porting are for use with OpenGL, SDL and SDL_mixer.
 D - porting
 http://shinh.skr.jp/d/porting.html

Mersenne Twister is used for creating a random number.
 Mersenne Twister: A random number generator (since 1997/10)
 http://www.math.sci.hiroshima-u.ac.jp/~m-mat/MT/emt.html


- History

2005  1/ 9  ver. 0.22
            Fixed problems when my ship overpassed a boss enemy.
            Fixed problems a replay directory was not unpacked.
2005  1/ 2  ver. 0.21
            Fixed problems when saving a replay data fails.
2005  1/ 1  ver. 0.2
            Added a replay mode.
            Added a torus color change feature(thanks to h_sakurai).
            Added a regenerative break feature.
            Fixed incorrect handling of my ship on edge of course.
            Fixed problems with option args.
            Adjusted a difficulty in normal and hard mode.
2004 11/13  ver. 0.1
            First released version.


-- License

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
