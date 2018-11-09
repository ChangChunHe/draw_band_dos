function draw_dos_pdos(dos_file, pos_file)
%draw DOS of each element
%   draw_dos_element(dos_file, pos_file)
%   dos_file:   the path of DOSCAR file
%   pos_file:   the path of pos file
%   have_pdos: true or false
%
%   Examples:
%       pos_file = 'FM/POSCAR';dos_file = 'FM/DOSCAR';
%       draw_dos_pdos(dos_file, pos_file)
%       axis([-5 3.5, -40 40])
%
%
%   See also  draw_dos_pdos, draw_band_structure

[sum_dos, p_dos] = read_doscar(dos_file);
[atom, num, sys_name] = read_element(pos_file);

fid = fopen(dos_file, 'rt');
k = 1;
while feof(fid) == 0
    tline = fgetl(fid);
%     if k == 1
%         s1 = str2num(tline);
%     end
    if k == 6
        s = str2num(tline);
        break
    end
    k = k + 1;
end
fclose(fid);
n_pdos = size(p_dos,2);
color_map = [255 0 0;255 128 0;255 255 0; 128 255 0; 2 255 0;0 255 128;
    0 255 255; 0 128 255; 0 0 255; 127 0 255;255 0 255;255 0 127;128 128 128;
    255,140,0;160,82,45;250,128,114; 128,128,0]/256;
