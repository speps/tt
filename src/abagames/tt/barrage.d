/*
 * $Id: barrage.d,v 1.2 2005/01/01 12:40:27 kenta Exp $
 *
 * Copyright 2004 Kenta Cho. Some rights reserved.
 */
module abagames.tt.barrage;

private import std.math;
private import std.string;
private import std.path;
private import std.file;
private import bulletml;
private import abagames.util.rand;
private import abagames.util.logger;
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

  public static this() {
    rand = new Rand;
  }

  public static void setRandSeed(long seed) {
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

  public void addBml(char[] bmlDirName, char[] bmlFileName, float r, bool re, float s) {
    BulletMLParser *p = BarrageManager.getInstance(bmlDirName, bmlFileName);
    if (!p)
      throw new Error("File not found: " ~ bmlDirName ~ "/" ~ bmlFileName);
    addBml(p, r, re, s);
  }

  public void addBml(char[] bmlDirName, char[] bmlFileName, float r, char[] reStr, float s) {
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
  static BulletMLParserTinyXML *parser[char[]][char[]];
  static const char[] BARRAGE_DIR_NAME = "barrage";

  public static void load() {
    char[][] dirs = listdir(BARRAGE_DIR_NAME);
    foreach (char[] dirName; dirs) {
      char[][] files = listdir(BARRAGE_DIR_NAME ~ "/" ~ dirName);
      foreach (char[] fileName; files) {
        if (getExt(fileName) != "xml")
          continue;
        parser[dirName][fileName] = getInstance(dirName, fileName);
      }
    }
  }

  public static BulletMLParserTinyXML* getInstance(char[] dirName, char[] fileName) {
    if (!parser[dirName][fileName]) {
      char[] barrageName = dirName ~ "/" ~ fileName;
      Logger.info("Load BulletML: " ~ barrageName);
      parser[dirName][fileName] = 
        BulletMLParserTinyXML_new(std.string.toStringz(BARRAGE_DIR_NAME ~ "/" ~ barrageName));
      BulletMLParserTinyXML_parse(parser[dirName][fileName]);
    }
    return parser[dirName][fileName];
  }

  public static BulletMLParserTinyXML*[] getInstanceList(char[] dirName) {
    BulletMLParserTinyXML *pl[];
    foreach (BulletMLParserTinyXML *p; parser[dirName]) {
      pl ~= p;
    }
    return pl;
  }

  public static void unload() {
    foreach (BulletMLParserTinyXML *pa[char[]]; parser) {
      foreach (BulletMLParserTinyXML *p; pa) {
        BulletMLParserTinyXML_delete(p);
      }
    }
  }
}
