/*
 * $Id: ship.d,v 1.7 2005/01/09 03:49:59 kenta Exp $
 *
 * Copyright 2004 Kenta Cho. Some rights reserved.
 */
module abagames.tt.ship;

private import std.math;
private import bindbc.opengl;
private import openglu;
private import abagames.util.vector;
private import abagames.util.rand;
private import abagames.util.sdl.pad;
private import abagames.util.sdl.recordablepad;
private import abagames.util.bulletml.bullet;
private import abagames.tt.tunnel;
private import abagames.tt.gamemanager;
private import abagames.tt.screen;
private import abagames.tt.shape;
private import abagames.tt.bullettarget;
private import abagames.tt.particle;
private import abagames.tt.letter;
private import abagames.tt.shot;
private import abagames.tt.stagemanager;
private import abagames.tt.soundmanager;
private import abagames.tt.camera;

/**
 * My ship.
 */
public class Ship: BulletTarget {
 public:
  static const float IN_SIGHT_DEPTH_DEFAULT = 35;
  static const float RELPOS_MAX_Y = 10;
  static enum Grade {
    NORMAL, HARD, EXTREME,
  };
  static const int GRADE_NUM = 3;
  static const string[] GRADE_LETTER = ["N", "H", "E"];
  static const string[] GRADE_STR = ["NORMAL", "HARD", "EXTREME"];
  static bool replayMode, cameraMode, drawFrontMode;
  bool isGameOver;
 private:
  static const int RESTART_CNT = 268;
  static const int INVINCIBLE_CNT = 228;
  static const float HIT_WIDTH = 0.00025;
  static const float EYE_HEIGHT = 0.8f;
  static const float LOOKAT_HEIGHT = 0.9f;
  Rand rand;
  RecordablePad pad;
  Tunnel tunnel;
  ShotPool shots;
  ParticlePool particles;
  InGameState gameState;
  Vector _pos;  // Absolute position in the torus.
  Vector _relPos;  // Relative position in the visual range.
  Vector _eyePos;
  Vector rocketPos;
  float d1, d2;
  int grade;
  float nextStarAppDist;
  Vector starPos;
  int lap;

  // Speed and max bank angle change according to the game's grade.
  static const float[] SPEED_DEFAULT = [0.4, 0.6, 0.8];
  static const float[] SPEED_MAX = [0.8, 1.2, 1.6];
  static const float[] ACCEL_RATIO = [0.002, 0.003, 0.004];
  float targetSpeed;
  float _speed;
  float _inSightDepth;  // A visual range in which enemies can fire bullets.

  static const float[] BANK_MAX_DEFAULT = [0.8, 1.0, 1.2];
  static const float OUT_OF_COURSE_BANK = 1.0;
  static const float RELPOS_Y_MOVE = 0.1;
  float bank;
  float bankMax;
  float tunnelOfs;  // Offset from the slice of a tunnel(torus).
  Vector3 pos3;
  ShipShape _shape;
  Vector3 epos;

  Shot chargingShot;
  static const int FIRE_INTERVAL = 2;
  static const int STAR_SHELL_INTERVAL = 7;
  float regenerativeCharge;
  int fireCnt;
  static const float GUNPOINT_WIDTH = 0.05;
  int fireShotCnt;
  int sideFireCnt;
  int sideFireShotCnt;
  Vector gunpointPos;

  int rank;
  int bossAppRank, bossAppNum, zoneEndRank;
  bool _inBossMode;
  bool _isBossModeEnd;
  int cnt;

  int screenShakeCnt;
  float screenShakeIntense;
  Camera camera;

  bool btnPressed;

  public this(Pad pad, Tunnel tunnel) {
    rand = new Rand;
    this.pad = cast(RecordablePad) pad;
    this.tunnel = tunnel;
    _pos = new Vector;
    _relPos = new Vector;
    _eyePos = new Vector;
    rocketPos = new Vector;
    starPos = new Vector;
    pos3 = new Vector3;
    epos = new Vector3;
    _shape = new ShipShape();
    shape.create(1, ShipShape.Type.SMALL);
    gunpointPos = new Vector;
    camera = new Camera(this);
    drawFrontMode = true;
    cameraMode = true;
  }

  public void setParticles(ParticlePool particles) {
    this.particles = particles;
  }

