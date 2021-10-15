//----------------------------------------------
// INCLUDE FILES
//----------------------------------------------
	
// C

#include "stdlib.h"
#include "math.h"

// Matlab
	
#include "mex.h"
#include "matrix.h"

//----------------------------------------------
// FUNCTIONS
//----------------------------------------------

//			 
// morph_gradient_double - morphological gradient
// ----------------------------------------------
// 
// Input:
// ------
//  *X - pointer to image array  (double *, (m * n))
//  m, n - number of image rows and columns (int)
//  *B - pointer to structuring element array (unsigned char *, (2*p + 1)*(2*q + 1))
//  p, q - structuring element support parameters (int)
//  *Z - pointer to mask image array (uint8 *, (m * n))
//
// Output:
// -------
//  *Y - pointer to gradient image (uint8 *, (m - 2*p)*(n - 2*q))
//

void morph_gradient_double (
	double *Y,
	double *X, int m, int n,
	unsigned char *B, int p, int q,
	unsigned char *Z);
	
void morph_gradient_double (
	double *Y,
	double *X, int m, int n,
	unsigned char *B, int p, int q,
	unsigned char *Z)

{
		
	 int m_p, n_q;
	
	 register int i, j, jj, k, kk, l, ij;
	
	 int s, *Vx, *Vy, *J, sh, sp;
	
	 register double xx, x1, x2, L, U, t;  
	
	//--
  	// size of SE
  	//--
				  		
	s = 0.0;

	for (k = 0; k < (2*p + 1)*(2*q + 1); k++) {
		if (*(B + k)) {
			s++;
		}
	}
	
	sh = s/2;
	sp = s - 2*sh;

	//--
	// SE displacement vectors
	//--
	
	Vx = (int *) mxCalloc(s, sizeof(int));
	Vy = (int *) mxCalloc(s, sizeof(int));
	
	k = 0;
	
	for (j = 0; j < (2*q + 1); j++) {
	for (i = 0; i < (2*p + 1); i++) {
	
		if (*(B + i + (2*p + 1)*j)) {
			*(Vy + k) = i - p;
			*(Vx + k) = j - q;
			k++;
		}
		
	}
	}
	
	//--
	// SE index jumps
	//--
	
	J = mxCalloc(s, sizeof(int));
	
	for (kk = 0; kk < s; kk++) {
		*(J + kk) += *(Vy + kk) + (*(Vx + kk) * m);
	}

	//--
	// FULL COMPUTATION
	//--
	
	if (Z == NULL) {
	
		// loop over image
		
		n_q = n - q;
		m_p = m - p;
		
	  	for (j = q; j < n_q; j++) {
	  	for (i = p; i < m_p; i++) {
			
			// loop over structuring element support in pairs
			
			ij = i + (j * m);
			
			L = *(X + ij);
			U = *(X + ij);
			
			for (kk = 0; kk < s - 1; kk = kk + 2) {
		        
				jj = ij + *(J + kk);
				x1 = *(X + jj);
				
				jj = ij + *(J + kk + 1);
				x2 = *(X + jj);
				
				// sort couple
				
				if (x1 > x2) {
					xx = x1;
					x1 = x2;
					x2 = xx;
				}
				
				if (x1 < L) {
					L = x1;
				}
				
				if (x2 > U) {
					U = x2;
				} 
		      
			}
			
			if (sp) {
			
				jj = ij + *(J + s - 1);
				xx = *(X + jj);
								
				if (xx < L) {
					L = xx;
				} else if (xx > U) {
					U = xx;
				}
				
			}
						
			// gradient
					
			ij = (i - p) + ((j - q) * (m - 2*p));
								
			*(Y + ij) = U - L;
		
		} 
		}
	
	//--
	// MASKED COMPUTATION
	//--
	
	} else {
			
		// loop over image
	
	  	n_q = n - q;
		m_p = m - p;
		
	  	for (j = q; j < n_q; j++) {
	  	for (i = p; i < m_p; i++) {
	  		  	
	  		ij = i + (j * m);
	  			
	  		if (*(Z + ij)) {
				
				// loop over structuring element support
							
				L = *(X + ij);
				U = *(X + ij);
				
				for (kk = 0; kk < s - 1; kk == kk + 2) {
			        
					jj = ij + *(J + kk);
					x1 = *(X + jj);
					
					jj = ij + *(J + kk + 1);
					x2 = *(X + jj);
					
					if (x1 > x2) {
						xx = x1;
						x1 = x2;
						x2 = xx;
					}
					
					if (x1 < L) {
						L = x1;
					}
					
					if (x2 > U) {
						U = x2;
					} 
							      
				} 
				
				if (sp) {
			
					xx = *(X + s - 1);
					
					if (xx < L) {
						L = xx;
					} else if (xx > U) {
						U = xx;
					}
					
				}
					
				// gradient
				
				ij = (i - p) + ((j - q) * (m - 2*p));
							
				*(Y + ij) = U - L;
				
			} else {
						
				// leave unchanged
				
				ij = (i - p) + ((j - q) * (m - 2*p));
					
				*(Y + ij) = 0;
				
			}
		
		} 
		}
	
	}
	
}

