function export2graphml (A, pages, fn)

fid = fopen (fn,'w');

fprintf (fid,'<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<graphml xmlns=\"http://graphml.graphdrawing.org/xmlns\"\nxmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\nxsi:schemaLocation=\"http://graphml.graphdrawing.org/xmlns\nhttp://graphml.graphdrawing.org/xmlns/1.0/graphml.xsd\">\n');
fprintf (fid,'<key id=\"name\" for=\"node\" attr.name=\"name\" attr.type=\"string\"/>');%\n<default>0</default>\n</key>');
fprintf (fid,'<graph id=\"G\" edgedefault=\"undirected\">\n');

n = size(A,1);
for i=1:n
    label = pages{i};
    label = strrep(label, 'Category:Wikipedia ', '');
    label = strrep(label, 'Category:', '');
    label = strrep(label, 'Portal:', '');
    %label = strrep(label, 'Wikipedia ', '');
    label = strrep(label, 'Categories', '');
    
    max_len = 10;
    if length(label) < 10,
        max_len = length(label);
    end
    
    fwrite(fid,['<node id="',unicode2native(native2unicode([label(1:max_len)],'UTF-8'),'UTF-8'),'"><data key="d0"></data></node>'],'uint8');
    fprintf(fid,'\n');
end

[src dest val] = find(A);
E = [src dest];

fprintf(fid,'\t<edge source=\"n%d\" target=\"n%d\"/>\n',E(:,1:2)');

fprintf (fid,'</graph>\n');
fprintf (fid,'</graphml>');

fclose (fid);