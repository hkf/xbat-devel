#include "sqlite3.h"

#include "mex.h"

#include "matrix.h"

/*
 * BIND PARAMETERS
 ----------------------------------------*/

void bind_parameters (sqlite3_stmt *statement, const mxArray *source, const int offset, const int count) {
	
	mxArray *cell;
	
	int k, numel; char *str;
	
	int result;
	
	// NOTE: this indicates we only take the first entry of a matrix
	
	const int scalar = 1;
	
	int ix = 0;
	
	mexPrintf("\n");
	
	//--
	// loop over parameters
	//--
	
	for (k = offset; k < offset + count; k++) {
		
		// NOTE: this is the parameter position index
		
		ix++;
		
		//--
		// get cell
		//--
		
		cell = mxGetCell(source, k); 
		
		numel = mxGetM(cell) * mxGetN(cell);
		
		mexPrintf("Cell %d: # = %d, ", k, numel);
		
		//--
		// bind cell contents to positional parameters
		//--
		
		switch (mxGetClassID(cell)) {
			
			case (mxCHAR_CLASS): {
				
				numel = numel + 1; 
				
				str = mxCalloc(numel, sizeof(char));
				
				mxGetString(cell, str, numel);
				
				result = sqlite3_bind_text(statement, ix, (const char *) str, numel, SQLITE_TRANSIENT);
				
				mexPrintf("string = %s\n", str);
				
				mxFree(str);
				
				break;
				
			}
			
			case (mxINT8_CLASS):
				
			case (mxUINT8_CLASS): 
				
			case (mxINT16_CLASS):
				
			case (mxUINT16_CLASS): 
				
			case (mxINT32_CLASS):
				
			case (mxUINT32_CLASS): {
				
				if ((numel == 1) || scalar) {
					
					result = sqlite3_bind_int(statement, ix, (int) mxGetScalar(cell));
					
					mexPrintf("integer = %d\n", (int) mxGetScalar(cell));
					
				} else {
					
					result = sqlite3_bind_blob(statement, ix, (void *) mxGetPr(cell), numel * mxGetElementSize(cell), SQLITE_STATIC);
				
				}
				
				
				
				break;
				
			}
			
			case (mxINT64_CLASS):
				
			case (mxUINT64_CLASS): {
				
				if ((numel == 1) || scalar) {
					
					result = sqlite3_bind_int64(statement, ix, (long long int) mxGetScalar(cell));
					
					mexPrintf("long = %d\n", (long long int) mxGetScalar(cell));
					
				} else {
					
					result = sqlite3_bind_blob(statement, ix, (void *) mxGetPr(cell), numel * mxGetElementSize(cell), SQLITE_STATIC);
				
				}
	
				break;
				
			}
	
			case (mxSINGLE_CLASS): 
				
			case (mxDOUBLE_CLASS): {
				
				if ((numel == 1) || scalar) {
					
					result = sqlite3_bind_double(statement, ix, mxGetScalar(cell));
					
					mexPrintf("real = %f\n", mxGetScalar(cell));
					
				} else {
					
					result = sqlite3_bind_blob(statement, ix, (void *) mxGetPr(cell), numel * mxGetElementSize(cell), SQLITE_STATIC);
				
				}
				
				break;
				
			}
				
			default:
					
				mexPrintf("null\n");
				
				/* we don't know how to bind complex types */
				
				result = sqlite3_bind_null(statement, ix);
					
		}
		
	}
	
}

//----------------------------------------
// MEX FUNCTION
//----------------------------------------

