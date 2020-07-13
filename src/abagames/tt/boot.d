/*
 * $Id: boot.d,v 1.2 2005/01/01 12:40:27 kenta Exp $
 *
 * Copyright 2004 Kenta Cho. Some rights reserved.
 */
module abagames.tt.boot;

private import std.conv;
private import undead.stream;
private import core.stdc.stdlib;
private import abagames.util.logger;
private import abagames.util.tokenizer;
private import abagames.util.sdl.mainloop;
private import abagames.util.sdl.pad;
private import abagames.util.sdl.recordablepad;
private import abagames.util.sdl.sound;
private import abagames.tt.screen;
private import abagames.tt.gamemanager;
private import abagames.tt.prefmanager;

/**
 * Boot the game.
 */
private:
Screen screen;
Pad input;
GameManager gameManager;
PrefManager prefManager;
MainLoop mainLoop;

version (Win32_release) {
  // Boot as the Windows executable.
  private import std.c.windows.windows;
  private import std.string;

  extern (C) void gc_init();
  extern (C) void gc_term();
  extern (C) void _minit();
  extern (C) void _moduleCtor();

  extern (Windows)
  public int WinMain(HINSTANCE hInstance,
		     HINSTANCE hPrevInstance,
		     LPSTR lpCmdLine,
		     int nCmdShow) {
    int result;
    gc_init();
    _minit();
    try {
      _moduleCtor();
      char[4096] exe;
      GetModuleFileNameA(null, exe, 4096);
      char[][1] prog;
      prog[0] = std.string.toString(exe);
      result = boot(prog ~ std.string.split(std.string.toString(lpCmdLine)));
    } catch (Object o) {
      Logger.error("Exception: " ~ o.toString());
      result = EXIT_FAILURE;
    }
    gc_term();
    return result;
  }
} else {
  // Boot as the general executable.
  public int main(string[] args) {
    return boot(args);
  }
}

public int boot(string[] args) {
  screen = new Screen;
  input = new RecordablePad;
  try {
    input.openJoystick();
  } catch (Exception) {}
  gameManager = new GameManager;
  prefManager = new PrefManager;
  mainLoop = new MainLoop(screen, input, gameManager, prefManager);
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
    case "-luminosity":
    case "-luminous":
      if (i >= args.length - 1) {
        usage(progName);
        throw new Exception("Invalid options");
      }
      i++;
      float l = cast(float) to!int(args[i]) / 100;
      if (l < 0 || l > 1) {
        usage(progName);
        throw new Exception("Invalid options");
      }
      Screen.luminous = l;
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
    case "-reverse":
      (cast (Pad) input).buttonReversed = true;
      break;
    case "-accframe":
      mainLoop.accframe = 1;
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
