#include "prpack_utils.h"
#include "prpack_result.h"
#include "prpack_solver.h"
#include <algorithm>
#include <cstdio>
#include <cstdlib>
#include <fstream>
#include <iostream>
#include <map>
#include <string>
#include <utility>
#include <vector>
using namespace prpack;
using namespace std;

// in prpack_driver_benchmark.cpp
void benchmark(int numverts=200000);

// Contains all possible input parameters.
class input {
    public:
        // instance variables
        bool help;
        string graph;
        string format;
        bool weighted;
        double alpha;
        double tol;
        string u;
        string v;
        string method;
        string output;
        // constructor
        input(const int argc, const char** argv) {
            // default values
            help = false;
            graph = "";
            format = "";
            weighted = false;
            alpha = 0.85;
            tol = 1e-10;
            u = "";
            v = "";
            method = "";
            output = "";
            // convenience variables
            map<string, bool*> bool_flags;
            bool_flags["-w"] = bool_flags["--weighted"] = &weighted;
            bool_flags["-h"] = bool_flags["--help"] = &help;
            map<string, double*> double_flags;
            double_flags["-a"] = double_flags["--alpha"] = &alpha;
            double_flags["-t"] = double_flags["--tol"] = double_flags["--tolerance"] = &tol;
            map<string, string*> string_flags;
            string_flags["-f"] = string_flags["--format"] = &format;
            string_flags["-u"] = string_flags["--u"] = &u;
            string_flags["-v"] = string_flags["--v"] = &v;
            string_flags["-m"] = string_flags["--method"] = &method;
            string_flags["-o"] = string_flags["--out"] = string_flags["--output"] = &output;
            // parse args
            prpack_utils::validate(argc >= 2, "Error: graph must be supplied.");
            graph = string(argv[1]);
            if (graph == "-h" || graph == "--help") {
                help = true;
                return;
            }
            for (int i = 2; i < argc; ++i) {
                string s(argv[i]);
                if (bool_flags.find(s) != bool_flags.end())
                    *bool_flags[s] = true;
                else {
                    // parse value of parameter s
                    string t;
                    if (s.length() >= 3 && s[0] == '-' && s[1] == '-' && s.find('=') != string::npos) {
                        const int idx = s.find('=');
                        t = s.substr(idx + 1);
                        s = s.substr(0, idx);
                    } else if (s.length() == 2 && s[0] == '-' && i + 1 < argc)
                        t = string(argv[++i]);
                    else
                        prpack_utils::validate(false, "Error: argument '" + s + "' is not valid or does not specify a value.");
                    // set parameter s to t
                    if (double_flags.find(s) != double_flags.end())
                        *double_flags[s] = atof(t.c_str());
                    else if (string_flags.find(s) != string_flags.end())
                        *string_flags[s] = t;
                    else
                        prpack_utils::validate(false, "Error: argument '" + s + "' is not valid.");
                }
            }
        }
};

// Prints out the help menu
void print_help() {
    string msg = "";
    msg += "Usage: prpack_driver GRAPH [options]\n";
    msg += "Options:\n";
    msg += "  -a ALPHA, --alpha=ALPHA             Solve with ALPHA value (default = 0.85).\n";
    msg += "  -f FORMAT, --format=FORMAT          Read GRAPH as a FORMAT file (default = use extension of GRAPH).\n";
    msg += "  -h, --help                          Print out this help menu.\n";
    msg += "  -m METHOD, --method=METHOD          Solve via METHOD (default = chosen based on properties of GRAPH).\n";
    msg += "  -o OUT, --out=OUT, --output=OUT     File to output solution (default = standard out).\n";
    msg += "  -t TOL, --tol=TOL, --tolerance=TOL  Ensure 1-norm error < TOL (default = 1e-10).\n";
    msg += "  -u U, --u=U                         Solve with U value (default = uniform vector).\n";
    msg += "  -v V, --v=V                         Solve with V value (default = uniform vector).\n";
    msg += "  -w, --weighted                      Solve a weighted problem (default = false).\n";
    printf("%s", msg.c_str());
}

double* read_vector(const string& filename) {
    if (filename == "")
        return NULL;
    // read into double vector
    vector<double> v;
    FILE* f = fopen(filename.c_str(), "r");
    double curr;
    while (fscanf(f, "%lf", &curr) == 1)
        v.push_back(curr);
    fclose(f);
    // convert to double array
    double* ret = new double[v.size()];
    for (int i = 0; i < (int) v.size(); ++i)
        ret[i] = v[i];
    return ret;
}

void write_vector(double *x, int n, ostream& out) {
    out.precision(16);
    out << scientific;
    for (int i=0; i<n; ++i) {
        out << x[i] << std::endl;
    }
}

int main(const int argc, const char** argv) {
    // parse command args
    input in(argc, argv);
    if (in.help) {
        print_help();
        return 0;
    }

    if (in.graph == "?") {
        benchmark();
        return 0;
    } else if (argv[1][0] == '?') {
        benchmark(atoi(&argv[1][1]));
        return 0;
    }

    // solve
    prpack_solver solver(in.graph.c_str(), in.format.c_str(), in.weighted);
    const double* u = read_vector(in.u);
    const double* v = (in.u == in.v) ? u : read_vector(in.v);
    const prpack_result* res = solver.solve(in.alpha, in.tol, u, v, in.method.c_str());
    // create output stream for text data
    ostream* out = &cout; // usually, this is cout
    if (in.output == "-") {
        out = &cerr; 
    } 
    *out << "---------------------------" << endl;
    *out << "graph = " << in.graph << endl;
    *out << "number of vertices = " << res->num_vs << endl;
    *out << "number of edges = " << res->num_es << endl;
    *out << "---------------------------" << endl;
    *out << "method = " << res->method << endl;
    *out << "read time = " << res->read_time << "s" << endl;
    *out << "preprocess time = " << res->preprocess_time << "s" << endl;
    *out << "compute time = " << res->compute_time << "s" << endl;
    *out << "number of edges touched = " << res->num_es_touched << endl;
    *out << "converged = " << res->converged << endl;
    *out << "---------------------------" << endl;
    pair<double, int>* xval_idx = new pair<double, int>[res->num_vs];
    for (int i = 0; i < res->num_vs; ++i)
        xval_idx[i] = make_pair(res->x[i], i);
    sort(xval_idx, xval_idx + res->num_vs);
    for (int i = res->num_vs - 1; i >= 0 && i >= res->num_vs - 20; --i)
        *out << "site = " << xval_idx[i].second << ", score = " << xval_idx[i].first << endl;
    delete[] xval_idx;

    // write the entire vector
    if (in.output != "") {
        if (in.output == "-") {
            write_vector(res->x, res->num_vs, cout);
        } else {
            ofstream outfile(in.output.c_str());
            write_vector(res->x, res->num_vs, outfile);
        }
    }
}

