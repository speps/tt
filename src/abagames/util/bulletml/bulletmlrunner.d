module abagames.util.bulletml.bulletmlrunner;

import std.math;
import abagames.util.bulletml.bulletmlnode;
import abagames.util.bulletml.bulletmlparser;

class LinearFunc(X_, Y_) {
	this(X_ firstX, X_ lastX, Y_ firstY, Y_ lastY) {
		firstX_ = firstX;
    lastX_ = lastX;
	  firstY_ = firstY;
    lastY_ = lastY;
		gradient_ = (lastY-firstY)/(lastX-firstX);
  }

	Y_ getValue(X_ x) {
		return firstY_ + gradient_ * (x-firstX_);
	}

	bool isLast(X_ x) {
		return x >= lastX_;
	}

	Y_ getLast() {
		return lastY_;
	}

protected:
	X_ firstX_, lastX_;
	Y_ firstY_, lastY_;
	Y_ gradient_;
}

struct Validatable(C_) {
public:
	@property bool isValidate() { return isValidate_; }

	void enValidate() { isValidate_ = true; }
	void disValidate() { isValidate_ = false; }

	@property C_ value() { return val_; }
  @property void value(C_ val) {
    isValidate_ = true;
    val_ = val;
  }

private:
	C_ val_;
	bool isValidate_;
};

alias BulletMLParameters = double[];

class BulletMLState {
  this(BulletMLParser bulletml, BulletMLNode[] node, BulletMLParameters parameters) {
    _bulletml = bulletml;
    _node = node;
    _parameters = parameters;
  }

  @property BulletMLParser bulletml() { return _bulletml; }
  @property BulletMLNode[] node() { return _node; }
  @property BulletMLParameters parameters() { return _parameters; }

private:
  BulletMLParser _bulletml;
  BulletMLNode[] _node;
  BulletMLParameters _parameters;
}

class BulletMLRunner {
  this(BulletMLParser parser) {
    _parser = parser;
    foreach (action; parser.topActions) {
      auto state = new BulletMLState(parser, [action], []);
      _impl ~= new BulletMLRunnerImpl(state, this);
    }
  }

  this(BulletMLState state) {
    _parser = state.bulletml;
    _impl ~= new BulletMLRunnerImpl(state, this);
  }

  @property const(BulletMLParser) parser() { return _parser; }

  void run() {
    foreach (impl; _impl) {
      impl.run();
    }
  }

  bool isEnd() {
    foreach (impl; _impl) {
      if (impl.isEnd) {
        return true;
      }
    }
    return false;
  }

  static double function(BulletMLRunner r) getBulletDirection;
  static double function(BulletMLRunner r) getAimDirection;
  static double function(BulletMLRunner r) getBulletSpeed;
  static double function(BulletMLRunner r) getDefaultSpeed;
  static double function(BulletMLRunner r) getRank;
  static void function(BulletMLRunner r, double d, double s) createSimpleBullet;
  static void function(BulletMLRunner r, BulletMLState state, double d, double s) createBullet;
  static int function(BulletMLRunner r) getTurn;
  static void function(BulletMLRunner r) doVanish;
  static void function(BulletMLRunner r, double d) doChangeDirection;
  static void function(BulletMLRunner r, double s) doChangeSpeed;
  static void function(BulletMLRunner r, double sx) doAccelX;
  static void function(BulletMLRunner r, double sy) doAccelY;
  static double function(BulletMLRunner r) getBulletSpeedX;
  static double function(BulletMLRunner r) getBulletSpeedY;
  static double function(BulletMLRunner r) getRand;

private:
  const BulletMLParser _parser;
  BulletMLRunnerImpl[] _impl;
}

private class BulletMLRunnerImpl {
  this(BulletMLState state, BulletMLRunner runner) {
    _commandMap = [
	    &runBullet,
	    &runAction,
	    &runFire,
	    &runChangeDirection,
	    &runChangeSpeed,
	    &runAccel,
	    &runWait,
	    &runRepeat,
	    &runBulletRef,
	    &runActionRef,
	    &runFireRef,
	    &runVanish
    ];
    _bulletml = state.bulletml;
    _node = state.node;
    _parameters = state.parameters;
    _runner = runner;
    _act = _node[0];
    foreach (child; _node) {
      child.parent = null;
    }
    _actTurn = -1;
    _actIte = 0;
    _end = false;
  }

