import numpy as np
cimport numpy as np

# TODO: this assumes int's in c++ are int32


cdef extern from "../prpack_edge_list.h" namespace "prpack":
    cdef cppclass prpack_edge_list:
        # instance variables
        int num_vs
        int num_es
        int* heads
        int* tails

cdef extern from "../prpack_result.h" namespace "prpack":
    cdef cppclass prpack_result:
        # instance variables
        int num_vs
        int num_es
        double* x
        double read_time
        double preprocess_time
        double compute_time
        long long num_es_touched
        char* method
        int converged

cdef extern from "../prpack_solver.h" namespace "prpack":
    cdef cppclass prpack_solver:
        # constructors
        prpack_solver(prpack_edge_list* g)
        prpack_solver(char* filename, char* format)
        # methods
        prpack_result* solve(double alpha, double tol, char* method)
        prpack_result* solve(double alpha, double tol, double* u, double* v, char* method)

class result:
    def __init__(self,
                 num_vs,
                 num_es,
                 x,
                 read_time,
                 preprocess_time,
                 compute_time,
                 num_es_touched,
                 method,
                 converged):
        self.num_vs = num_vs
        self.num_es = num_es
        self.x = x
        self.read_time = read_time
        self.preprocess_time = preprocess_time
        self.compute_time = compute_time
        self.num_es_touched = num_es_touched
        self.method = method
        self.converged = converged

cdef class pagerank_solver:
    cdef int __num_vs
    cdef prpack_solver* __solver
    def __cinit__(self,
                 int num_vs,
                 np.ndarray[np.int32_t, ndim = 1] heads,
                 np.ndarray[np.int32_t, ndim = 1] tails):
        # validate inputs
        assert(num_vs > 0)
        assert(len(heads) == len(tails))
        assert(heads.flags['C_CONTIGUOUS'])
        assert(tails.flags['C_CONTIGUOUS'])
        # create graph
        cdef int num_es = len(heads)
        cdef prpack_edge_list* g = new prpack_edge_list()
        g.num_vs = num_vs
        g.num_es = num_es
        g.heads = <int*> heads.data
        g.tails = <int*> tails.data
        # initialize variables
        self.__num_vs = num_vs
        self.__solver = new prpack_solver(g)
    def __dealloc__(self):
        del self.__solver
    def solve(self, double alpha, double tol, **kwargs):
        # validate inputs
        assert(0 < alpha < 1)
        assert(tol > 0)
        # handle optional arguments
        cdef np.ndarray[np.double_t, ndim = 1] u
        u_data = <double*> NULL
        if ("u" in kwargs):
            u = kwargs["u"]
            assert(u.flags['C_CONTIGUOUS'])
            assert(len(u) == self.__num_vs)
            u_data = <double*> u.data
        cdef np.ndarray[np.double_t, ndim = 1] v
        v_data = <double*> NULL
        if ("v" in kwargs):
            v = kwargs["v"]
            assert(v.flags['C_CONTIGUOUS'])
            assert(len(v) == self.__num_vs)
            v_data = <double*> v.data
        cdef char* method = ""
        if ("method" in kwargs):
            method = kwargs["method"]
        # solve and return
        cdef prpack_result* res = self.__solver.solve(alpha, tol, u_data, v_data, method)
        x = np.empty(self.__num_vs, dtype = np.double)
        for i in xrange(self.__num_vs):
            x[i] = res.x[i]
        return result(res.num_vs,
                      res.num_es,
                      x,
                      res.read_time,
                      res.preprocess_time,
                      res.compute_time,
                      res.num_es_touched,
                      res.method,
                      res.converged)

def pagerank(int num_vs,
             np.ndarray[np.int32_t, ndim = 1] heads,
             np.ndarray[np.int32_t, ndim = 1] tails,
             double alpha,
             double tol,
             **kwargs):
    solver = pagerank_solver(num_vs, heads, tails)
    return solver.solve(alpha, tol, **kwargs)

