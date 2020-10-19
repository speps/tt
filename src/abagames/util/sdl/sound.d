/*
 * $Id: sound.d,v 1.1.1.1 2004/11/10 13:45:22 kenta Exp $
 *
 * Copyright 2004 Kenta Cho. Some rights reserved.
 */
module abagames.util.sdl.sound;

import std.conv;
import std.string;
version(BindBC) { import bindbc.sdl; }
version(BindBC) { import bindbc.sdl.mixer; }
import abagames.util.sdl.sdlexception;

public interface Sound {
  public void load(string name);
  public void load(string name, int ch);
  public void free();
  public void play();
  public void fade();
  public void halt();
}

version(SDL_Mixer) {

/**
 * Initialize and close SDL_mixer.
 */
public class SoundManager {
 public:
  static bool noSound = false;
 private:

  public static void init() {
    if (noSound)
      return;
    if (loadSDL() != sdlSupport) {
      noSound = true;
      return;
    }
    if (SDL_InitSubSystem(SDL_INIT_AUDIO) < 0) {
      noSound = true;
      throw new SDLInitFailedException
        ("Unable to initialize SDL_AUDIO: " ~ to!string(SDL_GetError()));
    }
    if (loadSDLMixer() != sdlMixerSupport) {
      noSound = true;
      return;
    }
    int audio_rate = 44100;
    Uint16 audio_format = AUDIO_S16;
    int audio_channels = 1;
    int audio_buffers = 4096;
    if (Mix_OpenAudio(audio_rate, audio_format, audio_channels, audio_buffers) < 0) {
      noSound = true;
      throw new SDLInitFailedException
        ("Couldn't open audio: " ~ to!string(SDL_GetError()));
    }
    Mix_QuerySpec(&audio_rate, &audio_format, &audio_channels);
  }

  public static void close() {
    if (noSound)
      return;
    if (Mix_PlayingMusic()) {
      Mix_HaltMusic();
    }
    Mix_CloseAudio();
  }
}

/**
 * Music / Chunk.
 */

public class Music: Sound {
 public:
  static int fadeOutSpeed = 1280;
  static string dir = "sounds/musics";
 private:
  Mix_Music* music;

  public void load(string name) {
    if (SoundManager.noSound)
      return;
    string fileName = dir ~ "/" ~ name;
    music = Mix_LoadMUS(toStringz(fileName));
    if (!music) {
      SoundManager.noSound = true;
      throw new SDLException("Couldn't load: " ~ fileName ~ 
                             " (" ~ to!string(Mix_GetError()) ~ ")");
    }
  }
  
  public void load(string name, int ch) {
    load(name);
  }

  public void free() {
    if (music) {
      halt();
      Mix_FreeMusic(music);
    }
  }

  public void play() {
    if (SoundManager.noSound)
      return;
    Mix_PlayMusic(music, -1);
  }

  public void playOnce() {
    if (SoundManager.noSound)
      return;
    Mix_PlayMusic(music, 1);
  }

  public void fade() {
    Music.fadeMusic();
  }

  public void halt() {
    Music.haltMusic();
  }

  public static void fadeMusic() {
    if (SoundManager.noSound)
      return;
    Mix_FadeOutMusic(fadeOutSpeed);
  }

  public static void haltMusic() {
    if (SoundManager.noSound)
      return;
    if (Mix_PlayingMusic()) {
      Mix_HaltMusic();
    }
  }
}

public class Chunk: Sound {
 public:
  static string dir = "sounds/chunks";
 private:
  Mix_Chunk* chunk;
  int chunkChannel;

  public void load(string name) {
    load(name, 0);
  }
  
  public void load(string name, int ch) {
    if (SoundManager.noSound)
      return;
    string fileName = dir ~ "/" ~ name;
    chunk = Mix_LoadWAV(toStringz(fileName));
    if (!chunk) {
      SoundManager.noSound = true;
      throw new SDLException("Couldn't load: " ~ fileName ~ 
                             " (" ~ to!string(Mix_GetError()) ~ ")");
    }
    chunkChannel = ch;
  }

  public void free() {
    if (chunk) {
      halt();
      Mix_FreeChunk(chunk);
    }
  }

  public void play() {
    if (SoundManager.noSound)
      return;
    Mix_PlayChannel(chunkChannel, chunk, 0);
  }

  public void halt() {
    if (SoundManager.noSound)
      return;
    Mix_HaltChannel(chunkChannel);
  }

  public void fade() {
    halt();
  }
}

} else {

public class SoundManager {
public:
  static bool noSound = false;
  static void init() {}
  static void close() {}
}

public class Music: Sound {
public:
  public void load(string name) {}
  public void load(string name, int ch) {}
  public void free() {}
  public void play() {}
  public void playOnce() {}
  public void fade() {}
  public void halt() {}
  public static void fadeMusic() {}
  public static void haltMusic() {}
}

public class Chunk: Sound {
public:
  public void load(string name) {}
  public void load(string name, int ch) {}
  public void free() {}
  public void play() {}
  public void playOnce() {}
  public void fade() {}
  public void halt() {}
}

}