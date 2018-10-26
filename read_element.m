function [atom, num, sys_name] = read_element(filename)
fid = fopen(filename, 'rt');
k = 1;
while feof(fid) == 0
    tline = fgetl(fid);
    if k == 1
        sys_name = tline;
    end

    if k >= 6
        atom = strsplit(strtrim(tline));
        num = str2num(fgetl(fid));
        break
    end
  k = k + 1;
end
fclose(fid);
