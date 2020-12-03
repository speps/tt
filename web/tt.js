var decoder = new TextDecoder();
var encoder = new TextEncoder();

function bin2hex(buf) {
  return buf.reduce(function(hexstr, byte) {
    return hexstr + ('0' + (byte & 0xFF).toString(16)).slice(-2);
  }, "");
}
function hex2bin(hexstr) {
  return Uint8Array.from(hexstr.match(/../g).reduce(function(bytes, hex) {
    bytes.push(parseInt(hex, 16));
    return bytes;
  }, []));
}

var memory = null;

var loading = document.getElementById("loading");
var canvas = document.getElementById("screen");
var gl = canvas.getContext("webgl");
var vaoExt = gl.getExtension('OES_vertex_array_object');
if (vaoExt) {
  gl['createVertexArray'] = function() { return vaoExt['createVertexArrayOES'](); };
  gl['deleteVertexArray'] = function(vao) { vaoExt['deleteVertexArrayOES'](vao); };
  gl['bindVertexArray'] = function(vao) { vaoExt['bindVertexArrayOES'](vao); };
  gl['isVertexArray'] = function(vao) { return vaoExt['isVertexArrayOES'](vao); };
} else {
  throw new Error("OES_vertex_array_object extension not supported");
}
var glObjects = [null];
var glCreateId = function(obj) {
  const id = glObjects.length;
  glObjects[id] = obj;
  return id;
}

var AudioContext = window.AudioContext || window.webkitAudioContext;
var ac = AudioContext ? new AudioContext() : null;
var acData = {};
var acMusic = null;

