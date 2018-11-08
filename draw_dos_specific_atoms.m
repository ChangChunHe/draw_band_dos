function draw_dos_specific_atoms(dos_file, specific_atom)
%draw DOS of specific atoms
%   draw_dos_element(dos_file, pos_file)
%   dos_file:   the path of DOSCAR file
%   specific_atom: the sequence of atoms you want to plot
%
%   Examples:
%       dos_file = 'FM/DOSCAR';specific_atom = 1:40;
%       draw_specific_atoms(dos_file, specific_atom)
%       axis([-5 3.5, -40 40])
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

fid = fopen(dos_file, 'rt');
if ispin; FormatString=repmat('%f ',1,5);
else FormatString=repmat('%f ',1,3);end
sum_dos = cell2mat(textscan(fid,FormatString,s(3),'HeaderLines',6));
if ispin; FormatString = repmat('%f ',1,19);p_dos =  cell(s1(1),1);
else FormatString=repmat('%f ',1,10);p_dos = cell(s1(1),1);end
for ii = 1:s1(1)
    p_dos{ii} = cell2mat(textscan(fid,FormatString,s(3),'HeaderLines',2));
end
fclose(fid);

% p_dos(:,1) = sum_dos(:,1) - s(4);

if ispin
    specif_dos = 0;
    for ii = specific_atom
        specif_dos = specif_dos + p_dos{ii};
    end
    sum_dos(:,1) = sum_dos(:,1) - s(4);
    
    figure
    hold on
    plot(sum_dos(:,1), sum_dos(:,2),'r','LineWidth', 2)
    plot(sum_dos(:,1), sum(specif_dos(:,4:8),2),'b','LineWidth', 2);
    plot(sum_dos(:,1), sum(specif_dos(:,10:2:18),2), 'g','LineWidth', 2);
    
    ind = sum_dos(:,1) <= 0;
    patch([sum_dos(ind,1);flipud(sum_dos(ind,1))], ...
        [sum_dos(ind,2);flipud(zeros(length(ind(ind)),1))],...
        [45 48 52]/255,...
        'FaceA',.2,'EdgeA',0);
    plot(sum_dos(:,1), -sum_dos(:,3),'r','LineWidth', 2)
    plot(sum_dos(:,1), -sum(specif_dos(:,5:9),2),'b','LineWidth', 2);
    plot(sum_dos(:,1), -sum(specif_dos(:,11:2:19),2), 'g','LineWidth', 2);
    patch([sum_dos(ind,1);flipud(sum_dos(ind,1))], ...
        [-sum_dos(ind,3);flipud(zeros(length(ind(ind)),1))],...
        [45 48 52]/255,...
        'FaceA',.2,'EdgeA',0);
else % plot no-spin PDOS
    
    specif_dos = 0;
    for ii = specific_atom
        specif_dos = specif_dos + p_dos{ii};
    end
    sum_dos(:,1) = sum_dos(:,1) - s(4);
    figure
    hold on
    plot(sum_dos(:,1), sum_dos(:,2),'r','LineWidth', 2)
    plot(sum_dos(:,1), specif_dos(:,3)+specif_dos(:,5)+specif_dos(:,4),'b','LineWidth', 2);
    plot(sum_dos(:,1), sum(specif_dos(:,6:10),2),'g','LineWidth', 2);
    %     plot(sum_dos(:,1), specif_dos(:,4), 'g','LineWidth', 2);
    %     sum_dos(:,1) = p_dos(:,1);
    ind = sum_dos(:,1)<=0;
    patch([sum_dos(ind,1);flipud(sum_dos(ind,1))], ...
        [sum_dos(ind,2);flipud(zeros(length(ind(ind)),1))],...
        [45 48 52]/255,...
        'FaceA',.2,'EdgeA',0);
end
hl = legend('Total DOS','p','d');
% set(hl,'fontsize',22);
title('DOS')
