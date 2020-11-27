/*
 * $Id: mainloop.d,v 1.1.1.1 2004/11/10 13:45:22 kenta Exp $
 *
 * Copyright 2004 Kenta Cho. Some rights reserved.
 */
module abagames.util.sdl.mainloop;

import std.stdio;
version(BindBC) { import bindbc.sdl; }
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
  int maxSkipFrame = 5;
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
    SoundManager.init();
    gameManager.init();
  }

  // Quit and save preference.
  private void quitLast() {
    SoundManager.close();
    prefManager.save();
    screen.closeWindow();
  }

  private bool done = false;

  public void breakLoop() {
    done = true;
  }

  version(BindBC) {
    public void loop() {
      screen.initWindow();
      initFirst();
      gameManager.start();

      long prvTickCount = 0;
      loop: while (true) {
        SDL_Event event;
        if (SDL_PollEvent(&event) == 0)
          event.type = SDL_USEREVENT;
        if (event.type == SDL_QUIT)
          breakLoop();
        if (event.type == SDL_WINDOWEVENT && event.window.event == SDL_WINDOWEVENT_RESIZED) {
          int w = event.window.data1;
          int h = event.window.data2;
          screen.resized(w, h);
        }

        long nowTick = SDL_GetTicks();
        int frame = cast(int) (nowTick-prvTickCount) / interval;
        if (frame <= 0) {
          frame = 1;
          SDL_Delay(cast(uint)(prvTickCount+interval-nowTick));
          prvTickCount += interval;
        } else if (frame > maxSkipFrame) {
          frame = maxSkipFrame;
          prvTickCount = nowTick;
        } else {
          prvTickCount += frame * interval;
        }

        for (int i = 0; i < frame; i++) {
          if (update()) {
            break loop;
          }
        }
        draw();
      }
      quitLast();
    }
  }

  version(WASM) {
    public void loopStart() {
      writeln("start");
      screen.initWindow();
      initFirst();
      gameManager.start();
    }

    public void resized(int width, int height) {
      screen.resized(width, height);
    }
  }

  public bool update() {
    pad.update();
    gameManager.move();
    return done;
  }

  public void draw() {
    screen.clear();
    GL.frameStart();
    gameManager.draw();
    GL.frameEnd();
    screen.flip();
  }
}
