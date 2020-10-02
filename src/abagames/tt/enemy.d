/*
 * $Id: enemy.d,v 1.5 2005/01/09 03:49:59 kenta Exp $
 *
 * Copyright 2004 Kenta Cho. Some rights reserved.
 */
module abagames.tt.enemy;

import std.math;
import bindbc.opengl;
import abagames.util.gl;
import abagames.util.vector;
import abagames.util.actor;
import abagames.util.rand;
import abagames.tt.shape;
import abagames.tt.tunnel;
import abagames.tt.bulletactor;
import abagames.tt.bulletactorpool;
import abagames.tt.bullettarget;
import abagames.tt.barrage;
import abagames.tt.ship;
import abagames.tt.stagemanager;
import abagames.tt.screen;
import abagames.tt.particle;
import abagames.tt.shot;
import abagames.tt.soundmanager;

/**
 * Enemy ships.
 */
public class Enemy: Actor {
 private:
  static const float OUT_OF_COURSE_BANK = 1.0;
  static const float DISAP_DEPTH = -5.0f;
  static Rand rand;
  Tunnel tunnel;
  BulletActorPool bullets;
  Ship ship;
  ParticlePool particles;
  ShipSpec spec;
  Vector pos;
  Vector ppos;  // Position of the previous frame.
  Vector flipMv;
  int flipMvCnt;
  float speed;
  float d1, d2;
  float baseBank;
  int cnt;
  float bank;
  BulletActor topBullet;
  int shield, firstShield;
  bool damaged;
  bool highOrder;  // Whether it is at the head of a player's ship.
  float limitY;  // Boss type enemy has the limit y < limitY.
  BulletActor[] bitBullet; // Actors for bosse's bits.
  int bitCnt;
  Vector bitOffset;
  bool passed;
  EnemyPool passedEnemies;

  public static this() {
    rand = new Rand;
  }

  public static void setRandSeed(long seed) {
    rand.setSeed(seed);
  }

  public override void init(Object[] args) {
    tunnel = cast(Tunnel) args[0];
    bullets = cast(BulletActorPool) args[1];
    ship = cast(Ship) args[2];
    particles = cast(ParticlePool) args[3];
    pos = new Vector;
    ppos = new Vector;
    flipMv = new Vector;
    bitOffset = new Vector;
  }

  public void setPassedEnemies(EnemyPool pe) {
    passedEnemies = pe;
  }

  public void set(ShipSpec spec, float x, float y, Rand rand, bool ps = false, float baseBank = 0) {
    this.spec = spec;
    pos.x = x;
    limitY = pos.y = y;
    speed = 0;
    d1 = d2 = 0;
    cnt = 0;
    bank = 0;
    firstShield = shield = spec.shield;
    if (!ps)
      this.baseBank = spec.createBaseBank(rand);
    else
      this.baseBank = baseBank;
    flipMvCnt = 0;
    damaged = false;
    highOrder = true;
    topBullet = null;
    bitBullet = null;
    passed = ps;
    exists = true;
  }

