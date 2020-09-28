module abagames.util.bulletml.bulletmlparser;

import abagames.util.logger;
import abagames.util.bulletml.bulletmlnode;
import abagames.util.bulletml.idpool;
import abagames.util.bulletml.xml;
import std.file;
import std.conv;
import std.stdio;

class BulletMLParser {
  this(string fileName) {
    _fileName = fileName;
    _xml = parseXML(std.file.readText(fileName));
    _topActions = [];
    _isHorizontal = false;
  }

  void parse() {
    auto idPool = new IDPool();
    BulletMLNode curNode;
    foreach (element; _xml) {
      if (element.type == ElementType.TagOpen) {
        auto node = addContent(element.value);
        if (curNode !is null) {
          curNode.addChild(node);
        }
        curNode = node;
        if (node.name == Name.bulletml) {
          foreach (attr; element.attributes) {
            if (attr.value == "horizontal") {
              _isHorizontal = true;
            }
          }
        }
        else {
          foreach (attr; element.attributes) {
            addAttribute(idPool, node, attr.name, attr.value);
          }
        }
      }
      else if (element.type == ElementType.TagClose) {
        if (curNode) {
          curNode = curNode.parent;
        }
      }
      else if (element.type == ElementType.Text) {
        if (curNode) {
          curNode.setValue(element.value);
        }
      }
    }

    // dump(0, _bulletml);
  }

  @property string fileName() const { return _fileName; }

  @property bool isHorizontal() { return _isHorizontal; }
  @property BulletMLNode[] topActions() { return _topActions; }

  BulletMLNode getBulletRef(int id) {
    return _bulletMap[id];
  }
  BulletMLNode getActionRef(int id) {
    return _actionMap[id];
  }
  BulletMLNode getFireRef(int id) {
    return _fireMap[id];
  }

private:
  void dump(int level, BulletMLNode node) const {
    if (level == 0) {
      writeln(fileName);
    }
    for (int i = 0; i < level; i++) {
      write("\t");
    }
    writeln(node.name, " ", node.type, " ", node.refID, " ", node.getValueStr());
    foreach (child; node.children) {
      dump(level + 1, child);
    }
  }

  BulletMLNode addContent(string name) {
    if (name == to!string(Name.bulletml)) {
      _bulletml = new BulletMLNode(name);
      return _bulletml;
    }
    assert(_bulletml !is null);
    return new BulletMLNode(name);
  }

  void addAttribute(IDPool idPool, BulletMLNode node, string key, string val) {
    if (key == "type") {
      node.type = to!Type(val);
    }
    else if (key == "label") {
      Name domain = node.name;
      if (domain == Name.bulletRef) {
        domain = Name.bullet;
      } else if (domain == Name.actionRef) {
        domain = Name.action;
      } else if (domain == Name.fireRef) {
        domain = Name.fire;
      }
      int id = idPool.getID(domain, val);
      if (node.name == Name.bullet) {
        _bulletMap[id] = node;
      }
      else if (node.name == Name.action) {
        _actionMap[id] = node;
      }
      else if (node.name == Name.fire) {
        _fireMap[id] = node;
      }
      else if (node.name == Name.bulletRef || node.name == Name.actionRef || node.name == Name.fireRef) {
        node.refID = id;
      }
      else {
        assert(false);
      }
      if (node.name == Name.action && val.length >= 3 && val[0] == 't' && val[1] == 'o' && val[2] == 'p') {
        _topActions ~= node;
      }
    }
  }

  string _fileName;
  Element[] _xml;

  BulletMLNode _bulletml;
  BulletMLNode[int] _bulletMap;
  BulletMLNode[int] _actionMap;
  BulletMLNode[int] _fireMap;
  BulletMLNode[] _topActions;
  bool _isHorizontal;
}
