module abagames.util.bulletml.idpool;

import abagames.util.bulletml.bulletmlnode;

class IDPool {
  this() {
    _maxMap[Name.bullet] = 0;
    _maxMap[Name.action] = 0;
    _maxMap[Name.fire] = 0;
  }

  int getID(Name domain, string key) {
    int* id = !(domain in _map) ? null : key in _map[domain];
    if (id is null) {
      int newID = _maxMap[domain]++;
      _map[domain][key] = newID;
      return newID;
    }
    return *id;
  }

private:
  int[string][Name] _map;
  int[Name] _maxMap;
}