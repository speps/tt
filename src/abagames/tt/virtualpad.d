/*
 * virtualpad.d
 *
 * Copyright 2020 outlandkarasu. Some rights reserved.
 *
 * License: BSD-2-Clause
 */
module abagames.tt.virtualpad;

import abagames.util.gl : GL;
import abagames.util.sdl.pad : Pad;
import abagames.tt.screen : Screen;

public class VirtualPad {

  private Pad pad;

  this(Pad pad) {
    this.pad = pad;
  }

  version(InputBackendSDLTouch) {

    import abagames.util.sdl.input : Input, Backend = InputBackendSDLTouch;
  
    void draw() {
      GL.pushMatrix();
      GL.lineWidth(4);
      GL.color(1.0, 1.0, 1.0, 1.0);
  
      drawLeftWedge();
      drawRightWedge();
      drawUpWedge();
      drawDownWedge();

      drawA();
      drawB();
      drawExit();
  
      GL.lineWidth(1);
      GL.popMatrix();
    }

  private:
  
    void drawLeftWedge() {
      GL.pushMatrix();
      scaling(Backend.LEFT_WEDGE_RECT);
      GL.begin(isDirPressing(Input.Dir.LEFT) ? GL.TRIANGLES : GL.LINE_LOOP);
      GL.vertex( 0.5,  0.5, 0);
      GL.vertex(-0.5,  0.0, 0);
      GL.vertex( 0.5, -0.5, 0);
      GL.end();
      GL.popMatrix();
    }
  
    void drawUpWedge() {
      GL.pushMatrix();
      GL.begin(isDirPressing(Input.Dir.UP) ? GL.TRIANGLES : GL.LINE_LOOP);
      scaling(Backend.UP_WEDGE_RECT);
      GL.vertex( 0.0,  -0.5, 0);
      GL.vertex( 0.5,   0.5, 0); GL.vertex(-0.5,   0.5, 0);
      GL.end();
      GL.popMatrix();
    }
  
    void drawRightWedge() {
      GL.pushMatrix();
      scaling(Backend.RIGHT_WEDGE_RECT);
      GL.begin(isDirPressing(Input.Dir.RIGHT) ? GL.TRIANGLES : GL.LINE_LOOP);
      GL.vertex(-0.5,  0.5, 0);
      GL.vertex( 0.5,  0.0, 0);
      GL.vertex(-0.5, -0.5, 0);
      GL.end();
      GL.popMatrix();
    }
  
    void drawDownWedge() {
      GL.pushMatrix();
      scaling(Backend.DOWN_WEDGE_RECT);
      GL.begin(isDirPressing(Input.Dir.DOWN) ? GL.TRIANGLES : GL.LINE_LOOP);
      GL.vertex(-0.5,  -0.5, 0);
      GL.vertex( 0.5,  -0.5, 0);
      GL.vertex( 0.0,   0.5, 0);
      GL.end();
      GL.popMatrix();
    }

    void drawA() {
      GL.pushMatrix();
      scaling(Backend.A_BUTTON_RECT);
      GL.begin(isButtonPressing(Input.Button.A) ? GL.TRIANGLES : GL.LINE_LOOP);
      GL.vertex(-0.5,  -0.5, 0);
      GL.vertex( 0.5,   0.5, 0);
      GL.vertex(-0.5,   0.5, 0);
      GL.end();
      GL.popMatrix();
    }
  
    void drawB() {
      GL.pushMatrix();
      scaling(Backend.B_BUTTON_RECT);
      GL.begin(isButtonPressing(Input.Button.B) ? GL.TRIANGLES : GL.LINE_LOOP);
      GL.vertex(-0.5,  -0.5, 0);
      GL.vertex( 0.5,   0.0, 0);
      GL.vertex(-0.5,   0.0, 0);
      GL.vertex(-0.5,   0.0, 0);
      GL.vertex( 0.5,   0.5, 0);
      GL.vertex(-0.5,   0.5, 0);
      GL.end();
      GL.popMatrix();
    }
  
    void drawExit() {
      GL.pushMatrix();
      scaling(Backend.EXIT_BUTTON_RECT);
      GL.begin(GL.LINES);
      GL.vertex(-0.5,  -0.5, 0);
      GL.vertex( 0.5,   0.5, 0);
      GL.vertex( 0.5,  -0.5, 0);
      GL.vertex(-0.5,   0.5, 0);
      GL.end();
      GL.popMatrix();
    }
  
    void scaling(ref const(Backend.ButtonRect) rect) {
        GL.translate(rect.x + rect.width / 2.0, rect.y + rect.height / 2.0, 0);
        GL.scale(rect.width, rect.height, 1.0);
    }

    bool isDirPressing(Input.Dir dir) {
        return (pad.getDirState() & dir) != 0;
    }

    bool isButtonPressing(Input.Button button) {
        return (pad.getButtonState() & button) != 0;
    }
  
  } else {
    void draw() {}
  }
}

