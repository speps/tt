/*
 * $Id: vector.d,v 1.1.1.1 2004/11/10 13:45:22 kenta Exp $
 *
 * Copyright 2004 Kenta Cho. Some rights reserved.
 */
module abagames.util.vector;

import abagames.util.conv;
import abagames.util.math;

/**
 * Vector.
 */
public class Vector {
 public:
  float x, y;
 private:

  public this() {
    x = y = 0;
  }

  public this(float x, float y) {
    this.x = x;
    this.y = y;
  }

  public float opBinary(string op)(Vector v) if (op == "*") {
    return x * v.x + y * v.y;
  }

  public Vector getElement(Vector v) {
    Vector rsl;
    float ll = v * v;
    if (ll != 0) {
      float mag = this * v;
      rsl.x = mag * v.x / ll;
      rsl.y = mag * v.y / ll;
    } else {
      rsl.x = rsl.y = 0; 
    }
    return rsl;
  }

  public void opOpAssign(string op)(Vector v) if (op == "+" || op == "-") {
    mixin("x" ~ op ~ "=v.x;");
    mixin("y" ~ op ~ "=v.y;");
  }

  public void opOpAssign(string op)(float a) if (op == "*" || op == "/") {
    mixin("x" ~ op ~ "=a;");
    mixin("y" ~ op ~ "=a;");
  }

  public float checkSide(Vector pos1, Vector pos2) {
    float xo = pos2.x - pos1.x;
    float yo = pos2.y - pos1.y;
    if (xo == 0) {
      if (yo == 0)
	return 0;
      if (yo > 0)
	return x - pos1.x;
      else
	return pos1.x - x;
    } else if (yo == 0) {
      if (xo > 0)
	return pos1.y - y;
      else
	return y - pos1.y;
    } else {
      if (xo * yo > 0)
	return (x - pos1.x) / xo - (y - pos1.y) / yo;
      else
	return -(x - pos1.x) / xo + (y - pos1.y) / yo;
    }
  }

  public float checkSide(Vector pos1, Vector pos2, Vector ofs) {
    float xo = pos2.x - pos1.x;
    float yo = pos2.y - pos1.y;
    float mx = x + ofs.x;
    float my = y + ofs.y;
    if (xo == 0) {
      if (yo == 0)
	return 0;
      if (yo > 0)
	return mx - pos1.x;
      else
	return pos1.x - mx;
    } else if (yo == 0) {
      if (xo > 0)
	return pos1.y - my;
      else
	return my - pos1.y;
    } else {
      if (xo * yo > 0)
	return (mx - pos1.x) / xo - (my - pos1.y) / yo;
      else
	return -(mx - pos1.x) / xo + (my - pos1.y) / yo;
    }
  }

  public bool checkCross(Vector p, Vector p1, Vector p2, float width) {
    float a1x, a1y, a2x, a2y;
    if (x < p.x) {
      a1x = x - width; a2x = p.x + width;
    } else {
      a1x = p.x - width; a2x = x + width;
    }
    if (y < p.y) {
      a1y = y - width; a2y = p.y + width;
    } else {
      a1y = p.y - width; a2y = y + width;
    }
    float b1x, b1y, b2x, b2y;
    if (p2.y < p1.y) {
      b1y = p2.y - width; b2y = p1.y + width;
    } else {
      b1y = p1.y - width; b2y = p2.y + width;
    }
    if (a2y >= b1y && b2y >= a1y) {
      if (p2.x < p1.x) {
        b1x = p2.x - width; b2x = p1.x + width;
      } else {
        b1x = p1.x - width; b2x = p2.x + width;
      }
      if (a2x >= b1x && b2x >= a1x) {
        float a = y - p.y;
        float b = p.x - x;
        float c = p.x * y - p.y * x;
        float d = p2.y - p1.y;
        float e = p1.x - p2.x;
        float f = p1.x * p2.y - p1.y * p2.x;
        float dnm = b * d - a * e;
        if (dnm != 0) {
          float x = (b*f - c*e) / dnm;
          float y = (c*d - a*f) / dnm;
          if (a1x <= x && x <= a2x && a1y <= y && y <= a2y &&
              b1x <= x && x <= b2x && b1y <= y && y <= b2y)
            return true;
        }
      }
    }
    return false;
  }

  public bool checkHitDist(Vector p, Vector pp, float dist) {
    float bmvx, bmvy, inaa;
    bmvx = pp.x;
    bmvy = pp.y;
    bmvx -= p.x;
    bmvy -= p.y;
    inaa = bmvx * bmvx + bmvy * bmvy;
    if (inaa > 0.00001) {
      float sofsx, sofsy, inab, hd;
      sofsx = x;
      sofsy = y;
      sofsx -= p.x;
      sofsy -= p.y;
      inab = bmvx * sofsx + bmvy * sofsy;
      if (inab >= 0 && inab <= inaa) {
	hd = sofsx * sofsx + sofsy * sofsy - inab * inab / inaa;
	if (hd >= 0 && hd <= dist)
	  return true;
      }
    }
    return false;
  }
  
  public float size() {
    return sqrt(x * x + y * y);
  }

  public float dist(Vector v) {
    float ax = fabs(x - v.x);
    float ay = fabs(y - v.y);
    if (ax > ay)
      return ax + ay / 2;
    else
      return ay + ax / 2;
  }

  /*public bool contains(Vector p) {
    if (p.x >= -x && p.x <= x && p.y >= -y && p.y <= y)
      return true;
    else
      return false;
  }*/
}

public class Vector3 {
 public:
  float x, y, z;

  public this() {
    x = y = z = 0;
  }

  public this(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }

  public void rollX(float d) {
    float ty = y * cos(d) - z * sin(d);
    z = y * sin(d) + z * cos(d);
    y = ty;
  }

  public void rollY(float d) {
    float tx = x * cos(d) - z * sin(d);
    z = x * sin(d) + z * cos(d);
    x = tx;
  }

  public void rollZ(float d) {
    float tx = x * cos(d) - y * sin(d);
    y = x * sin(d) + y * cos(d);
    x = tx;
  }

  public void blend(Vector3 v1, Vector3 v2, float ratio) {
    x = v1.x * ratio + v2.x * (1 - ratio);
    y = v1.y * ratio + v2.y * (1 - ratio);
    z = v1.z * ratio + v2.z * (1 - ratio);
  }

  public void opOpAssign(string op)(Vector3 v) if (op == "+" || op == "-") {
    mixin("x" ~ op ~ "=v.x;");
    mixin("y" ~ op ~ "=v.y;");
    mixin("z" ~ op ~ "=v.z;");
  }

  public void opOpAssign(string op)(float a) if (op == "*" || op == "/") {
    mixin("x" ~ op ~ "=a;");
    mixin("y" ~ op ~ "=a;");
    mixin("z" ~ op ~ "=a;");
  }
}
