/*
 * $Id: bullettarget.d,v 1.1.1.1 2004/11/10 13:45:22 kenta Exp $
 *
 * Copyright 2004 Kenta Cho. Some rights reserved.
 */
module abagames.tt.bullettarget;

private import abagames.util.vector;

/**
 * Target that is aimed by bullets.
 */
public interface BulletTarget {
 public:
  Vector getTargetPos();
}

public class VirtualBulletTarget: BulletTarget {
 public:
  Vector pos;
 private:

  public this() {
    pos = new Vector;
  }

  public Vector getTargetPos() {
    return pos;
  }
}
