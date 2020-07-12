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

/* Functions for reading and writing endian-specific values */

/* These functions read and write data of the specified endianness, 
   dynamically translating to the host machine endianness.

   e.g.: If you want to read a 16 bit value on big-endian machine from
         an open file containing little endian values, you would use:
		value = SDL_ReadLE16(rp);
         Note that the read/write functions use SDL_RWops pointers
         instead of FILE pointers.  This allows you to read and write
         endian values from large chunks of memory as well as files 
         and other data sources.
*/

import SDL_types;
import SDL_rwops;
import SDL_byteorder;

extern(C):

/* Use inline functions for compilers that support them, and static
   functions for those that do not.  Because these functions become
   static for compilers that do not support inline functions, this
   header should only be included in files that actually use them.
*/

Uint16 SDL_Swap16(Uint16 D) {
	return((D<<8)|(D>>8));
}

Uint32 SDL_Swap32(Uint32 D) {
	return((D<<24)|((D<<8)&0x00FF0000)|((D>>8)&0x0000FF00)|(D>>24));
}

Uint64 SDL_Swap64(Uint64 val) {
	Uint32 hi, lo;
	/* Separate into high and low 32-bit values and swap them */
	lo = cast(Uint32)(val&0xFFFFFFFF);
	val >>= 32;
	hi = cast(Uint32)(val&0xFFFFFFFF);
	val = SDL_Swap32(lo);
	val <<= 32;
	val |= SDL_Swap32(hi);
	return(val);
}

/* Byteswap item from the specified endianness to the native endianness */
//#define SDL_SwapLE16(X)	(X)
//#define SDL_SwapLE32(X)	(X)
//#define SDL_SwapLE64(X)	(X)
//#define SDL_SwapBE16(X)	SDL_Swap16(X)
//#define SDL_SwapBE32(X)	SDL_Swap32(X)
//#define SDL_SwapBE64(X)	SDL_Swap64(X)
Uint16 SDL_SwapLE16(Uint16 X) { return SDL_Swap16(X); }
Uint32 SDL_SwapLE32(Uint32 X) { return SDL_Swap32(X); }
Uint64 SDL_SwapLE64(Uint64 X) { return SDL_Swap64(X); }
Uint16 SDL_SwapBE16(Uint16 X) { return (X); }
Uint32 SDL_SwapBE32(Uint32 X) { return (X); }
Uint64 SDL_SwapBE64(Uint64 X) { return (X); }

/* Read an item of the specified endianness and return in native format */
Uint16 SDL_ReadLE16(SDL_RWops *src);
Uint16 SDL_ReadBE16(SDL_RWops *src);
Uint32 SDL_ReadLE32(SDL_RWops *src);
Uint32 SDL_ReadBE32(SDL_RWops *src);
Uint64 SDL_ReadLE64(SDL_RWops *src);
Uint64 SDL_ReadBE64(SDL_RWops *src);

/* Write an item of native format to the specified endianness */
int SDL_WriteLE16(SDL_RWops *dst, Uint16 value);
int SDL_WriteBE16(SDL_RWops *dst, Uint16 value);
int SDL_WriteLE32(SDL_RWops *dst, Uint32 value);
int SDL_WriteBE32(SDL_RWops *dst, Uint32 value);
int SDL_WriteLE64(SDL_RWops *dst, Uint64 value);
int SDL_WriteBE64(SDL_RWops *dst, Uint64 value);
