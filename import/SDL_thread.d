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

/* Header for the SDL thread management routines 

	These are independent of the other SDL routines.
*/

import SDL_types;
import SDL_mutex;

extern(C):

/* The SDL thread structure, defined in SDL_thread.c */
struct SDL_Thread { }

/* Create a thread */
SDL_Thread * SDL_CreateThread(int (*fn)(void *), void *data);

/* Get the 32-bit thread identifier for the current thread */
Uint32 SDL_ThreadID();

/* Get the 32-bit thread identifier for the specified thread,
   equivalent to SDL_ThreadID() if the specified thread is NULL.
 */
Uint32 SDL_GetThreadID(SDL_Thread *thread);

/* Wait for a thread to finish.
   The return code for the thread function is placed in the area
   pointed to by 'status', if 'status' is not NULL.
 */
void SDL_WaitThread(SDL_Thread *thread, int *status);

/* Forcefully kill a thread without worrying about its state */
void SDL_KillThread(SDL_Thread *thread);