//			 
// morph_gradient_uint8 - morphological gradient
// ------------------------------------------
// 
// Input:
// ------
//  *X - pointer to image array  (unsigned char *, (m * n))
//  m, n - number of image rows and columns (int)
//  *B - pointer to structuring element array (unsigned char *, (2*p + 1)*(2*q + 1))
//  p, q - structuring element support parameters (int)
//  *Z - pointer to mask image array (uint8 *, (m * n))
//
// Output:
// -------
//  *Y - pointer to gradient image (uint8 *, (m - 2*p)*(n - 2*q))
//

void morph_gradient_uint8 (
	unsigned char *Y,
	unsigned char *X, int m, int n,
	unsigned char *B, int p, int q,
	unsigned char *Z);
	
void morph_gradient_uint8 (
	unsigned char *Y,
	unsigned char *X, int m, int n,
	unsigned char *B, int p, int q,
	unsigned char *Z)

{

	 int m_p, n_q;
			
	 register int i, j, jj, k, kk, l, ij;
	
	 int s, *Vx, *Vy, *J, sh, sp;
	
	 register unsigned char xx, x1, x2, L, U, t;  
	
	//--
  	// size of SE
  	//--
				  		
	s = 0.0;

	for (k = 0; k < (2*p + 1)*(2*q + 1); k++) {
		if (*(B + k)) {
			s++;
		}
	}
	
	sh = s/2;
	sp = s - 2*sh;

	//--
	// SE displacement vectors
	//--
	
	Vx = (int *) mxCalloc(s, sizeof(int));
	Vy = (int *) mxCalloc(s, sizeof(int));
	
	k = 0;
	
	for (j = 0; j < (2*q + 1); j++) {
	for (i = 0; i < (2*p + 1); i++) {
	
		if (*(B + i + (2*p + 1)*j)) {
			*(Vy + k) = i - p;
			*(Vx + k) = j - q;
			k++;
		}
		
	}
	}
	
	//--
	// SE index jumps
	//--
	
	J = mxCalloc(s, sizeof(int));
	
	for (kk = 0; kk < s; kk++) {
		*(J + kk) += *(Vy + kk) + (*(Vx + kk) * m);
	}

	//--
	// FULL COMPUTATION
	//--
	
	if (Z == NULL) {
	
		// loop over image
		
		n_q = n - q;
		m_p = m - p;
		
	  	for (j = q; j < n_q; j++) {
	  	for (i = p; i < m_p; i++) {
			
			// loop over structuring element support in pairs
			
			ij = i + (j * m);
			
			L = *(X + ij);
			U = *(X + ij);
			
			for (kk = 0; kk < s - 1; kk = kk + 2) {
		        
				jj = ij + *(J + kk);
				x1 = *(X + jj);
				
				jj = ij + *(J + kk + 1);
				x2 = *(X + jj);
				
				if (x1 > x2) {
					xx = x1;
					x1 = x2;
					x2 = xx;
				}
				
				if (x1 < L) {
					L = x1;
				}
				
				if (x2 > U) {
					U = x2;
				} 
		      
			}
			
			if (sp) {
			
				xx = *(X + s - 1);
				
				if (xx < L) {
					L = xx;
				} else if (xx > U) {
					U = xx;
				}
				
			}
						
			// gradient
					
			ij = (i - p) + ((j - q) * (m - 2*p));
								
			*(Y + ij) = U - L;
		
		} 
		}
	
	//--
	// MASKED COMPUTATION
	//--
	
	} else {
			
		// loop over image
	
	  	n_q = n - q;
		m_p = m - p;
		
	  	for (j = q; j < n_q; j++) {
	  	for (i = p; i < m_p; i++) {
	  		  
	  		ij = i + (j * m);
	  				
	  		if (*(Z + ij)) {
				
				// loop over structuring element support
							
				L = *(X + ij);
				U = *(X + ij);
				
				for (kk = 0; kk < s - 1; kk == kk + 2) {
			        
					jj = ij + *(J + kk);
					x1 = *(X + jj);
					
					jj = ij + *(J + kk + 1);
					x2 = *(X + jj);
					
					if (x1 > x2) {
						xx = x1;
						x1 = x2;
						x2 = xx;
					}
					
					if (x1 < L) {
						L = x1;
					}
					
					if (x2 > U) {
						U = x2;
					} 
							      
				} 
				
				if (sp) {
			
					xx = *(X + s - 1);
					
					if (xx < L) {
						L = xx;
					} else if (xx > U) {
						U = xx;
					}
					
				}
					
				// gradient
				
				ij = (i - p) + ((j - q) * (m - 2*p));
							
				*(Y + ij) = U - L;
				
			} else {
						
				// leave unchanged
				
				ij = (i - p) + ((j - q) * (m - 2*p));
					
				*(Y + ij) = 0;
				
			}
		
		} 
		}
	
	}
	
}

