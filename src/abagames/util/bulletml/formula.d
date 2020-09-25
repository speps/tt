module abagames.util.bulletml.formula;

import std.conv;
import std.string;

import abagames.util.bulletml.bulletmlrunner;
import abagames.util.logger;

struct Context {
  BulletMLRunner runner;
  BulletMLParameters parameters;
}

interface AbstractNumber {
  double getValue(Context context) const;
}

class Rank : AbstractNumber {
  double getValue(Context context) const {
    return BulletMLRunner.getRank(context.runner);
  }
}

class Random : AbstractNumber {
  double getValue(Context context) const {
    return BulletMLRunner.getRand(context.runner);
  }
}

class Param : AbstractNumber {
  double function(int id) getParam;

  this(int id) {
    _id = id;
  }

  double getValue(Context context) const {
    return context.parameters[_id];
  }

private:
  int _id;
}

class Number : AbstractNumber {
  this(double v) {
    _value = v;
  }

  double getValue(Context context) const {
    return _value;
  }

private:
  double _value;
}

class Formula : AbstractNumber {
  enum Operator {
    nil, add, sub, mul, div
  }

  this(AbstractNumber v) {
    _lhs = v;
    _rhs = null;
    _op = Operator.nil;
    _headSub = false;
  }

  this(AbstractNumber lhs, Operator op, AbstractNumber rhs) {
    _lhs = lhs;
    _rhs = rhs;
    _op = op;
    _headSub = false;
  }

  double getValue(Context context) const {
    return _headSub ? -computeValue(context) : computeValue(context);
  }
  @property void headSub(bool v) {
    _headSub = v;
  }

private:
  double computeValue(Context context) const {
    final switch (_op) {
      case Operator.nil:
        return _lhs.getValue(context);
      case Operator.add:
        return _lhs.getValue(context) + _rhs.getValue(context);
      case Operator.sub:
        return _lhs.getValue(context) - _rhs.getValue(context);
      case Operator.mul:
        return _lhs.getValue(context) * _rhs.getValue(context);
      case Operator.div:
        return _lhs.getValue(context) / _rhs.getValue(context);
    }
  }

  AbstractNumber _lhs, _rhs;
  Operator _op;
  bool _headSub;
}