  public void setShots(ShotPool shots) {
    this.shots = shots;
  }

  public void setGameState(InGameState gameState) {
    this.gameState = gameState;
  }

  public void start(int grd, long seed) {
    rand.setSeed(seed);
    grade = grd;
    tunnelOfs = 0;
    _pos.x = _pos.y = 0;
    _relPos.x = _relPos.y = 0;
    _eyePos.x = _eyePos.y = 0;
    bank = 0;
    _speed = 0;
    d1 = d2 = 0;
    cnt = -INVINCIBLE_CNT;
    fireShotCnt = sideFireShotCnt = 0;
    _inSightDepth = IN_SIGHT_DEPTH_DEFAULT;
    rank = 0;
    bankMax = BANK_MAX_DEFAULT[grade];
    nextStarAppDist = 0;
    lap = 1;
    isGameOver = false;
    restart();
    if (replayMode)
      camera.start();
    btnPressed = true;
  }

  public void restart() {
    targetSpeed = 0;
    fireCnt = 0;
    sideFireCnt = 99999;
    if (chargingShot) {
      chargingShot.remove();
      chargingShot = null;
    }
    regenerativeCharge = 0;
  }

  public void close() {
    _shape.close();
  }

  public void move() {
    cnt++;
    int btn, dir;
    if (!replayMode) {
      btn = pad.getButtonState();
      dir = pad.getDirState();
      pad.record();
    } else {
      int ps = pad.replay();
      if (ps == RecordablePad.REPLAY_END) {
        ps = 0;
        isGameOver = true;
      }
      dir = ps & (Pad.Dir.UP | Pad.Dir.DOWN | Pad.Dir.LEFT | Pad.Dir.RIGHT);
      btn = ps & Pad.Button.ANY;
    }
    if (btnPressed) {
      if (btn)
        btn = 0;
      else
        btnPressed = false;
    }
    if (isGameOver) {
      btn = dir = 0;
      _speed *= 0.9f;
      clearVisibleBullets();
      if (cnt < -INVINCIBLE_CNT)
        cnt = -RESTART_CNT;
    } else if (cnt < -INVINCIBLE_CNT) {
      btn = dir = 0;
      _relPos.y *= 0.99f;
      clearVisibleBullets();
    }
    float as = targetSpeed;
    if (btn & Pad.Button.B) {
      as *= 0.5f;
    } else {
      float acc = regenerativeCharge * 0.1f;
      _speed += acc;
      as += acc;
      regenerativeCharge -= acc;
    }
    if (_speed < as) {
      _speed += (as - _speed) * 0.015f;
    } else {
      if (btn & Pad.Button.B)
        regenerativeCharge -= (as - _speed) * 0.05f;
      _speed += (as - _speed) * 0.05f;
    }
    _pos.y += _speed;
    tunnelOfs += _speed;
    int tmv = cast(int) tunnelOfs;
    tunnel.goToNextSlice(tmv);
    addScore(tmv);
    tunnelOfs = _pos.y - cast(int) _pos.y;
    if (pos.y >= tunnel.getTorusLength()) {
      pos.y -= tunnel.getTorusLength();
      lap++;
    }

    tunnel.setShipPos(_relPos.x, tunnelOfs, _pos.y);
    tunnel.setSlices();
    tunnel.setSlicesBackward();
    Vector3 sp = tunnel.getPos(_relPos);
    pos3.x = sp.x;
    pos3.y = sp.y;
    pos3.z = sp.z;

    if (dir & Pad.Dir.RIGHT)
      bank += (-bankMax - bank) * 0.1f;
    if (dir & Pad.Dir.LEFT)
      bank += (bankMax - bank) * 0.1f;
    bool overAccel = false;
    if (dir & Pad.Dir.UP) {
      if (_relPos.y < RELPOS_MAX_Y) {
        _relPos.y += RELPOS_Y_MOVE;
      } else {
        targetSpeed += ACCEL_RATIO[grade];
        if (!(btn & Pad.Button.B) && !_inBossMode && !_isBossModeEnd)
          overAccel = true;
      }
    }
    if (dir & Pad.Dir.DOWN && _relPos.y > 0)
      _relPos.y -= RELPOS_Y_MOVE;
    float acc = _relPos.y * (SPEED_MAX[grade] - SPEED_DEFAULT[grade]) / RELPOS_MAX_Y +
      SPEED_DEFAULT[grade];
    if (overAccel)
      targetSpeed += (acc - targetSpeed) * 0.001f;
    else if (targetSpeed < acc)
      targetSpeed += (acc - targetSpeed) * 0.005f;
    else
      targetSpeed += (acc - targetSpeed) * 0.03f;
    _inSightDepth = IN_SIGHT_DEPTH_DEFAULT * (1 + _relPos.y / RELPOS_MAX_Y);
    if (_speed > SPEED_MAX[grade])
      _inSightDepth += IN_SIGHT_DEPTH_DEFAULT * (_speed - SPEED_MAX[grade]) / SPEED_MAX[grade] * 3.0f;
    bank *= 0.9f;
    _pos.x += bank * 0.08f * (SliceState.DEFAULT_RAD / tunnel.getRadius(_relPos.y));
    if (_pos.x < 0)
      _pos.x += PI * 2;
    else if (_pos.x >= PI * 2)
      _pos.x -= PI * 2;
    _relPos.x = _pos.x;
    float ox = _relPos.x - _eyePos.x;
    if (ox > PI)
      ox -= PI * 2;
    else if (ox < -PI)
      ox += PI * 2;
    _eyePos.x += ox * 0.1f;
    if (_eyePos.x < 0)
      _eyePos.x += PI * 2;
    else if (_eyePos.x >= PI * 2)
      _eyePos.x -= PI * 2;
    Slice sl = tunnel.getSlice(_relPos.y);
    float co = tunnel.checkInCourse(_relPos);
    if (co != 0) {
      float bm = (-OUT_OF_COURSE_BANK * co - bank) * 0.075f;
      if (bm > 1)
        bm = 1;
      else if (bm < -1)
        bm = -1;
      _speed *= (1 - fabs(bm));
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
      _relPos.x = _pos.x;
    }
    d1 += (sl.d1 - d1) * 0.05;
    d2 += (sl.d2 - d2) * 0.05;

    if (btn & Pad.Button.B) {
      if (!chargingShot) {
        chargingShot = shots.getInstanceForced();
        chargingShot.set(true);
      }
    } else {
      if (chargingShot) {
        chargingShot.release();
        chargingShot = null;
      }
      if (btn & Pad.Button.A) {
        if (fireCnt <= 0) {
          fireCnt = FIRE_INTERVAL;
          Shot shot = shots.getInstance();
          if (shot) {
            if ((fireShotCnt % STAR_SHELL_INTERVAL) == 0)
              shot.set(false, true);
            else
              shot.set();
            gunpointPos.x = _relPos.x + GUNPOINT_WIDTH * ((fireShotCnt % 2) * 2 - 1);
            gunpointPos.y = _relPos.y;
            shot.update(gunpointPos);
            fireShotCnt++;
          }
        }
        if (sideFireCnt <= 0) {
          sideFireCnt = 99999;
          Shot shot = shots.getInstance();
          if (shot) {
            float sideFireDeg =
              (speed - SPEED_DEFAULT[grade]) / (SPEED_MAX[grade] - SPEED_DEFAULT[grade]) * 0.1f;
            if (sideFireDeg < 0.01f)
              sideFireDeg = 0.01f;
            float d = sideFireDeg * (sideFireShotCnt % 5) * 0.2;
            if ((sideFireShotCnt % 2) == 1)
              d = -d;
            if ((sideFireShotCnt % STAR_SHELL_INTERVAL) == 0)
              shot.set(false, true, d);
            else
              shot.set(false, false, d);
            gunpointPos.x = _relPos.x + GUNPOINT_WIDTH * ((fireShotCnt % 2) * 2 - 1);
            gunpointPos.y = _relPos.y;
            shot.update(gunpointPos);
            sideFireShotCnt++;
          }
        }
      }
    }
    if (fireCnt > 0)
      fireCnt--;
    int ssc = 99999;
    if (speed > SPEED_DEFAULT[grade] * 1.33f) {
      ssc = cast(int) (100000 /
                       ((speed - SPEED_DEFAULT[grade] * 1.33f) * 99999 /
                        (SPEED_MAX[grade] - SPEED_DEFAULT[grade]) + 1));
    }
    if (sideFireCnt > ssc)
      sideFireCnt = ssc;
    if (sideFireCnt > 0)
      sideFireCnt--;
    rocketPos.x = _relPos.x - bank * 0.1;
    rocketPos.y = _relPos.y;
    if (chargingShot)
      chargingShot.update(rocketPos);
    if (cnt >= -INVINCIBLE_CNT)
      shape.addParticles(rocketPos, particles);
    nextStarAppDist -= speed;
    if (nextStarAppDist <= 0) {
      for (int i = 0; i < 5; i++) {
        Particle pt = particles.getInstance();
        if (!pt)
          break;
        starPos.x = relPos.x + rand.nextSignedFloat(PI / 2) + PI;
        starPos.y = 32;
        pt.set(starPos, -8 - rand.nextFloat(56), PI, 0, 0,
               0.6, 0.7, 0.9, 100, Particle.PType.STAR);
      }
      nextStarAppDist = 1;
    }
    if (screenShakeCnt > 0)
      screenShakeCnt--;
    if (replayMode)
      camera.move();
  }

