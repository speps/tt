module std.string;

int indexOf(string s, int n) {
  foreach (const c; 0 .. s.length) {
    if (s[c] == n) {
      return c;
    }
  }
  return -1;
}

bool empty(string s) {
  return s.length == 0;
}

string toStringz(string s) {
  if (!s.empty && s[$-1] != '\0') {
    return s ~ '\0';
  }
  return s;
}
