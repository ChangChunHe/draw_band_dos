function draw_dos_element(dos_file, pos_file, have_pdos)
%draw DOS of each element
%   draw_dos_element(dos_file, pos_file)
%   dos_file:   the path of DOSCAR file
%   pos_file:   the path of pos file
%   have_pdos: true or false
%
%   Examples:
%       pos_file = 'FM/POSCAR';dos_file = 'FM/DOSCAR';
%       draw_dos_element(dos_file, pos_file, true)
%       axis([-6.5 3.5, -40 40])
%
%
%   See also  draw_dos_pdos, draw_band_structure, draw_specific_atoms

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
FormatString=repmat('%f ',1,5);
sum_dos = cell2mat(textscan(fid,FormatString,s(3),'HeaderLines',6));
if sum(isnan(sum_dos)) == 0; ispin = 1;else ispin = 0;end
fclose(fid);
[atom, num, sys_name] = read_element(pos_file);
if have_pdos
    fid = fopen(dos_file, 'rt');
    if ispin; FormatString=repmat('%f ',1,5);else FormatString=repmat('%f ',1,3);end
    sum_dos = cell2mat(textscan(fid,FormatString,s(3),'HeaderLines',6));
    if ispin; FormatString = repmat('%f ',1,19);p_dos = zeros(s(3), 19, s1(1));
    else FormatString=repmat('%f ',1,10);p_dos = zeros(s(3), 10, s1(1));end
    for ii = 1:s1(1)
        p_dos(:,:,ii) = cell2mat(textscan(fid,FormatString,s(3),'HeaderLines',2));
    end
    fclose(fid);
    if ispin
        element_dos_up = zeros(s(3), length(atom));
        element_dos_down = zeros(s(3), length(atom));
        seq = zeros(length(atom),2);seq(1,:) = [1 num(1)];
        for ik = 2:length(atom)
            seq(ik,:) = [num(ik-1)+1 sum(num(1:ik))];
        end
        
        [~,ind] = min(abs(sum_dos(:,1) - s(4)));
        ind_up = find((sum_dos(:,4)-round(sum_dos(ind,4)))>0);
        
        ind_down =find((sum_dos(:,5)-round(sum_dos(ind,5)))>0);
        
        figure
        hold on
        
        for ik = 1:length(atom)
            element_dos_up(:, ik) = sum(sum(p_dos(:,2:2:19,seq(ik,1):seq(ik,2)),2),3);
            element_dos_down(:, ik) = sum(sum(p_dos(:,3:2:19,seq(ik,1):seq(ik,2)),2),3);
            color_ = rand(3,1);
            plot(sum_dos(:,1), -element_dos_down(:,ik),'color', color_);
            plot(sum_dos(:,1), element_dos_up(:,ik), 'color',color_)
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
        for ik = 1:2*length(atom)+1; tmp_atom{ik} = 'a';end
        tmp_atom{1} = [atom{1},'_{up}'];
        tmp_atom{2} = [atom{1},'_{down}'];
        h = legend(tmp_atom{:});
        for ik = 2:length(atom)
            tmp_str = get(h, 'String');
            tmp_str{2*(ik-1)+1} = [atom{ik}, '_{up}'];tmp_str{2*ik} = [atom{ik}, '_{down}'];
            set(h, 'String',tmp_str);
        end
        tmp_str = get(h, 'String');
        tmp_str{end} = 'Total DOS';
        set(h, 'String',tmp_str,'FontSize',18);
    else % plot no-spin
        element_dos_up = zeros(s(3), length(atom));
        seq = zeros(length(atom),2);seq(1,:) = [1 num(1)];
        for ik = 2:length(atom)
            seq(ik,:) = [sum(num(1:ik-1))+1 sum(num(1:ik))];
        end
        figure
        hold on
        sum_dos(:,1) = sum_dos(:,1) - s(4);
        for ik = 1:length(atom)
            element_dos_up(:, ik) = sum(sum(p_dos(:,2:end,seq(ik,1):seq(ik,2)),2),3);
            
            color_ = rand(3,1);
            plot(sum_dos(:,1), element_dos_up(:,ik), 'color',color_)
        end
        ind = sum_dos(:,1) <= 0;
        plot(sum_dos(:,1), sum_dos(:,2),'r','LineWidth', 2)
        patch([sum_dos(ind,1);flipud(sum_dos(ind,1))], ...axis([-5 3.5, -40 40])
            [sum_dos(ind,2);flipud(zeros(length(ind(ind)),1))],...
            [45 48 52]/255,...
            'FaceA',.2,'EdgeA',0);
        
        h = legend(atom{:},'Total DOS');set(h,'FontSize',18);
    end
    title(['DOS of ',deblank(sys_name)],'fontsize',18)
end
yval = get(gca, 'ylim');
text(s(4),1.1*yval(1),'E_{fermi}')
line([s(4), s(4)],[yval(1) yval(end)], 'linestyle','--')