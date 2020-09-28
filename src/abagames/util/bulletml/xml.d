module abagames.util.bulletml.xml;

import abagames.util.bulletml.parser;

import std.stdio;

enum ElementType
{
  TagOpen,
  TagClose,
  Text
}

struct Attribute
{
  string name;
  string value;
}

struct Element
{
  ElementType type;
  string value;
  Attribute[] attributes;
}

Element[] parseXML(string s) {
  Element[] elements;
  auto lexer = new XMLLexer(s);
  for (auto tok = lexer.token(); tok.type != TokenType.Invalid; tok = lexer.token()) {
    if (tok.type == TokenType.Header || tok.type == TokenType.Doctype) {
      continue;
    }
    else if (tok.type == TokenType.TagOpen) {
      // remove angle brackets
      string value = tok.value[1..$-1];
      // if auto closed tag, remove slash
      bool closed = false;
      if (value[$-1] == '/') {
        value = value[0..$-1];
        closed = true;
      }

      // find first space
      const string space = " \t\r\n";
      int spaceIndex = -1;
      search: foreach (idx, c; value) {
        foreach (sc; space) {
          if (sc == c) {
            spaceIndex = idx;
            break search;
          }
        }
      }

      string name = value;
      Attribute[] attrs;
      if (spaceIndex != -1) {
        name = value[0..spaceIndex];
        auto attrLexer = new AttributeLexer(value[spaceIndex..$]);
        for (auto attrName = attrLexer.token(); attrName.type != TokenType.Invalid; attrName = attrLexer.token()) {
          assert(attrName.type == TokenType.AttrName);
          auto attrValue = attrLexer.token();
          assert(attrValue.type == TokenType.AttrValue);
          // trim = for name, trim quotes for value
          attrs ~= Attribute(attrName.value[0..$-1], attrValue.value[1..$-1]);
        }
      }
      elements ~= Element(ElementType.TagOpen, name, attrs);
      if (closed) {
        elements ~= Element(ElementType.TagClose, name, []);
      }
    }
    else if (tok.type == TokenType.TagClose) {
      string name = tok.value[2..$-1];
      elements ~= Element(ElementType.TagClose, name, []);
    }
    else if (tok.type == TokenType.Text) {
      elements ~= Element(ElementType.Text, tok.value, []);
    }
  }
  return elements;
}

private:

enum TokenType
{
  Invalid,
  Header,
  Doctype,
  TagOpen,
  TagClose,
  AttrName,
  AttrValue,
  Text,
}

class AttributeLexer : Lexer!TokenType
{
public:
  this(string s) {
    super(s);
  }

  override Token token() {
    while (true) {
      if (acceptRun(" \t\r\n")) {
        discard();
        continue;
      }
      if (acceptRun(alphaNum)) {
        if (acceptExact("=")) {
          return emit(TokenType.AttrName);
        }
        assert(false, currentValue());
      }
      else if (acceptExact("\"")) {
        if (acceptRunExclude("\"")) {
          if (acceptExact("\"")) {
            return emit(TokenType.AttrValue);
          }
        }
        assert(false, currentValue());
      }
      if (next() == -1) {
          break;
      }
      backup(1);
    }
    return Token();
  }
}

class XMLLexer : Lexer!TokenType
{
public:
  this(string s) {
    super(s);
  }

  override Token token() {
    while (true) {
      if (acceptRun(" \t\r\n")) {
        discard();
        continue;
      }
      if (acceptExact("<?")) {
        acceptRunExclude(">");
        if (acceptExact(">")) {
          return emit(TokenType.Header);
        }
        assert(false, currentValue());
      }
      else if (acceptExact("<!")) {
        acceptRunExclude(">");
        if (acceptExact(">")) {
          return emit(TokenType.Doctype);
        }
        assert(false, currentValue());
      }
      else if (acceptExact("</")) {
        acceptRunExclude(">");
        if (acceptExact(">")) {
          return emit(TokenType.TagClose);
        }
        assert(false, currentValue());
      }
      else if (acceptExact("<")) {
        acceptRunExclude(">");
        if (acceptExact(">")) {
          return emit(TokenType.TagOpen);
        }
        assert(false, currentValue());
      }
      else if (acceptRunExclude("<")) {
        return emit(TokenType.Text);
      }
      if (next() == -1) {
          break;
      }
      backup(1);
    }
    return Token();
  }
}
