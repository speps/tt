version (Win32) {
	private import std.c.windows.windows;
	extern(Windows):
}
version (linux) {
	extern(C):
}

alias uint GLenum;
alias ubyte GLboolean;
alias uint GLbitfield;
alias byte GLbyte;
alias short GLshort;
alias int GLint;
alias int GLsizei;
alias ubyte GLubyte;
alias ushort GLushort;
alias uint GLuint;
alias float GLfloat;
alias float GLclampf;
alias double GLdouble;
alias double GLclampd;
alias void GLvoid;

/*************************************************************/

/* Version */
const uint GL_VERSION_1_1 = 1;

/* AccumOp */
const uint GL_ACCUM                      = 0x0100;
const uint GL_LOAD                       = 0x0101;
const uint GL_RETURN                     = 0x0102;
const uint GL_MULT                       = 0x0103;
const uint GL_ADD                        = 0x0104;

/* AlphaFunction */
const uint GL_NEVER                      = 0x0200;
const uint GL_LESS                       = 0x0201;
const uint GL_EQUAL                      = 0x0202;
const uint GL_LEQUAL                     = 0x0203;
const uint GL_GREATER                    = 0x0204;
const uint GL_NOTEQUAL                   = 0x0205;
const uint GL_GEQUAL                     = 0x0206;
const uint GL_ALWAYS                     = 0x0207;

/* AttribMask */
const uint GL_CURRENT_BIT                = 0x00000001;
const uint GL_POINT_BIT                  = 0x00000002;
const uint GL_LINE_BIT                   = 0x00000004;
const uint GL_POLYGON_BIT                = 0x00000008;
const uint GL_POLYGON_STIPPLE_BIT        = 0x00000010;
const uint GL_PIXEL_MODE_BIT             = 0x00000020;
const uint GL_LIGHTING_BIT               = 0x00000040;
const uint GL_FOG_BIT                    = 0x00000080;
const uint GL_DEPTH_BUFFER_BIT           = 0x00000100;
const uint GL_ACCUM_BUFFER_BIT           = 0x00000200;
const uint GL_STENCIL_BUFFER_BIT         = 0x00000400;
const uint GL_VIEWPORT_BIT               = 0x00000800;
const uint GL_TRANSFORM_BIT              = 0x00001000;
const uint GL_ENABLE_BIT                 = 0x00002000;
const uint GL_COLOR_BUFFER_BIT           = 0x00004000;
const uint GL_HINT_BIT                   = 0x00008000;
const uint GL_EVAL_BIT                   = 0x00010000;
const uint GL_LIST_BIT                   = 0x00020000;
const uint GL_TEXTURE_BIT                = 0x00040000;
const uint GL_SCISSOR_BIT                = 0x00080000;
const uint GL_ALL_ATTRIB_BITS            = 0x000fffff;

/* BeginMode */
const uint GL_POINTS                     = 0x0000;
const uint GL_LINES                      = 0x0001;
const uint GL_LINE_LOOP                  = 0x0002;
const uint GL_LINE_STRIP                 = 0x0003;
const uint GL_TRIANGLES                  = 0x0004;
const uint GL_TRIANGLE_STRIP             = 0x0005;
const uint GL_TRIANGLE_FAN               = 0x0006;
const uint GL_QUADS                      = 0x0007;
const uint GL_QUAD_STRIP                 = 0x0008;
const uint GL_POLYGON                    = 0x0009;

/* BlendingFactorDest */
const uint GL_ZERO                       = 0;
const uint GL_ONE                        = 1;
const uint GL_SRC_COLOR                  = 0x0300;
const uint GL_ONE_MINUS_SRC_COLOR        = 0x0301;
const uint GL_SRC_ALPHA                  = 0x0302;
const uint GL_ONE_MINUS_SRC_ALPHA        = 0x0303;
const uint GL_DST_ALPHA                  = 0x0304;
const uint GL_ONE_MINUS_DST_ALPHA        = 0x0305;

/* BlendingFactorSrc */
/*      GL_ZERO */
/*      GL_ONE */
const uint GL_DST_COLOR                  = 0x0306;
const uint GL_ONE_MINUS_DST_COLOR        = 0x0307;
const uint GL_SRC_ALPHA_SATURATE         = 0x0308;
/*      GL_SRC_ALPHA */
/*      GL_ONE_MINUS_SRC_ALPHA */
/*      GL_DST_ALPHA */
/*      GL_ONE_MINUS_DST_ALPHA */

/* Boolean */
const uint GL_TRUE                       = 1;
const uint GL_FALSE                      = 0;

/* ClearBufferMask */
/*      GL_COLOR_BUFFER_BIT */
/*      GL_ACCUM_BUFFER_BIT */
/*      GL_STENCIL_BUFFER_BIT */
/*      GL_DEPTH_BUFFER_BIT */

/* ClientArrayType */
/*      GL_VERTEX_ARRAY */
/*      GL_NORMAL_ARRAY */
/*      GL_COLOR_ARRAY */
/*      GL_INDEX_ARRAY */
/*      GL_TEXTURE_COORD_ARRAY */
/*      GL_EDGE_FLAG_ARRAY */

/* ClipPlaneName */
const uint GL_CLIP_PLANE0                = 0x3000;
const uint GL_CLIP_PLANE1                = 0x3001;
const uint GL_CLIP_PLANE2                = 0x3002;
const uint GL_CLIP_PLANE3                = 0x3003;
const uint GL_CLIP_PLANE4                = 0x3004;
const uint GL_CLIP_PLANE5                = 0x3005;

/* ColorMaterialFace */
/*      GL_FRONT */
/*      GL_BACK */
/*      GL_FRONT_AND_BACK */

/* ColorMaterialParameter */
/*      GL_AMBIENT */
/*      GL_DIFFUSE */
/*      GL_SPECULAR */
/*      GL_EMISSION */
/*      GL_AMBIENT_AND_DIFFUSE */

/* ColorPointerType */
/*      GL_BYTE */
/*      GL_UNSIGNED_BYTE */
/*      GL_SHORT */
/*      GL_UNSIGNED_SHORT */
/*      GL_INT */
/*      GL_UNSIGNED_INT */
/*      GL_FLOAT */
/*      GL_DOUBLE */

/* CullFaceMode */
/*      GL_FRONT */
/*      GL_BACK */
/*      GL_FRONT_AND_BACK */

/* DataType */
const uint GL_BYTE                       = 0x1400;
const uint GL_UNSIGNED_BYTE              = 0x1401;
const uint GL_SHORT                      = 0x1402;
const uint GL_UNSIGNED_SHORT             = 0x1403;
const uint GL_INT                        = 0x1404;
const uint GL_UNSIGNED_INT               = 0x1405;
const uint GL_FLOAT                      = 0x1406;
const uint GL_2_BYTES                    = 0x1407;
const uint GL_3_BYTES                    = 0x1408;
const uint GL_4_BYTES                    = 0x1409;
const uint GL_DOUBLE                     = 0x140A;

/* DepthFunction */
/*      GL_NEVER */
/*      GL_LESS */
/*      GL_EQUAL */
/*      GL_LEQUAL */
/*      GL_GREATER */
/*      GL_NOTEQUAL */
/*      GL_GEQUAL */
/*      GL_ALWAYS */

/* DrawBufferMode */
const uint GL_NONE                       = 0;
const uint GL_FRONT_LEFT                 = 0x0400;
const uint GL_FRONT_RIGHT                = 0x0401;
const uint GL_BACK_LEFT                  = 0x0402;
const uint GL_BACK_RIGHT                 = 0x0403;
const uint GL_FRONT                      = 0x0404;
const uint GL_BACK                       = 0x0405;
const uint GL_LEFT                       = 0x0406;
const uint GL_RIGHT                      = 0x0407;
const uint GL_FRONT_AND_BACK             = 0x0408;
const uint GL_AUX0                       = 0x0409;
const uint GL_AUX1                       = 0x040A;
const uint GL_AUX2                       = 0x040B;
const uint GL_AUX3                       = 0x040C;

/* Enable */
/*      GL_FOG */
/*      GL_LIGHTING */
/*      GL_TEXTURE_1D */
/*      GL_TEXTURE_2D */
/*      GL_LINE_STIPPLE */
/*      GL_POLYGON_STIPPLE */
/*      GL_CULL_FACE */
/*      GL_ALPHA_TEST */
/*      GL_BLEND */
/*      GL_INDEX_LOGIC_OP */
/*      GL_COLOR_LOGIC_OP */
/*      GL_DITHER */
/*      GL_STENCIL_TEST */
/*      GL_DEPTH_TEST */
/*      GL_CLIP_PLANE0 */
/*      GL_CLIP_PLANE1 */
/*      GL_CLIP_PLANE2 */
/*      GL_CLIP_PLANE3 */
/*      GL_CLIP_PLANE4 */
/*      GL_CLIP_PLANE5 */
/*      GL_LIGHT0 */
/*      GL_LIGHT1 */
/*      GL_LIGHT2 */
/*      GL_LIGHT3 */
/*      GL_LIGHT4 */
/*      GL_LIGHT5 */
/*      GL_LIGHT6 */
/*      GL_LIGHT7 */
/*      GL_TEXTURE_GEN_S */
/*      GL_TEXTURE_GEN_T */
/*      GL_TEXTURE_GEN_R */
/*      GL_TEXTURE_GEN_Q */
/*      GL_MAP1_VERTEX_3 */
/*      GL_MAP1_VERTEX_4 */
/*      GL_MAP1_COLOR_4 */
/*      GL_MAP1_INDEX */
/*      GL_MAP1_NORMAL */
/*      GL_MAP1_TEXTURE_COORD_1 */
/*      GL_MAP1_TEXTURE_COORD_2 */
/*      GL_MAP1_TEXTURE_COORD_3 */
/*      GL_MAP1_TEXTURE_COORD_4 */
/*      GL_MAP2_VERTEX_3 */
/*      GL_MAP2_VERTEX_4 */
/*      GL_MAP2_COLOR_4 */
/*      GL_MAP2_INDEX */
/*      GL_MAP2_NORMAL */
/*      GL_MAP2_TEXTURE_COORD_1 */
/*      GL_MAP2_TEXTURE_COORD_2 */
/*      GL_MAP2_TEXTURE_COORD_3 */
/*      GL_MAP2_TEXTURE_COORD_4 */
/*      GL_POINT_SMOOTH */
/*      GL_LINE_SMOOTH */
/*      GL_POLYGON_SMOOTH */
/*      GL_SCISSOR_TEST */
/*      GL_COLOR_MATERIAL */
/*      GL_NORMALIZE */
/*      GL_AUTO_NORMAL */
/*      GL_VERTEX_ARRAY */
/*      GL_NORMAL_ARRAY */
/*      GL_COLOR_ARRAY */
/*      GL_INDEX_ARRAY */
/*      GL_TEXTURE_COORD_ARRAY */
/*      GL_EDGE_FLAG_ARRAY */
/*      GL_POLYGON_OFFSET_POINT */
/*      GL_POLYGON_OFFSET_LINE */
/*      GL_POLYGON_OFFSET_FILL */

