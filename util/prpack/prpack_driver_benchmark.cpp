
/** 
 * @file prpack_driver_benchmark
 * Implement a simple synthetic benchmark to evaluate scalability of 
 * the prpack codes.
 * @author David F. Gleich and Dave Kurakowa
 */

/** History
 *  :2012-04-15: Initial coding
 */
 
#include <math.h>
#include <assert.h>
#include <omp.h>
 
#include <vector>
#include <iostream>

#include "prpack_base_graph.h"
#include "prpack_solver.h"

using namespace std;

// used random generator from
// http://berenger.eu/blog/2010/10/20/c-mersenne-twister-simple-class-random-generator/
 
// Copyright (C) 1997 - 2002, Makoto Matsumoto and Takuji Nishimura,
// All rights reserved.
// Some source from by Jasper Bedaux 2003/1/1 (see http://www.bedaux.net/mtrand/)
// and Isaku Wada, 2002/01/09
// Here we just create a pretty and easy to use class
// based on their work
// Mersenne Twister random number generator
 
/**
* @brief Random class for the brainable engine
*/
class BRand {
public:
    /** Singleton controller */
    static BRand Controller;
 
private:
    /**
    * @brief default constructor private to use singleton
    */
    BRand() {
        seed(5489UL);
    }
 
    /**
    * @brief Destructor
    */
    virtual ~BRand() {} // destructor
 
public:
    /**
    * @brief Set seed with 32 bit integer
    * @param seed
    */
    void seed(unsigned long);
 
    /**
    * @brief overload operator() to make this a generator (functor)
    */
    unsigned long operator()(){
        return rand_int32();
    }
 
    /**
    * @brief Get number in [0, 1]
    */
    double nextClosed() {
        return static_cast<double>(rand_int32()) * (1. / 4294967295.); // divided by 2^32 - 1
    }
 
    /**
    * @brief Get number in (0, 1)
    */
    double nextOpened() {
        return (static_cast<double>(rand_int32()) + .5) * (1. / 4294967296.);// divided by 2^32
    }
 
protected:
    /**
    * @brief To have the next generated number
    * @brief used by derived classes, otherwise not accessible; use the ()-operator
    */
    inline unsigned long rand_int32() { // generate 32 bit random int
        if (P == N) gen_state(); // new state vector needed
        // gen_state() is split off to be non-inline, because it is only called once
        // in every 624 calls and otherwise irand() would become too big to get inlined
        unsigned long x = State[P++];
        x ^= (x >> 11);
        x ^= (x << 7) & 0x9D2C5680UL;
        x ^= (x << 15) & 0xEFC60000UL;
        return x ^ (x >> 18);
    }
 
private:
    static const int N = 624;
    static const int M = 397;
 
    // the variables below are static (no duplicates can exist)
    static unsigned long State[N]; // state vector array
    static int P; // position in state array
 
    /**
    * @biref used by gen_state()
    * @brief private functions used to generate the pseudo random numbers
    */
    unsigned long twiddle(unsigned long u, unsigned long v) {
        return (((u & 0x80000000UL) | (v & 0x7FFFFFFFUL)) >> 1)
            ^ ((v & 1UL) ? 0x9908B0DFUL : 0x0UL);
    }
    /**
    * @brief generate new state
    */
    void gen_state();
};

// non-inline function definitions and static member definitions cannot
// reside in header file because of the risk of multiple declarations
 
/** Singleton */
BRand BRand::Controller;
/** Static variables */
unsigned long BRand::State[N] = {0x0UL};
int BRand::P = 0;
 
/** generate new state vector */
void BRand::gen_state() {
    for (int i = 0; i < (N - M); ++i){
        State[i] = State[i + M] ^ twiddle(State[i], State[i + 1]);
    }
    for (int i = N - M; i < (N - 1); ++i){
        State[i] = State[i + M - N] ^ twiddle(State[i], State[i + 1]);
    }
    State[N - 1] = State[M - 1] ^ twiddle(State[N - 1], State[0]);
    P = 0; // reset position
}
 
/** init by 32 bit seed */
void BRand::seed(unsigned long s) {
    State[0] = s & 0xFFFFFFFFUL; // for > 32 bit machines
    for (int i = 1; i < N; ++i) {
        State[i] = 1812433253UL * (State[i - 1] ^ (State[i - 1] >> 30)) + i;
        // see Knuth TAOCP Vol2. 3rd Ed. P.106 for multiplier
        // in the previous versions, MSBs of the seed affect only MSBs of the array state
        // 2002/01/09 modified by Makoto Matsumoto
        State[i] &= 0xFFFFFFFFUL; // for > 32 bit machines
    }
    P = N; // force gen_state() to be called for next random number
}
 

/** 
 * @param dist a cumulative probability distribution of size n
 *  where dist[n-1] = 1.0 and so dist[0] is the probability
 *  of sampling 0.
 */
size_t sf_rand_distribution(size_t n, double* dist)
{
    double rval = BRand::Controller.nextClosed();
    size_t i=0;
    // TODO add binary search here
    for (; i<n; i++) {
        if (dist[i]>rval) {
            break;
        }
    }
    
    return i;
}

unsigned long sf_rand_size(unsigned long n)
{
    return BRand::Controller() % n;
}
 

