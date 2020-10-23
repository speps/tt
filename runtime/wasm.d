module wasm;

extern(C) size_t memorySize();
extern(C) size_t growMemory(size_t by);
extern(C) void abort();