/* ErrorCode */
const uint GL_NO_ERROR                   = 0;
const uint GL_INVALID_ENUM               = 0x0500;
const uint GL_INVALID_VALUE              = 0x0501;
const uint GL_INVALID_OPERATION          = 0x0502;
const uint GL_STACK_OVERFLOW             = 0x0503;
const uint GL_STACK_UNDERFLOW            = 0x0504;
const uint GL_OUT_OF_MEMORY              = 0x0505;

/* FeedBackMode */
const uint GL_2D                         = 0x0600;
const uint GL_3D                         = 0x0601;
const uint GL_3D_COLOR                   = 0x0602;
const uint GL_3D_COLOR_TEXTURE           = 0x0603;
const uint GL_4D_COLOR_TEXTURE           = 0x0604;

/* FeedBackToken */
const uint GL_PASS_THROUGH_TOKEN         = 0x0700;
const uint GL_POINT_TOKEN                = 0x0701;
const uint GL_LINE_TOKEN                 = 0x0702;
const uint GL_POLYGON_TOKEN              = 0x0703;
const uint GL_BITMAP_TOKEN               = 0x0704;
const uint GL_DRAW_PIXEL_TOKEN           = 0x0705;
const uint GL_COPY_PIXEL_TOKEN           = 0x0706;
const uint GL_LINE_RESET_TOKEN           = 0x0707;

/* FogMode */
/*      GL_LINEAR */
const uint GL_EXP                        = 0x0800;
const uint GL_EXP2                       = 0x0801;


/* FogParameter */
/*      GL_FOG_COLOR */
/*      GL_FOG_DENSITY */
/*      GL_FOG_END */
/*      GL_FOG_INDEX */
/*      GL_FOG_MODE */
/*      GL_FOG_START */

/* FrontFaceDirection */
const uint GL_CW                         = 0x0900;
const uint GL_CCW                        = 0x0901;

/* GetMapTarget */
const uint GL_COEFF                      = 0x0A00;
const uint GL_ORDER                      = 0x0A01;
const uint GL_DOMAIN                     = 0x0A02;

/* GetPixelMap */
/*      GL_PIXEL_MAP_I_TO_I */
/*      GL_PIXEL_MAP_S_TO_S */
/*      GL_PIXEL_MAP_I_TO_R */
/*      GL_PIXEL_MAP_I_TO_G */
/*      GL_PIXEL_MAP_I_TO_B */
/*      GL_PIXEL_MAP_I_TO_A */
/*      GL_PIXEL_MAP_R_TO_R */
/*      GL_PIXEL_MAP_G_TO_G */
/*      GL_PIXEL_MAP_B_TO_B */
/*      GL_PIXEL_MAP_A_TO_A */

/* GetPointerTarget */
/*      GL_VERTEX_ARRAY_POINTER */
/*      GL_NORMAL_ARRAY_POINTER */
/*      GL_COLOR_ARRAY_POINTER */
/*      GL_INDEX_ARRAY_POINTER */
/*      GL_TEXTURE_COORD_ARRAY_POINTER */
/*      GL_EDGE_FLAG_ARRAY_POINTER */

/* GetTarget */
const uint GL_CURRENT_COLOR              = 0x0B00;
const uint GL_CURRENT_INDEX              = 0x0B01;
const uint GL_CURRENT_NORMAL             = 0x0B02;
const uint GL_CURRENT_TEXTURE_COORDS     = 0x0B03;
const uint GL_CURRENT_RASTER_COLOR       = 0x0B04;
const uint GL_CURRENT_RASTER_INDEX       = 0x0B05;
const uint GL_CURRENT_RASTER_TEXTURE_COORDS = 0x0B06;
const uint GL_CURRENT_RASTER_POSITION    = 0x0B07;
const uint GL_CURRENT_RASTER_POSITION_VALID = 0x0B08;
const uint GL_CURRENT_RASTER_DISTANCE    = 0x0B09;
const uint GL_POINT_SMOOTH               = 0x0B10;
const uint GL_POINT_SIZE                 = 0x0B11;
const uint GL_POINT_SIZE_RANGE           = 0x0B12;
const uint GL_POINT_SIZE_GRANULARITY     = 0x0B13;
const uint GL_LINE_SMOOTH                = 0x0B20;
const uint GL_LINE_WIDTH                 = 0x0B21;
const uint GL_LINE_WIDTH_RANGE           = 0x0B22;
const uint GL_LINE_WIDTH_GRANULARITY     = 0x0B23;
const uint GL_LINE_STIPPLE               = 0x0B24;
const uint GL_LINE_STIPPLE_PATTERN       = 0x0B25;
const uint GL_LINE_STIPPLE_REPEAT        = 0x0B26;
const uint GL_LIST_MODE                  = 0x0B30;
const uint GL_MAX_LIST_NESTING           = 0x0B31;
const uint GL_LIST_BASE                  = 0x0B32;
const uint GL_LIST_INDEX                 = 0x0B33;
const uint GL_POLYGON_MODE               = 0x0B40;
const uint GL_POLYGON_SMOOTH             = 0x0B41;
const uint GL_POLYGON_STIPPLE            = 0x0B42;
const uint GL_EDGE_FLAG                  = 0x0B43;
const uint GL_CULL_FACE                  = 0x0B44;
const uint GL_CULL_FACE_MODE             = 0x0B45;
const uint GL_FRONT_FACE                 = 0x0B46;
const uint GL_LIGHTING                   = 0x0B50;
const uint GL_LIGHT_MODEL_LOCAL_VIEWER   = 0x0B51;
const uint GL_LIGHT_MODEL_TWO_SIDE       = 0x0B52;
const uint GL_LIGHT_MODEL_AMBIENT        = 0x0B53;
const uint GL_SHADE_MODEL                = 0x0B54;
const uint GL_COLOR_MATERIAL_FACE        = 0x0B55;
const uint GL_COLOR_MATERIAL_PARAMETER   = 0x0B56;
const uint GL_COLOR_MATERIAL             = 0x0B57;
const uint GL_FOG                        = 0x0B60;
const uint GL_FOG_INDEX                  = 0x0B61;
const uint GL_FOG_DENSITY                = 0x0B62;
const uint GL_FOG_START                  = 0x0B63;
const uint GL_FOG_END                    = 0x0B64;
const uint GL_FOG_MODE                   = 0x0B65;
const uint GL_FOG_COLOR                  = 0x0B66;
const uint GL_DEPTH_RANGE                = 0x0B70;
const uint GL_DEPTH_TEST                 = 0x0B71;
const uint GL_DEPTH_WRITEMASK            = 0x0B72;
const uint GL_DEPTH_CLEAR_VALUE          = 0x0B73;
const uint GL_DEPTH_FUNC                 = 0x0B74;
const uint GL_ACCUM_CLEAR_VALUE          = 0x0B80;
const uint GL_STENCIL_TEST               = 0x0B90;
const uint GL_STENCIL_CLEAR_VALUE        = 0x0B91;
const uint GL_STENCIL_FUNC               = 0x0B92;
const uint GL_STENCIL_VALUE_MASK         = 0x0B93;
const uint GL_STENCIL_FAIL               = 0x0B94;
const uint GL_STENCIL_PASS_DEPTH_FAIL    = 0x0B95;
const uint GL_STENCIL_PASS_DEPTH_PASS    = 0x0B96;
const uint GL_STENCIL_REF                = 0x0B97;
const uint GL_STENCIL_WRITEMASK          = 0x0B98;
const uint GL_MATRIX_MODE                = 0x0BA0;
const uint GL_NORMALIZE                  = 0x0BA1;
const uint GL_VIEWPORT                   = 0x0BA2;
const uint GL_MODELVIEW_STACK_DEPTH      = 0x0BA3;
const uint GL_PROJECTION_STACK_DEPTH     = 0x0BA4;
const uint GL_TEXTURE_STACK_DEPTH        = 0x0BA5;
const uint GL_MODELVIEW_MATRIX           = 0x0BA6;
const uint GL_PROJECTION_MATRIX          = 0x0BA7;
const uint GL_TEXTURE_MATRIX             = 0x0BA8;
const uint GL_ATTRIB_STACK_DEPTH         = 0x0BB0;
const uint GL_CLIENT_ATTRIB_STACK_DEPTH  = 0x0BB1;
const uint GL_ALPHA_TEST                 = 0x0BC0;
const uint GL_ALPHA_TEST_FUNC            = 0x0BC1;
const uint GL_ALPHA_TEST_REF             = 0x0BC2;
const uint GL_DITHER                     = 0x0BD0;
const uint GL_BLEND_DST                  = 0x0BE0;
const uint GL_BLEND_SRC                  = 0x0BE1;
const uint GL_BLEND                      = 0x0BE2;
const uint GL_LOGIC_OP_MODE              = 0x0BF0;
const uint GL_INDEX_LOGIC_OP             = 0x0BF1;
const uint GL_COLOR_LOGIC_OP             = 0x0BF2;
const uint GL_AUX_BUFFERS                = 0x0C00;
const uint GL_DRAW_BUFFER                = 0x0C01;
const uint GL_READ_BUFFER                = 0x0C02;
const uint GL_SCISSOR_BOX                = 0x0C10;
const uint GL_SCISSOR_TEST               = 0x0C11;
const uint GL_INDEX_CLEAR_VALUE          = 0x0C20;
const uint GL_INDEX_WRITEMASK            = 0x0C21;
const uint GL_COLOR_CLEAR_VALUE          = 0x0C22;
const uint GL_COLOR_WRITEMASK            = 0x0C23;
const uint GL_INDEX_MODE                 = 0x0C30;
const uint GL_RGBA_MODE                  = 0x0C31;
const uint GL_DOUBLEBUFFER               = 0x0C32;
const uint GL_STEREO                     = 0x0C33;
const uint GL_RENDER_MODE                = 0x0C40;
const uint GL_PERSPECTIVE_CORRECTION_HINT= 0x0C50;
const uint GL_POINT_SMOOTH_HINT          = 0x0C51;
const uint GL_LINE_SMOOTH_HINT           = 0x0C52;
const uint GL_POLYGON_SMOOTH_HINT        = 0x0C53;
const uint GL_FOG_HINT                   = 0x0C54;
const uint GL_TEXTURE_GEN_S              = 0x0C60;
const uint GL_TEXTURE_GEN_T              = 0x0C61;
const uint GL_TEXTURE_GEN_R              = 0x0C62;
const uint GL_TEXTURE_GEN_Q              = 0x0C63;
const uint GL_PIXEL_MAP_I_TO_I           = 0x0C70;
const uint GL_PIXEL_MAP_S_TO_S           = 0x0C71;
const uint GL_PIXEL_MAP_I_TO_R           = 0x0C72;
const uint GL_PIXEL_MAP_I_TO_G           = 0x0C73;
const uint GL_PIXEL_MAP_I_TO_B           = 0x0C74;
const uint GL_PIXEL_MAP_I_TO_A           = 0x0C75;
const uint GL_PIXEL_MAP_R_TO_R           = 0x0C76;
const uint GL_PIXEL_MAP_G_TO_G           = 0x0C77;
const uint GL_PIXEL_MAP_B_TO_B           = 0x0C78;
const uint GL_PIXEL_MAP_A_TO_A           = 0x0C79;
const uint GL_PIXEL_MAP_I_TO_I_SIZE      = 0x0CB0;
const uint GL_PIXEL_MAP_S_TO_S_SIZE      = 0x0CB1;
const uint GL_PIXEL_MAP_I_TO_R_SIZE      = 0x0CB2;
const uint GL_PIXEL_MAP_I_TO_G_SIZE      = 0x0CB3;
const uint GL_PIXEL_MAP_I_TO_B_SIZE      = 0x0CB4;
const uint GL_PIXEL_MAP_I_TO_A_SIZE      = 0x0CB5;
const uint GL_PIXEL_MAP_R_TO_R_SIZE      = 0x0CB6;
const uint GL_PIXEL_MAP_G_TO_G_SIZE      = 0x0CB7;
const uint GL_PIXEL_MAP_B_TO_B_SIZE      = 0x0CB8;
const uint GL_PIXEL_MAP_A_TO_A_SIZE      = 0x0CB9;
const uint GL_UNPACK_SWAP_BYTES          = 0x0CF0;
const uint GL_UNPACK_LSB_FIRST           = 0x0CF1;
const uint GL_UNPACK_ROW_LENGTH          = 0x0CF2;
const uint GL_UNPACK_SKIP_ROWS           = 0x0CF3;
const uint GL_UNPACK_SKIP_PIXELS         = 0x0CF4;
const uint GL_UNPACK_ALIGNMENT           = 0x0CF5;
const uint GL_PACK_SWAP_BYTES            = 0x0D00;
const uint GL_PACK_LSB_FIRST             = 0x0D01;
const uint GL_PACK_ROW_LENGTH            = 0x0D02;
const uint GL_PACK_SKIP_ROWS             = 0x0D03;
const uint GL_PACK_SKIP_PIXELS           = 0x0D04;
const uint GL_PACK_ALIGNMENT             = 0x0D05;
const uint GL_MAP_COLOR                  = 0x0D10;
const uint GL_MAP_STENCIL                = 0x0D11;
const uint GL_INDEX_SHIFT                = 0x0D12;
const uint GL_INDEX_OFFSET               = 0x0D13;
const uint GL_RED_SCALE                  = 0x0D14;
const uint GL_RED_BIAS                   = 0x0D15;
const uint GL_ZOOM_X                     = 0x0D16;
const uint GL_ZOOM_Y                     = 0x0D17;
const uint GL_GREEN_SCALE                = 0x0D18;
const uint GL_GREEN_BIAS                 = 0x0D19;
const uint GL_BLUE_SCALE                 = 0x0D1A;
const uint GL_BLUE_BIAS                  = 0x0D1B;
const uint GL_ALPHA_SCALE                = 0x0D1C;
const uint GL_ALPHA_BIAS                 = 0x0D1D;
const uint GL_DEPTH_SCALE                = 0x0D1E;
const uint GL_DEPTH_BIAS                 = 0x0D1F;
const uint GL_MAX_EVAL_ORDER             = 0x0D30;
const uint GL_MAX_LIGHTS                 = 0x0D31;
const uint GL_MAX_CLIP_PLANES            = 0x0D32;
const uint GL_MAX_TEXTURE_SIZE           = 0x0D33;
const uint GL_MAX_PIXEL_MAP_TABLE        = 0x0D34;
const uint GL_MAX_ATTRIB_STACK_DEPTH     = 0x0D35;
const uint GL_MAX_MODELVIEW_STACK_DEPTH  = 0x0D36;
const uint GL_MAX_NAME_STACK_DEPTH       = 0x0D37;
const uint GL_MAX_PROJECTION_STACK_DEPTH = 0x0D38;
const uint GL_MAX_TEXTURE_STACK_DEPTH    = 0x0D39;
const uint GL_MAX_VIEWPORT_DIMS          = 0x0D3A;
const uint GL_MAX_CLIENT_ATTRIB_STACK_DEPTH = 0x0D3B;
const uint GL_SUBPIXEL_BITS              = 0x0D50;
const uint GL_INDEX_BITS                 = 0x0D51;
const uint GL_RED_BITS                   = 0x0D52;
const uint GL_GREEN_BITS                 = 0x0D53;
const uint GL_BLUE_BITS                  = 0x0D54;
const uint GL_ALPHA_BITS                 = 0x0D55;
const uint GL_DEPTH_BITS                 = 0x0D56;
const uint GL_STENCIL_BITS               = 0x0D57;
const uint GL_ACCUM_RED_BITS             = 0x0D58;
const uint GL_ACCUM_GREEN_BITS           = 0x0D59;
const uint GL_ACCUM_BLUE_BITS            = 0x0D5A;
const uint GL_ACCUM_ALPHA_BITS           = 0x0D5B;
const uint GL_NAME_STACK_DEPTH           = 0x0D70;
const uint GL_AUTO_NORMAL                = 0x0D80;
const uint GL_MAP1_COLOR_4               = 0x0D90;
const uint GL_MAP1_INDEX                 = 0x0D91;
const uint GL_MAP1_NORMAL                = 0x0D92;
const uint GL_MAP1_TEXTURE_COORD_1       = 0x0D93;
const uint GL_MAP1_TEXTURE_COORD_2       = 0x0D94;
const uint GL_MAP1_TEXTURE_COORD_3       = 0x0D95;
const uint GL_MAP1_TEXTURE_COORD_4       = 0x0D96;
const uint GL_MAP1_VERTEX_3              = 0x0D97;
const uint GL_MAP1_VERTEX_4              = 0x0D98;
const uint GL_MAP2_COLOR_4               = 0x0DB0;
const uint GL_MAP2_INDEX                 = 0x0DB1;
const uint GL_MAP2_NORMAL                = 0x0DB2;
const uint GL_MAP2_TEXTURE_COORD_1       = 0x0DB3;
const uint GL_MAP2_TEXTURE_COORD_2       = 0x0DB4;
const uint GL_MAP2_TEXTURE_COORD_3       = 0x0DB5;
const uint GL_MAP2_TEXTURE_COORD_4       = 0x0DB6;
const uint GL_MAP2_VERTEX_3              = 0x0DB7;
const uint GL_MAP2_VERTEX_4              = 0x0DB8;
const uint GL_MAP1_GRID_DOMAIN           = 0x0DD0;
const uint GL_MAP1_GRID_SEGMENTS         = 0x0DD1;
const uint GL_MAP2_GRID_DOMAIN           = 0x0DD2;
const uint GL_MAP2_GRID_SEGMENTS         = 0x0DD3;
const uint GL_TEXTURE_1D                 = 0x0DE0;
const uint GL_TEXTURE_2D                 = 0x0DE1;
const uint GL_FEEDBACK_BUFFER_POINTER    = 0x0DF0;
const uint GL_FEEDBACK_BUFFER_SIZE       = 0x0DF1;
const uint GL_FEEDBACK_BUFFER_TYPE       = 0x0DF2;
const uint GL_SELECTION_BUFFER_POINTER   = 0x0DF3;
const uint GL_SELECTION_BUFFER_SIZE      = 0x0DF4;
/*      GL_TEXTURE_BINDING_1D */
/*      GL_TEXTURE_BINDING_2D */
/*      GL_VERTEX_ARRAY */
/*      GL_NORMAL_ARRAY */
/*      GL_COLOR_ARRAY */
/*      GL_INDEX_ARRAY */
/*      GL_TEXTURE_COORD_ARRAY */
/*      GL_EDGE_FLAG_ARRAY */
/*      GL_VERTEX_ARRAY_SIZE */
/*      GL_VERTEX_ARRAY_TYPE */
/*      GL_VERTEX_ARRAY_STRIDE */
/*      GL_NORMAL_ARRAY_TYPE */
/*      GL_NORMAL_ARRAY_STRIDE */
/*      GL_COLOR_ARRAY_SIZE */
/*      GL_COLOR_ARRAY_TYPE */
/*      GL_COLOR_ARRAY_STRIDE */
/*      GL_INDEX_ARRAY_TYPE */
/*      GL_INDEX_ARRAY_STRIDE */
/*      GL_TEXTURE_COORD_ARRAY_SIZE */
/*      GL_TEXTURE_COORD_ARRAY_TYPE */
/*      GL_TEXTURE_COORD_ARRAY_STRIDE */
/*      GL_EDGE_FLAG_ARRAY_STRIDE */
/*      GL_POLYGON_OFFSET_FACTOR */
/*      GL_POLYGON_OFFSET_UNITS */

