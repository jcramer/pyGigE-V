from libcpp cimport bool

cdef extern from "gevapi.h":
    ctypedef int GEV_STATUS

    # // Structure Definition: GEV_CAMERA_INFO
    # typedef struct
    # {
    #   BOOL fIPv6;
    #   UINT32 ipAddr;
    #   UINT32 ipAddrLow;
    #   UINT32 ipAddrHigh;
    #   UINT32 macLow;
    #   UINT32 macHigh;
    #   GEV_NETWORK_INTERFACE host;
    #   UINT32 capabilities;
    #   char
    #   manufacturer[65];
    #   char
    #   model[65];
    #   char
    #   serial[65];
    #   char
    #   version[65];
    #   char
    #   username[65];
    # } GEV_CAMERA_INFO, *PGEV_CAMERA_INFO;
    ctypedef struct GEV_NETWORK_INTERFACE:
        pass

    ctypedef struct GEV_CAMERA_INFO:
        bool fIPv6
        int ipAddr
        int ipAddrLow
        int ipAddrHigh
        int macLow
        int macHigh
        GEV_NETWORK_INTERFACE host
        int capabilities
        char manufacturer[65]
        char model[65]
        char serial[65]
        char version[65]
        char username[65]

    ctypedef GEV_CAMERA_INFO* PGEV_CAMERA_INFO

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
# GEV_STATUS GevOpenCameraByAddress( unsigned long ip_address, GevAccessMode mode, GEV_CAMERA_HANDLE *handle);
# GEV_STATUS GevOpenCameraByName( char *name, GevAccessMode mode, GEV_CAMERA_HANDLE *handle);
# GEV_STATUS GevOpenCameraBySN( char *sn, GevAccessMode mode, GEV_CAMERA_HANDLE *handle);

# GEV_STATUS GevCloseCamera(GEV_CAMERA_HANDLE *handle);

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
# GEV_STATUS GevStopImageTransfer( GEV_CAMERA_HANDLE handle);
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

# GEV_STATUS GevReleaseImage( GEV_CAMERA_HANDLE handle, GEV_BUFFER_OBJECT *image_object_ptr);
# GEV_STATUS GevReleaseImageBuffer( GEV_CAMERA_HANDLE handle, void *image_buffer_ptr);

# //=================================================================================================
# // Camera event handling
# GEV_STATUS GevRegisterEventCallback(GEV_CAMERA_HANDLE handle,  UINT32 EventID, GEVEVENT_CBFUNCTION func, void *context);
# GEV_STATUS GevRegisterApplicationEvent(GEV_CAMERA_HANDLE handle,  UINT32 EventID, _EVENT appEvent);
# GEV_STATUS GevUnregisterEvent(GEV_CAMERA_HANDLE handle,  UINT32 EventID);
