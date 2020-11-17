module std.stdio;

import wasm;

void writeln(string s) {
  wasm.write(s);
}
void writeln(int i) {
  wasm.write(i);
}
void write(string s) {
  wasm.write(s);
}
void write(int i) {
  wasm.write(i);
}
