module abagames.util.bulletml.parser;

import abagames.util.conv;
import std.stdio;
import std.string;

class Lexer(TokenType)
{
protected:
    string _input;
    int _start = 0;
    int _pos = 0;
    int _width = 0;

protected:
    const string az = "abcdefghijklmnopqrstuvwxyz";
    const string AZ = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    const string digits = "0123456789";
    const string alpha = az ~ AZ;
    const string alphaNum = alpha ~ digits;

public:
    struct Token {
      TokenType type;
      string value;
    }
    
    this(string input) {
      _input = input;
    }

    @property string input() { return _input; }
    abstract Token token();

protected:
    int next()
    {
      if (_pos >= _input.length) {
          return -1;
      }
      _width++;
      char c = _input[_pos];
      _pos += 1;
      return c;
    }

    void backup(int n)
    {
      assert(_width >= n, "width=" ~ convString(_width) ~ " n=" ~ convString(n));
      _pos -= n;
      _width -= n;
    }

    bool acceptExact(string valid)
    {
      foreach (idx, v; valid) {
        auto c = next();
        if (c == -1) {
          return false;
        }
        if (c != v) {
          backup(idx + 1);
          return false;
        }
      }
      return true;
    }

    bool acceptRun(string valid)
    {
      auto prevPos = _pos;
      for (int c = next(); c != -1; c = next()) {
        if (valid.indexOf(c) == -1) {
          backup(1);
          break;
        }
      }
      return _pos != prevPos;
    }

    bool acceptRunExclude(string invalid)
    {
      auto prevPos = _pos;
      for (int c = next(); c != -1; c = next()) {
        if (invalid.indexOf(c) != -1) {
          backup(1);
          break;
        }
      }
      return _pos != prevPos;
    }

    string currentValue() {
      return _input[_start .. _pos];
    }

    Token emit(TokenType type)
    {
      string value = currentValue();
      discard();
      return Token(type, value);
    }

    void discard()
    {
      _start = _pos;
      _width = 0;
    }
}

interface PrefixParselet(TokenType, ReturnType) {
  alias Token = Lexer!TokenType.Token;
  ReturnType parse(Parser!(TokenType, ReturnType) parser, Token token);
}

interface InfixParselet(TokenType, ReturnType) {
  alias Token = Lexer!TokenType.Token;
  ReturnType parse(Parser!(TokenType, ReturnType) parser, ReturnType left, Token token);
  @property int precedence();
}

class Parser(TokenType, ReturnType)
{
private:
    alias LexerType = Lexer!TokenType;
    alias Token = LexerType.Token;
    alias PrefixType = PrefixParselet!(TokenType, ReturnType);
    alias InfixType = InfixParselet!(TokenType, ReturnType);

    LexerType _lexer;
    Token[] _read;
    PrefixType[TokenType] _prefixParselets;
    InfixType[TokenType] _infixParselets;

public:
    this(LexerType lexer) {
      _lexer = lexer;
    }

    ReturnType parseExpression() {
        return parseExpression(0);
    }

    void add(TokenType token, PrefixType parselet) {
        _prefixParselets[token] = parselet;
    }

    void add(TokenType token, InfixType parselet) {
        _infixParselets[token] = parselet;
    }

    ReturnType parseExpression(int precedence) {
        Token token = consume();

        auto prefix = token.type in _prefixParselets;
        assert(prefix !is null, convString(token.type) ~ " " ~ _lexer.input);

        auto left = prefix.parse(this, token);

        while (precedence < getPrecedence())
        {
            token = consume();

            auto infix = token.type in _infixParselets;
            assert(infix !is null);

            left = infix.parse(this, left, token);
        }

        return left;
    }

    Token consume(TokenType expected) {
        Token token = lookAhead(0);
        assert(token.type == expected);
        return consume();
    }

    Token consume() {
        // Make sure we've read the token.
        lookAhead(0);

        Token t = _read[0];
        _read = _read[1..$];
        return t;
    }

    Token lookAhead(int distance) {
        // Read in as many as needed.
        while (distance >= _read.length) {
            _read ~= _lexer.token();
        }

        // Get the queued token.
        return _read[distance];
    }

    int getPrecedence() {
        auto parser = lookAhead(0).type in _infixParselets;
        if (parser !is null) {
            return parser.precedence;
        }
        return 0;
    }
}