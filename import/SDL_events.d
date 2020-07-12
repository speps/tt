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

/* Include file for SDL event handling */

import SDL_types;
import SDL_active;
import SDL_keyboard;
import SDL_mouse;
import SDL_joystick;
import SDL_syswm;

extern(C):

/* Event enumerations */
enum { SDL_NOEVENT = 0,			/* Unused (do not remove) */
       SDL_ACTIVEEVENT,			/* Application loses/gains visibility */
       SDL_KEYDOWN,			/* Keys pressed */
       SDL_KEYUP,			/* Keys released */
       SDL_MOUSEMOTION,			/* Mouse moved */
       SDL_MOUSEBUTTONDOWN,		/* Mouse button pressed */
       SDL_MOUSEBUTTONUP,		/* Mouse button released */
       SDL_JOYAXISMOTION,		/* Joystick axis motion */
       SDL_JOYBALLMOTION,		/* Joystick trackball motion */
       SDL_JOYHATMOTION,		/* Joystick hat position change */
       SDL_JOYBUTTONDOWN,		/* Joystick button pressed */
       SDL_JOYBUTTONUP,			/* Joystick button released */
       SDL_QUIT,			/* User-requested quit */
       SDL_SYSWMEVENT,			/* System specific event */
       SDL_EVENT_RESERVEDA,		/* Reserved for future use.. */
       SDL_EVENT_RESERVEDB,		/* Reserved for future use.. */
       SDL_VIDEORESIZE,			/* User resized video mode */
       SDL_VIDEOEXPOSE,			/* Screen needs to be redrawn */
       SDL_EVENT_RESERVED2,		/* Reserved for future use.. */
       SDL_EVENT_RESERVED3,		/* Reserved for future use.. */
       SDL_EVENT_RESERVED4,		/* Reserved for future use.. */
       SDL_EVENT_RESERVED5,		/* Reserved for future use.. */
       SDL_EVENT_RESERVED6,		/* Reserved for future use.. */
       SDL_EVENT_RESERVED7,		/* Reserved for future use.. */
       /* Events SDL_USEREVENT through SDL_MAXEVENTS-1 are for your use */
       SDL_USEREVENT = 24,
       /* This last event is only for bounding internal arrays
	  It is the number of bits in the event mask datatype -- Uint32
        */
       SDL_NUMEVENTS = 32
}

/* Predefined event masks */
uint SDL_EVENTMASK(uint X) { return 1 << (X); }
enum {
	SDL_ACTIVEEVENTMASK	= 1 << SDL_ACTIVEEVENT,
	SDL_KEYDOWNMASK		= 1 << SDL_KEYDOWN,
	SDL_KEYUPMASK		= 1 << SDL_KEYUP,
	SDL_MOUSEMOTIONMASK	= 1 << SDL_MOUSEMOTION,
	SDL_MOUSEBUTTONDOWNMASK	= 1 << SDL_MOUSEBUTTONDOWN,
	SDL_MOUSEBUTTONUPMASK	= 1 << SDL_MOUSEBUTTONUP,
	SDL_MOUSEEVENTMASK	= (1 << SDL_MOUSEMOTION) |
	                          (1 << SDL_MOUSEBUTTONDOWN)|
	                          (1 << SDL_MOUSEBUTTONUP),
	SDL_JOYAXISMOTIONMASK	= (1 << SDL_JOYAXISMOTION),
	SDL_JOYBALLMOTIONMASK	= (1 << SDL_JOYBALLMOTION),
	SDL_JOYHATMOTIONMASK	= (1 << SDL_JOYHATMOTION),
	SDL_JOYBUTTONDOWNMASK	= (1 << SDL_JOYBUTTONDOWN),
	SDL_JOYBUTTONUPMASK	= 1 << SDL_JOYBUTTONUP,
	SDL_JOYEVENTMASK	= (1 << SDL_JOYAXISMOTION)|
	                          (1 << SDL_JOYBALLMOTION)|
	                          (1 << SDL_JOYHATMOTION)|
	                          (1 << SDL_JOYBUTTONDOWN)|
	                          (1 << SDL_JOYBUTTONUP),
	SDL_VIDEORESIZEMASK	= 1 << SDL_VIDEORESIZE,
	SDL_VIDEOEXPOSEMASK	= 1 << SDL_VIDEOEXPOSE,
	SDL_QUITMASK		= 1 << SDL_QUIT,
	SDL_SYSWMEVENTMASK	= 1 << SDL_SYSWMEVENT
}
const uint SDL_ALLEVENTS	= 0xFFFFFFFF;

