clear
clc
pat = 'PtSe';
eigval_file = fullfile(pat, 'EIGENVAL');
dos_file = fullfile(pat, 'DOSCAR');
pos_file = fullfile(pat, 'POSCAR');
kpts_file = fullfile(pat, 'KPOINTS');
[sum_dos, p_dos] = read_doscar(dos_file);
draw_band_structure_dos(eigval_file, dos_file, pos_file, kpts_file)
% draw_band_structure(eigval_file, pos_file, kpts_file)
% figure
% draw_dos_element(dos_file, pos_file)
% % % % % axis([-4.5 5 -40 40])``
% figure
% draw_dos_pdos(dos_file, pos_file)
%axis([-4.5 5 -40 40])
% draw_band_structure_two_spin(eigval_file, pos_file, kpts_file)
% set(gcf,'color','w');export_fig In_Mg_O_Sc_band.png -m2