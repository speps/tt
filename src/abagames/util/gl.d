module abagames.util.gl;

import std.conv;
import std.math;
import std.stdio;
import bindbc.opengl;

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

  static GLuint program;
  static GLint vertPositionLocation, vertColorLocation, projectionLocation, modelViewLocation;
  static GLuint vertArrayIndex, vertBufferIndex;

  static Vertex[1024] vertices;
  static int currentVertexCount = 0;

  static int currentPrimitiveType = -1;
  static float[4] currentColor = [1, 1, 1, 1];

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

  static void createBuffer(ref GLuint arrayIndex, ref GLuint bufferIndex, Vertex[1024] buffer) {
    glGenVertexArrays(1, &arrayIndex);
    glBindVertexArray(arrayIndex);

    glGenBuffers(1, &bufferIndex);
    glBindBuffer(GL_ARRAY_BUFFER, bufferIndex);
    glBufferData(GL_ARRAY_BUFFER, buffer.sizeof, buffer.ptr, GL_DYNAMIC_DRAW);

    glVertexAttribPointer(vertPositionLocation, 3, GL_FLOAT, GL_FALSE, 7 * float.sizeof, cast(void*)0);
    glVertexAttribPointer(vertColorLocation, 4, GL_FLOAT, GL_FALSE, 7 * float.sizeof, cast(void*)(3 * float.sizeof));

    glEnableVertexAttribArray(vertPositionLocation);
    glEnableVertexAttribArray(vertColorLocation);

    glBindVertexArray(0);
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

    createBuffer(vertArrayIndex, vertBufferIndex, vertices);

    glUseProgram(program);
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
    Matrix c = states[currentMode].stack[states[currentMode].stackIndex];
    Matrix r;

    for(int i = 0; i < 4; i++) {
        for(int j = 0; j < 4; j++) {
            r[j+4*i] =
              m[0+4*i] * c[j+4*0]
            + m[1+4*i] * c[j+4*1]
            + m[2+4*i] * c[j+4*2]
            + m[3+4*i] * c[j+4*3];
        }
    }

    states[currentMode].stack[states[currentMode].stackIndex] = r;
  }

  static void translate(float x, float y, float z) {
    multMatrix([
      1, 0, 0, 0,
      0, 1, 0, 0,
      0, 0, 1, 0,
      x, y, z, 1,
    ]);
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
    Matrix c = getMatrix(MatrixMode.ModelView);
    float w = c[12]*x+c[13]*y+c[14]*z+c[15];
    float tx = c[0]*x+c[1]*y+c[2]*z+c[3] / w;
    float ty = c[4]*x+c[5]*y+c[6]*z+c[7] / w;
    float tz = c[8]*x+c[9]*y+c[10]*z+c[11] / w;
    return Vertex(tx, ty, tz, currentColor[0], currentColor[1], currentColor[2], currentColor[3]);
  }

  static void begin(int primitiveType) {
    currentPrimitiveType = primitiveType;
  }

  static void vertex(float x, float y, float z) {
    vertices[currentVertexCount] = Vertex(x, y, z, currentColor[0], currentColor[1], currentColor[2], currentColor[3]);
    currentVertexCount++;
  }

  static void color(float r, float g, float b, float a) {
    currentColor = [r, g, b, a];
  }

  static void texCoord(float u, float v) {}

  static void end() {
    assert(currentPrimitiveType != -1);
    if (currentVertexCount > 0) {
      glBindVertexArray(vertArrayIndex);

      glBindBuffer(GL_ARRAY_BUFFER, vertBufferIndex);
      glBufferSubData(GL_ARRAY_BUFFER, 0, vertices.sizeof, vertices.ptr);
    
      glUniformMatrix4fv(projectionLocation, 1, GL_FALSE, getMatrix(MatrixMode.Projection).ptr);
      glUniformMatrix4fv(modelViewLocation, 1, GL_FALSE, getMatrix(MatrixMode.ModelView).ptr);
      glDrawArrays(currentPrimitiveType, 0, currentVertexCount);

      glBindVertexArray(0);

      currentVertexCount = 0;
    }
  }
}