void mexFunction (int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
  
	//----------------------------------------
	// VARIABLES
	//----------------------------------------
	
	char *file, *sql; int len;
	
	int mode;
	
	sqlite3 *db; 
	
	sqlite3_stmt *statement = 0;	
	
	int status, k, count = 0, sets = 0;
	
	char *errmsg, **result; int rows, cols;
	
	//----------------------------------------
	// HANDLE INPUT
	//----------------------------------------
	
	//--
	// DATABASE
	//--
	
	len = mxGetM(prhs[0]) * mxGetN(prhs[0]) + 1;

	file = mxCalloc(len, sizeof(char));

	mxGetString(prhs[0], file, len);  
	
	//--
	// ACCESS MODE
	//--
	
	mode = (int) mxGetScalar(prhs[1]);
	
	//--
	// SQL
	//--
	
	len = mxGetM(prhs[2]) * mxGetN(prhs[2]) + 1;

	sql = mxCalloc(len, sizeof(char));

	mxGetString(prhs[2], sql, len);
	
	//----------------------------------------
	// ACCESS DATABASE
	//----------------------------------------
	
	//---------------------------
	// OPEN
	//---------------------------
	
	status = sqlite3_open(file, &db);
	
	if (status) {
		mexPrintf("Can't open database: %s\n", sqlite3_errmsg(db)); goto done;
	}
	
	//---------------------------
	// ACCESS
	//---------------------------
	
	switch (mode) {
	
		//---------------------------
		// EXECUTE
		//---------------------------
		
		case (1): {
			
			status = sqlite3_exec(db, sql, NULL, NULL, &errmsg);
			
			if (status != SQLITE_OK) {
				mexPrintf("Problem executing: %s\n", errmsg);
			}
			
		}
		
		//---------------------------
		// GET TABLE
		//---------------------------
		
		case (2): {
			
			status = sqlite3_get_table(db, sql, &result, &rows, &cols, &errmsg);
			
			if (status != SQLITE_OK) {
				mexPrintf("Problem getting table: %s\n", errmsg);
			}
			
			// TODO: process results
			
			sqlite3_free_table(result);
			
		}
		
		//---------------------------
		// PREPARED
		//---------------------------
		
		case (3): {
			
			//---------------------------
			// PREPARE
			//---------------------------
			
			status = sqlite3_prepare(db, sql, len, &statement, 0);

			if (status || statement == NULL) {
				mexPrintf("Problem preparing: %s\n", sqlite3_errmsg(db)); goto done;
			}
				
			// NOTE: get output colums to recognize select

			cols = sqlite3_column_count(statement);

			//---------------------------
			// NOT SELECT
			//---------------------------

			if (cols == 0) {

				//---------------------------
				// LITERAL SQL
				//---------------------------
				
				if (nrhs < 4) {
					
					//--
					// step over results
					//--

					status = sqlite3_step(statement);
					
					while (status == SQLITE_ROW) {
						status = sqlite3_step(statement);
					}
					
				//---------------------------
				// PARAMETRIZED SQL
				//---------------------------
					
				} else {
					
					//--
					// get parameter count and number of parameter sets
					//--
					
					count = mxGetM(prhs[3]); sets = mxGetN(prhs[3]);
				
					//--
					// iterate over parameter sets
					//--
					
					for (k = 0; k < sets; k++) {
						
						//--
						// reset and bind statement
						//--
						
						sqlite3_reset(statement);
						
						bind_parameters(statement, (mxArray *) prhs[3], k * count, count);
						
						//--
						// step over results
						//--
						
						status = sqlite3_step(statement);
						
						while (status == SQLITE_ROW) {
							status = sqlite3_step(statement);
						}
						
						//--
						// handle error
						//--
						
						if (status != SQLITE_DONE) {
							mexPrintf("Problem stepping: %s\n", sqlite3_errmsg(db)); sqlite3_finalize(statement);
							goto done;
						}
						
					}
					
				}
					
			//---------------------------
			// SELECT
			//---------------------------

			} else {
					
				//--
				// step for status and number of rows
				//--

				status = sqlite3_step(statement);

				rows = sqlite3_data_count(statement);

				//--
				// allocate output
				//--

				if (nlhs > 1) {
					
					plhs[1] = mxCreateCellMatrix(cols, rows);
					
					if (!plhs[1]) {
						mexPrintf("Problem allocating output.\n"); goto done;
					}

				}
				
				//--
				// step over results and output rows
				//--

				while (status == SQLITE_ROW) {	

					//--
					// get row
					//--

					for (k = 0; k < cols; k++) {

					}

					//--
					// step to get next row
					//--

					status = sqlite3_step(statement);

				}

			}

			//--
			// finalize statement
			//--

			sqlite3_finalize(statement);

			//--
			// handle error
			//--

			if (status != SQLITE_DONE) {
				mexPrintf("Problem stepping: %s\n", sqlite3_errmsg(db)); goto done;
			}
			
		}
		
	}
	
	//---------------------------
	// CLOSE
	//---------------------------
	
	done:

	sqlite3_close(db);
	
	if (nlhs) {
		plhs[0] = mxCreateDoubleScalar((double) status);
	}
	
	mxFree(file); 
	
	mxFree(sql);
	
}