/* Application visibility event structure */
struct SDL_ActiveEvent {
	Uint8 type;	/* SDL_ACTIVEEVENT */
	Uint8 gain;	/* Whether given states were gained or lost (1/0) */
	Uint8 state;	/* A mask of the focus states */
}

/* Keyboard event structure */
struct SDL_KeyboardEvent {
	Uint8 type;	/* SDL_KEYDOWN or SDL_KEYUP */
	Uint8 which;	/* The keyboard device index */
	Uint8 state;	/* SDL_PRESSED or SDL_RELEASED */
	SDL_keysym keysym;
}

/* Mouse motion event structure */
struct SDL_MouseMotionEvent {
	Uint8 type;	/* SDL_MOUSEMOTION */
	Uint8 which;	/* The mouse device index */
	Uint8 state;	/* The current button state */
	Uint16 x, y;	/* The X/Y coordinates of the mouse */
	Sint16 xrel;	/* The relative motion in the X direction */
	Sint16 yrel;	/* The relative motion in the Y direction */
}

/* Mouse button event structure */
struct SDL_MouseButtonEvent {
	Uint8 type;	/* SDL_MOUSEBUTTONDOWN or SDL_MOUSEBUTTONUP */
	Uint8 which;	/* The mouse device index */
	Uint8 button;	/* The mouse button index */
	Uint8 state;	/* SDL_PRESSED or SDL_RELEASED */
	Uint16 x, y;	/* The X/Y coordinates of the mouse at press time */
}

/* Joystick axis motion event structure */
struct SDL_JoyAxisEvent {
	Uint8 type;	/* SDL_JOYAXISMOTION */
	Uint8 which;	/* The joystick device index */
	Uint8 axis;	/* The joystick axis index */
	Sint16 value;	/* The axis value (range: -32768 to 32767) */
}

/* Joystick trackball motion event structure */
struct SDL_JoyBallEvent {
	Uint8 type;	/* SDL_JOYBALLMOTION */
	Uint8 which;	/* The joystick device index */
	Uint8 ball;	/* The joystick trackball index */
	Sint16 xrel;	/* The relative motion in the X direction */
	Sint16 yrel;	/* The relative motion in the Y direction */
}

/* Joystick hat position change event structure */
struct SDL_JoyHatEvent {
	Uint8 type;	/* SDL_JOYHATMOTION */
	Uint8 which;	/* The joystick device index */
	Uint8 hat;	/* The joystick hat index */
	Uint8 value;	/* The hat position value:
				8   1   2
				7   0   3
				6   5   4
			   Note that zero means the POV is centered.
			*/
}

/* Joystick button event structure */
struct SDL_JoyButtonEvent {
	Uint8 type;	/* SDL_JOYBUTTONDOWN or SDL_JOYBUTTONUP */
	Uint8 which;	/* The joystick device index */
	Uint8 button;	/* The joystick button index */
	Uint8 state;	/* SDL_PRESSED or SDL_RELEASED */
}

/* The "window resized" event
   When you get this event, you are responsible for setting a new video
   mode with the new width and height.
 */
struct SDL_ResizeEvent {
	Uint8 type;	/* SDL_VIDEORESIZE */
	int w;		/* New width */
	int h;		/* New height */
}

/* The "screen redraw" event */
struct SDL_ExposeEvent {
	Uint8 type;	/* SDL_VIDEOEXPOSE */
}

/* The "quit requested" event */
struct SDL_QuitEvent {
	Uint8 type;	/* SDL_QUIT */
}

/* A user-defined event type */
struct SDL_UserEvent {
	Uint8 type;	/* SDL_USEREVENT through SDL_NUMEVENTS-1 */
	int code;	/* User defined event code */
	void *data1;	/* User defined data pointer */
	void *data2;	/* User defined data pointer */
}

