/*
 * $Id: boot.d,v 1.2 2005/01/01 12:40:27 kenta Exp $
 *
 * Copyright 2004 Kenta Cho. Some rights reserved.
 */
module abagames.tt.boot;

import std.conv;
import core.stdc.stdlib;
import abagames.util.logger;
import abagames.util.tokenizer;
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

public int main(string[] args) {
  screen = new Screen;
  pad = new RecordablePad(new InputBackendImpl());
  gameManager = new GameManager;
  prefManager = new PrefManager;
  mainLoop = new MainLoop(screen, pad, gameManager, prefManager);
  try {
    parseArgs(args);
  } catch (Exception e) {
    return EXIT_FAILURE;
  }
  try {
    mainLoop.loop();
  } catch (Throwable t) {
    try {
      gameManager.saveErrorReplay();
    } catch (Throwable) {}
    throw t;
  }
  return EXIT_SUCCESS;
}

private void parseArgs(string[] commandArgs) {
  string[] args = readOptionsIniFile();
  for (int i = 1; i < commandArgs.length; i++)
    args ~= commandArgs[i];
  string progName = commandArgs[0];
  for (int i = 0; i < args.length; i++) {
    switch (args[i]) {
    case "-brightness":
      if (i >= args.length - 1) {
        usage(progName);
        throw new Exception("Invalid options");
      }
      i++;
      float b = cast(float) to!int(args[i]) / 100;
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
      int w = to!int(args[i]);
      i++;
      int h = to!int(args[i]);
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

private const string OPTIONS_INI_FILE = "options.ini";

private string[] readOptionsIniFile() {
  try {
    return Tokenizer.readFile(OPTIONS_INI_FILE, " ");
  } catch (Throwable) {
    return null;
  }
}

private void usage(string progName) {
  Logger.error
    ("Usage: " ~ progName ~ " [-brightness [0-100]] [-luminosity [0-100]] [-window] [-res x y] [-nosound]");
}
