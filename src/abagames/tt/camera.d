/*
 * $Id: camera.d,v 1.4 2005/01/09 03:49:59 kenta Exp $
 *
 * Copyright 2004 Kenta Cho. Some rights reserved.
 */
module abagames.tt.camera;

private import std.math;
private import abagames.util.vector;
private import abagames.util.rand;
private import abagames.tt.ship;
private import abagames.tt.screen;

/**
 * Handle a camera.
 */
public class Camera {
 private:
  static const int ZOOM_CNT = 24;
  static enum MoveType {
    FLOAT, FIX,
  };
  Ship ship;
  Rand rand;
  Vector3 _cameraPos, cameraTrg, cameraVel;
  Vector3 _lookAtPos, lookAtOfs;
  int lookAtCnt, changeCnt, moveCnt;
  float _deg;
  float _zoom;
  float zoomTrg, zoomMin;
  int type;

  public this(Ship ship) {
    this.ship = ship;
    _cameraPos = new Vector3;
    cameraTrg = new Vector3;
    cameraVel = new Vector3;
    _lookAtPos = new Vector3;
    lookAtOfs = new Vector3;
    _zoom = zoomTrg = 1;
    zoomMin = 0.5f;
    rand = new Rand;
    type = MoveType.FLOAT;
  }

  public void start() {
    changeCnt = 0;
    moveCnt = 0;
  }

  public void move() {
    changeCnt--;
    if (changeCnt < 0) {
      type = rand.nextInt(2);
      switch (type) {
      case MoveType.FLOAT:
        changeCnt = 256 + rand.nextInt(150);
        cameraTrg.x = ship.relPos.x + rand.nextSignedFloat(1);
        cameraTrg.y = ship.relPos.y - 12 + rand.nextSignedFloat(48);
        cameraTrg.z = rand.nextInt(32);
        cameraVel.x = (ship.relPos.x - cameraTrg.x) / changeCnt * (1 + rand.nextFloat(1));
        cameraVel.y = (ship.relPos.y - 12 - cameraTrg.y) / changeCnt * (1.5f + rand.nextFloat(0.8f));
        cameraVel.z = (16 - cameraTrg.z) / changeCnt * rand.nextFloat(1);
        _zoom = zoomTrg = 1.2f + rand.nextFloat(0.8f);
        break;
      case MoveType.FIX:
        changeCnt = 200 + rand.nextInt(100);
        cameraTrg.x = rand.nextSignedFloat(0.3f);
        cameraTrg.y = -8 - rand.nextFloat(12);
        cameraTrg.z = 8 + rand.nextInt(16);
        cameraVel.x = (ship.relPos.x - cameraTrg.x) / changeCnt * (1 + rand.nextFloat(1));
        cameraVel.y = rand.nextSignedFloat(0.05f);
        cameraVel.z = (10 - cameraTrg.z) / changeCnt * rand.nextFloat(0.5f);
        zoomTrg = 1.0f + rand.nextSignedFloat(0.25f);
        _zoom = 0.2f + rand.nextFloat(0.8f);
        break;
      }
      _cameraPos.x = cameraTrg.x;
      _cameraPos.y = cameraTrg.y;
      _cameraPos.z = cameraTrg.z;
      _deg = cameraTrg.x;
      lookAtOfs.x = 0;
      lookAtOfs.y = 0;
      lookAtOfs.z = 0;
      lookAtCnt = 0;
      zoomMin = 1.0f - rand.nextFloat(0.9f);
    }
    lookAtCnt--;
    if (lookAtCnt == ZOOM_CNT) {
      lookAtOfs.x = rand.nextSignedFloat(0.4f);
      lookAtOfs.y = rand.nextSignedFloat(3);
      lookAtOfs.z = rand.nextSignedFloat(10);
    } else if (lookAtCnt < 0) {
      lookAtCnt = 32 + rand.nextInt(48);
    }
    cameraTrg += cameraVel;
    float cox, coy, coz;
    switch (type) {
    case MoveType.FLOAT:
      cox = cameraTrg.x;
      coy = cameraTrg.y;
      coz = cameraTrg.z;
      break;
    case MoveType.FIX:
      cox = cameraTrg.x + ship.relPos.x;
      coy = cameraTrg.y + ship.relPos.y;
      coz = cameraTrg.z;
      float od = ship.relPos.x - _deg;
      while (od >= PI)
        od -= PI * 2;
      while (od < -PI)
        od += PI * 2;
      _deg += od * 0.2f;
      break;
    }
    cox -= cameraPos.x;
    while (cox >= PI)
      cox -= PI * 2;
    while (cox < -PI)
      cox += PI * 2;
    coy -= cameraPos.y;
    coz -= cameraPos.z;
    _cameraPos.x += cox * 0.12f;
    _cameraPos.y += coy * 0.12f;
    _cameraPos.z += coz * 0.12f;
    float ofsRatio;
    if (lookAtCnt <= ZOOM_CNT)
      ofsRatio = 1.0f + fabs(zoomTrg - _zoom) * 2.5f;
    else
      ofsRatio = 1.0f;
    float lox = ship.relPos.x + lookAtOfs.x * ofsRatio - _lookAtPos.x;
    while (lox >= PI)
      lox -= PI * 2;
    while (lox < -PI)
      lox += PI * 2;
    float loy = ship.relPos.y + lookAtOfs.y * ofsRatio - _lookAtPos.y;
    float loz = lookAtOfs.z * ofsRatio - _lookAtPos.z;
    if (lookAtCnt <= ZOOM_CNT) {
      _zoom += (zoomTrg - _zoom) * 0.16f;
      _lookAtPos.x += lox * 0.2f;
      _lookAtPos.y += loy * 0.2f;
      _lookAtPos.z += loz * 0.2f;
    } else {
      _lookAtPos.x += lox * 0.1f;
      _lookAtPos.y += lox * 0.1f;
      _lookAtPos.z += loz * 0.1f;
    }
    lookAtOfs *= 0.985f;
    if (fabs(lookAtOfs.x) < 0.04f)
      lookAtOfs.x = 0;
    if (fabs(lookAtOfs.y) < 0.3f)
      lookAtOfs.y = 0;
    if (fabs(lookAtOfs.z) < 1)
      lookAtOfs.z = 0;
    moveCnt--;
    if (moveCnt < 0) {
      moveCnt = 15 + rand.nextInt(15);
      float lox = fabs(_lookAtPos.x - _cameraPos.x);
      if (lox > PI)
        lox = PI * 2 - lox;
      float ofs = lox * 3 + fabs(_lookAtPos.y - _cameraPos.y);
      zoomTrg = 3.0f / ofs;
      if (zoomTrg < zoomMin)
        zoomTrg = zoomMin;
      else if (zoomTrg > 2)
        zoomTrg = 2;
    }
    if (_lookAtPos.x < 0)
      _lookAtPos.x += PI * 2;
    else if (_lookAtPos.x >= PI * 2)
      _lookAtPos.x -= PI * 2;
  }

  public Vector3 cameraPos() {
    return _cameraPos;
  }

  public Vector3 lookAtPos() {
    return _lookAtPos;
  }

  public float deg() {
    return _deg;
  }

  public float zoom() {
    return _zoom;
  }
}
