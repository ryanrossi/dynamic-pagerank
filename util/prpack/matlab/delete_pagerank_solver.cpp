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
    if (nlhs > 0)
        mexErrMsgTxt("Too many output arguments.");
    // set up raw variables
    const mxArray* raw_solver_ptr = prhs[0];
    // parse variables
    prpack_solver* solver = parse_solver(raw_solver_ptr);
    // delete pagerank solver
    delete solver;
}

