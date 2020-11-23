/*
 * $Id: screen3d.d,v 1.2 2005/01/01 12:40:28 kenta Exp $
 *
 * Copyright 2004 Kenta Cho. Some rights reserved.
 */
module abagames.util.sdl.screen3d;

version(BindBC) {
  import std.conv;
  import std.stdio;
  import std.string;
  import bindbc.sdl;
  import bindbc.opengl;
}
import abagames.util.gl;
import abagames.util.vector;
import abagames.util.sdl.screen;
import abagames.util.sdl.sdlexception;

version(BindBC) {

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

  public void initWindow() {
    if (loadSDL() != sdlSupport) {
      throw new SDLInitFailedException("Unable to load SDL");
    }
    // Initialize SDL.
    if (SDL_Init(SDL_INIT_VIDEO) < 0) {
      throw new SDLInitFailedException("Unable to initialize SDL: " ~ to!string(SDL_GetError()));
    }

version(GL_32) {
    SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK, SDL_GL_CONTEXT_PROFILE_CORE);
    SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 3);
    SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 2);
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
    auto glStatus = loadOpenGL();
    if (!isOpenGLLoaded) {
      throw new SDLInitFailedException("Unable to load OpenGL");
    }
    writeln("OpenGL Status: ", glStatus);
    GL.init();
    GL.viewport(0, 0, width, height);
    GL.clearColor(0.0f, 0.0f, 0.0f, 0.0f);
    resized(width, height);
    SDL_ShowCursor(SDL_DISABLE);
    init();
  }

  // Reset viewport when the screen is resized.

  public void screenResized() {
    GL.viewport(0, 0, width, height);
    GL.matrixMode(GL.MatrixMode.Projection);
    GL.loadIdentity();
    //gluPerspective(45.0f, cast(float) width / cast(float) height, nearPlane, farPlane);
    GL.frustum(-nearPlane,
	      nearPlane,
	      -nearPlane * cast(float) height / cast(float) width,
	      nearPlane * cast(float) height / cast(float) width,
              0.1f, farPlane);
    GL.matrixMode(GL.MatrixMode.ModelView);
  }

  public void resized(int width, int height) {
    this.width = width;
    this.height = height;
    screenResized();
  }

  public void closeWindow() {
    SDL_DestroyRenderer(renderer);
    renderer = null;
    SDL_DestroyWindow(window);
    window = null;
    SDL_GL_DeleteContext(context);
    SDL_ShowCursor(SDL_ENABLE);
    SDL_Quit();
  }

  public void flip() {
    handleError();
    SDL_GL_SwapWindow(window);
  }

  public void clear() {
    GL.clear(GL.COLOR_BUFFER_BIT);
  }

  public void handleError() {
    // GLenum error = glGetError();
    // if (error == GL.NO_ERROR)
    //   return;
    // closeWindow();
    // throw new Exception("OpenGL error(" ~ convString(error) ~ ")");
  }

  protected void setCaption(string name) {
    SDL_SetWindowTitle(window, toStringz(name));
  }

  public static void setColor(float r, float g, float b, float a = 1) {
    GL.color(r * brightness, g * brightness, b * brightness, a);
  }

  public static void setClearColor(float r, float g, float b, float a = 1) {
    GL.clearColor(r * brightness, g * brightness, b * brightness, a);
  }
}

}
else
{

/**
 * Generic screen handler(3D, OpenGL).
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

  protected abstract void init();

  public void initWindow() {
    GL.init();
    GL.viewport(0, 0, width, height);
    GL.clearColor(0.0f, 0.0f, 0.0f, 0.0f);
    resized(width, height);
    init();
  }

  // Reset viewport when the screen is resized.
  public void screenResized() {
    GL.viewport(0, 0, width, height);
    GL.matrixMode(GL.MatrixMode.Projection);
    GL.loadIdentity();
    //gluPerspective(45.0f, cast(GLfloat) width / cast(GLfloat) height, nearPlane, farPlane);
    GL.frustum(-nearPlane,
	      nearPlane,
	      -nearPlane * cast(float) height / cast(float) width,
	      nearPlane * cast(float) height / cast(float) width,
              0.1f, farPlane);
    GL.matrixMode(GL.MatrixMode.ModelView);
  }

  public override void resized(int width, int height) {
    this.width = width;
    this.height = height;
    screenResized();
  }

  public void closeWindow() {
  }

  public void flip() {
  }

  public void clear() {
    GL.clear(GL.COLOR_BUFFER_BIT);
  }

  protected void setCaption(string name) {
  }

  public static void setColor(float r, float g, float b, float a = 1) {
    GL.color(r * brightness, g * brightness, b * brightness, a);
  }

  public static void setClearColor(float r, float g, float b, float a = 1) {
    GL.clearColor(r * brightness, g * brightness, b * brightness, a);
  }
}

}