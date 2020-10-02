module abagames.util.gl;

import std.math;
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
  struct MatrixState
  {
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

public:
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

  static void apply() {
    glMatrixMode(GL_PROJECTION);
    glLoadMatrixf(&getMatrix(MatrixMode.Projection)[0]);
    glMatrixMode(GL_MODELVIEW);
    glLoadMatrixf(&getMatrix(MatrixMode.ModelView)[0]);
  }

  static void begin(int primitiveType) {
    apply();
    glBegin(primitiveType);
  }

  static void end() {
    glEnd();
  }
}