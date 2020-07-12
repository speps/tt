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

/* This header defines the current SDL version */

import SDL_types;

extern(C):

/* Printable format: "%d.%d.%d", MAJOR, MINOR, PATCHLEVEL
*/
const uint SDL_MAJOR_VERSION	= 1;
const uint SDL_MINOR_VERSION	= 2;
const uint SDL_PATCHLEVEL		= 6;

struct SDL_version {
	Uint8 major;
	Uint8 minor;
	Uint8 patch;
}

/* This macro can be used to fill a version structure with the compile-time
 * version of the SDL library.
 */
void SDL_VERSION(SDL_version* X)
{
	X.major = SDL_MAJOR_VERSION;
	X.minor = SDL_MINOR_VERSION;
	X.patch = SDL_PATCHLEVEL;
}

/* This macro turns the version numbers into a numeric value:
   (1,2,3) -> (1203)
   This assumes that there will never be more than 100 patchlevels
*/
uint SDL_VERSIONNUM(Uint8 X, Uint8 Y, Uint8 Z)
{
	return X * 1000 + Y * 100 + Z;
}

/* This is the version number macro for the current SDL version */
const uint SDL_COMPILEDVERSION = SDL_MAJOR_VERSION * 1000 +
									SDL_MINOR_VERSION * 100 +
									SDL_PATCHLEVEL;

/* This macro will evaluate to true if compiled with SDL at least X.Y.Z */
bit SDL_VERSION_ATLEAST(Uint8 X, Uint8 Y, Uint8 Z)
{
	return (SDL_COMPILEDVERSION >= SDL_VERSIONNUM(X, Y, Z));
}

/* This function gets the version of the dynamically linked SDL library.
   it should NOT be used to fill a version structure, instead you should
   use the SDL_Version() macro.
 */
SDL_version * SDL_Linked_Version();
