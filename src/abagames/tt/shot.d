/*
 * $Id: shot.d,v 1.4 2005/01/02 05:49:31 kenta Exp $
 *
 * Copyright 2004 Kenta Cho. Some rights reserved.
 */
module abagames.tt.shot;

private import std.conv;
private import std.math;
private import std.string;
private import bindbc.opengl;
private import abagames.util.actor;
private import abagames.util.vector;
private import abagames.util.rand;
private import abagames.tt.tunnel;
private import abagames.tt.shape;
private import abagames.tt.screen;
private import abagames.tt.enemy;
private import abagames.tt.bulletactorpool;
private import abagames.tt.floatletter;
private import abagames.tt.particle;
private import abagames.tt.ship;
private import abagames.tt.soundmanager;

/**
 * Player's shot.
 */
public class Shot: Actor {
 private:
  static const float SPEED = 0.75;
  static const float RANGE_MIN = 2;
  static const float SIZE_MIN = 0.1;
  static const int MAX_CHARGE = 90;
  static const float SIZE_RATIO = 0.15;
  static const float RANGE_RATIO = 0.5;
  static const float CHARGE_RELEASE_RATIO = 0.25;
  static const int MAX_MULTIPLIER = 100;
  static ShotShape shotShape, chargeShotShape;
  static Rand rand;
  Tunnel tunnel;
  EnemyPool enemies;
  BulletActorPool bullets;
  FloatLetterPool floatLetters;
  ParticlePool particles;
  Ship ship;
  Vector pos;
  int chargeCnt, chargeSeCnt;
  int cnt;
  float range;
  float size, trgSize;
  bool chargeShot;
  bool inCharge;
  bool starShell;
  ResizableDrawable shape;
  int multiplier;
  int _damage;
  float deg;

  public static void init() {
    shotShape = new ShotShape;
    shotShape.create(false);
    chargeShotShape = new ShotShape;
    chargeShotShape.create(true);
    rand = new Rand;
  }

  public static void setRandSeed(long seed) {
    rand.setSeed(seed);
  }

  public static void close() {
    shotShape.close();
  }

  public override void init(Object[] args) {
    tunnel = cast(Tunnel) args[0];
    enemies = cast(EnemyPool) args[1];
    bullets = cast(BulletActorPool) args[2];
    floatLetters = cast(FloatLetterPool) args[3];
    particles = cast(ParticlePool) args[4];
    ship = cast(Ship) args[5];
    pos = new Vector;
    shape = new ResizableDrawable;
  }

  public void set(bool charge = false, bool star = false, float d = 0) {
    cnt = 0;
    multiplier = 1;
    if (charge) {
      chargeShot = inCharge = true;
      range = 0;
      chargeCnt = chargeSeCnt = 0;
      size = trgSize = 0;
      _damage = 100;
      starShell = false;
      deg = d;
      shape.shape = chargeShotShape;
    } else {
      chargeShot = inCharge = false;
      range = Ship.IN_SIGHT_DEPTH_DEFAULT;
      chargeCnt = chargeSeCnt = 0;
      size = trgSize = 1;
      _damage = 1;
      starShell = star;
      deg = d;
      shape.shape = shotShape;
      SoundManager.playSe("shot.wav");
    }
    exists = true;
  }

  public void update(Vector p) {
    pos.x = p.x;
    pos.y = p.y + 0.3;
  }

  public void release() {
    if (chargeCnt < MAX_CHARGE * CHARGE_RELEASE_RATIO) {
      remove();
      return;
    }
    inCharge = false;
    range = RANGE_MIN + chargeCnt * RANGE_RATIO;
    trgSize = SIZE_MIN + chargeCnt * SIZE_RATIO;
    SoundManager.playSe("charge_shot.wav");
  }

  public void remove() {
    exists = false;
  }

  public override void move() {
    if (inCharge) {
      if (chargeCnt < MAX_CHARGE) {
        chargeCnt++;
        trgSize = (SIZE_MIN + chargeCnt * SIZE_RATIO) * 0.33f;
      }
      if ((chargeSeCnt % 52) == 0)
        SoundManager.playSe("charge.wav");
      chargeSeCnt++;
    } else {
      pos.x += sin(deg) * SPEED;
      pos.y += cos(deg) * SPEED;
      range -= SPEED;
      if (range <= 0)
        remove();
      else if (range < 10)
        trgSize *= 0.75;
    }
    size += (trgSize - size) * 0.1;
    shape.size = size;
    if (!inCharge) {
      if (chargeShot)
        bullets.checkShotHit(pos, shape, this);
      enemies.checkShotHit(pos, shape, this);
    }
    if (starShell || chargeCnt > MAX_CHARGE * CHARGE_RELEASE_RATIO) {
      int pn = 1;
      if (chargeShot)
        pn = 3;
      for (int i = 0; i < pn; i++) {
        Particle pt = particles.getInstance();
        if (pt)
          pt.set(pos, 1, rand.nextSignedFloat(PI / 2) + PI, rand.nextSignedFloat(0.5), 0.05,
                 0.6, 1, 0.8, chargeCnt * 32 / MAX_CHARGE + 4);
      }
    }
    cnt++;
  }

  public void addScore(int sc, Vector pos) {
    ship.addScore(sc * multiplier);
    if (multiplier > 1) {
      FloatLetter fl = floatLetters.getInstanceForced();
      float size = 0.07;
      if (sc >= 100)
        size = 0.2;
      else if (sc >= 500)
        size = 0.4;
      else if (sc >= 2000)
        size = 0.7;
      size *= (1 + multiplier * 0.01f);
      fl.set("X" ~ to!string(multiplier), pos, size * pos.y,
             cast(int) (30 + multiplier * 0.3f));
    }
    if (chargeShot) {
      if (multiplier < MAX_MULTIPLIER)
        multiplier++;
    } else {
      remove();
    }
  }

  public override void draw() {
    Vector3 sp = tunnel.getPos(pos);
    glPushMatrix();
    Screen.glTranslate(sp);
    glRotatef(deg * 180 / PI, 0, 1, 10);
    glRotatef(cnt * 7, 0, 0, 1);
    shape.draw();
    glPopMatrix();
  }

  public int damage() {
    return _damage;
  }
}

public class ShotPool: ActorPool!(Shot) {
  public this(int n, Object[] args) {
    super(n, args);
  }
}
