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

// cuda_get_totalmem - get the total memory for the specified device
// ---------------------------------
//
// info = cuda_get_totalmem(n)
//
// Input:
// ------
//  n - device index
//
// Output:
// -------
//  info - total memory 

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
	unsigned int totalMem;
	
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
	
	cuInit(0);
	
	cuStatus = cuDeviceGet(&device, dordinal);

	if (cuStatus == CUDA_SUCCESS) {
		cuStatus = cuDeviceTotalMem(&totalMem, device);
	}
	
	//--
	// Output
	//--
	
	if (cuStatus == CUDA_SUCCESS) {
		plhs[0] = mxCreateScalarDouble((double) totalMem);
	}
	
	if (cuStatus != CUDA_SUCCESS)
	{			
		mexErrMsgTxt("Unable to query CUDA device.");
	}
}

