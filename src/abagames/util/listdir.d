module abagames.util.listdir;

version(WASM) {
  string[] listdir(string pathname) {
    if (pathname == "sounds/musics") {
      return ["tt1.ogg", "tt2.ogg", "tt3.ogg", "tt4.ogg"];
    }
    else if (pathname == "barrage") {
      return ["basic", "middle", "morph"];
    }
    else if (pathname == "barrage/basic") {
      return ["straight.xml"];
    }
    else if (pathname == "barrage/middle") {
      return [
        "35way.xml",
        "alt_nway.xml",
        "alt_sideshot.xml",
        "backword_spread.xml",
        "clow_rocket.xml",
        "diamondnway.xml",
        "fast_aim.xml",
        "forward_1way.xml",
        "grow.xml",
        "grow3way.xml",
        "nway.xml",
        "random_fire.xml",
        "spread2blt.xml",
        "squirt.xml",
      ];
    }
    else if (pathname == "barrage/morph") {
      return [
        "0to1.xml",
        "accel.xml",
        "accelshot.xml",
        "bar.xml",
        "divide.xml",
        "fast.xml",
        "fire_slowshot.xml",
        "slide.xml",
        "slowdown.xml",
        "speed_rnd.xml",
        "twin.xml",
        "wedge_half.xml",
        "wide.xml",
      ];
    }
    assert(false);
  }
}
else {
  string[] listdir(string pathname)
  {
    import std.algorithm;
    import std.array;
    import std.file;
    import std.path;

    return std.file.dirEntries(pathname, SpanMode.shallow)
      .map!(a => std.path.baseName(a.name))
      .array;
  }
}