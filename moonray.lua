local ffi = require("ffi")
ffi.cdef [[
    typedef struct Vector2 {
        float x;
        float y;
    } Vector2;
    typedef struct Vector3 {
        float x;
        float y;
        float z;
    } Vector3;
    typedef struct Vector4 {
        float x;
        float y;
        float z;
        float w;
    } Vector4;
    typedef Vector4 Quaternion;
    typedef struct Matrix {
        float m0, m4, m8, m12;
        float m1, m5, m9, m13;
        float m2, m6, m10, m14;
        float m3, m7, m11, m15;
    } Matrix;
    typedef struct Color {
        unsigned char r;
        unsigned char g;
        unsigned char b;
        unsigned char a;
    } Color;
    typedef struct Rectangle {
        float x;
        float y;
        float width;
        float height;
    } Rectangle;
    typedef struct Image {
        void *data;
        int width;
        int height;
        int mipmaps;
        int format;
    } Image;
    typedef struct Texture {
        unsigned int id;
        int width;
        int height;
        int mipmaps;
        int format;
    } Texture;
    typedef Texture Texture2D;
    typedef Texture TextureCubemap;
    typedef struct RenderTexture {
        unsigned int id;
        Texture texture;
        Texture depth;
    } RenderTexture;
    typedef RenderTexture RenderTexture2D;
    typedef struct NPatchInfo {
        Rectangle source;
        int left;
        int top;
        int right;
        int bottom;
        int layout;
    } NPatchInfo;
    typedef struct GlyphInfo {
        int value;
        int offsetX;
        int offsetY;
        int advanceX;
        Image image;
    } GlyphInfo;
    typedef struct Font {
        int baseSize;
        int glyphCount;
        int glyphPadding;
        Texture2D texture;
        Rectangle *recs;
        GlyphInfo *glyphs;
    } Font;
    typedef struct Camera3D {
        Vector3 position;
        Vector3 target;
        Vector3 up;
        float fovy;
        int projection;
    } Camera3D;
    typedef Camera3D Camera;
    typedef struct Camera2D {
        Vector2 offset;
        Vector2 target;
        float rotation;
        float zoom;
    } Camera2D;
    typedef struct Mesh {
        int vertexCount;
        int triangleCount;
        float *vertices;
        float *texcoords;
        float *texcoords2;
        float *normals;
        float *tangents;
        unsigned char *colors;
        unsigned short *indices;
        float *animVertices;
        float *animNormals;
        unsigned char *boneIds;
        float *boneWeights;
        unsigned int vaoId;
        unsigned int *vboId;
    } Mesh;
    typedef struct Shader {
        unsigned int id;
        int *locs;
    } Shader;
    typedef struct MaterialMap {
        Texture2D texture;
        Color color;
        float value;
    } MaterialMap;
    typedef struct Material {
        Shader shader;
        MaterialMap *maps;
        float params[4];
    } Material;
    typedef struct Transform {
        Vector3 translation;
        Quaternion rotation;
        Vector3 scale;
    } Transform;
    typedef struct BoneInfo {
        char name[32];
        int parent;
    } BoneInfo;
    typedef struct Model {
        Matrix transform;
        int meshCount;
        int materialCount;
        Mesh *meshes;
        Material *materials;
        int *meshMaterial;
        int boneCount;
        BoneInfo *bones;
        Transform *bindPose;
    } Model;
    typedef struct ModelAnimation {
        int boneCount;
        int frameCount;
        BoneInfo *bones;
        Transform **framePoses;
    } ModelAnimation;
    typedef struct Ray {
        Vector3 position;
        Vector3 direction;
    } Ray;
    typedef struct RayCollision {
        bool hit;
        float distance;
        Vector3 point;
        Vector3 normal;
    } RayCollision;
    typedef struct BoundingBox {
        Vector3 min;
        Vector3 max;
    } BoundingBox;
    typedef struct Wave {
        unsigned int frameCount;
        unsigned int sampleRate;
        unsigned int sampleSize;
        unsigned int channels;
        void *data;
    } Wave;
    typedef struct rAudioBuffer rAudioBuffer;
    typedef struct rAudioProcessor rAudioProcessor;
    typedef struct AudioStream {
        rAudioBuffer *buffer;
        rAudioProcessor *processor;
        unsigned int sampleRate;
        unsigned int sampleSize;
        unsigned int channels;
    } AudioStream;
    typedef struct Sound {
        AudioStream stream;
        unsigned int frameCount;
    } Sound;
    typedef struct Music {
        AudioStream stream;
        unsigned int frameCount;
        bool looping;
        int ctxType;
        void *ctxData;
    } Music;
    typedef struct VrDeviceInfo {
        int hResolution;
        int vResolution;
        float hScreenSize;
        float vScreenSize;
        float vScreenCenter;
        float eyeToScreenDistance;
        float lensSeparationDistance;
        float interpupillaryDistance;
        float lensDistortionValues[4];
        float chromaAbCorrection[4];
    } VrDeviceInfo;
    typedef struct VrStereoConfig {
        Matrix projection[2];
        Matrix viewOffset[2];
        float leftLensCenter[2];
        float rightLensCenter[2];
        float leftScreenCenter[2];
        float rightScreenCenter[2];
        float scale[2];
        float scaleIn[2];
    } VrStereoConfig;
    typedef struct FilePathList {
        unsigned int capacity;
        unsigned int count;
        char **paths;
    } FilePathList;
    typedef struct float3 {
        float v[3];
    } float3;
    typedef struct float16 {
        float v[16];
    } float16;
    typedef enum {
        FLAG_VSYNC_HINT         = 0x00000040,
        FLAG_FULLSCREEN_MODE    = 0x00000002,
        FLAG_WINDOW_RESIZABLE   = 0x00000004,
        FLAG_WINDOW_UNDECORATED = 0x00000008,
        FLAG_WINDOW_HIDDEN      = 0x00000080,
        FLAG_WINDOW_MINIMIZED   = 0x00000200,
        FLAG_WINDOW_MAXIMIZED   = 0x00000400,
        FLAG_WINDOW_UNFOCUSED   = 0x00000800,
        FLAG_WINDOW_TOPMOST     = 0x00001000,
        FLAG_WINDOW_ALWAYS_RUN  = 0x00000100,
        FLAG_WINDOW_TRANSPARENT = 0x00000010,
        FLAG_WINDOW_HIGHDPI     = 0x00002000,
        FLAG_WINDOW_MOUSE_PASSTHROUGH = 0x00004000,
        FLAG_MSAA_4X_HINT       = 0x00000020,
        FLAG_INTERLACED_HINT    = 0x00010000
    } ConfigFlags;
    typedef enum {
        LOG_ALL = 0,
        LOG_TRACE,
        LOG_DEBUG,
        LOG_INFO,
        LOG_WARNING,
        LOG_ERROR,
        LOG_FATAL,
        LOG_NONE
    } TraceLogLevel;
    typedef enum {
        KEY_NULL            = 0,
        KEY_APOSTROPHE      = 39,
        KEY_COMMA           = 44,
        KEY_MINUS           = 45,
        KEY_PERIOD          = 46,
        KEY_SLASH           = 47,
        KEY_ZERO            = 48,
        KEY_ONE             = 49,
        KEY_TWO             = 50,
        KEY_THREE           = 51,
        KEY_FOUR            = 52,
        KEY_FIVE            = 53,
        KEY_SIX             = 54,
        KEY_SEVEN           = 55,
        KEY_EIGHT           = 56,
        KEY_NINE            = 57,
        KEY_SEMICOLON       = 59,
        KEY_EQUAL           = 61,
        KEY_A               = 65,
        KEY_B               = 66,
        KEY_C               = 67,
        KEY_D               = 68,
        KEY_E               = 69,
        KEY_F               = 70,
        KEY_G               = 71,
        KEY_H               = 72,
        KEY_I               = 73,
        KEY_J               = 74,
        KEY_K               = 75,
        KEY_L               = 76,
        KEY_M               = 77,
        KEY_N               = 78,
        KEY_O               = 79,
        KEY_P               = 80,
        KEY_Q               = 81,
        KEY_R               = 82,
        KEY_S               = 83,
        KEY_T               = 84,
        KEY_U               = 85,
        KEY_V               = 86,
        KEY_W               = 87,
        KEY_X               = 88,
        KEY_Y               = 89,
        KEY_Z               = 90,
        KEY_LEFT_BRACKET    = 91,
        KEY_BACKSLASH       = 92,
        KEY_RIGHT_BRACKET   = 93,
        KEY_GRAVE           = 96,
        KEY_SPACE           = 32,
        KEY_ESCAPE          = 256,
        KEY_ENTER           = 257,
        KEY_TAB             = 258,
        KEY_BACKSPACE       = 259,
        KEY_INSERT          = 260,
        KEY_DELETE          = 261,
        KEY_RIGHT           = 262,
        KEY_LEFT            = 263,
        KEY_DOWN            = 264,
        KEY_UP              = 265,
        KEY_PAGE_UP         = 266,
        KEY_PAGE_DOWN       = 267,
        KEY_HOME            = 268,
        KEY_END             = 269,
        KEY_CAPS_LOCK       = 280,
        KEY_SCROLL_LOCK     = 281,
        KEY_NUM_LOCK        = 282,
        KEY_PRINT_SCREEN    = 283,
        KEY_PAUSE           = 284,
        KEY_F1              = 290,
        KEY_F2              = 291,
        KEY_F3              = 292,
        KEY_F4              = 293,
        KEY_F5              = 294,
        KEY_F6              = 295,
        KEY_F7              = 296,
        KEY_F8              = 297,
        KEY_F9              = 298,
        KEY_F10             = 299,
        KEY_F11             = 300,
        KEY_F12             = 301,
        KEY_LEFT_SHIFT      = 340,
        KEY_LEFT_CONTROL    = 341,
        KEY_LEFT_ALT        = 342,
        KEY_LEFT_SUPER      = 343,
        KEY_RIGHT_SHIFT     = 344,
        KEY_RIGHT_CONTROL   = 345,
        KEY_RIGHT_ALT       = 346,
        KEY_RIGHT_SUPER     = 347,
        KEY_KB_MENU         = 348,
        KEY_KP_0            = 320,
        KEY_KP_1            = 321,
        KEY_KP_2            = 322,
        KEY_KP_3            = 323,
        KEY_KP_4            = 324,
        KEY_KP_5            = 325,
        KEY_KP_6            = 326,
        KEY_KP_7            = 327,
        KEY_KP_8            = 328,
        KEY_KP_9            = 329,
        KEY_KP_DECIMAL      = 330,
        KEY_KP_DIVIDE       = 331,
        KEY_KP_MULTIPLY     = 332,
        KEY_KP_SUBTRACT     = 333,
        KEY_KP_ADD          = 334,
        KEY_KP_ENTER        = 335,
        KEY_KP_EQUAL        = 336,
        KEY_BACK            = 4,
        KEY_MENU            = 82,
        KEY_VOLUME_UP       = 24,
        KEY_VOLUME_DOWN     = 25
    } KeyboardKey;
    typedef enum {
        MOUSE_BUTTON_LEFT    = 0,
        MOUSE_BUTTON_RIGHT   = 1,
        MOUSE_BUTTON_MIDDLE  = 2,
        MOUSE_BUTTON_SIDE    = 3,
        MOUSE_BUTTON_EXTRA   = 4,
        MOUSE_BUTTON_FORWARD = 5,
        MOUSE_BUTTON_BACK    = 6,
    } MouseButton;
    typedef enum {
        MOUSE_CURSOR_DEFAULT       = 0,
        MOUSE_CURSOR_ARROW         = 1,
        MOUSE_CURSOR_IBEAM         = 2,
        MOUSE_CURSOR_CROSSHAIR     = 3,
        MOUSE_CURSOR_POINTING_HAND = 4,
        MOUSE_CURSOR_RESIZE_EW     = 5,
        MOUSE_CURSOR_RESIZE_NS     = 6,
        MOUSE_CURSOR_RESIZE_NWSE   = 7,
        MOUSE_CURSOR_RESIZE_NESW   = 8,
        MOUSE_CURSOR_RESIZE_ALL    = 9,
        MOUSE_CURSOR_NOT_ALLOWED   = 10
    } MouseCursor;
    typedef enum {
        GAMEPAD_BUTTON_UNKNOWN = 0,
        GAMEPAD_BUTTON_LEFT_FACE_UP,
        GAMEPAD_BUTTON_LEFT_FACE_RIGHT,
        GAMEPAD_BUTTON_LEFT_FACE_DOWN,
        GAMEPAD_BUTTON_LEFT_FACE_LEFT,
        GAMEPAD_BUTTON_RIGHT_FACE_UP,
        GAMEPAD_BUTTON_RIGHT_FACE_RIGHT,
        GAMEPAD_BUTTON_RIGHT_FACE_DOWN,
        GAMEPAD_BUTTON_RIGHT_FACE_LEFT,
        GAMEPAD_BUTTON_LEFT_TRIGGER_1,
        GAMEPAD_BUTTON_LEFT_TRIGGER_2,
        GAMEPAD_BUTTON_RIGHT_TRIGGER_1,
        GAMEPAD_BUTTON_RIGHT_TRIGGER_2,
        GAMEPAD_BUTTON_MIDDLE_LEFT,
        GAMEPAD_BUTTON_MIDDLE,
        GAMEPAD_BUTTON_MIDDLE_RIGHT,
        GAMEPAD_BUTTON_LEFT_THUMB,
        GAMEPAD_BUTTON_RIGHT_THUMB
    } GamepadButton;
    typedef enum {
        GAMEPAD_AXIS_LEFT_X        = 0,
        GAMEPAD_AXIS_LEFT_Y        = 1,
        GAMEPAD_AXIS_RIGHT_X       = 2,
        GAMEPAD_AXIS_RIGHT_Y       = 3,
        GAMEPAD_AXIS_LEFT_TRIGGER  = 4,
        GAMEPAD_AXIS_RIGHT_TRIGGER = 5
    } GamepadAxis;
    typedef enum {
        MATERIAL_MAP_ALBEDO = 0,
        MATERIAL_MAP_METALNESS,
        MATERIAL_MAP_NORMAL,
        MATERIAL_MAP_ROUGHNESS,
        MATERIAL_MAP_OCCLUSION,
        MATERIAL_MAP_EMISSION,
        MATERIAL_MAP_HEIGHT,
        MATERIAL_MAP_CUBEMAP,
        MATERIAL_MAP_IRRADIANCE,
        MATERIAL_MAP_PREFILTER,
        MATERIAL_MAP_BRDF
    } MaterialMapIndex;
    typedef enum {
        SHADER_LOC_VERTEX_POSITION = 0,
        SHADER_LOC_VERTEX_TEXCOORD01,
        SHADER_LOC_VERTEX_TEXCOORD02,
        SHADER_LOC_VERTEX_NORMAL,
        SHADER_LOC_VERTEX_TANGENT,
        SHADER_LOC_VERTEX_COLOR,
        SHADER_LOC_MATRIX_MVP,
        SHADER_LOC_MATRIX_VIEW,
        SHADER_LOC_MATRIX_PROJECTION,
        SHADER_LOC_MATRIX_MODEL,
        SHADER_LOC_MATRIX_NORMAL,
        SHADER_LOC_VECTOR_VIEW,
        SHADER_LOC_COLOR_DIFFUSE,
        SHADER_LOC_COLOR_SPECULAR,
        SHADER_LOC_COLOR_AMBIENT,
        SHADER_LOC_MAP_ALBEDO,
        SHADER_LOC_MAP_METALNESS,
        SHADER_LOC_MAP_NORMAL,
        SHADER_LOC_MAP_ROUGHNESS,
        SHADER_LOC_MAP_OCCLUSION,
        SHADER_LOC_MAP_EMISSION,
        SHADER_LOC_MAP_HEIGHT,
        SHADER_LOC_MAP_CUBEMAP,
        SHADER_LOC_MAP_IRRADIANCE,
        SHADER_LOC_MAP_PREFILTER,
        SHADER_LOC_MAP_BRDF
    } ShaderLocationIndex;
    typedef enum {
        SHADER_UNIFORM_FLOAT = 0,
        SHADER_UNIFORM_VEC2,
        SHADER_UNIFORM_VEC3,
        SHADER_UNIFORM_VEC4,
        SHADER_UNIFORM_INT,
        SHADER_UNIFORM_IVEC2,
        SHADER_UNIFORM_IVEC3,
        SHADER_UNIFORM_IVEC4,
        SHADER_UNIFORM_SAMPLER2D
    } ShaderUniformDataType;
    typedef enum {
        SHADER_ATTRIB_FLOAT = 0,
        SHADER_ATTRIB_VEC2,
        SHADER_ATTRIB_VEC3,
        SHADER_ATTRIB_VEC4
    } ShaderAttributeDataType;
    typedef enum {
        PIXELFORMAT_UNCOMPRESSED_GRAYSCALE = 1,
        PIXELFORMAT_UNCOMPRESSED_GRAY_ALPHA,
        PIXELFORMAT_UNCOMPRESSED_R5G6B5,
        PIXELFORMAT_UNCOMPRESSED_R8G8B8,
        PIXELFORMAT_UNCOMPRESSED_R5G5B5A1,
        PIXELFORMAT_UNCOMPRESSED_R4G4B4A4,
        PIXELFORMAT_UNCOMPRESSED_R8G8B8A8,
        PIXELFORMAT_UNCOMPRESSED_R32,
        PIXELFORMAT_UNCOMPRESSED_R32G32B32,
        PIXELFORMAT_UNCOMPRESSED_R32G32B32A32,
        PIXELFORMAT_COMPRESSED_DXT1_RGB,
        PIXELFORMAT_COMPRESSED_DXT1_RGBA,
        PIXELFORMAT_COMPRESSED_DXT3_RGBA,
        PIXELFORMAT_COMPRESSED_DXT5_RGBA,
        PIXELFORMAT_COMPRESSED_ETC1_RGB,
        PIXELFORMAT_COMPRESSED_ETC2_RGB,
        PIXELFORMAT_COMPRESSED_ETC2_EAC_RGBA,
        PIXELFORMAT_COMPRESSED_PVRT_RGB,
        PIXELFORMAT_COMPRESSED_PVRT_RGBA,
        PIXELFORMAT_COMPRESSED_ASTC_4x4_RGBA,
        PIXELFORMAT_COMPRESSED_ASTC_8x8_RGBA
    } PixelFormat;
    typedef enum {
        TEXTURE_FILTER_POINT = 0,
        TEXTURE_FILTER_BILINEAR,
        TEXTURE_FILTER_TRILINEAR,
        TEXTURE_FILTER_ANISOTROPIC_4X,
        TEXTURE_FILTER_ANISOTROPIC_8X,
        TEXTURE_FILTER_ANISOTROPIC_16X,
    } TextureFilter;
    typedef enum {
        TEXTURE_WRAP_REPEAT = 0,
        TEXTURE_WRAP_CLAMP,
        TEXTURE_WRAP_MIRROR_REPEAT,
        TEXTURE_WRAP_MIRROR_CLAMP
    } TextureWrap;
    typedef enum {
        CUBEMAP_LAYOUT_AUTO_DETECT = 0,
        CUBEMAP_LAYOUT_LINE_VERTICAL,
        CUBEMAP_LAYOUT_LINE_HORIZONTAL,
        CUBEMAP_LAYOUT_CROSS_THREE_BY_FOUR,
        CUBEMAP_LAYOUT_CROSS_FOUR_BY_THREE,
        CUBEMAP_LAYOUT_PANORAMA
    } CubemapLayout;
    typedef enum {
        FONT_DEFAULT = 0,
        FONT_BITMAP,
        FONT_SDF
    } FontType;
    typedef enum {
        BLEND_ALPHA = 0,
        BLEND_ADDITIVE,
        BLEND_MULTIPLIED,
        BLEND_ADD_COLORS,
        BLEND_SUBTRACT_COLORS,
        BLEND_ALPHA_PREMULTIPLY,
        BLEND_CUSTOM,
        BLEND_CUSTOM_SEPARATE
    } BlendMode;
    typedef enum {
        GESTURE_NONE        = 0,
        GESTURE_TAP         = 1,
        GESTURE_DOUBLETAP   = 2,
        GESTURE_HOLD        = 4,
        GESTURE_DRAG        = 8,
        GESTURE_SWIPE_RIGHT = 16,
        GESTURE_SWIPE_LEFT  = 32,
        GESTURE_SWIPE_UP    = 64,
        GESTURE_SWIPE_DOWN  = 128,
        GESTURE_PINCH_IN    = 256,
        GESTURE_PINCH_OUT   = 512
    } Gesture;
    typedef enum {
        CAMERA_CUSTOM = 0,
        CAMERA_FREE,
        CAMERA_ORBITAL,
        CAMERA_FIRST_PERSON,
        CAMERA_THIRD_PERSON
    } CameraMode;
    typedef enum {
        CAMERA_PERSPECTIVE = 0,
        CAMERA_ORTHOGRAPHIC
    } CameraProjection;
    typedef enum {
        NPATCH_NINE_PATCH = 0,
        NPATCH_THREE_PATCH_VERTICAL,
        NPATCH_THREE_PATCH_HORIZONTAL
    } NPatchLayout;
    typedef void (*TraceLogCallback)(int logLevel, const char *text, va_list args);
    typedef unsigned char *(*LoadFileDataCallback)(const char *fileName, unsigned int *bytesRead);
    typedef bool (*SaveFileDataCallback)(const char *fileName, void *data, unsigned int bytesToWrite);
    typedef char *(*LoadFileTextCallback)(const char *fileName);
    typedef bool (*SaveFileTextCallback)(const char *fileName, char *text);
    typedef void (*AudioCallback)(void *bufferData, unsigned int frames);
    void InitWindow(int width, int height, const char *title);
    bool WindowShouldClose(void);
    void CloseWindow(void);
    void SetTargetFPS(int fps);
    void ClearBackground(Color color);
    void BeginDrawing(void);
    void EndDrawing(void);
    bool IsWindowReady(void);
    bool IsWindowHidden(void);
    bool IsWindowMinimized(void);
    bool IsWindowMaximized(void);
    bool IsWindowFocused(void);
    bool IsWindowResized(void);
    bool IsWindowState(unsigned int flag);
    void SetWindowState(unsigned int flags);
    void ClearWindowState(unsigned int flags);
    void ToggleFullscreen(void);
    void MaximizeWindow(void);
    void MinimizeWindow(void);
    void RestoreWindow(void);
    void SetWindowIcon(Image image);
    void SetWindowIcons(Image *images, int count);
    void SetWindowTitle(const char *title);
    void SetWindowPosition(int x, int y);
    void SetWindowMonitor(int monitor);
    void SetWindowMinSize(int width, int height);
    void SetWindowSize(int width, int height);
    void SetWindowOpacity(float opacity);
    void *GetWindowHandle(void);
    int GetScreenWidth(void);
    int GetScreenHeight(void);
    int GetRenderWidth(void);
    int GetRenderHeight(void);
    int GetMonitorCount(void);
    int GetCurrentMonitor(void);
    Vector2 GetMonitorPosition(int monitor);
    int GetMonitorWidth(int monitor);
    int GetMonitorHeight(int monitor);
    int GetMonitorPhysicalWidth(int monitor);
    int GetMonitorPhysicalHeight(int monitor);
    int GetMonitorRefreshRate(int monitor);
    Vector2 GetWindowPosition(void);
    Vector2 GetWindowScaleDPI(void);
    const char *GetMonitorName(int monitor);
    void SetClipboardText(const char *text);
    const char *GetClipboardText(void);
    void EnableEventWaiting(void);
    void DisableEventWaiting(void);
    void SwapScreenBuffer(void);
    void PollInputEvents(void);
    void WaitTime(double seconds);
    void ShowCursor(void);
    void HideCursor(void);
    bool IsCursorHidden(void);
    void EnableCursor(void);
    void DisableCursor(void);
    bool IsCursorOnScreen(void);
    void BeginMode2D(Camera2D camera);
    void EndMode2D(void);
    void BeginMode3D(Camera3D camera);
    void EndMode3D(void);
    void BeginTextureMode(RenderTexture2D target);
    void EndTextureMode(void);
    void BeginShaderMode(Shader shader);
    void EndShaderMode(void);
    void BeginBlendMode(int mode);
    void EndBlendMode(void);
    void BeginScissorMode(int x, int y, int width, int height);
    void EndScissorMode(void);
    void BeginVrStereoMode(VrStereoConfig config);
    void EndVrStereoMode(void);
    VrStereoConfig LoadVrStereoConfig(VrDeviceInfo device);
    void UnloadVrStereoConfig(VrStereoConfig config);
    Shader LoadShader(const char *vsFileName, const char *fsFileName);
    Shader LoadShaderFromMemory(const char *vsCode, const char *fsCode);
    bool IsShaderReady(Shader shader);
    int GetShaderLocation(Shader shader, const char *uniformName);
    int GetShaderLocationAttrib(Shader shader, const char *attribName);
    void SetShaderValue(Shader shader, int locIndex, const void *value, int uniformType);
    void SetShaderValueV(Shader shader, int locIndex, const void *value, int uniformType, int count);
    void SetShaderValueMatrix(Shader shader, int locIndex, Matrix mat);
    void SetShaderValueTexture(Shader shader, int locIndex, Texture2D texture);
    void UnloadShader(Shader shader);
    Ray GetMouseRay(Vector2 mousePosition, Camera camera);
    Matrix GetCameraMatrix(Camera camera);
    Matrix GetCameraMatrix2D(Camera2D camera);
    Vector2 GetWorldToScreen(Vector3 position, Camera camera);
    Vector2 GetScreenToWorld2D(Vector2 position, Camera2D camera);
    Vector2 GetWorldToScreenEx(Vector3 position, Camera camera, int width, int height);
    Vector2 GetWorldToScreen2D(Vector2 position, Camera2D camera);
    bool IsWindowFullscreen(void);
    float GetFrameTime(void);
    double GetTime(void);
    int GetRandomValue(int min, int max);
    void SetRandomSeed(unsigned int seed);
    void TakeScreenshot(const char *fileName);
    void SetConfigFlags(unsigned int flags);
    void TraceLog(int logLevel, const char *text, ...);
    void SetTraceLogLevel(int logLevel);
    void *MemAlloc(unsigned int size);
    void *MemRealloc(void *ptr, unsigned int size);
    void MemFree(void *ptr);
    void OpenURL(const char *url);
    void SetTraceLogCallback(TraceLogCallback callback);
    void SetLoadFileDataCallback(LoadFileDataCallback callback);
    void SetSaveFileDataCallback(SaveFileDataCallback callback);
    void SetLoadFileTextCallback(LoadFileTextCallback callback);
    void SetSaveFileTextCallback(SaveFileTextCallback callback);
    unsigned char *LoadFileData(const char *fileName, unsigned int *bytesRead);
    void UnloadFileData(unsigned char *data);
    bool SaveFileData(const char *fileName, void *data, unsigned int bytesToWrite);
    bool ExportDataAsCode(const unsigned char *data, unsigned int size, const char *fileName);
    char *LoadFileText(const char *fileName);
    void UnloadFileText(char *text);
    bool SaveFileText(const char *fileName, char *text);
    bool FileExists(const char *fileName);
    bool DirectoryExists(const char *dirPath);
    bool IsFileExtension(const char *fileName, const char *ext);
    int GetFileLength(const char *fileName);
    const char *GetFileExtension(const char *fileName);
    const char *GetFileName(const char *filePath);
    const char *GetFileNameWithoutExt(const char *filePath);
    const char *GetDirectoryPath(const char *filePath);
    const char *GetPrevDirectoryPath(const char *dirPath);
    const char *GetWorkingDirectory(void);
    const char *GetApplicationDirectory(void);
    bool ChangeDirectory(const char *dir);
    bool IsPathFile(const char *path);
    FilePathList LoadDirectoryFiles(const char *dirPath);
    FilePathList LoadDirectoryFilesEx(const char *basePath, const char *filter, bool scanSubdirs);
    void UnloadDirectoryFiles(FilePathList files);
    bool IsFileDropped(void);
    FilePathList LoadDroppedFiles(void);
    void UnloadDroppedFiles(FilePathList files);
    long GetFileModTime(const char *fileName);
    unsigned char *CompressData(const unsigned char *data, int dataSize, int *compDataSize);
    unsigned char *DecompressData(const unsigned char *compData, int compDataSize, int *dataSize);
    char *EncodeDataBase64(const unsigned char *data, int dataSize, int *outputSize);
    unsigned char *DecodeDataBase64(const unsigned char *data, int *outputSize);
    bool IsKeyPressed(int key);
    bool IsKeyDown(int key);
    bool IsKeyReleased(int key);
    bool IsKeyUp(int key);
    void SetExitKey(int key);
    int GetKeyPressed(void);
    int GetCharPressed(void);
    bool IsGamepadAvailable(int gamepad);
    const char *GetGamepadName(int gamepad);
    bool IsGamepadButtonPressed(int gamepad, int button);
    bool IsGamepadButtonDown(int gamepad, int button);
    bool IsGamepadButtonReleased(int gamepad, int button);
    bool IsGamepadButtonUp(int gamepad, int button);
    int GetGamepadButtonPressed(void);
    int GetGamepadAxisCount(int gamepad);
    float GetGamepadAxisMovement(int gamepad, int axis);
    int SetGamepadMappings(const char *mappings);
    bool IsMouseButtonPressed(int button);
    bool IsMouseButtonDown(int button);
    bool IsMouseButtonReleased(int button);
    bool IsMouseButtonUp(int button);
    int GetMouseX(void);
    int GetMouseY(void);
    Vector2 GetMousePosition(void);
    Vector2 GetMouseDelta(void);
    void SetMousePosition(int x, int y);
    void SetMouseOffset(int offsetX, int offsetY);
    void SetMouseScale(float scaleX, float scaleY);
    float GetMouseWheelMove(void);
    Vector2 GetMouseWheelMoveV(void);
    void SetMouseCursor(int cursor);
    int GetTouchX(void);
    int GetTouchY(void);
    Vector2 GetTouchPosition(int index);
    int GetTouchPointId(int index);
    int GetTouchPointCount(void);
    void SetGesturesEnabled(unsigned int flags);
    bool IsGestureDetected(int gesture);
    int GetGestureDetected(void);
    float GetGestureHoldDuration(void);
    Vector2 GetGestureDragVector(void);
    float GetGestureDragAngle(void);
    Vector2 GetGesturePinchVector(void);
    float GetGesturePinchAngle(void);
    void UpdateCamera(Camera *camera, int mode);
    void UpdateCameraPro(Camera *camera, Vector3 movement, Vector3 rotation, float zoom);
    void SetShapesTexture(Texture2D texture, Rectangle source);
    void DrawPixel(int posX, int posY, Color color);
    void DrawPixelV(Vector2 position, Color color);
    void DrawLine(int startPosX, int startPosY, int endPosX, int endPosY, Color color);
    void DrawLineV(Vector2 startPos, Vector2 endPos, Color color);
    void DrawLineEx(Vector2 startPos, Vector2 endPos, float thick, Color color);
    void DrawLineBezier(Vector2 startPos, Vector2 endPos, float thick, Color color);
    void DrawLineBezierQuad(Vector2 startPos, Vector2 endPos, Vector2 controlPos, float thick, Color color);
    void DrawLineBezierCubic(Vector2 startPos, Vector2 endPos, Vector2 startControlPos, Vector2 endControlPos, float thick, Color color);
    void DrawLineStrip(Vector2 *points, int pointCount, Color color);
    void DrawCircle(int centerX, int centerY, float radius, Color color);
    void DrawCircleSector(Vector2 center, float radius, float startAngle, float endAngle, int segments, Color color);
    void DrawCircleSectorLines(Vector2 center, float radius, float startAngle, float endAngle, int segments, Color color);
    void DrawCircleGradient(int centerX, int centerY, float radius, Color color1, Color color2);
    void DrawCircleV(Vector2 center, float radius, Color color);
    void DrawCircleLines(int centerX, int centerY, float radius, Color color);
    void DrawEllipse(int centerX, int centerY, float radiusH, float radiusV, Color color);
    void DrawEllipseLines(int centerX, int centerY, float radiusH, float radiusV, Color color);
    void DrawRing(Vector2 center, float innerRadius, float outerRadius, float startAngle, float endAngle, int segments, Color color);
    void DrawRingLines(Vector2 center, float innerRadius, float outerRadius, float startAngle, float endAngle, int segments, Color color);
    void DrawRectangle(int posX, int posY, int width, int height, Color color);
    void DrawRectangleV(Vector2 position, Vector2 size, Color color);
    void DrawRectangleRec(Rectangle rec, Color color);
    void DrawRectanglePro(Rectangle rec, Vector2 origin, float rotation, Color color);
    void DrawRectangleGradientV(int posX, int posY, int width, int height, Color color1, Color color2);
    void DrawRectangleGradientH(int posX, int posY, int width, int height, Color color1, Color color2);
    void DrawRectangleGradientEx(Rectangle rec, Color col1, Color col2, Color col3, Color col4);
    void DrawRectangleLines(int posX, int posY, int width, int height, Color color);
    void DrawRectangleLinesEx(Rectangle rec, float lineThick, Color color);
    void DrawRectangleRounded(Rectangle rec, float roundness, int segments, Color color);
    void DrawRectangleRoundedLines(Rectangle rec, float roundness, int segments, float lineThick, Color color);
    void DrawTriangle(Vector2 v1, Vector2 v2, Vector2 v3, Color color);
    void DrawTriangleLines(Vector2 v1, Vector2 v2, Vector2 v3, Color color);
    void DrawTriangleFan(Vector2 *points, int pointCount, Color color);
    void DrawTriangleStrip(Vector2 *points, int pointCount, Color color);
    void DrawPoly(Vector2 center, int sides, float radius, float rotation, Color color);
    void DrawPolyLines(Vector2 center, int sides, float radius, float rotation, Color color);
    void DrawPolyLinesEx(Vector2 center, int sides, float radius, float rotation, float lineThick, Color color);
    bool CheckCollisionRecs(Rectangle rec1, Rectangle rec2);
    bool CheckCollisionCircles(Vector2 center1, float radius1, Vector2 center2, float radius2);
    bool CheckCollisionCircleRec(Vector2 center, float radius, Rectangle rec);
    bool CheckCollisionPointRec(Vector2 point, Rectangle rec);
    bool CheckCollisionPointCircle(Vector2 point, Vector2 center, float radius);
    bool CheckCollisionPointTriangle(Vector2 point, Vector2 p1, Vector2 p2, Vector2 p3);
    bool CheckCollisionPointPoly(Vector2 point, Vector2 *points, int pointCount);
    bool CheckCollisionLines(Vector2 startPos1, Vector2 endPos1, Vector2 startPos2, Vector2 endPos2, Vector2 *collisionPoint);
    bool CheckCollisionPointLine(Vector2 point, Vector2 p1, Vector2 p2, int threshold);
    Rectangle GetCollisionRec(Rectangle rec1, Rectangle rec2);
    Image LoadImage(const char *fileName);
    Image LoadImageRaw(const char *fileName, int width, int height, int format, int headerSize);
    Image LoadImageAnim(const char *fileName, int *frames);
    Image LoadImageFromMemory(const char *fileType, const unsigned char *fileData, int dataSize);
    Image LoadImageFromTexture(Texture2D texture);
    Image LoadImageFromScreen(void);
    bool IsImageReady(Image image);
    void UnloadImage(Image image);
    bool ExportImage(Image image, const char *fileName);
    bool ExportImageAsCode(Image image, const char *fileName);
    Image GenImageColor(int width, int height, Color color);
    Image GenImageGradientV(int width, int height, Color top, Color bottom);
    Image GenImageGradientH(int width, int height, Color left, Color right);
    Image GenImageGradientRadial(int width, int height, float density, Color inner, Color outer);
    Image GenImageChecked(int width, int height, int checksX, int checksY, Color col1, Color col2);
    Image GenImageWhiteNoise(int width, int height, float factor);
    Image GenImagePerlinNoise(int width, int height, int offsetX, int offsetY, float scale);
    Image GenImageCellular(int width, int height, int tileSize);
    Image GenImageText(int width, int height, const char *text);
    Image ImageCopy(Image image);
    Image ImageFromImage(Image image, Rectangle rec);
    Image ImageText(const char *text, int fontSize, Color color);
    Image ImageTextEx(Font font, const char *text, float fontSize, float spacing, Color tint);
    void ImageFormat(Image *image, int newFormat);
    void ImageToPOT(Image *image, Color fill);
    void ImageCrop(Image *image, Rectangle crop);
    void ImageAlphaCrop(Image *image, float threshold);
    void ImageAlphaClear(Image *image, Color color, float threshold);
    void ImageAlphaMask(Image *image, Image alphaMask);
    void ImageAlphaPremultiply(Image *image);
    void ImageBlurGaussian(Image *image, int blurSize);
    void ImageResize(Image *image, int newWidth, int newHeight);
    void ImageResizeNN(Image *image, int newWidth,int newHeight);
    void ImageResizeCanvas(Image *image, int newWidth, int newHeight, int offsetX, int offsetY, Color fill);
    void ImageMipmaps(Image *image);
    void ImageDither(Image *image, int rBpp, int gBpp, int bBpp, int aBpp);
    void ImageFlipVertical(Image *image);
    void ImageFlipHorizontal(Image *image);
    void ImageRotateCW(Image *image);
    void ImageRotateCCW(Image *image);
    void ImageColorTint(Image *image, Color color);
    void ImageColorInvert(Image *image);
    void ImageColorGrayscale(Image *image);
    void ImageColorContrast(Image *image, float contrast);
    void ImageColorBrightness(Image *image, int brightness);
    void ImageColorReplace(Image *image, Color color, Color replace);
    Color *LoadImageColors(Image image);
    Color *LoadImagePalette(Image image, int maxPaletteSize, int *colorCount);
    void UnloadImageColors(Color *colors);
    void UnloadImagePalette(Color *colors);
    Rectangle GetImageAlphaBorder(Image image, float threshold);
    Color GetImageColor(Image image, int x, int y);
    void ImageClearBackground(Image *dst, Color color);
    void ImageDrawPixel(Image *dst, int posX, int posY, Color color);
    void ImageDrawPixelV(Image *dst, Vector2 position, Color color);
    void ImageDrawLine(Image *dst, int startPosX, int startPosY, int endPosX, int endPosY, Color color);
    void ImageDrawLineV(Image *dst, Vector2 start, Vector2 end, Color color);
    void ImageDrawCircle(Image *dst, int centerX, int centerY, int radius, Color color);
    void ImageDrawCircleV(Image *dst, Vector2 center, int radius, Color color);
    void ImageDrawCircleLines(Image *dst, int centerX, int centerY, int radius, Color color);
    void ImageDrawCircleLinesV(Image *dst, Vector2 center, int radius, Color color);
    void ImageDrawRectangle(Image *dst, int posX, int posY, int width, int height, Color color);
    void ImageDrawRectangleV(Image *dst, Vector2 position, Vector2 size, Color color);
    void ImageDrawRectangleRec(Image *dst, Rectangle rec, Color color);
    void ImageDrawRectangleLines(Image *dst, Rectangle rec, int thick, Color color);
    void ImageDraw(Image *dst, Image src, Rectangle srcRec, Rectangle dstRec, Color tint);
    void ImageDrawText(Image *dst, const char *text, int posX, int posY, int fontSize, Color color);
    void ImageDrawTextEx(Image *dst, Font font, const char *text, Vector2 position, float fontSize, float spacing, Color tint);
    Texture2D LoadTexture(const char *fileName);
    Texture2D LoadTextureFromImage(Image image);
    TextureCubemap LoadTextureCubemap(Image image, int layout);
    RenderTexture2D LoadRenderTexture(int width, int height);
    bool IsTextureReady(Texture2D texture);
    void UnloadTexture(Texture2D texture);
    bool IsRenderTextureReady(RenderTexture2D target);
    void UnloadRenderTexture(RenderTexture2D target);
    void UpdateTexture(Texture2D texture, const void *pixels);
    void UpdateTextureRec(Texture2D texture, Rectangle rec, const void *pixels);
    void GenTextureMipmaps(Texture2D *texture);
    void SetTextureFilter(Texture2D texture, int filter);
    void SetTextureWrap(Texture2D texture, int wrap);
    void DrawTexture(Texture2D texture, int posX, int posY, Color tint);
    void DrawTextureV(Texture2D texture, Vector2 position, Color tint);
    void DrawTextureEx(Texture2D texture, Vector2 position, float rotation, float scale, Color tint);
    void DrawTextureRec(Texture2D texture, Rectangle source, Vector2 position, Color tint);
    void DrawTexturePro(Texture2D texture, Rectangle source, Rectangle dest, Vector2 origin, float rotation, Color tint);
    void DrawTextureNPatch(Texture2D texture, NPatchInfo nPatchInfo, Rectangle dest, Vector2 origin, float rotation, Color tint);
    Color Fade(Color color, float alpha);
    int ColorToInt(Color color);
    Vector4 ColorNormalize(Color color);
    Color ColorFromNormalized(Vector4 normalized);
    Vector3 ColorToHSV(Color color);
    Color ColorFromHSV(float hue, float saturation, float value);
    Color ColorTint(Color color, Color tint);
    Color ColorBrightness(Color color, float factor);
    Color ColorContrast(Color color, float contrast);
    Color ColorAlpha(Color color, float alpha);
    Color ColorAlphaBlend(Color dst, Color src, Color tint);
    Color GetColor(unsigned int hexValue);
    Color GetPixelColor(void *srcPtr, int format);
    void SetPixelColor(void *dstPtr, Color color, int format);
    int GetPixelDataSize(int width, int height, int format);
    Font GetFontDefault(void);
    Font LoadFont(const char *fileName);
    Font LoadFontEx(const char *fileName, int fontSize, int *fontChars, int glyphCount);
    Font LoadFontFromImage(Image image, Color key, int firstChar);
    Font LoadFontFromMemory(const char *fileType, const unsigned char *fileData, int dataSize, int fontSize, int *fontChars, int glyphCount);
    bool IsFontReady(Font font);
    GlyphInfo *LoadFontData(const unsigned char *fileData, int dataSize, int fontSize, int *fontChars, int glyphCount, int type);
    Image GenImageFontAtlas(const GlyphInfo *chars, Rectangle **recs, int glyphCount, int fontSize, int padding, int packMethod);
    void UnloadFontData(GlyphInfo *chars, int glyphCount);
    void UnloadFont(Font font);
    bool ExportFontAsCode(Font font, const char *fileName);
    void DrawFPS(int posX, int posY);
    void DrawText(const char *text, int posX, int posY, int fontSize, Color color);
    void DrawTextEx(Font font, const char *text, Vector2 position, float fontSize, float spacing, Color tint);
    void DrawTextPro(Font font, const char *text, Vector2 position, Vector2 origin, float rotation, float fontSize, float spacing, Color tint);
    void DrawTextCodepoint(Font font, int codepoint, Vector2 position, float fontSize, Color tint);
    void DrawTextCodepoints(Font font, const int *codepoints, int count, Vector2 position, float fontSize, float spacing, Color tint);
    int MeasureText(const char *text, int fontSize);
    Vector2 MeasureTextEx(Font font, const char *text, float fontSize, float spacing);
    int GetGlyphIndex(Font font, int codepoint);
    GlyphInfo GetGlyphInfo(Font font, int codepoint);
    Rectangle GetGlyphAtlasRec(Font font, int codepoint);
    char *LoadUTF8(const int *codepoints, int length);
    void UnloadUTF8(char *text);
    int *LoadCodepoints(const char *text, int *count);
    void UnloadCodepoints(int *codepoints);
    int GetCodepointCount(const char *text);
    int GetCodepoint(const char *text, int *codepointSize);
    int GetCodepointNext(const char *text, int *codepointSize);
    int GetCodepointPrevious(const char *text, int *codepointSize);
    const char *CodepointToUTF8(int codepoint, int *utf8Size);
    int TextCopy(char *dst, const char *src);
    bool TextIsEqual(const char *text1, const char *text2);
    unsigned int TextLength(const char *text);
    const char *TextFormat(const char *text, ...);
    const char *TextSubtext(const char *text, int position, int length);
    char *TextReplace(char *text, const char *replace, const char *by);
    char *TextInsert(const char *text, const char *insert, int position);
    const char *TextJoin(const char **textList, int count, const char *delimiter);
    const char **TextSplit(const char *text, char delimiter, int *count);
    void TextAppend(char *text, const char *append, int *position);
    int TextFindIndex(const char *text, const char *find);
    const char *TextToUpper(const char *text);
    const char *TextToLower(const char *text);
    const char *TextToPascal(const char *text);
    int TextToInteger(const char *text);
    void DrawLine3D(Vector3 startPos, Vector3 endPos, Color color);
    void DrawPoint3D(Vector3 position, Color color);
    void DrawCircle3D(Vector3 center, float radius, Vector3 rotationAxis, float rotationAngle, Color color);
    void DrawTriangle3D(Vector3 v1, Vector3 v2, Vector3 v3, Color color);
    void DrawTriangleStrip3D(Vector3 *points, int pointCount, Color color);
    void DrawCube(Vector3 position, float width, float height, float length, Color color);
    void DrawCubeV(Vector3 position, Vector3 size, Color color);
    void DrawCubeWires(Vector3 position, float width, float height, float length, Color color);
    void DrawCubeWiresV(Vector3 position, Vector3 size, Color color);
    void DrawSphere(Vector3 centerPos, float radius, Color color);
    void DrawSphereEx(Vector3 centerPos, float radius, int rings, int slices, Color color);
    void DrawSphereWires(Vector3 centerPos, float radius, int rings, int slices, Color color);
    void DrawCylinder(Vector3 position, float radiusTop, float radiusBottom, float height, int slices, Color color);
    void DrawCylinderEx(Vector3 startPos, Vector3 endPos, float startRadius, float endRadius, int sides, Color color);
    void DrawCylinderWires(Vector3 position, float radiusTop, float radiusBottom, float height, int slices, Color color);
    void DrawCylinderWiresEx(Vector3 startPos, Vector3 endPos, float startRadius, float endRadius, int sides, Color color);
    void DrawCapsule(Vector3 startPos, Vector3 endPos, float radius, int slices, int rings, Color color);
    void DrawCapsuleWires(Vector3 startPos, Vector3 endPos, float radius, int slices, int rings, Color color);
    void DrawPlane(Vector3 centerPos, Vector2 size, Color color);
    void DrawRay(Ray ray, Color color);
    void DrawGrid(int slices, float spacing);
    Model LoadModel(const char *fileName);
    Model LoadModelFromMesh(Mesh mesh);
    bool IsModelReady(Model model);
    void UnloadModel(Model model);
    BoundingBox GetModelBoundingBox(Model model);
    void DrawModel(Model model, Vector3 position, float scale, Color tint);
    void DrawModelEx(Model model, Vector3 position, Vector3 rotationAxis, float rotationAngle, Vector3 scale, Color tint);
    void DrawModelWires(Model model, Vector3 position, float scale, Color tint);
    void DrawModelWiresEx(Model model, Vector3 position, Vector3 rotationAxis, float rotationAngle, Vector3 scale, Color tint);
    void DrawBoundingBox(BoundingBox box, Color color);
    void DrawBillboard(Camera camera, Texture2D texture, Vector3 position, float size, Color tint);
    void DrawBillboardRec(Camera camera, Texture2D texture, Rectangle source, Vector3 position, Vector2 size, Color tint);
    void DrawBillboardPro(Camera camera, Texture2D texture, Rectangle source, Vector3 position, Vector3 up, Vector2 size, Vector2 origin, float rotation, Color tint);
    void UploadMesh(Mesh *mesh, bool dynamic);
    void UpdateMeshBuffer(Mesh mesh, int index, const void *data, int dataSize, int offset);
    void UnloadMesh(Mesh mesh);
    void DrawMesh(Mesh mesh, Material material, Matrix transform);
    void DrawMeshInstanced(Mesh mesh, Material material, const Matrix *transforms, int instances);
    bool ExportMesh(Mesh mesh, const char *fileName);
    BoundingBox GetMeshBoundingBox(Mesh mesh);
    void GenMeshTangents(Mesh *mesh);
    Mesh GenMeshPoly(int sides, float radius);
    Mesh GenMeshPlane(float width, float length, int resX, int resZ);
    Mesh GenMeshCube(float width, float height, float length);
    Mesh GenMeshSphere(float radius, int rings, int slices);
    Mesh GenMeshHemiSphere(float radius, int rings, int slices);
    Mesh GenMeshCylinder(float radius, float height, int slices);
    Mesh GenMeshCone(float radius, float height, int slices);
    Mesh GenMeshTorus(float radius, float size, int radSeg, int sides);
    Mesh GenMeshKnot(float radius, float size, int radSeg, int sides);
    Mesh GenMeshHeightmap(Image heightmap, Vector3 size);
    Mesh GenMeshCubicmap(Image cubicmap, Vector3 cubeSize);
    Material *LoadMaterials(const char *fileName, int *materialCount);
    Material LoadMaterialDefault(void);
    bool IsMaterialReady(Material material);
    void UnloadMaterial(Material material);
    void SetMaterialTexture(Material *material, int mapType, Texture2D texture);
    void SetModelMeshMaterial(Model *model, int meshId, int materialId);
    ModelAnimation *LoadModelAnimations(const char *fileName, unsigned int *animCount);
    void UpdateModelAnimation(Model model, ModelAnimation anim, int frame);
    void UnloadModelAnimation(ModelAnimation anim);
    void UnloadModelAnimations(ModelAnimation *animations, unsigned int count);
    bool IsModelAnimationValid(Model model, ModelAnimation anim);
    bool CheckCollisionSpheres(Vector3 center1, float radius1, Vector3 center2, float radius2);
    bool CheckCollisionBoxes(BoundingBox box1, BoundingBox box2);
    bool CheckCollisionBoxSphere(BoundingBox box, Vector3 center, float radius);
    RayCollision GetRayCollisionSphere(Ray ray, Vector3 center, float radius);
    RayCollision GetRayCollisionBox(Ray ray, BoundingBox box);
    RayCollision GetRayCollisionMesh(Ray ray, Mesh mesh, Matrix transform);
    RayCollision GetRayCollisionTriangle(Ray ray, Vector3 p1, Vector3 p2, Vector3 p3);
    RayCollision GetRayCollisionQuad(Ray ray, Vector3 p1, Vector3 p2, Vector3 p3, Vector3 p4);
    void InitAudioDevice(void);
    void CloseAudioDevice(void);
    bool IsAudioDeviceReady(void);
    void SetMasterVolume(float volume);
    Wave LoadWave(const char *fileName);
    Wave LoadWaveFromMemory(const char *fileType, const unsigned char *fileData, int dataSize);
    bool IsWaveReady(Wave wave);
    Sound LoadSound(const char *fileName);
    Sound LoadSoundFromWave(Wave wave);
    bool IsSoundReady(Sound sound);
    void UpdateSound(Sound sound, const void *data, int sampleCount);
    void UnloadWave(Wave wave);
    void UnloadSound(Sound sound);
    bool ExportWave(Wave wave, const char *fileName);
    bool ExportWaveAsCode(Wave wave, const char *fileName);
    void PlaySound(Sound sound);
    void StopSound(Sound sound);
    void PauseSound(Sound sound);
    void ResumeSound(Sound sound);
    bool IsSoundPlaying(Sound sound);
    void SetSoundVolume(Sound sound, float volume);
    void SetSoundPitch(Sound sound, float pitch);
    void SetSoundPan(Sound sound, float pan);
    Wave WaveCopy(Wave wave);
    void WaveCrop(Wave *wave, int initSample, int finalSample);
    void WaveFormat(Wave *wave, int sampleRate, int sampleSize, int channels);
    float *LoadWaveSamples(Wave wave);
    void UnloadWaveSamples(float *samples);
    Music LoadMusicStream(const char *fileName);
    Music LoadMusicStreamFromMemory(const char *fileType, const unsigned char *data, int dataSize);
    bool IsMusicReady(Music music);
    void UnloadMusicStream(Music music);
    void PlayMusicStream(Music music);
    bool IsMusicStreamPlaying(Music music);
    void UpdateMusicStream(Music music);
    void StopMusicStream(Music music);
    void PauseMusicStream(Music music);
    void ResumeMusicStream(Music music);
    void SeekMusicStream(Music music, float position);
    void SetMusicVolume(Music music, float volume);
    void SetMusicPitch(Music music, float pitch);
    void SetMusicPan(Music music, float pan);
    float GetMusicTimeLength(Music music);
    float GetMusicTimePlayed(Music music);
    AudioStream LoadAudioStream(unsigned int sampleRate, unsigned int sampleSize, unsigned int channels);
    bool IsAudioStreamReady(AudioStream stream);
    void UnloadAudioStream(AudioStream stream);
    void UpdateAudioStream(AudioStream stream, const void *data, int frameCount);
    bool IsAudioStreamProcessed(AudioStream stream);
    void PlayAudioStream(AudioStream stream);
    void PauseAudioStream(AudioStream stream);
    void ResumeAudioStream(AudioStream stream);
    bool IsAudioStreamPlaying(AudioStream stream);
    void StopAudioStream(AudioStream stream);
    void SetAudioStreamVolume(AudioStream stream, float volume);
    void SetAudioStreamPitch(AudioStream stream, float pitch);
    void SetAudioStreamPan(AudioStream stream, float pan);
    void SetAudioStreamBufferSizeDefault(int size);
    void SetAudioStreamCallback(AudioStream stream, AudioCallback callback);
    void AttachAudioStreamProcessor(AudioStream stream, AudioCallback processor);
    void DetachAudioStreamProcessor(AudioStream stream, AudioCallback processor);
    void AttachAudioMixedProcessor(AudioCallback processor);
    void DetachAudioMixedProcessor(AudioCallback processor);
    int GetFPS(void);
    float Clamp(float value, float min, float max);
    float Lerp(float start, float end, float amount);
    float Normalize(float value, float start, float end);
    float Remap(float value, float inputStart, float inputEnd, float outputStart, float outputEnd);
    float Wrap(float value, float min, float max);
    int FloatEquals(float x, float y);
    Vector2 Vector2Zero(void);
    Vector2 Vector2One(void);
    Vector2 Vector2Add(Vector2 v1, Vector2 v2);
    Vector2 Vector2AddValue(Vector2 v, float add);
    Vector2 Vector2Subtract(Vector2 v1, Vector2 v2);
    Vector2 Vector2SubtractValue(Vector2 v, float sub);
    float Vector2Length(Vector2 v);
    float Vector2LengthSqr(Vector2 v);
    float Vector2DotProduct(Vector2 v1, Vector2 v2);
    float Vector2Distance(Vector2 v1, Vector2 v2);
    float Vector2DistanceSqr(Vector2 v1, Vector2 v2);
    float Vector2Angle(Vector2 v1, Vector2 v2);
    float Vector2LineAngle(Vector2 start, Vector2 end);
    Vector2 Vector2Scale(Vector2 v, float scale);
    Vector2 Vector2Multiply(Vector2 v1, Vector2 v2);
    Vector2 Vector2Negate(Vector2 v);
    Vector2 Vector2Divide(Vector2 v1, Vector2 v2);
    Vector2 Vector2Normalize(Vector2 v);
    Vector2 Vector2Transform(Vector2 v, Matrix mat);
    Vector2 Vector2Lerp(Vector2 v1, Vector2 v2, float amount);
    Vector2 Vector2Reflect(Vector2 v, Vector2 normal);
    Vector2 Vector2Rotate(Vector2 v, float angle);
    Vector2 Vector2MoveTowards(Vector2 v, Vector2 target, float maxDistance);
    Vector2 Vector2Invert(Vector2 v);
    Vector2 Vector2Clamp(Vector2 v, Vector2 min, Vector2 max);
    Vector2 Vector2ClampValue(Vector2 v, float min, float max);
    int Vector2Equals(Vector2 p, Vector2 q);
    Vector3 Vector3Zero(void);
    Vector3 Vector3One(void);
    Vector3 Vector3Add(Vector3 v1, Vector3 v2);
    Vector3 Vector3AddValue(Vector3 v, float add);
    Vector3 Vector3Subtract(Vector3 v1, Vector3 v2);
    Vector3 Vector3SubtractValue(Vector3 v, float sub);
    Vector3 Vector3Scale(Vector3 v, float scalar);
    Vector3 Vector3Multiply(Vector3 v1, Vector3 v2);
    Vector3 Vector3CrossProduct(Vector3 v1, Vector3 v2);
    Vector3 Vector3Perpendicular(Vector3 v);
    float Vector3Length(const Vector3 v);
    float Vector3LengthSqr(const Vector3 v);
    float Vector3DotProduct(Vector3 v1, Vector3 v2);
    float Vector3Distance(Vector3 v1, Vector3 v2);
    float Vector3DistanceSqr(Vector3 v1, Vector3 v2);
    float Vector3Angle(Vector3 v1, Vector3 v2);
    Vector3 Vector3Negate(Vector3 v);
    Vector3 Vector3Divide(Vector3 v1, Vector3 v2);
    Vector3 Vector3Normalize(Vector3 v);
    void Vector3OrthoNormalize(Vector3 *v1, Vector3 *v2);
    Vector3 Vector3Transform(Vector3 v, Matrix mat);
    Vector3 Vector3RotateByQuaternion(Vector3 v, Quaternion q);
    Vector3 Vector3RotateByAxisAngle(Vector3 v, Vector3 axis, float angle);
    Vector3 Vector3Lerp(Vector3 v1, Vector3 v2, float amount);
    Vector3 Vector3Reflect(Vector3 v, Vector3 normal);
    Vector3 Vector3Min(Vector3 v1, Vector3 v2);
    Vector3 Vector3Max(Vector3 v1, Vector3 v2);
    Vector3 Vector3Barycenter(Vector3 p, Vector3 a, Vector3 b, Vector3 c);
    Vector3 Vector3Unproject(Vector3 source, Matrix projection, Matrix view);
    float3 Vector3ToFloatV(Vector3 v);
    Vector3 Vector3Invert(Vector3 v);
    Vector3 Vector3Clamp(Vector3 v, Vector3 min, Vector3 max);
    Vector3 Vector3ClampValue(Vector3 v, float min, float max);
    int Vector3Equals(Vector3 p, Vector3 q);
    Vector3 Vector3Refract(Vector3 v, Vector3 n, float r);
    float MatrixDeterminant(Matrix mat);
    float MatrixTrace(Matrix mat);
    Matrix MatrixTranspose(Matrix mat);
    Matrix MatrixInvert(Matrix mat);
    Matrix MatrixIdentity(void);
    Matrix MatrixAdd(Matrix left, Matrix right);
    Matrix MatrixSubtract(Matrix left, Matrix right);
    Matrix MatrixMultiply(Matrix left, Matrix right);
    Matrix MatrixTranslate(float x, float y, float z);
    Matrix MatrixRotate(Vector3 axis, float angle);
    Matrix MatrixRotateX(float angle);
    Matrix MatrixRotateY(float angle);
    Matrix MatrixRotateZ(float angle);
    Matrix MatrixRotateXYZ(Vector3 angle);
    Matrix MatrixRotateZYX(Vector3 angle);
    Matrix MatrixScale(float x, float y, float z);
    Matrix MatrixFrustum(double left, double right, double bottom, double top, double near, double far);
    Matrix MatrixPerspective(double fovy, double aspect, double near, double far);
    Matrix MatrixOrtho(double left, double right, double bottom, double top, double near, double far);
    Matrix MatrixLookAt(Vector3 eye, Vector3 target, Vector3 up);
    float16 MatrixToFloatV(Matrix mat);
    Quaternion QuaternionAdd(Quaternion q1, Quaternion q2);
    Quaternion QuaternionAddValue(Quaternion q, float add);
    Quaternion QuaternionSubtract(Quaternion q1, Quaternion q2);
    Quaternion QuaternionSubtractValue(Quaternion q, float sub);
    Quaternion QuaternionIdentity(void);
    float QuaternionLength(Quaternion q);
    Quaternion QuaternionNormalize(Quaternion q);
    Quaternion QuaternionInvert(Quaternion q);
    Quaternion QuaternionMultiply(Quaternion q1, Quaternion q2);
    Quaternion QuaternionScale(Quaternion q, float mul);
    Quaternion QuaternionDivide(Quaternion q1, Quaternion q2);
    Quaternion QuaternionLerp(Quaternion q1, Quaternion q2, float amount);
    Quaternion QuaternionNlerp(Quaternion q1, Quaternion q2, float amount);
    Quaternion QuaternionSlerp(Quaternion q1, Quaternion q2, float amount);
    Quaternion QuaternionFromVector3ToVector3(Vector3 from, Vector3 to);
    Quaternion QuaternionFromMatrix(Matrix mat);
    Matrix QuaternionToMatrix(Quaternion q);
    Quaternion QuaternionFromAxisAngle(Vector3 axis, float angle);
    void QuaternionToAxisAngle(Quaternion q, Vector3 *outAxis, float *outAngle);
    Quaternion QuaternionFromEuler(float pitch, float yaw, float roll);
    Vector3 QuaternionToEuler(Quaternion q);
    Quaternion QuaternionTransform(Quaternion q, Matrix mat);
    int QuaternionEquals(Quaternion p, Quaternion q);
]]
local r = ffi.load("raylib")
local newc =
    function(a, b, c, d) return ffi.new("struct Color", {a, b, c, d}) end