  private void addBoostParticles(int n, float sp) {
    for (int i = 0; i < n; i++) {
      Particle pt = particles.getInstanceForced();
      pt.set(relPos, 1, rand.nextSignedFloat(PI * 0.01),
             0, sp + rand.nextSignedFloat(0.25),
             0.9, 0.5, 1.0);
    }
  }
  
  public Vector getTargetPos() {
    return _relPos;
  }

  public void setEyepos() {
    float ex, ey, ez;
    float lx, ly, lz;
    float deg;
    if (!replayMode || !cameraMode) {
      epos.x = _eyePos.x;
      epos.y = -1.1f;
      epos.y += _relPos.y * 0.3f;
      epos.z = 30.0f;
      Vector3 ep3 = tunnel.getPos(epos);
      ex = ep3.x;
      ey = ep3.y;
      ez = ep3.z;
      epos.x = _eyePos.x;
      epos.y += 6.0f;
      epos.y += _relPos.y * 0.3f;
      epos.z = 0;
      Vector3 lp3 = tunnel.getPos(epos);
      lx = lp3.x;
      ly = lp3.y;
      lz = lp3.z;
      deg = _eyePos.x;
    } else {
      Vector3 ep3 = tunnel.getPos(camera.cameraPos);
      ex = ep3.x;
      ey = ep3.y;
      ez = ep3.z;
      Vector3 lp3 = tunnel.getPos(camera.lookAtPos);
      lx = lp3.x;
      ly = lp3.y;
      lz = lp3.z;
      deg = camera.deg;
      glMatrixMode(GL_PROJECTION);
      glLoadIdentity();
      float np = Screen.nearPlane * camera.zoom;
      glFrustum(-np,
                np,
                -np * cast(GLfloat) Screen.height / cast(GLfloat) Screen.width,
                np * cast(GLfloat) Screen.height / cast(GLfloat) Screen.width,
                0.1f, Screen.farPlane);
      glMatrixMode(GL_MODELVIEW);
    }
    if (screenShakeCnt > 0) {
      float mx = rand.nextSignedFloat(screenShakeIntense * (screenShakeCnt + 6));
      float my = rand.nextSignedFloat(screenShakeIntense * (screenShakeCnt + 6));
      float mz = rand.nextSignedFloat(screenShakeIntense * (screenShakeCnt + 6));
      ex += mx;
      ey += my;
      ez += mz;
      lx += mx;
      ly += my;
      lz += mz;
    }
    gluLookAt(ex, ey, ez,
	      lx, ly, lz,
	      sin(deg), -cos(deg) , 0);
  }

