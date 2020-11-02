// Minimal druntime for webassembly. Assumes your program has a main function.
module object;

static import wasm;

alias string = immutable(char)[];
alias size_t = uint;

class Object {
  size_t toHash() const {
    assert(false);
  }
  string toString() const {
    assert(false);
  }
}

class Throwable : Object
{
  Throwable next;
  string msg;
  string file;
  size_t line;

  @nogc @safe pure nothrow this(string msg, Throwable nextInChain = null)
  {
    this.msg = msg;
    this.next = nextInChain;
  }

  @nogc @safe pure nothrow this(string msg, string file, size_t line, Throwable nextInChain = null)
  {
    this.msg = msg;
    this.file = file;
    this.line = line;
    this.next = nextInChain;
  }
}

class Exception : Throwable
{
  @nogc @safe pure nothrow this(string msg, string file = __FILE__, size_t line = __LINE__, Throwable nextInChain = null)
  {
    super(msg, file, line, nextInChain);
  }

  @nogc @safe pure nothrow this(string msg, Throwable nextInChain, string file = __FILE__, size_t line = __LINE__)
  {
    super(msg, file, line, nextInChain);
  }
}

class Error : Throwable
{
  @nogc @safe pure nothrow this(string msg, string file = __FILE__, size_t line = __LINE__, Throwable nextInChain = null)
  {
    super(msg, file, line, nextInChain);
  }

  @nogc @safe pure nothrow this(string msg, Throwable nextInChain, string file = __FILE__, size_t line = __LINE__)
  {
    super(msg, file, line, nextInChain);
  }
}

class TypeInfo {
  @property size_t tsize() nothrow pure const @safe @nogc { return 0; }
  @property inout(TypeInfo) next() nothrow pure inout @nogc { return null; }
  const(void)[] initializer() nothrow pure const @trusted @nogc
  {
    return (cast(const(void)*) null)[0 .. typeof(null).sizeof];
  }
}

class TypeInfo_a : TypeInfo {
  override @property size_t tsize() nothrow pure const @safe @nogc
  {
    return char.sizeof;
  }
  override const(void)[] initializer() nothrow pure const @trusted @nogc
  {
    return (cast(void *)null)[0 .. char.sizeof];
  }
}
class TypeInfo_ya : TypeInfo_Invariant {
  override @property size_t tsize() nothrow pure const @safe @nogc
  {
    return immutable(char).sizeof;
  }
  override const(void)[] initializer() nothrow pure const @trusted @nogc
  {
    return (cast(void *)null)[0 .. immutable(char).sizeof];
  }
}
class TypeInfo_xa : TypeInfo_Const {
  override @property size_t tsize() nothrow pure const @safe @nogc
  {
    return const(char).sizeof;
  }
  override const(void)[] initializer() nothrow pure const @trusted @nogc
  {
    return (cast(void *)null)[0 .. const(char).sizeof];
  }
}
class TypeInfo_v : TypeInfo {
  override @property size_t tsize() nothrow pure const @safe @nogc
  {
    return void.sizeof;
  }
  override const(void)[] initializer() nothrow pure const @trusted @nogc
  {
    return (cast(void *)null)[0 .. void.sizeof];
  }
}
class TypeInfo_d : TypeInfo {
  alias F = double;
  override @property size_t tsize() nothrow pure const @safe @nogc
  {
    return F.sizeof;
  }
  override const(void)[] initializer() nothrow pure const @trusted @nogc
  {
    static immutable F r;
    return (&r)[0 .. 1];
  }
}
class TypeInfo_i : TypeInfo {
  override @property size_t tsize() nothrow pure const @safe @nogc
  {
    return int.sizeof;
  }

  override const(void)[] initializer() nothrow pure const @trusted @nogc
  {
    return (cast(void *)null)[0 .. int.sizeof];
  }
}
class TypeInfo_f : TypeInfo {
  alias F = float;
  override @property size_t tsize() nothrow pure const @safe @nogc
  {
    return F.sizeof;
  }
  override const(void)[] initializer() nothrow pure const @trusted @nogc
  {
    static immutable F r;
    return (&r)[0 .. 1];
  }
}
class TypeInfo_h : TypeInfo {
  override @property size_t tsize() nothrow pure const @safe @nogc
  {
    return ubyte.sizeof;
  }
  override const(void)[] initializer() nothrow pure const @trusted @nogc
  {
    return (cast(void *)null)[0 .. ubyte.sizeof];
  }
}
class TypeInfo_b : TypeInfo_h {}
class TypeInfo_k : TypeInfo {
  override @property size_t tsize() nothrow pure const @safe @nogc
  {
    return uint.sizeof;
  }
  override const(void)[] initializer() nothrow pure const @trusted @nogc
  {
    return (cast(void *)null)[0 .. uint.sizeof];
  }
}