switch n_pdos
    case 19
        seq = zeros(length(atom),2);seq(1,:) = [1 num(1)];
        for ik = 2:length(atom)
            seq(ik,:) = [num(ik-1)+1 sum(num(1:ik))];
        end
        [~,ind] = min(abs(sum_dos(:,1) - s(4)));
        ind_up = find((sum_dos(:,4)-round(sum_dos(ind,4)))>0);
        ind_down =find((sum_dos(:,5)-round(sum_dos(ind,5)))>0);
       
        hold on
        sum_dos(:,1) = sum_dos(:,1) - s(4);
        ind_color = 1;
        for ik = 1:length(atom)
            tmp_s_up = sum(sum(p_dos(:,2,seq(ik,1):seq(ik,2)),2),3);
            tmp_s_down = sum(sum(p_dos(:,3,seq(ik,1):seq(ik,2)),2),3);
            tmp_p_up = sum(sum(p_dos(:,4:2:8,seq(ik,1):seq(ik,2)),2),3);
            tmp_p_down = sum(sum(p_dos(:,5:2:9,seq(ik,1):seq(ik,2)),2),3);
            tmp_d_up = sum(sum(p_dos(:,10:2:19,seq(ik,1):seq(ik,2)),2),3);
            tmp_d_down = sum(sum(p_dos(:,11:2:19,seq(ik,1):seq(ik,2)),2),3);
            plot(sum_dos(:,1), tmp_s_up, 'color',color_map(ind_color,:));
            plot(sum_dos(:,1), -tmp_s_down, 'color',color_map(ind_color,:));ind_color = ind_color + 1;
            plot(sum_dos(:,1), tmp_p_up, 'color',color_map(ind_color,:));
            plot(sum_dos(:,1), -tmp_p_down, 'color',color_map(ind_color,:));ind_color = ind_color + 1;
            plot(sum_dos(:,1), tmp_d_up, 'color',color_map(ind_color,:));
            plot(sum_dos(:,1), -tmp_d_down, 'color',color_map(ind_color,:));ind_color = ind_color + 1;
        end
        plot(sum_dos(:,1), sum_dos(:,2),'r','LineWidth', 2)
        plot(sum_dos(:,1), -sum_dos(:,3),'r','LineWidth', 2)
        sum_dos_up = sum_dos;tmp = sum_dos_up(:,1) - sum_dos_up(ind_up(1)-1,1);
        ind = tmp <= 0;
        patch([sum_dos_up(ind,1);flipud(sum_dos_up(ind,1))], ...
            [sum_dos_up(ind,2);flipud(zeros(length(ind(ind)),1))],...
            [45 48 52]/255,...
            'FaceA',.2,'EdgeA',0);
        sum_dos_down = sum_dos;tmp = sum_dos_down(:,1) - sum_dos_up(ind_down(1)-1,1);
        ind = tmp <= 0;
        patch([sum_dos_down(ind,1);flipud(sum_dos_down(ind,1))], ...
            [-sum_dos_down(ind,3);flipud(zeros(length(ind(ind)),1))],...
            [45 48 52]/255,...axis([-5.5 3.5, -40 40])
            'FaceA',.2,'EdgeA',0);
        spd_atom = cell(6*length(atom),1);
        for ii = 1:length(atom); 
            spd_atom{6*(ii-1)+1} = [atom{ii}, '_s-up'];
            spd_atom{6*(ii-1)+2} = [atom{ii}, '_s-down'];
            spd_atom{6*(ii-1)+3} = [atom{ii}, '_p-up'];
            spd_atom{6*(ii-1)+4} = [atom{ii}, '_p-down'];
            spd_atom{6*(ii-1)+5} = [atom{ii}, '_d-up'];
            spd_atom{6*(ii-1)+6} = [atom{ii}, '_d-down'];
        end
        
        h = legend(spd_atom{:},'Total DOS');set(h,'FontSize',18);
    case 10
        spd_atom = cell(3*length(atom),1);
        for ii = 1:length(atom); spd_atom{3*(ii-1)+1} = [atom{ii}, '_s'];
            spd_atom{3*(ii-1)+2} = [atom{ii}, '_p'];spd_atom{3*(ii-1)+3} = [atom{ii}, '_d'];
        end
        
        seq = zeros(length(atom),2);seq(1,:) = [1 num(1)];
        for ik = 2:length(atom)
            seq(ik,:) = [sum(num(1:ik-1))+1 sum(num(1:ik))];
        end
        
        hold on
        sum_dos(:,1) = sum_dos(:,1) - s(4);
        ind_color = 1;
        for ik = 1:length(atom)
            tmp_s = sum(sum(p_dos(:,2,seq(ik,1):seq(ik,2)),2),3);
            tmp_p = sum(sum(p_dos(:,3:5,seq(ik,1):seq(ik,2)),2),3);
            tmp_d = sum(sum(p_dos(:,6:10,seq(ik,1):seq(ik,2)),2),3);
            plot(sum_dos(:,1), tmp_s, 'color',color_map(ind_color,:));ind_color = ind_color + 1;
            plot(sum_dos(:,1), tmp_p, 'color',color_map(ind_color,:));ind_color = ind_color + 1;
            plot(sum_dos(:,1), tmp_d, 'color',color_map(ind_color,:));ind_color = ind_color + 1;
        end
        ind = sum_dos(:,1) <= 0;
        plot(sum_dos(:,1), sum_dos(:,2),'r','LineWidth', 2)
        patch([sum_dos(ind,1);flipud(sum_dos(ind,1))], ...
            [sum_dos(ind,2);flipud(zeros(length(ind(ind)),1))],...
            [45 48 52]/255,...
            'FaceA',.2,'EdgeA',0);
        h = legend(spd_atom{:},'Total DOS');set(h,'FontSize',18);
    case 17
        
        spd_atom = cell(4*length(atom),1);
        for ii = 1:length(atom); spd_atom{4*(ii-1)+1} = [atom{ii}, '_s'];
            spd_atom{4*(ii-1)+2} = [atom{ii}, '_p'];
            spd_atom{4*(ii-1)+3} = [atom{ii}, '_d'];
            spd_atom{4*(ii-1)+4} = [atom{ii}, '_f'];
        end
        
        seq = zeros(length(atom),2);seq(1,:) = [1 num(1)];
        for ik = 2:length(atom)
            seq(ik,:) = [sum(num(1:ik-1))+1 sum(num(1:ik))];
        end
       
        hold on
        sum_dos(:,1) = sum_dos(:,1) - s(4);
        ind_color = 1;
        for ik = 1:length(atom)
            tmp_s = sum(sum(p_dos(:,2,seq(ik,1):seq(ik,2)),2),3);
            tmp_p = sum(sum(p_dos(:,3:5,seq(ik,1):seq(ik,2)),2),3);
            tmp_d = sum(sum(p_dos(:,6:10,seq(ik,1):seq(ik,2)),2),3);
            tmp_f = sum(sum(p_dos(:,11:17,seq(ik,1):seq(ik,2)),2),3);
            plot(sum_dos(:,1), tmp_s, 'color',color_map(ind_color,:));ind_color = ind_color + 1;
            plot(sum_dos(:,1), tmp_p, 'color',color_map(ind_color,:));ind_color = ind_color + 1;
            plot(sum_dos(:,1), tmp_d, 'color',color_map(ind_color,:));ind_color = ind_color + 1;
            plot(sum_dos(:,1), tmp_f, 'color',color_map(ind_color,:));ind_color = ind_color + 1;
        end
        ind = sum_dos(:,1) <= 0;
        plot(sum_dos(:,1), sum_dos(:,2),'r','LineWidth', 2)
        patch([sum_dos(ind,1);flipud(sum_dos(ind,1))], ...
            [sum_dos(ind,2);flipud(zeros(length(ind(ind)),1))],...
            [45 48 52]/255,...
            'FaceA',.2,'EdgeA',0);
        h = legend(spd_atom{:},'Total DOS');set(h,'FontSize',18);
end
title(['DOS of ',deblank(sys_name)],'fontsize',18)
yval = get(gca, 'ylim');
text(0,0,'E_{fermi}')
line([0, 0],[yval(1) yval(end)], 'linestyle','--')