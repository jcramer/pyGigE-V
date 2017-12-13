from pygigev import PyGigEV as gev
import timeit
import cv2

# create new context to store native camera data
ctx = gev()

# print list of available cameras
print ctx.GevGetCameraList()

# open the first detected camera - returns 'OK'
ctx.GevOpenCamera()

# get image parameters - returns python object of params
params = ctx.GevGetImageParameters()
print "Initial image parameters:"
print params

# camera sensor properties
width_max = 1936
height_max = 1216
binning = 0
saturation = 0
brightness = 0
contrast = 0

# desired properties
crop_factor = 1.0
width = int(width_max * 1/crop_factor)
height = int(height_max * 1/crop_factor)
x_offset = int((width_max - width) / 2)
y_offset = int((height_max - height) / 2)

ctx.GevSetImageParameters(width, height, x_offset, y_offset, params['pixelFormat'][0])
params = ctx.GevGetImageParameters()
print "Final image parameters:"
print params

width = params['width']
height = params['height'] 

# allocate image buffers and prepare for async image transfer to buffer
ctx.GevInitializeImageTransfer(1)

# start transfering images to memory buffer, use -1 for streaming or [1-9] for num frames 
ctx.GevStartImageTransfer(-1)

def reshapeAndDisplayImage(height, width):
    # simply return numpy array for first image in buffer
    img = ctx.GevGetImageBuffer().reshape(height, width) # is there a more efficient way to reshape?
    if width > 600 or height > 600:
        img = cv2.resize(img, (int(width*0.25),int(height*0.25)))
    cv2.imshow('pyGigE-V', img)

def reshape(height, width):
    img = ctx.GevGetImageBuffer()
    return img.reshape(height, width)

print timeit.timeit(stmt='reshape(height, width)', setup="from __main__ import reshape, width, height", number=1000)
print timeit.timeit(stmt='reshapeAndDisplayImage(height, width)', setup="from __main__ import reshapeAndDisplayImage, ctx, width, height", number=1000)

cv2.destroyAllWindows()

ctx.GevCloseCamera()