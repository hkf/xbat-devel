//---------------------------------------------------
// FUNCTIONS
//---------------------------------------------------

// max - max
//---------------------------------------------------

#ifndef max
 #define max(A,B) ((A) > (B) ? (A) : (B)) 
#endif

// min - min
//---------------------------------------------------

#ifndef min
 #define min(A,B) ((A) < (B) ? (A) : (B))
#endif

// summary - compute summary of buffer
// -----------------------------------------------------

void summary(
	FFT_TYPE *S, int F, FFT_TYPE *B, int bix, int nSUM, int six, SUM_TYPE mode
);

// median - compute median of a vector with variable stride indexing
// -----------------------------------------------------------------

// NOT IMPLEMENTED
FFT_TYPE median(FFT_TYPE *B, int nB, int stride);


// fast_specgram - spectrogram computation (norm or power)
// ----------------------------------------------------------

void fast_specgram (
	register FFT_TYPE *P, int F, int T,
	register FFT_TYPE *X, int nX, register FFT_TYPE *H, 
	int nH, int nFFT, int nLAP, SG_TYPE mode
);

// fast_specgram_complex - faster complex spectrogram computation
// ----------------------------------------------

void fast_specgram_complex (
	register FFT_TYPE *Br, register FFT_TYPE *Bi, int F, int T,
	register FFT_TYPE *X, int nX, register FFT_TYPE *H, 
	int nH, int nFFT, int nLAP
);

// fast_specgram_sum - faster spectrogram computation
// with summarization
// --------------------------------------------------

void fast_specgram_summary (
	FFT_TYPE *P, int F, int T, int nSUM,
	FFT_TYPE *X, int nX, FFT_TYPE *H, int nH, 
	int nFFT, int nLAP, SG_TYPE mode, SUM_TYPE sum_t,
	int quality
);
