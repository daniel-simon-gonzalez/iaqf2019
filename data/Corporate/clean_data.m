% this script will generate the cleaned and merged data
%
%

seq = {'BAMLC1A0C13YEY','BAMLC2A0C35YEY','BAMLC3A0C57YEY','BAMLC4A0C710YEY','BAMLC7A0C1015YEY'};
n = length(seq);

result = readtable('BAMLC1A0C13YEY.csv');
disp('BAMLC1A0C13YEY.csv')
for i = 2:n
    file_name = [ seq{i} '.csv'];
    disp(file_name);
    temp_table = readtable(file_name);
    result = outerjoin(result,temp_table,'Keys',1,'MergeKeys',true);
end

%% convert data type
names = result.Properties.VariableNames(2:end);
for i = 1:n
    temp_col = result(:,names{i});
    result(:,names{i}) = [];
    temp_col = temp_col.Variables;
    temp_col = str2double(temp_col);
    result = addvars(result,temp_col,'NewVariableNames',names{i});
end
%% delete rows with all NaN
[result,rm]= rmmissing(result,'MinNumMissing',10);

sum(rm) % num of rows been removed
%% name 
result.Properties.VariableNames = {'DATE','Y13','Y35','Y57','Y710','Y1015'};
%% output 
writetable(result,'data_cleaned_cor.csv','Delimiter',',')