  public void setScreenShake(int cnt, float its) {
    screenShakeCnt = cnt;
    screenShakeIntense = its;
  }

  public bool checkBulletHit(Vector p, Vector pp) {
    if (cnt <= 0)
      return false;
    float bmvx, bmvy, inaa;
    bmvx = pp.x;
    bmvy = pp.y;
    bmvx -= p.x;
    bmvy -= p.y;
    if (bmvx > PI)
      bmvx -= PI * 2;
    else if (bmvx < -PI)
      bmvx += PI * 2;
    inaa = bmvx * bmvx + bmvy * bmvy;
    if (inaa > 0.00001) {
      float sofsx, sofsy, inab, hd;
      sofsx = _relPos.x;
      sofsy = _relPos.y;
      sofsx -= p.x;
      sofsy -= p.y;
      if (sofsx > PI)
        sofsx -= PI * 2;
      else if (sofsx < -PI)
        sofsx += PI * 2;
      inab = bmvx * sofsx + bmvy * sofsy;
      if (inab >= 0 && inab <= inaa) {
        hd = sofsx * sofsx + sofsy * sofsy - inab * inab / inaa;
        if (hd >= 0 && hd <= HIT_WIDTH) {
          destroyed();
          return true;
        }
      }
    }
    return false;
  }