// morph_inner_double - morphological inner gradient
// -------------------------------------------------
// 
// Input:
// ------
//  *X - pointer to image array  (double *, (m * n))
//  m, n - number of image rows and columns (int)
//  *B - pointer to structuring element array (unsigned char *, (2*p + 1)*(2*q + 1))
//  p, q - structuring element support parameters (int)
//  *Z - pointer to mask image array (unsigned char *, (m * n))
//
// Output:
// -------
//  *Y - pointer to gradient image (double *, (m - 2*p)*(n - 2*q))
//

void morph_inner_double (
	double *Y,
	double *X, int m, int n,
	unsigned char *B, int p, int q,
	unsigned char *Z);
	
void morph_inner_double (
	double *Y,
	double *X, int m, int n,
	unsigned char *B, int p, int q,
	unsigned char *Z)

{
		
	 int m_p, n_q;
	 
	 int i, j, jj, k, kk, l, ij;
	
	 int s, *Vx, *Vy, *J;
	
	 double xx, c, L, t;  
	
	//--
  	// size of SE
  	//--
				  		
	s = 0.0;

	for (k = 0; k < (2*p + 1)*(2*q + 1); k++) {
		if (*(B + k)) {
			s++;
		}
	}

	//--
	// SE displacement vectors
	//--
	
	Vx = (int *) mxCalloc(s, sizeof(int));
	Vy = (int *) mxCalloc(s, sizeof(int));
	
	k = 0;
	
	for (j = 0; j < (2*q + 1); j++) {
	for (i = 0; i < (2*p + 1); i++) {
	
		if (*(B + i + (2*p + 1)*j)) {
			*(Vy + k) = i - p;
			*(Vx + k) = j - q;
			k++;
		}
		
	}
	}
	
	//--
	// SE index jumps
	//--
	
	J = mxCalloc(s, sizeof(int));
	
	for (kk = 0; kk < s; kk++) {
		*(J + kk) += *(Vy + kk) + (*(Vx + kk) * m);
	}
	
	//--
	// FULL COMPUTATION
	//--
	
	if (Z == NULL) {
	
		// loop over image
		
		n_q = n - q;
		m_p = m - p;
		
	  	for (j = q; j < n_q; j++) {
	  	for (i = p; i < m_p; i++) {

			// loop over structuring element support
			
			ij = i + (j * m);

			c = *(X + ij);
			L = *(X + ij);
			
			for (kk = 0; kk < s; kk++) {
		        
				jj = ij + *(J + kk);
				
				xx = *(X + jj);
				
				if (xx < L) {
					L = xx;
				} 

			}
			
			// compute inner gradient
					
			ij = (i - p) + ((j - q) * (m - 2*p));
								
			*(Y + ij) = c - L;
		
		} 
		}
	
	//--
	// MASKED COMPUTATION
	//--
	
	} else {
		
		// loop over image
	
	  	n_q = n - q;
		m_p = m - p;
		
	  	for (j = q; j < n_q; j++) {
	  	for (i = p; i < m_p; i++) {
	  		 
	  		ij = i + (j * m);
	  		 		
	  		if (*(Z + ij)) {
					
				// loop over structuring element support
			
				L = *(X + ij);
				c = *(X + ij);
				
				for (kk = 0; kk < s; kk++) {
			        
					jj = ij + *(J + kk);
					
					xx = *(X + jj);
					
					if (xx < L) {
						L = xx;
					} 

				}
				
				// compute inner gradient
						
				ij = (i - p) + ((j - q) * (m - 2*p));
									
				*(Y + ij) = c - L;
				
			} else {
						
				// leave unchanged
				
				ij = (i - p) + ((j - q) * (m - 2*p));
					
				*(Y + ij) = *(X + i + (j * m));
				
			}
		
		} 
		}
	
	}
	
}

