/*
    License Applicability. Except to the extent portions of this file are
    made subject to an alternative license as permitted in the SGI Free
    Software License B, Version 1.1 (the "License"), the contents of this
    file are subject only to the provisions of the License. You may not use
    this file except in compliance with the License. You may obtain a copy
    of the License at Silicon Graphics, Inc., attn: Legal Services, 1600
    Amphitheatre Parkway, Mountain View, CA 94043-1351, or at:

    http://oss.sgi.com/projects/FreeB

    Note that, as provided in the License, the Software is distributed on an
    "AS IS" basis, with ALL EXPRESS AND IMPLIED WARRANTIES AND CONDITIONS
    DISCLAIMED, INCLUDING, WITHOUT LIMITATION, ANY IMPLIED WARRANTIES AND
    CONDITIONS OF MERCHANTABILITY, SATISFACTORY QUALITY, FITNESS FOR A
    PARTICULAR PURPOSE, AND NON-INFRINGEMENT.

    Original Code. The Original Code is: OpenGL Sample Implementation,
    Version 1.2.1, released January 26, 2000, developed by Silicon Graphics,
    Inc. The Original Code is Copyright (c) 1991-2000 Silicon Graphics, Inc.
    Copyright in any portions created by third parties is as indicated
    elsewhere herein. All Rights Reserved.

    Additional Notice Provisions: This software was created using the
    OpenGL(R) version 1.2.1 Sample Implementation published by SGI, but has
    not been independently verified as being compliant with the OpenGL(R)
    version 1.2.1 Specification.
*/

import bindbc.opengl;
import std.math;

static void __gluMakeIdentityf(GLfloat* m)
{
    m[0+4*0] = 1; m[0+4*1] = 0; m[0+4*2] = 0; m[0+4*3] = 0;
    m[1+4*0] = 0; m[1+4*1] = 1; m[1+4*2] = 0; m[1+4*3] = 0;
    m[2+4*0] = 0; m[2+4*1] = 0; m[2+4*2] = 1; m[2+4*3] = 0;
    m[3+4*0] = 0; m[3+4*1] = 0; m[3+4*2] = 0; m[3+4*3] = 1;
}

static void normalize(ref float[3] v)
{
    float r;

    r = sqrt( v[0]*v[0] + v[1]*v[1] + v[2]*v[2] );
    if (r == 0.0) return;

    v[0] /= r;
    v[1] /= r;
    v[2] /= r;
}

static void cross(float[3] v1, float[3] v2, out float[3] result)
{
    result[0] = v1[1]*v2[2] - v1[2]*v2[1];
    result[1] = v1[2]*v2[0] - v1[0]*v2[2];
    result[2] = v1[0]*v2[1] - v1[1]*v2[0];
}

void gluLookAt(GLdouble eyex, GLdouble eyey, GLdouble eyez, GLdouble centerx,
	  GLdouble centery, GLdouble centerz, GLdouble upx, GLdouble upy,
	  GLdouble upz)
{
    int i;
    float[3] forward, side, up;
    GLfloat[4][4] m;

    forward[0] = centerx - eyex;
    forward[1] = centery - eyey;
    forward[2] = centerz - eyez;

    up[0] = upx;
    up[1] = upy;
    up[2] = upz;

    normalize(forward);

    /* Side = forward x up */
    cross(forward, up, side);
    normalize(side);

    /* Recompute up as: up = side x forward */
    cross(side, forward, up);

    __gluMakeIdentityf(&m[0][0]);
    m[0][0] = side[0];
    m[1][0] = side[1];
    m[2][0] = side[2];

    m[0][1] = up[0];
    m[1][1] = up[1];
    m[2][1] = up[2];

    m[0][2] = -forward[0];
    m[1][2] = -forward[1];
    m[2][2] = -forward[2];

    glMultMatrixf(&m[0][0]);
    glTranslated(-eyex, -eyey, -eyez);
}