  public override void move() {
    if (!passed) {
      if (highOrder) {
        if (pos.y <= ship.relPos.y) {
          ship.rankUp(spec.isBoss);
          highOrder = false;
        }
      } else {
        if (pos.y > ship.relPos.y) {
          ship.rankDown();
          highOrder = true;
        }
      }
    }
    ppos.x = pos.x;
    ppos.y = pos.y;
    if (ship.isBossModeEnd) {
      speed += (0 - speed) * 0.05f;
      flipMvCnt = 0;
    } else if (!ship.hasCollision()) {
      speed += (1.5f - speed) * 0.15f;
    }
    if (spec.hasLimitY)
      spec.setSpeed(speed, ship.speed);
    else if (pos.y > 5 && pos.y < Ship.IN_SIGHT_DEPTH_DEFAULT * 2)
      spec.setSpeed(speed, ship.speed);
    else
      spec.setSpeed(speed);
    float my = speed - ship.speed;
    if (passed && my > 0)
      my = 0;
    pos.y += my;
    if (!passed)
      if (spec.hasLimitY)
        spec.handleLimitY(pos.y, limitY);

    float ld, rd;
    bool steer = false;
    if (spec.getRangeOfMovement(ld, rd, pos, tunnel)) {
      int cdf = Tunnel.checkDegInside(pos.x, ld, rd);
      if (cdf != 0) {
        steer = true;
        if (cdf == -1)
          spec.tryToMove(bank, pos.x, ld);
        else if (cdf == 1)
          spec.tryToMove(bank, pos.x, rd);
      }
    }
    if (!steer) {
      if (spec.aimShip) {
        float ox = fabs(pos.x - ship.pos.x);
        if (ox > PI)
          ox = PI * 2 - ox;
        if (ox > PI / 3) {
          steer = true;
          spec.tryToMove(bank, pos.x, ship.pos.x);
        }
      }
    }
    if (!steer) {
      bank += (baseBank - bank) * 0.2;
    }
    bank *= 0.9f;
    pos.x += bank * 0.08f * (SliceState.DEFAULT_RAD / tunnel.getRadius(pos.y));
    if (flipMvCnt > 0) {
      flipMvCnt--;
      pos += flipMv;
      flipMv *= 0.95;
    }
    if (pos.x < 0)
      pos.x += PI * 2;
    else if (pos.x >= PI * 2)
      pos.x -= PI * 2;
    if (!passed && flipMvCnt <= 0 && !ship.isBossModeEnd) {
      float ax = fabs(pos.x - ship.relPos.x);
      if (ax > PI)
        ax = PI * 2 - ax;
      ax *= (tunnel.getRadius(0) / SliceState.DEFAULT_RAD);
      ax *= 3;
      float ay = fabs(pos.y - ship.relPos.y);
      if (ship.hasCollision() && spec.shape.checkCollision(ax, ay, ship.shape, ship.speed)) {
        float ox = ppos.x - ship.pos.x;
        if (ox > PI)
          ox -= PI * 2;
        else if (ox < -PI)
          ox += PI * 2;
        float oy = ppos.y;
        float od = atan2(ox, oy);
        flipMvCnt = 48;
        flipMv.x = sin(od) * ship.speed * 0.4;
        flipMv.y = cos(od) * ship.speed * 7;
      }
    }
    Slice sl = tunnel.getSlice(pos.y);
    float co = tunnel.checkInCourse(pos);
    if (co != 0) {
      float bm = (-OUT_OF_COURSE_BANK * co - bank) * 0.075f;
      if (bm > 1)
        bm = 1;
      else if (bm < -1)
        bm = -1;
      speed *= (1 - fabs(bm));
      bank += bm;
      float lo = fabs(pos.x - sl.getLeftEdgeDeg());
      if (lo > PI)
        lo = PI * 2 - lo;
      float ro = fabs(pos.x - sl.getRightEdgeDeg());
      if (ro > PI)
        ro = PI * 2 - ro;
      if (lo > ro)
        pos.x = sl.getRightEdgeDeg();
      else
        pos.x = sl.getLeftEdgeDeg();
    }
    d1 += (sl.d1 - d1) * 0.1;
    d2 += (sl.d2 - d2) * 0.1;
    if (!passed && !topBullet) {
      Barrage tbb = spec.barrage;
      topBullet = tbb.addTopBullet(bullets, ship);
      for (int i = 0; i < spec.bitNum; i++) {
        Barrage bbb = spec.bitBarrage;
        BulletActor ba = bbb.addTopBullet(bullets, ship);
        if (ba) {
          ba.unsetAimTop();
          bitBullet ~= ba;
        }
      }
    }
    if (topBullet) {
      topBullet.bullet.pos.x = pos.x;
      topBullet.bullet.pos.y = pos.y;
      checkBulletInRange(topBullet);
      float d;
      int i = 0;
      if (bitBullet) {
        foreach (BulletActor bb; bitBullet) {
          spec.getBitOffset(bitOffset, d, i, bitCnt);
          bb.bullet.pos.x = bitOffset.x + pos.x;
          bb.bullet.pos.y = bitOffset.y + pos.y;
          bb.bullet.deg = d;
          checkBulletInRange(bb);
          i++;
        }
      }
    }
    if (!passed && pos.y <= ship.inSightDepth)
      spec.shape.addParticles(pos, particles);
    if (!passed) {
      if ((!spec.hasLimitY && pos.y > Ship.IN_SIGHT_DEPTH_DEFAULT * 5) || pos.y < DISAP_DEPTH) {
        if (Ship.replayMode && pos.y < DISAP_DEPTH) {
          Enemy en = passedEnemies.getInstance();
          if (en)
            en.set(spec, pos.x, pos.y, null, true, baseBank);
        }
        remove();
      }
    } else {
      if (pos.y < -Ship.IN_SIGHT_DEPTH_DEFAULT * 3)
        remove();
    }
    damaged = false;
    bitCnt++;
  }

