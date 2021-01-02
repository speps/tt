/*
 * $Id: input.d,v 1.1.1.1 2004/11/10 13:45:22 kenta Exp $
 *
 * Copyright 2004 Kenta Cho. Some rights reserved.
 */
module abagames.util.sdl.input;

version(BindBC) { import bindbc.sdl; }

static class Input {
  public static enum Dir {
    UP = 1, DOWN = 2, LEFT = 4, RIGHT = 8,
  }
  public static enum Button {
    A = 16, B = 32, ANY = 48,
  }
}

/**
 * Input device interface.
 */
public interface InputBackend {
  public void update();
  public int getDirState();
  public int getButtonState();
  public bool getExitState();
  public bool getPauseState();
}

version (InputBackendSDL) {
  public class InputBackendSDL : InputBackend {
  private:
    Uint8 *keys;

    public override void update() {
      keys = SDL_GetKeyboardState(null);
    }

    public override int getDirState() {
      int dir = 0;
      if (keys[SDL_SCANCODE_RIGHT] == SDL_PRESSED || keys[SDL_SCANCODE_KP_6] == SDL_PRESSED || keys[SDL_SCANCODE_D] == SDL_PRESSED)
        dir |= Input.Dir.RIGHT;
      if (keys[SDL_SCANCODE_LEFT] == SDL_PRESSED || keys[SDL_SCANCODE_KP_4] == SDL_PRESSED || keys[SDL_SCANCODE_A] == SDL_PRESSED)
        dir |= Input.Dir.LEFT;
      if (keys[SDL_SCANCODE_DOWN] == SDL_PRESSED || keys[SDL_SCANCODE_KP_2] == SDL_PRESSED || keys[SDL_SCANCODE_S] == SDL_PRESSED)
        dir |= Input.Dir.DOWN;
      if (keys[SDL_SCANCODE_UP] == SDL_PRESSED ||  keys[SDL_SCANCODE_KP_8] == SDL_PRESSED || keys[SDL_SCANCODE_W] == SDL_PRESSED)
        dir |= Input.Dir.UP;
      return dir;
    }

    public override int getButtonState() {
      int btn = 0;
      if (keys[SDL_SCANCODE_Z] == SDL_PRESSED || keys[SDL_SCANCODE_PERIOD] == SDL_PRESSED || keys[SDL_SCANCODE_LCTRL] == SDL_PRESSED)
        btn |= Input.Button.A;
      if (keys[SDL_SCANCODE_X] == SDL_PRESSED || keys[SDL_SCANCODE_SLASH] == SDL_PRESSED || keys[SDL_SCANCODE_LALT] == SDL_PRESSED || keys[SDL_SCANCODE_LSHIFT] == SDL_PRESSED)
        btn |= Input.Button.B;
      return btn;
    }

    public override bool getExitState() {
      return keys[SDL_SCANCODE_ESCAPE] == SDL_PRESSED;
    }

    public override bool getPauseState() {
      return keys[SDL_SCANCODE_P] == SDL_PRESSED;
    }
  }

  alias InputBackendImpl = InputBackendSDL;
}

version(InputBackendDummy) {
  public class InputBackendDummy : InputBackend {
    public override void update() {}
    public override int getDirState() { return 0; }
    public override int getButtonState() { return 0; }
    public override bool getExitState() { return false; }
    public override bool getPauseState() { return false; }
  }

  alias InputBackendImpl = InputBackendDummy;
}

version(InputBackendWASM) {
  public class InputBackendWASM : InputBackend {
    uint state = 0;

    public override void update() {
      import wasm;
      state = wasm.inputState();
    }
    public override int getDirState() { return state & 0xF; }
    public override int getButtonState() { return state & 0x30; }
    public override bool getExitState() { return (state & 0x40) != 0; }
    public override bool getPauseState() { return (state & 0x80) != 0; }
  }

  alias InputBackendImpl = InputBackendWASM;
}

version(InputBackendSDLTouch) {
  public class InputBackendSDLTouch : InputBackend {
    uint state = 0;

    public override void update() {
        state = 0;
        foreach (i; 0 .. SDL_GetNumTouchDevices()) {
            immutable touchID = SDL_GetTouchDevice(i);
            foreach (f; 0 .. SDL_GetNumTouchFingers(touchID)) {
                const finger = SDL_GetTouchFinger(touchID, f);
                if (!finger) continue;
                state |= positionToButton(finger.x, finger.y);
            }
        }
    }

    private static int positionToButton(float x, float y) {
        if (x < 0.2) {
            if (y < 0.2) return Input.Dir.UP;
            if (0.2 <= y && y < 0.4) return Input.Dir.LEFT;
            if (0.4 <= y && y < 0.6) return Input.Dir.RIGHT;
            if (0.6 <= y && y < 0.8) return Input.Dir.DOWN;
        } else if (0.2 <= x && x < 0.4) {
            if (y < 0.5) return Input.Button.A;
            if (0.5 <= y) return Input.Button.B;
        }

        return 0;
    }

    public override int getDirState() {
        return state & 0xF;
    }

    public override int getButtonState() {
        return state & 0x30;
    }

    public override bool getExitState() {
        return false;
    }

    public override bool getPauseState() {
        return false;
    }
  }

  alias InputBackendImpl = InputBackendSDLTouch;
}

