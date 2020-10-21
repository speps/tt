/*
 * $Id: recordablepad.d,v 1.1 2005/01/01 12:40:28 kenta Exp $
 *
 * Copyright 2004 Kenta Cho. Some rights reserved.
 */
module abagames.util.sdl.recordablepad;

import std.bitmanip;

import abagames.util.bytebuffer;
import abagames.util.iterator;
import abagames.util.sdl.input;
import abagames.util.sdl.pad;

/**
 * Pad that can record an input for a replay.
 */
public class RecordablePad: Pad {
 public:
  static const int REPLAY_END = -1;
  PadRecord padRecord;
 private:

  public this(InputBackend backend) {
    super(backend);
  }

  public void startRecord() {
    padRecord = new PadRecord;
    padRecord.clear();
  }

  public void record() {
    padRecord.add(getRecordState());
  }

  public void startReplay(PadRecord pr) {
    padRecord = pr;
    padRecord.reset();
  }

  public int replay() {
    if (!padRecord.hasNext())
      return REPLAY_END;
    else
      return padRecord.next();
  }
}

public class PadRecord {
 private:
  struct Record {
    int series;
    int data;
  };
  Record[] record;
  int idx, series;

  public void clear() {
    record = null;
  }

  public void add(int d) {
    if (record && record[record.length - 1].data == d) {
      record[record.length - 1].series++;
    } else {
      Record r;
      r.series = 1;
      r.data = d;
      record ~= r;
    }
  }

  public void reset() {
    idx = 0;
    series = 0;
  }

  public bool hasNext() {
    if (idx >= record.length)
      return false;
    else
      return true;
  }

  public int next() {
    if (idx >= record.length)
      throw new Error("No more items");
    if (series <= 0)
      series = record[idx].series;
    int rsl = record[idx].data;
    series--;
    if (series <= 0)
      idx++;
    return rsl;
  }

  public void save(ByteBuffer buffer) {
    buffer.append!(int, Endian.littleEndian)(record.length);
    foreach (Record r; record) {
      buffer.append!(int, Endian.littleEndian)(r.series);
      buffer.append!(int, Endian.littleEndian)(r.data);
    }
  }

  public void load(ref ubyte[] buffer) {
    clear();
    int len = buffer.read!(int, Endian.littleEndian);
    for (int i = 0; i < len; i++) {
      Record r;
      r.series = buffer.read!(int, Endian.littleEndian);
      r.data = buffer.read!(int, Endian.littleEndian);
      record ~= r;
    }
  }
}