private {

  enum TokenType
  {
      Invalid,
      LeftParen,
      RightParen,
      Num,
      OpPlus,
      OpMinus,
      OpMul,
      OpDiv,
      Param,
      Name,
  }

  struct Token
  {
      TokenType type = TokenType.Invalid;
      string value;
  }

  class Lexer
  {
  private:
      string _input;
      string _message;
      int _start = 0;
      int _pos = 0;
      int _width = 0;

      const string az = "abcdefghijklmnopqrstuvwxyz";
      const string AZ = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
      const string digits = "0123456789";
      const string alpha = az ~ AZ;
      const string alphaNum = alpha ~ digits;

  public:
      this(string input) {
        _input = input;
      }

      Token token() {
          while (true)
          {
              if (accept("(")) {
                  return emit(TokenType.LeftParen);
              }
              else if (accept(")")) {
                  return emit(TokenType.RightParen);
              }
              else if (accept("+")) {
                  return emit(TokenType.OpPlus);
              }
              else if (accept("-")) {
                  return emit(TokenType.OpMinus);
              }
              else if (accept("*")) {
                  return emit(TokenType.OpMul);
              }
              else if (accept("/")) {
                  return emit(TokenType.OpDiv);
              }
              else if (accept("$")) {
                  return emit(TokenType.Param);
              }
              else if (accept(alpha)) {
                  acceptRun(alpha);
                  return emit(TokenType.Name);
              }
              else if (accept(digits)) {
                  acceptRun(digits);
                  if (accept(".")) {
                      acceptRun(digits);
                  }
                  return emit(TokenType.Num);
              }
              if (next() == -1) {
                  break;
              }
              backup();
          }
          return Token();
      }

  private:
      int next()
      {
          if (_pos >= _input.length) {
              _width = 0;
              return -1;
          }
          _width = 1;
          char c = _input[_pos];
          _pos += _width;
          return c;
      }

      void backup()
      {
          _pos -= _width;
      }

      bool accept(string valid)
      {
          if (valid.indexOf(next()) != -1) {
              return true;
          }
          backup();
          return false;
      }

      void acceptRun(string valid)
      {
          while (valid.indexOf(next()) != -1) {}
          backup();
      }

      Token emit(TokenType type)
      {
          string value = _input[_start .. _pos];
          _start = _pos;
          return Token(type, value);
      }
  }

  interface PrefixParselet(T) {
    T parse(Parser!T parser, Token token);
  }

  interface InfixParselet(T) {
    T parse(Parser!T parser, T left, Token token);
    @property int precedence();
  }

  class Parser(T)
  {
  private:

  private:
      Lexer _lexer;
      Token[] _read;
      PrefixParselet!T[TokenType] _prefixParselets;
      InfixParselet!T[TokenType] _infixParselets;

  public:
      this(Lexer lexer) {
        _lexer = lexer;
      }

      T parseExpression()
      {
          return parseExpression(0);
      }

      void add(TokenType token, PrefixParselet!T parselet) {
          _prefixParselets[token] = parselet;
      }

      void add(TokenType token, InfixParselet!T parselet) {
          _infixParselets[token] = parselet;
      }

      T parseExpression(int precedence)
      {
          Token token = consume();

          auto prefix = token.type in _prefixParselets;
          assert(prefix !is null);

          T left = prefix.parse(this, token);

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

  class NegOperatorParselet : PrefixParselet!Formula
  {
  private:
      int _precedence;

  public:
      this(int precedence) {
        _precedence = precedence;
      }

      Formula parse(Parser!Formula parser, Token token)
      {
          Formula right = parser.parseExpression(_precedence);
          right.headSub = true;
          return right;
      }
  }

  class ParamOperatorParselet : PrefixParselet!Formula
  {
  public:
      Formula parse(Parser!Formula parser, Token)
      {
          Token param = parser.consume();
          if (param.type == TokenType.Name) {
              if (param.value == "rank") {
                  return new Formula(new Rank());
              }
              else if (param.value == "rand") {
                  return new Formula(new Random());
              }
              else {
                  assert(false);
              }
          }
          else if (param.type == TokenType.Num) {
              int paramId = to!int(param.value);
              return new Formula(new Param(paramId));
          }
          assert(false);
      }
  }

  class BinaryOperatorParselet : InfixParselet!Formula
  {
  private:
      int _precedence;

  public:
      this(int precedence) {
        _precedence = precedence;
      }

      Formula parse(Parser!Formula parser, Formula left, Token token)
      {
          Formula right = parser.parseExpression(_precedence);
          if (token.type == TokenType.OpPlus) {
              return new Formula(left, Formula.Operator.add, right);
          }
          else if (token.type == TokenType.OpMinus) {
              return new Formula(left, Formula.Operator.sub, right);
          }
          else if (token.type == TokenType.OpMul) {
              return new Formula(left, Formula.Operator.mul, right);
          }
          else if (token.type == TokenType.OpDiv) {
              return new Formula(left, Formula.Operator.div, right);
          }
          assert(false);
      }

      @property int precedence() { return _precedence; }
  }

  class GroupParselet : PrefixParselet!Formula
  {
  public:
      Formula parse(Parser!Formula parser, Token token) {
          Formula right = parser.parseExpression();
          parser.consume(TokenType.RightParen);
          return right;
      }
  }

  class NumberParselet : PrefixParselet!Formula
  {
  public:
      Formula parse(Parser!Formula parser, Token token) {
        double v = to!double(token.value);
        return new Formula(new Number(v));
      }
  };

  class ExpressionParser : Parser!Formula
  {
  public:
      this(Lexer lexer) {
        super(lexer);
        add(TokenType.LeftParen, new GroupParselet());
        add(TokenType.Num, new NumberParselet());
        add(TokenType.Param, new ParamOperatorParselet());
        add(TokenType.OpMinus, new NegOperatorParselet(6));
        add(TokenType.OpPlus, new BinaryOperatorParselet(3));
        add(TokenType.OpMinus, new BinaryOperatorParselet(3));
        add(TokenType.OpMul, new BinaryOperatorParselet(4));
        add(TokenType.OpDiv, new BinaryOperatorParselet(4));
      }
  };
}

Formula calc(string s) {
  auto lexer = new Lexer(s);
  auto parser = new ExpressionParser(lexer);
  return parser.parseExpression();
}
