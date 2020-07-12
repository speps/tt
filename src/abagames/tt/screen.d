/*
 * $Id: screen.d,v 1.2 2005/01/01 12:40:28 kenta Exp $
 *
 * Copyright 2004 Kenta Cho. Some rights reserved.
 */
module abagames.tt.screen;

private import std.math;
private import opengl;
private import abagames.util.sdl.screen3d;
private import abagames.util.sdl.luminous;

/**
 * Initialize an OpenGL and set the caption.
 * Handle the luminous screen.
 */
public class Screen: Screen3D {
 public:
  static const char[] CAPTION = "Torus Trooper";
  static float luminous = 0;
 private:
  LuminousScreen luminousScreen;

  protected override void init() {
    setCaption(CAPTION);
    glLineWidth(1);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE);
    glEnable(GL_LINE_SMOOTH);
    glEnable(GL_BLEND);
    glDisable(GL_COLOR_MATERIAL);
    glDisable(GL_CULL_FACE);
    glDisable(GL_DEPTH_TEST);
    glDisable(GL_LIGHTING);
    glDisable(GL_TEXTURE_2D);
    setClearColor(0, 0, 0, 1);
    if (luminous > 0) {
      luminousScreen = new LuminousScreen;
      luminousScreen.init(luminous, width, height);
    } else {
      luminousScreen = null;
    }
    farPlane = 10000;
    screenResized();
  }

  public override void close() {
    if (luminousScreen)
      luminousScreen.close();
  }

  public bool startRenderToLuminousScreen() {
    if (!luminousScreen)
      return false;
    luminousScreen.startRender();
    return true;
  }

  public void endRenderToLuminousScreen() {
    if (luminousScreen)
      luminousScreen.endRender();
  }

  public void drawLuminous() {
    if (luminousScreen)
      luminousScreen.draw();
  }

  public void resized(int width, int height) {
    if (luminousScreen)
      luminousScreen.resized(width, height);
    super.resized(width, height);
  }

  public override void clear() {
    glClear(GL_COLOR_BUFFER_BIT);
  }

  public static void viewOrthoFixed() {
    glMatrixMode(GL_PROJECTION);
    glPushMatrix();
    glLoadIdentity();
    glOrtho(0, 640, 480, 0, -1, 1);
    glMatrixMode(GL_MODELVIEW);
    glPushMatrix();
    glLoadIdentity();
  }

  public static void viewPerspective() {
    glMatrixMode(GL_PROJECTION);
    glPopMatrix();
    glMatrixMode(GL_MODELVIEW);
    glPopMatrix();
  }
}