class TypeInfo_Ad : TypeInfo_Array {
  override @property inout(TypeInfo) next() nothrow pure inout @nogc
  {
    return cast(inout)typeid(double);
  }
}
class TypeInfo_Af : TypeInfo_Array {
  override @property inout(TypeInfo) next() nothrow pure inout @nogc
  {
    return cast(inout)typeid(float);
  }
}
class TypeInfo_Ah : TypeInfo_Array {
  override @property inout(TypeInfo) next() nothrow pure inout @nogc
  {
    return cast(inout)typeid(ubyte);
  }
}
class TypeInfo_Aa : TypeInfo_Ah {
  override @property inout(TypeInfo) next() nothrow pure inout @nogc
  {
    return cast(inout)typeid(char);
  }
}
class TypeInfo_Aya : TypeInfo_Aa {
  override @property inout(TypeInfo) next() nothrow pure inout @nogc
  {
    return cast(inout)typeid(immutable(char));
  }
}
class TypeInfo_Axa : TypeInfo_Aa {
  override @property inout(TypeInfo) next() nothrow pure inout @nogc
  {
    return cast(inout)typeid(const(char));
  }
}

struct OffsetTypeInfo
{
  size_t   offset;    /// Offset of member from start of object
  TypeInfo ti;        /// TypeInfo for this member
}

struct Interface
{
  TypeInfo_Class   classinfo;  /// .classinfo for this interface (not for containing class)
  void*[]     vtbl;
  size_t      offset;     /// offset to Interface 'this' from Object 'this'
}

class TypeInfo_Class : TypeInfo {
  ubyte[] m_init;
  string name;
  void*[] vtbl;
  Interface[] interfaces;
  TypeInfo_Class base;
  void* dtor;
  void function(Object) ci;
  uint flags;
  void* deallocator;
  OffsetTypeInfo[] offti;
  void function(Object) dctor;
  immutable(void)* rtInfo;

  override @property size_t tsize() nothrow pure const
  {
    return Object.sizeof;
  }

  override const(void)[] initializer() nothrow pure const @safe
  {
    return m_init;
  }
}

class TypeInfo_Array : TypeInfo {
  TypeInfo value;

  override @property size_t tsize() nothrow pure const
  {
    return (void[]).sizeof;
  }

  override @property inout(TypeInfo) next() nothrow pure inout { return value; }

  override const(void)[] initializer() const @trusted
  {
    return (cast(void *)null)[0 .. (void[]).sizeof];
  }
}

class TypeInfo_AssociativeArray : TypeInfo {
  TypeInfo value;
  TypeInfo key;

  override @property size_t tsize() nothrow pure const
  {
    return (char[int]).sizeof;
  }

  override @property inout(TypeInfo) next() nothrow pure inout { return value; }

  override const(void)[] initializer() const @trusted
  {
    return (cast(void *)null)[0 .. (char[int]).sizeof];
  }
}

class TypeInfo_Interface : TypeInfo {
  TypeInfo_Class info;

  override @property size_t tsize() nothrow pure const
  {
    return Object.sizeof;
  }

  override const(void)[] initializer() const @trusted
  {
    return (cast(void *)null)[0 .. Object.sizeof];
  }
}

class TypeInfo_Const : TypeInfo {
  size_t getHash(in void*) nothrow { return 0; }
  TypeInfo base;

  override @property size_t tsize() nothrow pure const { return base.tsize; }

  override @property inout(TypeInfo) next() nothrow pure inout { return base.next; }

  override const(void)[] initializer() nothrow pure const
  {
    return base.initializer();
  }
}

class TypeInfo_Invariant : TypeInfo_Const
{
}

class TypeInfo_Pointer : TypeInfo {
  TypeInfo m_next;

  override @property inout(TypeInfo) next() nothrow pure inout { return m_next; }

  override @property size_t tsize() nothrow pure const
  {
    return (void*).sizeof;
  }

  override const(void)[] initializer() const @trusted
  {
    return (cast(void *)null)[0 .. (void*).sizeof];
  }
}

class TypeInfo_Delegate : TypeInfo {
  TypeInfo next;
  string deco;

