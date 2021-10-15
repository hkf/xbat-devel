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

// cuda_get_name - get the name of the specified device
// ---------------------------------
//
// info = cuda_get_name(n)
//
// Input:
// ------
//  n - optional device index, default is 0
//
// Output:
// -------
//  info - array of major and minor 

//--------------------------------
// Author: William Hoagland
//--------------------------------
//--------------------------------

#define BUFLEN 1024

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])

{
	//--------------------------------------------
	// VARIABLES
	//--------------------------------------------
	
	CUresult cuStatus = CUDA_SUCCESS;
	int dordinal;
	CUdevice device;
	char buffer[BUFLEN];
	
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
	
	cuStatus = cuDeviceGet(&device, dordinal);

	if (cuStatus == CUDA_SUCCESS) {
		cuStatus = cuDeviceGetName(buffer, BUFLEN, device);
	}
	if (cuStatus == CUDA_SUCCESS) {
		plhs[0] = mxCreateString(buffer);
	}
	
	if (cuStatus != CUDA_SUCCESS)
	{			
		mexErrMsgTxt("Unable to query CUDA device.");
	}
}

