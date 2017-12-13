### PyGigE-V

#### Minimal Python wrapper for Teledyne DALSA's GigE-V Framework
A python wrapper for some of the GigE-V Framework API methods.

#### Installing Python Package from source repo
1.  Install GigE-V framework 2.02 https://www.teledynedalsa.com/imaging/products/software/linux-gige-v/
2.  Download this repository locally
3.  Run `sudo python setup.py install` at the repo's root dir
4.  Test by running `python gevconsoledemo.py` example

#### Extending this module using Cython (for developemnt) 
1.  Install GigE-V framework 2.02 https://www.teledynedalsa.com/imaging/products/software/linux-gige-v/
2.  Download this repository locally
3.  Install cython via `pip install Cython`
4.  Change the USE_CYTHON flag to `True` in the setup.py file
5.  Build the module using `python setup.py build_ext --inplace`
6.  test by running `python gevconsoledemo.py` example