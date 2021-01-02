/*
 * virtualpad.d
 *
 * Copyright 2020 outlandkarasu. Some rights reserved.
 *
 * License: BSD-2-Clause
 */
module abagames.tt.virtualpad;

import abagames.util.gl : GL;
import abagames.tt.screen : Screen;

public class VirtualPad {

  struct ButtonRect {
      float x;
      float y;
      float width;
      float height;
  }

  immutable WEDGES_POSITION_X = 0.0;
  immutable WEDGES_POSITION_Y = 0.0;
  immutable WEDGE_SIZE = 40.0;

  immutable LEFT_WEDGE_RECT = ButtonRect(
    WEDGES_POSITION_X,
    WEDGES_POSITION_Y + WEDGE_SIZE,
    WEDGE_SIZE,
    WEDGE_SIZE);

  immutable RIGHT_WEDGE_RECT = ButtonRect(
    WEDGES_POSITION_X + WEDGE_SIZE * 2.0,
    WEDGES_POSITION_Y + WEDGE_SIZE,
    WEDGE_SIZE,
    WEDGE_SIZE);

  immutable UP_WEDGE_RECT = ButtonRect(
    WEDGES_POSITION_X + WEDGE_SIZE,
    WEDGES_POSITION_Y,
    WEDGE_SIZE,
    WEDGE_SIZE);

  immutable DOWN_WEDGE_RECT = ButtonRect(
    WEDGES_POSITION_X + WEDGE_SIZE,
    WEDGES_POSITION_Y + WEDGE_SIZE * 2.0,
    WEDGE_SIZE,
    WEDGE_SIZE);

  void draw() {
    GL.pushMatrix();
    GL.lineWidth(4);
    GL.color(1.0, 1.0, 1.0, 1.0);

    drawLeftWedge();
    drawRightWedge();
    drawUpWedge();
    drawDownWedge();

    GL.lineWidth(1);
    GL.popMatrix();
  }

  void drawLeftWedge() {
    GL.pushMatrix();
    scaling(LEFT_WEDGE_RECT);
    GL.begin(GL.LINE_LOOP);
    GL.vertex( 0.5,  0.5, 0);
    GL.vertex(-0.5,  0.0, 0);
    GL.vertex( 0.5, -0.5, 0);
    GL.end();
    GL.popMatrix();
  }

  void drawUpWedge() {
    GL.pushMatrix();
    GL.begin(GL.LINE_LOOP);
    scaling(UP_WEDGE_RECT);
    GL.vertex( 0.0,  -0.5, 0);
    GL.vertex( 0.5,   0.5, 0);
    GL.vertex(-0.5,   0.5, 0);
    GL.end();
    GL.popMatrix();
  }

  void drawRightWedge() {
    GL.pushMatrix();
    scaling(RIGHT_WEDGE_RECT);
    GL.begin(GL.LINE_LOOP);
    GL.vertex(-0.5,  0.5, 0);
    GL.vertex( 0.5,  0.0, 0);
    GL.vertex(-0.5, -0.5, 0);
    GL.end();
    GL.popMatrix();
  }

  void drawDownWedge() {
    GL.pushMatrix();
    scaling(DOWN_WEDGE_RECT);
    GL.begin(GL.LINE_LOOP);
    GL.vertex(-0.5,  -0.5, 0);
    GL.vertex( 0.5,  -0.5, 0);
    GL.vertex( 0.0,   0.5, 0);
    GL.end();
    GL.popMatrix();
  }

  void scaling(ref const(ButtonRect) rect) {
      GL.translate(rect.x + rect.width / 2.0, rect.y + rect.height / 2.0, 0);
      GL.scale(rect.width, rect.height, 1.0);
  }
}