EPSILON = 0.000001
PI = 3.14159265358979323846
DEG2RAD = (PI / 180.0)
RAD2DEG = (180.0 / PI)
MOUSE_LEFT_BUTTON = MOUSE_BUTTON_LEFT
MOUSE_RIGHT_BUTTON = MOUSE_BUTTON_RIGHT
MOUSE_MIDDLE_BUTTON = MOUSE_BUTTON_MIDDLE
MATERIAL_MAP_DIFFUSE = MATERIAL_MAP_ALBEDO
MATERIAL_MAP_SPECULAR = MATERIAL_MAP_METALNESS
SHADER_LOC_MAP_DIFFUSE = SHADER_LOC_MAP_ALBEDO
SHADER_LOC_MAP_SPECULAR = SHADER_LOC_MAP_METALNESS
LIGHTGRAY = newc(200, 200, 200, 255)
GRAY = newc(130, 130, 130, 255)
DARKGRAY = newc(80, 80, 80, 255)
YELLOW = newc(253, 249, 0, 255)
GOLD = newc(255, 203, 0, 255)
ORANGE = newc(255, 161, 0, 255)
PINK = newc(255, 109, 194, 255)
RED = newc(230, 41, 55, 255)
MAROON = newc(190, 33, 55, 255)
GREEN = newc(0, 228, 48, 255)
LIME = newc(0, 158, 47, 255)
DARKGREEN = newc(0, 117, 44, 255)
SKYBLUE = newc(102, 191, 255, 255)
BLUE = newc(0, 121, 241, 255)
DARKBLUE = newc(0, 82, 172, 255)
PURPLE = newc(200, 122, 255, 255)
VIOLET = newc(135, 60, 190, 255)
DARKPURPLE = newc(112, 31, 126, 255)
BEIGE = newc(211, 176, 131, 255)
BROWN = newc(127, 106, 79, 255)
DARKBROWN = newc(76, 63, 47, 255)
WHITE = newc(255, 255, 255, 255)
BLACK = newc(0, 0, 0, 255)
BLANK = newc(0, 0, 0, 0)
MAGENTA = newc(255, 0, 255, 255)
RAYWHITE = newc(245, 245, 245, 255)
MatrixToFloat = function(m) return r.MatrixToFloatV(m).v end
Vector3ToFloat = function(V) return r.Vector3ToFloatV(V).v end

