function [C, S, atom] = read_poscar(filename)
fid = fopen(filename, 'rt');
latt = textscan(fid, '%f%[^\n\r]', 1, 'Headerlines',1);
C = cell2mat(textscan(fid, '%f %f %f', 3, 'Headerlines',1))*latt{1};
atom_ele = textscan(fid,'%s',1,'delimiter','\n', 'headerlines',1);
atom_ele = strsplit(deblank(atom_ele{1}{1}));
atom_num = textscan(fid,'%s',1,'delimiter','\n');
atom_num = strsplit(atom_num{1}{1});
sum_atom = 0;for ii = 1:length(atom_num);sum_atom = sum_atom+str2num(atom_num{ii});end

next_line = textscan(fid,'%s',1,'delimiter','\n');
if isempty(strfind(lower(next_line{1}{1}), 'sele'))
    select_flag = false;
else
    select_flag = true;
end
fclose(fid);
fid = fopen(filename,'rt');
if select_flag
    S = textscan(fid, '%f%f%f%[^\n\r]', sum_atom, 'Headerlines',9);
    S = [S{1} S{2} S{3}];
else
    S = textscan(fid, '%f%f%f%[^\n\r]', sum_atom, 'Headerlines',8);
    S = [S{1} S{2} S{3}];
    
end
fclose(fid);
atom = cell(2,length(atom_ele));
for ii = 1:length(atom_ele)
   atom{1,ii} = atom_ele{ii};
   atom{2,ii} = atom_num{ii};
end