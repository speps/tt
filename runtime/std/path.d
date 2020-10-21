module std.path;

string extension(string s) {
  for (int i = s.length - 1; i >= 0; i--) {
    if (s[i] == '.') {
      return s[i .. s.length];
    }
  }
  return "";
}