/* GetTextureParameter */
/*      GL_TEXTURE_MAG_FILTER */
/*      GL_TEXTURE_MIN_FILTER */
/*      GL_TEXTURE_WRAP_S */
/*      GL_TEXTURE_WRAP_T */
const uint GL_TEXTURE_WIDTH              = 0x1000;
const uint GL_TEXTURE_HEIGHT             = 0x1001;
const uint GL_TEXTURE_INTERNAL_FORMAT    = 0x1003;
const uint GL_TEXTURE_BORDER_COLOR       = 0x1004;
const uint GL_TEXTURE_BORDER             = 0x1005;
/*      GL_TEXTURE_RED_SIZE */
/*      GL_TEXTURE_GREEN_SIZE */
/*      GL_TEXTURE_BLUE_SIZE */
/*      GL_TEXTURE_ALPHA_SIZE */
/*      GL_TEXTURE_LUMINANCE_SIZE */
/*      GL_TEXTURE_INTENSITY_SIZE */
/*      GL_TEXTURE_PRIORITY */
/*      GL_TEXTURE_RESIDENT */

/* HintMode */
const uint GL_DONT_CARE                  = 0x1100;
const uint GL_FASTEST                    = 0x1101;
const uint GL_NICEST                     = 0x1102;

/* HintTarget */
/*      GL_PERSPECTIVE_CORRECTION_HINT */
/*      GL_POINT_SMOOTH_HINT */
/*      GL_LINE_SMOOTH_HINT */
/*      GL_POLYGON_SMOOTH_HINT */
/*      GL_FOG_HINT */
/*      GL_PHONG_HINT */

/* IndexPointerType */
/*      GL_SHORT */
/*      GL_INT */
/*      GL_FLOAT */
/*      GL_DOUBLE */

/* LightModelParameter */
/*      GL_LIGHT_MODEL_AMBIENT */
/*      GL_LIGHT_MODEL_LOCAL_VIEWER */
/*      GL_LIGHT_MODEL_TWO_SIDE */

/* LightName */
const uint GL_LIGHT0                     = 0x4000;
const uint GL_LIGHT1                     = 0x4001;
const uint GL_LIGHT2                     = 0x4002;
const uint GL_LIGHT3                     = 0x4003;
const uint GL_LIGHT4                     = 0x4004;
const uint GL_LIGHT5                     = 0x4005;
const uint GL_LIGHT6                     = 0x4006;
const uint GL_LIGHT7                     = 0x4007;

/* LightParameter */
const uint GL_AMBIENT                    = 0x1200;
const uint GL_DIFFUSE                    = 0x1201;
const uint GL_SPECULAR                   = 0x1202;
const uint GL_POSITION                   = 0x1203;
const uint GL_SPOT_DIRECTION             = 0x1204;
const uint GL_SPOT_EXPONENT              = 0x1205;
const uint GL_SPOT_CUTOFF                = 0x1206;
const uint GL_CONSTANT_ATTENUATION       = 0x1207;
const uint GL_LINEAR_ATTENUATION         = 0x1208;
const uint GL_QUADRATIC_ATTENUATION      = 0x1209;

