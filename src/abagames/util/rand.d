/*
 * $Id: rand.d,v 1.2 2005/01/01 12:40:28 kenta Exp $
 *
 * Copyright 2004 Kenta Cho. Some rights reserved.
 */
module abagames.util.rand;

private import undead.stream;
private import undead.date;

/**
 * Random number generator.
 */
public class Rand {
  
  public this() {
    d_time timer = getUTCtime();
    init_genrand(cast(uint)timer);
  }

  public void setSeed(long n) {
    init_genrand(cast(uint)n);
  }

  public uint nextInt32() {
    return genrand_int32();
  }

  public int nextInt(int n) {
    if (n == 0)
      return 0;
    else
      return genrand_int32() % n;
  }

  public int nextSignedInt(int n) {
    if (n == 0)
      return 0;
    else
      return genrand_int32() % (n * 2) - n;
  }

  public float nextFloat(float n) {
    return genrand_real1() * n;
  }

  public float nextSignedFloat(float n) {
    return genrand_real1() * (n * 2) - n;
  }

/* 
   MT.d
   Mersenne Twister random number generator -- D
   Based on code by Makoto Matsumoto, Takuji Nishimura, Shawn Cokus,
     Matthe Bellew, and Isaku Wada
   Andrew C. Edwards  v0.1  30 September 2003  edwardsac@ieee.org

   Before using, initialize the state by using init_genrand(seed) 
   or init_by_array(init_key, key_length).

   Copyright (C) 1997 - 2002, Makoto Matsumoto and Takuji Nishimura,
   Copyright (C) 2003, Andrew C. Edwards
   All rights reserved.

   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions
   are met:

     1. Redistributions of source code must retain the above copyright
        notice, this list of conditions and the following disclaimer.

     2. Redistributions in binary form must reproduce the above copyright
        notice, this list of conditions and the following disclaimer in the
        documentation and/or other materials provided with the distribution.

     3. The names of its contributors may not be used to endorse or promote 
        products derived from this software without specific prior written 
        permission.

   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
   "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
   A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
   CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
   EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
   PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
   PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
   LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
   NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
   SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

   The original code included the following notice:
  
     Any feedback is very welcome.
     http://www.math.keio.ac.jp/matumoto/emt.html
     email: matumoto@math.keio.ac.jp
  
   Please CC: edwardsac@ieee.org on all correspondence
*/

/* 
   Modified by Kenta Cho.
   Remove 'static' to wrap with Rand class.
*/

/* Period parameters */  
const int N = 624;
const int M = 397;
const uint MATRIX_A = 0x9908b0dfUL;   /* constant vector a */
const uint UMASK = 0x80000000UL; /* most significant w-r bits */
const uint LMASK = 0x7fffffffUL; /* least significant r bits */
uint MIXBITS(uint u, uint v) { return (u & UMASK) | (v & LMASK); }
uint TWIST(uint u,uint v) { return (MIXBITS(u,v) >> 1) ^ (v&1 ? MATRIX_A : 0); }

uint[N] state; /* the array for the state vector  */
int left = 1;
int initf = 0;
uint *next;

/* initializes state[N] with a seed */
void init_genrand(uint s)
{
    state[0]= s & 0xffffffffUL;
    for (int j=1; j<N; j++) {
        state[j] = cast(uint)(1812433253UL * (state[j-1] ^ (state[j-1] >> 30)) + j); 
        /* See Knuth TAOCP Vol2. 3rd Ed. P.106 for multiplier. */
        /* In the previous versions, MSBs of the seed affect   */
        /* only MSBs of the array state[].                        */
        /* 2002/01/09 modified by Makoto Matsumoto             */
        state[j] &= 0xffffffffUL;  /* for >32 bit machines */
    }
    left = 1; initf = 1;
}

/* initialize by an array with array-length */
/* init_key is the array for initializing keys */
/* key_length is its length */
//uint init_key[];
//uint key_length;
void init_by_array(uint[] init_key, uint key_length)
{
    int i, j, k;
    init_genrand(19650218UL);
    i=1; j=0;
    k = (N>key_length ? N : key_length);
    for (; k; k--) {
        state[i] = cast(uint)(state[i] ^ ((state[i-1] ^ (state[i-1] >> 30)) * 1664525UL))
          + init_key[j] + j; /* non linear */
        state[i] &= 0xffffffffUL; /* for WORDSIZE > 32 machines */
        i++; j++;
        if (i>=N) { state[0] = state[N-1]; i=1; }
        if (j>=key_length) j=0;
    }
    for (k=N-1; k; k--) {
        state[i] = cast(uint)(state[i] ^ ((state[i-1] ^ (state[i-1] >> 30)) * 1566083941UL))
          - i; /* non linear */
        state[i] &= 0xffffffffUL; /* for WORDSIZE > 32 machines */
        i++;
        if (i>=N) { state[0] = state[N-1]; i=1; }
    }

    state[0] = 0x80000000UL; /* MSB is 1; assuring non-zero initial array */ 
    left = 1; initf = 1;
}

void next_state()
{
    uint *p=&state[0];

    /* if init_genrand() has not been called, */
    /* a default initial seed is used         */
    if (initf==0) init_genrand(5489UL);

    left = N;
    next = &state[0];
    
    for (int j=N-M+1; --j; p++) 
        *p = p[M] ^ TWIST(p[0], p[1]);

    for (int j=M; --j; p++) 
        *p = p[M-N] ^ TWIST(p[0], p[1]);

    *p = p[M-N] ^ TWIST(p[0], state[0]);
}

/* generates a random number on [0,0xffffffff]-interval */
uint genrand_int32()
{
    uint y;

    if (--left == 0) next_state();
    y = *next++;

    /* Tempering */
    y ^= (y >> 11);
    y ^= (y << 7) & 0x9d2c5680UL;
    y ^= (y << 15) & 0xefc60000UL;
    y ^= (y >> 18);

    return y;
}

/* generates a random number on [0,0x7fffffff]-interval */
long genrand_int31()
{
    uint y;

    if (--left == 0) next_state();
    y = *next++;

    /* Tempering */
    y ^= (y >> 11);
    y ^= (y << 7) & 0x9d2c5680UL;
    y ^= (y << 15) & 0xefc60000UL;
    y ^= (y >> 18);

    return cast(long)(y>>1);
}

/* generates a random number on [0,1]-real-interval */
double genrand_real1()
{
    uint y;

    if (--left == 0) next_state();
    y = *next++;

    /* Tempering */
    y ^= (y >> 11);
    y ^= (y << 7) & 0x9d2c5680UL;
    y ^= (y << 15) & 0xefc60000UL;
    y ^= (y >> 18);

    return cast(double)y * (1.0/4294967295.0); 
    /* divided by 2^32-1 */ 
}

/* generates a random number on [0,1)-real-interval */
double genrand_real2()
{
    uint y;

    if (--left == 0) next_state();
    y = *next++;

    /* Tempering */
    y ^= (y >> 11);
    y ^= (y << 7) & 0x9d2c5680UL;
    y ^= (y << 15) & 0xefc60000UL;
    y ^= (y >> 18);

    return cast(double)y * (1.0/4294967296.0); 
    /* divided by 2^32 */
}

/* generates a random number on (0,1)-real-interval */
double genrand_real3()
{
    uint y;

    if (--left == 0) next_state();
    y = *next++;

    /* Tempering */
    y ^= (y >> 11);
    y ^= (y << 7) & 0x9d2c5680UL;
    y ^= (y << 15) & 0xefc60000UL;
    y ^= (y >> 18);

    return (cast(double)y + 0.5) * (1.0/4294967296.0); 
    /* divided by 2^32 */
}

/* generates a random number on [0,1) with 53-bit resolution*/
double genrand_res53() 
{ 
    uint a=genrand_int32()>>5, b=genrand_int32()>>6; 
    return(a*67108864.0+b)*(1.0/9007199254740992.0); 
} 

}
