/*
 * $Id: pad.d,v 1.2 2005/01/01 12:40:28 kenta Exp $
 *
 * Copyright 2004 Kenta Cho. Some rights reserved.
 */
module abagames.util.sdl.pad;

import std.conv;
import std.string;
import SDL;
import SDL_error;
import SDL_events;
import SDL_joystick;
import SDL_keyboard;
import SDL_Keysym;
import SDL_types;
import abagames.util.sdl.input;
import abagames.util.sdl.sdlexception;

/**
 * Joystick and keyboard input.
 */
public class Pad: Input {
 public:
  static enum Dir {
    UP = 1, DOWN = 2, LEFT = 4, RIGHT = 8,
  };
  static enum Button {
    A = 16, B = 32, ANY = 48,
  };
  Uint8 *keys;
  bool buttonReversed = false;
 protected:
  int lastDirState = 0, lastButtonState = 0;
 private:
  SDL_Joystick *stick = null;
  const int JOYSTICK_AXIS = 16384;

  public void openJoystick() {
    if (SDL_InitSubSystem(SDL_INIT_JOYSTICK) < 0) {
      throw new SDLInitFailedException(
        "Unable to init SDL joystick: " ~ to!string(SDL_GetError()));
    }
    stick = SDL_JoystickOpen(0);
  }

  public void handleEvent(SDL_Event *event) {
    keys = SDL_GetKeyState(null);
  }

  public int getDirState() {
    int x = 0, y = 0;
    int dir = 0;
    if (stick) {
      x = SDL_JoystickGetAxis(stick, 0);
      y = SDL_JoystickGetAxis(stick, 1);
    }
    if (keys[SDLK_RIGHT] == SDL_PRESSED || keys[SDLK_KP6] == SDL_PRESSED || 
        keys[SDLK_d] == SDL_PRESSED || x > JOYSTICK_AXIS)
      dir |= Dir.RIGHT;
    if (keys[SDLK_LEFT] == SDL_PRESSED || keys[SDLK_KP4] == SDL_PRESSED ||
        keys[SDLK_a] == SDL_PRESSED || x < -JOYSTICK_AXIS)
      dir |= Dir.LEFT;
    if (keys[SDLK_DOWN] == SDL_PRESSED || keys[SDLK_KP2] == SDL_PRESSED ||
        keys[SDLK_s] == SDL_PRESSED || y > JOYSTICK_AXIS)
      dir |= Dir.DOWN;
    if (keys[SDLK_UP] == SDL_PRESSED ||  keys[SDLK_KP8] == SDL_PRESSED ||
        keys[SDLK_w] == SDL_PRESSED || y < -JOYSTICK_AXIS)
      dir |= Dir.UP;
    lastDirState = dir;
    return dir;
  }

  public int getButtonState() {
    int btn = 0;
    int btn1 = 0, btn2 = 0, btn3 = 0, btn4 = 0, btn5 = 0, btn6 = 0, btn7 = 0, btn8 = 0;
    if (stick) {
      btn1 = SDL_JoystickGetButton(stick, 0);
      btn2 = SDL_JoystickGetButton(stick, 1);
      btn3 = SDL_JoystickGetButton(stick, 2);
      btn4 = SDL_JoystickGetButton(stick, 3);
      btn5 = SDL_JoystickGetButton(stick, 4);
      btn6 = SDL_JoystickGetButton(stick, 5);
      btn7 = SDL_JoystickGetButton(stick, 6);
      btn8 = SDL_JoystickGetButton(stick, 7);
    }
    if (keys[SDLK_z] == SDL_PRESSED || keys[SDLK_PERIOD] == SDL_PRESSED ||
        keys[SDLK_LCTRL] == SDL_PRESSED || 
        btn1 || btn4 || btn5 || btn8) {
      if (!buttonReversed)
        btn |= Button.A;
      else
        btn |= Button.B;
    }
    if (keys[SDLK_x] == SDL_PRESSED || keys[SDLK_SLASH] == SDL_PRESSED ||
        keys[SDLK_LALT] == SDL_PRESSED || keys[SDLK_LSHIFT] == SDL_PRESSED ||
        btn2 || btn3 || btn6 || btn7) {
      if (!buttonReversed)
        btn |= Button.B;
      else
        btn |= Button.A;
    }
    lastButtonState = btn;
    return btn;
  }
}
