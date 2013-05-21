classdef pagerank_solver < handle
    %PAGERANK_SOLVER PageRank solver
    %   A PageRank solver that upon creation takes in a graph, and between
    %   subsequent calls of solve will store preprocessed work.
    
    properties (Hidden)
        solver_ptr;
    end
    
    methods
        % constructor
        function obj = pagerank_solver(matrix)
            obj.solver_ptr = create_pagerank_solver(matrix);
        end
        % destructor
        function delete(obj)
            delete_pagerank_solver(obj.solver_ptr);
        end
        % method
        function [x, ret] = solve(obj, alpha, varargin)
            % set the default alpha
            if nargin < 3
                alpha = 0.85;
            end
            opts.v = [];
            opts.u = [];
            opts.tol = [];
            opts.alpha = []; 
            opts.method = 'sccgs';
            weighted = false;
            if numel(varargin) > 1
                if isnumeric(varargin{1})
                    % this must be the parameter v
                    v = double(varargin{1});
                    if numel(v) ~= n && numel(v) ~= 0
                        error('prpack:invalidArgument', ...
                            'v must have length 0 or the size of the graph');
                    end
                    varargin = varargin{2:end}; % clear this argument                    
                end
                % handle the parameters
                if isstruct(varargin{1})
                    newopts = varargin{1};
                    if numel(varargin) > 1
                        err = nargchk(1,1,2,'struct');
                        err.message = 'No other arguments allowed after argument struct';
                        error(err);
                    end
                    % copy over new options
                    for fn=fieldnames(opts)'
                        fn = fn{1}; 
                        if isfield(newopts,fn), opts.(fn) = newopts.(fn); end
                    end
                else
                    % we should use the inputParser
                    p = inputParser;
                    p.addParamValue('tol', [], ...
                        @(x)isempty(x) || (isnumeric(x) && isscalar(x) && x>0)); 
                    p.addParamValue('alpha', [], ...
                        @(x)isempty(x) || (isnumeric(x) && isscalar(x) && x>=0 && x<=1)); 
                    p.addParamValue('method', opts.method, ...
                        @(x) validatestring(x,{'sccgs','sgs','gs'}));
                    p.addParamValue('u', [], ...
                        @(u)isnumeric(u) && (isempty(u) || numel(u) == n));
                    p.addParamValue('v', [], ...
                        @(u)isnumeric(u) && (isempty(u) || numel(u) == n));
                    p.parse(varargin{:});
                    opts.tol = p.Results.tol;
                    opts.method = p.Results.method;
                    opts.u = p.Results.u;
                    opts.v = p.Results.v;
                    opts.alpha = p.Results.alpha;
                end
            end
            
            if isempty(opts.tol), opts.tol = 1e-10; end
            if ~isempty(opts.alpha), alpha = opts.alpha; end
            [x, ret] = use_pagerank_solver(obj.solver_ptr, alpha, opts.tol, ...
                opts.u, opts.v, opts.method);
        end
    end
    
end
