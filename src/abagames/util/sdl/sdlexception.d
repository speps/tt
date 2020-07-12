/*
 * $Id: sdlexception.d,v 1.1.1.1 2004/11/10 13:45:22 kenta Exp $
 *
 * Copyright 2004 Kenta Cho. Some rights reserved.
 */
module abagames.util.sdl.sdlexception;

/**
 * SDL initialize failed.
 */
public class SDLInitFailedException: Exception {
  public this(string msg) {
    super(msg);
  }
}

/**
 * SDL general exception.
 */
public class SDLException: Exception {
  public this(string msg) {
    super(msg);
  }
}