/* If you want to use this event, you should include SDL_syswm.h */
struct SDL_SysWMEvent {
	Uint8 type;
	SDL_SysWMmsg *msg;
}

/* General event structure */
union SDL_Event {
	Uint8 type;
	SDL_ActiveEvent active;
	SDL_KeyboardEvent key;
	SDL_MouseMotionEvent motion;
	SDL_MouseButtonEvent button;
	SDL_JoyAxisEvent jaxis;
	SDL_JoyBallEvent jball;
	SDL_JoyHatEvent jhat;
	SDL_JoyButtonEvent jbutton;
	SDL_ResizeEvent resize;
	SDL_ExposeEvent expose;
	SDL_QuitEvent quit;
	SDL_UserEvent user;
	SDL_SysWMEvent syswm;
}

/* Function prototypes */

/* Pumps the event loop, gathering events from the input devices.
   This function updates the event queue and internal input device state.
   This should only be run in the thread that sets the video mode.
*/
void SDL_PumpEvents();

/* Checks the event queue for messages and optionally returns them.
   If 'action' is SDL_ADDEVENT, up to 'numevents' events will be added to
   the back of the event queue.
   If 'action' is SDL_PEEKEVENT, up to 'numevents' events at the front
   of the event queue, matching 'mask', will be returned and will not
   be removed from the queue.
   If 'action' is SDL_GETEVENT, up to 'numevents' events at the front 
   of the event queue, matching 'mask', will be returned and will be
   removed from the queue.
   This function returns the number of events actually stored, or -1
   if there was an error.  This function is thread-safe.
*/
alias int SDL_eventaction;
enum {
	SDL_ADDEVENT,
	SDL_PEEKEVENT,
	SDL_GETEVENT
}
/* */
int SDL_PeepEvents(SDL_Event *events, int numevents,
		SDL_eventaction action, Uint32 mask);

/* Polls for currently pending events, and returns 1 if there are any pending
   events, or 0 if there are none available.  If 'event' is not NULL, the next
   event is removed from the queue and stored in that area.
 */
int SDL_PollEvent(SDL_Event *event);

/* Waits indefinitely for the next available event, returning 1, or 0 if there
   was an error while waiting for events.  If 'event' is not NULL, the next
   event is removed from the queue and stored in that area.
 */
int SDL_WaitEvent(SDL_Event *event);

/* Add an event to the event queue.
   This function returns 0, or -1 if the event couldn't be added to
   the event queue.  If the event queue is full, this function fails.
 */
int SDL_PushEvent(SDL_Event *event);

/*
  This function sets up a filter to process all events before they
  change internal state and are posted to the internal event queue.

  The filter is protypted as:
*/
alias int (*SDL_EventFilter)(SDL_Event *event);
/*
  If the filter returns 1, then the event will be added to the internal queue.
  If it returns 0, then the event will be dropped from the queue, but the 
  internal state will still be updated.  This allows selective filtering of
  dynamically arriving events.

  WARNING:  Be very careful of what you do in the event filter function, as 
            it may run in a different thread!

  There is one caveat when dealing with the SDL_QUITEVENT event type.  The
  event filter is only called when the window manager desires to close the
  application window.  If the event filter returns 1, then the window will
  be closed, otherwise the window will remain open if possible.
  If the quit event is generated by an interrupt signal, it will bypass the
  internal queue and be delivered to the application at the next event poll.
*/
void SDL_SetEventFilter(SDL_EventFilter filter);

/*
  Return the current event filter - can be used to "chain" filters.
  If there is no event filter set, this function returns NULL.
*/
SDL_EventFilter SDL_GetEventFilter();

/*
  This function allows you to set the state of processing certain events.
  If 'state' is set to SDL_IGNORE, that event will be automatically dropped
  from the event queue and will not event be filtered.
  If 'state' is set to SDL_ENABLE, that event will be processed normally.
  If 'state' is set to SDL_QUERY, SDL_EventState() will return the 
  current processing state of the specified event.
*/
const uint SDL_QUERY	= cast(uint) -1;
const uint SDL_IGNORE	= 0;
const uint SDL_DISABLE	= 0;
const uint SDL_ENABLE	= 1;
Uint8 SDL_EventState(Uint8 type, int state);