/* InterleavedArrays */
/*      GL_V2F */
/*      GL_V3F */
/*      GL_C4UB_V2F */
/*      GL_C4UB_V3F */
/*      GL_C3F_V3F */
/*      GL_N3F_V3F */
/*      GL_C4F_N3F_V3F */
/*      GL_T2F_V3F */
/*      GL_T4F_V4F */
/*      GL_T2F_C4UB_V3F */
/*      GL_T2F_C3F_V3F */
/*      GL_T2F_N3F_V3F */
/*      GL_T2F_C4F_N3F_V3F */
/*      GL_T4F_C4F_N3F_V4F */

/* ListMode */
const uint GL_COMPILE                    = 0x1300;
const uint GL_COMPILE_AND_EXECUTE        = 0x1301;

/* ListNameType */
/*      GL_BYTE */
/*      GL_UNSIGNED_BYTE */
/*      GL_SHORT */
/*      GL_UNSIGNED_SHORT */
/*      GL_INT */
/*      GL_UNSIGNED_INT */
/*      GL_FLOAT */
/*      GL_2_BYTES */
/*      GL_3_BYTES */
/*      GL_4_BYTES */

/* LogicOp */
const uint GL_CLEAR                      = 0x1500;
const uint GL_AND                        = 0x1501;
const uint GL_AND_REVERSE                = 0x1502;
const uint GL_COPY                       = 0x1503;
const uint GL_AND_INVERTED               = 0x1504;
const uint GL_NOOP                       = 0x1505;
const uint GL_XOR                        = 0x1506;
const uint GL_OR                         = 0x1507;
const uint GL_NOR                        = 0x1508;
const uint GL_EQUIV                      = 0x1509;
const uint GL_INVERT                     = 0x150A;
const uint GL_OR_REVERSE                 = 0x150B;
const uint GL_COPY_INVERTED              = 0x150C;
const uint GL_OR_INVERTED                = 0x150D;
const uint GL_NAND                       = 0x150E;
const uint GL_SET                        = 0x150F;

/* MapTarget */
/*      GL_MAP1_COLOR_4 */
/*      GL_MAP1_INDEX */
/*      GL_MAP1_NORMAL */
/*      GL_MAP1_TEXTURE_COORD_1 */
/*      GL_MAP1_TEXTURE_COORD_2 */
/*      GL_MAP1_TEXTURE_COORD_3 */
/*      GL_MAP1_TEXTURE_COORD_4 */
/*      GL_MAP1_VERTEX_3 */
/*      GL_MAP1_VERTEX_4 */
/*      GL_MAP2_COLOR_4 */
/*      GL_MAP2_INDEX */
/*      GL_MAP2_NORMAL */
/*      GL_MAP2_TEXTURE_COORD_1 */
/*      GL_MAP2_TEXTURE_COORD_2 */
/*      GL_MAP2_TEXTURE_COORD_3 */
/*      GL_MAP2_TEXTURE_COORD_4 */
/*      GL_MAP2_VERTEX_3 */
/*      GL_MAP2_VERTEX_4 */

/* MaterialFace */
/*      GL_FRONT */
/*      GL_BACK */
/*      GL_FRONT_AND_BACK */

/* MaterialParameter */
const uint GL_EMISSION                   = 0x1600;
const uint GL_SHININESS                  = 0x1601;
const uint GL_AMBIENT_AND_DIFFUSE        = 0x1602;
const uint GL_COLOR_INDEXES              = 0x1603;
/*      GL_AMBIENT */
/*      GL_DIFFUSE */
/*      GL_SPECULAR */

/* MatrixMode */
const uint GL_MODELVIEW                  = 0x1700;
const uint GL_PROJECTION                 = 0x1701;
const uint GL_TEXTURE                    = 0x1702;

/* MeshMode1 */
/*      GL_POINT */
/*      GL_LINE */

/* MeshMode2 */
/*      GL_POINT */
/*      GL_LINE */
/*      GL_FILL */

/* NormalPointerType */
/*      GL_BYTE */
/*      GL_SHORT */
/*      GL_INT */
/*      GL_FLOAT */
/*      GL_DOUBLE */

/* PixelCopyType */
const uint GL_COLOR                      = 0x1800;
const uint GL_DEPTH                      = 0x1801;
const uint GL_STENCIL                    = 0x1802;

/* PixelFormat */
const uint GL_COLOR_INDEX                = 0x1900;
const uint GL_STENCIL_INDEX              = 0x1901;
const uint GL_DEPTH_COMPONENT            = 0x1902;
const uint GL_RED                        = 0x1903;
const uint GL_GREEN                      = 0x1904;
const uint GL_BLUE                       = 0x1905;
const uint GL_ALPHA                      = 0x1906;
const uint GL_RGB                        = 0x1907;
const uint GL_RGBA                       = 0x1908;
const uint GL_LUMINANCE                  = 0x1909;
const uint GL_LUMINANCE_ALPHA            = 0x190A;

/* PixelMap */
/*      GL_PIXEL_MAP_I_TO_I */
/*      GL_PIXEL_MAP_S_TO_S */
/*      GL_PIXEL_MAP_I_TO_R */
/*      GL_PIXEL_MAP_I_TO_G */
/*      GL_PIXEL_MAP_I_TO_B */
/*      GL_PIXEL_MAP_I_TO_A */
/*      GL_PIXEL_MAP_R_TO_R */
/*      GL_PIXEL_MAP_G_TO_G */
/*      GL_PIXEL_MAP_B_TO_B */
/*      GL_PIXEL_MAP_A_TO_A */

/* PixelStore */
/*      GL_UNPACK_SWAP_BYTES */
/*      GL_UNPACK_LSB_FIRST */
/*      GL_UNPACK_ROW_LENGTH */
/*      GL_UNPACK_SKIP_ROWS */
/*      GL_UNPACK_SKIP_PIXELS */
/*      GL_UNPACK_ALIGNMENT */
/*      GL_PACK_SWAP_BYTES */
/*      GL_PACK_LSB_FIRST */
/*      GL_PACK_ROW_LENGTH */
/*      GL_PACK_SKIP_ROWS */
/*      GL_PACK_SKIP_PIXELS */
/*      GL_PACK_ALIGNMENT */

/* PixelTransfer */
/*      GL_MAP_COLOR */
/*      GL_MAP_STENCIL */
/*      GL_INDEX_SHIFT */
/*      GL_INDEX_OFFSET */
/*      GL_RED_SCALE */
/*      GL_RED_BIAS */
/*      GL_GREEN_SCALE */
/*      GL_GREEN_BIAS */
/*      GL_BLUE_SCALE */
/*      GL_BLUE_BIAS */
/*      GL_ALPHA_SCALE */
/*      GL_ALPHA_BIAS */
/*      GL_DEPTH_SCALE */
/*      GL_DEPTH_BIAS */

/* PixelType */
const uint GL_BITMAP                     = 0x1A00;
/*      GL_BYTE */
/*      GL_UNSIGNED_BYTE */
/*      GL_SHORT */
/*      GL_UNSIGNED_SHORT */
/*      GL_INT */
/*      GL_UNSIGNED_INT */
/*      GL_FLOAT */

/* PolygonMode */
const uint GL_POINT                      = 0x1B00;
const uint GL_LINE                       = 0x1B01;
const uint GL_FILL                       = 0x1B02;

/* ReadBufferMode */
/*      GL_FRONT_LEFT */
/*      GL_FRONT_RIGHT */
/*      GL_BACK_LEFT */
/*      GL_BACK_RIGHT */
/*      GL_FRONT */
/*      GL_BACK */
/*      GL_LEFT */
/*      GL_RIGHT */
/*      GL_AUX0 */
/*      GL_AUX1 */
/*      GL_AUX2 */
/*      GL_AUX3 */

/* RenderingMode */
const uint GL_RENDER                     = 0x1C00;
const uint GL_FEEDBACK                   = 0x1C01;
const uint GL_SELECT                     = 0x1C02;

/* ShadingModel */
const uint GL_FLAT                       = 0x1D00;
const uint GL_SMOOTH                     = 0x1D01;


/* StencilFunction */
/*      GL_NEVER */
/*      GL_LESS */
/*      GL_EQUAL */
/*      GL_LEQUAL */
/*      GL_GREATER */
/*      GL_NOTEQUAL */
/*      GL_GEQUAL */
/*      GL_ALWAYS */

/* StencilOp */
/*      GL_ZERO */
const uint GL_KEEP                       = 0x1E00;
const uint GL_REPLACE                    = 0x1E01;
const uint GL_INCR                       = 0x1E02;
const uint GL_DECR                       = 0x1E03;
/*      GL_INVERT */

/* StringName */
const uint GL_VENDOR                     = 0x1F00;
const uint GL_RENDERER                   = 0x1F01;
const uint GL_VERSION                    = 0x1F02;
const uint GL_EXTENSIONS                 = 0x1F03;

/* TextureCoordName */
const uint GL_S                          = 0x2000;
const uint GL_T                          = 0x2001;
const uint GL_R                          = 0x2002;
const uint GL_Q                          = 0x2003;

/* TexCoordPointerType */
/*      GL_SHORT */
/*      GL_INT */
/*      GL_FLOAT */
/*      GL_DOUBLE */

/* TextureEnvMode */
const uint GL_MODULATE                   = 0x2100;
const uint GL_DECAL                      = 0x2101;
/*      GL_BLEND */
/*      GL_REPLACE */

/* TextureEnvParameter */
const uint GL_TEXTURE_ENV_MODE           = 0x2200;
const uint GL_TEXTURE_ENV_COLOR          = 0x2201;

/* TextureEnvTarget */
const uint GL_TEXTURE_ENV                = 0x2300;

/* TextureGenMode */
const uint GL_EYE_LINEAR                 = 0x2400;
const uint GL_OBJECT_LINEAR              = 0x2401;
const uint GL_SPHERE_MAP                 = 0x2402;

/* TextureGenParameter */
const uint GL_TEXTURE_GEN_MODE           = 0x2500;
const uint GL_OBJECT_PLANE               = 0x2501;
const uint GL_EYE_PLANE                  = 0x2502;

/* TextureMagFilter */
const uint GL_NEAREST                    = 0x2600;
const uint GL_LINEAR                     = 0x2601;

/* TextureMinFilter */
/*      GL_NEAREST */
/*      GL_LINEAR */
const uint GL_NEAREST_MIPMAP_NEAREST     = 0x2700;
const uint GL_LINEAR_MIPMAP_NEAREST      = 0x2701;
const uint GL_NEAREST_MIPMAP_LINEAR      = 0x2702;
const uint GL_LINEAR_MIPMAP_LINEAR       = 0x2703;

/* TextureParameterName */
const uint GL_TEXTURE_MAG_FILTER         = 0x2800;
const uint GL_TEXTURE_MIN_FILTER         = 0x2801;
const uint GL_TEXTURE_WRAP_S             = 0x2802;
const uint GL_TEXTURE_WRAP_T             = 0x2803;
/*      GL_TEXTURE_BORDER_COLOR */
/*      GL_TEXTURE_PRIORITY */

