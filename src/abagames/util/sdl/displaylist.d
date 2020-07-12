/*
 * $Id: displaylist.d,v 1.1.1.1 2004/11/10 13:45:22 kenta Exp $
 *
 * Copyright 2004 Kenta Cho. Some rights reserved.
 */
module abagames.util.sdl.displaylist;

private import opengl;
private import abagames.util.sdl.sdlexception;

/**
 * Manage the display list.
 */
public class DisplayList {
 private:
  int num;
  int idx;
  int enumIdx;

  public this(int num) {
    this.num = num;
    idx = glGenLists(num);
  }

  public void beginNewList() {
    resetList();
    newList();
  }

  public void nextNewList() {
    glEndList();
    enumIdx++;
    if (enumIdx >= idx + num || enumIdx < idx)
      throw new SDLException("Can't create new list. Index out of bound.");
    glNewList(enumIdx, GL_COMPILE);
  }

  public void endNewList() {
    glEndList();
  }

  public void resetList() {
    enumIdx = idx;
  }

  public void newList() {
    glNewList(enumIdx, GL_COMPILE);
  }

  public void endList() {
    glEndList();
    enumIdx++;
  }

  public void call(int i) {
    glCallList(idx + i);
  }

  public void close() {
    glDeleteLists(idx, num);
  }
}