  void run() {
    if (isEnd) {
      return;
    }

    changes();
    
    _endTurn = BulletMLRunner.getTurn(_runner);

    if (_act is null) {
      if (!isTurnEnd()) {
        if (_changeDir is null && _changeSpeed is null && _accelx is null && _accely is null) {
          _end = true;
        }
      }
      return;
    }

    _act = _node[_actIte];
    if (_actTurn == -1) {
      _actTurn = BulletMLRunner.getTurn(_runner);
    }

    runSub();

    if (_act is null) {
      _actIte++;
      if (_node.length != _actIte) {
        _act = _node[_actIte];
      }
    }
    else {
      _node[_actIte] = _act;
    }
  }

  @property bool isEnd() { return _end; }

	void calcChangeDirection(double direction, int term, bool seq) {
    int finalTurn = _actTurn + term;
    double dirFirst = BulletMLRunner.getBulletDirection(_runner);

    if (seq) {
      _changeDir = new LinearFunc!(int, double)(_actTurn, finalTurn, dirFirst, dirFirst + direction * term);
    }
    else {
      double dirSpace;

      double dirSpace1 = direction - dirFirst;
      double dirSpace2;
      if (dirSpace1 > 0) dirSpace2 = dirSpace1 - 360;
      else dirSpace2 = dirSpace1 + 360;
      if (abs(dirSpace1) < abs(dirSpace2)) dirSpace = dirSpace1;
      else dirSpace = dirSpace2;

      _changeDir = new LinearFunc!(int, double)(_actTurn, finalTurn, dirFirst, dirFirst + dirSpace);
    }
  }
	void calcChangeSpeed(double speed, int term) {
    int finalTurn = _actTurn + term;
	  double spdFirst = BulletMLRunner.getBulletSpeed(_runner);
    _changeSpeed = new LinearFunc!(int, double)(_actTurn, finalTurn, spdFirst, speed);
  }
	void calcAccelX(double vertical, int term, Type type) {
    int finalTurn = _actTurn + term;

    double firstSpd = BulletMLRunner.getBulletSpeedX(_runner);
    double finalSpd;

    if (type == Type.sequence) {
      finalSpd = firstSpd + vertical * term;
    }
    else if (type == Type.relative) {
      finalSpd = firstSpd + vertical;
    }
    else {
      finalSpd = vertical;
    }

    _accelx = new LinearFunc!(int, double)(_actTurn, finalTurn, firstSpd, finalSpd);
  }
	void calcAccelY(double horizontal, int term, Type type) {
    int finalTurn = _actTurn + term;

    double firstSpd = BulletMLRunner.getBulletSpeedY(_runner);
    double finalSpd;

    if (type == Type.sequence) {
      finalSpd = firstSpd + horizontal * term;
    }
    else if (type == Type.relative) {
      finalSpd = firstSpd + horizontal;
    }
    else {
      finalSpd = horizontal;
    }

    _accely = new LinearFunc!(int, double)(_actTurn, finalTurn, firstSpd, finalSpd);
  }

private:
  void runBullet() {
    setSpeed();
    setDirection();
    if (!_spd.isValidate()) {
      double spd = BulletMLRunner.getDefaultSpeed(_runner);
      _prevSpd.value = spd;
      _spd.value = spd;
    }
    if (!_dir.isValidate()) {
      double dir = BulletMLRunner.getAimDirection(_runner);
      _prevDir.value = dir;
      _dir.value = dir;
    }
    if (_act.getChild(Name.action) is null && _act.getChild(Name.actionRef) is null) {
      BulletMLRunner.createSimpleBullet(_runner, _dir.value, _spd.value);
    }
    else {
      BulletMLNode[] acts;
      acts ~= _act.getChildren(Name.action);
      acts ~= _act.getChildren(Name.actionRef);
      auto state = new BulletMLState(_bulletml, acts, _parameters);
      BulletMLRunner.createBullet(_runner, state, _dir.value, _spd.value);
    }
    _act = null;
  }
  void runAction() {
    if (_act.children.length == 0) {
      _act = null;
    } else {
      _act = _act.children[0];
    }
  }
  void runFire() {
    shotInit();

    setSpeed();
    setDirection();

    auto bullet = _act.getChild(Name.bullet);
    if (bullet is null) {
      bullet = _act.getChild(Name.bulletRef);
    }
    assert(bullet !is null);

	  _act = bullet;
  }
  void runWait() {
    int frame = cast(int)getNumberContents(_act);
    doWait(frame);
    _act = null;
  }
  void runRepeat() {
    auto times = _act.getChild(Name.times);
    if (times is null) {
      return;
    }

    int timesNum = cast(int)getNumberContents(times);

    auto action = _act.getChild(Name.action);
    if (action is null) {
      action = _act.getChild(Name.actionRef);
    }
    assert(action !is null);

    _repeatStack ~= new RepeatElem(0, timesNum, action);
    _act = action;
  }
  void runBulletRef() {
    auto prevParameters = _parameters;
    _parameters = getParameters();
    _refStack ~= RefElem(_act, prevParameters);
    _act = _bulletml.getBulletRef(_act.refID);
  }
  void runActionRef() {
    auto prevParameters = _parameters;
    _parameters = getParameters();
    _refStack ~= RefElem(_act, prevParameters);
    _act = _bulletml.getActionRef(_act.refID);
  }
  void runFireRef() {
    auto prevParameters = _parameters;
    _parameters = getParameters();
    _refStack ~= RefElem(_act, prevParameters);
    _act = _bulletml.getFireRef(_act.refID);
  }
  void runChangeDirection() {
    int term = cast(int)getNumberContents(_act.getChild(Name.term));
    auto dirNode = _act.getChild(Name.direction);

    double dir;
    if (dirNode.type != Type.sequence) {
      dir = getDirection(dirNode, false);
    } else {
      dir = getNumberContents(dirNode);
    }

    calcChangeDirection(dir, term, dirNode.type == Type.sequence);

    _act = null;
  }
  void runChangeSpeed() {
    int term = cast(int)getNumberContents(_act.getChild(Name.term));
    auto spdNode = _act.getChild(Name.speed);

    double spd;
    if (spdNode.type != Type.sequence) {
      spd = getSpeed(spdNode);
    } else {
      spd = getNumberContents(spdNode) * term + BulletMLRunner.getBulletSpeed(_runner);
    }

    calcChangeSpeed(spd, term);

    _act = null;
  }
  void runAccel() {
    int term = cast(int)getNumberContents(_act.getChild(Name.term));
    auto hnode = _act.getChild(Name.horizontal);
    auto vnode = _act.getChild(Name.vertical);

    if (_bulletml.isHorizontal) {
      if (vnode !is null) calcAccelX(getNumberContents(vnode), term, vnode.type);
      if (hnode !is null) calcAccelY(-getNumberContents(hnode), term, hnode.type);
    }
    else {
      if (hnode !is null) calcAccelX(getNumberContents(hnode), term, hnode.type);
      if (vnode !is null) calcAccelY(getNumberContents(vnode), term, vnode.type);
    }

    _act = null;
  }
  void runVanish() {
    BulletMLRunner.doVanish(_runner);
    _act = null;
  }

