/*
 * $Id: replay.d,v 1.1 2005/01/01 12:40:28 kenta Exp $
 *
 * Copyright 2004 Kenta Cho. Some rights reserved.
 */
module abagames.tt.replay;

import std.file;
import std.array;
import std.bitmanip;

private import abagames.util.sdl.recordablepad;

/**
 * Manage a replay data.
 */
public class ReplayData {
 public:
  static const string dir = "replay";
  static const int VERSION_NUM = 20;
  PadRecord padRecord;
  float level;
  int grade;
  long seed;
 private:

  public void save(string fileName) {
    auto buffer = appender!(ubyte[]);
    buffer.append!(int, Endian.littleEndian)(VERSION_NUM);
    buffer.append!(float, Endian.littleEndian)(level);
    buffer.append!(int, Endian.littleEndian)(grade);
    buffer.append!(long, Endian.littleEndian)(seed);
    padRecord.save(buffer);
    std.file.write(dir ~ "/" ~ fileName, buffer[]);
  }

  public void load(string fileName) {
    auto buffer = cast(ubyte[])std.file.read(dir ~ "/" ~ fileName);
    int ver = buffer.read!(int, Endian.littleEndian);
    if (ver != VERSION_NUM)
      throw new Error("Wrong version num");
    level = buffer.read!(float, Endian.littleEndian);
    grade = buffer.read!(int, Endian.littleEndian);
    seed = buffer.read!(long, Endian.littleEndian);
    padRecord = new PadRecord;
    padRecord.load(buffer);
  }
}
