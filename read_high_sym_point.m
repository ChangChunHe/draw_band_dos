function [hsp, hsp_label, node] = read_high_sym_point(kpoint_filename)
fid = fopen(kpoint_filename, 'rt');
hsp =[];
hsp_label = {};
k = 1;
kk = 1;
while feof(fid) == 0
    tline = fgetl(fid);
    if kk == 2
        mat_ = regexp(tline, '^\d+','match');
        node = str2num(mat_{1});
    end
    if kk >= 5
        mat= strsplit(tline, '!');
        try
            hsp_label{k} = mat{2};
            hsp = [hsp;str2num(mat{1})];
            k = k + 1;
        end
    end
    kk = kk + 1;
end
fclose(fid);
