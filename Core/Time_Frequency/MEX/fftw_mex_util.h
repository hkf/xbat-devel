//---------------------------------------------------
// UTILITY FUNCTIONS
//---------------------------------------------------

// mx_to_fftw - convert matlab format to fftw complex array
// --------------------------------------------------------

void mx_to_fftw (
	register fftw_complex *X, register FFT_TYPE *Xr, register FFT_TYPE *Xi, int N
);

// fftw_to_mx - convert from fftw complex format to matlab format
// --------------------------------------------------------------

void fftw_to_mx (
	register FFT_TYPE *Xr, register FFT_TYPE *Xi, register fftw_complex *X, int N
);

// hc_fftw_to_mx - convert from fftw half-complex format to full matlab format
// ---------------------------------------------------------------------------

void hc_fftw_to_mx (
	register FFT_TYPE *Xr, register FFT_TYPE *Xi, register FFT_TYPE *X, int N
);

// hc_fftw_to_half_mx - convert from fftw half-complex format to half matlab format
// --------------------------------------------------------------------------------

void hc_fftw_to_half_mx (
	register FFT_TYPE *Xr, register FFT_TYPE *Xi, register FFT_TYPE *X, int N
);

// vec_power - compute pointwise power of complex vector
//------------------------------------------------------

void vec_power(FFT_TYPE *P, FFT_TYPE *re, FFT_TYPE *im, unsigned int N);

// vec_norm - compute poitwise norm of complex vector
//---------------------------------------------------

void vec_norm(FFT_TYPE *P, FFT_TYPE *re, FFT_TYPE *im, unsigned int N);

// hc_mult - multiply half complex arrays
// --------------------------------------

void hc_power_spectrum (FFT_TYPE *P, FFT_TYPE *X, int N);

// hc_power_spectrum - compute power spectrum for half complex array
// -----------------------------------------------------------------

void hc_mult (
	register FFT_TYPE *Y, register FFT_TYPE *X1, register FFT_TYPE *X2, int N
);


