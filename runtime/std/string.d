module std.string;

string toStringz(string s) {
  if (!s.empty && s[$-1] != '\0') {
    return s ~ '\0';
  }
  return s;
}