// morph_inner_uint8 - morphological inner gradient
// ------------------------------------------------
// 
// Input:
// ------
//  *X - pointer to image array  (unsigned char *, (m * n))
//  m, n - number of image rows and columns (int)
//  *B - pointer to structuring element array (unsigned char *, (2*p + 1)*(2*q + 1))
//  p, q - structuring element support parameters (int)
//  *Z - pointer to mask image array (uint8 *, (m * n))
//
// Output:
// -------
//  *Y - pointer to gradient image (uint8 *, (m - 2*p)*(n - 2*q))
//


void morph_inner_uint8 (
	unsigned char *Y,
	unsigned char *X, int m, int n,
	unsigned char *B, int p, int q,
	unsigned char *Z);
	
void morph_inner_uint8 (
	unsigned char *Y,
	unsigned char *X, int m, int n,
	unsigned char *B, int p, int q,
	unsigned char *Z)

{
		
	 int m_p, n_q;
	
	 int i, j, jj, k, kk, l, ij;
	
	 int s, *Vx, *Vy, *J;
	
	 unsigned char xx, c, L, t;  
	
	//--
  	// size of SE
  	//--
				  		
	s = 0.0;

	for (k = 0; k < (2*p + 1)*(2*q + 1); k++) {
		if (*(B + k)) {
			s++;
		}
	}

	//--
	// SE displacement vectors
	//--
	
	Vx = (int *) mxCalloc(s, sizeof(int));
	Vy = (int *) mxCalloc(s, sizeof(int));
	
	k = 0;
	
	for (j = 0; j < (2*q + 1); j++) {
	for (i = 0; i < (2*p + 1); i++) {
	
		if (*(B + i + (2*p + 1)*j)) {
			*(Vy + k) = i - p;
			*(Vx + k) = j - q;
			k++;
		}
		
	}
	}
	
	//--
	// SE index jumps
	//--
	
	J = mxCalloc(s, sizeof(int));
	
	for (kk = 0; kk < s; kk++) {
		*(J + kk) += *(Vy + kk) + (*(Vx + kk) * m);
	}

	//--
	// FULL COMPUTATION
	//--
	
	if (Z == NULL) {
	
		// loop over image
		
	  	n_q = n - q;
		m_p = m - p;
		
	  	for (j = q; j < n_q; j++) {
	  	for (i = p; i < m_p; i++) {
	  					
			// loop over structuring element support
			
			ij = i + (j * m);

			L = *(X + ij);
			c = *(X + ij);
			
			for (kk = 0; kk < s; kk++) {
		        
				jj = ij + *(J + kk);
				
				xx = *(X + jj);
				
				if (xx < L) {
					L = xx;
				} 
						      
			}
			
			// compute inner gradient
					
			ij = (i - p) + ((j - q) * (m - 2*p));
								
			*(Y + ij) = c - L;
		
		} 
		}
	
	//--
	// MASKED COMPUTATION
	//--
	
	} else {
			
		// loop over image
	
	  	n_q = n - q;
		m_p = m - p;
		
	  	for (j = q; j < n_q; j++) {
	  	for (i = p; i < m_p; i++) {
	  		  		
	  		ij = i + (j * m);
	  		
	  		if (*(Z + ij)) {

				// loop over structuring element support
			
				ij = i + (j * m);

				L = *(X + ij);
				c = *(X + ij);
				
				for (kk = 0; kk < s; kk++) {
			        
					jj = ij + *(J + kk);
					
					xx = *(X + jj);
					
					if (xx < L) {
						L = xx;
					} 
							      
				} 
					
				// compute inner gradient
				
				ij = (i - p) + ((j - q) * (m - 2*p));
							
				*(Y + ij) = c - L;
				
			} else {
						
				// leave unchanged
				
				ij = (i - p) + ((j - q) * (m - 2*p));
					
				*(Y + ij) = *(X + i + (j * m));
				
			}
		
		} 
		}
	
	}
	
}

