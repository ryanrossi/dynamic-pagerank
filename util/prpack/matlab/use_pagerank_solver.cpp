#include <mex.h>
#include "../prpack.h"
#include "utils.h"
#include <string>
using namespace prpack;
using namespace std;

void mexFunction(int nlhs, mxArray* plhs[], int nrhs, const mxArray* prhs[]) {
    // validate number of inputs and outputs
    if (nrhs < 6)
        mexErrMsgTxt("Not enough input arguments.");
    if (nrhs > 6)
        mexErrMsgTxt("Too many input arguments.");
    if (nlhs > 2)
        mexErrMsgTxt("Too many output arguments.");
    // set up raw variables
    const mxArray* raw_solver_ptr = prhs[0];
    const mxArray* raw_alpha = prhs[1];
    const mxArray* raw_tol = prhs[2];
    const mxArray* raw_u = prhs[3];
    const mxArray* raw_v = prhs[4];
    const mxArray* raw_method = prhs[5];
    // parse variables
    prpack_solver* solver = parse_solver(raw_solver_ptr);
    int num_vs = solver->get_num_vs();
    double alpha = parse_alpha(raw_alpha);
    double tol = parse_tol(raw_tol);
    double* u = parse_uv(num_vs, raw_u);
    double* v = parse_uv(num_vs, raw_v);
    char* method = parse_method(raw_method);
    // compute pagerank
    prpack_result* res = solver->solve(alpha, tol, u, v, method);
    // return the pagerank vector and stats if necessary
    mxArray* ares = result_to_matlab_array(res);
    plhs[0] = mxGetField(ares, 0, "x");
    if (nlhs >= 2)
        plhs[1] = ares;
    delete res;
}

