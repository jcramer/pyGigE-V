from pygigev import PyGigEV as gev
import cv2

# create new context to store native camera data
cxt = gev()

# open the first detected camera - returns 'OK'
cxt.GevOpenCamera()

# get image parameters - returns python object of params
params = cxt.GevGetImageParameters()
width = params['width']
height = params['height'] 

# allocate image buffers and prepare for async image transfer to buffer
cxt.GevInitializeImageTransfer(2)

# start transfering images to memory buffer, use -1 for streaming or [1-9] for num frames 
cxt.GevStartImageTransfer(-1)

while(True):
    # simply return numpy array for first image in buffer
    img = cxt.GevGetImageBuffer().reshape(height, width) # is there a more efficient way to reshape?
    cv2.imshow('pyGigE-V', img)
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break


cv2.destroyAllWindows()

# Stop transfer, release memory, close camera connection 
cxt.GevStopImageTransfer()  # not working at the moment
cxt.GevAbortImageTransfer() # not working at the moment
cxt.GevReleaseImage()       # not working at the moment, will need to exit python to release memory
cxt.GevCloseCamera()