// morph_outer_double - morphological outer gradient
// -------------------------------------------------
// 
// Input:
// ------
//  *X - pointer to image array  (double *, (m * n))
//  m, n - number of image rows and columns (int)
//  *B - pointer to structuring element array (unsigned char *, (2*p + 1)*(2*q + 1))
//  p, q - structuring element support parameters (int)
//  *Z - pointer to mask image array (unsigned char *, (m * n))
//
// Output:
// -------
//  *Y - pointer to gradient image (double *, (m - 2*p)*(n - 2*q))
//

void morph_outer_double (
	double *Y,
	double *X, int m, int n,
	unsigned char *B, int p, int q,
	unsigned char *Z);
	
void morph_outer_double (
	double *Y,
	double *X, int m, int n,
	unsigned char *B, int p, int q,
	unsigned char *Z)

{
		
	 int m_p, n_q;
	 
	 int i, j, jj, k, kk, l, ij;
	
	 int s, *Vx, *Vy, *J;
	
	 double xx, c, U, t;  
	
	//--
  	// size of SE
  	//--
				  		
	s = 0.0;

	for (k = 0; k < (2*p + 1)*(2*q + 1); k++) {
		if (*(B + k)) {
			s++;
		}
	}

	//--
	// SE displacement vectors
	//--
	
	Vx = (int *) mxCalloc(s, sizeof(int));
	Vy = (int *) mxCalloc(s, sizeof(int));
	
	k = 0;
	
	for (j = 0; j < (2*q + 1); j++) {
	for (i = 0; i < (2*p + 1); i++) {
	
		if (*(B + i + (2*p + 1)*j)) {
			*(Vy + k) = i - p;
			*(Vx + k) = j - q;
			k++;
		}
		
	}
	}
	
	//--
	// SE index jumps
	//--
	
	J = mxCalloc(s, sizeof(int));
	
	for (kk = 0; kk < s; kk++) {
		*(J + kk) += *(Vy + kk) + (*(Vx + kk) * m);
	}
	
	//--
	// FULL COMPUTATION
	//--
	
	if (Z == NULL) {
	
		// loop over image
		
		n_q = n - q;
		m_p = m - p;
		
	  	for (j = q; j < n_q; j++) {
	  	for (i = p; i < m_p; i++) {

			// loop over structuring element support
			
			ij = i + (j * m);

			U = *(X + ij);
			c = *(X + ij);
			
			for (kk = 0; kk < s; kk++) {
		        
				jj = ij + *(J + kk);
				
				xx = *(X + jj);
				
				if (xx > U) {
					U = xx;
				} 

			}
			
			// computer outer gradient
					
			ij = (i - p) + ((j - q) * (m - 2*p));
								
			*(Y + ij) = U - c;
		
		} 
		}
	
	//--
	// MASKED COMPUTATION
	//--
	
	} else {
		
		// loop over image
	
		n_q = n - q;
		m_p = m - p;
		
	  	for (j = q; j < n_q; j++) {
	  	for (i = p; i < m_p; i++) {
	  		  		
	  		ij = i + (j * m);
	  		
	  		if (*(Z + ij)) {
					
				// loop over structuring element support
			
				U = *(X + ij);
				c = *(X + ij);
				
				for (kk = 0; kk < s; kk++) {
			        
					jj = ij + *(J + kk);
					
					xx = *(X + jj);
					
					if (xx > U) {
						U = xx;
					} 

				}
				
				// computer outer gradient
						
				ij = (i - p) + ((j - q) * (m - 2*p));
									
				*(Y + ij) = U - c;
				
			} else {
						
				// leave unchanged
				
				ij = (i - p) + ((j - q) * (m - 2*p));
					
				*(Y + ij) = *(X + i + (j * m));
				
			}
		
		} 
		}
	
	}
	
}

// morph_outer_uint8 - morphological outer gradient
// ------------------------------------------------
// 
// Input:
// ------
//  *X - pointer to image array  (unsigned char *, (m * n))
//  m, n - number of image rows and columns (int)
//  *B - pointer to structuring element array (unsigned char *, (2*p + 1)*(2*q + 1))
//  p, q - structuring element support parameters (int)
//  *Z - pointer to mask image array (uint8 *, (m * n))
//
// Output:
// -------
//  *Y - pointer to gradient image (uint8 *, (m - 2*p)*(n - 2*q))
//