/* TextureTarget */
/*      GL_TEXTURE_1D */
/*      GL_TEXTURE_2D */
/*      GL_PROXY_TEXTURE_1D */
/*      GL_PROXY_TEXTURE_2D */

/* TextureWrapMode */
const uint GL_CLAMP                      = 0x2900;
const uint GL_REPEAT                     = 0x2901;

/* VertexPointerType */
/*      GL_SHORT */
/*      GL_INT */
/*      GL_FLOAT */
/*      GL_DOUBLE */

/* ClientAttribMask */
const uint GL_CLIENT_PIXEL_STORE_BIT     = 0x00000001;
const uint GL_CLIENT_VERTEX_ARRAY_BIT    = 0x00000002;
const uint GL_CLIENT_ALL_ATTRIB_BITS     = 0xffffffff;

/* polygon_offset */
const uint GL_POLYGON_OFFSET_FACTOR      = 0x8038;
const uint GL_POLYGON_OFFSET_UNITS       = 0x2A00;
const uint GL_POLYGON_OFFSET_POINT       = 0x2A01;
const uint GL_POLYGON_OFFSET_LINE        = 0x2A02;
const uint GL_POLYGON_OFFSET_FILL        = 0x8037;

/* texture */
const uint GL_ALPHA4                     = 0x803B;
const uint GL_ALPHA8                     = 0x803C;
const uint GL_ALPHA12                    = 0x803D;
const uint GL_ALPHA16                    = 0x803E;
const uint GL_LUMINANCE4                 = 0x803F;
const uint GL_LUMINANCE8                 = 0x8040;
const uint GL_LUMINANCE12                = 0x8041;
const uint GL_LUMINANCE16                = 0x8042;
const uint GL_LUMINANCE4_ALPHA4          = 0x8043;
const uint GL_LUMINANCE6_ALPHA2          = 0x8044;
const uint GL_LUMINANCE8_ALPHA8          = 0x8045;
const uint GL_LUMINANCE12_ALPHA4         = 0x8046;
const uint GL_LUMINANCE12_ALPHA12        = 0x8047;
const uint GL_LUMINANCE16_ALPHA16        = 0x8048;
const uint GL_INTENSITY                  = 0x8049;
const uint GL_INTENSITY4                 = 0x804A;
const uint GL_INTENSITY8                 = 0x804B;
const uint GL_INTENSITY12                = 0x804C;
const uint GL_INTENSITY16                = 0x804D;
const uint GL_R3_G3_B2                   = 0x2A10;
const uint GL_RGB4                       = 0x804F;
const uint GL_RGB5                       = 0x8050;
const uint GL_RGB8                       = 0x8051;
const uint GL_RGB10                      = 0x8052;
const uint GL_RGB12                      = 0x8053;
const uint GL_RGB16                      = 0x8054;
const uint GL_RGBA2                      = 0x8055;
const uint GL_RGBA4                      = 0x8056;
const uint GL_RGB5_A1                    = 0x8057;
const uint GL_RGBA8                      = 0x8058;
const uint GL_RGB10_A2                   = 0x8059;
const uint GL_RGBA12                     = 0x805A;
const uint GL_RGBA16                     = 0x805B;
const uint GL_TEXTURE_RED_SIZE           = 0x805C;
const uint GL_TEXTURE_GREEN_SIZE         = 0x805D;
const uint GL_TEXTURE_BLUE_SIZE          = 0x805E;
const uint GL_TEXTURE_ALPHA_SIZE         = 0x805F;
const uint GL_TEXTURE_LUMINANCE_SIZE     = 0x8060;
const uint GL_TEXTURE_INTENSITY_SIZE     = 0x8061;
const uint GL_PROXY_TEXTURE_1D           = 0x8063;
const uint GL_PROXY_TEXTURE_2D           = 0x8064;

/* texture_object */
const uint GL_TEXTURE_PRIORITY           = 0x8066;
const uint GL_TEXTURE_RESIDENT           = 0x8067;
const uint GL_TEXTURE_BINDING_1D         = 0x8068;
const uint GL_TEXTURE_BINDING_2D         = 0x8069;

/* vertex_array */
const uint GL_VERTEX_ARRAY               = 0x8074;
const uint GL_NORMAL_ARRAY               = 0x8075;
const uint GL_COLOR_ARRAY                = 0x8076;
const uint GL_INDEX_ARRAY                = 0x8077;
const uint GL_TEXTURE_COORD_ARRAY        = 0x8078;
const uint GL_EDGE_FLAG_ARRAY            = 0x8079;
const uint GL_VERTEX_ARRAY_SIZE          = 0x807A;
const uint GL_VERTEX_ARRAY_TYPE          = 0x807B;
const uint GL_VERTEX_ARRAY_STRIDE        = 0x807C;
const uint GL_NORMAL_ARRAY_TYPE          = 0x807E;
const uint GL_NORMAL_ARRAY_STRIDE        = 0x807F;
const uint GL_COLOR_ARRAY_SIZE           = 0x8081;
const uint GL_COLOR_ARRAY_TYPE           = 0x8082;
const uint GL_COLOR_ARRAY_STRIDE         = 0x8083;
const uint GL_INDEX_ARRAY_TYPE           = 0x8085;
const uint GL_INDEX_ARRAY_STRIDE         = 0x8086;
const uint GL_TEXTURE_COORD_ARRAY_SIZE   = 0x8088;
const uint GL_TEXTURE_COORD_ARRAY_TYPE   = 0x8089;
const uint GL_TEXTURE_COORD_ARRAY_STRIDE = 0x808A;
const uint GL_EDGE_FLAG_ARRAY_STRIDE     = 0x808C;
const uint GL_VERTEX_ARRAY_POINTER       = 0x808E;
const uint GL_NORMAL_ARRAY_POINTER       = 0x808F;
const uint GL_COLOR_ARRAY_POINTER        = 0x8090;
const uint GL_INDEX_ARRAY_POINTER        = 0x8091;
const uint GL_TEXTURE_COORD_ARRAY_POINTER= 0x8092;
const uint GL_EDGE_FLAG_ARRAY_POINTER    = 0x8093;
const uint GL_V2F                        = 0x2A20;
const uint GL_V3F                        = 0x2A21;
const uint GL_C4UB_V2F                   = 0x2A22;
const uint GL_C4UB_V3F                   = 0x2A23;
const uint GL_C3F_V3F                    = 0x2A24;
const uint GL_N3F_V3F                    = 0x2A25;
const uint GL_C4F_N3F_V3F                = 0x2A26;
const uint GL_T2F_V3F                    = 0x2A27;
const uint GL_T4F_V4F                    = 0x2A28;
const uint GL_T2F_C4UB_V3F               = 0x2A29;
const uint GL_T2F_C3F_V3F                = 0x2A2A;
const uint GL_T2F_N3F_V3F                = 0x2A2B;
const uint GL_T2F_C4F_N3F_V3F            = 0x2A2C;
const uint GL_T4F_C4F_N3F_V4F            = 0x2A2D;

/* Extensions */
const uint GL_EXT_vertex_array               = 1;
const uint GL_EXT_bgra                       = 1;
const uint GL_EXT_paletted_texture           = 1;
const uint GL_WIN_swap_hint                  = 1;
const uint GL_WIN_draw_range_elements        = 1;
// const uint GL_WIN_phong_shading              1
// const uint GL_WIN_specular_fog               1

/* EXT_vertex_array */
const uint GL_VERTEX_ARRAY_EXT           = 0x8074;
const uint GL_NORMAL_ARRAY_EXT           = 0x8075;
const uint GL_COLOR_ARRAY_EXT            = 0x8076;
const uint GL_INDEX_ARRAY_EXT            = 0x8077;
const uint GL_TEXTURE_COORD_ARRAY_EXT    = 0x8078;
const uint GL_EDGE_FLAG_ARRAY_EXT        = 0x8079;
const uint GL_VERTEX_ARRAY_SIZE_EXT      = 0x807A;
const uint GL_VERTEX_ARRAY_TYPE_EXT      = 0x807B;
const uint GL_VERTEX_ARRAY_STRIDE_EXT    = 0x807C;
const uint GL_VERTEX_ARRAY_COUNT_EXT     = 0x807D;
const uint GL_NORMAL_ARRAY_TYPE_EXT      = 0x807E;
const uint GL_NORMAL_ARRAY_STRIDE_EXT    = 0x807F;
const uint GL_NORMAL_ARRAY_COUNT_EXT     = 0x8080;
const uint GL_COLOR_ARRAY_SIZE_EXT       = 0x8081;
const uint GL_COLOR_ARRAY_TYPE_EXT       = 0x8082;
const uint GL_COLOR_ARRAY_STRIDE_EXT     = 0x8083;
const uint GL_COLOR_ARRAY_COUNT_EXT      = 0x8084;
const uint GL_INDEX_ARRAY_TYPE_EXT       = 0x8085;
const uint GL_INDEX_ARRAY_STRIDE_EXT     = 0x8086;
const uint GL_INDEX_ARRAY_COUNT_EXT      = 0x8087;
const uint GL_TEXTURE_COORD_ARRAY_SIZE_EXT   = 0x8088;
const uint GL_TEXTURE_COORD_ARRAY_TYPE_EXT   = 0x8089;
const uint GL_TEXTURE_COORD_ARRAY_STRIDE_EXT = 0x808A;
const uint GL_TEXTURE_COORD_ARRAY_COUNT_EXT  = 0x808B;
const uint GL_EDGE_FLAG_ARRAY_STRIDE_EXT = 0x808C;
const uint GL_EDGE_FLAG_ARRAY_COUNT_EXT  = 0x808D;
const uint GL_VERTEX_ARRAY_POINTER_EXT   = 0x808E;
const uint GL_NORMAL_ARRAY_POINTER_EXT   = 0x808F;
const uint GL_COLOR_ARRAY_POINTER_EXT    = 0x8090;
const uint GL_INDEX_ARRAY_POINTER_EXT    = 0x8091;
const uint GL_TEXTURE_COORD_ARRAY_POINTER_EXT = 0x8092;
const uint GL_EDGE_FLAG_ARRAY_POINTER_EXT = 0x8093;
const uint GL_DOUBLE_EXT                  = GL_DOUBLE;

/* EXT_bgra */
const uint GL_BGR_EXT                    = 0x80E0;
const uint GL_BGRA_EXT                   = 0x80E1;

/* EXT_paletted_texture */

/* These must match the GL_COLOR_TABLE_*_SGI enumerants */
const uint GL_COLOR_TABLE_FORMAT_EXT     = 0x80D8;
const uint GL_COLOR_TABLE_WIDTH_EXT      = 0x80D9;
const uint GL_COLOR_TABLE_RED_SIZE_EXT   = 0x80DA;
const uint GL_COLOR_TABLE_GREEN_SIZE_EXT = 0x80DB;
const uint GL_COLOR_TABLE_BLUE_SIZE_EXT  = 0x80DC;
const uint GL_COLOR_TABLE_ALPHA_SIZE_EXT = 0x80DD;
const uint GL_COLOR_TABLE_LUMINANCE_SIZE_EXT = 0x80DE;
const uint GL_COLOR_TABLE_INTENSITY_SIZE_EXT = 0x80DF;

