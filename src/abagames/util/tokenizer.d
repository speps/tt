/*
 * $Id: tokenizer.d,v 1.1.1.1 2004/11/10 13:45:22 kenta Exp $
 *
 * Copyright 2004 Kenta Cho. Some rights reserved.
 */
module abagames.util.tokenizer;

private import std.conv;
private import std.array;
private import std.string;
private import undead.stream;
private import undead.string;

/**
 * Tokenizer.
 */
public class Tokenizer {
 private:

  public static string[] readFile(string fileName, string separator) {
    string[] result;
    auto fd = new File;
    fd.open(fileName);
    for (;;) {
      char[] line = fd.readLine();
      if (!line)
        break;
      char[][] spl = split(line, separator);
      foreach (char[] s; spl) {
        char[] r = strip(s);
        if (r.length > 0)
          result ~= to!string(r);
      }
    }
    fd.close();
    return result;
  }
}

/**
 * CSV format tokenizer.
 */
public class CSVTokenizer {
 private:

  public static string[] readFile(string fileName) {
    return Tokenizer.readFile(fileName, ",");
  }
}