  override @property size_t tsize() nothrow pure const
  {
    alias dg = int delegate();
    return dg.sizeof;
  }

  override const(void)[] initializer() const @trusted
  {
    return (cast(void *)null)[0 .. (int delegate()).sizeof];
  }
}

class TypeInfo_Enum : TypeInfo {
  TypeInfo base;
  string   name;
  void[]   m_init;

  override @property size_t tsize() nothrow pure const { return base.tsize; }

  override @property inout(TypeInfo) next() nothrow pure inout { return base.next; }

  override const(void)[] initializer() const
  {
    return m_init.length ? m_init : base.initializer();
  }
}

class TypeInfo_Struct : TypeInfo {
  string name;
  void[] m_init;
  void* xtohash;
  void* xopequals;
  void* xopcmp;
  void* xtostring;
  uint flags;
  union {
    void function(void*) dtor;
    void function(void*, const TypeInfo_Struct) xdtor;
  }
  void function(void*) postblit;
  uint align_;
  immutable(void)* rtinfo;

  override @property size_t tsize() nothrow pure const
  {
    return initializer().length;
  }

  override const(void)[] initializer() nothrow pure const @safe
  {
    return m_init;
  }
}

class TypeInfo_StaticArray : TypeInfo {
  TypeInfo value;
  size_t len;

  override @property size_t tsize() nothrow pure const
  {
      return len * value.tsize;
  }

  override @property inout(TypeInfo) next() nothrow pure inout { return value; }

  override const(void)[] initializer() nothrow pure const
  {
      return value.initializer();
  }
}

inout(TypeInfo) unqualify(inout(TypeInfo) cti) pure nothrow @nogc
{
    TypeInfo ti = cast() cti;
    while (ti)
    {
        // avoid dynamic type casts
        auto tti = typeid(ti);
        if (tti is typeid(TypeInfo_Const))
            ti = (cast(TypeInfo_Const)cast(void*)ti).base;
        else if (tti is typeid(TypeInfo_Invariant))
            ti = (cast(TypeInfo_Invariant)cast(void*)ti).base;
        // else if (tti is typeid(TypeInfo_Shared))
        //     ti = (cast(TypeInfo_Shared)cast(void*)ti).base;
        // else if (tti is typeid(TypeInfo_Inout))
        //     ti = (cast(TypeInfo_Inout)cast(void*)ti).base;
        else
            break;
    }
    return ti;
}


// ldc defines this, used to find where wasm memory begins
private extern extern(C) ubyte __heap_base;
//                                           ---unused--- -- stack grows down -- -- heap here --
// this is less than __heap_base. memory map 0 ... __data_end ... __heap_base ... end of memory
private extern extern(C) ubyte __data_end;

private ubyte* nextFree;
private size_t memorySize;

ubyte[] malloc(size_t sz) {
  if (nextFree is null) {
    nextFree = &__heap_base;
    memorySize = wasm.memorySize();
  }
  auto ret = nextFree;
  nextFree += sz;
  return ret[0 .. sz];
}

// then the entry point just for convenience so main works.
extern(C) int _Dmain(string[] args);
extern(C) void _start() { _Dmain(null); }
extern(C) int main(int argc, immutable(char**) argv) {
  return _Dmain(null);
}

extern (C) int _adEq2(void[] a1, void[] a2, TypeInfo ti) {
  assert(false, "array equality");
}

extern(C) bool _xopEquals(in void*, in void*) { return false; }

extern(C) void _d_array_slice_copy(void* dst, size_t dstlen, void* src, size_t srclen, size_t elemsz) {
  memcpy(dst, src, dstlen * elemsz);
}

extern(C) void _d_throw_exception(Throwable throwable) {
  wasm.assertMessage(throwable.msg, throwable.file, throwable.line);
  wasm.abort();
}
extern(C) Throwable _d_eh_enter_catch(void* exceptionObject) {
  assert(false, "enter catch");
}

extern(C) void _d_assert(string file, uint line) {
  wasm.assertMessage("", file, line);
}

extern(C) void _d_assert_msg(string msg, string file, uint line) {
  wasm.assertMessage(msg, file, line);
}

extern(C) void _d_arraybounds(string file, size_t line) {
  wasm.assertMessage("out of bounds", file, line);
}

extern(C) void* memset(void* s, int c, size_t n) {
  wasm.write("memset");
  wasm.write(cast(int) s);
  wasm.write(c);
  wasm.write(n);
  auto d = cast(ubyte*) s;
  while(n) {
    *d = cast(ubyte) c;
    d++;
    n--;
  }
  return s;
}

