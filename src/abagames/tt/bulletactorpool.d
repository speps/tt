/*
 * $Id: bulletactorpool.d,v 1.4 2005/01/02 05:49:31 kenta Exp $
 *
 * Copyright 2004 Kenta Cho. Some rights reserved.
 */
module abagames.tt.bulletactorpool;

import std.math;
import bulletml;
import abagames.util.actor;
import abagames.util.vector;
import abagames.util.bulletml.bullet;
import abagames.util.bulletml.bulletsmanager;
import abagames.util.sdl.luminous;
import abagames.tt.bulletactor;
import abagames.tt.bulletimpl;
import abagames.tt.bullettarget;
import abagames.tt.tunnel;
import abagames.tt.ship;
import abagames.tt.shot;
import abagames.tt.shape;

/**
 * Bullet actor pool that works as BulletsManager.
 */
public class BulletActorPool: ActorPool!(BulletActor), BulletsManager {
 private:
  int cnt;

  public this(int n, Object[] args) {
    super(n, args);
    Bullet.setBulletsManager(this);
    cnt = 0;
  }

  public void addBullet(float deg, float speed) {
    //if ((cast(BulletImpl) Bullet.now).rootBullet.rootRank <= 0)
      //return;
    BulletActor rb = (cast(BulletImpl) Bullet.now).rootBullet;
    if (rb)
      if (rb.rootRank <= 0)
        return;
    BulletActor ba = cast(BulletActor) getInstance();
    if (!ba)
      return;
    BulletImpl nbi = ba.bullet;
    nbi.setParam(cast(BulletImpl) Bullet.now);
    if (nbi.gotoNextParser()) {
      BulletMLRunner *runner = BulletMLRunner_new_parser(nbi.getParser());
      BulletActorPool.registFunctions(runner);
      ba.set(runner, Bullet.now.pos.x, Bullet.now.pos.y, deg, speed);
      ba.setMorphSeed();
    } else {
      ba.set(Bullet.now.pos.x, Bullet.now.pos.y, deg, speed);
    }
  }

  public void addBullet(BulletMLState *state, float deg, float speed) {
    //if ((cast(BulletImpl) Bullet.now).rootBullet.rootRank <= 0)
      //return;
    BulletActor rb = (cast(BulletImpl) Bullet.now).rootBullet;
    if (rb)
      if (rb.rootRank <= 0)
        return;
    BulletActor ba = cast(BulletActor) getInstance();
    if (!ba)
      return;
    BulletMLRunner* runner = BulletMLRunner_new_state(state);
    registFunctions(runner);
    BulletImpl nbi = ba.bullet;
    nbi.setParam(cast(BulletImpl) Bullet.now);
    ba.set(runner, Bullet.now.pos.x, Bullet.now.pos.y, deg, speed);
  }

  public BulletActor addTopBullet(ParserParam[] parserParam,
				  float x, float y, float deg, float speed,
				  Drawable shape, Drawable disapShape,
				  float xReverse, float yReverse, bool longRange,
				  BulletTarget target,
				  int prevWait, int postWait) {
    BulletActor ba = getInstance();
    if (!ba)
      return null;
    BulletImpl nbi = ba.bullet;
    nbi.setParamFirst(parserParam, shape, disapShape,
                      xReverse, yReverse, longRange, target, ba);
    BulletMLRunner *runner = BulletMLRunner_new_parser(nbi.getParser());
    BulletActorPool.registFunctions(runner);
    ba.set(runner, x, y, deg, speed);
    ba.setWait(prevWait, postWait);
    ba.setTop();
    return ba;
  }

  public BulletActor addMoveBullet(BulletMLParser *parser, float speed,
				   float x, float y, float deg, BulletTarget target) {
    BulletActor ba = getInstance();
    if (!ba)
      return null;
    BulletImpl bi = ba.bullet;
    bi.setParamFirst(null, null, null, 1, 1, false, target, ba);
    BulletMLRunner *runner = BulletMLRunner_new_parser(parser);
    BulletActorPool.registFunctions(runner);
    ba.set(runner, x, y, deg, speed);
    ba.setInvisible();
    return ba;
  }

  public override void move() {
    super.move();
    cnt++;
  }

  public override void draw() {
    foreach (BulletActor ba; actor)
      if (ba.exists)
        ba.draw();
  }

  public int getTurn() {
    return cnt;
  }

  public void killMe(Bullet bullet) {
    assert((cast(BulletActor) actor[bullet.id]).bullet.id == bullet.id);
    (cast(BulletActor) actor[bullet.id]).remove();
  }

  public override void clear() {
    foreach (BulletActor ba; actor)
      if (ba.exists)
        ba.removeForced();
    actorIdx = 0;
    cnt = 0;
  }

  public void clearVisible() {
    foreach (BulletActor ba; actor)
      if (ba.exists)
        ba.startDisappear();
  }

  public void checkShotHit(Vector pos, Collidable shape, Shot shot) {
    foreach (BulletActor ba; actor)
      if (ba.exists)
        ba.checkShotHit(pos, shape, shot);
  }
  
  public static void registFunctions(BulletMLRunner* runner) {
    BulletMLRunner_set_getBulletDirection(runner, &getBulletDirection_);
    BulletMLRunner_set_getAimDirection(runner, &getAimDirectionWithRev_);
    BulletMLRunner_set_getBulletSpeed(runner, &getBulletSpeed_);
    BulletMLRunner_set_getDefaultSpeed(runner, &getDefaultSpeed_);
    BulletMLRunner_set_getRank(runner, &getRank_);
    BulletMLRunner_set_createSimpleBullet(runner, &createSimpleBullet_);
    BulletMLRunner_set_createBullet(runner, &createBullet_);
    BulletMLRunner_set_getTurn(runner, &getTurn_);
    BulletMLRunner_set_doVanish(runner, &doVanish_);

    BulletMLRunner_set_doChangeDirection(runner, &doChangeDirection_);
    BulletMLRunner_set_doChangeSpeed(runner, &doChangeSpeed_);
    BulletMLRunner_set_doAccelX(runner, &doAccelX_);
    BulletMLRunner_set_doAccelY(runner, &doAccelY_);
    BulletMLRunner_set_getBulletSpeedX(runner, &getBulletSpeedX_);
    BulletMLRunner_set_getBulletSpeedY(runner, &getBulletSpeedY_);
    BulletMLRunner_set_getRand(runner, &getRand_);
  }
}

extern (C) {
  double getAimDirectionWithRev_(BulletMLRunner* r) {
    Vector b = Bullet.now.pos;
    Vector t = Bullet.target;
    float xrev = (cast(BulletImpl) Bullet.now).xReverse;
    float yrev = (cast(BulletImpl) Bullet.now).yReverse;
    float ox = t.x - b.x;
    if (ox > PI)
      ox -= PI * 2;
    else if (ox < -PI)
      ox += PI * 2;
    return rtod((atan2(ox, t.y - b.y) * xrev + PI / 2) * yrev - PI / 2);
  }
}

