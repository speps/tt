/*
 * $Id: luminous.d,v 1.2 2005/01/01 12:40:28 kenta Exp $
 *
 * Copyright 2004 Kenta Cho. Some rights reserved.
 */
module abagames.util.sdl.luminous;

import std.math;
import core.stdc.string;
import bindbc.opengl;
import abagames.util.gl;
import abagames.util.actor;

/**
 * Luminous effect texture.
 */
public class LuminousScreen {
 private:
  GLuint luminousTexture;
  const int LUMINOUS_TEXTURE_WIDTH_MAX = 64;
  const int LUMINOUS_TEXTURE_HEIGHT_MAX = 64;
  GLuint[LUMINOUS_TEXTURE_WIDTH_MAX * LUMINOUS_TEXTURE_HEIGHT_MAX * 4 * uint.sizeof] td;
  int luminousTextureWidth = 64, luminousTextureHeight = 64;
  int screenWidth, screenHeight;
  float luminous;

  public void init(float luminous, int width, int height) {
    makeLuminousTexture();
    this.luminous = luminous;
    resized(width, height);
  }

  private void makeLuminousTexture() {
    uint *data = &td[0];
    int i;
    memset(data, 0, luminousTextureWidth * luminousTextureHeight * 4 * uint.sizeof);
    glGenTextures(1, &luminousTexture);
    glBindTexture(GL_TEXTURE_2D, luminousTexture);
    glTexImage2D(GL_TEXTURE_2D, 0, 4, luminousTextureWidth, luminousTextureHeight, 0,
		 GL_RGBA, GL_UNSIGNED_BYTE, data);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
  }

  public void resized(int width, int height) {
    screenWidth = width;
    screenHeight = height;
  }

  public void close() {
    glDeleteTextures(1, &luminousTexture);
  }

  public void startRender() {
    glViewport(0, 0, luminousTextureWidth, luminousTextureHeight);
  }

  public void endRender() {
    glBindTexture(GL_TEXTURE_2D, luminousTexture);
    glCopyTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, 
		     0, 0, luminousTextureWidth, luminousTextureHeight, 0);
    glViewport(0, 0, screenWidth, screenHeight);
  }

  private void viewOrtho() {
    GL.matrixMode(GL.MatrixMode.Projection);
    GL.pushMatrix();
    GL.loadIdentity();
    GL.ortho(0, screenWidth, screenHeight, 0, -1, 1);
    GL.matrixMode(GL.MatrixMode.ModelView);
    GL.pushMatrix();
    GL.loadIdentity();
  }

  private void viewPerspective() {
    GL.matrixMode(GL.MatrixMode.Projection);
    GL.popMatrix();
    GL.matrixMode(GL.MatrixMode.ModelView);
    GL.popMatrix();
  }

  //private int[5][2] lmOfs = [[0, 0], [1, 0], [-1, 0], [0, 1], [0, -1]];
  //private const float lmOfsBs = 5;
  private float[2][2] lmOfs = [[-2, -1], [2, 1]];
  private const float lmOfsBs = 3;

  public void draw() {
    glEnable(GL_TEXTURE_2D);
    glBindTexture(GL_TEXTURE_2D, luminousTexture);
    viewOrtho();
    GL.color(1, 0.8, 0.9, luminous);
    // GL.begin(GL_QUADS);
    // //for (int i = 0; i < 5; i++) {
    // //for (int i = 1; i < 5; i++) {
    // for (int i = 0; i < 2; i++) {
    //   GL.texCoord(0, 1);
    //   GL.vertex(0 + lmOfs[i][0] * lmOfsBs, 0 + lmOfs[i][1] * lmOfsBs, 0);
    //   GL.texCoord(0, 0);
    //   GL.vertex(0 + lmOfs[i][0] * lmOfsBs, screenHeight + lmOfs[i][1] * lmOfsBs, 0);
    //   GL.texCoord(1, 0);
    //   GL.vertex(screenWidth + lmOfs[i][0] * lmOfsBs, screenHeight + lmOfs[i][0] * lmOfsBs, 0);
    //   GL.texCoord(1, 1);
    //   GL.vertex(screenWidth + lmOfs[i][0] * lmOfsBs, 0 + lmOfs[i][0] * lmOfsBs, 0);
    // }
    // GL.end();
    viewPerspective();
    glDisable(GL_TEXTURE_2D);
  }
}

/**
 * Actor with the luminous effect.
 */
public class LuminousActor: Actor {
  public abstract void drawLuminous();
}

/**
 * Actor pool for the LuminousActor.
 */
public class LuminousActorPool(T): ActorPool!(T) {
  public this(int n, Object[] args) {
    createActors(n, args);
  }

  public void drawLuminous() {
    for (int i = 0; i < actor.length; i++)
      if (actor[i].exists)
        actor[i].drawLuminous();
  }
}
