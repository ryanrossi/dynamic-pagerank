function [out_results in_results] = prt_causality(C,ids,pages)

out_idx = find(C(1,:) > 0);
in_idx = find(C(:,1) > 0);

%fprintf('%s influences (or Granger causes): \n', pages{ids(1)});
out_results = pages(ids(out_idx));

%fprintf('\n\nThe pages below influence or Granger cause %s \n', pages{ids(1)});
in_results = pages(ids(in_idx));

nout = length(out_idx);
nin = length(in_idx);
maxchar = 30;

fprintf('\n\n\n%s Granger causes: \n', pages{ids(1)});
fprintf('--------------------------------------------\n');
for i=1:nout,
    str = out_results{i};
    if length(out_results{i}) > maxchar,
        str = out_results{i}(1:maxchar);
    end
    fprintf('%30s,  %f \n', str, C(1,out_idx(i)));
end

fprintf('\n\nThe pages below Granger cause %s: \n', pages{ids(1)});
fprintf('--------------------------------------------\n');
for i=1:nin,
    str = in_results{i};
    if length(in_results{i}) > maxchar,
        str = in_results{i}(1:maxchar);
    end
    fprintf('%30s,  %f \n', str, C(in_idx(i),1));
end
