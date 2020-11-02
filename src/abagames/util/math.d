module abagames.util.math;

version(WASM)
{
  private:
  version(X86) {
    extern(C) float wasm_cos(float x) { return 0.0f; }
    extern(C) float wasm_sin(float x) { return 0.0f; }
    extern(C) float wasm_sqrt(float x) { return 0.0f; }
    extern(C) float wasm_atan2(float y, float x) { return 0.0f; }
    extern(C) float wasm_pow(float x, float y) { return 0.0f; }
  } else {
    extern(C) float wasm_cos(float x);
    extern(C) float wasm_sin(float x);
    extern(C) float wasm_sqrt(float x);
    extern(C) float wasm_atan2(float y, float x);
    extern(C) float wasm_pow(float x, float y);
  }

  public:
  float cos(float x) { return wasm_cos(x); }
  float sin(float x) { return wasm_sin(x); }
  float sqrt(float x) { return wasm_sqrt(x); }
  float atan2(float y, float x) { return wasm_atan2(y, x); }
  float pow(float x, float y) { return wasm_pow(x, y); }
}
else
{
  import std.math;
  alias cos = std.math.cos;
  alias sin = std.math.sin;
  alias sqrt = std.math.sqrt;
  alias atan2 = std.math.atan2;
  alias pow = std.math.pow;
}

enum real PI = 0x1.921fb54442d18469898cc51701b84p+1L;
enum real PI_2 =       PI/2;
enum real PI_4 =       PI/4;

float fabs(float x) {
  return x < 0.0f ? -x : x;
}

// to fix undefined symbol, not sure where this is linked from
extern(C) float fmodf(float x, float y) {
  assert(false);
}

bool isNaN(float x) @nogc @trusted pure nothrow {
    return x != x;
}
