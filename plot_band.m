function plot_band(kpoint, energy, hsp, hsp_label, node, sys_name, energy_gap)
plot(kpoint(:,5), energy)
x_value = get(gca, 'XTick');
y_value = get(gca, 'YTick');hold on
set(gca,'XTick', [], 'XTickLabel', []);
for ii = 1:size(hsp,1)/2
    text(kpoint(node*(ii-1)+1,5)-0.01*(x_value(end)-x_value(1)),...
        y_value(1)-0.02*(y_value(end)-y_value(1)), hsp_label{2*(ii-1)+1}, 'fontsize', 13)
    text(kpoint(node*ii,5)-0.01*(x_value(end)-x_value(1)),...
        y_value(1)-0.02*(y_value(end)-y_value(1)), hsp_label{2*ii}, 'fontsize', 13)
    line([kpoint(node*(ii-1)+1,5) kpoint(node*(ii-1)+1,5)], [y_value(1) y_value(end)], 'LineStyle','--','color','r')
    line([kpoint(node*ii,5) kpoint(node*ii,5)], [y_value(1) y_value(end)], 'LineStyle','--','color','r')
end
text(x_value(1)-x_value(end)/15,0,'E_f')
axis([kpoint(1,5) kpoint(end,5) y_value(1) y_value(end)])
title(['Band Structure of ', sys_name, ' Gap is ', num2str(energy_gap), 'eV'])