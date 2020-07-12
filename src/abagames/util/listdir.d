module abagames.util.listdir;

string[] listdir(string pathname)
{
  import std.algorithm;
  import std.array;
  import std.file;
  import std.path;

  return std.file.dirEntries(pathname, SpanMode.shallow)
    .filter!(a => a.isFile)
    .map!(a => std.path.baseName(a.name))
    .array;
}
