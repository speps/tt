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

/* This file provides a general interface for SDL to read and write
   data sources.  It can easily be extended to files, memory, etc.
*/

import SDL_types;

extern(C):

typedef int (*_seek_func_t)(SDL_RWops *context, int offset, int whence);
typedef int (*_read_func_t)(SDL_RWops *context, void *ptr, int size, int maxnum);
typedef int (*_write_func_t)(SDL_RWops *context, void *ptr, int size, int num);
typedef int (*_close_func_t)(SDL_RWops *context);

/* This is the read/write operation structure -- very basic */

struct SDL_RWops {
	/* Seek to 'offset' relative to whence, one of stdio's whence values:
		SEEK_SET, SEEK_CUR, SEEK_END
	   Returns the final offset in the data source.
	 */
	_seek_func_t seek;
//	int (*seek)(SDL_RWops *context, int offset, int whence);

	/* Read up to 'num' objects each of size 'objsize' from the data
	   source to the area pointed at by 'ptr'.
	   Returns the number of objects read, or -1 if the read failed.
	 */
	_read_func_t read;
//	int (*read)(SDL_RWops *context, void *ptr, int size, int maxnum);

	/* Write exactly 'num' objects each of size 'objsize' from the area
	   pointed at by 'ptr' to data source.
	   Returns 'num', or -1 if the write failed.
	 */
	_write_func_t write;
//	int (*write)(SDL_RWops *context, void *ptr, int size, int num);

	/* Close and free an allocated SDL_FSops structure */
	_close_func_t close;
//	int (*close)(SDL_RWops *context);

	Uint32 type;
	union {
	    struct {
			int autoclose;
		 	void *fp;	// was FILE
	    } // stdio;
	    struct {
			Uint8 *base;
		 	Uint8 *here;
			Uint8 *stop;
	    } // mem;
	    struct {
			void *data1;
	    } // unknown;
	} // hidden;
}


/* Functions to create SDL_RWops structures from various data sources */

SDL_RWops * SDL_RWFromFile(char *file, char *mode);

SDL_RWops * SDL_RWFromFP(void *fp, int autoclose);

SDL_RWops * SDL_RWFromMem(void *mem, int size);

SDL_RWops * SDL_AllocRW();
void SDL_FreeRW(SDL_RWops *area);

/* Macros to easily read and write from an SDL_RWops structure */
int SDL_RWseek(SDL_RWops *ctx, int offset, int whence)
{
	_seek_func_t seek;
//	int (*seek)(SDL_RWops *context, int offset, int whence);
	seek = ctx.seek;
	return (*seek)(ctx, offset, whence);
}

int SDL_RWtell(SDL_RWops *ctx)
{
	_seek_func_t seek;
//	int (*seek)(SDL_RWops *context, int offset, int whence);
	seek = ctx.seek;
	return (*seek)(ctx, 0, 1);
}

int SDL_RWread(SDL_RWops *ctx, void* ptr, int size, int n)
{
	_read_func_t read;
//	int (*read)(SDL_RWops *context, void *ptr, int size, int maxnum);
	read = ctx.read;
	return (*read)(ctx, ptr, size, n);
}

int SDL_RWwrite(SDL_RWops *ctx, void* ptr, int size, int n)
{
	_write_func_t write;
//	int (*write)(SDL_RWops *context, void *ptr, int size, int num);
	write = ctx.write;
	return (*write)(ctx, ptr, size, n);
}

int SDL_RWclose(SDL_RWops *ctx)
{
	_close_func_t close;
//	int (*close)(SDL_RWops *context);
	close = ctx.close;
	return (*close)(ctx);
}
