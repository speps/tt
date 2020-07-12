/*
 * $Id: replay.d,v 1.1 2005/01/01 12:40:28 kenta Exp $
 *
 * Copyright 2004 Kenta Cho. Some rights reserved.
 */
module abagames.tt.replay;

private import undead.stream;
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
    auto fd = new File;
    fd.create(dir ~ "/" ~ fileName);
    fd.write(VERSION_NUM);
    fd.write(level);
    fd.write(grade);
    fd.write(seed);
    padRecord.save(fd);
    fd.close();
  }

  public void load(string fileName) {
    auto fd = new File;
    fd.open(dir ~ "/" ~ fileName);
    int ver;
    fd.read(ver);
    if (ver != VERSION_NUM)
      throw new Error("Wrong version num");
    fd.read(level);
    fd.read(grade);
    fd.read(seed);
    padRecord = new PadRecord;
    padRecord.load(fd);
    fd.close();
  }
}
