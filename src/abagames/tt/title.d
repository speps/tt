/*
 * $Id: title.d,v 1.3 2005/01/01 12:40:28 kenta Exp $
 *
 * Copyright 2004 Kenta Cho. Some rights reserved.
 */
module abagames.tt.title;

import std.math;
import bindbc.opengl;
import abagames.util.gl;
import abagames.util.gl;
import abagames.util.vector;
import abagames.util.sdl.texture;
import abagames.util.sdl.pad;
import abagames.tt.screen;
import abagames.tt.prefmanager;
import abagames.tt.ship;
import abagames.tt.letter;
import abagames.tt.gamemanager;

/**
 * Title screen.
 */
public class TitleManager {
 private:
  static const int REPLAY_CHANGE_DURATION = 30;
  static const int AUTO_REPEAT_START_TIME = 30;
  static const int AUTO_REPEAT_CNT = 5;
  PrefManager prefManager;
  Pad pad;
  Ship ship;
  GameManager gameManager;
  int cnt;
  Texture titleTexture;
  int grade, level;
  bool dirPressed, btnPressed;
  int keyRepeatCnt;
  int replayCnt;
  bool _replayMode;
  float _replayChangeRatio;

  public this(PrefManager pm, Pad p, Ship s, GameManager gm) {
    prefManager = pm;
    pad = p;
    ship = s;
    gameManager = gm;
    titleTexture = new Texture("title.bmp");
  }

  public void start() {
    cnt = 0;
    grade = prefManager.prefData.selectedGrade;
    level = prefManager.prefData.selectedLevel;
    keyRepeatCnt = 0;
    dirPressed = btnPressed = true;
    replayCnt = 0;
    _replayMode = false;
  }

  public void move(bool hasReplayData) {
    int dir = pad.getDirState();
    if (!replayMode) {
      if (dir & (Pad.Dir.RIGHT | Pad.Dir.LEFT)) {
        if (!dirPressed) {
          dirPressed = true;
          if (dir & Pad.Dir.RIGHT) {
            grade++;
            if (grade >= Ship.GRADE_NUM)
              grade = 0;
          }
          if (dir & Pad.Dir.LEFT) {
            grade--;
            if (grade < 0)
              grade = Ship.GRADE_NUM - 1;
          }
          if (level > prefManager.prefData.getMaxLevel(grade))
            level = prefManager.prefData.getMaxLevel(grade);
        }
      }
      if (dir & (Pad.Dir.UP | Pad.Dir.DOWN)) {
        int mv = 0;
        if (!dirPressed) {
          dirPressed = true;
          mv = 1;
        } else {
          keyRepeatCnt++;
          if (keyRepeatCnt >= AUTO_REPEAT_START_TIME) {
            if (keyRepeatCnt % AUTO_REPEAT_CNT == 0) {
              mv = (keyRepeatCnt / AUTO_REPEAT_START_TIME) *
                (keyRepeatCnt / AUTO_REPEAT_START_TIME);
            }
          }
        }
        if (dir & Pad.Dir.DOWN) {
          level += mv;
          if (level > prefManager.prefData.getMaxLevel(grade)) {
            if (keyRepeatCnt >= AUTO_REPEAT_START_TIME)
              level = prefManager.prefData.getMaxLevel(grade);
            else
              level = 1;
            keyRepeatCnt = 0;
          }
        }
        if (dir & Pad.Dir.UP) {
          level -= mv;
          if (level < 1) {
            if (keyRepeatCnt >= AUTO_REPEAT_START_TIME)
              level = 1;
            else
              level = prefManager.prefData.getMaxLevel(grade);
            keyRepeatCnt = 0;
          }
        }
      }
    } else {
      if (dir & (Pad.Dir.RIGHT | Pad.Dir.LEFT)) {
        if (!dirPressed) {
          dirPressed = true;
          if (dir & Pad.Dir.RIGHT) {
            ship.cameraMode = false;
          }
          if (dir & Pad.Dir.LEFT) {
            ship.cameraMode = true;
          }
        }
      }
      if (dir & (Pad.Dir.UP | Pad.Dir.DOWN)) {
        if (!dirPressed) {
          dirPressed = true;
          if (dir & Pad.Dir.UP) {
            ship.drawFrontMode = true;
          }
          if (dir & Pad.Dir.DOWN) {
            ship.drawFrontMode = false;
          }
        }
      }
    }
    if (dir == 0) {
      dirPressed = false;
      keyRepeatCnt = 0;
    }
    int btn = pad.getButtonState();
    if (btn & Pad.Button.ANY) {
      if (!btnPressed) {
        btnPressed = true;
        if (btn & Pad.Button.A) {
          if (!replayMode) {
            prefManager.prefData.recordStartGame(grade, level);
            gameManager.startInGame();
          }
        }
        if (hasReplayData)
          if (btn & Pad.Button.B)
            _replayMode = !_replayMode;
      }
    } else {
      btnPressed = false;
    }
    cnt++;
    if (_replayMode) {
      if (replayCnt < REPLAY_CHANGE_DURATION)
        replayCnt++;
    } else {
      if (replayCnt > 0)
        replayCnt--;
    }
    _replayChangeRatio = cast(float) replayCnt / REPLAY_CHANGE_DURATION;
  }

