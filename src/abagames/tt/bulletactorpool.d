/*
 * $Id: bulletactorpool.d,v 1.4 2005/01/02 05:49:31 kenta Exp $
 *
 * Copyright 2004 Kenta Cho. Some rights reserved.
 */
module abagames.tt.bulletactorpool;

import abagames.util.math;
import abagames.util.actor;
import abagames.util.vector;
import abagames.util.bulletml.bullet;
import abagames.util.bulletml.bulletsmanager;
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
      auto runner = new BulletMLRunnerType(nbi.getParser());
      BulletActorPool.registFunctions(runner);
      ba.set(runner, Bullet.now.pos.x, Bullet.now.pos.y, deg, speed);
      ba.setMorphSeed();
    } else {
      ba.set(Bullet.now.pos.x, Bullet.now.pos.y, deg, speed);
    }
  }

  public void addBullet(BulletMLStateType state, float deg, float speed) {
    //if ((cast(BulletImpl) Bullet.now).rootBullet.rootRank <= 0)
      //return;
    BulletActor rb = (cast(BulletImpl) Bullet.now).rootBullet;
    if (rb)
      if (rb.rootRank <= 0)
        return;
    BulletActor ba = cast(BulletActor) getInstance();
    if (!ba)
      return;
    auto runner = new BulletMLRunnerType(state);
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
    auto runner = new BulletMLRunnerType(nbi.getParser());
    BulletActorPool.registFunctions(runner);
    ba.set(runner, x, y, deg, speed);
    ba.setWait(prevWait, postWait);
    ba.setTop();
    return ba;
  }

  public BulletActor addMoveBullet(BulletMLParserType parser, float speed,
				   float x, float y, float deg, BulletTarget target) {
    BulletActor ba = getInstance();
    if (!ba)
      return null;
    BulletImpl bi = ba.bullet;
    bi.setParamFirst(null, null, null, 1, 1, false, target, ba);
    auto runner = new BulletMLRunnerType(parser);
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
  
  public static void registFunctions(BulletMLRunnerType) {
    BulletMLRunnerType.getBulletDirection = &getBulletDirection_;
    BulletMLRunnerType.getAimDirection = &getAimDirectionWithRev_;
    BulletMLRunnerType.getBulletSpeed = &getBulletSpeed_;
    BulletMLRunnerType.getDefaultSpeed = &getDefaultSpeed_;
    BulletMLRunnerType.getRank = &getRank_;
    BulletMLRunnerType.createSimpleBullet = &createSimpleBullet_;
    BulletMLRunnerType.createBullet = &createBullet_;
    BulletMLRunnerType.getTurn = &getTurn_;
    BulletMLRunnerType.doVanish = &doVanish_;

    BulletMLRunnerType.doChangeDirection = &doChangeDirection_;
    BulletMLRunnerType.doChangeSpeed = &doChangeSpeed_;
    BulletMLRunnerType.doAccelX = &doAccelX_;
    BulletMLRunnerType.doAccelY = &doAccelY_;
    BulletMLRunnerType.getBulletSpeedX = &getBulletSpeedX_;
    BulletMLRunnerType.getBulletSpeedY = &getBulletSpeedY_;
    BulletMLRunnerType.getRand = &getRand_;
  }
}

double getAimDirectionWithRev_(BulletMLRunnerType) {
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

