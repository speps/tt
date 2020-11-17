/*
 * $Id: screen.d,v 1.2 2005/01/01 12:40:28 kenta Exp $
 *
 * Copyright 2004 Kenta Cho. Some rights reserved.
 */
module abagames.tt.screen;

import abagames.util.gl;
import abagames.util.sdl.screen3d;

/**
 * Initialize an OpenGL and set the caption.
 * Handle the luminous screen.
 */
public class Screen: Screen3D {
 public:
  static const string CAPTION = "Torus Trooper";
 private:
  protected override void init() {
    setCaption(CAPTION);
    GL.lineWidth(1);
    GL.blendFunc(GL.SRC_ALPHA, GL.ONE);
    // GL.enable(GL.LINE_SMOOTH);
    GL.enable(GL.BLEND);
    // GL.disable(GL.COLOR_MATERIAL);
    GL.disable(GL.CULL_FACE);
    GL.disable(GL.DEPTH_TEST);
    // GL.disable(GL.LIGHTING);
    // GL.disable(GL.TEXTURE_2D);
    setClearColor(0, 0, 0, 1);
    farPlane = 10000;
    screenResized();
  }

  public override void clear() {
    GL.clear(GL.COLOR_BUFFER_BIT);
  }

  public static void viewOrthoFixed() {
    GL.matrixMode(GL.MatrixMode.Projection);
    GL.pushMatrix();
    GL.loadIdentity();
    GL.ortho(0, 640, 480, 0, -1, 1);
    GL.matrixMode(GL.MatrixMode.ModelView);
    GL.pushMatrix();
    GL.loadIdentity();
  }

  public static void viewPerspective() {
    GL.matrixMode(GL.MatrixMode.Projection);
    GL.popMatrix();
    GL.matrixMode(GL.MatrixMode.ModelView);
    GL.popMatrix();
  }
}
