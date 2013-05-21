import numpy as np
from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext

ext_modules = [Extension(
    name="prpack",
    sources=["prpack.pyx",
             "../prpack_base_graph.cpp",
             "../prpack_preprocessed_ge_graph.cpp",
             "../prpack_preprocessed_gs_graph.cpp",
             "../prpack_preprocessed_scc_graph.cpp",
             "../prpack_preprocessed_schur_graph.cpp",
             "../prpack_result.cpp",
             "../prpack_solver.cpp",
             "../prpack_utils.cpp"],
    include_dirs = [np.get_include()],
    language="c++",
    extra_compile_args = "-Wall -O3 -fopenmp".split(),
    extra_link_args = "-Wall -O3 -fopenmp".split())]

setup(
    name = 'prpack',
    cmdclass = {'build_ext': build_ext},
    ext_modules = ext_modules)