  private void destroyed() {
    if (cnt <= 0)
      return;
    for (int i = 0; i < 256; i++) {
      Particle pt = particles.getInstanceForced();
      pt.set(relPos, 1, rand.nextSignedFloat(PI / 8),
             rand.nextSignedFloat(2.5), 0.5 + rand.nextFloat(1),
             1, 0.2 + rand.nextFloat(0.8), 0.2, 32);
    }
    gameState.shipDestroyed();
    SoundManager.playSe("myship_dest.wav");
    setScreenShake(32, 0.05f);
    restart();
    cnt = -RESTART_CNT;
  }

  public bool hasCollision() {
    if (cnt < -INVINCIBLE_CNT)
      return false;
    else
      return true;
  }

  public void rankUp(bool isBoss) {
    if ((_inBossMode && !isBoss) || isGameOver)
      return;
    if (_inBossMode) {
      bossAppNum--;
      if (bossAppNum <= 0) {
        rank++;
        gameState.gotoNextZone();
        _inBossMode = false;
        _isBossModeEnd = true;
        bossAppRank = 9999999;
        return;
      }
    }
    rank++;
    if (rank >= bossAppRank)
      _inBossMode = true;
  }

  public void gotoNextZoneForced() {
    bossAppNum = 0;
    _inBossMode = false;
    _isBossModeEnd = true;
    bossAppRank = 9999999;
  }

  public void startNextZone() {
    _isBossModeEnd = false;
  }

  public void rankDown() {
    if (_inBossMode)
      return;
    rank--;
  }

  public void setBossApp(int rank, int num, int zoneEndRank) {
    bossAppRank = rank;
    bossAppNum = num;
    this.zoneEndRank = zoneEndRank;
    _inBossMode = false;
  }

  public void addScore(int sc) {
    gameState.addScore(sc);
  }

  public void clearVisibleBullets() {
    gameState.clearVisibleBullets();
  }

  public void draw() {
    if (cnt < -INVINCIBLE_CNT || (cnt < 0 && (-cnt % 32) < 16))
      return;
    glPushMatrix();
    glTranslatef(pos3.x, pos3.y, pos3.z);
    glRotatef((pos.x - bank) * 180 / PI, 0, 0, 1);
    glRotatef(d1 * 180 / PI, 0, 1, 0);
    glRotatef(d2 * 180 / PI, 1, 0, 0);
    _shape.draw();
    glPopMatrix();
  }

  public void drawFront() {
    Letter.drawNum(cast(int) (speed * 2500), 490, 420, 20);
    Letter.drawString("KM/H", 540, 445, 12);
    Letter.drawNum(rank, 150, 432, 16);
    Letter.drawString("/", 185, 448, 10);
    Letter.drawNum(zoneEndRank - rank, 250, 448, 10);
    /*Letter.drawString("LAP", 20, 388, 8, Letter.Direction.TO_RIGHT, 1);
    Letter.drawNum(lap, 120, 388, 8);
    Letter.drawString(".", 130, 386, 8);
    Letter.drawNum(cast(int) (pos.y * 1000000 / tunnel.getTorusLength()), 230, 388, 8,
                   Letter.Direction.TO_RIGHT, 0, 6);*/
  }

  public Vector pos() {
    return _pos;
  }

  public Vector relPos() {
    return _relPos;
  }

  public Vector eyePos() {
    return _eyePos;
  }

  public float speed() {
    return _speed;
  }

  public ShipShape shape() {
    return _shape;
  }

  public float inSightDepth() {
    return _inSightDepth;
  }

  public bool inBossMode() {
    return _inBossMode;
  }

  public bool isBossModeEnd() {
    return _isBossModeEnd;
  }
}
