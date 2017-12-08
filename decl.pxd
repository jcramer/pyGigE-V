import numpy as np
cimport numpy as cnp
from libcpp cimport bool

# typedef signed char     INT8;
# typedef unsigned char   UINT8;
# typedef short           INT16;
# typedef unsigned short  UINT16;
# typedef float           FLOAT;
# typedef int             BOOL;
# typedef double		  DOUBLE;
# typedef long            INT32;
# typedef unsigned long   UINT32;
ctypedef char INT8
ctypedef unsigned char UINT8
ctypedef short INT16
ctypedef unsigned short UINT16
ctypedef int BOOL
ctypedef long INT32
ctypedef unsigned long UINT32

ctypedef UINT8* PUINT8

ctypedef UINT16 GEV_STATUS

# typedef struct
# {
# 	UINT32 version;
# 	UINT32 logLevel;
# 	UINT32 numRetries;
# 	UINT32 command_timeout_ms;
# 	UINT32 discovery_timeout_ms;
# 	UINT32 enumeration_port;
# 	UINT32 gvcp_port_range_start;
# 	UINT32 gvcp_port_range_end;
# } GEVLIB_CONFIG_OPTIONS, *PGEVLIB_CONFIG_OPTIONS;
ctypedef struct GEVLIB_CONFIG_OPTIONS:
    UINT32 version
    UINT32 logLevel
    UINT32 numRetries
    UINT32 command_timeout_ms
    UINT32 discovery_timeout_ms
    UINT32 enumeration_port
    UINT32 gvcp_port_range_start
    UINT32 gvcp_port_range_end

# // Buffer object structure - returned 
# typedef struct _tag_GEVBUF_ENTRY
# {
# 	UINT32 state;			// Full/empty state for image buffer
# 	UINT32 status;			// Frame Status (success, error types) (see below - GEV_FRAME_STATUS_*)
# 	UINT32 timestamp_hi;
# 	UINT32 timestamp_lo;
# 	UINT32 recv_size;		// Received size for buffer (allows variable sized data).
# 	UINT32 id;				// Block id for image (starts at 1, wraps to 1 at 65535).
# 	UINT32 h;				// Received heigth (pixels) for this buffer
# 	UINT32 w;				// Received width (pixels) for ROI in this buffer
# 	UINT32 x_offset;		// Received x offset for origin of ROI in this buffer
# 	UINT32 y_offset;		// Received y offset for origin of ROI in this buffer
# 	UINT32 x_padding;		// Received x padding bytes (invalid data padding end of each line [horizontal invalid])
# 	UINT32 y_padding;		// Received y padding bytes (invalid data padding end of image [vertical invalid])
# 	UINT32 d;				// Received depth (bytes per pixel) for this buffer
# 	UINT32 format;			// Received format for image.
# 	PUINT8 address;
# } GEVBUF_ENTRY, *PGEVBUF_ENTRY, GEVBUF_HEADER, *PGEVBUF_HEADER, GEV_BUFFER_OBJECT, *PGEV_BUFFER_OBJECT;
ctypedef struct GEV_BUFFER_OBJECT:
    UINT32 state
    UINT32 status
    UINT32 timestamp_hi
    UINT32 timestamp_lo
    UINT32 recv_size
    UINT32 id 
    UINT32 h
    UINT32 w
    UINT32 x_offset
    UINT32 y_offset
    UINT32 x_padding
    UINT32 y_padding
    UINT32 d
    UINT32 format
    PUINT8 address



ctypedef GEV_CAMERA_INFO* PGEV_CAMERA_INFO

ctypedef void* GEV_CAMERA_HANDLE

# typedef enum
# {
# 	GevMonitorMode = 0,
# 	GevControlMode = 2,
# 	GevExclusiveMode = 4
# } GevAccessMode;
ctypedef enum GevAccessMode:
    GevMonitorMode = 0 
    GevControlMode = 2
    GevExclusiveMode = 4