	void changes() {
    int now = BulletMLRunner.getTurn(_runner);

    if (_changeDir !is null) {
      if (_changeDir.isLast(now)) {
        BulletMLRunner.doChangeDirection(_runner, _changeDir.getLast());
        _changeDir = null;
      } else {
        BulletMLRunner.doChangeDirection(_runner, _changeDir.getValue(now));
      }
    }
    if (_changeSpeed !is null) {
      if (_changeSpeed.isLast(now)) {
        BulletMLRunner.doChangeSpeed(_runner, _changeSpeed.getLast());
        _changeSpeed = null;
      } else {
        BulletMLRunner.doChangeSpeed(_runner, _changeSpeed.getValue(now));
      }
    }
    if (_accelx !is null) {
      if (_accelx.isLast(now)) {
        BulletMLRunner.doAccelX(_runner, _accelx.getLast());
        _accelx = null;
      } else {
        BulletMLRunner.doAccelX(_runner, _accelx.getValue(now));
      }
    }
    if (_accely !is null) {
      if (_accely.isLast(now)) {
        BulletMLRunner.doAccelY(_runner, _accely.getLast());
        _accely = null;
      } else {
        BulletMLRunner.doAccelY(_runner, _accely.getValue(now));
      }
    }
  }
	void runSub() {
    while (_act !is null && !isTurnEnd()) {
      auto prev = _act;
      auto fp = _commandMap[cast(int)_act.name];
      fp();

      if (_act is null && prev.parent !is null && prev.parent.name == Name.bulletml) {
        assert(_refStack.length > 0, _runner.parser.fileName);
        prev = _refStack[$-1].node;
        _parameters = _refStack[$-1].parameters;
        _refStack = _refStack[0..$-1];
      }

      if (_act is null) {
        _act = prev.getNext();
      }

      while (_act is null) {
        if (prev.parent !is null && prev.parent.name == Name.repeat) {
          auto rep = _repeatStack[$-1];
          rep.ite++;
          if (rep.ite < rep.end) {
            _act = rep.action;
            break;
          }
          else {
            _repeatStack = _repeatStack[0..$-1];
          }
        }

        _act = prev.parent;
        if (_act is null) {
          break;
        }

        prev = _act;

        if (prev.parent !is null && prev.parent.name == Name.bulletml) {
          assert(_refStack.length > 0, _runner.parser.fileName);
          prev = _act = _refStack[$-1].node;
          _parameters = _refStack[$-1].parameters;
          _refStack = _refStack[0..$-1];
        }

        _act = _act.getNext();
      }
    }
  }