const uint GL_COLOR_INDEX1_EXT           = 0x80E2;
const uint GL_COLOR_INDEX2_EXT           = 0x80E3;
const uint GL_COLOR_INDEX4_EXT           = 0x80E4;
const uint GL_COLOR_INDEX8_EXT           = 0x80E5;
const uint GL_COLOR_INDEX12_EXT          = 0x80E6;
const uint GL_COLOR_INDEX16_EXT          = 0x80E7;

/* WIN_draw_range_elements */
const uint GL_MAX_ELEMENTS_VERTICES_WIN  = 0x80E8;
const uint GL_MAX_ELEMENTS_INDICES_WIN   = 0x80E9;

/* WIN_phong_shading */
const uint GL_PHONG_WIN                  = 0x80EA;
const uint GL_PHONG_HINT_WIN             = 0x80EB;

/* WIN_specular_fog */
const uint GL_FOG_SPECULAR_TEXTURE_WIN   = 0x80EC;

/* For compatibility with OpenGL v1.0 */
const uint GL_LOGIC_OP = GL_INDEX_LOGIC_OP;
const uint GL_TEXTURE_COMPONENTS = GL_TEXTURE_INTERNAL_FORMAT;

/*************************************************************/

void /*APIENTRY*/glAccum (GLenum op, GLfloat value);
void /*APIENTRY*/glAlphaFunc (GLenum func, GLclampf ref);
GLboolean /*APIENTRY*/glAreTexturesResident (GLsizei n, GLuint *textures, GLboolean *residences);
void /*APIENTRY*/glArrayElement (GLint i);
void /*APIENTRY*/glBegin (GLenum mode);
void /*APIENTRY*/glBindTexture (GLenum target, GLuint texture);
void /*APIENTRY*/glBitmap (GLsizei width, GLsizei height, GLfloat xorig, GLfloat yorig, GLfloat xmove, GLfloat ymove, GLubyte *bitmap);
void /*APIENTRY*/glBlendFunc (GLenum sfactor, GLenum dfactor);
void /*APIENTRY*/glCallList (GLuint list);
void /*APIENTRY*/glCallLists (GLsizei n, GLenum type, GLvoid *lists);
void /*APIENTRY*/glClear (GLbitfield mask);
void /*APIENTRY*/glClearAccum (GLfloat red, GLfloat green, GLfloat blue, GLfloat alpha);
void /*APIENTRY*/glClearColor (GLclampf red, GLclampf green, GLclampf blue, GLclampf alpha);
void /*APIENTRY*/glClearDepth (GLclampd depth);
void /*APIENTRY*/glClearIndex (GLfloat c);
void /*APIENTRY*/glClearStencil (GLint s);
void /*APIENTRY*/glClipPlane (GLenum plane, GLdouble *equation);
void /*APIENTRY*/glColor3b (GLbyte red, GLbyte green, GLbyte blue);
void /*APIENTRY*/glColor3bv (GLbyte *v);
void /*APIENTRY*/glColor3d (GLdouble red, GLdouble green, GLdouble blue);
void /*APIENTRY*/glColor3dv (GLdouble *v);
void /*APIENTRY*/glColor3f (GLfloat red, GLfloat green, GLfloat blue);
void /*APIENTRY*/glColor3fv (GLfloat *v);
void /*APIENTRY*/glColor3i (GLint red, GLint green, GLint blue);
void /*APIENTRY*/glColor3iv (GLint *v);
void /*APIENTRY*/glColor3s (GLshort red, GLshort green, GLshort blue);
void /*APIENTRY*/glColor3sv (GLshort *v);
void /*APIENTRY*/glColor3ub (GLubyte red, GLubyte green, GLubyte blue);
void /*APIENTRY*/glColor3ubv (GLubyte *v);
void /*APIENTRY*/glColor3ui (GLuint red, GLuint green, GLuint blue);
void /*APIENTRY*/glColor3uiv (GLuint *v);
void /*APIENTRY*/glColor3us (GLushort red, GLushort green, GLushort blue);
void /*APIENTRY*/glColor3usv (GLushort *v);
void /*APIENTRY*/glColor4b (GLbyte red, GLbyte green, GLbyte blue, GLbyte alpha);
void /*APIENTRY*/glColor4bv (GLbyte *v);
void /*APIENTRY*/glColor4d (GLdouble red, GLdouble green, GLdouble blue, GLdouble alpha);
void /*APIENTRY*/glColor4dv (GLdouble *v);
void /*APIENTRY*/glColor4f (GLfloat red, GLfloat green, GLfloat blue, GLfloat alpha);
void /*APIENTRY*/glColor4fv (GLfloat *v);
void /*APIENTRY*/glColor4i (GLint red, GLint green, GLint blue, GLint alpha);
void /*APIENTRY*/glColor4iv (GLint *v);
void /*APIENTRY*/glColor4s (GLshort red, GLshort green, GLshort blue, GLshort alpha);
void /*APIENTRY*/glColor4sv (GLshort *v);
void /*APIENTRY*/glColor4ub (GLubyte red, GLubyte green, GLubyte blue, GLubyte alpha);
void /*APIENTRY*/glColor4ubv (GLubyte *v);
void /*APIENTRY*/glColor4ui (GLuint red, GLuint green, GLuint blue, GLuint alpha);
void /*APIENTRY*/glColor4uiv (GLuint *v);
void /*APIENTRY*/glColor4us (GLushort red, GLushort green, GLushort blue, GLushort alpha);
void /*APIENTRY*/glColor4usv (GLushort *v);
void /*APIENTRY*/glColorMask (GLboolean red, GLboolean green, GLboolean blue, GLboolean alpha);
void /*APIENTRY*/glColorMaterial (GLenum face, GLenum mode);
void /*APIENTRY*/glColorPointer (GLint size, GLenum type, GLsizei stride, GLvoid *pointer);
void /*APIENTRY*/glCopyPixels (GLint x, GLint y, GLsizei width, GLsizei height, GLenum type);
void /*APIENTRY*/glCopyTexImage1D (GLenum target, GLint level, GLenum internalFormat, GLint x, GLint y, GLsizei width, GLint border);
void /*APIENTRY*/glCopyTexImage2D (GLenum target, GLint level, GLenum internalFormat, GLint x, GLint y, GLsizei width, GLsizei height, GLint border);
void /*APIENTRY*/glCopyTexSubImage1D (GLenum target, GLint level, GLint xoffset, GLint x, GLint y, GLsizei width);
void /*APIENTRY*/glCopyTexSubImage2D (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint x, GLint y, GLsizei width, GLsizei height);
void /*APIENTRY*/glCullFace (GLenum mode);
void /*APIENTRY*/glDeleteLists (GLuint list, GLsizei range);
void /*APIENTRY*/glDeleteTextures (GLsizei n, GLuint *textures);
void /*APIENTRY*/glDepthFunc (GLenum func);
void /*APIENTRY*/glDepthMask (GLboolean flag);
void /*APIENTRY*/glDepthRange (GLclampd zNear, GLclampd zFar);
void /*APIENTRY*/glDisable (GLenum cap);
void /*APIENTRY*/glDisableClientState (GLenum array);
void /*APIENTRY*/glDrawArrays (GLenum mode, GLint first, GLsizei count);
void /*APIENTRY*/glDrawBuffer (GLenum mode);
void /*APIENTRY*/glDrawElements (GLenum mode, GLsizei count, GLenum type, GLvoid *indices);
void /*APIENTRY*/glDrawPixels (GLsizei width, GLsizei height, GLenum format, GLenum type, GLvoid *pixels);
void /*APIENTRY*/glEdgeFlag (GLboolean flag);
void /*APIENTRY*/glEdgeFlagPointer (GLsizei stride, GLvoid *pointer);
void /*APIENTRY*/glEdgeFlagv (GLboolean *flag);
void /*APIENTRY*/glEnable (GLenum cap);
void /*APIENTRY*/glEnableClientState (GLenum array);
void /*APIENTRY*/glEnd ();
void /*APIENTRY*/glEndList ();
void /*APIENTRY*/glEvalCoord1d (GLdouble u);
void /*APIENTRY*/glEvalCoord1dv (GLdouble *u);
void /*APIENTRY*/glEvalCoord1f (GLfloat u);
void /*APIENTRY*/glEvalCoord1fv (GLfloat *u);
void /*APIENTRY*/glEvalCoord2d (GLdouble u, GLdouble v);
void /*APIENTRY*/glEvalCoord2dv (GLdouble *u);
void /*APIENTRY*/glEvalCoord2f (GLfloat u, GLfloat v);
void /*APIENTRY*/glEvalCoord2fv (GLfloat *u);
void /*APIENTRY*/glEvalMesh1 (GLenum mode, GLint i1, GLint i2);
void /*APIENTRY*/glEvalMesh2 (GLenum mode, GLint i1, GLint i2, GLint j1, GLint j2);
void /*APIENTRY*/glEvalPoint1 (GLint i);
void /*APIENTRY*/glEvalPoint2 (GLint i, GLint j);
void /*APIENTRY*/glFeedbackBuffer (GLsizei size, GLenum type, GLfloat *buffer);
void /*APIENTRY*/glFinish ();
void /*APIENTRY*/glFlush ();
void /*APIENTRY*/glFogf (GLenum pname, GLfloat param);
void /*APIENTRY*/glFogfv (GLenum pname, GLfloat *params);
void /*APIENTRY*/glFogi (GLenum pname, GLint param);
void /*APIENTRY*/glFogiv (GLenum pname, GLint *params);
void /*APIENTRY*/glFrontFace (GLenum mode);
void /*APIENTRY*/glFrustum (GLdouble left, GLdouble right, GLdouble bottom, GLdouble top, GLdouble zNear, GLdouble zFar);
GLuint /*APIENTRY*/glGenLists (GLsizei range);
void /*APIENTRY*/glGenTextures (GLsizei n, GLuint *textures);
void /*APIENTRY*/glGetBooleanv (GLenum pname, GLboolean *params);
void /*APIENTRY*/glGetClipPlane (GLenum plane, GLdouble *equation);
void /*APIENTRY*/glGetDoublev (GLenum pname, GLdouble *params);
GLenum /*APIENTRY*/glGetError ();
void /*APIENTRY*/glGetFloatv (GLenum pname, GLfloat *params);
void /*APIENTRY*/glGetIntegerv (GLenum pname, GLint *params);
void /*APIENTRY*/glGetLightfv (GLenum light, GLenum pname, GLfloat *params);
void /*APIENTRY*/glGetLightiv (GLenum light, GLenum pname, GLint *params);
void /*APIENTRY*/glGetMapdv (GLenum target, GLenum query, GLdouble *v);
void /*APIENTRY*/glGetMapfv (GLenum target, GLenum query, GLfloat *v);
void /*APIENTRY*/glGetMapiv (GLenum target, GLenum query, GLint *v);
void /*APIENTRY*/glGetMaterialfv (GLenum face, GLenum pname, GLfloat *params);
void /*APIENTRY*/glGetMaterialiv (GLenum face, GLenum pname, GLint *params);
void /*APIENTRY*/glGetPixelMapfv (GLenum map, GLfloat *values);
void /*APIENTRY*/glGetPixelMapuiv (GLenum map, GLuint *values);
void /*APIENTRY*/glGetPixelMapusv (GLenum map, GLushort *values);
void /*APIENTRY*/glGetPointerv (GLenum pname, GLvoid* *params);
void /*APIENTRY*/glGetPolygonStipple (GLubyte *mask);
GLubyte * /*APIENTRY*/glGetString (GLenum name);
void /*APIENTRY*/glGetTexEnvfv (GLenum target, GLenum pname, GLfloat *params);
void /*APIENTRY*/glGetTexEnviv (GLenum target, GLenum pname, GLint *params);
void /*APIENTRY*/glGetTexGendv (GLenum coord, GLenum pname, GLdouble *params);
void /*APIENTRY*/glGetTexGenfv (GLenum coord, GLenum pname, GLfloat *params);
void /*APIENTRY*/glGetTexGeniv (GLenum coord, GLenum pname, GLint *params);
void /*APIENTRY*/glGetTexImage (GLenum target, GLint level, GLenum format, GLenum type, GLvoid *pixels);
void /*APIENTRY*/glGetTexLevelParameterfv (GLenum target, GLint level, GLenum pname, GLfloat *params);
void /*APIENTRY*/glGetTexLevelParameteriv (GLenum target, GLint level, GLenum pname, GLint *params);
void /*APIENTRY*/glGetTexParameterfv (GLenum target, GLenum pname, GLfloat *params);
void /*APIENTRY*/glGetTexParameteriv (GLenum target, GLenum pname, GLint *params);
void /*APIENTRY*/glHint (GLenum target, GLenum mode);
void /*APIENTRY*/glIndexMask (GLuint mask);
void /*APIENTRY*/glIndexPointer (GLenum type, GLsizei stride, GLvoid *pointer);
void /*APIENTRY*/glIndexd (GLdouble c);
void /*APIENTRY*/glIndexdv (GLdouble *c);
void /*APIENTRY*/glIndexf (GLfloat c);
void /*APIENTRY*/glIndexfv (GLfloat *c);
void /*APIENTRY*/glIndexi (GLint c);
void /*APIENTRY*/glIndexiv (GLint *c);
void /*APIENTRY*/glIndexs (GLshort c);
void /*APIENTRY*/glIndexsv (GLshort *c);
void /*APIENTRY*/glIndexub (GLubyte c);
void /*APIENTRY*/glIndexubv (GLubyte *c);
void /*APIENTRY*/glInitNames ();
void /*APIENTRY*/glInterleavedArrays (GLenum format, GLsizei stride, GLvoid *pointer);
GLboolean /*APIENTRY*/glIsEnabled (GLenum cap);
GLboolean /*APIENTRY*/glIsList (GLuint list);
GLboolean /*APIENTRY*/glIsTexture (GLuint texture);
void /*APIENTRY*/glLightModelf (GLenum pname, GLfloat param);
void /*APIENTRY*/glLightModelfv (GLenum pname, GLfloat *params);
void /*APIENTRY*/glLightModeli (GLenum pname, GLint param);
void /*APIENTRY*/glLightModeliv (GLenum pname, GLint *params);
void /*APIENTRY*/glLightf (GLenum light, GLenum pname, GLfloat param);
void /*APIENTRY*/glLightfv (GLenum light, GLenum pname, GLfloat *params);
void /*APIENTRY*/glLighti (GLenum light, GLenum pname, GLint param);
void /*APIENTRY*/glLightiv (GLenum light, GLenum pname, GLint *params);
void /*APIENTRY*/glLineStipple (GLint factor, GLushort pattern);
void /*APIENTRY*/glLineWidth (GLfloat width);
void /*APIENTRY*/glListBase (GLuint base);
void /*APIENTRY*/glLoadIdentity ();
void /*APIENTRY*/glLoadMatrixd (GLdouble *m);
void /*APIENTRY*/glLoadMatrixf (GLfloat *m);
void /*APIENTRY*/glLoadName (GLuint name);
void /*APIENTRY*/glLogicOp (GLenum opcode);
void /*APIENTRY*/glMap1d (GLenum target, GLdouble u1, GLdouble u2, GLint stride, GLint order, GLdouble *points);
void /*APIENTRY*/glMap1f (GLenum target, GLfloat u1, GLfloat u2, GLint stride, GLint order, GLfloat *points);
void /*APIENTRY*/glMap2d (GLenum target, GLdouble u1, GLdouble u2, GLint ustride, GLint uorder, GLdouble v1, GLdouble v2, GLint vstride, GLint vorder, GLdouble *points);
void /*APIENTRY*/glMap2f (GLenum target, GLfloat u1, GLfloat u2, GLint ustride, GLint uorder, GLfloat v1, GLfloat v2, GLint vstride, GLint vorder, GLfloat *points);
void /*APIENTRY*/glMapGrid1d (GLint un, GLdouble u1, GLdouble u2);
void /*APIENTRY*/glMapGrid1f (GLint un, GLfloat u1, GLfloat u2);
void /*APIENTRY*/glMapGrid2d (GLint un, GLdouble u1, GLdouble u2, GLint vn, GLdouble v1, GLdouble v2);
void /*APIENTRY*/glMapGrid2f (GLint un, GLfloat u1, GLfloat u2, GLint vn, GLfloat v1, GLfloat v2);
void /*APIENTRY*/glMaterialf (GLenum face, GLenum pname, GLfloat param);
void /*APIENTRY*/glMaterialfv (GLenum face, GLenum pname, GLfloat *params);
void /*APIENTRY*/glMateriali (GLenum face, GLenum pname, GLint param);
void /*APIENTRY*/glMaterialiv (GLenum face, GLenum pname, GLint *params);
void /*APIENTRY*/glMatrixMode (GLenum mode);
void /*APIENTRY*/glMultMatrixd (GLdouble *m);
void /*APIENTRY*/glMultMatrixf (GLfloat *m);
void /*APIENTRY*/glNewList (GLuint list, GLenum mode);
void /*APIENTRY*/glNormal3b (GLbyte nx, GLbyte ny, GLbyte nz);
void /*APIENTRY*/glNormal3bv (GLbyte *v);
void /*APIENTRY*/glNormal3d (GLdouble nx, GLdouble ny, GLdouble nz);
void /*APIENTRY*/glNormal3dv (GLdouble *v);
void /*APIENTRY*/glNormal3f (GLfloat nx, GLfloat ny, GLfloat nz);
void /*APIENTRY*/glNormal3fv (GLfloat *v);
void /*APIENTRY*/glNormal3i (GLint nx, GLint ny, GLint nz);
void /*APIENTRY*/glNormal3iv (GLint *v);
void /*APIENTRY*/glNormal3s (GLshort nx, GLshort ny, GLshort nz);
void /*APIENTRY*/glNormal3sv (GLshort *v);
void /*APIENTRY*/glNormalPointer (GLenum type, GLsizei stride, GLvoid *pointer);
void /*APIENTRY*/glOrtho (GLdouble left, GLdouble right, GLdouble bottom, GLdouble top, GLdouble zNear, GLdouble zFar);
void /*APIENTRY*/glPassThrough (GLfloat token);
void /*APIENTRY*/glPixelMapfv (GLenum map, GLsizei mapsize, GLfloat *values);
void /*APIENTRY*/glPixelMapuiv (GLenum map, GLsizei mapsize, GLuint *values);
void /*APIENTRY*/glPixelMapusv (GLenum map, GLsizei mapsize, GLushort *values);
void /*APIENTRY*/glPixelStoref (GLenum pname, GLfloat param);
void /*APIENTRY*/glPixelStorei (GLenum pname, GLint param);
void /*APIENTRY*/glPixelTransferf (GLenum pname, GLfloat param);
void /*APIENTRY*/glPixelTransferi (GLenum pname, GLint param);
void /*APIENTRY*/glPixelZoom (GLfloat xfactor, GLfloat yfactor);
void /*APIENTRY*/glPointSize (GLfloat size);
void /*APIENTRY*/glPolygonMode (GLenum face, GLenum mode);
void /*APIENTRY*/glPolygonOffset (GLfloat factor, GLfloat units);
void /*APIENTRY*/glPolygonStipple (GLubyte *mask);
void /*APIENTRY*/glPopAttrib ();
void /*APIENTRY*/glPopClientAttrib ();
void /*APIENTRY*/glPopMatrix ();
void /*APIENTRY*/glPopName ();
void /*APIENTRY*/glPrioritizeTextures (GLsizei n, GLuint *textures, GLclampf *priorities);
void /*APIENTRY*/glPushAttrib (GLbitfield mask);
void /*APIENTRY*/glPushClientAttrib (GLbitfield mask);
void /*APIENTRY*/glPushMatrix ();
void /*APIENTRY*/glPushName (GLuint name);
void /*APIENTRY*/glRasterPos2d (GLdouble x, GLdouble y);
void /*APIENTRY*/glRasterPos2dv (GLdouble *v);
void /*APIENTRY*/glRasterPos2f (GLfloat x, GLfloat y);
void /*APIENTRY*/glRasterPos2fv (GLfloat *v);
void /*APIENTRY*/glRasterPos2i (GLint x, GLint y);
void /*APIENTRY*/glRasterPos2iv (GLint *v);
void /*APIENTRY*/glRasterPos2s (GLshort x, GLshort y);
void /*APIENTRY*/glRasterPos2sv (GLshort *v);
void /*APIENTRY*/glRasterPos3d (GLdouble x, GLdouble y, GLdouble z);
void /*APIENTRY*/glRasterPos3dv (GLdouble *v);
void /*APIENTRY*/glRasterPos3f (GLfloat x, GLfloat y, GLfloat z);
void /*APIENTRY*/glRasterPos3fv (GLfloat *v);
void /*APIENTRY*/glRasterPos3i (GLint x, GLint y, GLint z);
void /*APIENTRY*/glRasterPos3iv (GLint *v);
void /*APIENTRY*/glRasterPos3s (GLshort x, GLshort y, GLshort z);
void /*APIENTRY*/glRasterPos3sv (GLshort *v);
void /*APIENTRY*/glRasterPos4d (GLdouble x, GLdouble y, GLdouble z, GLdouble w);
void /*APIENTRY*/glRasterPos4dv (GLdouble *v);
void /*APIENTRY*/glRasterPos4f (GLfloat x, GLfloat y, GLfloat z, GLfloat w);
void /*APIENTRY*/glRasterPos4fv (GLfloat *v);
void /*APIENTRY*/glRasterPos4i (GLint x, GLint y, GLint z, GLint w);
void /*APIENTRY*/glRasterPos4iv (GLint *v);
void /*APIENTRY*/glRasterPos4s (GLshort x, GLshort y, GLshort z, GLshort w);
void /*APIENTRY*/glRasterPos4sv (GLshort *v);
void /*APIENTRY*/glReadBuffer (GLenum mode);
void /*APIENTRY*/glReadPixels (GLint x, GLint y, GLsizei width, GLsizei height, GLenum format, GLenum type, GLvoid *pixels);
void /*APIENTRY*/glRectd (GLdouble x1, GLdouble y1, GLdouble x2, GLdouble y2);
void /*APIENTRY*/glRectdv (GLdouble *v1, GLdouble *v2);
void /*APIENTRY*/glRectf (GLfloat x1, GLfloat y1, GLfloat x2, GLfloat y2);
void /*APIENTRY*/glRectfv (GLfloat *v1, GLfloat *v2);
void /*APIENTRY*/glRecti (GLint x1, GLint y1, GLint x2, GLint y2);
void /*APIENTRY*/glRectiv (GLint *v1, GLint *v2);
void /*APIENTRY*/glRects (GLshort x1, GLshort y1, GLshort x2, GLshort y2);
void /*APIENTRY*/glRectsv (GLshort *v1, GLshort *v2);
GLint /*APIENTRY*/glRenderMode (GLenum mode);
void /*APIENTRY*/glRotated (GLdouble angle, GLdouble x, GLdouble y, GLdouble z);
void /*APIENTRY*/glRotatef (GLfloat angle, GLfloat x, GLfloat y, GLfloat z);
void /*APIENTRY*/glScaled (GLdouble x, GLdouble y, GLdouble z);
void /*APIENTRY*/glScalef (GLfloat x, GLfloat y, GLfloat z);
void /*APIENTRY*/glScissor (GLint x, GLint y, GLsizei width, GLsizei height);
void /*APIENTRY*/glSelectBuffer (GLsizei size, GLuint *buffer);
void /*APIENTRY*/glShadeModel (GLenum mode);
void /*APIENTRY*/glStencilFunc (GLenum func, GLint ref, GLuint mask);
void /*APIENTRY*/glStencilMask (GLuint mask);
void /*APIENTRY*/glStencilOp (GLenum fail, GLenum zfail, GLenum zpass);
void /*APIENTRY*/glTexCoord1d (GLdouble s);
void /*APIENTRY*/glTexCoord1dv (GLdouble *v);
void /*APIENTRY*/glTexCoord1f (GLfloat s);
void /*APIENTRY*/glTexCoord1fv (GLfloat *v);
void /*APIENTRY*/glTexCoord1i (GLint s);
void /*APIENTRY*/glTexCoord1iv (GLint *v);
void /*APIENTRY*/glTexCoord1s (GLshort s);
void /*APIENTRY*/glTexCoord1sv (GLshort *v);
void /*APIENTRY*/glTexCoord2d (GLdouble s, GLdouble t);
void /*APIENTRY*/glTexCoord2dv (GLdouble *v);
void /*APIENTRY*/glTexCoord2f (GLfloat s, GLfloat t);
void /*APIENTRY*/glTexCoord2fv (GLfloat *v);
void /*APIENTRY*/glTexCoord2i (GLint s, GLint t);
void /*APIENTRY*/glTexCoord2iv (GLint *v);
void /*APIENTRY*/glTexCoord2s (GLshort s, GLshort t);
void /*APIENTRY*/glTexCoord2sv (GLshort *v);
void /*APIENTRY*/glTexCoord3d (GLdouble s, GLdouble t, GLdouble r);
void /*APIENTRY*/glTexCoord3dv (GLdouble *v);
void /*APIENTRY*/glTexCoord3f (GLfloat s, GLfloat t, GLfloat r);
void /*APIENTRY*/glTexCoord3fv (GLfloat *v);
void /*APIENTRY*/glTexCoord3i (GLint s, GLint t, GLint r);
void /*APIENTRY*/glTexCoord3iv (GLint *v);
void /*APIENTRY*/glTexCoord3s (GLshort s, GLshort t, GLshort r);
void /*APIENTRY*/glTexCoord3sv (GLshort *v);
void /*APIENTRY*/glTexCoord4d (GLdouble s, GLdouble t, GLdouble r, GLdouble q);
void /*APIENTRY*/glTexCoord4dv (GLdouble *v);
void /*APIENTRY*/glTexCoord4f (GLfloat s, GLfloat t, GLfloat r, GLfloat q);
void /*APIENTRY*/glTexCoord4fv (GLfloat *v);
void /*APIENTRY*/glTexCoord4i (GLint s, GLint t, GLint r, GLint q);
void /*APIENTRY*/glTexCoord4iv (GLint *v);
void /*APIENTRY*/glTexCoord4s (GLshort s, GLshort t, GLshort r, GLshort q);
void /*APIENTRY*/glTexCoord4sv (GLshort *v);
void /*APIENTRY*/glTexCoordPointer (GLint size, GLenum type, GLsizei stride, GLvoid *pointer);
void /*APIENTRY*/glTexEnvf (GLenum target, GLenum pname, GLfloat param);
void /*APIENTRY*/glTexEnvfv (GLenum target, GLenum pname, GLfloat *params);
void /*APIENTRY*/glTexEnvi (GLenum target, GLenum pname, GLint param);
void /*APIENTRY*/glTexEnviv (GLenum target, GLenum pname, GLint *params);
void /*APIENTRY*/glTexGend (GLenum coord, GLenum pname, GLdouble param);
void /*APIENTRY*/glTexGendv (GLenum coord, GLenum pname, GLdouble *params);
void /*APIENTRY*/glTexGenf (GLenum coord, GLenum pname, GLfloat param);
void /*APIENTRY*/glTexGenfv (GLenum coord, GLenum pname, GLfloat *params);
void /*APIENTRY*/glTexGeni (GLenum coord, GLenum pname, GLint param);
void /*APIENTRY*/glTexGeniv (GLenum coord, GLenum pname, GLint *params);
void /*APIENTRY*/glTexImage1D (GLenum target, GLint level, GLint internalformat, GLsizei width, GLint border, GLenum format, GLenum type, GLvoid *pixels);
void /*APIENTRY*/glTexImage2D (GLenum target, GLint level, GLint internalformat, GLsizei width, GLsizei height, GLint border, GLenum format, GLenum type, GLvoid *pixels);
void /*APIENTRY*/glTexParameterf (GLenum target, GLenum pname, GLfloat param);
void /*APIENTRY*/glTexParameterfv (GLenum target, GLenum pname, GLfloat *params);
void /*APIENTRY*/glTexParameteri (GLenum target, GLenum pname, GLint param);
void /*APIENTRY*/glTexParameteriv (GLenum target, GLenum pname, GLint *params);
void /*APIENTRY*/glTexSubImage1D (GLenum target, GLint level, GLint xoffset, GLsizei width, GLenum format, GLenum type, GLvoid *pixels);
void /*APIENTRY*/glTexSubImage2D (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLsizei width, GLsizei height, GLenum format, GLenum type, GLvoid *pixels);
void /*APIENTRY*/glTranslated (GLdouble x, GLdouble y, GLdouble z);
void /*APIENTRY*/glTranslatef (GLfloat x, GLfloat y, GLfloat z);
void /*APIENTRY*/glVertex2d (GLdouble x, GLdouble y);
void /*APIENTRY*/glVertex2dv (GLdouble *v);
void /*APIENTRY*/glVertex2f (GLfloat x, GLfloat y);
void /*APIENTRY*/glVertex2fv (GLfloat *v);
void /*APIENTRY*/glVertex2i (GLint x, GLint y);
void /*APIENTRY*/glVertex2iv (GLint *v);
void /*APIENTRY*/glVertex2s (GLshort x, GLshort y);
void /*APIENTRY*/glVertex2sv (GLshort *v);
void /*APIENTRY*/glVertex3d (GLdouble x, GLdouble y, GLdouble z);
void /*APIENTRY*/glVertex3dv (GLdouble *v);
void /*APIENTRY*/glVertex3f (GLfloat x, GLfloat y, GLfloat z);
void /*APIENTRY*/glVertex3fv (GLfloat *v);
void /*APIENTRY*/glVertex3i (GLint x, GLint y, GLint z);
void /*APIENTRY*/glVertex3iv (GLint *v);
void /*APIENTRY*/glVertex3s (GLshort x, GLshort y, GLshort z);
void /*APIENTRY*/glVertex3sv (GLshort *v);
void /*APIENTRY*/glVertex4d (GLdouble x, GLdouble y, GLdouble z, GLdouble w);
void /*APIENTRY*/glVertex4dv (GLdouble *v);
void /*APIENTRY*/glVertex4f (GLfloat x, GLfloat y, GLfloat z, GLfloat w);
void /*APIENTRY*/glVertex4fv (GLfloat *v);
void /*APIENTRY*/glVertex4i (GLint x, GLint y, GLint z, GLint w);
void /*APIENTRY*/glVertex4iv (GLint *v);
void /*APIENTRY*/glVertex4s (GLshort x, GLshort y, GLshort z, GLshort w);
void /*APIENTRY*/glVertex4sv (GLshort *v);
void /*APIENTRY*/glVertexPointer (GLint size, GLenum type, GLsizei stride, GLvoid *pointer);
void /*APIENTRY*/glViewport (GLint x, GLint y, GLsizei width, GLsizei height);


