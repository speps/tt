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
	@nogc @safe pure nothrow this(string msg, Throwable nextInChain = null)
	{
	}

	@nogc @safe pure nothrow this(string msg, string file, size_t line, Throwable nextInChain = null)
	{
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
	const(void)[] initializer() nothrow pure const @trusted @nogc
	{
		return (cast(const(void)*) null)[0 .. typeof(null).sizeof];
	}
}

class TypeInfo_v : TypeInfo {}
class TypeInfo_d : TypeInfo {}
class TypeInfo_i : TypeInfo {}

class TypeInfo_Ad : TypeInfo_Array {}
class TypeInfo_Af : TypeInfo_Array {}
class TypeInfo_Ah : TypeInfo_Array {}
class TypeInfo_Aa : TypeInfo_Ah {}
class TypeInfo_Aya : TypeInfo_Aa {}
class TypeInfo_Axa : TypeInfo_Aa {}

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

	override const(void)[] initializer() const @trusted
	{
		return (cast(void *)null)[0 .. (void[]).sizeof];
	}
}

class TypeInfo_AssociativeArray : TypeInfo {
  TypeInfo value;
  TypeInfo key;
}

class TypeInfo_Interface : TypeInfo {
  TypeInfo_Class info;
}

class TypeInfo_Const : TypeInfo {
	size_t getHash(in void*) nothrow { return 0; }
  TypeInfo base;
}

class TypeInfo_Pointer : TypeInfo {
  TypeInfo next;
}

class TypeInfo_Delegate : TypeInfo {
  TypeInfo next;
  string deco;
}

class TypeInfo_Enum : TypeInfo {
    TypeInfo base;
    string   name;
    void[]   m_init;
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
}

class TypeInfo_StaticArray : TypeInfo {
  TypeInfo value;
  size_t   len;
}


// ldc defines this, used to find where wasm memory begins
private extern extern(C) ubyte __heap_base;
//                                           ---unused--- -- stack grows down -- -- heap here --
// this is less than __heap_base. memory map 0 ... __data_end ... __heap_base ... end of memory
private extern extern(C) ubyte __data_end;

private ubyte* nextFree;
private size_t memorySize;

ubyte[] malloc(size_t sz) {
	// lol bumping that pointer
	if(nextFree is null) {
		nextFree = &__heap_base;
		memorySize = wasm.memorySize();
	}

	auto ret = nextFree;

	nextFree += sz;

	return ret[0 .. sz];
}

extern(C) ubyte* bridge_malloc(size_t sz) {
	return malloc(sz).ptr;
}

// then the entry point just for convenience so main works.
extern(C) int _Dmain(string[] args);
extern(C) void _start() { _Dmain(null); }

extern(C) bool _xopEquals(in void*, in void*) { return false; }

extern(C) void _d_array_slice_copy(void* dst, size_t dstlen, void* src, size_t srclen, size_t elemsz) {
	auto d = cast(ubyte*) dst;
	auto s = cast(ubyte*) src;
	auto len = dstlen * elemsz;

	while(len) {
		*d = *s;
		d++;
		s++;
		len--;
	}

}

extern(C) void _d_throw_exception(Throwable throwable) {
	assert(false);
}

extern(C) void _d_assert(string file, uint line) {
	wasm.abort();
}

extern(C) void _d_assert_msg(string msg, string file, uint line) {
	wasm.abort();
}

extern(C) void _d_arraybounds(string file, size_t line) {
	assert(false);
}

extern(C) void* memset(void* s, int c, size_t n) {
	auto d = cast(ubyte*) s;
	while(n) {
		*d = cast(ubyte) c;
    d++;
		n--;
	}
	return s;
}

extern(C) void* memcpy(void* d, void* s, size_t n) {
	auto td = cast(ubyte*)d, ts = cast(ubyte*)s;
	while(n) {
		*td = *ts;
    td++;
    ts++;
		n--;
	}
	return d;
}

void __switch_error(string file, size_t line) {}

extern(C) Object _d_allocclass(TypeInfo_Class ti) {
	auto ptr = malloc(ti.m_init.length);
	ptr[] = ti.m_init[];
	return cast(Object) ptr.ptr;
}

extern(C) void* _d_allocmemory(size_t sz) {
	return malloc(sz).ptr;
}
extern (C) void _d_callfinalizer(void* p) {
}

extern (C) void* _d_interface_cast(void* p, TypeInfo_Class c) {
  return null;
}

extern (C) void* _d_dynamic_cast(Object o, TypeInfo_Class c) {
  return null;
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
	return malloc(length * ti.tsize);
}
extern (C) void[] _d_arrayappendT(const TypeInfo ti, ref byte[] x, byte[] y) {
	ubyte[] tmp = malloc((x.length + y.length) * ti.tsize);
	_d_array_slice_copy(&tmp[0], x.length, x.ptr, x.length, 1);
	_d_array_slice_copy(&tmp[x.length], y.length, y.ptr, y.length, 1);
	return tmp;
}
extern (C) byte[] _d_arrayappendcTX(const TypeInfo ti, ref byte[] px, size_t n) {
  assert(false);
}
extern (C) byte[] _d_arraycatT(const TypeInfo ti, byte[] x, byte[] y) {
  assert(false);
}
extern (C) void[] _d_arraycatnTX(const TypeInfo ti, byte[][] arrs) {
  assert(false);
}
extern (C) void[] _d_newarrayU(const TypeInfo ti, size_t length) {
  assert(false);
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
