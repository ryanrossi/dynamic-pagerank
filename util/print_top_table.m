function str = print_top_table(pages, idx, c)

n = length(idx); str = ''; count = 1;
for i=1:floor(n / c),
    tmpstr = '';
    for j=1:c,
        if j == c,
            tmpstr = strcat(tmpstr, pages{idx(count)}, ' \\ ');
        else
            tmpstr = strcat(tmpstr, pages{idx(count)}, ' & ', ' ');
        end
        count = count + 1;
    end
    fprintf('%s\n',tmpstr)
    str = strcat(str,tmpstr);
    
end


str = ''; space = ' '; space = char(space);
count = 1; tstr = cell(floor(n/c),1);
for i=1:c,
    for j=1:floor(n / c),
        max_len = 25;
        if length(pages{idx(count)}) < max_len,
            max_len = length(pages{idx(count)});
        end
        if i == c,
            tstr{j} = strcat(tstr{j}, int2str(count), '. ' , pages{idx(count)}(1:max_len), ' \\ ',space);
        else
            j
            tstr{j} = strcat(tstr{j}, int2str(count), '. ', blanks(10) , pages{idx(count)}(1:max_len), ' & ', ' ',space);
        end
        count = count + 1;
        tstr{j} = strrep(tstr{j}, 'Portal:', 'P:');
        tstr{j} = strrep(tstr{j}, 'Category:', 'C:');
    end
end
for i=1:floor(n / c),
    fprintf('%s\n',tstr{i})
end
