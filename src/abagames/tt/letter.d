/*
 * $Id: letter.d,v 1.2 2005/01/01 12:40:27 kenta Exp $
 *
 * Copyright 2004 Kenta Cho. Some rights reserved.
 */
module abagames.tt.letter;

import abagames.util.gl;
import abagames.util.math;
import abagames.tt.screen;

/**
 * Letters.
 */
public class Letter {
 public:
  static const float LETTER_WIDTH = 2.1f;
  static const float LETTER_HEIGHT = 3.0f;
  static const int COLOR_NUM = 4;
 private:
  static const float[][] COLOR_RGB = [[1, 1, 1], [0.9, 0.7, 0.5]];
  static const int LETTER_NUM = 44;
  static const int DISPLAY_LIST_NUM = LETTER_NUM * COLOR_NUM;

  public static float getWidth(int n ,float s) {
    return n * s * LETTER_WIDTH;
  }

  public static float getHeight(float s) {
    return s * LETTER_HEIGHT;
  }

  private static void drawLetter(int n, float x, float y, float s, float d, int c) {
    GL.pushMatrix();
    GL.translate(x, y, 0);
    GL.scale(s, s, s);
    GL.rotate(d, 0, 0, 1);
    drawLetter(n, c);
    GL.popMatrix();
  }

  private static void drawLetterRev(int n, float x, float y, float s, float d, int c) {
    GL.pushMatrix();
    GL.translate(x, y, 0);
    GL.scale(s, -s, s);
    GL.rotate(d, 0, 0, 1);
    drawLetter(n, c);
    GL.popMatrix();
  }

  public static enum Direction {
    TO_RIGHT, TO_DOWN, TO_LEFT, TO_UP,
  }

  public static int convertCharToInt(char c) {
    int idx;
    if (c >= '0' && c <='9') {
      idx = c - '0';
    } else if (c >= 'A' && c <= 'Z') {
      idx = c - 'A' + 10;
    } else if (c >= 'a' && c <= 'z') {
      idx = c - 'a' + 10;
    } else if (c == '.') {
      idx = 36;
    } else if (c == '-') {
      idx = 38;
    } else if (c == '+') {
      idx = 39;
    } else if (c == '_') {
      idx = 37;
    } else if (c == '!') {
      idx = 42;
    } else if (c == '/') {
      idx = 43;
    }
    return idx;
  }

  public static void drawString(string str, float lx, float y, float s,
                                int d = Direction.TO_RIGHT, int cl = 0,
                                bool rev = false, float od = 0) {
    lx += LETTER_WIDTH * s / 2;
    y += LETTER_HEIGHT * s / 2;
    float x = lx;
    int idx;
    float ld;
    final switch (d) {
    case Direction.TO_RIGHT:
      ld = 0;
      break;
    case Direction.TO_DOWN:
      ld = 90;
      break;
    case Direction.TO_LEFT:
      ld = 180;
      break;
    case Direction.TO_UP:
      ld = 270;
      break;
    }
    ld += od;
    foreach (char c; str) {
      if (c != ' ') {
        idx = convertCharToInt(c);
        if (rev)
          drawLetterRev(idx, x, y, s, ld, cl);
        else
          drawLetter(idx, x, y, s, ld, cl);
      }
      if (od == 0) {
        final switch(d) {
        case Direction.TO_RIGHT:
          x += s * LETTER_WIDTH;
          break;
        case Direction.TO_DOWN:
          y += s * LETTER_WIDTH;
          break;
        case Direction.TO_LEFT:
          x -= s * LETTER_WIDTH;
          break;
        case Direction.TO_UP:
          y -= s * LETTER_WIDTH;
          break;
        }
      } else {
        x += cos(ld * PI / 180) * s * LETTER_WIDTH;
        y += sin(ld * PI / 180) * s * LETTER_WIDTH;
      }
    }
  }

