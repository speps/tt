/*
    SDL - Simple DirectMedia Layer
    Copyright (C) 1997, 1998, 1999, 2000, 2001  Sam Lantinga

    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Library General Public
    License as published by the Free Software Foundation; either
    version 2 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Library General Public License for more details.

    You should have received a copy of the GNU Library General Public
    License along with this library; if not, write to the Free
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

    Sam Lantinga
    slouken@devolution.com
*/

/* Include file for SDL mouse event handling */

import SDL_types;
import SDL_video;

extern(C):

struct SDL_Cursor {
	SDL_Rect area;			/* The area of the mouse cursor */
	Sint16 hot_x, hot_y;		/* The "tip" of the cursor */
	Uint8 *data;			/* B/W cursor data */
	Uint8 *mask;			/* B/W cursor mask */
	Uint8 *save[2];			/* Place to save cursor area */
	void /*WMcursor*/ *wm_cursor;		/* Window-manager cursor */
}

/* Function prototypes */
/*
 * Retrieve the current state of the mouse.
 * The current button state is returned as a button bitmask, which can
 * be tested using the SDL_BUTTON(X) macros, and x and y are set to the
 * current mouse cursor position.  You can pass NULL for either x or y.
 */
Uint8 SDL_GetMouseState(int *x, int *y);

/*
 * Retrieve the current state of the mouse.
 * The current button state is returned as a button bitmask, which can
 * be tested using the SDL_BUTTON(X) macros, and x and y are set to the
 * mouse deltas since the last call to SDL_GetRelativeMouseState().
 */
Uint8 SDL_GetRelativeMouseState(int *x, int *y);

/*
 * Set the position of the mouse cursor (generates a mouse motion event)
 */
void SDL_WarpMouse(Uint16 x, Uint16 y);

/*
 * Create a cursor using the specified data and mask (in MSB format).
 * The cursor width must be a multiple of 8 bits.
 * 
 * The cursor is created in black and white according to the following:
 * data  mask    resulting pixel on screen
 *  0     1       White
 *  1     1       Black
 *  0     0       Transparent
 *  1     0       Inverted color if possible, black if not.
 * 
 * Cursors created with this function must be freed with SDL_FreeCursor().
 */
SDL_Cursor *SDL_CreateCursor
		(Uint8 *data, Uint8 *mask, int w, int h, int hot_x, int hot_y);

/*
 * Set the currently active cursor to the specified one.
 * If the cursor is currently visible, the change will be immediately 
 * represented on the display.
 */
void SDL_SetCursor(SDL_Cursor *cursor);

/*
 * Returns the currently active cursor.
 */
SDL_Cursor * SDL_GetCursor();

/*
 * Deallocates a cursor created with SDL_CreateCursor().
 */
void SDL_FreeCursor(SDL_Cursor *cursor);

/*
 * Toggle whether or not the cursor is shown on the screen.
 * The cursor start off displayed, but can be turned off.
 * SDL_ShowCursor() returns 1 if the cursor was being displayed
 * before the call, or 0 if it was not.  You can query the current
 * state by passing a 'toggle' value of -1.
 */
int SDL_ShowCursor(int toggle);

/* Used as a mask when testing buttons in buttonstate
   Button 1:	Left mouse button
   Button 2:	Middle mouse button
   Button 3:	Right mouse button
 */
uint SDL_BUTTON(uint X) { return SDL_PRESSED << (X-1); }
const uint SDL_BUTTON_LEFT		= 1;
const uint SDL_BUTTON_MIDDLE	= 2;
const uint SDL_BUTTON_RIGHT		= 3;
const uint SDL_BUTTON_WHEELUP	= 4;
const uint SDL_BUTTON_WHEELDOWN	= 5;
const uint SDL_BUTTON_LMASK		= SDL_PRESSED << (SDL_BUTTON_LEFT - 1);
const uint SDL_BUTTON_MMASK		= SDL_PRESSED << (SDL_BUTTON_MIDDLE - 1);
const uint SDL_BUTTON_RMASK		= SDL_PRESSED << (SDL_BUTTON_RIGHT - 1);
