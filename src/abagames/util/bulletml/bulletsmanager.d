/*
 * $Id: bulletsmanager.d,v 1.1.1.1 2004/11/10 13:45:22 kenta Exp $
 *
 * Copyright 2004 Kenta Cho. Some rights reserved.
 */
module abagames.util.bulletml.bulletsmanager;

private import bulletml;
private import abagames.util.bulletml.bullet;

/**
 * Interface for bullet's instances manager.
 */
public interface BulletsManager {
  public void addBullet(float deg, float speed);
  public void addBullet(BulletMLState *state, float deg, float speed);
  public int getTurn();
  public void killMe(Bullet bullet);
}

