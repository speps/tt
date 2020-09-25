/*
 * $Id: bulletimpl.d,v 1.2 2005/01/01 12:40:27 kenta Exp $
 *
 * Copyright 2004 Kenta Cho. Some rights reserved.
 */
module abagames.tt.bulletimpl;

import bulletml;
import abagames.util.bulletml.bullet;
import abagames.tt.bulletactor;
import abagames.tt.bullettarget;
import abagames.tt.shape;

/**
 * Bullet params of parsers, shape, the vertical/horizontal reverse moving, target, rootBullet.
 */
public class BulletImpl: Bullet {
 public:
  ParserParam[] parserParam;
  int parserIdx;
  Drawable shape, disapShape;
  float xReverse, yReverse;
  bool longRange;
  BulletTarget target;
  BulletActor rootBullet;
 private:

  public this(int id) {
    super(id);
  }
  
  public void setParamFirst(ParserParam[] parserParam,
                            Drawable shape, Drawable disapShape,
                            float xReverse, float yReverse, bool longRange,
                            BulletTarget target, BulletActor rootBullet) {
    this.parserParam = parserParam;
    this.shape = shape;
    this.disapShape = disapShape;
    this.xReverse = xReverse;
    this.yReverse = yReverse;
    this.longRange = longRange;
    this.target = target;
    this.rootBullet = rootBullet;
    parserIdx = 0;
  }

  public void setParam(BulletImpl bi) {
    parserParam = bi.parserParam;
    shape = bi.shape;
    disapShape = bi.disapShape;
    xReverse = bi.xReverse;
    yReverse = bi.yReverse;
    target = bi.target;
    //rootBullet = bi.rootBullet;
    rootBullet = null;
    parserIdx = bi.parserIdx;
    longRange = bi.longRange;
  }

  public void addParser(BulletMLParserType p, float r, float re, float s) {
    parserParam ~= new ParserParam(p, r, re, s);
  }
  
  public bool gotoNextParser() {
    parserIdx++;
    if (parserIdx >= parserParam.length) {
      parserIdx--;
      return false;
    } else {
      return true;
    }
  }

  public BulletMLParserType getParser() {
    return parserParam[parserIdx].parser;
  }
  
  public void resetParser() {
    parserIdx = 0;
  }

  public override float rank() {
    ParserParam pp = parserParam[parserIdx];
    //float r = pp.rank + (rootBullet.rootRank - 1) * pp.rootRankEffect * pp.rank;
    float r = pp.rank;
    if (r > 1)
      r = 1;
    return r;
  }

  public float getSpeedRank() {
    return parserParam[parserIdx].speed;
  }
}

public class ParserParam {
 public:
  BulletMLParserType parser;
  float rank;
  float rootRankEffect;
  float speed;

  public this(BulletMLParserType p, float r, float re, float s) {
    parser = p;
    rank = r;
    rootRankEffect = re;
    speed = s;
  }
}
