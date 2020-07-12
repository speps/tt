import opengl;

version (Win32) {
	extern(Windows):
}
version (linux) {
	extern(C):
}

GLubyte* gluErrorString (
    GLenum   errCode);

wchar* gluErrorUnicodeStringEXT (
    GLenum   errCode);

GLubyte* gluGetString (
    GLenum   name);

void gluOrtho2D (
    GLdouble left, 
    GLdouble right, 
    GLdouble bottom, 
    GLdouble top);

void gluPerspective (
    GLdouble fovy, 
    GLdouble aspect, 
    GLdouble zNear, 
    GLdouble zFar);

void gluPickMatrix (
    GLdouble x, 
    GLdouble y, 
    GLdouble width, 
    GLdouble height, 
    GLint[4]    viewport);

void gluLookAt (
    GLdouble eyex, 
    GLdouble eyey, 
    GLdouble eyez, 
    GLdouble centerx, 
    GLdouble centery, 
    GLdouble centerz, 
    GLdouble upx, 
    GLdouble upy, 
    GLdouble upz);

int gluProject (
    GLdouble        objx, 
    GLdouble        objy, 
    GLdouble        objz,  
    GLdouble[16]    modelMatrix, 
    GLdouble[16]    projMatrix, 
    GLint[4]        viewport, 
    GLdouble        *winx, 
    GLdouble        *winy, 
    GLdouble        *winz);

int gluUnProject (
    GLdouble       winx, 
    GLdouble       winy, 
    GLdouble       winz, 
    GLdouble[16]   modelMatrix, 
    GLdouble[16]   projMatrix, 
    GLint[4]       viewport, 
    GLdouble       *objx, 
    GLdouble       *objy, 
    GLdouble       *objz);


int gluScaleImage (
    GLenum      format, 
    GLint       widthin, 
    GLint       heightin, 
    GLenum      typein, 
    void  *datain, 
    GLint       widthout, 
    GLint       heightout, 
    GLenum      typeout, 
    void        *dataout);


int gluBuild1DMipmaps (
    GLenum      target, 
    GLint       components, 
    GLint       width, 
    GLenum      format, 
    GLenum      type, 
    void  *data);

int gluBuild2DMipmaps (
    GLenum      target, 
    GLint       components, 
    GLint       width, 
    GLint       height, 
    GLenum      format, 
    GLenum      type, 
    void  *data);

struct GLUnurbs { }
struct GLUquadric { }
struct GLUtesselator { }

/* backwards compatibility: */
alias GLUnurbs GLUnurbsObj;
alias GLUquadric GLUquadricObj;
alias GLUtesselator GLUtesselatorObj;
alias GLUtesselator GLUtriangulatorObj;

GLUquadric* gluNewQuadric ();

void gluDeleteQuadric (
    GLUquadric          *state);

void gluQuadricNormals (
    GLUquadric          *quadObject, 
    GLenum              normals);

void gluQuadricTexture (
    GLUquadric          *quadObject, 
    GLboolean           textureCoords);

void gluQuadricOrientation (
    GLUquadric          *quadObject, 
    GLenum              orientation);

void gluQuadricDrawStyle (
    GLUquadric          *quadObject, 
    GLenum              drawStyle);

void gluCylinder (
    GLUquadric          *qobj, 
    GLdouble            baseRadius, 
    GLdouble            topRadius, 
    GLdouble            height, 
    GLint               slices, 
    GLint               stacks);

void gluDisk (
    GLUquadric          *qobj, 
    GLdouble            innerRadius, 
    GLdouble            outerRadius, 
    GLint               slices, 
    GLint               loops);

void gluPartialDisk (
    GLUquadric          *qobj, 
    GLdouble            innerRadius, 
    GLdouble            outerRadius, 
    GLint               slices, 
    GLint               loops, 
    GLdouble            startAngle, 
    GLdouble            sweepAngle);

void gluSphere (
    GLUquadric          *qobj, 
    GLdouble            radius, 
    GLint               slices, 
    GLint               stacks);

void gluQuadricCallback (
    GLUquadric          *qobj, 
    GLenum              which, 
    void                (* fn)());

GLUtesselator*  gluNewTess(          
    );

void  gluDeleteTess(       
    GLUtesselator       *tess );

void  gluTessBeginPolygon( 
    GLUtesselator       *tess,
    void                *polygon_data );

