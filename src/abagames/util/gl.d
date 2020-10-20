module abagames.util.gl;

import std.conv;
import std.stdio;
version(BindBC) { import bindbc.opengl; }

import abagames.util.math;
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
    if (mode == MatrixMode.Projection) {
      glMatrixMode(GL.PROJECTION);
    } else if (mode == MatrixMode.ModelView) {
      glMatrixMode(GL.MODELVIEW);
    }
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

  static void clear(uint flag) {
    glClear(flag);
  }

  static void blendFunc(uint src, uint dest) {
    glBlendFunc(src, dest);
  }

  static void enable(uint flag) {
    glEnable(flag);
  }

  static void disable(uint flag) {
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

  static void end() {
    glEnd();
  }

  static const int QUADS = GL.QUADS;
}
else
{
  enum : ubyte {
    FALSE                          = 0,
    TRUE                           = 1,
  }
  enum : uint {
    DEPTH_BUFFER_BIT               = 0x00000100,
    STENCIL_BUFFER_BIT             = 0x00000400,
    COLOR_BUFFER_BIT               = 0x00004000,
    POINTS                         = 0x0000,
    LINES                          = 0x0001,
    LINE_LOOP                      = 0x0002,
    LINE_STRIP                     = 0x0003,
    TRIANGLES                      = 0x0004,
    TRIANGLE_STRIP                 = 0x0005,
    TRIANGLE_FAN                   = 0x0006,
    QUADS                          = 0x0007,
    NEVER                          = 0x0200,
    LESS                           = 0x0201,
    EQUAL                          = 0x0202,
    LEQUAL                         = 0x0203,
    GREATER                        = 0x0204,
    NOTEQUAL                       = 0x0205,
    GEQUAL                         = 0x0206,
    ALWAYS                         = 0x0207,
    ZERO                           = 0,
    ONE                            = 1,
    SRC_COLOR                      = 0x0300,
    ONE_MINUS_SRC_COLOR            = 0x0301,
    SRC_ALPHA                      = 0x0302,
    ONE_MINUS_SRC_ALPHA            = 0x0303,
    DST_ALPHA                      = 0x0304,
    ONE_MINUS_DST_ALPHA            = 0x0305,
    DST_COLOR                      = 0x0306,
    ONE_MINUS_DST_COLOR            = 0x0307,
    SRC_ALPHA_SATURATE             = 0x0308,
    NONE                           = 0,
    FRONT_LEFT                     = 0x0400,
    FRONT_RIGHT                    = 0x0401,
    BACK_LEFT                      = 0x0402,
    BACK_RIGHT                     = 0x0403,
    FRONT                          = 0x0404,
    BACK                           = 0x0405,
    LEFT                           = 0x0406,
    RIGHT                          = 0x0407,
    FRONT_AND_BACK                 = 0x0408,
    NO_ERROR                       = 0,
    INVALID_ENUM                   = 0x0500,
    INVALID_VALUE                  = 0x0501,
    INVALID_OPERATION              = 0x0502,
    OUT_OF_MEMORY                  = 0x0505,
    CW                             = 0x0900,
    CCW                            = 0x0901,
    POINT_SIZE                     = 0x0B11,
    POINT_SIZE_RANGE               = 0x0B12,
    POINT_SIZE_GRANULARITY         = 0x0B13,
    LINE_SMOOTH                    = 0x0B20,
    LINE_WIDTH                     = 0x0B21,
    LINE_WIDTH_RANGE               = 0x0B22,
    LINE_WIDTH_GRANULARITY         = 0x0B23,
    POLYGON_MODE                   = 0x0B40,
    POLYGON_SMOOTH                 = 0x0B41,
    CULL_FACE                      = 0x0B44,
    CULL_FACE_MODE                 = 0x0B45,
    FRONT_FACE                     = 0x0B46,
    DEPTH_RANGE                    = 0x0B70,
    DEPTH_TEST                     = 0x0B71,
    DEPTH_WRITEMASK                = 0x0B72,
    DEPTH_CLEAR_VALUE              = 0x0B73,
    DEPTH_FUNC                     = 0x0B74,
    STENCIL_TEST                   = 0x0B90,
    STENCIL_CLEAR_VALUE            = 0x0B91,
    STENCIL_FUNC                   = 0x0B92,
    STENCIL_VALUE_MASK             = 0x0B93,
    STENCIL_FAIL                   = 0x0B94,
    STENCIL_PASS_DEPTH_FAIL        = 0x0B95,
    STENCIL_PASS_DEPTH_PASS        = 0x0B96,
    STENCIL_REF                    = 0x0B97,
    STENCIL_WRITEMASK              = 0x0B98,
    VIEWPORT                       = 0x0BA2,
    DITHER                         = 0x0BD0,
    BLEND_DST                      = 0x0BE0,
    BLEND_SRC                      = 0x0BE1,
    BLEND                          = 0x0BE2,
    LOGIC_OP_MODE                  = 0x0BF0,
    COLOR_LOGIC_OP                 = 0x0BF2,
    DRAW_BUFFER                    = 0x0C01,
    READ_BUFFER                    = 0x0C02,
    SCISSOR_BOX                    = 0x0C10,
    SCISSOR_TEST                   = 0x0C11,
    COLOR_CLEAR_VALUE              = 0x0C22,
    COLOR_WRITEMASK                = 0x0C23,
    DOUBLEBUFFER                   = 0x0C32,
    STEREO                         = 0x0C33,
    LINE_SMOOTH_HINT               = 0x0C52,
    POLYGON_SMOOTH_HINT            = 0x0C53,
    UNPACK_SWAP_BYTES              = 0x0CF0,
    UNPACK_LSB_FIRST               = 0x0CF1,
    UNPACK_ROW_LENGTH              = 0x0CF2,
    UNPACK_SKIP_ROWS               = 0x0CF3,
    UNPACK_SKIP_PIXELS             = 0x0CF4,
    UNPACK_ALIGNMENT               = 0x0CF5,
    PACK_SWAP_BYTES                = 0x0D00,
    PACK_LSB_FIRST                 = 0x0D01,
    PACK_ROW_LENGTH                = 0x0D02,
    PACK_SKIP_ROWS                 = 0x0D03,
    PACK_SKIP_PIXELS               = 0x0D04,
    PACK_ALIGNMENT                 = 0x0D05,
    MAX_TEXTURE_SIZE               = 0x0D33,
    MAX_VIEWPORT_DIMS              = 0x0D3A,
    SUBPIXEL_BITS                  = 0x0D50,
    TEXTURE_1D                     = 0x0DE0,
    TEXTURE_2D                     = 0x0DE1,
    POLYGON_OFFSET_UNITS           = 0x2A00,
    POLYGON_OFFSET_POINT           = 0x2A01,
    POLYGON_OFFSET_LINE            = 0x2A02,
    POLYGON_OFFSET_FILL            = 0x8037,
    POLYGON_OFFSET_FACTOR          = 0x8038,
    TEXTURE_BINDING_1D             = 0x8068,
    TEXTURE_BINDING_2D             = 0x8069,
    TEXTURE_WIDTH                  = 0x1000,
    TEXTURE_HEIGHT                 = 0x1001,
    TEXTURE_INTERNAL_FORMAT        = 0x1003,
    TEXTURE_BORDER_COLOR           = 0x1004,
    TEXTURE_RED_SIZE               = 0x805C,
    TEXTURE_GREEN_SIZE             = 0x805D,
    TEXTURE_BLUE_SIZE              = 0x805E,
    TEXTURE_ALPHA_SIZE             = 0x805F,
    DONT_CARE                      = 0x1100,
    FASTEST                        = 0x1101,
    NICEST                         = 0x1102,
    BYTE                           = 0x1400,
    UNSIGNED_BYTE                  = 0x1401,
    SHORT                          = 0x1402,
    UNSIGNED_SHORT                 = 0x1403,
    INT                            = 0x1404,
    UNSIGNED_INT                   = 0x1405,
    FLOAT                          = 0x1406,
    DOUBLE                         = 0x140A,
    CLEAR                          = 0x1500,
    AND                            = 0x1501,
    AND_REVERSE                    = 0x1502,
    COPY                           = 0x1503,
    AND_INVERTED                   = 0x1504,
    NOOP                           = 0x1505,
    XOR                            = 0x1506,
    OR                             = 0x1507,
    NOR                            = 0x1508,
    EQUIV                          = 0x1509,
    INVERT                         = 0x150A,
    OR_REVERSE                     = 0x150B,
    COPY_INVERTED                  = 0x150C,
    OR_INVERTED                    = 0x150D,
    NAND                           = 0x150E,
    SET                            = 0x150F,
    TEXTURE                        = 0x1702,
    COLOR                          = 0x1800,
    DEPTH                          = 0x1801,
    STENCIL                        = 0x1802,
    STENCIL_INDEX                  = 0x1901,
    DEPTH_COMPONENT                = 0x1902,
    RED                            = 0x1903,
    GREEN                          = 0x1904,
    BLUE                           = 0x1905,
    ALPHA                          = 0x1906,
    RGB                            = 0x1907,
    RGBA                           = 0x1908,
    POINT                          = 0x1B00,
    LINE                           = 0x1B01,
    FILL                           = 0x1B02,
    KEEP                           = 0x1E00,
    REPLACE                        = 0x1E01,
    INCR                           = 0x1E02,
    DECR                           = 0x1E03,
    VENDOR                         = 0x1F00,
    RENDERER                       = 0x1F01,
    VERSION                        = 0x1F02,
    EXTENSIONS                     = 0x1F03,
    NEAREST                        = 0x2600,
    LINEAR                         = 0x2601,
    NEAREST_MIPMAP_NEAREST         = 0x2700,
    LINEAR_MIPMAP_NEAREST          = 0x2701,
    NEAREST_MIPMAP_LINEAR          = 0x2702,
    LINEAR_MIPMAP_LINEAR           = 0x2703,
    TEXTURE_MAG_FILTER             = 0x2800,
    TEXTURE_MIN_FILTER             = 0x2801,
    TEXTURE_WRAP_S                 = 0x2802,
    TEXTURE_WRAP_T                 = 0x2803,
    PROXY_TEXTURE_1D               = 0x8063,
    PROXY_TEXTURE_2D               = 0x8064,
    REPEAT                         = 0x2901,
    R3_G3_B2                       = 0x2A10,
    RGB4                           = 0x804F,
    RGB5                           = 0x8050,
    RGB8                           = 0x8051,
    RGB10                          = 0x8052,
    RGB12                          = 0x8053,
    RGB16                          = 0x8054,
    RGBA2                          = 0x8055,
    RGBA4                          = 0x8056,
    RGB5_A1                        = 0x8057,
    RGBA8                          = 0x8058,
    RGB10_A2                       = 0x8059,
    RGBA12                         = 0x805A,
    RGBA16                         = 0x805B,
    VERTEX_ARRAY                   = 0x8074,
    ARRAY_BUFFER                   = 0x8892,
    STREAM_DRAW                    = 0x88E0,
    FRAGMENT_SHADER                = 0x8B30,
    VERTEX_SHADER                  = 0x8B31,
    COMPILE_STATUS                 = 0x8B81,
    LINK_STATUS                    = 0x8B82,
    VALIDATE_STATUS                = 0x8B83,
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

version(GL_Batching) {
  static const int MaxNumVertices = 32768;
} else {
  static const int MaxNumVertices = 4096;
}

  static uint program;
  static int vertPositionLocation, vertColorLocation, projectionLocation, modelViewLocation;

  static int currentPrimitiveType = -1;
  static float[4] currentColor = [1, 1, 1, 1];

  static uint compileProgram(string vsSource, string fsSource) {
    char[1024] infoLog;
    int infoLogLength = 0;
    int status = 0;

    auto vsIndex = glCreateShader(GL.VERTEX_SHADER);
    {
      auto sourcePtr = cast(char*)vsSource.ptr;
      glShaderSource(vsIndex, 1, &sourcePtr, null);
      glCompileShader(vsIndex);
      glGetShaderiv(vsIndex, GL.COMPILE_STATUS, &status);
      if (status == 0) {
        glGetShaderInfoLog(vsIndex, infoLog.length, &infoLogLength, infoLog.ptr);
        assert(false, infoLog[0..infoLogLength]);
      }
    }

    auto fsIndex = glCreateShader(GL.FRAGMENT_SHADER);
    {
      auto sourcePtr = cast(char*)fsSource.ptr;
      glShaderSource(fsIndex, 1, &sourcePtr, null);
      glCompileShader(fsIndex);
      glGetShaderiv(fsIndex, GL.COMPILE_STATUS, &status);
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
        glGetProgramiv(progIndex, GL.LINK_STATUS, &status);
        if (status == 0) {
          glGetProgramInfoLog(progIndex, infoLog.length, &infoLogLength, infoLog.ptr);
          assert(false, infoLog[0..infoLogLength]);
        }
      }

      glValidateProgram(progIndex);

      {
        glGetProgramiv(progIndex, GL.VALIDATE_STATUS, &status);
        if (status == 0) {
          glGetProgramInfoLog(progIndex, infoLog.length, &infoLogLength, infoLog.ptr);
          assert(false, infoLog[0..infoLogLength]);
        }
      }
    }

    return progIndex;
  }

  static void createBuffer(ref uint arrayIndex, ref uint bufferIndex, Vertex[MaxNumVertices] buffer) {
    glGenVertexArrays(1, &arrayIndex);
    glBindVertexArray(arrayIndex);

    glGenBuffers(1, &bufferIndex);
    glBindBuffer(GL.ARRAY_BUFFER, bufferIndex);
    glBufferData(GL.ARRAY_BUFFER, buffer.sizeof, null, GL.STREAM_DRAW);

    glVertexAttribPointer(vertPositionLocation, 3, GL.FLOAT, GL.FALSE, 7 * float.sizeof, cast(void*)0);
    glVertexAttribPointer(vertColorLocation, 4, GL.FLOAT, GL.FALSE, 7 * float.sizeof, cast(void*)(3 * float.sizeof));

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
    if (currentMode == MatrixMode.ModelView && mode == MatrixMode.Projection) {
      flush();
    }
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

  static void clear(uint flag) {
    glClear(flag);
  }

  static void blendFunc(uint src, uint dest) {
    flush();
    glBlendFunc(src, dest);
  }

  static void enable(uint flag) {
    flush();
    glEnable(flag);
  }

  static void disable(uint flag) {
    flush();
    glDisable(flag);
  }

  static void lineWidth(float w) {
    flush();
    glLineWidth(w);
  }

version(GL_Batching) {
  static uint triArrayIndex, triBufferIndex;
  static uint lineArrayIndex, lineBufferIndex;
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
    if (currentPrimitiveType == GL.TRIANGLES) {
      pushTriVertex(x, y, z);
    } else if (currentPrimitiveType == GL.TRIANGLE_FAN) {
      int n = currentTriCount;
      if ((n - currentTriStartIndex) >= 3) {
        pushTriVertex(currentTriStartIndex);
        pushTriVertex(n - 1);
        pushTriVertex(x, y, z);
      } else {
        pushTriVertex(x, y, z);
      }
    } else if (currentPrimitiveType == GL.TRIANGLE_STRIP) {
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
    else if (currentPrimitiveType == GL.LINES) {
      pushLineVertex(x, y, z);
    }
    else if (currentPrimitiveType == GL.LINE_LOOP || currentPrimitiveType == GL.LINE_STRIP) {
      int n = currentLineCount;
      if ((n - currentLineStartIndex) >= 2) {
        pushLineVertex(n - 1);
        pushLineVertex(x, y, z);
      } else {
        pushLineVertex(x, y, z);
      }
    }
  }

  static void end() {
    assert(currentTriCount % 3 == 0, "end(): invalid triangle count " ~ to!string(currentTriCount));
    assert(currentLineCount % 2 == 0, "end(): invalid line count " ~ to!string(currentLineCount));
    if (currentPrimitiveType == GL.LINE_LOOP) {
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

      glBindBuffer(GL.ARRAY_BUFFER, triBufferIndex);
      int size = currentTriCount * Vertex.sizeof;
      glBufferData(GL.ARRAY_BUFFER, size, null, GL.STREAM_DRAW);
      glBufferData(GL.ARRAY_BUFFER, size, triangles.ptr, GL.STREAM_DRAW);
    
      glUniformMatrix4fv(projectionLocation, 1, GL.FALSE, getMatrix(MatrixMode.Projection).ptr);
      glUniformMatrix4fv(modelViewLocation, 1, GL.FALSE, Identity.ptr);
      glDrawArrays(GL.TRIANGLES, 0, currentTriCount);

      glBindVertexArray(0);

      currentTriCount = 0;
    }
  }
  static void flushLines() {
    if (currentLineCount > 0) {
      glBindVertexArray(lineArrayIndex);

      glBindBuffer(GL.ARRAY_BUFFER, lineBufferIndex);
      int size = currentLineCount * Vertex.sizeof;
      glBufferData(GL.ARRAY_BUFFER, size, null, GL.STREAM_DRAW);
      glBufferData(GL.ARRAY_BUFFER, size, lines.ptr, GL.STREAM_DRAW);
    
      glUniformMatrix4fv(projectionLocation, 1, GL.FALSE, getMatrix(MatrixMode.Projection).ptr);
      glUniformMatrix4fv(modelViewLocation, 1, GL.FALSE, Identity.ptr);
      glDrawArrays(GL.LINES, 0, currentLineCount);

      glBindVertexArray(0);

      currentLineCount = 0;
    }
  }
} else {
  static uint vertArrayIndex, vertBufferIndex;
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

  static void end() {
    assert(currentPrimitiveType != -1);
    if (currentVertexCount > 0) {
      glBindVertexArray(vertArrayIndex);

      glBindBuffer(GL.ARRAY_BUFFER, vertBufferIndex);
      int size = currentVertexCount * Vertex.sizeof;
      glBufferData(GL.ARRAY_BUFFER, size, null, GL.STREAM_DRAW);
      glBufferData(GL.ARRAY_BUFFER, size, vertices.ptr, GL.STREAM_DRAW);
    
      glUniformMatrix4fv(projectionLocation, 1, GL.FALSE, getMatrix(MatrixMode.Projection).ptr);
      glUniformMatrix4fv(modelViewLocation, 1, GL.FALSE, getMatrix(MatrixMode.ModelView).ptr);
      glDrawArrays(currentPrimitiveType, 0, currentVertexCount);

      glBindVertexArray(0);

      currentVertexCount = 0;
    }
  }
}
}
}

