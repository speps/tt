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
    struct ButtonRect {
        float x;
        float y;
        float width;
        float height;

        bool isIn(float positionX, float positionY) const {
            return (x <= positionX && positionX < x + width)
                && (y <= positionY && positionY < y + height);
        }
    }

    struct Button {
        ButtonRect rect;
        int state;
    }
  
    static {
      // ortho screen is fixed size.
      immutable SCREEN_WIDTH = 640;
      immutable SCREEN_HEIGHT = 480;

      immutable WEDGES_POSITION_X = 15.0;
      immutable WEDGES_POSITION_Y = 300.0;
      immutable WEDGE_SIZE = 50.0;
    
      immutable LEFT_WEDGE_RECT = ButtonRect(
        WEDGES_POSITION_X,
        WEDGES_POSITION_Y + WEDGE_SIZE,
        WEDGE_SIZE,
        WEDGE_SIZE);
    
      immutable RIGHT_WEDGE_RECT = ButtonRect(
        WEDGES_POSITION_X + WEDGE_SIZE * 2.0,
        WEDGES_POSITION_Y + WEDGE_SIZE,
        WEDGE_SIZE,
        WEDGE_SIZE);
    
      immutable UP_WEDGE_RECT = ButtonRect(
        WEDGES_POSITION_X + WEDGE_SIZE,
        WEDGES_POSITION_Y,
        WEDGE_SIZE,
        WEDGE_SIZE);
    
      immutable DOWN_WEDGE_RECT = ButtonRect(
        WEDGES_POSITION_X + WEDGE_SIZE,
        WEDGES_POSITION_Y + WEDGE_SIZE * 2.0,
        WEDGE_SIZE,
        WEDGE_SIZE);

      immutable BUTTON_SIZE = 60.0;
      immutable A_BUTTON_POSITION_X = 580.0;
      immutable A_BUTTON_POSITION_Y = 300.0;
      immutable B_BUTTON_POSITION_X = 580.0;
      immutable B_BUTTON_POSITION_Y = A_BUTTON_POSITION_Y + BUTTON_SIZE + 20.0;

      immutable A_BUTTON_RECT = ButtonRect(
        A_BUTTON_POSITION_X,
        A_BUTTON_POSITION_Y,
        BUTTON_SIZE,
        BUTTON_SIZE);

      immutable B_BUTTON_RECT = ButtonRect(
        B_BUTTON_POSITION_X,
        B_BUTTON_POSITION_Y,
        BUTTON_SIZE,
        BUTTON_SIZE);

      immutable BUTTONS = [
          Button(LEFT_WEDGE_RECT, Input.Dir.LEFT),
          Button(UP_WEDGE_RECT, Input.Dir.UP),
          Button(RIGHT_WEDGE_RECT, Input.Dir.RIGHT),
          Button(DOWN_WEDGE_RECT, Input.Dir.DOWN),
          Button(A_BUTTON_RECT, Input.Button.A),
          Button(B_BUTTON_RECT, Input.Button.B),
      ];
    }

    uint state = 0;

    public override void update() {
        state = 0;
        foreach (i; 0 .. SDL_GetNumTouchDevices()) {
            immutable touchID = SDL_GetTouchDevice(i);
            foreach (f; 0 .. SDL_GetNumTouchFingers(touchID)) {
                const finger = SDL_GetTouchFinger(touchID, f);
                if (!finger) continue;
                state |= positionToButton(
                  finger.x, finger.y, SCREEN_WIDTH, SCREEN_HEIGHT);
            }
        }
    }

    private static int positionToButton(float x, float y, int width, int height) {
        immutable positionX = width * x;
        immutable positionY = height * y;
        int state = 0;
        foreach (button; BUTTONS) {
            if (button.rect.isIn(positionX, positionY)) {
                state |= button.state;
            }
        }
        return state;
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

