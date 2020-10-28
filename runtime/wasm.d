module wasm;

private:
extern(C) size_t wasm_memorySize();
extern(C) size_t wasm_growMemory(size_t by);
extern(C) void wasm_abort();

public:
size_t memorySize() { return wasm_memorySize(); }
size_t growMemory(size_t by) { return wasm_growMemory(by); }
void abort() { wasm_abort(); }
