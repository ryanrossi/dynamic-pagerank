function strs=strsplit(str,delimiters)
% STRSPLIT Divide a string into parts
%   STRSPLIT(STR) returns a cell array for all pieces of STR
%   separated by whitespace (' \n\t')
%
%   STRSPLIT(STR,DELIMITER) returns a cell array 
%   where DELIMITER separates each piece.
%

% David F. Gleich, Copyright 2009
% University of British Columbia

% History
% :2009-12-09: Initial coding.  This function is inspired by
%   python's split function

if nargin<2, delimiters=[]; end
%if isempty(delimiters), delimiters=' \n\t'; end

strs={};
if isempty(delimiters)
    while ~isempty(str), 
        [t,str]=strtok(str); strs{end+1} = t;
    end
else
    while ~isempty(str), 
        [t,str]=strtok(str,delimiters); strs{end+1} = t;
    end
end



