/*
 * $Id: bulletactor.d,v 1.4 2005/01/09 03:49:59 kenta Exp $
 *
 * Copyright 2004 Kenta Cho. Some rights reserved.
 */
module abagames.tt.bulletactor;

private import std.math;
private import std.c.stdarg;
private import opengl;
private import bulletml;
private import abagames.util.actor;
private import abagames.util.vector;
private import abagames.util.bulletml.bullet;
private import abagames.tt.bulletimpl;
private import abagames.tt.bullettarget;
private import abagames.tt.bulletactorpool;
private import abagames.tt.tunnel;
private import abagames.tt.ship;
private import abagames.tt.screen;
private import abagames.tt.shape;
private import abagames.tt.enemy;
private import abagames.tt.shot;

/**
 * Actor of an bullet controlled by BulletML.
 */
public class BulletActor: Actor {
 public:
  //static float totalBulletsSpeed;
  BulletImpl bullet;
  float rootRank;
 private:
  static const int DISAP_CNT = 45;
  static int nextId = 0;
  Tunnel tunnel;
  Ship ship;
  Vector ppos;
  int cnt;
  bool isSimple;
  bool isTop;
  bool isAimTop;
  bool isVisible;
  bool shouldBeRemoved;
  bool isWait;
  int postWait;  // Waiting count before a top(root) bullet rewinds the action.
  int waitCnt;
  bool isMorphSeed;  // Bullet marked as morph seed disappears after it morphs.
  int disapCnt;

  /*public static void resetTotalBulletsSpeed() {
    totalBulletsSpeed = 0;
  }*/

  public override void init(Object[] args) {
    tunnel = cast(Tunnel) args[0];
    ship = cast(Ship) args[1];
    bullet = new BulletImpl(nextId);
    nextId++;
    ppos = new Vector;
  }

  public void set(BulletMLRunner* runner,
                  float x, float y, float deg, float speed) {
    bullet.set(runner, x, y, deg, speed, 0);
    isSimple = false;
    start();
  }

  public void set(float x, float y, float deg, float speed) {
    bullet.set(x, y, deg, speed, 0);
    isSimple = true;
    start();
  }

  private void start() {
    isTop = isAimTop = false;
    isWait = false;
    isVisible = true;
    isMorphSeed = false;
    ppos.x = bullet.pos.x;
    ppos.y = bullet.pos.y;
    cnt = 0;
    rootRank = 1;
    shouldBeRemoved = false;
    disapCnt = 0;
    exists = true;
  }

  public void setInvisible() {
    isVisible = false;
  }

  public void setTop() {
    isTop = isAimTop = true;
    setInvisible();
  }

  public void unsetTop() {
    isTop = isAimTop = false;
  }

  public void unsetAimTop() {
    isAimTop = false;
  }

  public void setWait(int prvw, int pstw) {
    isWait = true;
    waitCnt = prvw;
    postWait = pstw;
  }

  public void setMorphSeed() {
    isMorphSeed = true;
  }

  public void rewind() {
    bullet.remove();
    bullet.resetParser();
    BulletMLRunner *runner = BulletMLRunner_new_parser(bullet.getParser());
    BulletActorPool.registFunctions(runner);
    bullet.setRunner(runner);
  }

  public void remove() {
    shouldBeRemoved = true;
  }

  public void removeForced() {
    if (!isSimple)
      bullet.remove();
    exists = false;
  }

  public void startDisappear() {
    if (isVisible && disapCnt <= 0)
      disapCnt = 1;
  }

  public override void move() {
    Vector tpos = bullet.target.getTargetPos();
    Bullet.target.x = tpos.x;
    Bullet.target.y = tpos.y;
    ppos.x = bullet.pos.x;
    ppos.y = bullet.pos.y;
    if (isAimTop) {
      float ox = tpos.x - bullet.pos.x;
      if (ox > PI)
        ox -= PI * 2;
      else if (ox < -PI)
        ox += PI * 2;
      bullet.deg = (atan2(ox, tpos.y - bullet.pos.y) * bullet.xReverse
		    + PI / 2) * bullet.yReverse - PI / 2;
    }
    if (isWait && waitCnt > 0) {
      waitCnt--;
      if (shouldBeRemoved)
        removeForced();
      return;
    }
    if (!isSimple) {
      bullet.move();
      if (bullet.isEnd()) {
        if (isTop) {
          rewind();
          if (isWait) {
            waitCnt = postWait;
            return;
          }
        } else if (isMorphSeed) {
          removeForced();
          return;
        }
      }
    }
    if (shouldBeRemoved) {
      removeForced();
      return;
     }
    float mx =
      (sin(bullet.deg) * bullet.speed + bullet.acc.x) *
        bullet.getSpeedRank() * bullet.xReverse;
    float my =
      (cos(bullet.deg) * bullet.speed - bullet.acc.y) *
        bullet.getSpeedRank() * bullet.yReverse;
    float d = atan2(mx, my);
    float r = 1 - fabs(sin(d)) * 0.999f;
    r *= (ship.speed * 5);
    bullet.pos.x += mx * r;
    bullet.pos.y += my * r;

    if (bullet.pos.x >= PI * 2)
      bullet.pos.x -= PI * 2;
    else if (bullet.pos.x < 0)
      bullet.pos.x += PI * 2;
    if (isVisible && disapCnt <= 0) {
      if (ship.checkBulletHit(bullet.pos, ppos))
        removeForced();
      if (bullet.pos.y < -2 ||
          (!bullet.longRange && bullet.pos.y > ship.inSightDepth) ||
          !tunnel.checkInScreen(bullet.pos, ship))
        startDisappear();
    }
    cnt++;
    if (disapCnt > 0) {
      disapCnt++;
      if (disapCnt > DISAP_CNT)
        removeForced();
    } else {
      if (cnt > 600)
        startDisappear();
    }
  }

  public void checkShotHit(Vector p, Collidable shape, Shot shot) {
    if (!isVisible || disapCnt > 0)
      return;
    float ox = fabs(bullet.pos.x - p.x), oy = fabs(bullet.pos.y - p.y);
    if (ox > PI)
      ox = PI * 2 - ox;
    ox *= (tunnel.getRadius(bullet.pos.y) / SliceState.DEFAULT_RAD);
    ox *= 3;
    if (shape.checkCollision(ox, oy)) {
      startDisappear();
      shot.addScore(10, bullet.pos);
    }
  }

  public override void draw() {
    if (!isVisible)
      return;
    float d = (bullet.deg * bullet.xReverse + PI / 2) * bullet.yReverse - PI / 2;
    Vector3 sp = tunnel.getPos(bullet.pos);
    glPushMatrix();
    glTranslatef(sp.x, sp.y, sp.z);
    glRotatef(d * 180 / PI, 0, 1, 0);
    glRotatef(cnt * 6, 0, 0, 1);
    if (disapCnt <= 0) {
      bullet.shape.draw();
    } else {
      float s = 1 - cast(float) disapCnt / DISAP_CNT;
      glScalef(s, s, s);
      bullet.disapShape.draw();
    }
    glPopMatrix();
  }
}