/** Compute a vector of degrees for a power-law */
template <typename VertexType>
void random_power_law_degrees(size_t n, double theta, size_t max_degree,
        VertexType* degrees)
{
    assert(theta>0);
    // first compute a distribution over degrees based on the powerlaw
    std::vector<double> dist(max_degree,0);
    double total = 0.;
    for (size_t i=0; i<max_degree; ++i) {
        dist[i] = (double)n*1./(pow(((double)i+1.),theta));
        total += dist[i];
    }
    // normalize to be a cumulative probability distribuiton
    double current_sum = 0.;
    for (size_t i=0; i<max_degree; ++i) {
        current_sum += dist[i]/total;
        dist[i] = current_sum;
    }
    
    // now sample n degrees
    for (size_t i=0; i<n; ++i) {
        degrees[i] = (VertexType)sf_rand_distribution(max_degree, &dist[0]) + 1;
    }
}



/** Generate a graph based on a really simple power-law graph model.
 *
 * TODO
 * We throw in a bit of local clustering ala Neville and collabs too...
 * http://arxiv.org/abs/1202.4805
 */
void generate_graph(int nverts, double pow, int maxdeg, 
    std::vector<std::pair<int,int> >& edges) {
    // get the power-law degree dist
    std::vector<int> degs(nverts);
    random_power_law_degrees(nverts, pow, maxdeg, &degs[0]);
    
    int nedges = 0;
    for (int i=0; i<nverts; ++i) { nedges += degs[i]; }
    
    // pick nedges with <src,dst> pairs sampled with prop proportional
    // to the degree, to do so, build a big long vector with each vertex id 
    // repeated in proportion to its degree
    std::vector<int> edgesampler(nedges);
    for (int i=0, ei=0; i<nverts; ++i) {
        for (int d=0; d<degs[i]; ++d, ++ei) {
            edgesampler[ei] = i;
        }
    }
    
    //std::vector<std::pair<int,int> > edges(nedges);
    edges.resize(nedges);
    for (int i=0; i<nedges; ++i) {
        int src = edgesampler[sf_rand_size(nedges)];
        int dst = edgesampler[sf_rand_size(nedges)];
        edges[i] = std::make_pair(src,dst);
        //cout << "picked edge (" << src << " " << dst << ")" << endl;
    }
}

/** Compute a performance benchmark on a synthetic graph. */
void benchmark(int nverts) {
    int nthreads = omp_get_max_threads();
    cout << "Can use up to " << nthreads << " threads" << endl;
    
    // test sizes
    // generate a 10000 node graph
    assert(nverts > 0);
    std::vector<std::pair<int,int> > edges;
    generate_graph(nverts, 1.8, 10000, edges);
    prpack::prpack_base_graph *g = new prpack::prpack_base_graph(
                                        nverts, edges.size(), &edges[0]);
    cout << "nverts = " << nverts << endl;
    cout << "nedges = " << edges.size() << endl;
    prpack::prpack_solver solver(g);
    
    int threadseq[] = {2, 3, 4, 5, 6, 8, 10, 12, 16, 20, 24, 30, 32,
    40, 48, 50, 56, 60, 64, 80, 96, 120, 144, 160};
    int ntests = sizeof(threadseq)/sizeof(int);
    
    {
        cout << "method = sccgs" << endl;    
        omp_set_num_threads(1);
        prpack::prpack_result* res1 = solver.solve(0.85, 1.e-10, NULL, NULL, "sccgs");
        cout << "  preprocess time = " << res1->preprocess_time << "s" << endl;
        cout << "  1-thread compute time = " << res1->compute_time << "s" << endl;
        for (int t=0; t<ntests; ++t) {
            int nt = threadseq[t];
            if (nt > nthreads) { break; }
            omp_set_num_threads(nt);
            prpack::prpack_result* res = solver.solve(0.85, 1.e-10, NULL, NULL, "sccgs");
            cout << "  " << nt << "-thread compute time = " << res->compute_time << "s" 
                 << "  ("<< res1->compute_time/res->compute_time << "x) " 
                 << "  " << res->num_es_touched/(double)edges.size() << " eff iters" 
                 << endl;
            delete res;
        }
        delete res1;
    }
    
    {
        cout << "method = sgs" << endl;
        omp_set_num_threads(1);
        prpack::prpack_result* res1 = solver.solve(0.85, 1.e-10, NULL, NULL, "sgs");
        cout << "  preprocess time = " << res1->preprocess_time << "s" << endl;
        cout << "  1-thread compute time = " << res1->compute_time << "s" << endl;
        for (int t=0; t<ntests; ++t) {
            int nt = threadseq[t];
            if (nt > nthreads) { break; }
            omp_set_num_threads(nt);
            prpack::prpack_result* res = solver.solve(0.85, 1.e-10, NULL, NULL, "sgs");
            cout << "  " << nt << "-thread compute time = " << res->compute_time << "s" 
                 << "  ("<< res1->compute_time/res->compute_time << "x) " 
                 << "  " << res->num_es_touched/(double)edges.size() << " eff iters" 
                 << endl;
            delete res;
        }
        delete res1;
    }
    
    {
        cout << "method = gs" << endl;
        prpack::prpack_result* res = solver.solve(0.85, 1.e-10, NULL, NULL, "gs");
        cout << "  preprocess time = " << res->preprocess_time << "s" << endl;
        cout << "  " << 1 << "-thread compute time = " << res->compute_time << "s" 
                 << "  " << res->num_es_touched/(double)edges.size() << " eff iters" 
                 << endl;
        delete res;

    }
    
    // TODO free memory
}
