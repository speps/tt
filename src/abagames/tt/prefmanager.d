/*
 * $Id: prefmanager.d,v 1.1.1.1 2004/11/10 13:45:22 kenta Exp $
 *
 * Copyright 2004 Kenta Cho. Some rights reserved.
 */
module abagames.tt.prefmanager;

private import std.stream;
private import abagames.util.prefmanager;
private import abagames.tt.ship;

/**
 * Save/Load the high score.
 */
public class PrefManager: abagames.util.prefmanager.PrefManager {
 private:
  static const int VERSION_NUM = 10;
  static const char[] PREF_FILE = "tt.prf";
  PrefData _prefData;

  public this() {
    _prefData = new PrefData;
  }

  public void load() {
    auto File fd = new File;
    try {
      int ver;
      fd.open(PREF_FILE);
      fd.read(ver);
      if (ver != VERSION_NUM)
        throw new Error("Wrong version num");
      _prefData.load(fd);
    } catch (Object e) {
      _prefData.init();
    } finally {
      if (fd.isOpen())
        fd.close();
    }
  }

  public void save() {
    auto File fd = new File;
    fd.create(PREF_FILE);
    fd.write(VERSION_NUM);
    _prefData.save(fd);
    fd.close();
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
    foreach (inout GradeData gd; gradeData)
      gd = new GradeData;
  }

  public void init() {
    foreach (GradeData gd; gradeData)
      gd.init();
    _selectedGrade = 0;
    _selectedLevel = 1;
  }

  public void load(File fd) {
    foreach (GradeData gd; gradeData)
      gd.load(fd);
    fd.read(_selectedGrade);
    fd.read(_selectedLevel);
  }

  public void save(File fd) {
    foreach (GradeData gd; gradeData)
      gd.save(fd);
    fd.write(_selectedGrade);
    fd.write(_selectedLevel);
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

  public void load(File fd) {
    fd.read(reachedLevel);
    fd.read(hiScore);
    fd.read(startLevel);
    fd.read(endLevel);
  }

  public void save(File fd) {
    fd.write(reachedLevel);
    fd.write(hiScore);
    fd.write(startLevel);
    fd.write(endLevel);
  }
}