void  gluTessBeginContour( 
    GLUtesselator       *tess );

void  gluTessVertex(       
    GLUtesselator       *tess,
    GLdouble[3]         coords, 
    void                *data );

void  gluTessEndContour(   
    GLUtesselator       *tess );

void  gluTessEndPolygon(   
    GLUtesselator       *tess );

void  gluTessProperty(     
    GLUtesselator       *tess,
    GLenum              which, 
    GLdouble            value );
 
void  gluTessNormal(       
    GLUtesselator       *tess, 
    GLdouble            x,
    GLdouble            y, 
    GLdouble            z );

void  gluTessCallback(     
    GLUtesselator       *tess,
    GLenum              which, 
    void                ( *fn)());

void  gluGetTessProperty(  
    GLUtesselator       *tess,
    GLenum              which, 
    GLdouble            *value );
 
GLUnurbs* gluNewNurbsRenderer ();

void gluDeleteNurbsRenderer (
    GLUnurbs            *nobj);

void gluBeginSurface (
    GLUnurbs            *nobj);

void gluBeginCurve (
    GLUnurbs            *nobj);

void gluEndCurve (
    GLUnurbs            *nobj);

void gluEndSurface (
    GLUnurbs            *nobj);

void gluBeginTrim (
    GLUnurbs            *nobj);

void gluEndTrim (
    GLUnurbs            *nobj);

void gluPwlCurve (
    GLUnurbs            *nobj, 
    GLint               count, 
    GLfloat             *array, 
    GLint               stride, 
    GLenum              type);

void gluNurbsCurve (
    GLUnurbs            *nobj, 
    GLint               nknots, 
    GLfloat             *knot, 
    GLint               stride, 
    GLfloat             *ctlarray, 
    GLint               order, 
    GLenum              type);

void 
gluNurbsSurface(     
    GLUnurbs            *nobj, 
    GLint               sknot_count, 
    float               *sknot, 
    GLint               tknot_count, 
    GLfloat             *tknot, 
    GLint               s_stride, 
    GLint               t_stride, 
    GLfloat             *ctlarray, 
    GLint               sorder, 
    GLint               torder, 
    GLenum              type);

void 
gluLoadSamplingMatrices (
    GLUnurbs            *nobj, 
    GLfloat[16]     modelMatrix, 
    GLfloat[16]     projMatrix, 
    GLint[4]        viewport );

void 
gluNurbsProperty (
    GLUnurbs            *nobj, 
    GLenum              property, 
    GLfloat             value );

void 
gluGetNurbsProperty (
    GLUnurbs            *nobj, 
    GLenum              property, 
    GLfloat             *value );

void 
gluNurbsCallback (
    GLUnurbs            *nobj, 
    GLenum              which, 
    void                (* fn)() );


/****            function prototypes    ****/

/* gluQuadricCallback */
typedef void (* GLUquadricErrorProc) (GLenum);

/* gluTessCallback */
typedef void (* GLUtessBeginProc)        (GLenum);
typedef void (* GLUtessEdgeFlagProc)     (GLboolean);
typedef void (* GLUtessVertexProc)       (void *);
typedef void (* GLUtessEndProc)          ();
typedef void (* GLUtessErrorProc)        (GLenum);
typedef void (* GLUtessCombineProc)      (GLdouble[3],
                                                  void*[4], 
                                                  GLfloat[4],
                                                  void** );
typedef void (* GLUtessBeginDataProc)    (GLenum, void *);
typedef void (* GLUtessEdgeFlagDataProc) (GLboolean, void *);
typedef void (* GLUtessVertexDataProc)   (void *, void *);
typedef void (* GLUtessEndDataProc)      (void *);
typedef void (* GLUtessErrorDataProc)    (GLenum, void *);
typedef void (* GLUtessCombineDataProc)  (GLdouble[3],
                                                  void*[4], 
                                                  GLfloat[4],
                                                  void**,
                                                  void* );

/* gluNurbsCallback */
typedef void (* GLUnurbsErrorProc)   (GLenum);


/****           Generic constants               ****/

/* Version */
const int GLU_VERSION_1_1               = 1;
const int GLU_VERSION_1_2               = 1;

