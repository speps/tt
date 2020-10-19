/*
 * $Id: screen.d,v 1.1.1.1 2004/11/10 13:45:22 kenta Exp $
 *
 * Copyright 2004 Kenta Cho. Some rights reserved.
 */
module abagames.util.sdl.screen;

/**
 * SDL screen handler interface.
 */
public interface Screen {
  public void initWindow();
  public void closeWindow();
  public void flip();
  public void clear();
}
