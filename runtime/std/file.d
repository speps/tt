module std.file;

import wasm;

ubyte[] read(string path) {
  if (path == "sounds/chunks/boss_dest.wav") return cast(ubyte[]) import("sounds/chunks/boss_dest.wav");
  if (path == "sounds/chunks/charge.wav") return cast(ubyte[]) import("sounds/chunks/charge.wav");
  if (path == "sounds/chunks/charge_shot.wav") return cast(ubyte[]) import("sounds/chunks/charge_shot.wav");
  if (path == "sounds/chunks/extend.wav") return cast(ubyte[]) import("sounds/chunks/extend.wav");
  if (path == "sounds/chunks/hit.wav") return cast(ubyte[]) import("sounds/chunks/hit.wav");
  if (path == "sounds/chunks/middle_dest.wav") return cast(ubyte[]) import("sounds/chunks/middle_dest.wav");
  if (path == "sounds/chunks/myship_dest.wav") return cast(ubyte[]) import("sounds/chunks/myship_dest.wav");
  if (path == "sounds/chunks/shot.wav") return cast(ubyte[]) import("sounds/chunks/shot.wav");
  if (path == "sounds/chunks/small_dest.wav") return cast(ubyte[]) import("sounds/chunks/small_dest.wav");
  if (path == "sounds/chunks/timeup_beep.wav") return cast(ubyte[]) import("sounds/chunks/timeup_beep.wav");
  if (path == "sounds/musics/tt1.ogg") return cast(ubyte[]) import("sounds/musics/tt1.ogg");
  if (path == "sounds/musics/tt2.ogg") return cast(ubyte[]) import("sounds/musics/tt2.ogg");
  if (path == "sounds/musics/tt3.ogg") return cast(ubyte[]) import("sounds/musics/tt3.ogg");
  if (path == "sounds/musics/tt4.ogg") return cast(ubyte[]) import("sounds/musics/tt4.ogg");
  size_t size = 0;
  if (wasm.readFileSize(path, &size)) {
    ubyte[] buffer = new ubyte[size];
    wasm.readFile(path, buffer);
    return buffer;
  }
  return null;
}

string readText(string path) {
  if (path == "barrage/basic/straight.xml") return import("barrage/basic/straight.xml");
  if (path == "barrage/middle/35way.xml") return import("barrage/middle/35way.xml");
  if (path == "barrage/middle/alt_nway.xml") return import("barrage/middle/alt_nway.xml");
  if (path == "barrage/middle/alt_sideshot.xml") return import("barrage/middle/alt_sideshot.xml");
  if (path == "barrage/middle/backword_spread.xml") return import("barrage/middle/backword_spread.xml");
  if (path == "barrage/middle/clow_rocket.xml") return import("barrage/middle/clow_rocket.xml");
  if (path == "barrage/middle/diamondnway.xml") return import("barrage/middle/diamondnway.xml");
  if (path == "barrage/middle/fast_aim.xml") return import("barrage/middle/fast_aim.xml");
  if (path == "barrage/middle/forward_1way.xml") return import("barrage/middle/forward_1way.xml");
  if (path == "barrage/middle/grow.xml") return import("barrage/middle/grow.xml");
  if (path == "barrage/middle/grow3way.xml") return import("barrage/middle/grow3way.xml");
  if (path == "barrage/middle/nway.xml") return import("barrage/middle/nway.xml");
  if (path == "barrage/middle/random_fire.xml") return import("barrage/middle/random_fire.xml");
  if (path == "barrage/middle/spread2blt.xml") return import("barrage/middle/spread2blt.xml");
  if (path == "barrage/middle/squirt.xml") return import("barrage/middle/squirt.xml");
  if (path == "barrage/morph/0to1.xml") return import("barrage/morph/0to1.xml");
  if (path == "barrage/morph/accel.xml") return import("barrage/morph/accel.xml");
  if (path == "barrage/morph/accelshot.xml") return import("barrage/morph/accelshot.xml");
  if (path == "barrage/morph/bar.xml") return import("barrage/morph/bar.xml");
  if (path == "barrage/morph/divide.xml") return import("barrage/morph/divide.xml");
  if (path == "barrage/morph/fast.xml") return import("barrage/morph/fast.xml");
  if (path == "barrage/morph/fire_slowshot.xml") return import("barrage/morph/fire_slowshot.xml");
  if (path == "barrage/morph/slide.xml") return import("barrage/morph/slide.xml");
  if (path == "barrage/morph/slowdown.xml") return import("barrage/morph/slowdown.xml");
  if (path == "barrage/morph/speed_rnd.xml") return import("barrage/morph/speed_rnd.xml");
  if (path == "barrage/morph/twin.xml") return import("barrage/morph/twin.xml");
  if (path == "barrage/morph/wedge_half.xml") return import("barrage/morph/wedge_half.xml");
  if (path == "barrage/morph/wide.xml") return import("barrage/morph/wide.xml");
  assert(false, "unknown file: " ~ path);
}

void write(string path, const(ubyte[]) data) {
  wasm.writeFile(path, data);
}