/* Errors: (return value 0 = no error) */
const int GLU_INVALID_ENUM      = 100900;
const int GLU_INVALID_VALUE     = 100901;
const int GLU_OUT_OF_MEMORY     = 100902;
const int GLU_INCOMPATIBLE_GL_VERSION   = 100903;

/* StringName */
const int GLU_VERSION           = 100800;
const int GLU_EXTENSIONS        = 100801;

/* Boolean */
const int GLU_TRUE              = GL_TRUE;
const int GLU_FALSE             = GL_FALSE;


/****           Quadric constants               ****/

/* QuadricNormal */
const int GLU_SMOOTH            = 100000;
const int GLU_FLAT              = 100001;
const int GLU_NONE              = 100002;

/* QuadricDrawStyle */
const int GLU_POINT             = 100010;
const int GLU_LINE              = 100011;
const int GLU_FILL              = 100012;
const int GLU_SILHOUETTE        = 100013;

/* QuadricOrientation */
const int GLU_OUTSIDE           = 100020;
const int GLU_INSIDE            = 100021;

/*  types: */
/*      GLU_ERROR               100103 */


/****           Tesselation constants           ****/

const real GLU_TESS_MAX_COORD            = 1.0e150;

/* TessProperty */
const int GLU_TESS_WINDING_RULE         = 100140;
const int GLU_TESS_BOUNDARY_ONLY        = 100141;
const int GLU_TESS_TOLERANCE            = 100142;

/* TessWinding */
const int GLU_TESS_WINDING_ODD          = 100130;
const int GLU_TESS_WINDING_NONZERO      = 100131;
const int GLU_TESS_WINDING_POSITIVE     = 100132;
const int GLU_TESS_WINDING_NEGATIVE     = 100133;
const int GLU_TESS_WINDING_ABS_GEQ_TWO  = 100134;

/* TessCallback */
const int GLU_TESS_BEGIN        = 100100;  /* void (*)(GLenum    type)  */
const int GLU_TESS_VERTEX       = 100101;  /* void (*)(void      *data) */
const int GLU_TESS_END          = 100102;  /* void (*)(void)            */
const int GLU_TESS_ERROR        = 100103;  /* void (*)(GLenum    errno) */
const int GLU_TESS_EDGE_FLAG    = 100104;  /* void (*)(GLboolean boundaryEdge)  */
const int GLU_TESS_COMBINE      = 100105;  /* void (*)(GLdouble  coords[3],
                                                            void      *data[4],
                                                            GLfloat   weight[4],
                                                            void      **dataOut)     */
const int GLU_TESS_BEGIN_DATA   = 100106;  /* void (*)(GLenum    type,  
                                                            void      *polygon_data) */
const int GLU_TESS_VERTEX_DATA  = 100107;  /* void (*)(void      *data, 
                                                            void      *polygon_data) */
const int GLU_TESS_END_DATA     = 100108;  /* void (*)(void      *polygon_data) */
const int GLU_TESS_ERROR_DATA   = 100109;  /* void (*)(GLenum    errno, 
                                                            void      *polygon_data) */
const int GLU_TESS_EDGE_FLAG_DATA = 100110;  /* void (*)(GLboolean boundaryEdge,
                                                            void      *polygon_data) */
const int GLU_TESS_COMBINE_DATA = 100111; /* void (*)(GLdouble  coords[3],
                                                            void      *data[4],
                                                            GLfloat   weight[4],
                                                            void      **dataOut,
                                                            void      *polygon_data) */

/* TessError */
const int GLU_TESS_ERROR1   = 100151;
const int GLU_TESS_ERROR2   = 100152;
const int GLU_TESS_ERROR3   = 100153;
const int GLU_TESS_ERROR4   = 100154;
const int GLU_TESS_ERROR5   = 100155;
const int GLU_TESS_ERROR6   = 100156;
const int GLU_TESS_ERROR7   = 100157;
const int GLU_TESS_ERROR8   = 100158;

const int GLU_TESS_MISSING_BEGIN_POLYGON = GLU_TESS_ERROR1;
const int GLU_TESS_MISSING_BEGIN_CONTOUR = GLU_TESS_ERROR2;
const int GLU_TESS_MISSING_END_POLYGON   = GLU_TESS_ERROR3;
const int GLU_TESS_MISSING_END_CONTOUR   = GLU_TESS_ERROR4;
const int GLU_TESS_COORD_TOO_LARGE       = GLU_TESS_ERROR5;
const int GLU_TESS_NEED_COMBINE_CALLBACK = GLU_TESS_ERROR6;

