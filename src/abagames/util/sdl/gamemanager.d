/*
 * $Id: gamemanager.d,v 1.1.1.1 2004/11/10 13:45:22 kenta Exp $
 *
 * Copyright 2004 Kenta Cho. Some rights reserved.
 */
module abagames.util.sdl.gamemanager;

import abagames.util.prefmanager;
import abagames.util.sdl.mainloop;
import abagames.util.sdl.screen;
import abagames.util.sdl.pad;

/**
 * Manage the lifecycle of the game.
 */
public class GameManager {
 protected:
  MainLoop mainLoop;
  Screen abstScreen;
  Pad pad;
  PrefManager abstPrefManager;
 private:

  public void setMainLoop(MainLoop mainLoop) {
    this.mainLoop = mainLoop;
  }

  public void setUIs(Screen screen, Pad pad) {
    abstScreen = screen;
    this.pad = pad;
  }

  public void setPrefManager(PrefManager prefManager) {
    abstPrefManager = prefManager;
  }

  public abstract void init();
  public abstract void start();
  public abstract void close();
  public abstract void move();
  public abstract void draw();
}
