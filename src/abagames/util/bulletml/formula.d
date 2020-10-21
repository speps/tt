module abagames.util.bulletml.formula;

import std.string;

import abagames.util.conv;
import abagames.util.bulletml.bulletmlrunner;
import abagames.util.bulletml.parser;
import abagames.util.logger;

Formula calc(string s) {
  auto lexer = new ExpressionLexer(s);
  auto parser = new ExpressionParser(lexer);
  return parser.parseExpression();
}

struct Context {
  BulletMLRunner runner;
  BulletMLParameters parameters;
}

interface AbstractNumber {
  float getValue(Context context) const;
}

class Rank : AbstractNumber {
  float getValue(Context context) const {
    return BulletMLRunner.getRank(context.runner);
  }
}

class Random : AbstractNumber {
  float getValue(Context context) const {
    return BulletMLRunner.getRand(context.runner);
  }
}

class Param : AbstractNumber {
  float function(int id) getParam;

  this(int id) {
    _id = id;
  }

  float getValue(Context context) const {
    return context.parameters[_id];
  }

private:
  int _id;
}

class Number : AbstractNumber {
  this(float v) {
    _value = v;
  }

  float getValue(Context context) const {
    return _value;
  }

private:
  float _value;
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

  float getValue(Context context) const {
    return _headSub ? -computeValue(context) : computeValue(context);
  }
  @property void headSub(bool v) {
    _headSub = v;
  }

private:
  float computeValue(Context context) const {
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

private:

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

class ExpressionLexer : Lexer!TokenType
{
public:
    this(string s) {
      super(s);
    }

    override Token token() {
        while (true) {
            if (acceptExact("(")) {
                return emit(TokenType.LeftParen);
            }
            else if (acceptExact(")")) {
                return emit(TokenType.RightParen);
            }
            else if (acceptExact("+")) {
                return emit(TokenType.OpPlus);
            }
            else if (acceptExact("-")) {
                return emit(TokenType.OpMinus);
            }
            else if (acceptExact("*")) {
                return emit(TokenType.OpMul);
            }
            else if (acceptExact("/")) {
                return emit(TokenType.OpDiv);
            }
            else if (acceptExact("$")) {
                return emit(TokenType.Param);
            }
            else if (acceptRun(alpha)) {
                return emit(TokenType.Name);
            }
            else if (acceptRun(digits)) {
                if (acceptExact(".")) {
                    acceptRun(digits);
                }
                return emit(TokenType.Num);
            }
            if (next() == -1) {
                break;
            }
            backup(1);
        }
        return Token();
    }
}

class NegOperatorParselet : PrefixParselet!(TokenType, Formula)
{
private:
    int _precedence;

public:
    this(int precedence) {
      _precedence = precedence;
    }

    Formula parse(Parser!(TokenType, Formula) parser, Token token)
    {
        Formula right = parser.parseExpression(_precedence);
        right.headSub = true;
        return right;
    }
}

class ParamOperatorParselet : PrefixParselet!(TokenType, Formula)
{
public:
    Formula parse(Parser!(TokenType, Formula) parser, Token)
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
            int paramId = convInt(param.value);
            return new Formula(new Param(paramId));
        }
        assert(false);
    }
}

class BinaryOperatorParselet : InfixParselet!(TokenType, Formula)
{
private:
    int _precedence;

public:
    this(int precedence) {
      _precedence = precedence;
    }

    Formula parse(Parser!(TokenType, Formula) parser, Formula left, Token token)
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

class GroupParselet : PrefixParselet!(TokenType, Formula)
{
public:
    Formula parse(Parser!(TokenType, Formula) parser, Token token) {
        Formula right = parser.parseExpression();
        parser.consume(TokenType.RightParen);
        return right;
    }
}

class NumberParselet : PrefixParselet!(TokenType, Formula)
{
public:
    Formula parse(Parser!(TokenType, Formula) parser, Token token) {
      float v = convFloat(token.value);
      return new Formula(new Number(v));
    }
}

class ExpressionParser : Parser!(TokenType, Formula)
{
public:
    this(ExpressionLexer lexer) {
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
}