/****           NURBS constants                 ****/

/* NurbsProperty */
const int GLU_AUTO_LOAD_MATRIX   = 100200;
const int GLU_CULLING            = 100201;
const int GLU_SAMPLING_TOLERANCE = 100203;
const int GLU_DISPLAY_MODE       = 100204;
const int GLU_PARAMETRIC_TOLERANCE      = 100202;
const int GLU_SAMPLING_METHOD           = 100205;
const int GLU_U_STEP                    = 100206;
const int GLU_V_STEP                    = 100207;

/* NurbsSampling */
const int GLU_PATH_LENGTH               = 100215;
const int GLU_PARAMETRIC_ERROR          = 100216;
const int GLU_DOMAIN_DISTANCE           = 100217;


/* NurbsTrim */
const int GLU_MAP1_TRIM_2       = 100210;
const int GLU_MAP1_TRIM_3       = 100211;

/* NurbsDisplay */
/*      GLU_FILL                100012 */
const int GLU_OUTLINE_POLYGON   = 100240;
const int GLU_OUTLINE_PATCH     = 100241;

/* NurbsCallback */
/*      GLU_ERROR               100103 */

/* NurbsErrors */
const int GLU_NURBS_ERROR1      = 100251;
const int GLU_NURBS_ERROR2      = 100252;
const int GLU_NURBS_ERROR3      = 100253;
const int GLU_NURBS_ERROR4      = 100254;
const int GLU_NURBS_ERROR5      = 100255;
const int GLU_NURBS_ERROR6      = 100256;
const int GLU_NURBS_ERROR7      = 100257;
const int GLU_NURBS_ERROR8      = 100258;
const int GLU_NURBS_ERROR9      = 100259;
const int GLU_NURBS_ERROR10     = 100260;
const int GLU_NURBS_ERROR11     = 100261;
const int GLU_NURBS_ERROR12     = 100262;
const int GLU_NURBS_ERROR13     = 100263;
const int GLU_NURBS_ERROR14     = 100264;
const int GLU_NURBS_ERROR15     = 100265;
const int GLU_NURBS_ERROR16     = 100266;
const int GLU_NURBS_ERROR17     = 100267;
const int GLU_NURBS_ERROR18     = 100268;
const int GLU_NURBS_ERROR19     = 100269;
const int GLU_NURBS_ERROR20     = 100270;
const int GLU_NURBS_ERROR21     = 100271;
const int GLU_NURBS_ERROR22     = 100272;
const int GLU_NURBS_ERROR23     = 100273;
const int GLU_NURBS_ERROR24     = 100274;
const int GLU_NURBS_ERROR25     = 100275;
const int GLU_NURBS_ERROR26     = 100276;
const int GLU_NURBS_ERROR27     = 100277;
const int GLU_NURBS_ERROR28     = 100278;
const int GLU_NURBS_ERROR29     = 100279;
const int GLU_NURBS_ERROR30     = 100280;
const int GLU_NURBS_ERROR31     = 100281;
const int GLU_NURBS_ERROR32     = 100282;
const int GLU_NURBS_ERROR33     = 100283;
const int GLU_NURBS_ERROR34     = 100284;
const int GLU_NURBS_ERROR35     = 100285;
const int GLU_NURBS_ERROR36     = 100286;
const int GLU_NURBS_ERROR37     = 100287;

/****           Backwards compatibility for old tesselator           ****/

void   gluBeginPolygon( GLUtesselator *tess );

void   gluNextContour(  GLUtesselator *tess, 
                                 GLenum        type );

void   gluEndPolygon(   GLUtesselator *tess );

/* Contours types -- obsolete! */
const int GLU_CW        = 100120;
const int GLU_CCW       = 100121;
const int GLU_INTERIOR  = 100122;
const int GLU_EXTERIOR  = 100123;
const int GLU_UNKNOWN   = 100124;

/* Names without "TESS_" prefix */
const int GLU_BEGIN     = GLU_TESS_BEGIN;
const int GLU_VERTEX    = GLU_TESS_VERTEX;
const int GLU_END       = GLU_TESS_END;
const int GLU_ERROR     = GLU_TESS_ERROR;
const int GLU_EDGE_FLAG = GLU_TESS_EDGE_FLAG;

