/*
 * $Id: barrage.d,v 1.2 2005/01/01 12:40:27 kenta Exp $
 *
 * Copyright 2004 Kenta Cho. Some rights reserved.
 */
module abagames.tt.barrage;

private import std.math;
private import std.string;
private import std.path;
private import bulletml;
private import abagames.util.rand;
private import abagames.util.logger;
private import abagames.util.listdir;
private import abagames.tt.bulletactor;
private import abagames.tt.bulletactorpool;
private import abagames.tt.bulletimpl;
private import abagames.tt.bullettarget;
private import abagames.tt.shape;

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

  public void addBml(BulletMLParser *p, float r, bool re, float s) {
    parserParam ~= new ParserParam(p, r, re, s);
  }

  public void addBml(string bmlDirName, string bmlFileName, float r, bool re, float s) {
    BulletMLParser *p = BarrageManager.getInstance(bmlDirName, bmlFileName);
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
  static BulletMLParserTinyXML*[string][string] parser;
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

  public static BulletMLParserTinyXML* getInstance(string dirName, string fileName) {
    if (!parser[dirName][fileName]) {
      string barrageName = dirName ~ "/" ~ fileName;
      Logger.info("Load BulletML: " ~ barrageName);
      parser[dirName][fileName] = 
        BulletMLParserTinyXML_new(std.string.toStringz(BARRAGE_DIR_NAME ~ "/" ~ barrageName));
      BulletMLParserTinyXML_parse(parser[dirName][fileName]);
    }
    return parser[dirName][fileName];
  }

  public static BulletMLParserTinyXML*[] getInstanceList(string dirName) {
    BulletMLParserTinyXML*[] pl;
    foreach (BulletMLParserTinyXML *p; parser[dirName]) {
      pl ~= p;
    }
    return pl;
  }

  public static void unload() {
    foreach (BulletMLParserTinyXML*[string] pa; parser) {
      foreach (BulletMLParserTinyXML *p; pa) {
        BulletMLParserTinyXML_delete(p);
      }
    }
  }
}
