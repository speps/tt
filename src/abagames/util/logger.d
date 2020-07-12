/*
 * $Id: logger.d,v 1.1.1.1 2004/11/10 13:45:22 kenta Exp $
 *
 * Copyright 2004 Kenta Cho. Some rights reserved.
 */
module abagames.util.logger;

private import std.stream;
private import std.string;

/**
 * Logger(error/info).
 */
version(Win32_release) {

private import std.string;
private import std.c.windows.windows;

public class Logger {

  public static void info(char[] msg, bool nline = true) {
    // Win32 exe crashes if it writes something to stderr.
    /*if (nline)
      stderr.writeLine(msg);
    else
    stderr.writeString(msg);*/
  }

  public static void info(double n, bool nline = true) {
    /*if (nline)
      stderr.writeLine(std.string.toString(n));
    else
    stderr.writeString(std.string.toString(n) ~ " ");*/
  }

  private static void putMessage(char[] msg) {
    MessageBoxA(null, std.string.toStringz(msg), "Error", MB_OK | MB_ICONEXCLAMATION);
  }

  public static void error(char[] msg) {
    putMessage("Error: " ~ msg);
  }

  public static void error(Exception e) {
    putMessage("Error: " ~ e.toString());
  }

  public static void error(Error e) {
    putMessage("Error: " ~ e.toString());
  }
}

} else {

public class Logger {

  public static void info(char[] msg, bool nline = true) {
    if (nline)
      stderr.writeLine(msg);
    else
      stderr.writeString(msg);
  }

  public static void info(double n, bool nline = true) {
    if (nline)
      stderr.writeLine(std.string.toString(n));
    else
      stderr.writeString(std.string.toString(n) ~ " ");
  }

  public static void error(char[] msg) {
    stderr.writeLine("Error: " ~ msg);
  }

  public static void error(Exception e) {
    stderr.writeLine("Error: " ~ e.toString());
  }

  public static void error(Error e) {
    stderr.writeLine("Error: " ~ e.toString());
    if (e.next)
      error(e.next);
  }
}

}
