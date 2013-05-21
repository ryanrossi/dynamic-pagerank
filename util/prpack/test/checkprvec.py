#!/usr/bin/env python

"""
Verify that a pagerank vector is accurate via the power method

If we run the power-method for 2*log(alpha)/log(tol) iterations,
then the error in the solution of the PageRank vector is at most
tol.  This means that the inf-norm difference between any other
vector must be at most 2*tol and the 1-norm difference must
also be at most 2*tol.  
"""

import sys
import optparse
import math

def read_smat_triples(filename):
    """ Read a set of triples from an smat file. """
    file = open(filename,'rt')
    header = file.readline()
    parts = header.split()
    m = int(parts[0])
    n = int(parts[1])
    nz = int(parts[2])
    edges = []
    for line in file:
        parts = line.split()
        if len(parts)==0: continue
        i = int(parts[0])
        j = int(parts[1])
        v = float(parts[2])
        assert(i >= 0 and i < m)
        assert(j >= 0 and j < n)
        edges.append((i,j,v))
    return m, n, edges


class Graph:
    """ A simple graph type wrapping an smat file. """
    def __init__(self, filename):
        m, n, edges = read_smat_triples(filename)
        assert(m == n)
        for edge in edges:
            assert(edge[2] >= 0.)
        self.edges = edges
        self.nverts = m
        
    def outdegrees(self):
        outd = [ 0. for _ in xrange(self.nverts) ]
        for edge in self.edges:
            outd[edge[0]] += edge[2]
        return outd
        
    def _inv_outdegrees(self):
        """ Compute the inverse outdegree vector for PageRank. """
        outd = self.outdegrees()
        def inv_zero(d):
            if d==0.: return 0.
            else: return 1./d            
        invoutd = [ inv_zero(d) for d in outd ]
        return invoutd
    
    def prvec(self,alpha,tol,v,u):
        assert(alpha > 0)
        assert(alpha < 1)
        assert(len(v) == self.nverts)
        assert(len(u) == self.nverts)
        niter = int(math.ceil(2*math.log(tol)/math.log(alpha)))
        x = [ vi for vi in v ] # copy vi to x
        ioutd = self._inv_outdegrees()
        for iter in xrange(niter):
            y = [ 0. for _ in xrange(self.nverts) ]
            for edge in self.edges:
                y[edge[1]] += alpha*x[edge[0]]*edge[2]*ioutd[edge[0]]
            # compute the dangling node adjustment
            delta = 0.
            for i in xrange(self.nverts):
                if ioutd[i] == 0.:
                    delta += x[i]
            delta *= alpha
            
            for i in xrange(self.nverts):
                y[i] += delta*u[i] + (1-alpha)*v[i]
                
            sumy = math.fsum(y)
            
            x = [ yi/sumy for yi in y ]
        return x

def setup_command_line():
    usage = "python %prog [options] graphfile otherprvec"
    
    parser = optparse.OptionParser(usage=usage)
    parser.add_option('-a','--alpha',default=0.85,type='float')
    parser.add_option('-v','--v',default=None,metavar='FILE',
        help="Use a personalization vector v from a file, default=uniform 1/n.")
    parser.add_option('-u','--u',default=None,metavar='FILE',
        help="Use a dangling adjustment u from a file, default=uniform 1/n.")    
    parser.add_option('-t','--tol',default=1e-10,type='float')
    parser.add_option('--verbose',action="store_true")
    return parser
    
def load_vec(filename):
    v = []
    if filename == '-':
        for line in sys.stdin:
            v.append(float(line))
    else:
        with open(filename) as file:
            for line in file:
                v.append(float(line))
    return v
    
def compare_vecs(v1,v2,tol):
    """ Check that v1 and v2 satisfy the tolerance properties we need. """
    assert(len(v1) == len(v2))
    assert(tol > 0)
    
    failed = False
    nwritten = 0
    maxwrite = 10
    diff = [0 for _ in xrange(len(v1))]
    for i in xrange(len(v1)):
        diff[i] = abs(v1[i] - v2[i])
        if diff[i] > 2.*tol:
            failed = True
            nwritten += 1
            print >>sys.stderr, \
                "difference in element %i too large: |%18.16e - %18.16e| > 2*tol"%(
                i, v1[i], v2[i])
            if nwritten >= maxwrite: 
                break
    
    diff1 = math.fsum(diff)
    if diff1 > 2.*tol:
        failed = True
        print >>sys.stderr, "one-norm difference %e > 2*tol"%(diff1)
    
    return not failed
            
def main():
    parser = setup_command_line()
    (opts,args) = parser.parse_args()
    if len(args) != 2:
        parser.print_help()
        sys.exit(-1)
        
    if opts.verbose: vprint = lambda x: sys.stderr.writelines([x,'\n'])
    else: vprint = lambda x: None
    
    graphfilename = args[0]
    graph = Graph(graphfilename)
    vprint("Loaded graph %s, nverts=%i, nedges=%i"%(
        graphfilename,graph.nverts,len(graph.edges)))
    
    prvecfile = args[1]
    prvec = load_vec(prvecfile)
    vprint("Loaded vector %s, len=%i"%(prvecfile, len(prvec)))
    
    if opts.v is None:
        invn = 1./graph.nverts
        opts.v = [invn for _ in xrange(graph.nverts)]
    else:
        opts.v = load_vec(opts.v)

    if opts.u is None:
        opts.u = opts.v
    else:
        opts.u = load_vec(opts.u)
    
    trueprvec = graph.prvec(opts.alpha, opts.tol, opts.v, opts.u)
    vprint("Computed true PageRank, sum=%18.16e, max=%18.16e, argmax=%i"%(
        math.fsum(trueprvec), max(trueprvec), trueprvec.index(max(trueprvec))))
        
    result = compare_vecs(trueprvec, prvec, opts.tol)
    if result:
        print >> sys.stderr, "PageRank vectors are within acceptable differences"
        sys.exit(0) # this indicates success
    else:
        print >> sys.stderr, "FAILED: PageRank vectors differ by more than tolerance"
        sys.exit(1) # this indicates a failure
    
    

if __name__=='__main__':
    main()