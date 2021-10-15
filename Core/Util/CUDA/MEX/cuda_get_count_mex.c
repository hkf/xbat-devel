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

// cuda_get_count - get count of CUDA devices
// ---------------------------------
//
// info = cuda_get_count
//
// Input:
// ------
//  NONE
//
// Output:
// -------
//  info - count of CUDA devices 

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
	int ccount;

	//--------------------------------------------
	// COMPUTATION
	//--------------------------------------------
	
	cuInit(0);
	
	cuStatus = cuDeviceGetCount(&ccount);

	//--
	// Output
	//--
	
	if (cuStatus == CUDA_SUCCESS) {
		plhs[0] = mxCreateScalarDouble((double) ccount);
	}
	
	if (cuStatus != CUDA_SUCCESS)
	{			
		mexErrMsgTxt("Unable to query CUDA device.");
	}
}

