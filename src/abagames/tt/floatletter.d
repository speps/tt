/*
 * $Id: floatletter.d,v 1.2 2005/01/01 12:40:27 kenta Exp $
 *
 * Copyright 2004 Kenta Cho. Some rights reserved.
 */
module abagames.tt.floatletter;

private import std.math;
private import bindbc.opengl;
private import abagames.util.actor;
private import abagames.util.vector;
private import abagames.util.rand;
private import abagames.tt.letter;
private import abagames.tt.tunnel;
private import abagames.tt.screen;

/**
 * Floating letters(display the multiplier).
 */
public class FloatLetter: Actor {
 private:
  static Rand rand;
  Tunnel tunnel;
  Vector3 pos;
  float mx, my;
  float d;
  float size;
  string msg;
  int cnt;
  float alpha;

  public static void setRandSeed(long seed) {
    if (!rand) {
      rand = new Rand;
    }
    rand.setSeed(seed);
  }

  public override void init(Object[] args) {
    tunnel = cast(Tunnel) args[0];
    pos = new Vector3;
  }

  public void set(string m, Vector p, float s, int c = 120) {
    pos.x = p.x;
    pos.y = p.y;
    pos.z = 1;
    mx = rand.nextSignedFloat(0.001);
    my = -rand.nextFloat(0.2) + 0.2f;
    d = p.x;
    size = s;
    msg = m;
    cnt = c;
    alpha = 0.8f;
    exists = true;
  }

  public override void move() {
    pos.x += mx * pos.y;
    pos.y += my;
    pos.z -= 0.03f * pos.y;
    cnt--;
    if (cnt < 0)
      exists = false;
    if (alpha >= 0.03f)
      alpha -= 0.03f;
  }

  public override void draw() {
    glPushMatrix();
    Vector3 sp = tunnel.getPos(pos);
    glTranslatef(0, 0, sp.z);
    Screen.setColor(1, 1, 1, 1);
    Letter.drawString(msg, sp.x, sp.y, size, Letter.Direction.TO_RIGHT, 2, false, d  * 180 / PI);
    Screen.setColor(1, 1, 1, alpha);
    Letter.drawString(msg, sp.x, sp.y, size, Letter.Direction.TO_RIGHT, 3, false, d  * 180 / PI);
    glPopMatrix();
  }
}

public class FloatLetterPool: ActorPool!(FloatLetter) {
  public this(int n, Object[] args) {
    super(n, args);
  }
}