extern(C) void* memcpy(void* d, void* s, size_t n) {
  wasm.write("memcpy");
  wasm.write(cast(int) d);
  wasm.write(cast(int) s);
  wasm.write(n);
  auto td = cast(ubyte*) d, ts = cast(ubyte*) s;
  while(n) {
    *td = *ts;
    td++;
    ts++;
    n--;
  }
  return d;
}

void __switch_error(string file, size_t line) {}

extern(C) void wasm_writeString(immutable(char*) msgptr, size_t msglen);

extern(C) Object _d_allocclass(TypeInfo_Class ti) {
  auto ptr = ti.name.ptr;
  auto len = ti.name.length;
  wasm_writeString(ptr, len);
  auto obj = malloc(ti.m_init.length);
  obj[] = ti.m_init[];
  return cast(Object) obj.ptr;
}

extern(C) void* _d_allocmemory(size_t sz) {
  return malloc(sz).ptr;
}

extern (C) void _d_callfinalizer(void* p) {
}

extern (C) void* _d_interface_cast(void* p, TypeInfo_Class c) {
  assert(false, "iface cast");
}

extern (C) void* _d_dynamic_cast(Object o, TypeInfo_Class c) {
  assert(false, "dyn cast");
}

bool __equals(T1, T2)(T1[] lhs, T2[] rhs)
{
  if (lhs.length != rhs.length)
    return false;

  if (lhs.length == 0 && rhs.length == 0)
    return true;

  foreach (const u; 0 .. lhs.length)
  {
    if (lhs[u] != rhs[u])
      return false;
  }
  return true;
}

int __switch(T, caseLabels...)(/*in*/ const scope T[] condition) pure nothrow @safe @nogc
{
  static immutable T[][caseLabels.length] cases = [caseLabels];
  foreach (const u; 0 .. cases.length) {
    if (cases[u] == condition) {
      return u;
    }
  }
  return int.min;
}

size_t hashOf(T)(const T val, size_t seed = 0) {
  assert(false);
}

extern(C) void[] _d_newarrayT(const TypeInfo ti, size_t length) {
  auto tinext = unqualify(ti.next);
  auto size = tinext.tsize;
  auto buffer = malloc(size * length);
  memset(buffer.ptr, 0, size * length);
  return buffer;
}
extern (C) void[] _d_arrayappendT(const TypeInfo ti, ref byte[] x, byte[] y) {
  auto size = ti.tsize;
  ubyte[] tmp = malloc((x.length + y.length) * size);
  _d_array_slice_copy(&tmp[0], x.length, x.ptr, x.length, 1);
  _d_array_slice_copy(&tmp[x.length], y.length, y.ptr, y.length, 1);
  return tmp;
}
extern (C) byte[] _d_arrayappendcTX(const TypeInfo ti, ref byte[] px, size_t n) {
  assert(false);
}
extern (C) byte[] _d_arraycatT(const TypeInfo ti, byte[] x, byte[] y) {
  auto tinext = unqualify(ti.next);
  auto size = tinext.tsize;
  size_t length = x.length + y.length;
  byte[] buffer = cast(byte[]) malloc(size * length);
  memcpy(&buffer[0], x.ptr, size * x.length);
  memcpy(&buffer[x.length], y.ptr, size * y.length);
  return buffer;
}
extern (C) void[] _d_arraycatnTX(const TypeInfo ti, byte[][] arrs) {
  auto tinext = unqualify(ti.next);
  auto size = tinext.tsize;
  size_t length = 0;
  foreach (b; arrs) {
    length += b.length;
  }
  auto buffer = malloc(size * length);
  ubyte* dst = buffer.ptr;
  foreach (b; arrs) {
    if (b.length) {
      memcpy(dst, b.ptr, size * b.length);
      dst += size * b.length;
    }
  }
  return buffer;
}
extern (C) void[] _d_newarrayU(const TypeInfo ti, size_t length) {
  auto tinext = unqualify(ti.next);
  auto size = tinext.tsize;
  return malloc(size * length);
}

struct AA {}

extern (C) void* _aaGetY(AA* aa, const TypeInfo aati, in size_t valuesize, in void* pkey) {
  return null;
}

extern (C) inout(void)* _aaInX(inout AA aa, in TypeInfo keyti, in void* pkey) {
  return null;
}

extern (D) alias dg_t = int delegate(void*);
extern (C) int _aaApply(AA aa, const size_t keysz, dg_t dg) {
  return 0;
}
