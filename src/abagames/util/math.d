module abagames.util.math;

version (LDC)
{
    pragma(LDC_intrinsic, "llvm.cos.f#")
    float cos(float x);
    pragma(LDC_intrinsic, "llvm.sin.f#")
    float sin(float x);
    pragma(LDC_intrinsic, "llvm.fabs.f#")
    float fabs(float x);
    pragma(LDC_intrinsic, "llvm.sqrt.f#")
    float llvm_sqrt(float x);
    pragma(inline, true):
    float sqrt(float x) { return x < 0 ? float.nan  : llvm_sqrt(x); }
}
else
{
    import std.math;
    alias cos = std.math.cos;
    alias sin = std.math.sin;
    alias fabs = std.math.fabs;
    alias sqrt = std.math.sqrt;
}

enum real PI = 0x1.921fb54442d18469898cc51701b84p+1L;
enum real PI_2 =       PI/2;
enum real PI_4 =       PI/4;

bool isNaN(float x) @nogc @trusted pure nothrow
{
    return x != x;
}

int signbit(float x) @nogc @trusted pure nothrow
{
    double dval = cast(double) x; // Precision can increase or decrease but sign won't change (even NaN).
    return 0 > *cast(long*) &dval;
}

float copysign(float to, float from) @nogc @trusted pure nothrow
{
  return signbit(to) == signbit(from) ? to : -to;
}

bool isInfinity(float x) @nogc @trusted pure nothrow
{
    return (x < -float.max) || (float.max < x);
}

private float poly(float x, in float[] A) @trusted pure nothrow @nogc
{
    uint i = A.length - 1;
    float r = A[i];
    while (--i >= 0)
    {
        r *= x;
        r += A[i];
    }
    return r;
}

private T atanImpl(T)(T x) @safe pure nothrow @nogc
{
    static immutable T[4] P = [
        -3.33329491539E-1,
        1.99777106478E-1,
        -1.38776856032E-1,
        8.05374449538E-2,
    ];

    // tan(PI/8)
    enum T TAN_PI_8 = 0.414213562373095048801688724209698078569672L;
    // tan(3 * PI/8)
    enum T TAN3_PI_8 = 2.414213562373095048801688724209698078569672L;

    // Special cases.
    if (x == cast(T) 0.0)
        return x;
    if (isInfinity(x))
        return copysign(cast(T) PI_2, x);

    // Make argument positive but save the sign.
    bool sign = false;
    if (signbit(x))
    {
        sign = true;
        x = -x;
    }

    // Range reduction.
    T y;
    if (x > TAN3_PI_8)
    {
        y = PI_2;
        x = -((cast(T) 1.0) / x);
    }
    else if (x > TAN_PI_8)
    {
        y = PI_4;
        x = (x - cast(T) 1.0)/(x + cast(T) 1.0);
    }
    else
        y = 0.0;

    // Rational form in x^^2.
    const T z = x * x;
    y += poly(z, P) * z * x + x;

    return (sign) ? -y : y;
}

float atan(float x) @safe pure nothrow @nogc
{
  return atanImpl(x);
}

private T atan2Impl(T)(T y, T x) @safe pure nothrow @nogc
{
    // Special cases.
    if (isNaN(x) || isNaN(y))
        return T.nan;
    if (y == cast(T) 0.0)
    {
        if (x >= 0 && !signbit(x))
            return copysign(0, y);
        else
            return copysign(cast(T) PI, y);
    }
    if (x == cast(T) 0.0)
        return copysign(cast(T) PI_2, y);
    if (isInfinity(x))
    {
        if (signbit(x))
        {
            if (isInfinity(y))
                return copysign(3 * cast(T) PI_4, y);
            else
                return copysign(cast(T) PI, y);
        }
        else
        {
            if (isInfinity(y))
                return copysign(cast(T) PI_4, y);
            else
                return copysign(cast(T) 0.0, y);
        }
    }
    if (isInfinity(y))
        return copysign(cast(T) PI_2, y);

    // Call atan and determine the quadrant.
    T z = atan(y / x);

    if (signbit(x))
    {
        if (signbit(y))
            z = z - cast(T) PI;
        else
            z = z + cast(T) PI;
    }

    if (z == cast(T) 0.0)
        return copysign(z, y);

    return z;
}

float atan2(float y, float x) @safe pure nothrow @nogc
{
  return atan2Impl(y, x);
}

float pow(float x, int n) @nogc @trusted pure nothrow
{
    real p = 1.0, v = void;
    uint m = n;
    alias n2 = n;

    if (n < 0)
    {
        switch (n2)
        {
        case -1:
            return 1 / x;
        case -2:
            return 1 / (x * x);
        default:
        }

        m = cast(uint)(0 - n);
        v = p / x;
    }
    else
    {
        switch (n)
        {
        case 0:
            return 1.0;
        case 1:
            return x;
        case 2:
            return x * x;
        default:
        }

        v = x;
    }

    while (1)
    {
        if (m & 1)
            p *= v;
        m >>= 1;
        if (!m)
            break;
        v *= v;
    }
    return p;
}
