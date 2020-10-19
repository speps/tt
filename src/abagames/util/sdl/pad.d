/*
 * $Id: pad.d,v 1.2 2005/01/01 12:40:28 kenta Exp $
 *
 * Copyright 2004 Kenta Cho. Some rights reserved.
 */
module abagames.util.sdl.pad;

import std.conv;
version(BindBC) { import bindbc.sdl; }
import abagames.util.sdl.input;
import abagames.util.sdl.sdlexception;
import abagames.util.logger;

/**
 * Keyboard input.
 */
public class Pad {
  private:
    InputBackend _backend;
    int _lastDirState = 0, _lastButtonState = 0;

  public this(InputBackend backend) {
    _backend = backend;
  }

  public void update() {
    _backend.update();
  }

  public int getRecordState() {
    return _lastDirState | _lastButtonState;
  }

  public int getDirState() {
    _lastDirState = _backend.getDirState();
    return _lastDirState;
  }

  public int getButtonState() {
    _lastButtonState = _backend.getButtonState();
    return _lastButtonState;
  }

  public bool getExitState() {
    return _backend.getExitState();
  }

  public bool getPauseState() {
    return _backend.getPauseState();
  }
}
