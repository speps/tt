module wasm;

private:
alias cstr_t = const(char*);
extern(C) size_t wasm_memorySize();
extern(C) void wasm_writeString(cstr_t msgptr, size_t msglen);
extern(C) void wasm_writeInt(int n);
extern(C) void wasm_assert(cstr_t msgptr, size_t msglen, cstr_t fileptr, size_t filelen, size_t line);
extern(C) void wasm_abort();

version(X86) {
  static const size_t SIZE = 10 * 1024 * 1024;
  static const auto newline = "\n";

  pragma(lib, "kernel32");
  alias HANDLE = uint;
  alias DWORD = int;
  alias BOOL = int;
  extern(Windows) void DebugBreak();
  extern(Windows) void ExitProcess(uint uExitCode);
  extern(Windows) HANDLE GetStdHandle(DWORD nStdHandle);
  extern(Windows) BOOL WriteFile(HANDLE hFile, const(void*) lpBuffer, DWORD nNumberOfBytesToWrite, DWORD* lpNumberOfBytesWritten, void* lpOverlapped);
  extern(C) int _itoa_s(int value, char* buffer, size_t size, int radix);

  void stdOut(cstr_t ptr, size_t len) {
    auto hStdOut = GetStdHandle(-11);
    WriteFile(hStdOut, ptr, len, null, null);
  }

  extern(C) ubyte[SIZE] __heap_base;
  extern(C) size_t wasm_memorySize() {
    return SIZE;
  }
  extern(C) size_t wasm_growMemory(size_t by) {
    assert(false, "growing memory not supported");
  }
  extern(C) void wasm_writeString(cstr_t msgptr, size_t msglen) {
    stdOut(msgptr, msglen);
    stdOut(newline.ptr, newline.length);
  }
  extern(C) void wasm_writeInt(int n) {
    static char[128] buffer;
    if (_itoa_s(n, buffer.ptr, buffer.length, 10) == 0) {
      int len = 0;
      while (len < buffer.length) {
        if (buffer[len] == 0) {
          break;
        }
        len++;
      }
      stdOut(buffer.ptr, len);
      stdOut(newline.ptr, newline.length);
    }
  }
  extern(C) void wasm_assert(cstr_t msgptr, size_t msglen, cstr_t fileptr, size_t filelen, size_t line) {
    wasm_writeString(msgptr, msglen);
    wasm_writeString(fileptr, filelen);
    wasm_writeInt(line);
  }
  extern(C) void wasm_abort() {
    DebugBreak();
    ExitProcess(-1);
  }
} else {
  extern(C) size_t wasm_memorySize();
  extern(C) size_t wasm_growMemory(size_t by);
  extern(C) void wasm_writeString(cstr_t msgptr, size_t msglen);
  extern(C) void wasm_writeInt(int n);
  extern(C) void wasm_assert(cstr_t msgptr, size_t msglen, cstr_t fileptr, size_t filelen, size_t line);
  extern(C) void wasm_abort();
}

public:
size_t memorySize() { return wasm_memorySize(); }
size_t growMemory(size_t by) { return wasm_growMemory(by); }
void write(string s) { return wasm_writeString(s.ptr, s.length); }
void write(int n) { return wasm_writeInt(n); }
void assertMessage(string msg, string file, int line) { return wasm_assert(msg.ptr, msg.length, file.ptr, file.length, line); }
void abort() { wasm_abort(); }
