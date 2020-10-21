/*
 * $Id: logger.d,v 1.1.1.1 2004/11/10 13:45:22 kenta Exp $
 *
 * Copyright 2004 Kenta Cho. Some rights reserved.
 */
module abagames.util.logger;

import std.stdio;

/**
 * Logger(error/info).
 */
version(Win32_release) {

import std.c.windows.windows;

public class Logger {

  public static void info(string msg, bool nline = true) {
    if (nline)
      stderr.writeln(msg);
    else
      stderr.write(msg);
  }

  private static void putMessage(string msg) {
    MessageBoxA(null, toStringz(msg), "Error", MB_OK | MB_ICONEXCLAMATION);
  }

  public static void error(string msg) {
    putMessage("Error: " ~ msg);
  }

  public static void error(Throwable e) {
    putMessage("Error: " ~ e.toString());
  }
}

} else {

public class Logger {

  public static void info(string msg, bool nline = true) {
    if (nline)
      stderr.writeln(msg);
    else
      stderr.write(msg);
  }

  public static void error(string msg) {
    stderr.writeln("Error: " ~ msg);
  }

}

}
