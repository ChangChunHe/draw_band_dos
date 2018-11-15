function [C, S, atom] = read_poscar(filename)
fid = fopen(filename, 'rt');
C = cell2mat(textscan(fid, '%f %f %f', 3, 'Headerlines',2));
fclose(fid);

fid = fopen(filename, 'rt');
k = 1;
while feof(fid) == 0
    tline = fgetl(fid);
    
    if k == 7
        temp_str=regexp(tline,'(\d\s*)*','match'); %cell
        break
    elseif k == 8
        temp_str=regexp(tline,'(\d\s*)*','match'); %cell
        break
    end
    k = k +1;
end
temp_str = str2num(temp_str{1});

fid = fopen(filename,'rt');
S = zeros(sum(temp_str),3);
iter = 1;
while feof(fid) == 0
    tline = fgetl(fid);
    if iter > k+2
        t = regexp(tline,'[+-]?\d+\.?\d*', 'match');
        S(iter-k-2,:) = [str2double(t{1}) str2double(t{2}) str2double(t{3})];
        
    end
    iter = iter + 1;
    if iter > k+sum(temp_str)+2
        break
    end
end

fclose(fid);


fid = fopen(filename);
kk = 1;
while feof(fid) == 0
    tline = fgetl(fid);
    if kk == k-1
        a= regexp(tline,'\w*','match'); %cell
    end
    kk = kk +1;
end
fclose(fid);
atom = [];
if length(a) ~= length(temp_str)
    error('Atom species are not consistent to atom numbers')
end
for ii = 1:length(a)
    atom = [atom repmat([a{ii}, ' '],1, temp_str(ii))];
end





