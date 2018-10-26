function [rec_k, sys_name] = read_recip(filename)
fid = fopen(filename, 'rt');
k = 1;
C =[];%vector
while feof(fid) == 0
    tline = fgetl(fid);
    if k == 1
        sys_name = strtrim(tline);
    end
    if k>2&&k<6
        C =[C
            str2num(tline)];
    end
    if k > 6
        break
    end
    k = k + 1;
end
fclose(fid);
V = abs(det(C));
rec_k = zeros(3);
rec_k(1,:) = cross(C(2,:), C(3,:))/V;
rec_k(2,:) = cross(C(3,:), C(1,:))/V;
rec_k(3,:) = cross(C(1,:), C(2,:))/V;
rec_k = 2*pi* rec_k ;