/* EXT_vertex_array */
typedef void (* PFNGLARRAYELEMENTEXTPROC) (GLint i);
typedef void (* PFNGLDRAWARRAYSEXTPROC) (GLenum mode, GLint first, GLsizei count);
typedef void (* PFNGLVERTEXPOINTEREXTPROC) (GLint size, GLenum type, GLsizei stride, GLsizei count, GLvoid *pointer);
typedef void (* PFNGLNORMALPOINTEREXTPROC) (GLenum type, GLsizei stride, GLsizei count, GLvoid *pointer);
typedef void (* PFNGLCOLORPOINTEREXTPROC) (GLint size, GLenum type, GLsizei stride, GLsizei count, GLvoid *pointer);
typedef void (* PFNGLINDEXPOINTEREXTPROC) (GLenum type, GLsizei stride, GLsizei count, GLvoid *pointer);
typedef void (* PFNGLTEXCOORDPOINTEREXTPROC) (GLint size, GLenum type, GLsizei stride, GLsizei count, GLvoid *pointer);
typedef void (* PFNGLEDGEFLAGPOINTEREXTPROC) (GLsizei stride, GLsizei count, GLboolean *pointer);
typedef void (* PFNGLGETPOINTERVEXTPROC) (GLenum pname, GLvoid* *params);
typedef void (* PFNGLARRAYELEMENTARRAYEXTPROC)(GLenum mode, GLsizei count, GLvoid* pi);

/* WIN_draw_range_elements */
typedef void (* PFNGLDRAWRANGEELEMENTSWINPROC) (GLenum mode, GLuint start, GLuint end, GLsizei count, GLenum type, GLvoid *indices);

/* WIN_swap_hint */
typedef void (* PFNGLADDSWAPHINTRECTWINPROC)  (GLint x, GLint y, GLsizei width, GLsizei height);

/* EXT_paletted_texture */
typedef void (* PFNGLCOLORTABLEEXTPROC)
    (GLenum target, GLenum internalFormat, GLsizei width, GLenum format,
     GLenum type, GLvoid *data);
typedef void (* PFNGLCOLORSUBTABLEEXTPROC)
    (GLenum target, GLsizei start, GLsizei count, GLenum format,
     GLenum type, GLvoid *data);
typedef void (* PFNGLGETCOLORTABLEEXTPROC)
    (GLenum target, GLenum format, GLenum type, GLvoid *data);
typedef void (* PFNGLGETCOLORTABLEPARAMETERIVEXTPROC)
    (GLenum target, GLenum pname, GLint *params);
typedef void (* PFNGLGETCOLORTABLEPARAMETERFVEXTPROC)
    (GLenum target, GLenum pname, GLfloat *params);

//import openglu;
