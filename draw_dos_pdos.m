function draw_dos_pdos(dos_file, have_pdos)
%draw Density of state diagram  of a system
%   draw_dos_pdos(dos_file, have_pdos)
%   doscar_file:   the path of DOSCAR file
%   have_pdos: true or false, 0 or 1 a bool value to specify that whether
%   you want to draw partial dos diagram
%
%   Examples:
%
%       dos_file = 'FM/DOSCAR';
%       draw_dos_pdos(dos_file, true)
%       axis([-7 3.5, -40 40])
%
%   See also draw_band_structure draw_band_structure_dos, draw_dos_element, draw_dos_pdos

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
if sum(sum(isnan(sum_dos))) == 0; ispin = 1;else ispin = 0;end
fclose(fid);
if have_pdos
    fid = fopen(dos_file, 'rt');
    if ispin; FormatString=repmat('%f ',1,5);
    else FormatString=repmat('%f ',1,3);end
    sum_dos = cell2mat(textscan(fid,FormatString,s(3),'HeaderLines',6));
    if ispin; FormatString = repmat('%f ',1,19);p_dos = zeros(s(3), 19);
    else FormatString=repmat('%f ',1,10);p_dos = zeros(s(3), 10);end
    for ii = 1:s1(1)
        temp = cell2mat(textscan(fid,FormatString,s(3),'HeaderLines',2));
        p_dos(:,2:end) = p_dos(:,2:end) + temp(:,2:end);
    end
    fclose(fid);
    
    if ispin
        figure
        hold on
        p_dos(:,1) = sum_dos(:,1);
        plot(p_dos(:,1), sum_dos(:,2),'r','LineWidth', 2)
        plot(p_dos(:,1), p_dos(:,2),'m','LineWidth', 2)
        plot(p_dos(:,1), p_dos(:,4)+p_dos(:,8)+p_dos(:,6),'b','LineWidth', 2);
        plot(p_dos(:,1), sum(p_dos(:,10:2:19),2), 'g','LineWidth', 2);
        
        
        
        [~,ind] = min(abs(sum_dos(:,1) - s(4)));
        ind_up = find((sum_dos(:,4)-round(sum_dos(ind,4)))>0);
        
        ind_down =find((sum_dos(:,5)-round(sum_dos(ind,5)))>0);
         sum_dos_up = sum_dos;tmp = sum_dos_up(:,1) - sum_dos_up(ind_up(1)-1,1);
        ind = tmp <= 0;
        
        
        patch([sum_dos_up(ind,1);flipud(sum_dos_up(ind,1))], ...
            [sum_dos_up(ind,2);flipud(zeros(length(ind(ind)),1))],...
            [45 48 52]/255,...
            'FaceA',.2,'EdgeA',0);
        
        plot(p_dos(:,1), -p_dos(:,3),'m','LineWidth', 2)
        plot(p_dos(:,1), -sum_dos(:,3),'r','LineWidth', 2)
        plot(p_dos(:,1), -p_dos(:,5)-p_dos(:,9)-p_dos(:,7),'b','LineWidth', 2);
        plot(p_dos(:,1), -sum(p_dos(:,11:2:19),2), 'g','LineWidth', 2);
        sum_dos_down = sum_dos;tmp = sum_dos_down(:,1) - sum_dos_up(ind_down(1)-1,1);
        ind = tmp <= 0;
        
        patch([sum_dos_down(ind,1);flipud(sum_dos_down(ind,1))], ...
            [-sum_dos_down(ind,3);flipud(zeros(length(ind(ind)),1))],...
            [45 48 52]/255,...axis([-5.5 3.5, -40 40])
            'FaceA',.2,'EdgeA',0);
    else % plot no-spin PDOS
        p_dos(:,1) = sum_dos(:,1) - s(4);
        figure
        hold on
        plot(p_dos(:,1), sum_dos(:,2),'r','LineWidth', 2)
        plot(p_dos(:,1), p_dos(:,2),'m','LineWidth', 2)
        plot(p_dos(:,1), p_dos(:,3)+p_dos(:,5)+p_dos(:,4),'b','LineWidth', 2);
        plot(p_dos(:,1), sum(p_dos(:,6:10),2), 'g','LineWidth', 2);
        
        sum_dos(:,1) = p_dos(:,1);
        ind = sum_dos(:,1)<=0;
        patch([sum_dos(ind,1);flipud(sum_dos(ind,1))], ...
            [sum_dos(ind,2);flipud(zeros(length(ind(ind)),1))],...
            [45 48 52]/255,...
            'FaceA',.2,'EdgeA',0);
    end
    h = legend('Total DOS','s-orbit','p-orbit','d-orbit');
    set(h,'fontsize',22);
else
    if ispin
        fid = fopen(dos_file, 'rt');
        FormatString=repmat('%f ',1,5);
        sum_dos = cell2mat(textscan(fid,FormatString,s(3),'HeaderLines',6));
        fclose(fid);
        figure
        hold on
        plot(sum_dos(:,1), sum_dos(:,2),'r','LineWidth', 2)
        
        ind = sum_dos(:,1) <= 0;
        patch([sum_dos(ind,1);flipud(sum_dos(ind,1))], ...
            [sum_dos(ind,2);flipud(zeros(length(ind(ind)),1))],...
            [45 48 52]/255,...
            'FaceA',.2,'EdgeA',0);
        plot(sum_dos(:,1), -sum_dos(:,3),'r','LineWidth', 2)
        patch([sum_dos(ind,1);flipud(sum_dos(ind,1))], ...
            [-sum_dos(ind,3);flipud(zeros(length(ind(ind)),1))],...
            [45 48 52]/255,...
            'FaceA',.2,'EdgeA',0);
    else % plot no-spin PDOS
        fid = fopen(dos_file, 'rt');
        FormatString=repmat('%f ',1,3);
        sum_dos = cell2mat(textscan(fid,FormatString,s(3),'HeaderLines',6));
        fclose(fid);
        figure
        hold on
        plot(sum_dos(:,1), sum_dos(:,2),'r','LineWidth', 2)
        ind = sum_dos(:,1)<=0;
        patch([sum_dos(ind,1);flipud(sum_dos(ind,1))], ...
            [sum_dos(ind,2);flipud(zeros(length(ind(ind)),1))],...
            [45 48 52]/255,...
            'FaceA',.2,'EdgeA',0);
    end
    h = legend('Total DOS');
    set(h,'fontsize',22)
end

yval = get(gca, 'ylim');
text(s(4),yval(1),'E_{fermi}')
line([s(4), s(4)],[yval(1) yval(end)], 'linestyle','--')
title('DOS and PDOS')