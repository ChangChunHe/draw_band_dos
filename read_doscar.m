function [sum_dos, p_dos] = read_doscar(dos_file)
fid = fopen(dos_file, 'rt');
k = 1;
while feof(fid) == 0
    tline = fgetl(fid);
    if k == 1
        s1 = str2num(tline);
    end
    if k == 6
        s = str2num(tline);
        break
    end
    k = k + 1;
end
fclose(fid);
fid = fopen(dos_file, 'rt');
FormatString=repmat('%f ',1,3);
sum_dos = cell2mat(textscan(fid,FormatString,s(3) ,'HeaderLines',6));
if sum(sum(isnan(sum_dos))) == 0; ispin = 0;else ispin = 1;end
tline = fgetl(fid);
tline = fgetl(fid);
tline = fgetl(fid);
if fgetl(fid) == -1
    have_pdos = false;
else
    have_pdos = true;
    tmp_pdos = str2num(tline);
end
fclose(fid);
if ispin
    fid = fopen(dos_file, 'rt');
    FormatString=repmat('%f ',1,5);
    sum_dos = cell2mat(textscan(fid,FormatString,s(3) ,'HeaderLines',6));
    tline = fgetl(fid);
    tline = fgetl(fid);
    tline  =fgetl(fid);
    if fgetl(fid) == -1
        have_pdos = false;
    else
        have_pdos = true;
        tmp_pdos = str2num(fgetl(fid));
    end
    fclose(fid);
end
if have_pdos
    n_pdos = length(tmp_pdos);
else
    n_pdos = 0;
end
p_dos = get_pdos(dos_file, n_pdos, s(3), s1(1), ispin);

function p_dos = get_pdos(dos_file, n_pdos, NEDOS, n_element, ispin)
fid = fopen(dos_file, 'rt');
if ispin; FormatString=repmat('%f ',1,5);else FormatString=repmat('%f ',1,3);end
sum_dos = cell2mat(textscan(fid,FormatString,NEDOS,'HeaderLines',6));
if n_pdos ~= 0
    p_dos = zeros(NEDOS, n_pdos, n_element);
    FormatString=repmat('%f ',1,n_pdos);
    for ii = 1:n_element
        p_dos(:,:,ii) = cell2mat(textscan(fid,FormatString,NEDOS,'HeaderLines',2));
    end
else
    p_dos = 0;
end

fclose(fid);
