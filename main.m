clear
clc
pat = 'FM';
have_pdos = true;
eigval_file = fullfile(pat, 'EIGENVAL');
dos_file = fullfile(pat, 'DOSCAR');
pos_file = fullfile(pat, 'POSCAR');
kpts_file = fullfile(pat, 'KPOINTS');
% draw_band_structure_dos(eigval_file, dos_file, pos_file, kpts_file, have_pdos)

% draw_band_structure(eigval_file, pos_file, kpts_file)
% draw_dos_element(dos_file, pos_file)
% draw_dos_pdos(dos_file, true)

draw_band_structure_two_spin(eigval_file, pos_file, kpts_file)