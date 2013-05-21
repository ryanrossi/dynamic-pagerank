CXXFLAGS = -Wall -O3 -fopenmp 

FILES = utils.cpp ../*.cpp ../*.h

all : use_pagerank_solver.mex* create_pagerank_solver.mex* delete_pagerank_solver.mex*

MEX ?= mex
MEXFLAGS ?=

MEXFLAGS += 
MEXFLAGS += -I../ 

LBITS := $(shell getconf LONG_BIT)
ifeq ($(LBITS),64)
    MEXFLAGS += -largeArrayDims
    CXXFLAGS += -DPRPACK_MEX_64
else
    CFLAGS += -DPRPACK_MEX_32
endif

MEXEXTRA ?=

MEXEXTRA += utils.cpp ../*.cpp
MEXEXTRA += CXXFLAGS="\$$CXXFLAGS $(CXXFLAGS)" LDFLAGS="\$$LDFLAGS $(CXXFLAGS)"

%.mex*: %.cpp
	$(MEX) $(MEXFLAGS) $< $(MEXEXTRA)

use_pagerank_solver.mex* : use_pagerank_solver.cpp $(FILES)
create_pagerank_solver.mex*: create_pagerank_solver.cpp $(FILES)
delete_pagerank_solver.mex*: delete_pagerank_solver.cpp $(FILES)

#use_pagerank_solver.mex* : use_pagerank_solver.cpp $(FILES)
#	$(MEX) -largeArrayDims use_pagerank_solver.cpp utils.cpp 

#create_pagerank_solver.mex* : create_pagerank_solver.cpp $(FILES)
#	$(MEX) -largeArrayDims -I../ create_pagerank_solver.cpp utils.cpp ../*.cpp CXXFLAGS="\$$CXXFLAGS $(CXXFLAGS)" LDFLAGS="\$$LDFLAGS $(CXXFLAGS)"

#delete_pagerank_solver.mex* : delete_pagerank_solver.cpp $(FILES)
#	$(MEX) -largeArrayDims -I../ delete_pagerank_solver.cpp utils.cpp ../*.cpp CXXFLAGS="\$$CXXFLAGS $(CXXFLAGS)" LDFLAGS="\$$LDFLAGS $(CXXFLAGS)"
    
clean:
	$(RM) *.mex*
    
test: 
	matlab -nodesktop -nosplash -r test_main

debug: 
	matlab -Dgdb
.PHONY : all clean test
