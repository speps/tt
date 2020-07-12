/* Not all environments have a working getenv()/putenv() */

extern(C):

/+
/* Put a variable of the form "name=value" into the environment */
int SDL_putenv(char *variable);
int putenv(char* X) { return SDL_putenv(X); }

/* Retrieve a variable named "name" from the environment */
char *SDL_getenv(char *name);
char *getenv(char* X) { return SDL_getenv(X); }
+/