  public static void drawNum(int num, float lx, float y, float s,
                             int d = Direction.TO_RIGHT, int cl = 0, int dg = 0) {
    lx += LETTER_WIDTH * s / 2;
    y += LETTER_HEIGHT * s / 2;
    int n = num;
    float x = lx;
    float ld;
    final switch (d) {
    case Direction.TO_RIGHT:
      ld = 0;
      break;
    case Direction.TO_DOWN:
      ld = 90;
      break;
    case Direction.TO_LEFT:
      ld = 180;
      break;
    case Direction.TO_UP:
      ld = 270;
      break;
    }
    int digit = dg;
    for (;;) {
      drawLetter(n % 10, x, y, s, ld, cl);
      final switch(d) {
      case Direction.TO_RIGHT:
        x -= s * LETTER_WIDTH;
        break;
      case Direction.TO_DOWN:
        y -= s * LETTER_WIDTH;
        break;
      case Direction.TO_LEFT:
        x += s * LETTER_WIDTH;
        break;
      case Direction.TO_UP:
        y += s * LETTER_WIDTH;
        break;
      }
      n /= 10;
      digit--;
      if (n <= 0 && digit <= 0)
        break;
    }
  }

  public static void drawNumSign(int num, float lx, float ly, float s, int cl) {
    float dg;
    if (num < 100)
      dg = 2;
    else if (num < 1000)
      dg = 3;
    else if (num < 10000)
      dg = 4;
    else
      dg = 5;
    float x = lx + LETTER_WIDTH * s * dg / 2;
    float y = ly + LETTER_HEIGHT * s / 2;
    int n = num;
    for (;;) {
      drawLetterRev(n % 10, x, y, s, 0, cl);
      x -= s * LETTER_WIDTH;
      n /= 10;
      if (n <= 0)
        break;
    }
  }

  public static void drawTime(int time, float lx, float y, float s, int cl = 0) {
    int n = time;
    if (n < 0)
      n = 0;
    float x = lx;
    for (int i = 0; i < 7; i++) {
      if (i != 4) {
        drawLetter(n % 10, x, y, s, Direction.TO_RIGHT, cl);
        n /= 10;
      } else {
        drawLetter(n % 6, x, y, s, Direction.TO_RIGHT, cl);
        n /= 6;
      }
      if ((i & 1) == 1 || i == 0) {
        switch (i) {
        case 3:
          drawLetter(41, x + s * 1.16f, y, s, Direction.TO_RIGHT, cl);
          break;
        case 5:
          drawLetter(40, x + s * 1.16f, y, s, Direction.TO_RIGHT, cl);
          break;
        default:
          break;
        }
        x -= s * LETTER_WIDTH;
      } else {
        x -= s * LETTER_WIDTH * 1.3f;
      }
      if (n <= 0)
        break;
    }
  }

  private static void drawLetter(int idx, int c) {
    float x, y, length, size, t;
    float deg;
    for (int i = 0;; i++) {
      deg = cast(int) spData[idx][i][4];
      if (deg > 99990) break;
      x = -spData[idx][i][0];
      y = -spData[idx][i][1];
      size = spData[idx][i][2];
      length = spData[idx][i][3];
      y *= 0.9;
      size *= 1.4;
      length *= 1.05;
      x = -x;
      y = y;
      while (deg < -180) deg += 180;
      while (deg > 180) deg -= 180;
      if (c == 2)
        drawBoxLine(x, y, size, length, deg);
      else if (c == 3)
        drawBoxPoly(x, y, size, length, deg);
      else
        drawBox(x, y, size, length, deg,
                COLOR_RGB[c][0], COLOR_RGB[c][1], COLOR_RGB[c][2]);
    }
  }

  private static void drawBox(float x, float y, float width, float height, float deg,
                              float r, float g, float b) {
    GL.pushMatrix();
    GL.translate(x - width / 2, y - height / 2, 0);
    GL.rotate(deg, 0, 0, 1);
    Screen.setColor(r, g, b, 0.5);
    GL.begin(GL.TRIANGLE_FAN);
    drawBoxPart(width, height);
    GL.end();
    Screen.setColor(r, g, b);
    GL.begin(GL.LINE_LOOP);
    drawBoxPart(width, height);
    GL.end();
    GL.popMatrix();
  }

  private static void drawBoxLine(float x, float y, float width, float height, float deg) {
    GL.pushMatrix();
    GL.translate(x - width / 2, y - height / 2, 0);
    GL.rotate(deg, 0, 0, 1);
    GL.begin(GL.LINE_LOOP);
    drawBoxPart(width, height);
    GL.end();
    GL.popMatrix();
  }