var inputState = 0;

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
      console.trace("growMemory by " + by + " > " + (numPages * bytesPerPage) + " bytes to " + memory.buffer.byteLength + " bytes");
      return memory.buffer.byteLength;
    },
    wasm_writeString: function(ptr, len) {
      var s = decoder.decode(new Uint8Array(memory.buffer, ptr, len));
      console.log(s);
    },
    wasm_writeInt: function(n) {
      console.log(n);
    },
    wasm_readFileSize: function(nameptr, namelen, sizeptr) {
      const name = decoder.decode(new Uint8Array(memory.buffer, nameptr, namelen));
      const size = new Uint32Array(memory.buffer, sizeptr, 4);
      const str = localStorage.getItem(name);
      if (str) {
        const data = hex2bin(str);
        size.set([data.length]);
        return true;
      }
      return false;
    },
    wasm_readFile: function(nameptr, namelen, dataptr, datalen) {
      const name = decoder.decode(new Uint8Array(memory.buffer, nameptr, namelen));
      const output = new Uint8Array(memory.buffer, dataptr, datalen);
      const str = localStorage.getItem(name);
      if (str) {
        const data = hex2bin(str);
        if (data.length == output.length) {
          console.log("read " + name + " with " + data.length + " bytes");
          output.set(data);
          return true;
        } else {
          console.error("data read was " + data.length + " while expected was " + output.length);
        }
      } else {
        console.error("calling readFile without checking return value of readFileSize");
      }
    },
    wasm_writeFile: function(nameptr, namelen, dataptr, datalen) {
      const name = decoder.decode(new Uint8Array(memory.buffer, nameptr, namelen));
      const data = new Uint8Array(memory.buffer, dataptr, datalen);
      const str = bin2hex(data);
      localStorage.setItem(name, str);
      console.log("saved " + name + " with " + data.length + " bytes");
    },
    wasm_assert: function(msgptr, msglen, fileptr, filelen, line) {
      var msg = decoder.decode(new Uint8Array(memory.buffer, msgptr, msglen));
      var file = decoder.decode(new Uint8Array(memory.buffer, fileptr, filelen));
      throw "assert: " + file + ":" + line + ": " + msg;
    },
    wasm_abort: function() {
      throw "abort";
    },
    wasm_time: function() {
      return (new Date().valueOf() / 1000) >> 0;
    },
    wasm_inputState: function() {
      return inputState;
    },
    wasm_cos: Math.cos,
    wasm_sin: Math.sin,
    wasm_atan2: Math.atan2,
    wasm_sqrt: Math.sqrt,
    wasm_pow: Math.pow,
    wasm_fmodf: function(x, y) { return x % y; },
    wasm_sound_load: function(nameptr, namelen, bufptr, buflen) {
      if (!ac) return;
      const name = decoder.decode(new Uint8Array(memory.buffer, nameptr, namelen));
      const buffer = memory.buffer.slice(bufptr, bufptr + buflen);
      ac.decodeAudioData(buffer,
        function(data) {
          acData[name] = data;
        },
        function(err) {
          console.error(err);
        }
      );
    },
    wasm_sound_play: function(nameptr, namelen) {
      if (!ac) return;
      const name = decoder.decode(new Uint8Array(memory.buffer, nameptr, namelen));
      const isMusic = name.startsWith("sounds/musics");
      const src = ac.createBufferSource();
      src.buffer = acData[name];
      if (isMusic) {
        if (acMusic) {
          acMusic.node.stop();
          acMusic.gain.disconnect();
          acMusic = null;
        }
        const gain = ac.createGain();
        src.connect(gain);
        src.loop = true;
        gain.connect(ac.destination);
        acMusic = { node: src, gain: gain };
      } else {
        src.connect(ac.destination);
      }
      src.start();
    },
    wasm_sound_fadeMusic: function(ms) {
      if (acMusic) {
        acMusic.gain.linearRampToValueAtTime(0, ac.currentTime + ms * 0.001);
      }
    },
    wasm_sound_haltMusic: function() {
      if (acMusic) {
        acMusic.node.stop();
      }
    },
    glCreateProgram: function() {
      const id = glCreateId(gl.createProgram());
      return id;
    },
    glCreateShader: function(t) {
      const id = glCreateId(gl.createShader(t));
      return id;
    },
    glUseProgram: function(p) { gl.useProgram(glObjects[p]); },
    glShaderSource: function(s, n, srcptr, lenptr) {
      const ptr = new Uint32Array(memory.buffer, srcptr, 1)[0];
      const len = new Uint32Array(memory.buffer, lenptr, 1)[0];
      const src = decoder.decode(new Uint8Array(memory.buffer, ptr, len));
      gl.shaderSource(glObjects[s], src);
    },
    glGetShaderInfoLog: function(s, buflen, lenptr, bufptr) {
      const msg = gl.getShaderInfoLog(glObjects[s]);
      const buf = new Uint8Array(memory.buffer, bufptr, buflen);
      const bytes = encoder.encode(msg);
      buf.set(bytes);
      const len = new Uint32Array(memory.buffer, lenptr, 1);
      len.set([bytes.length]);
    },
    glGetShaderiv: function(s, f, vptr) {
      const param = gl.getShaderParameter(glObjects[s], f);
      const v = new Uint32Array(memory.buffer, vptr, 1);
      v.set([param]);
    },
    glGetProgramInfoLog: function(p, buflen, lenptr, bufptr) {
      const msg = gl.getProgramInfoLog(glObjects[p]);
      const buf = new Uint8Array(memory.buffer, bufptr, buflen);
      const bytes = encoder.encode(msg);
      buf.set(bytes);
      const len = new Uint32Array(memory.buffer, lenptr, 1);
      len.set([bytes.length]);
    },
    glGetProgramiv: function(s, f, vptr) {
      const param = gl.getProgramParameter(glObjects[s], f);
      const v = new Uint32Array(memory.buffer, vptr, 1);
      v.set([param]);
    },
    glCompileShader: function(s) { gl.compileShader(glObjects[s]); },
    glAttachShader: function(p, s) { gl.attachShader(glObjects[p], glObjects[s]); },
    glLinkProgram: function(p) { gl.linkProgram(glObjects[p]); },
    glValidateProgram: function(p) { gl.validateProgram(glObjects[p]); },
    glGetUniformLocationWithLen: function(p, ptr, len) {
      const name = decoder.decode(new Uint8Array(memory.buffer, ptr, len));
      return glCreateId(gl.getUniformLocation(glObjects[p], name));
    },
    glGetAttribLocationWithLen: function(p, ptr, len) {
      const name = decoder.decode(new Uint8Array(memory.buffer, ptr, len));
      return gl.getAttribLocation(glObjects[p], name);
    },
    glViewport: function(x, y, w, h) { gl.viewport(x, y, w, h); },
    glClearColor: function(r, g, b, a) { gl.clearColor(r, g, b, a); },
    glClear: function(f) { gl.clear(f); },
    glGenVertexArrays: function(n, ptr) {
      for (var i = 0; i < n; i++) {
        const dest = new Uint32Array(memory.buffer, ptr + i * 4, 1);
        const id = glCreateId(gl.createVertexArray());
        dest.set([id]);
      }
    },
    glBindVertexArray: function(va) {
      gl.bindVertexArray(glObjects[va]);
    },
    glGenBuffers: function(n, ptr) {
      for (var i = 0; i < n; i++) {
        const dest = new Uint32Array(memory.buffer, ptr + i * 4, 1);
        const id = glCreateId(gl.createBuffer());
        dest.set([id]);
      }
    },
    glBindBuffer: function(t, b) { gl.bindBuffer(t, glObjects[b]); },
    glBufferData: function(t, size, ptr, usage) {
      if (ptr != 0) {
        const buf = new Uint8Array(memory.buffer, ptr, size);
        gl.bufferData(t, buf, usage);
      } else {
        gl.bufferData(t, size, usage);
      }
    },
    glVertexAttribPointer: function(index, size, type, normalized, stride, offset) {
      gl.vertexAttribPointer(index, size, type, normalized, stride, offset);
    },
    glEnableVertexAttribArray: function(i) { gl.enableVertexAttribArray(i); },
    glDisableVertexAttribArray: function(i) { gl.disableVertexAttribArray(i); },
    glBlendFunc: function(s, d) { gl.blendFunc(s, d); },
    glEnable: function(f) { gl.enable(f); },
    glDisable: function(f) { gl.disable(f); },
    glLineWidth: function(w) { gl.lineWidth(w); },
    glUniformMatrix4fv: function(loc, n, t, ptr) {
      const m = new Float32Array(memory.buffer, ptr, 16);
      gl.uniformMatrix4fv(glObjects[loc], t, m);
    },
    glDrawArrays: function(m, s, n) {
      gl.drawArrays(m, s, n);
    }
  }
};

