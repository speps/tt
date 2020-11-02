module std.stdio;

import wasm;

void writeln(string s) {
  wasm.write(s);
}
void write(string s) {
  wasm.write(s);
}