  private static void drawBoxPoly(float x, float y, float width, float height, float deg) {
    GL.pushMatrix();
    GL.translate(x - width / 2, y - height / 2, 0);
    GL.rotate(deg, 0, 0, 1);
    GL.begin(GL.TRIANGLE_FAN);
    drawBoxPart(width, height);
    GL.end();
    GL.popMatrix();
  }

  private static void drawBoxPart(float width, float height) {
    GL.vertex(-width / 2, 0, 0);
    GL.vertex(-width / 3 * 1, -height / 2, 0);
    GL.vertex( width / 3 * 1, -height / 2, 0);
    GL.vertex( width / 2, 0, 0);
    GL.vertex( width / 3 * 1,  height / 2, 0);
    GL.vertex(-width / 3 * 1,  height / 2, 0);
  }
  
  private static float[5][16][] spData = 
    [[
     [0, 1.15f, 0.65f, 0.3f, 0],
     [-0.6f, 0.55f, 0.65f, 0.3f, 90], [0.6f, 0.55f, 0.65f, 0.3f, 90],
     [-0.6f, -0.55f, 0.65f, 0.3f, 90], [0.6f, -0.55f, 0.65f, 0.3f, 90],
     [0, -1.15f, 0.65f, 0.3f, 0],
     [0, 0, 0, 0, 99999],
    ],[
     [0.5f, 0.55f, 0.65f, 0.3f, 90],
     [0.5f, -0.55f, 0.65f, 0.3f, 90],
     [0, 0, 0, 0, 99999],
    ],[
     [0, 1.15f, 0.65f, 0.3f, 0],
     [0.65f, 0.55f, 0.65f, 0.3f, 90],
     [0, 0, 0.65f, 0.3f, 0],
     [-0.65f, -0.55f, 0.65f, 0.3f, 90],
     [0, -1.15f, 0.65f, 0.3f, 0],
     [0, 0, 0, 0, 99999],
    ],[
     [0, 1.15f, 0.65f, 0.3f, 0],
     [0.65f, 0.55f, 0.65f, 0.3f, 90],
     [0, 0, 0.65f, 0.3f, 0],
     [0.65f, -0.55f, 0.65f, 0.3f, 90],
     [0, -1.15f, 0.65f, 0.3f, 0],
     [0, 0, 0, 0, 99999],
    ],[
     [-0.65f, 0.55f, 0.65f, 0.3f, 90], [0.65f, 0.55f, 0.65f, 0.3f, 90],
     [0, 0, 0.65f, 0.3f, 0],
     [0.65f, -0.55f, 0.65f, 0.3f, 90],
     [0, 0, 0, 0, 99999],
    ],[
     [0, 1.15f, 0.65f, 0.3f, 0],
     [-0.65f, 0.55f, 0.65f, 0.3f, 90],
     [0, 0, 0.65f, 0.3f, 0],
     [0.65f, -0.55f, 0.65f, 0.3f, 90],
     [0, -1.15f, 0.65f, 0.3f, 0],
     [0, 0, 0, 0, 99999],
    ],[
     [0, 1.15f, 0.65f, 0.3f, 0],
     [-0.65f, 0.55f, 0.65f, 0.3f, 90],
     [0, 0, 0.65f, 0.3f, 0],
     [-0.65f, -0.55f, 0.65f, 0.3f, 90], [0.65f, -0.55f, 0.65f, 0.3f, 90],
     [0, -1.15f, 0.65f, 0.3f, 0],
     [0, 0, 0, 0, 99999],
    ],[
     [0, 1.15f, 0.65f, 0.3f, 0],
     [0.65f, 0.55f, 0.65f, 0.3f, 90],
     [0.65f, -0.55f, 0.65f, 0.3f, 90],
     [0, 0, 0, 0, 99999],
    ],[
     [0, 1.15f, 0.65f, 0.3f, 0],
     [-0.65f, 0.55f, 0.65f, 0.3f, 90], [0.65f, 0.55f, 0.65f, 0.3f, 90],
     [0, 0, 0.65f, 0.3f, 0],
     [-0.65f, -0.55f, 0.65f, 0.3f, 90], [0.65f, -0.55f, 0.65f, 0.3f, 90],
     [0, -1.15f, 0.65f, 0.3f, 0],
     [0, 0, 0, 0, 99999],
    ],[
     [0, 1.15f, 0.65f, 0.3f, 0],
     [-0.65f, 0.55f, 0.65f, 0.3f, 90], [0.65f, 0.55f, 0.65f, 0.3f, 90],
     [0, 0, 0.65f, 0.3f, 0],
     [0.65f, -0.55f, 0.65f, 0.3f, 90],
     [0, -1.15f, 0.65f, 0.3f, 0],
     [0, 0, 0, 0, 99999],
    ],[
     //A
     [0, 1.15f, 0.65f, 0.3f, 0],
     [-0.65f, 0.55f, 0.65f, 0.3f, 90], [0.65f, 0.55f, 0.65f, 0.3f, 90],
     [0, 0, 0.65f, 0.3f, 0],
     [-0.65f, -0.55f, 0.65f, 0.3f, 90], [0.65f, -0.55f, 0.65f, 0.3f, 90],
     [0, 0, 0, 0, 99999],
    ],[
     [-0.18f, 1.15f, 0.45f, 0.3f, 0],
     [-0.65f, 0.55f, 0.65f, 0.3f, 90], [0.45f, 0.55f, 0.65f, 0.3f, 90],
     [-0.18f, 0, 0.45f, 0.3f, 0],
     [-0.65f, -0.55f, 0.65f, 0.3f, 90], [0.65f, -0.55f, 0.65f, 0.3f, 90],
     [0, -1.15f, 0.65f, 0.3f, 0],
     [0, 0, 0, 0, 99999],
    ],[
     [0, 1.15f, 0.65f, 0.3f, 0],
     [-0.65f, 0.55f, 0.65f, 0.3f, 90],
     [-0.65f, -0.55f, 0.65f, 0.3f, 90],
     [0, -1.15f, 0.65f, 0.3f, 0],
     [0, 0, 0, 0, 99999],
    ],[
     [-0.15f, 1.15f, 0.45f, 0.3f, 0],
     [-0.65f, 0.55f, 0.65f, 0.3f, 90], [0.45f, 0.45f, 0.65f, 0.3f, 90],
     [-0.65f, -0.55f, 0.65f, 0.3f, 90], [0.65f, -0.55f, 0.65f, 0.3f, 90],
     [0, -1.15f, 0.65f, 0.3f, 0],
     [0, 0, 0, 0, 99999],
    ],[
     [0, 1.15f, 0.65f, 0.3f, 0],
     [-0.65f, 0.55f, 0.65f, 0.3f, 90],
     [0, 0, 0.65f, 0.3f, 0],
     [-0.65f, -0.55f, 0.65f, 0.3f, 90],
     [0, -1.15f, 0.65f, 0.3f, 0],
     [0, 0, 0, 0, 99999],
    ],[// F
     [0, 1.15f, 0.65f, 0.3f, 0],
     [-0.65f, 0.55f, 0.65f, 0.3f, 90],
     [0, 0, 0.65f, 0.3f, 0],
     [-0.65f, -0.55f, 0.65f, 0.3f, 90],
     [0, 0, 0, 0, 99999],
    ],[
     [0, 1.15f, 0.65f, 0.3f, 0],
     [-0.65f, 0.55f, 0.65f, 0.3f, 90],
     [0.05f, 0, 0.3f, 0.3f, 0],
     [-0.65f, -0.55f, 0.65f, 0.3f, 90], [0.65f, -0.55f, 0.65f, 0.3f, 90],
     [0, -1.15f, 0.65f, 0.3f, 0],
     [0, 0, 0, 0, 99999],
    ],[
     [-0.65f, 0.55f, 0.65f, 0.3f, 90], [0.65f, 0.55f, 0.65f, 0.3f, 90],
     [0, 0, 0.65f, 0.3f, 0],
     [-0.65f, -0.55f, 0.65f, 0.3f, 90], [0.65f, -0.55f, 0.65f, 0.3f, 90],
     [0, 0, 0, 0, 99999],
    ],[
     [0, 0.55f, 0.65f, 0.3f, 90],
     [0, -0.55f, 0.65f, 0.3f, 90],
     [0, 0, 0, 0, 99999],
    ],[
     [0.65f, 0.55f, 0.65f, 0.3f, 90],
     [0.65f, -0.55f, 0.65f, 0.3f, 90], [-0.7f, -0.7f, 0.3f, 0.3f, 90],
     [0, -1.15f, 0.65f, 0.3f, 0],
     [0, 0, 0, 0, 99999],
    ],[//K
     [-0.65f, 0.55f, 0.65f, 0.3f, 90], [0.4f, 0.55f, 0.65f, 0.3f, 100],
     [-0.25f, 0, 0.45f, 0.3f, 0],
     [-0.65f, -0.55f, 0.65f, 0.3f, 90], [0.6f, -0.55f, 0.65f, 0.3f, 80],
     [0, 0, 0, 0, 99999],
    ],[
     [-0.65f, 0.55f, 0.65f, 0.3f, 90],
     [-0.65f, -0.55f, 0.65f, 0.3f, 90],
     [0, -1.15f, 0.65f, 0.3f, 0],
     [0, 0, 0, 0, 99999],
    ],[
     [-0.5f, 1.15f, 0.3f, 0.3f, 0], [0.1f, 1.15f, 0.3f, 0.3f, 0],
     [-0.65f, 0.55f, 0.65f, 0.3f, 90], [0.65f, 0.55f, 0.65f, 0.3f, 90],
     [-0.65f, -0.55f, 0.65f, 0.3f, 90], [0.65f, -0.55f, 0.65f, 0.3f, 90],
     [0, 0.55f, 0.65f, 0.3f, 90],
     [0, -0.55f, 0.65f, 0.3f, 90],
     [0, 0, 0, 0, 99999],
    ],[
     [0, 1.15f, 0.65f, 0.3f, 0],
     [-0.65f, 0.55f, 0.65f, 0.3f, 90], [0.65f, 0.55f, 0.65f, 0.3f, 90],
     [-0.65f, -0.55f, 0.65f, 0.3f, 90], [0.65f, -0.55f, 0.65f, 0.3f, 90],
     [0, 0, 0, 0, 99999],
    ],[
     [0, 1.15f, 0.65f, 0.3f, 0],
     [-0.65f, 0.55f, 0.65f, 0.3f, 90], [0.65f, 0.55f, 0.65f, 0.3f, 90],
     [-0.65f, -0.55f, 0.65f, 0.3f, 90], [0.65f, -0.55f, 0.65f, 0.3f, 90],
     [0, -1.15f, 0.65f, 0.3f, 0],
     [0, 0, 0, 0, 99999],
    ],[//P
     [0, 1.15f, 0.65f, 0.3f, 0],
     [-0.65f, 0.55f, 0.65f, 0.3f, 90], [0.65f, 0.55f, 0.65f, 0.3f, 90],
     [0, 0, 0.65f, 0.3f, 0],
     [-0.65f, -0.55f, 0.65f, 0.3f, 90],
     [0, 0, 0, 0, 99999],
    ],[
     [0, 1.15f, 0.65f, 0.3f, 0],
     [-0.65f, 0.55f, 0.65f, 0.3f, 90], [0.65f, 0.55f, 0.65f, 0.3f, 90],
     [-0.65f, -0.55f, 0.65f, 0.3f, 90], [0.65f, -0.55f, 0.65f, 0.3f, 90],
     [0, -1.15f, 0.65f, 0.3f, 0],
     [0.05f, -0.55f, 0.45f, 0.3f, 60],
     [0, 0, 0, 0, 99999],
    ],[
     [0, 1.15f, 0.65f, 0.3f, 0],
     [-0.65f, 0.55f, 0.65f, 0.3f, 90], [0.65f, 0.55f, 0.65f, 0.3f, 90],
     [-0.2f, 0, 0.45f, 0.3f, 0],
     [-0.65f, -0.55f, 0.65f, 0.3f, 90], [0.45f, -0.55f, 0.65f, 0.3f, 80],
     [0, 0, 0, 0, 99999],
    ],[
     [0, 1.15f, 0.65f, 0.3f, 0],
     [-0.65f, 0.55f, 0.65f, 0.3f, 90],
     [0, 0, 0.65f, 0.3f, 0],
     [0.65f, -0.55f, 0.65f, 0.3f, 90],
     [0, -1.15f, 0.65f, 0.3f, 0],
     [0, 0, 0, 0, 99999],
    ],[
     [-0.5f, 1.15f, 0.55f, 0.3f, 0], [0.5f, 1.15f, 0.55f, 0.3f, 0],
     [0.1f, 0.55f, 0.65f, 0.3f, 90],
     [0.1f, -0.55f, 0.65f, 0.3f, 90],
     [0, 0, 0, 0, 99999],
    ],[//U
     [-0.65f, 0.55f, 0.65f, 0.3f, 90], [0.65f, 0.55f, 0.65f, 0.3f, 90],
     [-0.65f, -0.55f, 0.65f, 0.3f, 90], [0.65f, -0.55f, 0.65f, 0.3f, 90],
     [0, -1.15f, 0.65f, 0.3f, 0],
     [0, 0, 0, 0, 99999],
    ],[
     [-0.65f, 0.55f, 0.65f, 0.3f, 90], [0.65f, 0.55f, 0.65f, 0.3f, 90],
     [-0.5f, -0.55f, 0.65f, 0.3f, 90], [0.5f, -0.55f, 0.65f, 0.3f, 90],
     [-0.1f, -1.15f, 0.45f, 0.3f, 0],
     [0, 0, 0, 0, 99999],
    ],[
     [-0.65f, 0.55f, 0.65f, 0.3f, 90], [0.65f, 0.55f, 0.65f, 0.3f, 90],
     [-0.65f, -0.55f, 0.65f, 0.3f, 90], [0.65f, -0.55f, 0.65f, 0.3f, 90],
     [-0.5f, -1.15f, 0.3f, 0.3f, 0], [0.1f, -1.15f, 0.3f, 0.3f, 0],
     [0, 0.55f, 0.65f, 0.3f, 90],
     [0, -0.55f, 0.65f, 0.3f, 90],
     [0, 0, 0, 0, 99999],
    ],[
     [-0.4f, 0.6f, 0.85f, 0.3f, 360-120],
     [0.4f, 0.6f, 0.85f, 0.3f, 360-60],
     [-0.4f, -0.6f, 0.85f, 0.3f, 360-240],
     [0.4f, -0.6f, 0.85f, 0.3f, 360-300],
     [0, 0, 0, 0, 99999],
    ],[
     [-0.4f, 0.6f, 0.85f, 0.3f, 360-120],
     [0.4f, 0.6f, 0.85f, 0.3f, 360-60],
     [-0.1f, -0.55f, 0.65f, 0.3f, 90],
     [0, 0, 0, 0, 99999],
    ],[
     [0, 1.15f, 0.65f, 0.3f, 0],
     [0.3f, 0.4f, 0.65f, 0.3f, 120],
     [-0.3f, -0.4f, 0.65f, 0.3f, 120],
     [0, -1.15f, 0.65f, 0.3f, 0],
     [0, 0, 0, 0, 99999],
    ],[//.
     [0, -1.15f, 0.3f, 0.3f, 0],
     [0, 0, 0, 0, 99999],
    ],[//_
     [0, -1.15f, 0.8f, 0.3f, 0],
     [0, 0, 0, 0, 99999],
    ],[//-
     [0, 0, 0.9f, 0.3f, 0],
     [0, 0, 0, 0, 99999],
    ],[//+
     [-0.5f, 0, 0.45f, 0.3f, 0], [0.45f, 0, 0.45f, 0.3f, 0],
     [0.1f, 0.55f, 0.65f, 0.3f, 90],
     [0.1f, -0.55f, 0.65f, 0.3f, 90],
     [0, 0, 0, 0, 99999],
    ],[//'
     [0, 1.0f, 0.4f, 0.2f, 90],
     [0, 0, 0, 0, 99999],
    ],[//''
     [-0.19f, 1.0f, 0.4f, 0.2f, 90],
     [0.2f, 1.0f, 0.4f, 0.2f, 90],
     [0, 0, 0, 0, 99999],
    ],[//!
     [0.56f, 0.25f, 1.1f, 0.3f, 90],
     [0, -1.0f, 0.3f, 0.3f, 90],
     [0, 0, 0, 0, 99999],
    ],[// /
     [0.8f, 0, 1.75f, 0.3f, 120],
     [0, 0, 0, 0, 99999],
    ]];
}