  private void checkBulletInRange(BulletActor ba) {
    if (!tunnel.checkInScreen(pos, ship)) {
      topBullet.rootRank = 0;
    } else {
      if (pos.dist(ship.relPos) > 20 + ship.relPos.y * 10 / Ship.RELPOS_MAX_Y &&
          pos.y > ship.relPos.y &&
          flipMvCnt <= 0) {
        if (spec.noFireDepthLimit)
          topBullet.rootRank = 1;
        else if (pos.y <= ship.inSightDepth)
          topBullet.rootRank = 1;
        else
          topBullet.rootRank = 0;
      } else {
        topBullet.rootRank = 0;
      }
    }
  }

  public void checkShotHit(Vector p, Collidable shape, Shot shot) {
    float ox = fabs(pos.x - p.x), oy = fabs(pos.y - p.y);
    if (ox > PI)
      ox = PI * 2 - ox;
    ox *= (tunnel.getRadius(pos.y) / SliceState.DEFAULT_RAD);
    ox *= 3;
    if (spec.shape.checkCollision(ox, oy, shape)) {
      shield -= shot.damage;
      if (shield <= 0) {
        destroyed();
      } else {
        damaged = true;
        Particle pt;
        for (int i = 0 ; i < 4; i++) {
          pt = particles.getInstance();
          if (pt)
            pt.set(pos, 1, rand.nextSignedFloat(0.1), rand.nextSignedFloat(1.6), 0.75,
                   1, 0.4 + rand.nextFloat(0.4), 0.3);
          pt = particles.getInstance();
          if (pt)
            pt.set(pos, 1, rand.nextSignedFloat(0.1) + PI, rand.nextSignedFloat(1.6), 0.75,
                   1, 0.4 + rand.nextFloat(0.4), 0.3);
        }
        SoundManager.playSe("hit.wav");
      }
      shot.addScore(spec.score, pos);
    }
  }

  private void destroyed() {
    for (int i = 0; i < 30; i++) {
      Particle pt = particles.getInstance();
      if (!pt)
        break;
      pt.set(pos, 1, rand.nextFloat(PI * 2),
             rand.nextSignedFloat(1), 0.01 + rand.nextFloat(0.1),
             1, 0.2 + rand.nextFloat(0.8), 0.4, 24);
    }
    spec.shape.addFragments(pos, particles);
    ship.rankUp(spec.isBoss);
    if (firstShield == 1) {
      SoundManager.playSe("small_dest.wav");
    } else if (firstShield < 20) {
      SoundManager.playSe("middle_dest.wav");
    } else {
      SoundManager.playSe("boss_dest.wav");
      ship.setScreenShake(56, 0.064f);
    }
    remove();
  }

  public void remove() {
    if (topBullet) {
      topBullet.removeForced();
      topBullet = null;
      if (bitBullet) {
        foreach (BulletActor bb; bitBullet) {
          bb.removeForced();
          bb = null;
        }
        bitBullet = null;
      }
    }
    exists = false;
  }

  public override void draw() {
    Vector3 sp = tunnel.getPos(pos);
    GL.pushMatrix();
    Screen.glTranslate(sp);
    GL.rotate((pos.x - bank) * 180 / PI, 0, 0, 1);
    if (sp.z > 200) {
      float sz = 1 - (sp.z - 200) * 0.0025;
      GL.scale(sz, sz, sz);
    }
    GL.rotate(d1 * 180 / PI, 0, 1, 0);
    GL.rotate(d2 * 180 / PI, 1, 0, 0);
    if (!damaged)
      spec.shape.draw();
    else
      spec.damagedShape.draw();
    GL.popMatrix();
    if (bitBullet) {
      foreach (BulletActor bb; bitBullet) {
        sp = tunnel.getPos(bb.bullet.pos);
        GL.pushMatrix();
        Screen.glTranslate(sp);
        GL.rotate(bitCnt * 7, 0, 1, 0);
        GL.rotate(pos.x * 180 / PI, 0, 0, 1);
        ShipSpec.bitShape.draw();
        GL.popMatrix();
      }
    }
  }
}

public class EnemyPool: ActorPool!(Enemy) {
 private:

  public this(int n, Object[] args) {
    super(n, args);
  }

  public void checkShotHit(Vector pos, Collidable shape, Shot shot) {
    foreach (Enemy e; actor)
      if (e.exists)
        e.checkShotHit(pos, shape, shot);
  }

  public int getNum() {
    int num = 0;
    foreach (Enemy e; actor)
      if (e.exists)
        num++;
    return num;
  }

  public void setPassedEnemies(EnemyPool pe) {
    foreach (Enemy e; actor)
      e.setPassedEnemies(pe);
  }

  public override void clear() {
    foreach (Enemy e; actor)
      if (e.exists)
        e.remove();
    super.clear();
  }
}
