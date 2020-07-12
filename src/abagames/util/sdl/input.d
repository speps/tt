/*
 * $Id: input.d,v 1.1.1.1 2004/11/10 13:45:22 kenta Exp $
 *
 * Copyright 2004 Kenta Cho. Some rights reserved.
 */
module abagames.util.sdl.input;

private import SDL;
private import SDL_events;

/**
 * Input device interface.
 */
public interface Input {
  public void handleEvent(SDL_Event *event);
}
