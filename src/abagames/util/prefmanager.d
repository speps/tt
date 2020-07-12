/*
 * $Id: prefmanager.d,v 1.1.1.1 2004/11/10 13:45:22 kenta Exp $
 *
 * Copyright 2004 Kenta Cho. Some rights reserved.
 */
module abagames.util.prefmanager;

/**
 * Save/load the preference(e.g. high-score).
 */
public interface PrefManager {
  public void save();
  public void load();
}
