/*
 * $Id: replay.d,v 1.1 2005/01/01 12:40:28 kenta Exp $
 *
 * Copyright 2004 Kenta Cho. Some rights reserved.
 */
module abagames.tt.replay;

import std.file;

import abagames.util.bytebuffer;
import abagames.util.sdl.recordablepad;

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
    ubyte[] buffer;
    buffer.append(VERSION_NUM);
    buffer.append(level);
    buffer.append(grade);
    buffer.append(seed);
    padRecord.save(buffer);
    std.file.write(dir ~ "/" ~ fileName, buffer);
  }

  public void load(string fileName) {
    auto buffer = cast(ubyte[])std.file.read(dir ~ "/" ~ fileName);
    int ver = buffer.readInt;
    if (ver != VERSION_NUM)
      throw new Error("Wrong version num");
    level = buffer.readFloat();
    grade = buffer.readInt();
    seed = buffer.readLong();
    padRecord = new PadRecord;
    padRecord.load(buffer);
  }
}
