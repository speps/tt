/*
 * $Id: screen3d.d,v 1.2 2005/01/01 12:40:28 kenta Exp $
 *
 * Copyright 2004 Kenta Cho. Some rights reserved.
 */
module abagames.util.sdl.screen3d;

import std.conv;
import std.string;
import bindbc.sdl;
import bindbc.opengl;
import abagames.util.vector;
import abagames.util.sdl.screen;
import abagames.util.sdl.sdlexception;

/**
 * SDL screen handler(3D, OpenGL).
 */
public class Screen3D: Screen {
 public:
  static float brightness = 1;
  static int width = 800;
  static int height = 600;
  static bool windowMode = true;
  static float nearPlane = 0.1;
  static float farPlane = 1000;
 private:

  SDL_Window* window;
  SDL_Renderer* renderer;
  SDL_GLContext context;

  protected abstract void init();
  protected abstract void close();

  public void initSDL() {
    if (loadSDL() != sdlSupport) {
      throw new SDLInitFailedException("Unable to load SDL");
    }
    // Initialize SDL.
    if (SDL_Init(SDL_INIT_VIDEO) < 0) {
      throw new SDLInitFailedException("Unable to initialize SDL: " ~ to!string(SDL_GetError()));
    }
    // Create an OpenGL screen.
    SDL_WindowFlags videoFlags;
    if (windowMode) {
      videoFlags = SDL_WINDOW_OPENGL | SDL_WINDOW_RESIZABLE;
    } else {
      videoFlags = SDL_WINDOW_OPENGL | SDL_WINDOW_FULLSCREEN;
    }
    if (SDL_CreateWindowAndRenderer(width, height, videoFlags, &window, &renderer) != 0) {
      throw new SDLInitFailedException("Unable to create SDL screen: " ~ to!string(SDL_GetError()));
    }
    context = SDL_GL_CreateContext(window);
    loadOpenGL();
    if (!isOpenGLLoaded) {
      throw new SDLInitFailedException("Unable to load OpenGL");
    }
    glViewport(0, 0, width, height);
    glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
    resized(width, height);
    SDL_ShowCursor(SDL_DISABLE);
    init();
  }

  // Reset viewport when the screen is resized.

  public void screenResized() {
    glViewport(0, 0, width, height);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    //gluPerspective(45.0f, cast(GLfloat) width / cast(GLfloat) height, nearPlane, farPlane);
    glFrustum(-nearPlane,
	      nearPlane,
	      -nearPlane * cast(GLfloat) height / cast(GLfloat) width,
	      nearPlane * cast(GLfloat) height / cast(GLfloat) width,
              0.1f, farPlane);
    glMatrixMode(GL_MODELVIEW);
  }

  public void resized(int width, int height) {
    this.width = width;
    this.height = height;
    screenResized();
  }

  public void closeSDL() {
    SDL_DestroyRenderer(renderer);
    renderer = null;
    SDL_DestroyWindow(window);
    window = null;
    SDL_GL_DeleteContext(context);
    close();
    SDL_ShowCursor(SDL_ENABLE);
  }

  public void flip() {
    handleError();
    SDL_GL_SwapWindow(window);
  }

  public void clear() {
    glClear(GL_COLOR_BUFFER_BIT);
  }

  public void handleError() {
    GLenum error = glGetError();
    if (error == GL_NO_ERROR)
      return;
    closeSDL();
    throw new Exception("OpenGL error(" ~ to!string(error) ~ ")");
  }

  protected void setCaption(string name) {
    SDL_SetWindowTitle(window, std.string.toStringz(name));
  }

  public static void setColor(float r, float g, float b, float a = 1) {
    glColor4f(r * brightness, g * brightness, b * brightness, a);
  }

  public static void setClearColor(float r, float g, float b, float a = 1) {
    glClearColor(r * brightness, g * brightness, b * brightness, a);
  }

  public static void glVertex(Vector3 v) {
    glVertex3f(v.x, v.y, v.z);
  }

  public static void glTranslate(Vector3 v) {
    glTranslatef(v.x, v.y, v.z);
  }
}
