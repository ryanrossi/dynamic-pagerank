#include <mex.h>

#include "../prpack.h"
#include "utils.h"
using namespace prpack;

void mexFunction(int nlhs, mxArray* plhs[], int nrhs, const mxArray* prhs[]) {
    // validate number of inputs and outputs
    if (nrhs < 1)
        mexErrMsgTxt("Not enough input arguments.");
    if (nrhs > 1)
        mexErrMsgTxt("Too many input arguments.");
    if (nlhs > 1)
        mexErrMsgTxt("Too many output arguments.");
    // set up raw variables
    const mxArray* raw_csc = prhs[0];
    // parse variables
    if (mxGetN(raw_csc) != mxGetM(raw_csc))
        mexErrMsgTxt("matrix must be square.");
#ifdef PRPACK_MEX_32 
    prpack_csc g;    
    g.num_vs = mxGetN(raw_csc);
    g.heads = mxGetJc(raw_csc);
    g.tails = mxGetIr(raw_csc);
#elif PRPACK_MEX_64
    // create pagerank solver
    prpack_int64_csc g;
    g.num_vs = mxGetN(raw_csc);
    g.heads = (int64_t*)mxGetJc(raw_csc);
    g.tails = (int64_t*)mxGetIr(raw_csc);
#endif    
    g.num_es = g.heads[g.num_vs];
    prpack_solver* solver = new prpack_solver(&g);
    // return a pointer to the pagerank solver
    plhs[0] = solver_to_matlab_array(solver);
}