	bool isTurnEnd() {
    return isEnd || _actTurn > _endTurn;
  }
	void doWait(int frame) {
    if (frame > 0) {
      _actTurn += frame;
    }
  }

  void setDirection() {
    auto dir = _act.getChild(Name.direction);
    if (dir !is null) {
      _dir.value = getDirection(dir);
    }
  }
  void setSpeed() {
    auto spd = _act.getChild(Name.speed);
    if (spd !is null) {
      _spd.value = getSpeed(spd);
    }
  }

  void shotInit() {
    _spd.disValidate();
    _dir.disValidate();
  }

  double getNumberContents(BulletMLNode node) {
    return node.getValue(_runner, _parameters);
  }

  BulletMLParameters getParameters() {
    BulletMLParameters parameters;
    foreach (idx, child; _act.children) {
      if (child.name != Name.param) {
        continue;
      }
      if (parameters.length == 0) {
        parameters ~= 0;
      }
      parameters ~= getNumberContents(child);
    }
    return parameters;
  }
  double getSpeed(BulletMLNode spdNode) {
    double spd = getNumberContents(spdNode);
    if (spdNode.type != Type.none) {
      if (spdNode.type == Type.relative) {
        spd += BulletMLRunner.getBulletSpeed(_runner);
      }
      else if (spdNode.type == Type.sequence) {
        if (!_prevSpd.isValidate()) {
          spd = 1;
        } else {
          spd += _prevSpd.value;
        }
      }
    }
    _prevSpd.value = spd;
    return spd;
  }
	double getDirection(BulletMLNode dirNode, bool prevChange = true) {
    bool isDefault = true;
    double dir = getNumberContents(dirNode);
    if (dirNode.type != Type.none) {
      isDefault = false;
      if (dirNode.type == Type.absolute) {
        if (_bulletml.isHorizontal) {
          dir -= 90;
        }
      }
      else if (dirNode.type == Type.relative) {
        dir += BulletMLRunner.getBulletDirection(_runner);
      }
      else if (dirNode.type == Type.sequence) {
        if (!_prevDir.isValidate()) {
          dir = 0;
          isDefault = true;
        } else {
          dir += _prevDir.value;
        }
      }
      else {
        isDefault = true;
      }
    }
    if (isDefault) {
      dir += BulletMLRunner.getAimDirection(_runner);
    }

    while (dir > 360) dir -= 360;
    while (dir < 0) dir += 360;

    if (prevChange) {
      _prevDir.value = dir;
    }

    return dir;
  }

private:
  alias Method = void delegate();
  Method[] _commandMap;
  BulletMLParser _bulletml;
  BulletMLNode[] _node;
  BulletMLParameters _parameters;
  BulletMLRunner _runner;
  BulletMLNode _act;
  int _actTurn;
	int[] _actTurns;
	int _endTurn;
	int _actIte;
	bool _end;

  LinearFunc!(int, double) _changeDir;
  LinearFunc!(int, double) _changeSpeed;
  LinearFunc!(int, double) _accelx;
  LinearFunc!(int, double) _accely;

  Validatable!double _spd, _dir, _prevSpd, _prevDir;

	class RepeatElem {
		this(int i, int e, BulletMLNode a) {
      ite = i;
      end = e;
      action = a;
    }
		int ite, end;
		BulletMLNode action;
	}
  RepeatElem[] _repeatStack;

  struct RefElem {
    this(BulletMLNode n, BulletMLParameters p) {
      node = n;
      parameters = p;
    }
    BulletMLNode node;
    BulletMLParameters parameters;
  }
  RefElem[] _refStack;
}
