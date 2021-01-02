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

  void draw() {
    GL.pushMatrix();
    GL.translate(100, 300, 0);
    GL.scale(40.0, 40.0, 1.0);
    GL.lineWidth(4);
    GL.color(1.0, 1.0, 1.0, 1.0);

    GL.pushMatrix();
    GL.translate(-1.5, 0, 0);
    drawLeftWedge();
    GL.popMatrix();

    GL.pushMatrix();
    GL.translate(1.5, 0, 0);
    drawRightWedge();
    GL.popMatrix();

    GL.pushMatrix();
    GL.translate(0, -1.5, 0);
    drawUpWedge();
    GL.popMatrix();

    GL.pushMatrix();
    GL.translate(0, 1.5, 0);
    drawDownWedge();
    GL.popMatrix();

    GL.lineWidth(1);
    GL.popMatrix();
  }

  void drawLeftWedge() {
    GL.begin(GL.LINE_LOOP);
    GL.vertex(0, -0.5, 0);
    GL.vertex(-0.75, 0, 0);
    GL.vertex(0, 0.5, 0);
    GL.end();
  }

  void drawUpWedge() {
    GL.begin(GL.LINE_LOOP);
    GL.vertex(-0.5, 0, 0);
    GL.vertex(0, -0.75, 0);
    GL.vertex(0.5, 0, 0);
    GL.end();
  }

  void drawRightWedge() {
    GL.begin(GL.LINE_LOOP);
    GL.vertex(0, -0.5, 0);
    GL.vertex(0.75, 0, 0);
    GL.vertex(0, 0.5, 0);
    GL.end();
  }

  void drawDownWedge() {
    GL.begin(GL.LINE_LOOP);
    GL.vertex(-0.5, 0, 0);
    GL.vertex(0, 0.75, 0);
    GL.vertex(0.5, 0, 0);
    GL.end();
  }
}

