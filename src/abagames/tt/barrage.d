/*
 * $Id: barrage.d,v 1.2 2005/01/01 12:40:27 kenta Exp $
 *
 * Copyright 2004 Kenta Cho. Some rights reserved.
 */
module abagames.tt.barrage;

import std.math;
import std.string;
import std.path;
import abagames.util.bulletml.bullet;
import abagames.util.rand;
import abagames.util.logger;
import abagames.util.listdir;
import abagames.tt.bulletactor;
import abagames.tt.bulletactorpool;
import abagames.tt.bulletimpl;
import abagames.tt.bullettarget;
import abagames.tt.shape;

/**
 * Barrage pattern.
 */
public class Barrage {
 private:
  static Rand rand;
  ParserParam[] parserParam;
  Drawable shape, disapShape;
  bool longRange;
  int prevWait, postWait;
  bool noXReverse = false;

  public static void setRandSeed(long seed) {
    if (!rand) {
      rand = new Rand;
    }
    rand.setSeed(seed);
  }

  public void setShape(Drawable shape, Drawable disapShape) {
    this.shape = shape;
    this.disapShape = disapShape;
  }

  public void setWait(int prevWait, int postWait) {
    this.prevWait = prevWait;
    this.postWait = postWait;
  }

  public void setLongRange(bool longRange) {
    this.longRange = longRange;
  }

  public void setNoXReverse() {
    noXReverse = true;
  }

  public void addBml(BulletMLParserType p, float r, bool re, float s) {
    parserParam ~= new ParserParam(p, r, re, s);
  }

  public void addBml(string bmlDirName, string bmlFileName, float r, bool re, float s) {
    auto p = BarrageManager.getInstance(bmlDirName, bmlFileName);
    if (!p)
      throw new Error("File not found: " ~ bmlDirName ~ "/" ~ bmlFileName);
    addBml(p, r, re, s);
  }

  public void addBml(string bmlDirName, string bmlFileName, float r, string reStr, float s) {
    bool re = true;
    if (reStr == "f" || reStr == "false")
      re = false;
    addBml(bmlDirName, bmlFileName, r, re, s);
  }

  public BulletActor addTopBullet(BulletActorPool bullets, BulletTarget target) {
    float xReverse;
    if (noXReverse)
      xReverse = 1;
    else
      xReverse = rand.nextInt(2) * 2 - 1;
    return bullets.addTopBullet(parserParam,
				0, 0, PI, 0,
				shape, disapShape, xReverse, 1, longRange, target,
				prevWait, postWait);
  }
}

/**
 * Barrage manager(BulletMLs' loader).
 */
public class BarrageManager {
 private:
  static BulletMLParserType[string][string] parser;
  static const string BARRAGE_DIR_NAME = "barrage";

  public static void load() {
    string[] dirs = listdir(BARRAGE_DIR_NAME);
    foreach (string dirName; dirs) {
      string[] files = listdir(BARRAGE_DIR_NAME ~ "/" ~ dirName);
      foreach (string fileName; files) {
        if (fileName.extension != ".xml")
          continue;
        parser[dirName][fileName] = getInstance(dirName, fileName);
      }
    }
  }

  public static BulletMLParserType getInstance(string dirName, string fileName) {
    if (!(dirName in parser) || !(fileName in parser[dirName])) {
      string barrageName = dirName ~ "/" ~ fileName;
      Logger.info("Load BulletML: " ~ barrageName);
      parser[dirName][fileName] = new BulletMLParserType(BARRAGE_DIR_NAME ~ "/" ~ barrageName);
      parser[dirName][fileName].parse();
    }
    return parser[dirName][fileName];
  }

  public static BulletMLParserType[] getInstanceList(string dirName) {
    BulletMLParserType[] pl;
    if (dirName in parser) {
      foreach (BulletMLParserType p; parser[dirName]) {
        pl ~= p;
      }
    }
    return pl;
  }

  public static void unload() {
    parser.clear();
  }
}