var started = false;
const targetFrameRate = 1000.0 / 60.0;
var frameAccumulator = 0.0;
var previousTimestamp = null;
function loop(timestamp) {
  if (previousTimestamp == null) {
    previousTimestamp = timestamp;
  } else {
    const diff = timestamp - previousTimestamp;
    previousTimestamp = timestamp;
    frameAccumulator += diff;
  }
  var numUpdates = 0;
  while (frameAccumulator >= targetFrameRate) {
    frameAccumulator -= targetFrameRate;
    if (!exports._update()) {
      numUpdates++;
    } else {
      break;
    }
  }
  if (numUpdates > 0) {
    exports._draw();
    numUpdates = 0;
  }
  requestAnimationFrame(loop);
}

function maskInput(code, enable) {
  const masks = {
    ArrowUp: 0x1,
    ArrowDown: 0x2,
    ArrowLeft: 0x4,
    ArrowRight: 0x8,
    ControlLeft: 0x10,
    ShiftLeft: 0x20,
    Escape: 0x40,
    KeyP: 0x80
  };
  if (code in masks) {
    const mask = masks[code];
    if (enable) {
      inputState |= mask;
    } else {
      inputState &= ~mask;
    }
    return true;
  }
  return false;
}

window.addEventListener("keydown", function(event) {
  if (!event.defaultPrevented) {
    if (maskInput(event.code, true)) {
      event.preventDefault();
    }
  }
});

window.addEventListener("keyup", function(event) {
  if (!event.defaultPrevented) {
    if (started && (inputState & 0x10) != 0) {
      onStart();
    }
    if (maskInput(event.code, false)) {
      event.preventDefault();
    }
  }
});

window.addEventListener("resize", onResize, true);

const expectedBufferLength = 8032937;
fetch('./tt.wasm').then(function(response) {
  const reader = response.body.getReader();
  var chunks = [];
  var total = 0;
  function add(result) {
    if (result.done) {
      var buffer = new Uint8Array(total);
      var offset = 0;
      for (const chunk of chunks) {
        buffer.set(chunk, offset);
        offset += chunk.length;
      }
      WebAssembly.instantiate(buffer, importObject)
        .then(function(obj) {
          memory = obj.instance.exports.memory;
          exports = obj.instance.exports;
          exports._start();
          onResize();
          onLoad();
          started = true;
        });
    } else {
      chunks.push(result.value);
      total += result.value.length;
      onProgress(total / expectedBufferLength);
      reader.read().then(add);
    }
  }
  reader.read().then(add);
});
