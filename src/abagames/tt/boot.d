/*
 * $Id: boot.d,v 1.2 2005/01/01 12:40:27 kenta Exp $
 *
 * Copyright 2004 Kenta Cho. Some rights reserved.
 */
module abagames.tt.boot;

import abagames.util.conv;
import abagames.util.logger;
import abagames.util.sdl.mainloop;
import abagames.util.sdl.pad;
import abagames.util.sdl.input;
import abagames.util.sdl.recordablepad;
import abagames.util.sdl.sound;
import abagames.tt.screen;
import abagames.tt.gamemanager;
import abagames.tt.prefmanager;

import std.stdio;
import abagames.util.bulletml.xml;

/**
 * Boot the game.
 */
private:
Screen screen;
Pad pad;
GameManager gameManager;
PrefManager prefManager;
MainLoop mainLoop;

version(WASM) {
  export extern (C) bool _loop() {
    return mainLoop.innerLoop(1);
  }
}

public int main(string[] args) {
  screen = new Screen;
  pad = new RecordablePad(new InputBackendImpl());
  gameManager = new GameManager;
  prefManager = new PrefManager;
  mainLoop = new MainLoop(screen, pad, gameManager, prefManager);
  version(WASM) {
    mainLoop.loopStart();
  } else {
    try {
      parseArgs(args);
    } catch (Exception e) {
      return 1;
    }
    try {
      mainLoop.loop();
    } catch (Throwable t) {
      try {
        gameManager.saveErrorReplay();
      } catch (Throwable) {}
      throw t;
    }
  }
  return 0;
}

private void parseArgs(string[] commandArgs) {
  string[] args = commandArgs[1..$];
  string progName = commandArgs[0];
  for (int i = 0; i < args.length; i++) {
    switch (args[i]) {
    case "-brightness":
      if (i >= args.length - 1) {
        usage(progName);
        throw new Exception("Invalid options");
      }
      i++;
      float b = cast(float) convInt(args[i]) / 100;
      if (b < 0 || b > 1) {
        usage(args[0]);
        throw new Exception("Invalid options");
      }
      Screen.brightness = b;
      break;
    case "-window":
      Screen.windowMode = true;
      break;
    case "-res":
      if (i >= args.length - 2) {
        usage(progName);
        throw new Exception("Invalid options");
      }
      i++;
      int w = convInt(args[i]);
      i++;
      int h = convInt(args[i]);
      Screen.width = w;
      Screen.height = h;
      break;
    case "-nosound":
      SoundManager.noSound = true;
      break;
    default:
      usage(progName);
      throw new Exception("Invalid options");
    }
  }
}

private void usage(string progName) {
  Logger.error
    ("Usage: " ~ progName ~ " [-brightness [0-100]] [-luminosity [0-100]] [-window] [-res x y] [-nosound]");
}
