function draw_band_structure_dos(eigval_file, dos_file, pos_file, kpoint_file, have_pdos, n_band)
[energy, kpoint] = read_eigenval(eigval_file);
energy = energy{1} - get_fermi_from_doscar(dos_file);
[rec_k, sys_name] = read_recip(pos_file);
sys_name = deblank(sys_name);
for ii = 2:size(kpoint,1)
    kpoint(ii, 5) = norm((kpoint(ii-1,1:3)-kpoint(ii,1:3)) * rec_k);
end
kpoint(:,5) = cumsum(kpoint(:,5));
q1 = find(energy(:,1)>0);
if mod(n_band,2) == 0
    low_lim = n_band/2;
    up_lim = n_band/2-1;
else
    low_lim = floor(n_band/2);
    up_lim = floor(n_band/2);
end
% energy = energy(q1(1)-low_lim:q1(1)+up_lim,:);
[hsp, hsp_label, node] = read_high_sym_point(kpoint_file);
energy_gap = min(energy(q1(1),:)) - max(energy(q1(1)-1,:));
figure
h1 = subplot(1,2,1);
h1_pos = get(h1,'position');
set(h1,'position',[h1_pos(1)+0.05 h1_pos(2:4)])

energy = energy - max(energy(q1(1)-1,:));

plot(kpoint(:,5), energy(q1(1)-low_lim:q1(1)+up_lim,:))
x_value = get(gca, 'XTick');
y_value = get(gca, 'YTick');hold on
set(gca,'XTick', [], 'XTickLabel', []);
for ii = 1:size(hsp,1)/2
    text(kpoint(node*(ii-1)+1,5)-0.01*(x_value(end)-x_value(1)),...
        y_value(1)-0.02*(y_value(end)-y_value(1)), hsp_label{2*(ii-1)+1}, 'fontsize', 13)
    text(kpoint(node*ii,5)-0.01*(x_value(end)-x_value(1)),...
        y_value(1)-0.02*(y_value(end)-y_value(1)), hsp_label{2*ii}, 'fontsize', 13)
    line([kpoint(node*(ii-1)+1,5) kpoint(node*(ii-1)+1,5)], [y_value(1) y_value(end)],...
        'LineStyle','--','color','r' )
    line([kpoint(node*ii,5) kpoint(node*ii,5)], [y_value(1) y_value(end)], 'LineStyle','--','color','r')
end
text(x_value(1)-x_value(end)/15,0,'E_f')
axis([kpoint(1,5) kpoint(end,5) y_value(1) y_value(end)])
title(['Band Structure of ', sys_name, ' Gap is ', num2str(energy_gap), 'eV'])
screen_size = get(0,'screensize');
set(gcf, 'Position',0.8*screen_size)

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

h1_pos = get(h1,'position');
h2 = subplot(1,2,2);
set(h2, 'position', [h1_pos(1)+h1_pos(3) h1_pos(2) h1_pos(3) h1_pos(4)])
if have_pdos
    fid = fopen(dos_file, 'rt');
    FormatString=repmat('%f ',1,3);
    sum_dos = cell2mat(textscan(fid,FormatString,s(3),'HeaderLines',6));
    FormatString = repmat('%f ',1,10);
    p_dos = zeros(s(3), 10);
    for ii = 1:s1(1)
        temp = cell2mat(textscan(fid,FormatString,s(3),'HeaderLines',2));
        p_dos(:,2:end) = p_dos(:,2:end) + temp(:,2:end);
    end
    fclose(fid);
    p_dos(:,1) = sum_dos(:,1) - s(4) - max(energy(q1(1)-1,:));
    plot(sum_dos(:,2), p_dos(:,1), 'r','LineWidth', 3);hold on
    plot(p_dos(:,2), p_dos(:,1), 'm','LineWidth', 3);hold on
    plot(p_dos(:,3)+p_dos(:,5)+p_dos(:,4),p_dos(:,1), 'b','LineWidth', 3)
    plot(sum(p_dos(:,6:10),2), p_dos(:,1),  'g','LineWidth', 3);
    x_value = get(gca, 'XTick');
    axis([x_value(1) x_value(end) y_value(1) y_value(end)])
    set(gca,'YTick', [], 'YTickLabel', []);
    sum_dos(:,1) = sum_dos(:,1) - s(4);
    sum_dos = sum_dos(sum_dos(:,1)<=0,:);
    patch([sum_dos(:,2);flipud(zeros(size(sum_dos,1),1))],...
        [sum_dos(:,1);flipud(sum_dos(:,1))],...
        [45 48 52]/255,...
        'FaceA',.2,'EdgeA',0);
    legend('total','s-orbit','p-orbit','d-orbit')
    set(gca,'XTick', [], 'XTickLabel', []);
else
    fid = fopen(dos_file, 'rt');
    FormatString=repmat('%f ',1,3);
    sum_dos = cell2mat(textscan(fid,FormatString,s(3),'HeaderLines',6));
    fclose(fid);
    plot(sum_dos(:,2), sum_dos(:,1)-s(4),'LineWidth', 3)
    sum_dos(:,1) = sum_dos(:,1) - s(4)- max(energy(q1(1)-1,:));
    hold on
    sum_dos = sum_dos(sum_dos(:,1)<=0,:);
    patch([sum_dos(:,2);flipud(zeros(size(sum_dos,1),1))],...
        [sum_dos(:,1);flipud(sum_dos(:,1))],...
        [45 48 52]/255,...
        'FaceA',.2,'EdgeA',0)
    x_value = get(gca, 'XTick');
    axis([x_value(1) x_value(end) y_value(1) y_value(end)])
    set(gca,'YTick', [], 'YTickLabel', []);
    set(gca,'XTick', [], 'XTickLabel', []);
    legend('Total DOS')
    title('DOS')
    set(gca,'XTick', [], 'XTickLabel', []);
end
