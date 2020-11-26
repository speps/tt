/*
 * $Id: prefmanager.d,v 1.1.1.1 2004/11/10 13:45:22 kenta Exp $
 *
 * Copyright 2004 Kenta Cho. Some rights reserved.
 */
module abagames.tt.prefmanager;

import std.file;

import abagames.util.bytebuffer;
import abagames.util.prefmanager;
import abagames.tt.ship;

/**
 * Save/Load the high score.
 */
public class PrefManager: abagames.util.prefmanager.PrefManager {
 private:
  static const int VERSION_NUM = 10;
  static const string PREF_FILE = "tt.prf";
  PrefData _prefData;

  public this() {
    _prefData = new PrefData;
  }

  public void load() {
    ubyte[] buffer = null;
    try {
      buffer = cast(ubyte[])std.file.read(PREF_FILE);
    } catch(Exception) {
    }
    if (buffer is null) {
      _prefData.init();
      return;
    }
    int ver = buffer.readInt();
    if (ver != VERSION_NUM)
      throw new Error("Wrong version num");
    _prefData.load(buffer);
  }

  public void save() {
    ubyte[] buffer;
    buffer.append(VERSION_NUM);
    _prefData.save(buffer);
    std.file.write(PREF_FILE, buffer);
  }

  public PrefData prefData() {
    return _prefData;
  }
}

public class PrefData {
 private:
  GradeData[] gradeData;
  int _selectedGrade, _selectedLevel;

  public this() {
    gradeData = new GradeData[Ship.GRADE_NUM];
    foreach (ref GradeData gd; gradeData)
      gd = new GradeData;
  }

  public void init() {
    foreach (GradeData gd; gradeData)
      gd.init();
    _selectedGrade = 0;
    _selectedLevel = 1;
  }

  public void load(ref ubyte[] buffer) {
    foreach (GradeData gd; gradeData)
      gd.load(buffer);
    _selectedGrade = buffer.readInt();
    _selectedLevel = buffer.readInt();
  }

  public void save(ref ubyte[] buffer) {
    foreach (GradeData gd; gradeData)
      gd.save(buffer);
    buffer.append(_selectedGrade);
    buffer.append(_selectedLevel);
  }

  public void recordStartGame(int gd, int lv) {
    _selectedGrade = gd;
    _selectedLevel = lv;
  }

  public void recordResult(int lv, int sc) {
    GradeData gd = gradeData[_selectedGrade];
    if (sc > gd.hiScore) {
      gd.hiScore = sc;
      gd.startLevel = _selectedLevel;
      gd.endLevel = lv;
    }
    if (lv > gd.reachedLevel) {
      gd.reachedLevel = lv;
    }
    _selectedLevel = lv;
  }

  public int getMaxLevel(int gd) {
    return gradeData[gd].reachedLevel;
  }

  public GradeData getGradeData(int gd) {
    return gradeData[gd];
  }

  public int selectedGrade() {
    return _selectedGrade;
  }

  public int selectedLevel() {
    return _selectedLevel;
  }
}

public class GradeData {
 public:
  int reachedLevel;
  int hiScore;
  int startLevel, endLevel;
 private:

  public void init() {
    reachedLevel = startLevel = endLevel = 1;
    hiScore = 0;
  }

  public void load(ref ubyte[] buffer) {
    reachedLevel = buffer.readInt();
    hiScore = buffer.readInt();
    startLevel = buffer.readInt();
    endLevel = buffer.readInt();
  }

  public void save(ref ubyte[] buffer) {
    buffer.append(reachedLevel);
    buffer.append(hiScore);
    buffer.append(startLevel);
    buffer.append(endLevel);
  }
}
