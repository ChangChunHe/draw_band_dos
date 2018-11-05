function draw_dos_pdos(dos_file, have_pdos)
%draw Density of state diagram  of a system
%   draw_dos_pdos(dos_file, have_pdos)
%   doscar_file:   the path of DOSCAR file
%   have_pdos: true or false, 0 or 1 a bool value to specify that whether
%   you want to draw partial dos diagram 
% 
%   Examples:
%
%       dos_file = 'DOSCAR';
%       draw_dos_pdos(dos_file, 1)
%
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
if sum(isnan(sum_dos)) == 0; ispin = 1;else ispin = 0;end
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
    p_dos(:,1) = sum_dos(:,1) - s(4);
    if ispin
        figure
        hold on
        plot(p_dos(:,1), sum_dos(:,2),'r','LineWidth', 2)
        plot(p_dos(:,1), p_dos(:,2),'m','LineWidth', 2)
        plot(p_dos(:,1), p_dos(:,4)+p_dos(:,8)+p_dos(:,6),'b','LineWidth', 2);
        plot(p_dos(:,1), sum(p_dos(:,10:2:19),2), 'g','LineWidth', 2);
        sum_dos(:,1) = p_dos(:,1);
        ind = sum_dos(:,1) <= 0;
        patch([sum_dos(ind,1);flipud(sum_dos(ind,1))], ...
            [sum_dos(ind,2);flipud(zeros(length(ind(ind)),1))],...
            [45 48 52]/255,...
            'FaceA',.2,'EdgeA',0);
        plot(p_dos(:,1), -p_dos(:,3),'m','LineWidth', 2)
        plot(p_dos(:,1), -sum_dos(:,3),'r','LineWidth', 2)
        plot(p_dos(:,1), -p_dos(:,5)-p_dos(:,9)-p_dos(:,7),'b','LineWidth', 2);
        plot(p_dos(:,1), -sum(p_dos(:,11:2:19),2), 'g','LineWidth', 2);
        patch([sum_dos(ind,1);flipud(sum_dos(ind,1))], ...
            [-sum_dos(ind,3);flipud(zeros(length(ind(ind)),1))],...
            [45 48 52]/255,...
            'FaceA',.2,'EdgeA',0);
    else % plot no-spin PDOS
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
text(0,1.1*yval(1),'E_{fermi}')
line([0, 0],[yval(1) yval(end)], 'linestyle','--')
title('DOS')