  public void draw() {
    if (_replayChangeRatio >= 1.0f)
      return;
    GL.popMatrix();
    Screen.viewOrthoFixed();
    glDisable(GL_BLEND);
    Screen.setColor(0, 0, 0);
    float rcr = _replayChangeRatio * 2;
    if (rcr > 1)
      rcr = 1;
    // GL.begin(GL_QUADS);
    // GL.vertex(450 + (640 - 450) * rcr, 0, 0);
    // GL.vertex(640, 0, 0);
    // GL.vertex(640, 480, 0);
    // GL.vertex(450 + (640 - 450) * rcr, 480, 0);
    // GL.end();
    glEnable(GL_BLEND);
    Screen.viewPerspective();
    GL.pushMatrix();
    GL.lookAt(0, 0, -1, 0, 0, 0, 0, 1, 0);
    GL.pushMatrix();
    GL.translate(3 - _replayChangeRatio * 2.4f, 1.8f, 3.5f - _replayChangeRatio * 1.5f);
    GL.rotate(30, 1, 0, 0);
    GL.rotate(sin(cnt * 0.005f) * 12, 0, 1, 0);
    GL.rotate(cnt * 0.2f, 0, 0, 1);
    glDisable(GL_BLEND);
    Screen.setColor(0, 0, 0);
    createTorusShape(1);
    glEnable(GL_BLEND);
    Screen.setColor(1, 1, 1, 0.5f);
    createTorusShape(0);
    GL.popMatrix();
  }

  public void drawFront() {
    if (_replayChangeRatio > 0)
      return;
    GL.pushMatrix();
    GL.translate(508, 400, 0);
    GL.rotate(-20, 0, 0, 1);
    GL.scale(128, 64, 1);
    glLineWidth(2);
    createTorusShape(2);
    glLineWidth(1);
    GL.popMatrix();
    Screen.setColor(1, 1, 1);
    glEnable(GL_TEXTURE_2D);
    titleTexture.bind();
    GL.begin(GL_TRIANGLE_FAN);
    GL.texCoord(0, 0);
    GL.vertex(470, 380, 0);
    GL.texCoord(1, 0);
    GL.vertex(598, 380, 0);
    GL.texCoord(1, 1);
    GL.vertex(598, 428, 0);
    GL.texCoord(0, 1);
    GL.vertex(470, 428, 0);
    GL.end();
    glDisable(GL_TEXTURE_2D);
    float cx, cy;
    for (int i = 0; i < Ship.GRADE_NUM; i++) {
      glLineWidth(2);
      calcCursorPos(cx, cy, i, 1);
      drawCursorRing(cx, cy, 15);
      Letter.drawString(Ship.GRADE_LETTER[i], cx - 4, cy - 10, 7);
      glLineWidth(1);
      int ml = prefManager.prefData.getMaxLevel(i);
      if (ml > 1) {
        float ecx, ecy;
        calcCursorPos(ecx, ecy, i, ml);
        drawCursorRing(ecx, ecy, 15);
        Letter.drawNum(ml, ecx + 7, ecy - 8, 6);
        float l2cx, l2cy;
        calcCursorPos(l2cx, l2cy, i, 2);
        GL.begin(GL_LINES);
        GL.vertex(cx - 29, cy + 7, 0);
        GL.vertex(l2cx - 29, l2cy + 7, 0);
        GL.vertex(l2cx - 29, l2cy + 7, 0);
        GL.vertex(ecx - 29, ecy + 7, 0);
        GL.vertex(cx + 29, cy - 7, 0);
        GL.vertex(l2cx + 29, l2cy - 7, 0);
        GL.vertex(l2cx + 29, l2cy - 7, 0);
        GL.vertex(ecx + 29, ecy - 7, 0);
        GL.end();
      }
    }
    Letter.drawString(Ship.GRADE_STR[grade],
                      560 - Ship.GRADE_STR[grade].length * 19, 4, 9);
    Letter.drawNum(level, 620, 10, 6);
    Letter.drawString("LV", 570, 10, 6);
    GradeData gd = prefManager.prefData.getGradeData(grade);
    Letter.drawNum(gd.hiScore, 620, 45, 8);
    Letter.drawNum(gd.startLevel, 408, 54, 5);
    Letter.drawNum(gd.endLevel, 453, 54, 5);
    Letter.drawString("-", 423, 54, 5);
    calcCursorPos(cx, cy, grade, level);
    drawCursorRing(cx, cy, 18 + sin(cnt * 0.1f) * 3);
  }

  private void calcCursorPos(ref float x, ref float y, int gd, int lv) {
    x = 460 + gd * 70;
    y = 90;
    if (lv > 1) {
      y += 30 + lv;
      x -= lv * 0.33f;
    }
  }

