#include "mex.h"
#include "cuda.h"
#include "cuda_runtime.h"
#include "math_functions.h"
#include "driver_types.h"

#define BLOCK_SIZE 8

__global__ void stampalo(float*,int M, int N);

void convert_double2float( double *input_double, float *output_float,int Ntot);
void convert_float2double( float *input_float, double *output_double,int Ntot);
__global__ void initDelta(float* imInD,int M,int N, float k, float lambda, short type);

void mexFunction( int nlhs, mxArray *plhs[],
   int nrhs, const mxArray *prhs[])
{
	int N,M;
    int iter;
    double k,lambda;
    double* imIn, *diffN,*diffS,*diffW,*diffE, *imOut;
    float* fImIn, *fDiffN, *fDiffS, *fDiffW, *fDiffE, *fImOut;    
    float* imInD, *deltaN,*deltaS,*deltaW,*deltaE;
    int size,sizeDiff;
    short type;


	N = mxGetN(prhs[0]);
    M = mxGetM(prhs[0]);
    
	imIn = (double *)mxGetPr(prhs[0]);    
    
    size = M*N*sizeof(float);
 
    
    fImIn = (float *)malloc(size);
    
	mwSize dims[2];
    dims[0] = M;
    dims[1] = N;        
    
    

    
	convert_double2float(imIn,fImIn,N*M);    
    
    cudaMalloc((void **)&imInD,size);
	cudaMemcpy(imInD,fImIn,size,cudaMemcpyHostToDevice);
    


    iter = (int)mxGetScalar(prhs[1]);  
    k = (double)mxGetScalar(prhs[2]);  
    lambda = (double)mxGetScalar(prhs[3]);   
    type = (short)mxGetScalar(prhs[4]);   
 
    
    dim3 dimBlock(BLOCK_SIZE,BLOCK_SIZE);
    dim3 dimGrid(ceil(N / (float)dimBlock.x), ceil(M / (float)dimBlock.y));    
    
 
    for (int i=0;i<iter;++i) {
        initDelta<<<dimGrid,dimBlock>>>(imInD,M,N,(float)k,(float)lambda,type);
    }


    
        
        
	plhs[0]=mxCreateNumericArray(2,dims,mxDOUBLE_CLASS,mxREAL);
     
    
       
    
    imOut = (double *)mxGetPr(plhs[0]);   
    
    fImOut = (float *)malloc(size);
    cudaMemcpy(fImOut,imInD,size,cudaMemcpyDeviceToHost);      
 
    convert_float2double(fImOut,imOut,N*M); 
    

//	
}

void convert_double2float( double *input_double, float *output_float,int Ntot)
{
    int i;
    for (i = 0; i < Ntot; i++)
    {
                output_float[i] = (float) input_double[i];
    }
}

void convert_float2double( float *input_float, double *output_double,int Ntot)
{
    int i;
    for (i = 0; i < Ntot; i++)
    {
                output_double[i] = (double) input_float[i];
    }
}



__global__ void initDelta(float* imInD,int M,int N, float k, float lambda, short type) {
        int i = blockIdx.x * blockDim.x + threadIdx.x;
        int j = blockIdx.y * blockDim.y + threadIdx.y;
        int index = j + i*M;
        
        float deltaN=0, deltaS=0, deltaW=0, deltaE=0;
        float cN, cS, cW, cE;
        
        int indexN = (j)+(i-1)*(M);
        int indexS = (j)+(i+1)*(M);
        int indexW = (j-1)+(i)*(M);
        int indexE = (j+1)+(i)*(M);        
        
        if (i>1)
            deltaN = imInD[indexN]-imInD[index];
        if (i<N)
            deltaS = imInD[indexS]-imInD[index];    
        if (j>1)
            deltaW = imInD[indexW]-imInD[index];    
        if (j<M)
            deltaE = imInD[indexE]-imInD[index];   
        
        if (type==1) {
            cN = exp(-(pow((deltaN / k),2)));
            cS = exp(-(pow((deltaS / k),2)));
            cW = exp(-(pow((deltaW / k),2)));
            cE = exp(-(pow((deltaE / k),2)));  
        } else {
            cN = 1/(1+pow((deltaN / k),2));
            cS = 1/(1+pow((deltaS / k),2));
            cW = 1/(1+pow((deltaW / k),2));
            cE = 1/(1+pow((deltaE / k),2));        
        }
        
        imInD[index] += lambda*(cN*deltaN + cS*deltaS + cW*deltaW + cE*deltaE);      
        

        __syncthreads();    
}