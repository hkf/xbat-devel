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
// DEFINE
//---------------------------------------------------

#define CUDA_PROPERTIES_FIELDCOUNT 22

//---------------------------------------------------
// MEX FUNCTION
//---------------------------------------------------

// get_cuda_mex - get info on all CUDA capable devices available
// ---------------------------------
//
// info = get_cuda_mex()
//
// Input:
// ------
//  NONE
//
// Output:
// -------
//  info - array of cuda device property structures

//--------------------------------
// Author: William Hoagland
//--------------------------------
//--------------------------------

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])

{
	
	//--------------------------------------------
	// VARIABLES
	//--------------------------------------------
	
	int k, cCount, count;
	
	mxArray *d, *value[CUDA_PROPERTIES_FIELDCOUNT];
	
	int prop;
	
	CUresult cuStatus = CUDA_SUCCESS;
	
	//--
	// CUDA data structures
	//--

	CUdevice device;
	CUdevprop properties;
	
	//--
	// matlab structure fieldnames
	//--
	
	static CUdevice_attribute attributeSelector[CUDA_PROPERTIES_FIELDCOUNT] = {
		CU_DEVICE_ATTRIBUTE_MAX_THREADS_PER_BLOCK, 
		CU_DEVICE_ATTRIBUTE_MAX_BLOCK_DIM_X,
		CU_DEVICE_ATTRIBUTE_MAX_BLOCK_DIM_Y,
		CU_DEVICE_ATTRIBUTE_MAX_BLOCK_DIM_Z,
		CU_DEVICE_ATTRIBUTE_MAX_GRID_DIM_X,
		CU_DEVICE_ATTRIBUTE_MAX_GRID_DIM_Y,
		CU_DEVICE_ATTRIBUTE_MAX_GRID_DIM_Z,
		CU_DEVICE_ATTRIBUTE_MAX_SHARED_MEMORY_PER_BLOCK,
		CU_DEVICE_ATTRIBUTE_SHARED_MEMORY_PER_BLOCK,
		CU_DEVICE_ATTRIBUTE_TOTAL_CONSTANT_MEMORY,
		CU_DEVICE_ATTRIBUTE_WARP_SIZE,
		CU_DEVICE_ATTRIBUTE_MAX_PITCH,
		CU_DEVICE_ATTRIBUTE_MAX_REGISTERS_PER_BLOCK,
		CU_DEVICE_ATTRIBUTE_REGISTERS_PER_BLOCK,
		CU_DEVICE_ATTRIBUTE_CLOCK_RATE,
		CU_DEVICE_ATTRIBUTE_TEXTURE_ALIGNMENT,
		CU_DEVICE_ATTRIBUTE_GPU_OVERLAP,
		CU_DEVICE_ATTRIBUTE_MULTIPROCESSOR_COUNT,
		CU_DEVICE_ATTRIBUTE_KERNEL_EXEC_TIMEOUT,
		CU_DEVICE_ATTRIBUTE_INTEGRATED,
		CU_DEVICE_ATTRIBUTE_CAN_MAP_HOST_MEMORY,
		CU_DEVICE_ATTRIBUTE_COMPUTE_MODE
	};
	static char *attributeName[CUDA_PROPERTIES_FIELDCOUNT] = {
		"MAX_THREADS_PER_BLOCK", 
		"MAX_BLOCK_DIM_X",
		"MAX_BLOCK_DIM_Y",
		"MAX_BLOCK_DIM_Z",
		"MAX_GRID_DIM_X",
		"MAX_GRID_DIM_Y",
		"MAX_GRID_DIM_Z",
		"MAX_SHARED_MEMORY_PER_BLOCK",
		"SHARED_MEMORY_PER_BLOCK",
		"TOTAL_CONSTANT_MEMORY",
		"WARP_SIZE",
		"MAX_PITCH",
		"MAX_REGISTERS_PER_BLOCK",
		"REGISTERS_PER_BLOCK",
		"CLOCK_RATE",
		"TEXTURE_ALIGNMENT",
		"GPU_OVERLAP",
		"MULTIPROCESSOR_COUNT",
		"KERNEL_EXEC_TIMEOUT",
		"INTEGRATED",
		"CAN_MAP_HOST_MEMORY",
		"COMPUTE_MODE"
	};
	
	//--------------------------------------------
	// COMPUTATION
	//--------------------------------------------
	
	//--
	// Initialize CUDA interface
	//
	
	cuInit(0);
	
	//--
	// get device count
	//--
	
	cuDeviceGetCount(&cCount);
	
	//--------------------------------------------
	// OUTPUT
	//--------------------------------------------
	
	//--
	// allocate property info structures
	//--
	
	d = plhs[0] = mxCreateStructMatrix(1, cCount, CUDA_PROPERTIES_FIELDCOUNT, attributeName);
	
	//--
	// for each device
	//--
	for (count = 0; count < cCount; count++) {
		cuDeviceGet(&device, count);

		//--
		// get attributes and add to structure
		//--
			
		for (k = 0; k < CUDA_PROPERTIES_FIELDCOUNT; k++) {
			cuDeviceGetAttribute(&prop, attributeSelector[k], device);
			value[k] = mxCreateScalarDouble((double) prop);
			mxSetField(d, count, attributeName[k], value[k]);
		}
	}
	
	if (cuStatus != CUDA_SUCCESS)
	{			
		mexErrMsgTxt("Unable to query CUDA devices.");
	}
}