InitWindow = r.InitWindow
WindowShouldClose = r.WindowShouldClose
CloseWindow = r.CloseWindow
SetTargetFPS = r.SetTargetFPS
ClearBackground = r.ClearBackground
BeginDrawing = r.BeginDrawing
EndDrawing = r.EndDrawing
IsWindowReady = r.IsWindowReady
IsWindowHidden = r.IsWindowHidden
IsWindowMinimized = r.IsWindowMinimized
IsWindowMaximized = r.IsWindowMaximized
IsWindowFocused = r.IsWindowFocused
IsWindowResized = r.IsWindowResized
IsWindowState = r.IsWindowState
SetWindowState = r.SetWindowState
ClearWindowState = r.ClearWindowState
ToggleFullscreen = r.ToggleFullscreen
MaximizeWindow = r.MaximizeWindow
MinimizeWindow = r.MinimizeWindow
RestoreWindow = r.RestoreWindow
SetWindowIcon = r.SetWindowIcon
SetWindowIcons = r.SetWindowIcons
SetWindowTitle = r.SetWindowTitle
SetWindowPosition = r.SetWindowPosition
SetWindowMonitor = r.SetWindowMonitor
SetWindowMinSize = r.SetWindowMinSize
SetWindowSize = r.SetWindowSize
SetWindowOpacity = r.SetWindowOpacity
GetWindowHandle = r.GetWindowHandle
GetScreenWidth = r.GetScreenWidth
GetScreenHeight = r.GetScreenHeight
GetRenderWidth = r.GetRenderWidth
GetRenderHeight = r.GetRenderHeight
GetMonitorCount = r.GetMonitorCount
GetCurrentMonitor = r.GetCurrentMonitor
GetMonitorPosition = r.GetMonitorPosition
GetMonitorWidth = r.GetMonitorWidth
GetMonitorHeight = r.GetMonitorHeight
GetMonitorPhysicalWidth = r.GetMonitorPhysicalWidth
GetMonitorPhysicalHeight = r.GetMonitorPhysicalHeight
GetMonitorRefreshRate = r.GetMonitorRefreshRate
GetWindowPosition = r.GetWindowPosition
GetWindowScaleDPI = r.GetWindowScaleDPI
GetMonitorName = r.GetMonitorName
SetClipboardText = r.SetClipboardText
GetClipboardText = r.GetClipboardText
EnableEventWaiting = r.EnableEventWaiting
DisableEventWaiting = r.DisableEventWaiting
SwapScreenBuffer = r.SwapScreenBuffer
PollInputEvents = r.PollInputEvents
WaitTime = r.WaitTime
ShowCursor = r.ShowCursor
HideCursor = r.HideCursor
IsCursorHidden = r.IsCursorHidden
EnableCursor = r.EnableCursor
DisableCursor = r.DisableCursor
IsCursorOnScreen = r.IsCursorOnScreen
BeginMode2D = r.BeginMode2D
EndMode2D = r.EndMode2D
BeginMode3D = r.BeginMode3D
EndMode3D = r.EndMode3D
BeginTextureMode = r.BeginTextureMode
EndTextureMode = r.EndTextureMode
BeginShaderMode = r.BeginShaderMode
EndShaderMode = r.EndShaderMode
BeginBlendMode = r.BeginBlendMode
EndBlendMode = r.EndBlendMode
BeginScissorMode = r.BeginScissorMode
EndScissorMode = r.EndScissorMode
BeginVrStereoMode = r.BeginVrStereoMode
EndVrStereoMode = r.EndVrStereoMode
LoadVrStereoConfig = r.LoadVrStereoConfig
UnloadVrStereoConfig = r.UnloadVrStereoConfig
LoadShader = r.LoadShader
LoadShaderFromMemory = r.LoadShaderFromMemory
IsShaderReady = r.IsShaderReady
GetShaderLocation = r.GetShaderLocation
GetShaderLocationAttrib = r.GetShaderLocationAttrib
SetShaderValue = r.SetShaderValue
SetShaderValueV = r.SetShaderValueV
SetShaderValueMatrix = r.SetShaderValueMatrix
SetShaderValueTexture = r.SetShaderValueTexture
UnloadShader = r.UnloadShader
GetMouseRay = r.GetMouseRay
GetCameraMatrix = r.GetCameraMatrix
GetCameraMatrix2D = r.GetCameraMatrix2D
GetWorldToScreen = r.GetWorldToScreen
GetScreenToWorld2D = r.GetScreenToWorld2D
GetWorldToScreenEx = r.GetWorldToScreenEx
GetWorldToScreen2D = r.GetWorldToScreen2D
IsWindowFullscreen = r.IsWindowFullscreen
GetFrameTime = r.GetFrameTime
GetTime = r.GetTime
GetRandomValue = r.GetRandomValue
SetRandomSeed = r.SetRandomSeed
TakeScreenshot = r.TakeScreenshot
SetConfigFlags = r.SetConfigFlags
TraceLog = r.TraceLog
SetTraceLogLevel = r.SetTraceLogLevel
MemAlloc = r.MemAlloc
MemRealloc = r.MemRealloc
MemFree = r.MemFree
OpenURL = r.OpenURL
SetTraceLogCallback = r.SetTraceLogCallback
SetLoadFileDataCallback = r.SetLoadFileDataCallback
SetSaveFileDataCallback = r.SetSaveFileDataCallback
SetLoadFileTextCallback = r.SetLoadFileTextCallback
SetSaveFileTextCallback = r.SetSaveFileTextCallback
LoadFileData = r.LoadFileData
UnloadFileData = r.UnloadFileData
SaveFileData = r.SaveFileData
ExportDataAsCode = r.ExportDataAsCode
LoadFileText = r.LoadFileText
UnloadFileText = r.UnloadFileText
SaveFileText = r.SaveFileText
FileExists = r.FileExists
DirectoryExists = r.DirectoryExists
IsFileExtension = r.IsFileExtension
GetFileLength = r.GetFileLength
GetFileExtension = r.GetFileExtension
GetFileName = r.GetFileName
GetFileNameWithoutExt = r.GetFileNameWithoutExt
GetDirectoryPath = r.GetDirectoryPath
GetPrevDirectoryPath = r.GetPrevDirectoryPath
GetWorkingDirectory = r.GetWorkingDirectory
GetApplicationDirectory = r.GetApplicationDirectory
ChangeDirectory = r.ChangeDirectory
IsPathFile = r.IsPathFile
LoadDirectoryFiles = r.LoadDirectoryFiles
LoadDirectoryFilesEx = r.LoadDirectoryFilesEx
UnloadDirectoryFiles = r.UnloadDirectoryFiles
IsFileDropped = r.IsFileDropped
LoadDroppedFiles = r.LoadDroppedFiles
UnloadDroppedFiles = r.UnloadDroppedFiles
GetFileModTime = r.GetFileModTime
CompressData = r.CompressData
DecompressData = r.DecompressData
EncodeDataBase64 = r.EncodeDataBase64
DecodeDataBase64 = r.DecodeDataBase64
IsKeyPressed = r.IsKeyPressed
IsKeyDown = r.IsKeyDown
IsKeyReleased = r.IsKeyReleased
IsKeyUp = r.IsKeyUp
SetExitKey = r.SetExitKey
GetKeyPressed = r.GetKeyPressed
GetCharPressed = r.GetCharPressed
IsGamepadAvailable = r.IsGamepadAvailable
GetGamepadName = r.GetGamepadName
IsGamepadButtonPressed = r.IsGamepadButtonPressed
IsGamepadButtonDown = r.IsGamepadButtonDown
IsGamepadButtonReleased = r.IsGamepadButtonReleased
IsGamepadButtonUp = r.IsGamepadButtonUp
GetGamepadButtonPressed = r.GetGamepadButtonPressed
GetGamepadAxisCount = r.GetGamepadAxisCount
GetGamepadAxisMovement = r.GetGamepadAxisMovement
SetGamepadMappings = r.SetGamepadMappings
IsMouseButtonPressed = r.IsMouseButtonPressed
IsMouseButtonDown = r.IsMouseButtonDown
IsMouseButtonReleased = r.IsMouseButtonReleased
IsMouseButtonUp = r.IsMouseButtonUp
GetMouseX = r.GetMouseX
GetMouseY = r.GetMouseY
GetMousePosition = r.GetMousePosition
GetMouseDelta = r.GetMouseDelta
SetMousePosition = r.SetMousePosition
SetMouseOffset = r.SetMouseOffset
SetMouseScale = r.SetMouseScale
GetMouseWheelMove = r.GetMouseWheelMove
GetMouseWheelMoveV = r.GetMouseWheelMoveV
SetMouseCursor = r.SetMouseCursor
GetTouchX = r.GetTouchX
GetTouchY = r.GetTouchY
GetTouchPosition = r.GetTouchPosition
GetTouchPointId = r.GetTouchPointId
GetTouchPointCount = r.GetTouchPointCount
SetGesturesEnabled = r.SetGesturesEnabled
IsGestureDetected = r.IsGestureDetected
GetGestureDetected = r.GetGestureDetected
GetGestureHoldDuration = r.GetGestureHoldDuration
GetGestureDragVector = r.GetGestureDragVector
GetGestureDragAngle = r.GetGestureDragAngle
GetGesturePinchVector = r.GetGesturePinchVector
GetGesturePinchAngle = r.GetGesturePinchAngle
UpdateCamera = r.UpdateCamera
UpdateCameraPro = r.UpdateCameraPro
SetShapesTexture = r.SetShapesTexture
DrawPixel = r.DrawPixel
DrawPixelV = r.DrawPixelV
DrawLine = r.DrawLine
DrawLineV = r.DrawLineV
DrawLineEx = r.DrawLineEx
DrawLineBezier = r.DrawLineBezier
DrawLineBezierQuad = r.DrawLineBezierQuad
DrawLineBezierCubic = r.DrawLineBezierCubic
DrawLineStrip = r.DrawLineStrip
DrawCircle = r.DrawCircle
DrawCircleSector = r.DrawCircleSector
DrawCircleSectorLines = r.DrawCircleSectorLines
DrawCircleGradient = r.DrawCircleGradient
DrawCircleV = r.DrawCircleV
DrawCircleLines = r.DrawCircleLines
DrawEllipse = r.DrawEllipse
DrawEllipseLines = r.DrawEllipseLines
DrawRing = r.DrawRing
DrawRingLines = r.DrawRingLines
DrawRectangle = r.DrawRectangle
DrawRectangleV = r.DrawRectangleV
DrawRectangleRec = r.DrawRectangleRec
DrawRectanglePro = r.DrawRectanglePro
DrawRectangleGradientV = r.DrawRectangleGradientV
DrawRectangleGradientH = r.DrawRectangleGradientH
DrawRectangleGradientEx = r.DrawRectangleGradientEx
DrawRectangleLines = r.DrawRectangleLines
DrawRectangleLinesEx = r.DrawRectangleLinesEx
DrawRectangleRounded = r.DrawRectangleRounded
DrawRectangleRoundedLines = r.DrawRectangleRoundedLines
DrawTriangle = r.DrawTriangle
DrawTriangleLines = r.DrawTriangleLines
DrawTriangleFan = r.DrawTriangleFan
DrawTriangleStrip = r.DrawTriangleStrip
DrawPoly = r.DrawPoly
DrawPolyLines = r.DrawPolyLines
DrawPolyLinesEx = r.DrawPolyLinesEx
CheckCollisionRecs = r.CheckCollisionRecs
CheckCollisionCircles = r.CheckCollisionCircles
CheckCollisionCircleRec = r.CheckCollisionCircleRec
CheckCollisionPointRec = r.CheckCollisionPointRec
CheckCollisionPointCircle = r.CheckCollisionPointCircle
CheckCollisionPointTriangle = r.CheckCollisionPointTriangle
CheckCollisionPointPoly = r.CheckCollisionPointPoly
CheckCollisionLines = r.CheckCollisionLines
CheckCollisionPointLine = r.CheckCollisionPointLine
GetCollisionRec = r.GetCollisionRec
LoadImage = r.LoadImage
LoadImageRaw = r.LoadImageRaw
LoadImageAnim = r.LoadImageAnim
LoadImageFromMemory = r.LoadImageFromMemory
LoadImageFromTexture = r.LoadImageFromTexture
LoadImageFromScreen = r.LoadImageFromScreen
IsImageReady = r.IsImageReady
UnloadImage = r.UnloadImage
ExportImage = r.ExportImage
ExportImageAsCode = r.ExportImageAsCode
GenImageColor = r.GenImageColor
GenImageGradientV = r.GenImageGradientV
GenImageGradientH = r.GenImageGradientH
GenImageGradientRadial = r.GenImageGradientRadial
GenImageChecked = r.GenImageChecked
GenImageWhiteNoise = r.GenImageWhiteNoise
GenImagePerlinNoise = r.GenImagePerlinNoise
GenImageCellular = r.GenImageCellular
GenImageText = r.GenImageText
ImageCopy = r.ImageCopy
ImageFromImage = r.ImageFromImage
ImageText = r.ImageText
ImageTextEx = r.ImageTextEx
ImageFormat = r.ImageFormat
ImageToPOT = r.ImageToPOT
ImageCrop = r.ImageCrop
ImageAlphaCrop = r.ImageAlphaCrop
ImageAlphaClear = r.ImageAlphaClear
ImageAlphaMask = r.ImageAlphaMask
ImageAlphaPremultiply = r.ImageAlphaPremultiply
ImageBlurGaussian = r.ImageBlurGaussian
ImageResize = r.ImageResize
ImageResizeNN = r.ImageResizeNN
ImageResizeCanvas = r.ImageResizeCanvas
ImageMipmaps = r.ImageMipmaps
ImageDither = r.ImageDither
ImageFlipVertical = r.ImageFlipVertical
ImageFlipHorizontal = r.ImageFlipHorizontal
ImageRotateCW = r.ImageRotateCW
ImageRotateCCW = r.ImageRotateCCW
ImageColorTint = r.ImageColorTint
ImageColorInvert = r.ImageColorInvert
ImageColorGrayscale = r.ImageColorGrayscale
ImageColorContrast = r.ImageColorContrast
ImageColorBrightness = r.ImageColorBrightness
ImageColorReplace = r.ImageColorReplace
LoadImageColors = r.LoadImageColors
LoadImagePalette = r.LoadImagePalette
UnloadImageColors = r.UnloadImageColors
UnloadImagePalette = r.UnloadImagePalette
GetImageAlphaBorder = r.GetImageAlphaBorder
GetImageColor = r.GetImageColor
ImageClearBackground = r.ImageClearBackground
ImageDrawPixel = r.ImageDrawPixel
ImageDrawPixelV = r.ImageDrawPixelV
ImageDrawLine = r.ImageDrawLine
ImageDrawLineV = r.ImageDrawLineV
ImageDrawCircle = r.ImageDrawCircle
ImageDrawCircleV = r.ImageDrawCircleV
ImageDrawCircleLines = r.ImageDrawCircleLines
ImageDrawCircleLinesV = r.ImageDrawCircleLinesV
ImageDrawRectangle = r.ImageDrawRectangle
ImageDrawRectangleV = r.ImageDrawRectangleV
ImageDrawRectangleRec = r.ImageDrawRectangleRec
ImageDrawRectangleLines = r.ImageDrawRectangleLines
ImageDraw = r.ImageDraw
ImageDrawText = r.ImageDrawText
ImageDrawTextEx = r.ImageDrawTextEx
LoadTexture = r.LoadTexture
LoadTextureFromImage = r.LoadTextureFromImage
LoadTextureCubemap = r.LoadTextureCubemap
LoadRenderTexture = r.LoadRenderTexture
IsTextureReady = r.IsTextureReady
UnloadTexture = r.UnloadTexture
IsRenderTextureReady = r.IsRenderTextureReady
UnloadRenderTexture = r.UnloadRenderTexture
UpdateTexture = r.UpdateTexture
UpdateTextureRec = r.UpdateTextureRec
GenTextureMipmaps = r.GenTextureMipmaps
SetTextureFilter = r.SetTextureFilter
SetTextureWrap = r.SetTextureWrap
DrawTexture = r.DrawTexture
DrawTextureV = r.DrawTextureV
DrawTextureEx = r.DrawTextureEx
DrawTextureRec = r.DrawTextureRec
DrawTexturePro = r.DrawTexturePro
DrawTextureNPatch = r.DrawTextureNPatch
Fade = r.Fade
ColorToInt = r.ColorToInt
ColorNormalize = r.ColorNormalize
ColorFromNormalized = r.ColorFromNormalized
ColorToHSV = r.ColorToHSV
ColorFromHSV = r.ColorFromHSV
ColorTint = r.ColorTint
ColorBrightness = r.ColorBrightness
ColorContrast = r.ColorContrast
ColorAlpha = r.ColorAlpha
ColorAlphaBlend = r.ColorAlphaBlend
GetColor = r.GetColor
GetPixelColor = r.GetPixelColor
SetPixelColor = r.SetPixelColor
GetPixelDataSize = r.GetPixelDataSize
GetFontDefault = r.GetFontDefault
LoadFont = r.LoadFont
LoadFontEx = r.LoadFontEx
LoadFontFromImage = r.LoadFontFromImage
LoadFontFromMemory = r.LoadFontFromMemory
IsFontReady = r.IsFontReady
LoadFontData = r.LoadFontData
GenImageFontAtlas = r.GenImageFontAtlas
UnloadFontData = r.UnloadFontData
UnloadFont = r.UnloadFont
ExportFontAsCode = r.ExportFontAsCode
DrawFPS = r.DrawFPS
DrawText = r.DrawText
DrawTextEx = r.DrawTextEx
DrawTextPro = r.DrawTextPro
DrawTextCodepoint = r.DrawTextCodepoint
DrawTextCodepoints = r.DrawTextCodepoints
MeasureText = r.MeasureText
MeasureTextEx = r.MeasureTextEx
GetGlyphIndex = r.GetGlyphIndex
GetGlyphInfo = r.GetGlyphInfo
GetGlyphAtlasRec = r.GetGlyphAtlasRec
LoadUTF8 = r.LoadUTF8
UnloadUTF8 = r.UnloadUTF8
LoadCodepoints = r.LoadCodepoints
UnloadCodepoints = r.UnloadCodepoints
GetCodepointCount = r.GetCodepointCount
GetCodepoint = r.GetCodepoint
GetCodepointNext = r.GetCodepointNext
GetCodepointPrevious = r.GetCodepointPrevious
CodepointToUTF8 = r.CodepointToUTF8
TextCopy = r.TextCopy
TextIsEqual = r.TextIsEqual
TextLength = r.TextLength
TextFormat = r.TextFormat
TextSubtext = r.TextSubtext
TextReplace = r.TextReplace
TextInsert = r.TextInsert
TextJoin = r.TextJoin
TextSplit = r.TextSplit
TextAppend = r.TextAppend
TextFindIndex = r.TextFindIndex
TextToUpper = r.TextToUpper
TextToLower = r.TextToLower
TextToPascal = r.TextToPascal
TextToInteger = r.TextToInteger
DrawLine3D = r.DrawLine3D
DrawPoint3D = r.DrawPoint3D
DrawCircle3D = r.DrawCircle3D
DrawTriangle3D = r.DrawTriangle3D
DrawTriangleStrip3D = r.DrawTriangleStrip3D
DrawCube = r.DrawCube
DrawCubeV = r.DrawCubeV
DrawCubeWires = r.DrawCubeWires
DrawCubeWiresV = r.DrawCubeWiresV
DrawSphere = r.DrawSphere
DrawSphereEx = r.DrawSphereEx
DrawSphereWires = r.DrawSphereWires
DrawCylinder = r.DrawCylinder
DrawCylinderEx = r.DrawCylinderEx
DrawCylinderWires = r.DrawCylinderWires
DrawCylinderWiresEx = r.DrawCylinderWiresEx
DrawCapsule = r.DrawCapsule
DrawCapsuleWires = r.DrawCapsuleWires
DrawPlane = r.DrawPlane
DrawRay = r.DrawRay
DrawGrid = r.DrawGrid
LoadModel = r.LoadModel
LoadModelFromMesh = r.LoadModelFromMesh
IsModelReady = r.IsModelReady
UnloadModel = r.UnloadModel
GetModelBoundingBox = r.GetModelBoundingBox
DrawModel = r.DrawModel
DrawModelEx = r.DrawModelEx
DrawModelWires = r.DrawModelWires
DrawModelWiresEx = r.DrawModelWiresEx
DrawBoundingBox = r.DrawBoundingBox
DrawBillboard = r.DrawBillboard
DrawBillboardRec = r.DrawBillboardRec
DrawBillboardPro = r.DrawBillboardPro
UploadMesh = r.UploadMesh
UpdateMeshBuffer = r.UpdateMeshBuffer
UnloadMesh = r.UnloadMesh
DrawMesh = r.DrawMesh
DrawMeshInstanced = r.DrawMeshInstanced
ExportMesh = r.ExportMesh
GetMeshBoundingBox = r.GetMeshBoundingBox
GenMeshTangents = r.GenMeshTangents
GenMeshPoly = r.GenMeshPoly
GenMeshPlane = r.GenMeshPlane
GenMeshCube = r.GenMeshCube
GenMeshSphere = r.GenMeshSphere
GenMeshHemiSphere = r.GenMeshHemiSphere
GenMeshCylinder = r.GenMeshCylinder
GenMeshCone = r.GenMeshCone
GenMeshTorus = r.GenMeshTorus
GenMeshKnot = r.GenMeshKnot
GenMeshHeightmap = r.GenMeshHeightmap
GenMeshCubicmap = r.GenMeshCubicmap
LoadMaterials = r.LoadMaterials
LoadMaterialDefault = r.LoadMaterialDefault
IsMaterialReady = r.IsMaterialReady
UnloadMaterial = r.UnloadMaterial
SetMaterialTexture = r.SetMaterialTexture
SetModelMeshMaterial = r.SetModelMeshMaterial
LoadModelAnimations = r.LoadModelAnimations
UpdateModelAnimation = r.UpdateModelAnimation
UnloadModelAnimation = r.UnloadModelAnimation
UnloadModelAnimations = r.UnloadModelAnimations
IsModelAnimationValid = r.IsModelAnimationValid
CheckCollisionSpheres = r.CheckCollisionSpheres
CheckCollisionBoxes = r.CheckCollisionBoxes
CheckCollisionBoxSphere = r.CheckCollisionBoxSphere
GetRayCollisionSphere = r.GetRayCollisionSphere
GetRayCollisionBox = r.GetRayCollisionBox
GetRayCollisionMesh = r.GetRayCollisionMesh
GetRayCollisionTriangle = r.GetRayCollisionTriangle
GetRayCollisionQuad = r.GetRayCollisionQuad
InitAudioDevice = r.InitAudioDevice
CloseAudioDevice = r.CloseAudioDevice
IsAudioDeviceReady = r.IsAudioDeviceReady
SetMasterVolume = r.SetMasterVolume
LoadWave = r.LoadWave
LoadWaveFromMemory = r.LoadWaveFromMemory
IsWaveReady = r.IsWaveReady
LoadSound = r.LoadSound
LoadSoundFromWave = r.LoadSoundFromWave
IsSoundReady = r.IsSoundReady
UpdateSound = r.UpdateSound
UnloadWave = r.UnloadWave
UnloadSound = r.UnloadSound
ExportWave = r.ExportWave
ExportWaveAsCode = r.ExportWaveAsCode
PlaySound = r.PlaySound
StopSound = r.StopSound
PauseSound = r.PauseSound
ResumeSound = r.ResumeSound
IsSoundPlaying = r.IsSoundPlaying
SetSoundVolume = r.SetSoundVolume
SetSoundPitch = r.SetSoundPitch
SetSoundPan = r.SetSoundPan
WaveCopy = r.WaveCopy
WaveCrop = r.WaveCrop
WaveFormat = r.WaveFormat
LoadWaveSamples = r.LoadWaveSamples
UnloadWaveSamples = r.UnloadWaveSamples
LoadMusicStream = r.LoadMusicStream
LoadMusicStreamFromMemory = r.LoadMusicStreamFromMemory
IsMusicReady = r.IsMusicReady
UnloadMusicStream = r.UnloadMusicStream
PlayMusicStream = r.PlayMusicStream
IsMusicStreamPlaying = r.IsMusicStreamPlaying
UpdateMusicStream = r.UpdateMusicStream
StopMusicStream = r.StopMusicStream
PauseMusicStream = r.PauseMusicStream
ResumeMusicStream = r.ResumeMusicStream
SeekMusicStream = r.SeekMusicStream
SetMusicVolume = r.SetMusicVolume
SetMusicPitch = r.SetMusicPitch
SetMusicPan = r.SetMusicPan
GetMusicTimeLength = r.GetMusicTimeLength
GetMusicTimePlayed = r.GetMusicTimePlayed
LoadAudioStream = r.LoadAudioStream
IsAudioStreamReady = r.IsAudioStreamReady
UnloadAudioStream = r.UnloadAudioStream
UpdateAudioStream = r.UpdateAudioStream
IsAudioStreamProcessed = r.IsAudioStreamProcessed
PlayAudioStream = r.PlayAudioStream
PauseAudioStream = r.PauseAudioStream
ResumeAudioStream = r.ResumeAudioStream
IsAudioStreamPlaying = r.IsAudioStreamPlaying
StopAudioStream = r.StopAudioStream
SetAudioStreamVolume = r.SetAudioStreamVolume
SetAudioStreamPitch = r.SetAudioStreamPitch
SetAudioStreamPan = r.SetAudioStreamPan
SetAudioStreamBufferSizeDefault = r.SetAudioStreamBufferSizeDefault
SetAudioStreamCallback = r.SetAudioStreamCallback
AttachAudioStreamProcessor = r.AttachAudioStreamProcessor
DetachAudioStreamProcessor = r.DetachAudioStreamProcessor
AttachAudioMixedProcessor = r.AttachAudioMixedProcessor
DetachAudioMixedProcessor = r.DetachAudioMixedProcessor
GetFPS = r.GetFPS
Clamp = r.Clamp
Lerp = r.Lerp
Normalize = r.Normalize
Remap = r.Remap
Wrap = r.Wrap
FloatEquals = r.FloatEquals
Vector2Zero = r.Vector2Zero
Vector2One = r.Vector2One
Vector2Add = r.Vector2Add
Vector2AddValue = r.Vector2AddValue
Vector2Subtract = r.Vector2Subtract
Vector2SubtractValue = r.Vector2SubtractValue
Vector2Length = r.Vector2Length
Vector2LengthSqr = r.Vector2LengthSqr
Vector2DotProduct = r.Vector2DotProduct
Vector2Distance = r.Vector2Distance
Vector2DistanceSqr = r.Vector2DistanceSqr
Vector2Angle = r.Vector2Angle
Vector2LineAngle = r.Vector2LineAngle
Vector2Scale = r.Vector2Scale
Vector2Multiply = r.Vector2Multiply
Vector2Negate = r.Vector2Negate
Vector2Divide = r.Vector2Divide
Vector2Normalize = r.Vector2Normalize
Vector2Transform = r.Vector2Transform
Vector2Lerp = r.Vector2Lerp
Vector2Reflect = r.Vector2Reflect
Vector2Rotate = r.Vector2Rotate
Vector2MoveTowards = r.Vector2MoveTowards
Vector2Invert = r.Vector2Invert
Vector2Clamp = r.Vector2Clamp
Vector2ClampValue = r.Vector2ClampValue
Vector2Equals = r.Vector2Equals
Vector3Zero = r.Vector3Zero
Vector3One = r.Vector3One
Vector3Add = r.Vector3Add
Vector3AddValue = r.Vector3AddValue
Vector3Subtract = r.Vector3Subtract
Vector3SubtractValue = r.Vector3SubtractValue
Vector3Scale = r.Vector3Scale
Vector3Multiply = r.Vector3Multiply
Vector3CrossProduct = r.Vector3CrossProduct
Vector3Perpendicular = r.Vector3Perpendicular
Vector3Length = r.Vector3Length
Vector3LengthSqr = r.Vector3LengthSqr
Vector3DotProduct = r.Vector3DotProduct
Vector3Distance = r.Vector3Distance
Vector3DistanceSqr = r.Vector3DistanceSqr
Vector3Angle = r.Vector3Angle
Vector3Negate = r.Vector3Negate
Vector3Divide = r.Vector3Divide
Vector3Normalize = r.Vector3Normalize
Vector3OrthoNormalize = r.Vector3OrthoNormalize
Vector3Transform = r.Vector3Transform
Vector3RotateByQuaternion = r.Vector3RotateByQuaternion
Vector3RotateByAxisAngle = r.Vector3RotateByAxisAngle
Vector3Lerp = r.Vector3Lerp
Vector3Reflect = r.Vector3Reflect
Vector3Min = r.Vector3Min
Vector3Max = r.Vector3Max
Vector3Barycenter = r.Vector3Barycenter
Vector3Unproject = r.Vector3Unproject
Vector3ToFloatV = r.Vector3ToFloatV
Vector3Invert = r.Vector3Invert
Vector3Clamp = r.Vector3Clamp
Vector3ClampValue = r.Vector3ClampValue
Vector3Equals = r.Vector3Equals
Vector3Refract = r.Vector3Refract
MatrixDeterminant = r.MatrixDeterminant
MatrixTrace = r.MatrixTrace
MatrixTranspose = r.MatrixTranspose
MatrixInvert = r.MatrixInvert
MatrixIdentity = r.MatrixIdentity
MatrixAdd = r.MatrixAdd
MatrixSubtract = r.MatrixSubtract
MatrixMultiply = r.MatrixMultiply
MatrixTranslate = r.MatrixTranslate
MatrixRotate = r.MatrixRotate
MatrixRotateX = r.MatrixRotateX
MatrixRotateY = r.MatrixRotateY
MatrixRotateZ = r.MatrixRotateZ
MatrixRotateXYZ = r.MatrixRotateXYZ
MatrixRotateZYX = r.MatrixRotateZYX
MatrixScale = r.MatrixScale
MatrixFrustum = r.MatrixFrustum
MatrixPerspective = r.MatrixPerspective
MatrixOrtho = r.MatrixOrtho
MatrixLookAt = r.MatrixLookAt
MatrixToFloatV = r.MatrixToFloatV
QuaternionAdd = r.QuaternionAdd
QuaternionAddValue = r.QuaternionAddValue
QuaternionSubtract = r.QuaternionSubtract
QuaternionSubtractValue = r.QuaternionSubtractValue
QuaternionIdentity = r.QuaternionIdentity
QuaternionLength = r.QuaternionLength
QuaternionNormalize = r.QuaternionNormalize
QuaternionInvert = r.QuaternionInvert
QuaternionMultiply = r.QuaternionMultiply
QuaternionScale = r.QuaternionScale
QuaternionDivide = r.QuaternionDivide
QuaternionLerp = r.QuaternionLerp
QuaternionNlerp = r.QuaternionNlerp
QuaternionSlerp = r.QuaternionSlerp
QuaternionFromVector3ToVector3 = r.QuaternionFromVector3ToVector3
QuaternionFromMatrix = r.QuaternionFromMatrix
QuaternionToMatrix = r.QuaternionToMatrix
QuaternionFromAxisAngle = r.QuaternionFromAxisAngle
QuaternionToAxisAngle = r.QuaternionToAxisAngle
QuaternionFromEuler = r.QuaternionFromEuler
QuaternionToEuler = r.QuaternionToEuler
QuaternionTransform = r.QuaternionTransform
QuaternionEquals = r.QuaternionEquals
