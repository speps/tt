module abagames.util.bytebuffer;

static assert(int.sizeof == 4);
static assert(long.sizeof == 8);

int readInt(ref ubyte[] i) {
  assert(i.length >= 4);
  int r = i[0] | (i[1] << 8) | (i[2] << 16) | (i[3] << 24);
  i = i[4..$];
  return r;
}

long readLong(ref ubyte[] i) {
  assert(i.length >= 8);
  long r = i[0] | (i[1] << 8) | (i[2] << 16) | (i[3] << 24)
    | (cast(ulong)(i[4]) << 32) | (cast(ulong)(i[5]) << 40) | (cast(ulong)(i[6]) << 48) | (cast(ulong)(i[7]) << 56);
  i = i[8..$];
  return r;
}

float readFloat(ref ubyte[] i) {
  float f = *cast(float*)i.ptr;
  i = i[4..$];
  return f;
}

void append(ref ubyte[] o, int v) {
  ubyte[] b = [v & 0xff, (v >> 8) & 0xff, (v >> 16) & 0xff, (v >> 24) & 0xff];
  o ~= b;
}

void append(ref ubyte[] o, long v) {
  ubyte[] b = [
    v & 0xff, (v >> 8) & 0xff, (v >> 16) & 0xff, (v >> 24) & 0xff,
    (v >> 32) & 0xff, (v >> 40) & 0xff, (v >> 48) & 0xff, (v >> 56) & 0xff
  ];
  o ~= b;
}

void append(ref ubyte[] o, float v) {
  int i = *cast(int*)&v;
  append(o, i);
}
