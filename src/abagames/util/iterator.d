/*
 * $Id: iterator.d,v 1.2 2005/01/01 12:40:28 kenta Exp $
 *
 * Copyright 2004 Kenta Cho. Some rights reserved.
 */
module abagames.util.iterator;

/**
 * Simple iterator for array.
 */
public class ArrayIterator(T) {
 protected:
  T[] array;
  int idx;
 private:

  public this(T[] a) {
    array = a;
    idx = 0;
  }

  public bool hasNext() {
    if (idx >= array.length)
      return false;
    else
      return true;
  }

  public T next() {
    if (idx >= array.length)
      throw new Error("No more items");
    T result = array[idx];
    idx++;
    return result;
  }
}

alias ArrayIterator!(char[]) StringIterator;
