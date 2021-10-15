//---------------------------------------------------
// INCLUDE
//---------------------------------------------------

// C

#include "math.h"
#include "string.h"
#include "stdio.h"

// MATLAB

#include "mex.h"
#include "matrix.h"

// CUDA

#include "cuda.h"

//---------------------------------------------------
// MEX FUNCTION
//---------------------------------------------------

// cuda_get_capability - get the compute capability for the specified device
// ---------------------------------
//
// info = cuda_get_capability(n)
//
// Input:
// ------
//  n - device index
//
// Output:
// -------
//  info - array of major and minor 

//--------------------------------
// Author: William Hoagland
//--------------------------------
//--------------------------------

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])

{
	//--------------------------------------------
	// VARIABLES
	//--------------------------------------------
	
	CUresult cuStatus = CUDA_SUCCESS;
	int dordinal;
	CUdevice device;
	int maj, min;
	double *pr;
	
	//--------------------------------------------
	// Ordinal value of device to query, default is 0
	//--------------------------------------------

	if (nrhs > 0) {
		dordinal = (int) mxGetScalar(prhs[0]);
	} else {
		dordinal = 0;
	}

	//--------------------------------------------
	// COMPUTATION
	//--------------------------------------------
	
	//--
	// Initialize CUDA interface
	//--
	
	cuInit(0);
	
	//--------------------------------------------
	// OUTPUT
	//--------------------------------------------
	
	//--
	// allocate property output array
	//--
	
	plhs[0] = mxCreateDoubleMatrix(1, 2, mxREAL);
	pr = (double *) mxGetPr(plhs[0]);
	
	cuStatus = cuDeviceGet(&device, dordinal);

	if (cuStatus == CUDA_SUCCESS) {
		cuStatus = cuDeviceComputeCapability(&maj, &min, device);
	}
	if (cuStatus == CUDA_SUCCESS) {
		pr[0] = (double) maj;
		pr[1] = (double) min;
	}
	
	if (cuStatus != CUDA_SUCCESS)
	{			
		mexErrMsgTxt("Unable to query CUDA device.");
	}
}

