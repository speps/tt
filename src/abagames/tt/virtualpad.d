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

  version(InputBackendSDLTouch) {

    import abagames.util.sdl.input : Input = InputBackendSDLTouch;
  
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
      scaling(Input.LEFT_WEDGE_RECT);
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
      scaling(Input.UP_WEDGE_RECT);
      GL.vertex( 0.0,  -0.5, 0);
      GL.vertex( 0.5,   0.5, 0); GL.vertex(-0.5,   0.5, 0);
      GL.end();
      GL.popMatrix();
    }
  
    void drawRightWedge() {
      GL.pushMatrix();
      scaling(Input.RIGHT_WEDGE_RECT);
      GL.begin(GL.LINE_LOOP);
      GL.vertex(-0.5,  0.5, 0);
      GL.vertex( 0.5,  0.0, 0);
      GL.vertex(-0.5, -0.5, 0);
      GL.end();
      GL.popMatrix();
    }
  
    void drawDownWedge() {
      GL.pushMatrix();
      scaling(Input.DOWN_WEDGE_RECT);
      GL.begin(GL.LINE_LOOP);
      GL.vertex(-0.5,  -0.5, 0);
      GL.vertex( 0.5,  -0.5, 0);
      GL.vertex( 0.0,   0.5, 0);
      GL.end();
      GL.popMatrix();
    }
  
    void scaling(ref const(Input.ButtonRect) rect) {
        GL.translate(rect.x + rect.width / 2.0, rect.y + rect.height / 2.0, 0);
        GL.scale(rect.width, rect.height, 1.0);
    }
  
  } else {
    void draw() {}
  }
}

