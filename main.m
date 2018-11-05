clear
clc
pat = 'band';
eigval_file = [pat, '/EIGENVAL'];
dos_file = [pat, '/DOSCAR'];
pos_file = [pat, '/POSCAR'];
kpoint_file = [pat, '/KPOINTS'];
draw_band_structure_dos(eigval_file, dos_file, pos_file, kpoint_file,1, 80)