void morph_outer_uint8 (
	unsigned char *Y,
	unsigned char *X, int m, int n,
	unsigned char *B, int p, int q,
	unsigned char *Z);
	
void morph_outer_uint8 (
	unsigned char *Y,
	unsigned char *X, int m, int n,
	unsigned char *B, int p, int q,
	unsigned char *Z)

{
	
	 int m_p, n_q; 
		
	 int i, j, jj, k, kk, l, ij;
	
	 int s, *Vx, *Vy, *J;
	
	 unsigned char xx, c, U, t;  
	
	//--
  	// size of SE
  	//--
				  		
	s = 0.0;

	for (k = 0; k < (2*p + 1)*(2*q + 1); k++) {
		if (*(B + k)) {
			s++;
		}
	}

	//--
	// SE displacement vectors
	//--
	
	Vx = (int *) mxCalloc(s, sizeof(int));
	Vy = (int *) mxCalloc(s, sizeof(int));
	
	k = 0;
	
	for (j = 0; j < (2*q + 1); j++) {
	for (i = 0; i < (2*p + 1); i++) {
	
		if (*(B + i + (2*p + 1)*j)) {
			*(Vy + k) = i - p;
			*(Vx + k) = j - q;
			k++;
		}
		
	}
	}
	
	//--
	// SE index jumps
	//--
	
	J = mxCalloc(s, sizeof(int));
	
	for (kk = 0; kk < s; kk++) {
		*(J + kk) += *(Vy + kk) + (*(Vx + kk) * m);
	}

	//--
	// FULL COMPUTATION
	//--
	
	if (Z == NULL) {
	
		// loop over image
		
	  	n_q = n - q;
		m_p = m - p;
		
	  	for (j = q; j < n_q; j++) {
	  	for (i = p; i < m_p; i++) {
	  					
			// loop over structuring element support
			
			ij = i + (j * m);
			
			U = *(X + ij);
			c = *(X + ij);
			
			for (kk = 0; kk < s; kk++) {
		        
				jj = ij + *(J + kk);
				
				xx = *(X + jj);
				
				if (xx > U) {
					U = xx;
				} 
						      
			}
			
			// computer outer gradient
					
			ij = (i - p) + ((j - q) * (m - 2*p));
								
			*(Y + ij) = U - c;
		
		} 
		}
	
	//--
	// MASKED COMPUTATION
	//--
	
	} else {
			
		// loop over image
	
	  	n_q = n - q;
		m_p = m - p;
		
	  	for (j = q; j < n_q; j++) {
	  	for (i = p; i < m_p; i++) {
	  		  	
	  		ij = i + (j * m);
	  			
	  		if (*(Z + ij)) {

				// loop over structuring element support
			
				U = *(X + ij);
				c = *(X + ij);
				
				for (kk = 0; kk < s; kk++) {
			        
					jj = ij + *(J + kk);
					
					xx = *(X + jj);
					
					if (xx > U) {
						U = xx;
					} 
							      
				} 
					
				// computer outer gradient
				
				ij = (i - p) + ((j - q) * (m - 2*p));
							
				*(Y + ij) = U - c;
				
			} else {
						
				// leave unchanged
				
				ij = (i - p) + ((j - q) * (m - 2*p));
					
				*(Y + ij) = *(X + i + (j * m));
				
			}
		
		} 
		}
	
	}
	
}

//----------------------------------------------
// MEX FUNCTION
//----------------------------------------------

//
// morph_gradient_uint8 - morphological gradient
// ------------------------------------------
//
// Y = morph_gradient_uint8(X,SE,Z)
//
// Input:
// ------
//  X - input image (uint8)
//  SE - structuring element (uint8)
//  Z - computation mask image (def: []) (uint8)
//
// Output:
// -------
//  Y - gradient image (uint8)
//

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])

