#include <algorithm>
#include "utils.h"

using namespace prpack;
using namespace std;

bool is_double_scalar(const mxArray* a) {
    return mxIsDouble(a)
            && !mxIsComplex(a)
            && mxGetNumberOfElements(a) == 1;
}

bool is_vector(const mxArray* a) {
    const mwSize* dims = mxGetDimensions(a);
    return mxGetNumberOfDimensions(a) == 2
            && min(dims[0], dims[1]) <= 1;
}

bool is_double_vector(const mxArray* a) {
    return mxIsDouble(a)
            && !mxIsComplex(a)
            && is_vector(a);
}

bool is_string(const mxArray* a) {
    return mxIsChar(a) && is_vector(a);
}

prpack_solver* parse_solver(const mxArray* raw_solver_ptr) {
    unsigned long long solver_ptr_val = *(unsigned long long*) mxGetData(raw_solver_ptr);
    return reinterpret_cast<prpack_solver*>(solver_ptr_val);
}

double parse_alpha(const mxArray* raw_alpha) {
    if (!is_double_scalar(raw_alpha))
        mexErrMsgTxt("alpha must be a real scalar.");
    double alpha = *((double*) mxGetData(raw_alpha));
    if (alpha <= 0 || 1 <= alpha)
        mexErrMsgTxt("alpha must be in (0, 1).");
    return alpha;
}

double parse_tol(const mxArray* raw_tol) {
    if (!is_double_scalar(raw_tol))
        mexErrMsgTxt("tol must be a real scalar.");
    double tol = *((double*) mxGetData(raw_tol));
    if (tol <= 0)
        mexErrMsgTxt("tol must be > 0.");
    return tol;
}

double* parse_uv(int num_vs, const mxArray* raw_uv) {
    if (!is_double_vector(raw_uv))
        mexErrMsgTxt("u and v must be real vectors.");
    mwSize uv_size = mxGetNumberOfElements(raw_uv);
    if (uv_size != 0 && uv_size != (mwSize)num_vs)
        mexErrMsgTxt("u and v must be the same size as the matrix, or empty.");
    return (uv_size == 0) ? NULL : (double*) mxGetPr(raw_uv);
}

char* parse_method(const mxArray* raw_method) {
    if (!is_string(raw_method))
        mexErrMsgTxt("method must be a string");
    mwSize method_length = mxGetNumberOfElements(raw_method);
    char* method = new char[method_length + 1];
    mxGetString(raw_method, method, method_length + 1);
    return method;
}

mxArray* int_to_matlab_array(int x) {
    mxArray* ret = mxCreateNumericMatrix(1, 1, mxINT32_CLASS, mxREAL);
    *(int*) mxGetData(ret) = x;
    return ret;
}

mxArray* double_to_matlab_array(double x) {
    return mxCreateDoubleScalar(x);
}

mxArray* double_array_to_matlab_array(int length, double* a) {
    mxArray* ret = mxCreateDoubleMatrix(length, 1, mxREAL);
    double* ret_data = mxGetPr(ret);
    for (int i = 0; i < length; ++i)
        ret_data[i] = a[i];
    return ret;
}

mxArray* ll_to_matlab_array(long long x) {
    mxArray* ret = mxCreateNumericMatrix(1, 1, mxINT64_CLASS, mxREAL);
    *(long long*) mxGetData(ret) = x;
    return ret;
}

mxArray* string_to_matlab_array(const char* s) {
    return mxCreateString(s);
}

mxArray* solver_to_matlab_array(prpack_solver* solver) {
    mxArray* ret = mxCreateNumericMatrix(1, 1, mxUINT64_CLASS, mxREAL);
    *(unsigned long long*) mxGetData(ret) = reinterpret_cast<unsigned long long>(solver);
    return ret;
}

mxArray* result_to_matlab_array(prpack_result* res) {
    const int num_fields = 8;
    const char* field_names[num_fields] = {"num_vs", "num_es", "x", "read_time", "preprocess_time", "compute_time", "num_es_touched", "method"};
    mxArray* ret = mxCreateStructMatrix(1, 1, num_fields, field_names);
    mxSetField(ret, 0, "num_vs", double_to_matlab_array((double)res->num_vs));
    mxSetField(ret, 0, "num_es", double_to_matlab_array((double)res->num_es));
    mxSetField(ret, 0, "x", double_array_to_matlab_array(res->num_vs, res->x));
    mxSetField(ret, 0, "read_time", double_to_matlab_array(res->read_time));
    mxSetField(ret, 0, "preprocess_time", double_to_matlab_array(res->preprocess_time));
    mxSetField(ret, 0, "compute_time", double_to_matlab_array(res->compute_time));
    mxSetField(ret, 0, "num_es_touched", double_to_matlab_array((double)res->num_es_touched));
    mxSetField(ret, 0, "method", string_to_matlab_array(res->method));
    return ret;
}