cdef extern from "gevapi.h":

    # typedef struct
    # {
    # 	BOOL fIPv6;				// GEV is only IPv4 for now.
    # 	UINT32 ipAddr;
    # 	UINT32 ipAddrLow;
    # 	UINT32 ipAddrHigh;
    # 	UINT32 ifIndex;		// Index of network interface (set by system - required for packet interface access).
    # } GEV_NETWORK_INTERFACE, *PGEV_NETWORK_INTERFACE;
    ctypedef struct GEV_NETWORK_INTERFACE:
        pass
        # BOOL fIPv6
        # UINT32 ipAddr
        # UINT32 ipAddrLow
        # UINT32 ipAddrHigh
        # UINT32 ifIndex

    # typedef struct
    # {
    # 	BOOL fIPv6;				// GEV is only IPv4 for now.
    # 	UINT32 ipAddr;
    # 	UINT32 ipAddrLow;
    # 	UINT32 ipAddrHigh;
    # 	UINT32 macLow;
    # 	UINT32 macHigh;
    # 	GEV_NETWORK_INTERFACE host;
    # 	UINT32 mode;
    # 	UINT32 capabilities;
    # 	char   manufacturer[MAX_GEVSTRING_LENGTH+1];
    # 	char   model[MAX_GEVSTRING_LENGTH+1];
    # 	char   serial[MAX_GEVSTRING_LENGTH+1];
    # 	char   version[MAX_GEVSTRING_LENGTH+1];
    # 	char   username[MAX_GEVSTRING_LENGTH+1];
    # } GEV_DEVICE_INTERFACE, *PGEV_DEVICE_INTERFACE, GEV_CAMERA_INFO, *PGEV_CAMERA_INFO;
    ctypedef struct GEV_CAMERA_INFO:
        BOOL fIPv6
        UINT32 ipAddr
        UINT32 ipAddrLow
        UINT32 ipAddrHigh
        UINT32 macLow
        UINT32 macHigh
        #GEV_NETWORK_INTERFACE host
        UINT32 capabilities
        char[65] manufacturer
        char[65] model
        char[65] serial
        char[65] version
        char[65] username

    # //====================================================================
    # // Public API
    # //====================================================================
    # // API Initialization
    # GEV_STATUS	GevApiInitialize(void);
    # GEV_STATUS	GevApiUninitialize(void);
    GEV_STATUS GevApiInitialize()
    GEV_STATUS GevApiUninitialize()

    # //====================================================================
    # // API Configuratoin options
    # GEV_STATUS GevGetLibraryConfigOptions( GEVLIB_CONFIG_OPTIONS *options);
    # GEV_STATUS GevSetLibraryConfigOptions( GEVLIB_CONFIG_OPTIONS *options);
    GEV_STATUS GevGetLibraryConfigOptions(GEVLIB_CONFIG_OPTIONS* options)
    GEV_STATUS GevSetLibraryConfigOptions(GEVLIB_CONFIG_OPTIONS* options)

    # //=================================================================================================
    # // Camera automatic discovery
    # int GevDeviceCount(void);	// Get the number of Gev devices seen by the system.
    # GEV_STATUS GevGetCameraList( GEV_CAMERA_INFO *cameras, int maxCameras, int *numCameras); // Automatically detect and list cameras.
    int GevDeviceCount()
    GEV_STATUS GevGetCameraList(GEV_CAMERA_INFO* cameras, int maxCameras, int* numCameras)

    # GEV_STATUS GevForceCameraIPAddress( UINT32 macHi, UINT32 macLo, UINT32 IPAddress, UINT32 subnetmask);
    # GEV_STATUS GevEnumerateNetworkInterfaces(GEV_NETWORK_INTERFACE *pIPAddr, UINT32 maxInterfaces, PUINT32 pNumInterfaces );

    # //=================================================================================================
    # // Utility function (external) for discovering camera devices.  
    # GEV_STATUS GevEnumerateGevDevices(GEV_NETWORK_INTERFACE *pIPAddr, UINT32 discoveryTimeout, GEV_DEVICE_INTERFACE *pDevice, UINT32 maxDevices, PUINT32 pNumDevices );

    # // Camera Manual discovery/setup 
    # GEV_STATUS GevSetCameraList( GEV_CAMERA_INFO *cameras, int numCameras); // Manually set camera list from data structure.

    # //=================================================================================================
    # // Gige Vision Camera Access
    # GEV_STATUS GevOpenCamera( GEV_CAMERA_INFO *device, GevAccessMode mode, GEV_CAMERA_HANDLE *handle);
    GEV_STATUS GevOpenCamera(GEV_CAMERA_INFO* device, GevAccessMode mode, GEV_CAMERA_HANDLE* handle)
    # GEV_STATUS GevOpenCameraByAddress( unsigned long ip_address, GevAccessMode mode, GEV_CAMERA_HANDLE *handle);
    # GEV_STATUS GevOpenCameraByName( char *name, GevAccessMode mode, GEV_CAMERA_HANDLE *handle);
    # GEV_STATUS GevOpenCameraBySN( char *sn, GevAccessMode mode, GEV_CAMERA_HANDLE *handle);

    # GEV_STATUS GevCloseCamera(GEV_CAMERA_HANDLE *handle);
    GEV_STATUS GevCloseCamera(GEV_CAMERA_HANDLE* handle)

    # GEV_CAMERA_INFO *GevGetCameraInfo( GEV_CAMERA_HANDLE handle);

    # GEV_STATUS GevGetCameraInterfaceOptions( GEV_CAMERA_HANDLE handle, GEV_CAMERA_OPTIONS *options);
    # GEV_STATUS GevSetCameraInterfaceOptions( GEV_CAMERA_HANDLE handle, GEV_CAMERA_OPTIONS *options);

    # //=================================================================================================
    # // Manual GigeVision access to GenICam XML File
    # GEV_STATUS Gev_RetrieveXMLData( GEV_CAMERA_HANDLE handle, int size, char *xml_data, int *num_read, int *data_is_compressed );
    # GEV_STATUS Gev_RetrieveXMLFile( GEV_CAMERA_HANDLE handle, char *file_name, int size, BOOL force_download );

    # //=================================================================================================
    # // GenICam XML Feature Node Map manual registration/access functions (for use in C++ code).
    # GEV_STATUS GevConnectFeatures(  GEV_CAMERA_HANDLE handle,  void *featureNodeMap);
    # void * GevGetFeatureNodeMap(  GEV_CAMERA_HANDLE handle);

    # //=================================================================================================
    # // GenICam XML Feature access functions (C language compatible).
    # GEV_STATUS GevGetGenICamXML_FileName( GEV_CAMERA_HANDLE handle, int size, char *xmlFileName);
    # GEV_STATUS GevInitGenICamXMLFeatures( GEV_CAMERA_HANDLE handle, BOOL updateXMLFile);
    # GEV_STATUS GevInitGenICamXMLFeatures_FromFile( GEV_CAMERA_HANDLE handle, char *xmlFileName);
    # GEV_STATUS GevInitGenICamXMLFeatures_FromData( GEV_CAMERA_HANDLE handle, int size, void *pXmlData);

    # GEV_STATUS GevGetFeatureValue( GEV_CAMERA_HANDLE handle, const char *feature_name, int *feature_type, int value_size, void *value);
    # GEV_STATUS GevSetFeatureValue( GEV_CAMERA_HANDLE handle, const char *feature_name, int value_size, void *value);
    # GEV_STATUS GevGetFeatureValueAsString( GEV_CAMERA_HANDLE handle, const char *feature_name, int *feature_type, int value_string_size, char *value_string);
    # GEV_STATUS GevSetFeatureValueAsString( GEV_CAMERA_HANDLE handle, const char *feature_name, const char *value_string);

    # //=================================================================================================
    # // Camera image acquisition
    # GEV_STATUS GevGetImageParameters(GEV_CAMERA_HANDLE handle,PUINT32 width, PUINT32 height, PUINT32 x_offset, PUINT32 y_offset, PUINT32 format);
    # GEV_STATUS GevSetImageParameters(GEV_CAMERA_HANDLE handle,UINT32 width, UINT32 height, UINT32 x_offset, UINT32 y_offset, UINT32 format);

    # GEV_STATUS GevInitImageTransfer( GEV_CAMERA_HANDLE handle, GevBufferCyclingMode mode, UINT32 numBuffers, UINT8 **bufAddress);
    # GEV_STATUS GevInitializeImageTransfer( GEV_CAMERA_HANDLE handle, UINT32 numBuffers, UINT8 **bufAddress);
    # GEV_STATUS GevFreeImageTransfer( GEV_CAMERA_HANDLE handle);
    # GEV_STATUS GevStartImageTransfer( GEV_CAMERA_HANDLE handle, UINT32 numFrames);
    GEV_STATUS GevStartImageTransfer(GEV_CAMERA_HANDLE handle, int numFrames)
    # GEV_STATUS GevStopImageTransfer( GEV_CAMERA_HANDLE handle);
    GEV_STATUS GevStopImageTransfer(GEV_CAMERA_HANDLE handle)
    # GEV_STATUS GevAbortImageTransfer( GEV_CAMERA_HANDLE handle);

    # GEV_STATUS GevQueryImageTransferStatus( GEV_CAMERA_HANDLE handle, PUINT32 pTotalBuffers, PUINT32 pNumUsed, PUINT32 pNumFree, PUINT32 pNumTrashed, GevBufferCyclingMode *pMode);
    # int GetPixelSizeInBytes (UINT32 pixelType);

    # // +Coming soon
    # GEV_STATUS GevResetImageTransfer( GEV_CAMERA_HANDLE handle );
    # // -Coming soon

    # GEV_STATUS GevGetNextImage( GEV_CAMERA_HANDLE handle, GEV_BUFFER_OBJECT **image_object_ptr, struct timeval *pTimeout);
    # GEV_STATUS GevGetImageBuffer( GEV_CAMERA_HANDLE handle, void **image_buffer);
    # GEV_STATUS GevGetImage( GEV_CAMERA_HANDLE handle, GEV_BUFFER_OBJECT **image_object);
    # GEV_STATUS GevWaitForNextImageBuffer( GEV_CAMERA_HANDLE handle, void **image_buffer, UINT32 timeout);
    # GEV_STATUS GevWaitForNextImage( GEV_CAMERA_HANDLE handle, GEV_BUFFER_OBJECT **image_object, UINT32 timeout);
    GEV_STATUS GevWaitForNextImage(GEV_CAMERA_HANDLE handle, GEV_BUFFER_OBJECT** image_object_ptr, int timeout)

    # GEV_STATUS GevReleaseImage( GEV_CAMERA_HANDLE handle, GEV_BUFFER_OBJECT *image_object_ptr);
    GEV_STATUS GevReleaseImage(GEV_CAMERA_HANDLE handle, GEV_BUFFER_OBJECT* image_object_ptr)
    # GEV_STATUS GevReleaseImageBuffer( GEV_CAMERA_HANDLE handle, void *image_buffer_ptr);

    # //=================================================================================================
    # // Camera event handling
    # GEV_STATUS GevRegisterEventCallback(GEV_CAMERA_HANDLE handle,  UINT32 EventID, GEVEVENT_CBFUNCTION func, void *context);
    # GEV_STATUS GevRegisterApplicationEvent(GEV_CAMERA_HANDLE handle,  UINT32 EventID, _EVENT appEvent);
    # GEV_STATUS GevUnregisterEvent(GEV_CAMERA_HANDLE handle,  UINT32 EventID);


    # BOOL GevIsPixelTypeMono( UINT32 pixelType);
    # BOOL GevIsPixelTypeRGB( UINT32 pixelType);
    # BOOL GevIsPixelTypeCustom( UINT32 pixelType);
    # BOOL GevIsPixelTypePacked( UINT32 pixelType);
    # UINT32 GevGetPixelSizeInBytes( UINT32 pixelType);
    # UINT32 GevGetPixelDepthInBits( UINT32 pixelType);
    UINT32 GevGetPixelDepthInBits(UINT32 pixelType)
    # UINT32 GevGetRGBPixelOrder( UINT32 pixelType);
    # GEVLIB_STATUS GevTranslateRawPixelFormat( UINT32 rawFormat, PUINT32 translatedFormat, PUINT32 bitDepth, PUINT32 order);
    # const char *GevGetFormatString( UINT32 format);
