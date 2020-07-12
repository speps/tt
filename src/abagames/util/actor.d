/*
 * $Id: actor.d,v 1.2 2005/01/01 12:40:28 kenta Exp $
 *
 * Copyright 2004 Kenta Cho. Some rights reserved.
 */
module abagames.util.actor;

/**
 * Actor in the game that has the interface to move and draw.
 */
public class Actor {
 private:
  bool _exists;

  public bool exists() {
    return _exists;
  }

  public bool exists(bool value) {
    return _exists = value;
  }

  public abstract void init(Object[] args);
  public abstract void move();
  public abstract void draw();
}

/**
 * Object pooling for actors.
 */
public class ActorPool(T) {
 public:
  T[] actor;
 protected:
  int actorIdx = 0;
 private:

  public this() {}

  public this(int n, Object[] args = null) {
    createActors(n, args);
  }

  protected void createActors(int n, Object[] args = null) {
    actor = new T[n];
    foreach (ref T a; actor) {
      a = new T;
      a.exists = false;
      a.init(args);
    }
    actorIdx = 0;
  }

  public T getInstance() {
    for (int i = 0; i < cast(int)actor.length; i++) {
      actorIdx--;
      if (actorIdx < 0)
        actorIdx = cast(int)actor.length - 1;
      if (!actor[actorIdx].exists) 
        return actor[actorIdx];
    }
    return null;
  }

  public T getInstanceForced() {
    actorIdx--;
    if (actorIdx < 0)
      actorIdx = cast(int)actor.length - 1;
    return actor[actorIdx];
  }

  public T[] getMultipleInstances(int n) {
    T[] rsl;
    for (int i = 0; i < n; i++) {
      T inst = getInstance();
      if (!inst) {
        foreach (T r; rsl)
          r.exists = false;
        return null;
      }
      inst.exists = true;
      rsl ~= inst;
    }
    foreach (T r; rsl)
      r.exists = false;
    return rsl;
  }
  
  public void move() {
    foreach (T ac; actor)
      if (ac.exists)
        ac.move();
  }

  public void draw() {
    foreach (T ac; actor)
      if (ac.exists)
        ac.draw();
  }

  public void clear() {
    foreach (T ac; actor)
      ac.exists = false;
    actorIdx = 0;
  }
}
