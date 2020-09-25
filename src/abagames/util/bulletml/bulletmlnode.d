module abagames.util.bulletml.bulletmlnode;

import std.conv;

import abagames.util.bulletml.bulletmlrunner;
import abagames.util.bulletml.formula;

enum Type {
  none,
  aim,
  absolute,
  relative,
  sequence,
  typeSize
}

enum Name {
  bullet,
  action,
  fire,
  changeDirection,
  changeSpeed,
  accel,
  wait,
  repeat,
  bulletRef,
  actionRef,
  fireRef,
  vanish,
  horizontal,
  vertical,
  term,
  times,
  direction,
  speed,
  param,
  bulletml,
  nameSize
}

class BulletMLNode {

  this(string name) {
    _name = to!Name(name);
    _type = Type.none;
    _refID = 0;
  }

  @property BulletMLNode parent() { return _parent; }
  @property void parent(BulletMLNode p) { _parent = p; }

  @property Name name() const { return _name; }

  @property Type type() const { return _type; }
  @property void type(Type t) { _type = t; }

  @property int refID() const { return _refID; }
  @property void refID(int id) { _refID = id; }

  @property BulletMLNode[] children() { return _children; }

  void addChild(BulletMLNode node) {
    node.parent = this;
    _children ~= node;
  }

  BulletMLNode getChild(Name name) {
    foreach (child; _children) {
      if (child._name == name) {
        return child;
      }
    }
    return null;
  }

  BulletMLNode[] getChildren(Name name) {
    BulletMLNode[] result;
    foreach (child; _children) {
      if (child._name == name) {
        result ~= child;
      }
    }
    return result;
  }

  BulletMLNode getNext() {
    if (parent !is null) {
      foreach (idx, child; parent.children) {
        if (child == this && (idx + 1) < parent.children.length) {
          return parent.children[idx + 1];
        }
      }
    }
    return null;
  }

  string getValueStr() const { return _valueStr; }
  double getValue(BulletMLRunner runner, BulletMLParameters parameters) const {
    return _value.getValue(Context(runner, parameters));
  }
  void setValue(string s) {
    _valueStr = s;
    _value = calc(s);
  }

private:
  BulletMLNode[] _children;
  BulletMLNode _parent;

  Name _name;
  Type _type;
  int _refID;
  string _valueStr;
  Formula _value;
}