{
	
	 double *X, *Y;
	
	 unsigned char *X8, *Y8;
	
	 int d[2];
	
	 unsigned char *B;
	
	 int m, n, p, q, t;
			
	 unsigned char *Z;
	
	//--
  	// compute depending on type of image
  	//--

  	//--
  	// UINT8 image
  	//--
  		  	
  	if (mxGetClassID(prhs[0]) == mxUINT8_CLASS) {
  	
  		//--
  		// INPUT
  		//--
  		
  		// input image
					  
	  	X8 = (unsigned char *) mxGetPr(prhs[0]);
	  	
	  	m = mxGetM(prhs[0]);
	  	n = mxGetN(prhs[0]);
	
		// structuring element matrix
		
		if (mxIsUint8(prhs[1])) {
	  		B = (unsigned char *) mxGetPr(prhs[1]);	  
	  	} else {
	  		mexErrMsgTxt("Structuring element must be of class uint8.");
	  	}
				
		p = (mxGetM(prhs[1]) - 1)/2;
		q = (mxGetN(prhs[1]) - 1)/2;
		
		// get parameters

		// type of gradient

		t = mxGetScalar(prhs[2]);
			
		// get mask
						
		if (nrhs > 3) {
		
			if (mxIsEmpty(prhs[3])) {
			
		  		Z = NULL;
		  		
		  	} else {
		  	
			  	if (mxIsUint8(prhs[3])) {
			  		Z = (unsigned char *) mxGetPr(prhs[3]);
			  	} else {
			  		mexErrMsgTxt("Mask must be of class uint8.");
			  	}
			  	
			  	if ((m != mxGetM(prhs[3])) || (n != mxGetN(prhs[3]))) {
					mexErrMsgTxt("Image and mask must be of the same size.");
				}
				
			}
			
		  	
		} else {
		
			Z = NULL;
		
		}
		
		//--
	  	// OUTPUT 
	  	//--
  		
  		// gradient image
  		
  		*d = (m - 2*p);
  		*(d + 1) = (n - 2*q);
  		
  		Y8 = (unsigned char *) mxGetPr(plhs[0] = mxCreateNumericArray(2, d, mxUINT8_CLASS, mxREAL));
  	
	  	//--
	  	// COMPUTATION
	  	//--
  	
		switch (t) {

		case (-1):
			morph_gradient_uint8 (Y8, X8, m, n, B, p, q, Z);
			break;

		case (0):
  			morph_gradient_uint8 (Y8, X8, m, n, B, p, q, Z);
			break;

		case (1):
			morph_outer_uint8 (Y8, X8, m, n, B, p, q, Z);
			break;

		}
  	
  	//--
  	// DOUBLE image
  	//--
  	
  	} else {
  	
  		//--
  		// INPUT
  		//--
  		
  		// input image
					  
	  	X = mxGetPr(prhs[0]);
	  	
	  	m = mxGetM(prhs[0]);
	  	n = mxGetN(prhs[0]);
	
		// structuring element matrix
		
		if (mxIsUint8(prhs[1])) {
	  		B = (unsigned char *) mxGetPr(prhs[1]);	  
	  	} else {
	  		mexErrMsgTxt("Structuring element must be of class uint8.");
	  	}
				
		p = (mxGetM(prhs[1]) - 1)/2;
		q = (mxGetN(prhs[1]) - 1)/2;
		
		// get parameters

		// type of gradient

		t = mxGetScalar(prhs[2]);
			
		// get mask
						
		if (nrhs > 3) {
		
			if (mxIsEmpty(prhs[3])) {
			
		  		Z = NULL;
		  		
		  	} else {
		  	
			  	if (mxIsUint8(prhs[3])) {
			  		Z = (unsigned char *) mxGetPr(prhs[3]);
			  	} else {
			  		mexErrMsgTxt("Mask must be of class uint8.");
			  	}
			  	
			  	if ((m != mxGetM(prhs[3])) || (n != mxGetN(prhs[3]))) {
					mexErrMsgTxt("Image and mask must be of the same size.");
				}
				
			}
			
		  	
		} else {
		
			Z = NULL;
		
		}
		
		//--
	  	// OUTPUT 
	  	//--
  		
  		// eroded image

  		Y = mxGetPr(plhs[0] = mxCreateDoubleMatrix((m - 2*p), (n - 2*q), mxREAL));
  	
	  	//--
	  	// COMPUTATION
	  	//--
  	
		switch (t) {

		case (-1):
			morph_inner_double (Y, X, m, n, B, p, q, Z);
			break;

		case (0):
  			morph_gradient_double (Y, X, m, n, B, p, q, Z);
			break;

		case (1):
			morph_outer_double (Y, X, m, n, B, p, q, Z);
			break;

		}

  	}

}

