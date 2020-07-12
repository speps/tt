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

/* This is the CD-audio control API for Simple DirectMedia Layer */

import SDL_types;

extern(C):

/* In order to use these functions, SDL_Init() must have been called
   with the SDL_INIT_CDROM flag.  This causes SDL to scan the system
   for CD-ROM drives, and load appropriate drivers.
*/

/* The maximum number of CD-ROM tracks on a disk */
const int SDL_MAX_TRACKS	= 99;

/* The types of CD-ROM track possible */
const uint SDL_AUDIO_TRACK	= 0x00;
const uint SDL_DATA_TRACK	= 0x04;

/* The possible states which a CD-ROM drive can be in. */
alias int CDstatus;
enum {
	CD_TRAYEMPTY,
	CD_STOPPED,
	CD_PLAYING,
	CD_PAUSED,
	CD_ERROR = -1
}

/* Given a status, returns true if there's a disk in the drive */
bit CD_INDRIVE(int status) { return status > 0; }

struct SDL_CDtrack {
	Uint8 id;		/* Track number */
	Uint8 type;		/* Data or audio track */
	Uint16 unused;
	Uint32 length;		/* Length, in frames, of this track */
	Uint32 offset;		/* Offset, in frames, from start of disk */
}

/* This structure is only current as of the last call to SDL_CDStatus() */
struct SDL_CD {
	int id;			/* Private drive identifier */
	CDstatus status;	/* Current drive status */

	/* The rest of this structure is only valid if there's a CD in drive */
	int numtracks;		/* Number of tracks on disk */
	int cur_track;		/* Current track position */
	int cur_frame;		/* Current frame offset within current track */
	SDL_CDtrack track[SDL_MAX_TRACKS+1];
}

/* Conversion functions from frames to Minute/Second/Frames and vice versa */
const uint CD_FPS	= 75;
void FRAMES_TO_MSF(int f, out int M, out int S, out int F)
{
	int value = f;
	F = value % CD_FPS;
	value /= CD_FPS;
	S = value % 60;
	value /= 60;
	M = value;
}

int MSF_TO_FRAMES(int M, int S, int F)
{
	return M * 60 * CD_FPS + S * CD_FPS + F;
}

/* CD-audio API functions: */

/* Returns the number of CD-ROM drives on the system, or -1 if
   SDL_Init() has not been called with the SDL_INIT_CDROM flag.
 */
int SDL_CDNumDrives();

/* Returns a human-readable, system-dependent identifier for the CD-ROM.
   Example:
	"/dev/cdrom"
	"E:"
	"/dev/disk/ide/1/master"
*/
char * SDL_CDName(int drive);

/* Opens a CD-ROM drive for access.  It returns a drive handle on success,
   or NULL if the drive was invalid or busy.  This newly opened CD-ROM
   becomes the default CD used when other CD functions are passed a NULL
   CD-ROM handle.
   Drives are numbered starting with 0.  Drive 0 is the system default CD-ROM.
*/
SDL_CD * SDL_CDOpen(int drive);

/* This function returns the current status of the given drive.
   If the drive has a CD in it, the table of contents of the CD and current
   play position of the CD will be stored in the SDL_CD structure.
*/
CDstatus SDL_CDStatus(SDL_CD *cdrom);

/* Play the given CD starting at 'start_track' and 'start_frame' for 'ntracks'
   tracks and 'nframes' frames.  If both 'ntrack' and 'nframe' are 0, play 
   until the end of the CD.  This function will skip data tracks.
   This function should only be called after calling SDL_CDStatus() to 
   get track information about the CD.
   For example:
	// Play entire CD:
	if ( CD_INDRIVE(SDL_CDStatus(cdrom)) )
		SDL_CDPlayTracks(cdrom, 0, 0, 0, 0);
	// Play last track:
	if ( CD_INDRIVE(SDL_CDStatus(cdrom)) ) {
		SDL_CDPlayTracks(cdrom, cdrom->numtracks-1, 0, 0, 0);
	}
	// Play first and second track and 10 seconds of third track:
	if ( CD_INDRIVE(SDL_CDStatus(cdrom)) )
		SDL_CDPlayTracks(cdrom, 0, 0, 2, 10);

   This function returns 0, or -1 if there was an error.
*/
int SDL_CDPlayTracks(SDL_CD *cdrom,
		int start_track, int start_frame, int ntracks, int nframes);

/* Play the given CD starting at 'start' frame for 'length' frames.
   It returns 0, or -1 if there was an error.
*/
int SDL_CDPlay(SDL_CD *cdrom, int start, int length);

/* Pause play -- returns 0, or -1 on error */
int SDL_CDPause(SDL_CD *cdrom);

/* Resume play -- returns 0, or -1 on error */
int SDL_CDResume(SDL_CD *cdrom);

/* Stop play -- returns 0, or -1 on error */
int SDL_CDStop(SDL_CD *cdrom);

/* Eject CD-ROM -- returns 0, or -1 on error */
int SDL_CDEject(SDL_CD *cdrom);

/* Closes the handle for the CD-ROM drive */
void SDL_CDClose(SDL_CD *cdrom);
