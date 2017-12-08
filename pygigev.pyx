# from libc.stdint cimport uintptr_t

cimport decl

cdef class GevCameraContext:
    cdef decl.GEV_CAMERA_INFO cameras
    cdef decl.GEV_CAMERA_HANDLE handle

    def __cinit__(self):
        self.handle = NULL

    def __init__(self):
        self.GevGetCameraList()

    def GevGetCameraList(self, int maxCameras=1000):
        cdef int numCameras
        cdef decl.GEV_STATUS exitcode
        exitcode = decl.GevGetCameraList(&self.cameras, maxCameras, &numCameras)
        return (self.handleExitCode(exitcode), self.cameras, numCameras)

    def GevOpenCamera(self, int gevAccessMode=4):
        cdef decl.GEV_CAMERA_INFO _device = self.cameras  # what happens with multiple cameras in list??
        cdef decl.GEV_STATUS exitcode
        exitcode = decl.GevOpenCamera(&_device, <decl.GevAccessMode>gevAccessMode, &self.handle)
        return self.handleExitCode(exitcode)

    def GevCloseCamera(self):
        cdef decl.GEV_STATUS exitcode
        exitcode = decl.GevCloseCamera(&self.handle)
        return self.handleExitCode(exitcode)

    def GevStartImageTransfer(self, int numFrames):
        cdef decl.GEV_STATUS exitcode
        exitcode = decl.GevStartImageTransfer(self.handle, <decl.UINT32>numFrames)
        return self.handleExitCode(exitcode)

    def GevStopImageTransfer(self):
        cdef decl.GEV_STATUS exitcode
        exitcode = decl.GevStopImageTransfer(self.handle)
        return self.handleExitCode(exitcode)

    @staticmethod
    def handleExitCode(exitcode):
        if exitcode is not 0:
            return "Method returned code " + str(exitcode) + ", please check your camera's manual."
        else: return "OK"

# //====================================================================
# // Public API
# //====================================================================
# // API Initialization
# GEV_STATUS	GevApiInitialize(void);
# GEV_STATUS	GevApiUninitialize(void);
def GevApiInitialize():
    return decl.GevApiInitialize()
def GevApiUninitialize():
    return decl.GevApiUninitialize()

# //====================================================================
# // API Configuratoin options
# GEV_STATUS GevGetLibraryConfigOptions( GEVLIB_CONFIG_OPTIONS *options);
# GEV_STATUS GevSetLibraryConfigOptions( GEVLIB_CONFIG_OPTIONS *options);
def GevGetLibraryConfigOptions():
    cdef decl.GEVLIB_CONFIG_OPTIONS options
    cdef decl.GEV_STATUS exitcode
    exitcode = decl.GevGetLibraryConfigOptions(&options)
    return (exitcode, options)
def GevSetLibraryConfigOptions(object options):
    cdef decl.GEVLIB_CONFIG_OPTIONS _options = options
    cdef decl.GEV_STATUS exitcode
    exitcode = decl.GevGetLibraryConfigOptions(&_options)
    return exitcode

# //=================================================================================================
# // Camera automatic discovery
# int GevDeviceCount(void);	// Get the number of Gev devices seen by the system.
# GEV_STATUS GevGetCameraList( GEV_CAMERA_INFO *cameras, int maxCameras, int *numCameras); // Automatically detect and list cameras.
def GevDeviceCount():
    return decl.GevDeviceCount()
def GevGetCameraList(int maxCameras):
    cdef decl.GEV_CAMERA_INFO cameras
    cdef int numCameras
    cdef decl.GEV_STATUS exitcode
    exitcode = decl.GevGetCameraList(&cameras, maxCameras, &numCameras)
    return (exitcode, cameras, numCameras)

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
def GevOpenCamera(object device, int mode):
    cdef decl.GEV_CAMERA_INFO _device = device
    cdef decl.GEV_CAMERA_HANDLE _handle = NULL
    cdef decl.GEV_STATUS exitcode
    exitcode = decl.GevOpenCamera(&_device, <decl.GevAccessMode>mode, &_handle)
    return (exitcode, _handle[0])

# GEV_STATUS GevCloseCamera(GEV_CAMERA_HANDLE *handle);
def GevCloseCamera(object handle):
    cdef decl.GEV_CAMERA_HANDLE _handle = <decl.GEV_CAMERA_HANDLE>handle
    cdef decl.GEV_STATUS exitcode
    exitcode = decl.GevCloseCamera(&_handle)
    return exitcode

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
def GevStartImageTransfer(object handle, int numFrames):
    cdef int exitcode
    exitcode = decl.GevStartImageTransfer(<decl.GEV_CAMERA_HANDLE>handle, <decl.UINT32>numFrames)
    return exitcode

def GevStopImageTransfer(object handle):
    cdef int exitcode
    exitcode = decl.GevStopImageTransfer(<decl.GEV_CAMERA_HANDLE>handle)
    return exitcode


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
def GevWaitForNextImage(object handle, int timeout):
    cdef decl.GEV_BUFFER_OBJECT* image_object_ptr
    cdef decl.GEV_STATUS exitcode
    exitcode = decl.GevWaitForNextImage(<decl.GEV_CAMERA_HANDLE>handle, &image_object_ptr, <decl.UINT32>timeout)
    return (exitcode, image_object_ptr[0])

# GEV_STATUS GevReleaseImage( GEV_CAMERA_HANDLE handle, GEV_BUFFER_OBJECT *image_object_ptr);
# GEV_STATUS GevReleaseImageBuffer( GEV_CAMERA_HANDLE handle, void *image_buffer_ptr);
def GevReleaseImage(object handle):
    cdef decl.GEV_BUFFER_OBJECT image_object_ptr
    cdef decl.GEV_STATUS exitcode
    exitcode = decl.GevReleaseImage(<decl.GEV_CAMERA_HANDLE>handle, &image_object_ptr)
    return (exitcode, image_object_ptr)

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
# UINT32 GevGetRGBPixelOrder( UINT32 pixelType);
# GEVLIB_STATUS GevTranslateRawPixelFormat( UINT32 rawFormat, PUINT32 translatedFormat, PUINT32 bitDepth, PUINT32 order);
# const char *GevGetFormatString( UINT32 format);

def GevGetPixelDepthInBits(unsigned long pixelType):
    return decl.GevGetPixelDepthInBits(<decl.UINT32>pixelType)