  private void drawCursorRing(float x, float y, float s) {
    GL.pushMatrix();
    GL.translate(x, y, 0);
    GL.rotate(-20, 0, 0, 1);
    GL.scale(s * 2, s, 1);
    createTorusShape(2);
    GL.popMatrix();
  }

  private void createTorusShape(int n) {
    Vector3 cp = new Vector3;
    cp.z = 0;
    Vector3 ringOfs = new Vector3;
    float torusRad = 5;
    float ringRad = 0.7;
    if (n == 0) {
      float d1 = 0;
      for (int i = 0; i < 32; i++, d1 += PI * 2 / 32) {
        float d2 = 0;
        for (int j = 0; j < 16; j++, d2 += PI * 2 / 16) {
          cp.x = sin(d1) * torusRad;
          cp.y = cos(d1) * torusRad;
          GL.begin(GL_LINE_STRIP);
          createRingOffset(ringOfs, cp, ringRad, d1, d2);
          Screen.glVertex(ringOfs);
          createRingOffset(ringOfs, cp, ringRad, d1, d2 + PI * 2 / 16);
          Screen.glVertex(ringOfs);
          cp.x = sin(d1 + PI * 2 / 32) * torusRad;
          cp.y = cos(d1 + PI * 2 / 32) * torusRad;
          createRingOffset(ringOfs, cp, ringRad, d1 + PI * 2 / 32, d2 + PI * 2 / 16);
          Screen.glVertex(ringOfs);
          GL.end();
        }
      }
    }
    else if (n == 1)
    {
      float d1 = 0;
      // GL.begin(GL_QUADS);
      // for (int i = 0; i < 32; i++, d1 += PI * 2 / 32) {
      //   cp.x = sin(d1) * (torusRad + ringRad);
      //   cp.y = cos(d1) * (torusRad + ringRad);
      //   Screen.glVertex(cp);
      //   cp.x = sin(d1) * (torusRad + ringRad * 10);
      //   cp.y = cos(d1) * (torusRad + ringRad * 10);
      //   Screen.glVertex(cp);
      //   cp.x = sin(d1 + PI * 2 / 32) * (torusRad + ringRad * 10);
      //   cp.y = cos(d1 + PI * 2 / 32) * (torusRad + ringRad * 10);
      //   Screen.glVertex(cp);
      //   cp.x = sin(d1 + PI * 2 / 32) * (torusRad + ringRad);
      //   cp.y = cos(d1 + PI * 2 / 32) * (torusRad + ringRad);
      //   Screen.glVertex(cp);
      // }
      // d1 = 0;
      // for (int i = 0; i < 32; i++, d1 += PI * 2 / 32) {
      //   float d2 = 0;
      //   for (int j = 0; j < 16; j++, d2 += PI * 2 / 16) {
      //     cp.x = sin(d1) * torusRad;
      //     cp.y = cos(d1) * torusRad;
      //     createRingOffset(ringOfs, cp, ringRad, d1, d2);
      //     Screen.glVertex(ringOfs);
      //     createRingOffset(ringOfs, cp, ringRad, d1, d2 + PI * 2 / 16);
      //     Screen.glVertex(ringOfs);
      //     cp.x = sin(d1 + PI * 2 / 32) * torusRad;
      //     cp.y = cos(d1 + PI * 2 / 32) * torusRad;
      //     createRingOffset(ringOfs, cp, ringRad, d1 + PI * 2 / 32, d2 + PI * 2 / 16);
      //     Screen.glVertex(ringOfs);
      //     createRingOffset(ringOfs, cp, ringRad, d1 + PI * 2 / 32, d2);
      //     Screen.glVertex(ringOfs);
      //   }
      // }
      // GL.end();
    }
    else if (n == 2) {
      float d1 = 0;
      Screen.setColor(1, 1, 1);
      GL.begin(GL_LINE_LOOP);
      for (int i = 0; i < 128; i++, d1 += PI * 2 / 128) {
        cp.x = sin(d1);
        cp.y = cos(d1);
        Screen.glVertex(cp);
      }
      GL.end();
      Screen.setColor(1, 1, 1, 0.3f);
      GL.begin(GL_TRIANGLE_FAN);
      GL.vertex(0, 0, 0);
      for (int i = 0; i <= 128; i++, d1 += PI * 2 / 128) {
        cp.x = sin(d1);
        cp.y = cos(d1);
        Screen.glVertex(cp);
      }
      GL.end();
    }
  }

  public void createRingOffset(Vector3 ringOfs, Vector3 centerPos,
                               float rad, float d1, float d2) {
    ringOfs.x = 0;
    ringOfs.y = rad;
    ringOfs.z = 0;
    ringOfs.rollX(d2);
    ringOfs.rollZ(-d1);
    ringOfs += centerPos;
  }

  public bool replayMode() {
    return _replayMode;
  }

  public float replayChangeRatio() {
    return _replayChangeRatio;
  }
}
