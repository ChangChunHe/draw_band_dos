function draw_dos_pdos(dos_file, have_pdos)
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
        plot(p_dos(:,1), p_dos(:,4)+p_dos(:,8),'b','LineWidth', 2);
        plot(p_dos(:,1), p_dos(:,6), 'g','LineWidth', 2);
        sum_dos(:,1) = p_dos(:,1);
        ind = sum_dos(:,1) <= 0;
        patch([sum_dos(ind,1);flipud(sum_dos(ind,1))], ...
            [sum_dos(ind,2);flipud(zeros(length(ind(ind)),1))],...
            [45 48 52]/255,...
            'FaceA',.2,'EdgeA',0);
        plot(p_dos(:,1), -sum_dos(:,3),'r','LineWidth', 2)
        plot(p_dos(:,1), -p_dos(:,5)-p_dos(:,9),'b','LineWidth', 2);
        plot(p_dos(:,1), -p_dos(:,7), 'g','LineWidth', 2);
        patch([sum_dos(ind,1);flipud(sum_dos(ind,1))], ...
            [-sum_dos(ind,3);flipud(zeros(length(ind(ind)),1))],...
            [45 48 52]/255,...
            'FaceA',.2,'EdgeA',0);
    else % plot no-spin PDOS
        figure
        hold on
        plot(p_dos(:,1), sum_dos(:,2),'r','LineWidth', 2)
        plot(p_dos(:,1), p_dos(:,3)+p_dos(:,5),'b','LineWidth', 2);
        plot(p_dos(:,1), p_dos(:,4), 'g','LineWidth', 2);
        sum_dos(:,1) = p_dos(:,1);
        ind = sum_dos(:,1)<=0;
        patch([sum_dos(ind,1);flipud(sum_dos(ind,1))], ...
            [sum_dos(ind,2);flipud(zeros(length(ind(ind)),1))],...
            [45 48 52]/255,...
            'FaceA',.2,'EdgeA',0);
    end
    legend('Total DOS','p_x+p_y','p_z')
    title('DOS')
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
    legend('Total DOS')
    title('DOS')
end