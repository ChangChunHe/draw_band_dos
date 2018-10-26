function fermi = get_fermi_from_doscar(filename)
fid = fopen(filename);
sum_dos = cell2mat(textscan(fid,'%f %f %f %f %f',1, 'HeaderLines',5));
fermi = sum_dos(4);
fclose(fid);