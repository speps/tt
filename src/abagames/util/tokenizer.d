/*
 * $Id: tokenizer.d,v 1.1.1.1 2004/11/10 13:45:22 kenta Exp $
 *
 * Copyright 2004 Kenta Cho. Some rights reserved.
 */
module abagames.util.tokenizer;

private import std.stream;
private import std.string;

/**
 * Tokenizer.
 */
public class Tokenizer {
 private:

  public static char[][] readFile(char[] fileName, char[] separator) {
    char[][] result;
    auto File fd = new File;
    fd.open(fileName);
    for (;;) {
      char[] line = fd.readLine();
      if (!line)
	break;
      char[][] spl = split(line, separator);
      foreach (char[] s; spl) {
	char[] r = strip(s);
	if (r.length > 0)
	  result ~= r;
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

  public static char[][] readFile(char[] fileName) {
    return Tokenizer.readFile(fileName, ",");
  }
}