version(WebGL) {
  extern (C) {
    int glGetAttribLocation(uint, const(char)*) { return 0; }
    int glGetUniformLocation(uint, const(char)*) { return 0; }
    uint glCreateProgram() { return 0; }
    uint glCreateShader(uint) { return 0; }
    void glAttachShader(uint, uint) {}
    void glBindBuffer(uint, uint) {}
    void glBindVertexArray(uint) {}
    void glBlendFunc(uint, uint) {}
    void glBufferData(uint, ptrdiff_t, const(void)*, uint) {}
    void glClear(uint) {}
    void glClearColor(float, float, float, float) {}
    void glCompileShader(uint) {}
    void glDisable(uint) {}
    void glDrawArrays(uint, int, int) {}
    void glEnable(uint) {}
    void glEnableVertexAttribArray(int) {}
    void glGenBuffers(int, uint*) {}
    void glGenVertexArrays(int, uint*) {}
    void glGetProgramInfoLog(uint, int, int*, char*) {}
    void glGetProgramiv(uint, uint, int* v) { *v = 1; }
    void glGetShaderInfoLog(uint, int, int*, char*) {}
    void glGetShaderiv(uint, uint, int* v) { *v = 1; }
    void glLineWidth(float) {}
    void glLinkProgram(uint) {}
    void glShaderSource(uint, int, const(char*)*, const(int)*) {}
    void glUniformMatrix4fv(int, int, ubyte, const(float)*) {}
    void glUseProgram(uint) {}
    void glValidateProgram(uint) {}
    void glVertexAttribPointer(uint, int, uint, ubyte, int, const(void)*) {}
    void glViewport(int, int, int, int) {}
  }
}
