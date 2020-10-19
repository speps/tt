/*
 * $Id: mainloop.d,v 1.1.1.1 2004/11/10 13:45:22 kenta Exp $
 *
 * Copyright 2004 Kenta Cho. Some rights reserved.
 */
module abagames.util.sdl.mainloop;

import bindbc.sdl;
import abagames.util.gl;
import abagames.util.logger;
import abagames.util.rand;
import abagames.util.prefmanager;
import abagames.util.sdl.gamemanager;
import abagames.util.sdl.screen;
import abagames.util.sdl.pad;
import abagames.util.sdl.sound;
import abagames.util.sdl.sdlexception;

/**
 * SDL main loop.
 */
public class MainLoop {
 public:
  const int INTERVAL_BASE = 16;
  int interval = INTERVAL_BASE;
  int accframe = 0;
  int maxSkipFrame = 5;
  SDL_Event event;
 private:
  Screen screen;
  Pad pad;
  GameManager gameManager;
  PrefManager prefManager;

  public this(Screen screen, Pad pad, GameManager gameManager, PrefManager prefManager) {
    this.screen = screen;
    this.pad = pad;
    gameManager.setMainLoop(this);
    gameManager.setUIs(screen, pad);
    gameManager.setPrefManager(prefManager);
    this.gameManager = gameManager;
    this.prefManager = prefManager;
  }

  // Initialize and load preference.
  private void initFirst() {
    prefManager.load();
    try {
      SoundManager.init();
    } catch (SDLInitFailedException e) {
      Logger.error(e);
    }
    gameManager.init();
  }

  // Quit and save preference.
  private void quitLast() {
    gameManager.close();
    SoundManager.close();
    prefManager.save();
    screen.closeSDL();
    SDL_Quit();
  }

  private bool done;

  public void breakLoop() {
    done = true;
  }

  public void loop() {
    done = false;
    long prvTickCount = 0;
    int i;
    long nowTick;
    int frame;
    
    screen.initSDL();
    initFirst();
    gameManager.start();

    while (!done) {
      if (SDL_PollEvent(&event) == 0)
	      event.type = SDL_USEREVENT;
      pad.update();
      if (event.type == SDL_QUIT)
	      breakLoop();
      nowTick = SDL_GetTicks();
      frame = cast(int) (nowTick-prvTickCount) / interval;
      if (frame <= 0) {
        frame = 1;
        SDL_Delay(cast(uint)(prvTickCount+interval-nowTick));
        if (accframe) {
          prvTickCount = SDL_GetTicks();
        } else {
          prvTickCount += interval;
        }
      } else if (frame > maxSkipFrame) {
        frame = maxSkipFrame;
        prvTickCount = nowTick;
      } else {
	      prvTickCount += frame * interval;
      }
      for (i = 0; i < frame; i++) {
	      gameManager.move();
      }
      screen.clear();
      GL.frameStart();
      gameManager.draw();
      GL.frameEnd();
      screen.flip();
    }
    quitLast();
  }
}
