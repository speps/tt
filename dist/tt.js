var decoder = new TextDecoder();
var memory;

var importObject = {
  env: {
    wasm_memorySize: function() {
      console.log("memorySize is " + memory.buffer.byteLength + " bytes");
      return memory.buffer.byteLength;
    },
    wasm_growMemory: function(by) {
      const bytesPerPage = 64 * 1024;
      const numPages = ((by * bytesPerPage) / bytesPerPage) >> 0;
      memory.grow(numPages);
      console.log("growMemory by " + by + " > " + (numPages * bytesPerPage) + " bytes to " + memory.buffer.byteLength + " bytes");
      return memory.buffer.byteLength;
    },
    wasm_writeString: function(ptr, len) {
      var s = decoder.decode(new Uint8Array(memory.buffer, ptr, len));
      console.log(s);
    },
    wasm_writeInt: function(n) {
      console.log(n);
    },
    wasm_assert: function(msgptr, msglen, fileptr, filelen, line) {
      var msg = decoder.decode(new Uint8Array(memory.buffer, msgptr, msglen));
      var file = decoder.decode(new Uint8Array(memory.buffer, fileptr, filelen));
      throw "assert: " + file + ":" + line + ": " + msg;
    },
    wasm_abort: function() {
      throw "abort";
    },
    wasm_cos: Math.cos,
    wasm_sin: Math.sin,
    wasm_atan2: Math.atan2,
    wasm_sqrt: Math.sqrt,
    wasm_pow: Math.pow
  }
};

WebAssembly.instantiateStreaming(fetch('./tt.wasm'), importObject)
  .then(function(obj) {
    memory = obj.instance.exports.memory;
    exports = obj.instance.exports;
    obj.instance.exports._start();
  });
