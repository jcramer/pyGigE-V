from pygigev import PyGigEV as gev

# create new context to store native camera data
cxt = gev()

# open the first detected camera - returns 'OK'
cxt.GevOpenCamera()

# get image parameters - returns python object of params
cxt.GevGetImageParameters()

# allocate image buffers and prepare for async image transfer to buffer
cxt.GevInitializeImageTransfer(8)

# start transfering images to memory buffer, use -1 for streaming or [1-9] for num frames 
cxt.GevStartImageTransfer(-1)

# Stop transfer, release memory, close camera connection 
cxt.GevStopImageTransfer() # not working at the moment
cxt.GevAbortImageTransfer() # not working at the moment
cxt.GevReleaseImage() # not working at the moment, will need to exit python to release memory
cxt.GevCloseCamera()
