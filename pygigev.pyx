import numpy as np

cimport numpy as np
from cython cimport view
from libc.stdlib cimport malloc, free

cimport decl

cdef class PyGigEV:
	cdef decl.GEV_CAMERA_INFO cameras
	cdef decl.GEV_CAMERA_HANDLE handle
	cdef decl.GEV_BUFFER_OBJECT* image_object_ptr
	cdef decl.UINT8[:, ::1] buffers
	cdef decl.UINT8** buffers_ptr
	cdef decl.UINT32 width
	cdef decl.UINT32 height
	cdef decl.UINT32 x_offset
	cdef decl.UINT32 y_offset
	cdef decl.UINT32 format

	def __cinit__(self):
		self.handle = NULL
		self.width = 0
		self.height = 0
		self.x_offset = 0
		self.y_offset = 0
		self.format = 0

	def __init__(self):
		self.GevGetCameraList()

	def GevGetCameraList(self, int maxCameras=1000):
		cdef int numCameras
		cdef decl.GEV_STATUS exitcode = 0
		exitcode = decl.GevGetCameraList(&self.cameras, maxCameras, &numCameras)
		return (self.handleExitCode(exitcode), self.cameras, numCameras)

	def GevOpenCamera(self, int gevAccessMode=4, int cameraListIndex=0):
		cdef decl.GEV_CAMERA_INFO _device = self.cameras  # what happens with multiple cameras in list??
		cdef decl.GEV_STATUS exitcode = 0
		exitcode = decl.GevOpenCamera(&_device, <decl.GevAccessMode>gevAccessMode, &self.handle)
		return self.handleExitCode(exitcode)

	def GevCloseCamera(self):
		cdef decl.GEV_STATUS exitcode = 0
		exitcode = decl.GevCloseCamera(&self.handle)
		free(self.buffers_ptr)
		return self.handleExitCode(exitcode)

	def GevGetCameraInterfaceOptions(self):
		cdef decl.GEV_CAMERA_OPTIONS options
		cdef decl.GEV_STATUS exitcode = 0
		exitcode = decl.GevGetCameraInterfaceOptions(self.handle, &options)
		return (self.handleExitCode(exitcode), options)

	def GevSetCameraInterfaceOptions(self, options):
		cdef decl.GEV_CAMERA_OPTIONS _options = options
		cdef decl.GEV_STATUS exitcode = 0
		exitcode = decl.GevSetCameraInterfaceOptions(self.handle, &_options)
		return self.handleExitCode(exitcode)

	def GevGetImageParameters(self):
		cdef decl.GEV_STATUS exitcode = 0
		exitcode = decl.GevGetImageParameters(self.handle, &self.width, &self.height, &self.x_offset, &self.y_offset, &self.format)
		return {'code': exitcode, 'width': self.width, 'height': self.height, 'x_offset': self.x_offset, 'y_offset': self.y_offset, 'pixelFormat':(self.format, hex(self.format))}

	def GevSetImageParameters(self, decl.UINT32 width, decl.UINT32 height, decl.UINT32 x_offset, decl.UINT32 y_offset, decl.UINT32 format):
		cdef decl.GEV_STATUS exitcode = 0
		exitcode = decl.GevSetImageParameters(self.handle, width, height, x_offset, y_offset, format)
		return self.handleExitCode(exitcode)

	def GevInitImageTransfer(self, int bufferCyclingMode=1, int numImgBuffers=8):
		cdef decl.GEV_STATUS exitcode = 0
		imgParams = self.GevGetImageParameters()
		cdef decl.UINT32 size = self.GetPixelSizeInBytes(imgParams['pixelFormat'][0]) * \
								imgParams['width'] * imgParams['height']

		# create variable to hold a image buffer
		self.buffers = np.empty(shape=[numImgBuffers,size], dtype=np.uint8, order="C")

		# create helper array to get a pointers
		self.buffers_ptr = <decl.UINT8**>malloc(numImgBuffers * sizeof(decl.UINT8*))

		# loop through buffer elements to addresses to store in helper array
		if not self.buffers_ptr: raise MemoryError
		try: 
			for i in range(numImgBuffers):
				self.buffers_ptr[i] = &self.buffers[i,0]

			exitcode = decl.GevInitImageTransfer(self.handle, <decl.GevBufferCyclingMode>bufferCyclingMode, numImgBuffers, &self.buffers_ptr[0])
		except:
			pass
		#finally:
			#free(buffers_ptr)

		return self.handleExitCode(exitcode)

	def GevInitializeImageTransfer(self, int numImgBuffers=8):
		cdef decl.GEV_STATUS exitcode = 0
		imgParams = self.GevGetImageParameters()
		cdef decl.UINT32 size = self.GetPixelSizeInBytes(imgParams['pixelFormat'][0]) * \
								imgParams['width'] * imgParams['height']

		# create variable to hold a image buffer
		self.buffers = np.empty(shape=[numImgBuffers,size], dtype=np.uint8, order="C")

		# create helper array to store image array pointers
		self.buffers_ptr = <decl.UINT8**>malloc(numImgBuffers * sizeof(decl.UINT8*))

		# loop through buffer elements to get addresses to store in helper array
		if not self.buffers_ptr: raise MemoryError
		try:
			for i in range(numImgBuffers):
				self.buffers_ptr[i] = &self.buffers[i,0]

			exitcode = decl.GevInitializeImageTransfer(self.handle, numImgBuffers, self.buffers_ptr)
		except:
			pass
		#finally:
			#free(buffers_ptr)

		return self.handleExitCode(exitcode)

	def GevStartImageTransfer(self, int numFrames):
		cdef decl.GEV_STATUS exitcode = 0
		exitcode = decl.GevStartImageTransfer(self.handle, <decl.UINT32>numFrames)
		return self.handleExitCode(exitcode)

	# partially working, can return an image in the buffer, but not properly through API
	def GevGetImageBuffer(self):
		return np.asarray(self.buffers[0,:])
		# cdef int size = self.height * self.width
		# cdef decl.UINT8** _buffer = NULL
		# cdef decl.GEV_STATUS exitcode = 0
		# exitcode = decl.GevGetImageBuffer(self.handle, <void**>_buffer)
		# cdef view.array buffer_view = view.array(shape=(size,), itemsize=sizeof(decl.UINT8), format="i", mode="c", allocate_buffer=False)
		# buffer_view.data = <char *> _buffer

		# print "exitcode: "
		# print exitcode

		# print "printing _buffer value"
		# print <unsigned int>_buffer
		# print "{0:x}".format(<unsigned int>_buffer)

		# print "printing handle value"
		# print "{0:x}".format(self.handle)
		# print "{0:x}".format(<unsigned int>&self.handle)

		# print "buffers addresses"
		# for i in range(8):
		# 	print "{0:x}".format(<unsigned int>&self.buffers[i,0])

		# print "buffers_ptr addresses"
		# for i in range(8):
		# 	print "{0:x}".format(<unsigned int>self.buffers_ptr[i])

		# print "returning as numpy array"
		# return np.asarray(buffer_view)

	# def GevWaitForNextImageBuffer(self, decl.UINT32 timeout=1000):
	# 	cdef void** buffer_ptr = NULL
	# 	cdef decl.GEV_STATUS exitcode
	# 	exitcode = decl.GevWaitForNextImageBuffer(self.handle, buffer_ptr, <decl.UINT32>timeout)
	# 	return exitcode

	# not working, struct returns weird values
	def GevWaitForNextImage(self, decl.UINT32 timeout=1000):
		cdef decl.GEV_BUFFER_OBJECT* img
		cdef decl.GEV_STATUS exitcode = 0
		exitcode = decl.GevWaitForNextImage(self.handle, &img, timeout)

		if img is NULL:
			return "NULL"

		print "buffer object"
		print "{0:x}".format(<unsigned int>&img)
		print "{0:x}".format(img.status)
		print img.status
		print img.state
		print img.w
		print img.h
		
		print "exitcode: " + str(exitcode)

		return str(img.status)

	# not working
	def GevStopImageTransfer(self):
		cdef decl.GEV_STATUS exitcode = 0
		exitcode = decl.GevStopImageTransfer(self.handle)
		return self.handleExitCode(exitcode)

	# not working
	def GevAbortImageTransfer(self):
		cdef decl.GEV_STATUS exitcode = 0
		exitcode = decl.GevAbortImageTransfer(self.handle)
		return self.handleExitCode(exitcode)
	
	# havn't tested since previous 2 aren't working
	def GevReleaseImageBuffer(self):
		cdef decl.GEV_STATUS exitcode = 0
		exitcode = decl.GevReleaseImageBuffer(self.handle, &self.buffers_ptr[0])
		return self.handleExitCode(exitcode)

	@staticmethod
	def GevApiInitialize():
		return decl.GevApiInitialize()
	
	@staticmethod
	def GevApiUninitialize():
		return decl.GevApiUninitialize()

	@staticmethod
	def GevGetLibraryConfigOptions():
		cdef decl.GEVLIB_CONFIG_OPTIONS options
		cdef decl.GEV_STATUS exitcode = 0
		exitcode = decl.GevGetLibraryConfigOptions(&options)
		return (exitcode, options)

	@staticmethod
	def GevSetLibraryConfigOptions(object options):
		cdef decl.GEVLIB_CONFIG_OPTIONS _options = options
		cdef decl.GEV_STATUS exitcode = 0
		exitcode = decl.GevGetLibraryConfigOptions(&_options)
		return exitcode

	@staticmethod
	def GevDeviceCount():
		return decl.GevDeviceCount()

	@staticmethod 
	def GetPixelSizeInBytes(int pixelFormat):
		return decl.GetPixelSizeInBytes(pixelFormat)

	@staticmethod 
	def GevGetPixelDepthInBits(int pixelFormat):
		return decl.GevGetPixelDepthInBits(pixelFormat)

	@staticmethod
	def handleExitCode(exitcode):
		if exitcode is not 0:
			return "Method returned code " + str(exitcode) + ", please check your camera's manual."
		else: return "OK"
