/*
 * $Id: soundmanager.d,v 1.4 2005/01/01 12:40:28 kenta Exp $
 *
 * Copyright 2004 Kenta Cho. Some rights reserved.
 */
module abagames.tt.soundmanager;

private import std.path;
private import std.file;
private import abagames.util.rand;
private import abagames.util.logger;
private import abagames.util.listdir;
private import abagames.util.sdl.sound;

/**
 * Manage BGMs and SEs.
 */
public class SoundManager: abagames.util.sdl.sound.SoundManager {
 private static:
  string[] seFileName =
    ["shot.wav", "charge.wav", "charge_shot.wav", "hit.wav",
     "small_dest.wav", "middle_dest.wav", "boss_dest.wav",
     "myship_dest.wav", "extend.wav", "timeup_beep.wav"];
  int[] seChannel =
    [0, 1, 1, 2,
     3, 4, 4,
     5, 6, 7];
  Rand rand;
  Music[] bgm;
  Chunk[string] se;
  int prevBgmIdx;
  int nextIdxMv;
  bool seDisabled = false;

  public static void loadSounds() {
    bgm = loadMusics();
    se = loadChunks();
    prevBgmIdx = -1;
    rand = new Rand;
  }

  public static void setRandSeed(long seed) {
    rand.setSeed(seed);
  }

  private static Music[] loadMusics() {
    Music[] musics;
    string[] files = listdir(Music.dir);
    foreach (string fileName; files) {
      string ext = fileName.extension;
      if (ext != ".ogg" && ext != ".wav")
        continue;
      Music music = new Music();
      music.load(fileName);
      musics ~= music;
      Logger.info("Load bgm: " ~ fileName);
    }
    return musics;
  }

  private static Chunk[string] loadChunks() {
    Chunk[string] chunks;
    int i = 0;
    foreach (string fileName; seFileName) {
      Chunk chunk = new Chunk();
      chunk.load(fileName, seChannel[i]);
      chunks[fileName] = chunk;
      Logger.info("Load SE: " ~ fileName);
      i++;
    }
    return chunks;
  }

  public static void playBgm() {
    int bgmIdx = rand.nextInt(cast(int)bgm.length);
    nextIdxMv = rand.nextInt(2) * 2 - 1;
    if (bgmIdx == prevBgmIdx) {
      bgmIdx++;
      if (bgmIdx >= bgm.length)
        bgmIdx = 0;
    }
    prevBgmIdx = bgmIdx;
    bgm[bgmIdx].play();
  }

  public static void nextBgm() {
    int bgmIdx = prevBgmIdx + nextIdxMv;
    if (bgmIdx < 0)
      bgmIdx = cast(int)bgm.length - 1;
    else if (bgmIdx >= bgm.length)
        bgmIdx = 0;
    prevBgmIdx = bgmIdx;
    bgm[bgmIdx].play();
  }

  public static void fadeBgm() {
    Music.fadeMusic();
  }

  public static void haltBgm() {
    Music.haltMusic();
  }

  public static void playSe(string name) {
    if (seDisabled)
      return;
    se[name].play();
  }

  public static void disableSe() {
    seDisabled = true;
  }

  public static void enableSe() {
    seDisabled = false;
  }
}
