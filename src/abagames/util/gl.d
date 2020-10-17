module abagames.util.gl;

import std.conv;
import std.math;
import std.stdio;
import bindbc.opengl;
import abagames.util.vector;

static class GL
{
  alias Matrix = float[16];
  static const Matrix Identity = [
    1, 0, 0, 0,
    0, 1, 0, 0,
    0, 0, 1, 0,
    0, 0, 0, 1,
  ];
  enum MatrixMode {
    ModelView,
    Projection,
  }

  static void normalize(ref float[3] v) {
    float r;

    r = sqrt(v[0]*v[0] + v[1]*v[1] + v[2]*v[2]);
    if (r == 0.0) return;

    v[0] /= r;
    v[1] /= r;
    v[2] /= r;
  }

  static void cross(float[3] v1, float[3] v2, out float[3] result) {
    result[0] = v1[1]*v2[2] - v1[2]*v2[1];
    result[1] = v1[2]*v2[0] - v1[0]*v2[2];
    result[2] = v1[0]*v2[1] - v1[1]*v2[0];
  }

version(GL_AllowDeprecated)
{
  static void init() {}

  static void matrixMode(MatrixMode mode) {
    glMatrixMode(mode);
  }

  static void loadIdentity() {
    glLoadIdentity();
  }

  static void pushMatrix() {
    glPushMatrix();
  }

  static void popMatrix() {
    glPopMatrix();
  }

  static void multMatrix(Matrix m) {
    glMultMatrixf(m.ptr);
  }

  static void translate(float x, float y, float z) {
    glTranslatef(x, y, z);
  }

  static void translate(Vector3 v) {
    translate(v.x, v.y, v.z);
  }

  static void rotate(float angle, float x, float y, float z) {
    glRotatef(angle, x, y, z);
  }

  static void scale(float x, float y, float z) {
    glScalef(x, y, z);
  }

  static void ortho(float left, float right, float bottom, float top, float near, float far) {
    glOrtho(left, right, bottom, top, near, far);
  }

  static void frustum(float left, float right, float bottom, float top, float near, float far) {
    glFrustum(left, right, bottom, top, near, far);
  }

  static void lookAt(float eyex, float eyey, float eyez, float centerx, float centery, float centerz, float upx, float upy, float upz) {
    int i;
    float[3] forward, side, up;

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

    Matrix m = Identity[];

    m[0+4*0] = side[0];
    m[0+4*1] = side[1];
    m[0+4*2] = side[2];

    m[1+4*0] = up[0];
    m[1+4*1] = up[1];
    m[1+4*2] = up[2];

    m[2+4*0] = -forward[0];
    m[2+4*1] = -forward[1];
    m[2+4*2] = -forward[2];

    GL.multMatrix(m);
    GL.translate(-eyex, -eyey, -eyez);
  }

  static void vertex(float x, float y, float z) {
    glVertex3f(x, y, z);
  }

  static void vertex(Vector3 v) {
    vertex(v.x, v.y, v.z);
  }

  static void color(float r, float g, float b, float a) {
    glColor4f(r, g, b, a);
  }

  static void viewport(int left, int right, int width, int height) {
    glViewport(left, right, width, height);
  }

  static void clearColor(float r, float g, float b, float a) {
    glClearColor(r, g, b, a);
  }

  static void clear(GLbitfield flag) {
    glClear(flag);
  }

  static void blendFunc(GLenum src, GLenum dest) {
    glBlendFunc(src, dest);
  }

  static void enable(GLenum flag) {
    glEnable(flag);
  }

  static void disable(GLenum flag) {
    glDisable(flag);
  }

  static void lineWidth(float w) {
    glLineWidth(w);
  }

  static void frameStart() {}
  static void frameEnd() {}

  static void begin(int primitiveType) {
    glBegin(primitiveType);
  }

  static void texCoord(float u, float v) {}

  static void end() {
    glEnd();
  }

  static const int QUADS = GL_QUADS;
}
else
{
  static const int QUADS = 0x0007;

private:
  struct MatrixState {
    static const int StackDepth = 16;
    Matrix[StackDepth] stack = [
      Identity[], Identity[], Identity[], Identity[],
      Identity[], Identity[], Identity[], Identity[],
      Identity[], Identity[], Identity[], Identity[],
      Identity[], Identity[], Identity[], Identity[],
    ];
    int stackIndex = 0;
  }
  static MatrixState[MatrixMode.max + 1] states;
  static MatrixMode currentMode = MatrixMode.ModelView;

  struct Vertex {
  align(1):
    float x, y, z;
    float r, g, b, a;
  }

version(GL_Batching) {
  static const int MaxNumVertices = 32768;
} else {
  static const int MaxNumVertices = 4096;
}

  static GLuint program;
  static GLint vertPositionLocation, vertColorLocation, projectionLocation, modelViewLocation;

  static int currentPrimitiveType = -1;
  static float[4] currentColor = [1, 1, 1, 1];

  static GLuint compileProgram(string vsSource, string fsSource) {
    char[1024] infoLog;
    GLsizei infoLogLength = 0;
    GLint status = 0;

    auto vsIndex = glCreateShader(GL_VERTEX_SHADER);
    {
      auto sourcePtr = cast(char*)vsSource.ptr;
      glShaderSource(vsIndex, 1, &sourcePtr, null);
      glCompileShader(vsIndex);
      glGetShaderiv(vsIndex, GL_COMPILE_STATUS, &status);
      if (status == 0) {
        glGetShaderInfoLog(vsIndex, infoLog.length, &infoLogLength, infoLog.ptr);
        assert(false, );
      }
    }

    auto fsIndex = glCreateShader(GL_FRAGMENT_SHADER);
    {
      auto sourcePtr = cast(char*)fsSource.ptr;
      glShaderSource(fsIndex, 1, &sourcePtr, null);
      glCompileShader(fsIndex);
      glGetShaderiv(fsIndex, GL_COMPILE_STATUS, &status);
      if (status == 0) {
        glGetShaderInfoLog(fsIndex, infoLog.length, &infoLogLength, infoLog.ptr);
        assert(false, infoLog[0..infoLogLength]);
      }
    }

    auto progIndex = glCreateProgram();
    {
      glAttachShader(progIndex, vsIndex);
      glAttachShader(progIndex, fsIndex);
      glLinkProgram(progIndex);

      {
        glGetProgramiv(progIndex, GL_LINK_STATUS, &status);
        if (status == 0) {
          glGetProgramInfoLog(progIndex, infoLog.length, &infoLogLength, infoLog.ptr);
          assert(false, infoLog[0..infoLogLength]);
        }
      }

      glValidateProgram(progIndex);

      {
        glGetProgramiv(progIndex, GL_VALIDATE_STATUS, &status);
        if (status == 0) {
          glGetProgramInfoLog(progIndex, infoLog.length, &infoLogLength, infoLog.ptr);
          assert(false, infoLog[0..infoLogLength]);
        }
      }
    }

    return progIndex;
  }

  static void createBuffer(ref GLuint arrayIndex, ref GLuint bufferIndex, Vertex[MaxNumVertices] buffer) {
    glGenVertexArrays(1, &arrayIndex);
    glBindVertexArray(arrayIndex);

    glGenBuffers(1, &bufferIndex);
    glBindBuffer(GL_ARRAY_BUFFER, bufferIndex);
    glBufferData(GL_ARRAY_BUFFER, buffer.sizeof, null, GL_STREAM_DRAW);

    glVertexAttribPointer(vertPositionLocation, 3, GL_FLOAT, GL_FALSE, 7 * float.sizeof, cast(void*)0);
    glVertexAttribPointer(vertColorLocation, 4, GL_FLOAT, GL_FALSE, 7 * float.sizeof, cast(void*)(3 * float.sizeof));

    glEnableVertexAttribArray(vertPositionLocation);
    glEnableVertexAttribArray(vertColorLocation);

    glBindVertexArray(0);
  }

  static Matrix mult(Matrix m1, Matrix m2) {
    Matrix r;
    for(int i = 0; i < 4; i++) {
        for(int j = 0; j < 4; j++) {
            r[j+4*i] =
              m1[0+4*i] * m2[j+4*0]
            + m1[1+4*i] * m2[j+4*1]
            + m1[2+4*i] * m2[j+4*2]
            + m1[3+4*i] * m2[j+4*3];
        }
    }
    return r;
  }

public:
  
  static void init() {
    program = compileProgram(
      `
        #version 120

        uniform mat4 projection; 
        uniform mat4 modelView;

        attribute vec3 vertPosition;
        attribute vec4 vertColor;
        varying vec4 fragColor;

        void main()
        {
          fragColor = vertColor;
          gl_Position = projection * modelView * vec4(vertPosition, 1.0);
        }
      `,
      `
        #version 120

        varying vec4 fragColor;

        void main()
        {
          gl_FragColor = fragColor;
        }
      `
    );

    projectionLocation = glGetUniformLocation(program, "projection");
    modelViewLocation = glGetUniformLocation(program, "modelView");

    vertPositionLocation = glGetAttribLocation(program, "vertPosition");
    vertColorLocation = glGetAttribLocation(program, "vertColor");

    glUseProgram(program);

    customInit();
  }

  static void matrixMode(MatrixMode mode) {
    currentMode = mode;
  }

  static void loadIdentity() {
    states[currentMode].stack[states[currentMode].stackIndex] = Identity[];
  }

  static void pushMatrix() {
    states[currentMode].stackIndex++;
    states[currentMode].stack[states[currentMode].stackIndex] = states[currentMode].stack[states[currentMode].stackIndex - 1];
    assert(states[currentMode].stackIndex < MatrixState.StackDepth);
  }

  static void popMatrix() {
    assert(states[currentMode].stackIndex > 0);
    states[currentMode].stackIndex--;
  }

  static void multMatrix(Matrix m) {
    states[currentMode].stack[states[currentMode].stackIndex] = mult(m, states[currentMode].stack[states[currentMode].stackIndex]);
  }

  static void translate(float x, float y, float z) {
    multMatrix([
      1, 0, 0, 0,
      0, 1, 0, 0,
      0, 0, 1, 0,
      x, y, z, 1,
    ]);
  }

  static void translate(Vector3 v) {
    translate(v.x, v.y, v.z);
  }

  static void rotate(float angle, float x, float y, float z) {
    float angleRad = PI * angle / 180.0f;
    float sina = sin(angleRad);
    float cosa = cos(angleRad);
    float oneMinusCosa = 1.0f - cosa;
    float nxsq = x * x;
    float nysq = y * y;
    float nzsq = z * z;

    Matrix mat = Identity[];
    mat[0] = nxsq + (1.0f - nxsq) * cosa;
    mat[4] = x * y * oneMinusCosa - z * sina;
    mat[8] = x * z * oneMinusCosa + y * sina;
    mat[1] = x * y * oneMinusCosa + z * sina;
    mat[5] = nysq + (1.0f - nysq) * cosa;
    mat[9] = y * z * oneMinusCosa - x * sina;
    mat[2] = x * z * oneMinusCosa - y * sina;
    mat[6] = y * z * oneMinusCosa + x * sina;
    mat[10] = nzsq + (1.0f - nzsq) * cosa;
    multMatrix(mat);
  }

  static void scale(float x, float y, float z) {
    multMatrix([
      x, 0, 0, 0,
      0, y, 0, 0,
      0, 0, z, 0,
      0, 0, 0, 1,
    ]);
  }

  static void ortho(float left, float right, float bottom, float top, float near, float far) {
    float dx = right - left;
    float dy = top - bottom;
    float dz = far - near;

    float tx = -(right + left) / dx;
    float ty = -(top + bottom) / dy;
    float tz = -(far + near) / dz;

    float sx = 2.0f / dx;
    float sy = 2.0f / dy;
    float sz = -2.0f / dz;

    Matrix mat = Identity[];
    mat[0] = sx;
    mat[5] = sy;
    mat[10] = sz;
    mat[12] = tx;
    mat[13] = ty;
    mat[14] = tz;
    multMatrix(mat);
  }

  static void frustum(float left, float right, float bottom, float top, float near, float far) {
    float dx = right - left;
    float dy = top - bottom;
    float dz = far - near;

    float a = (right + left) / dx;
    float b = (top + bottom) / dy;
    float c = -(far + near) / dz;
    float d = -2.0f * far * near / dz;

    Matrix mat = Identity[];
    mat[0] = 2.0f * near / dx;
    mat[5] = 2.0f * near / dy;
    mat[8] = a;
    mat[9] = b;
    mat[10] = c;
    mat[11] = -1.0f;
    mat[14] = d;
    mat[15] = 0;
    multMatrix(mat);
  }

  static void lookAt(float eyex, float eyey, float eyez, float centerx, float centery, float centerz, float upx, float upy, float upz) {
    int i;
    float[3] forward, side, up;

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

    Matrix m = Identity[];

    m[0+4*0] = side[0];
    m[0+4*1] = side[1];
    m[0+4*2] = side[2];

    m[1+4*0] = up[0];
    m[1+4*1] = up[1];
    m[1+4*2] = up[2];

    m[2+4*0] = -forward[0];
    m[2+4*1] = -forward[1];
    m[2+4*2] = -forward[2];

    GL.multMatrix(m);
    GL.translate(-eyex, -eyey, -eyez);
  }

  static Matrix getMatrix(MatrixMode mode) {
    return states[mode].stack[states[mode].stackIndex];
  }

  static Vertex transform(float x, float y, float z) {
    Matrix c = mult([
      1, 0, 0, 0,
      0, 1, 0, 0,
      0, 0, 1, 0,
      x, y, z, 1,
    ], getMatrix(MatrixMode.ModelView));
    return Vertex(c[12], c[13], c[14], currentColor[0], currentColor[1], currentColor[2], currentColor[3]);
  }

  static void vertex(Vector3 v) {
    vertex(v.x, v.y, v.z);
  }

  static void color(float r, float g, float b, float a) {
    currentColor = [r, g, b, a];
  }

  static void viewport(int left, int right, int width, int height) {
    glViewport(left, right, width, height);
  }

  static void clearColor(float r, float g, float b, float a) {
    glClearColor(r, g, b, a);
  }

  static void clear(GLbitfield flag) {
    glClear(flag);
  }

  static void blendFunc(GLenum src, GLenum dest) {
    flush();
    glBlendFunc(src, dest);
  }

  static void enable(GLenum flag) {
    flush();
    glEnable(flag);
  }

  static void disable(GLenum flag) {
    flush();
    glDisable(flag);
  }

  static void lineWidth(float w) {
    flush();
    glLineWidth(w);
  }

version(GL_Batching) {
  static GLuint triArrayIndex, triBufferIndex;
  static GLuint lineArrayIndex, lineBufferIndex;
  static Vertex[MaxNumVertices] triangles;
  static int currentTriCount = 0;
  static int currentTriStartIndex = 0;
  static Vertex[MaxNumVertices] lines;
  static int currentLineCount = 0;
  static int currentLineStartIndex = 0;

  static void customInit() {
    createBuffer(triArrayIndex, triBufferIndex, triangles);
    createBuffer(lineArrayIndex, lineBufferIndex, lines);
  }
  static void frameStart() {

  }
  static void frameEnd() {
    flush();
  }

  static void begin(int primitiveType) {
    if (primitiveType == GL_TRIANGLES || primitiveType == GL_TRIANGLE_FAN || primitiveType == GL_TRIANGLE_STRIP || primitiveType == GL.QUADS) {
      flushLines();
    } else if (primitiveType == GL_LINES || primitiveType == GL_LINE_LOOP || primitiveType == GL_LINE_STRIP) {
      flushTriangles();
    }
    currentPrimitiveType = primitiveType;
    currentTriStartIndex = currentTriCount;
    currentLineStartIndex = currentLineCount;
  }

  static void pushTriVertex(float x, float y, float z) {
    assert(currentTriCount < triangles.length, "pushTriVertex(x, y, z): vertex count is " ~ to!string(currentTriCount));
    triangles[currentTriCount] = transform(x, y, z);
    currentTriCount++;
  }

  static void pushTriVertex(int n) {
    assert(currentTriCount < triangles.length, "pushTriVertex(n): vertex count is " ~ to!string(currentTriCount));
    assert(n >= 0 && n < triangles.length, "pushTriVertex(n): invalid index " ~ to!string(n));
    triangles[currentTriCount] = triangles[n];
    currentTriCount++;
  }

  static void pushLineVertex(float x, float y, float z) {
    assert(currentLineCount < lines.length, "pushLineVertex(x, y, z): vertex count is " ~ to!string(currentLineCount));
    lines[currentLineCount] = transform(x, y, z);
    currentLineCount++;
  }

  static void pushLineVertex(int n) {
    assert(currentLineCount < lines.length, "pushLineVertex(n): vertex count is " ~ to!string(currentLineCount));
    assert(n >= 0 && n < lines.length, "pushLineVertex(n): invalid index " ~ to!string(n));
    lines[currentLineCount] = lines[n];
    currentLineCount++;
  }

  static void vertex(float x, float y, float z) {
    assert(currentPrimitiveType != -1);
    if (currentPrimitiveType == GL_TRIANGLES) {
      pushTriVertex(x, y, z);
    } else if (currentPrimitiveType == GL_TRIANGLE_FAN) {
      int n = currentTriCount;
      if ((n - currentTriStartIndex) >= 3) {
        pushTriVertex(currentTriStartIndex);
        pushTriVertex(n - 1);
        pushTriVertex(x, y, z);
      } else {
        pushTriVertex(x, y, z);
      }
    } else if (currentPrimitiveType == GL_TRIANGLE_STRIP) {
      int n = currentTriCount;
      if ((n - currentTriStartIndex) >= 3) {
        if ((n / 3) % 2 == 0) {
          pushTriVertex(n - 2);
          pushTriVertex(n - 1);
          pushTriVertex(x, y, z);
        } else {
          pushTriVertex(n - 1);
          pushTriVertex(n - 2);
          pushTriVertex(x, y, z);
        }
      } else {
        pushTriVertex(x, y, z);
      }
    }
    else if (currentPrimitiveType == GL.QUADS) {
      int n = currentTriCount;
      if (n >= 3 && (n - currentTriStartIndex) % 3 == 0 && (n - currentTriStartIndex) % 6 != 0) {
        pushTriVertex(n - 3);
        pushTriVertex(n - 1);
        pushTriVertex(x, y, z);
      } else {
        pushTriVertex(x, y, z);
      }
    }
    else if (currentPrimitiveType == GL_LINES) {
      pushLineVertex(x, y, z);
    }
    else if (currentPrimitiveType == GL_LINE_LOOP || currentPrimitiveType == GL_LINE_STRIP) {
      int n = currentLineCount;
      if ((n - currentLineStartIndex) >= 2) {
        pushLineVertex(n - 1);
        pushLineVertex(x, y, z);
      } else {
        pushLineVertex(x, y, z);
      }
    }
  }

  static void texCoord(float u, float v) {}

  static void end() {
    assert(currentTriCount % 3 == 0, "end(): invalid triangle count " ~ to!string(currentTriCount));
    assert(currentLineCount % 2 == 0, "end(): invalid line count " ~ to!string(currentLineCount));
    if (currentPrimitiveType == GL_LINE_LOOP) {
      pushLineVertex(currentLineCount - 1);
      pushLineVertex(currentLineStartIndex);
    }
  }

  static void flush() {
    flushTriangles();
    flushLines();
  }

  static void flushTriangles() {
    if (currentTriCount > 0) {
      glBindVertexArray(triArrayIndex);

      glBindBuffer(GL_ARRAY_BUFFER, triBufferIndex);
      int size = currentTriCount * Vertex.sizeof;
      glBufferData(GL_ARRAY_BUFFER, size, null, GL_DYNAMIC_DRAW);
      glBufferData(GL_ARRAY_BUFFER, size, triangles.ptr, GL_DYNAMIC_DRAW);
    
      glUniformMatrix4fv(projectionLocation, 1, GL_FALSE, getMatrix(MatrixMode.Projection).ptr);
      glUniformMatrix4fv(modelViewLocation, 1, GL_FALSE, Identity.ptr);
      glDrawArrays(GL_TRIANGLES, 0, currentTriCount);

      glBindVertexArray(0);

      currentTriCount = 0;
    }
  }
  static void flushLines() {
    if (currentLineCount > 0) {
      glBindVertexArray(lineArrayIndex);

      glBindBuffer(GL_ARRAY_BUFFER, lineBufferIndex);
      int size = currentLineCount * Vertex.sizeof;
      glBufferData(GL_ARRAY_BUFFER, size, null, GL_DYNAMIC_DRAW);
      glBufferData(GL_ARRAY_BUFFER, size, lines.ptr, GL_DYNAMIC_DRAW);
    
      glUniformMatrix4fv(projectionLocation, 1, GL_FALSE, getMatrix(MatrixMode.Projection).ptr);
      glUniformMatrix4fv(modelViewLocation, 1, GL_FALSE, Identity.ptr);
      glDrawArrays(GL_LINES, 0, currentLineCount);

      glBindVertexArray(0);

      currentLineCount = 0;
    }
  }
} else {
  static GLuint vertArrayIndex, vertBufferIndex;
  static Vertex[MaxNumVertices] vertices;
  static int currentVertexCount = 0;

  static void customInit() {
    createBuffer(vertArrayIndex, vertBufferIndex, vertices);
  }
  static void frameStart() {}
  static void frameEnd() {}
  static void flush() {}

  static void begin(int primitiveType) {
    currentPrimitiveType = primitiveType;
  }

  static void vertex(float x, float y, float z) {
    vertices[currentVertexCount] = Vertex(x, y, z, currentColor[0], currentColor[1], currentColor[2], currentColor[3]);
    currentVertexCount++;
  }

  static void texCoord(float u, float v) {}

  static void end() {
    assert(currentPrimitiveType != -1);
    if (currentVertexCount > 0) {
      glBindVertexArray(vertArrayIndex);

      glBindBuffer(GL_ARRAY_BUFFER, vertBufferIndex);
      int size = currentVertexCount * Vertex.sizeof;
      glBufferData(GL_ARRAY_BUFFER, size, null, GL_STREAM_DRAW);
      glBufferData(GL_ARRAY_BUFFER, size, vertices.ptr, GL_STREAM_DRAW);
    
      glUniformMatrix4fv(projectionLocation, 1, GL_FALSE, getMatrix(MatrixMode.Projection).ptr);
      glUniformMatrix4fv(modelViewLocation, 1, GL_FALSE, getMatrix(MatrixMode.ModelView).ptr);
      glDrawArrays(currentPrimitiveType, 0, currentVertexCount);

      glBindVertexArray(0);

      currentVertexCount = 0;
    }
  }
}
}
}