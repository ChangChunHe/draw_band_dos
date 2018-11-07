function [engval, kpoints] = read_eigenval(filename)
fid = fopen(filename, 'rt');
FormatString=repmat('%f ',1,3);
numb = cell2mat(textscan(fid,FormatString,1,'HeaderLines',5));
tmp = cell2mat(textscan(fid,repmat('%f ', 1, 5),1,'HeaderLines', 4));
NrNaN = sum(isnan(tmp(:)));
if NrNaN ~= 0
    spin_type = 1;
else
    spin_type = 2;
end
fclose(fid);
kpoints = zeros(numb(2),3);
if spin_type == 1
    fid = fopen(filename, 'rt');
    FormatString=repmat('%f ',1,3);
    numb = cell2mat(textscan(fid,FormatString,1,'HeaderLines',5));
    engval = zeros(numb(3), 2*numb(2));
    for ii = 1:numb(2)
        kpoints(ii,:) = cell2mat(textscan(fid,repmat('%f ', 1, 3),1,'HeaderLines',1));
        sub_eigval = cell2mat(textscan(fid,repmat('%f ', 1, 3),numb(3),'HeaderLines', 1));
        engval(:,2*(ii-1)+1:2*ii) = sub_eigval(:,2:3);
    end
    fclose(fid);
    engval = {engval};
else
    fid = fopen(filename, 'rt');
    FormatString=repmat('%f ',1,3);
    numb = cell2mat(textscan(fid,FormatString,1,'HeaderLines',5));
    engval_1 = zeros(numb(3), numb(2));
    engval_2 = zeros(numb(3), numb(2));
    for ii = 1:numb(2)
        kpoints(ii,:) = cell2mat(textscan(fid,repmat('%f ', 1, 3),1,'HeaderLines',1));
        sub_eigval = cell2mat(textscan(fid,repmat('%f ', 1, 5),numb(3),'HeaderLines', 1));
        engval_1(:,2*(ii-1)+1:2*ii) = sub_eigval(:,[2 4]);
        engval_2(:,2*(ii-1)+1:2*ii) = sub_eigval(:,[3 5]);
    end
    fclose(fid);
    engval = {engval_1, engval_2};
end
