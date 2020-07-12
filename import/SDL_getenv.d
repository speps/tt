/* Not all environments have a working getenv()/putenv() */

extern(C):

/* Put a variable of the form "name=value" into the environment */
int SDL_putenv(char *variable) { return 0; }
int putenv(char* X) { return SDL_putenv(X); }

/* Retrieve a variable named "name" from the environment */
char *SDL_getenv(char *name) { return null; }
char *getenv(char* X) { return SDL_getenv(X); }
