/*
 * $Id: bullet.d,v 1.2 2005/01/01 12:40:28 kenta Exp $
 *
 * Copyright 2004 Kenta Cho. Some rights reserved.
 */
module abagames.util.bulletml.bullet;

import abagames.util.math;
import abagames.util.vector;
import abagames.util.rand;
import abagames.util.bulletml.bulletsmanager;

alias BulletMLParserType = abagames.util.bulletml.bulletmlparser.BulletMLParser;
alias BulletMLRunnerType = abagames.util.bulletml.bulletmlrunner.BulletMLRunner;
alias BulletMLStateType = abagames.util.bulletml.bulletmlrunner.BulletMLState;

/**
 * Bullet controlled by BulletML.
 */
public class Bullet {
 public:
  static Bullet now;
  static Vector target;
  Vector pos, acc;
  float deg;
  float speed;
  int id;
 private:
  static Rand rand;
  static BulletsManager manager;
  BulletMLRunnerType runner;
  float _rank;

  public static void setRandSeed(long s) {
    if (!rand) {
      rand = new Rand;
    }
    rand.setSeed(s);
  }

  public static void setBulletsManager(BulletsManager bm) {
    manager = bm;
    target = new Vector;
    target.x = target.y = 0;
  }

  public static double getRand() {
    return rand.nextFloat(1);
  }

  public static void addBullet(float deg, float speed) {
    manager.addBullet(deg, speed);
  }

  public static void addBullet(BulletMLStateType state, float deg, float speed) {
    manager.addBullet(state, deg, speed);
  }

  public static int getTurn() {
    return manager.getTurn();
  }

  public this(int id) {
    pos = new Vector;
    acc = new Vector;
    this.id = id;
  }

  public void set(float x, float y, float deg, float speed, float rank) {
    pos.x = x; pos.y = y;
    acc.x = acc.y = 0;
    this.deg = deg;
    this.speed = speed;
    this.rank = rank;
    runner = null;
  }

  public void setRunner(BulletMLRunnerType runner) {
    this.runner = runner;
  }

  public void set(BulletMLRunnerType runner, 
		  float x, float y, float deg, float speed, float rank) {
    set(x, y, deg, speed, rank);
    setRunner(runner);
  }

  public void move() {
    now = this;
    if (!runner.isEnd) {
      runner.run();
    }
  }

  public bool isEnd() {
    return runner.isEnd;
  }

  public void kill() {
    manager.killMe(this);
  }

  public void remove() {
    if (runner) {
      runner = null;
    }
  }

  public float rank() {
    return _rank;
  }

  public float rank(float value) {
    return _rank = value;
  }
}

private:
const float VEL_SS_SDM_RATIO = 62.0 / 10;
const float VEL_SDM_SS_RATIO = 10.0 / 62;

public:

float rtod(float a) {
  return a * 180 / PI;
}

float dtor(float a) {
  return a * PI / 180;
}


double getBulletDirection_(BulletMLRunnerType) {
  return rtod(Bullet.now.deg);
}
double getAimDirection_(BulletMLRunnerType) {
  Vector b = Bullet.now.pos;
  Vector t = Bullet.target;
  return rtod(atan2(t.x - b.x, t.y - b.y));
}
double getBulletSpeed_(BulletMLRunnerType) {
  return Bullet.now.speed * VEL_SS_SDM_RATIO;
}
double getDefaultSpeed_(BulletMLRunnerType) {
  return 1;
}
double getRank_(BulletMLRunnerType) {
  return Bullet.now.rank;
}
void createSimpleBullet_(BulletMLRunnerType, double d, double s) {
  Bullet.addBullet(dtor(d), s * VEL_SDM_SS_RATIO);
}
void createBullet_(BulletMLRunnerType, BulletMLStateType state, double d, double s) {
  Bullet.addBullet(state, dtor(d), s * VEL_SDM_SS_RATIO);
}
int getTurn_(BulletMLRunnerType) {
  return Bullet.getTurn();
}
void doVanish_(BulletMLRunnerType) {
  Bullet.now.kill();
}
void doChangeDirection_(BulletMLRunnerType, double d) {
  Bullet.now.deg = dtor(d);
}
void doChangeSpeed_(BulletMLRunnerType, double s) {
  Bullet.now.speed = s * VEL_SDM_SS_RATIO;
}
void doAccelX_(BulletMLRunnerType, double sx) {
  Bullet.now.acc.x = sx * VEL_SDM_SS_RATIO;
}
void doAccelY_(BulletMLRunnerType, double sy) {
  Bullet.now.acc.y = sy * VEL_SDM_SS_RATIO;
}
double getBulletSpeedX_(BulletMLRunnerType) {
  return Bullet.now.acc.x;
}
double getBulletSpeedY_(BulletMLRunnerType) {
  return Bullet.now.acc.y;
}
double getRand_(BulletMLRunnerType) {
  return Bullet.getRand();
}
