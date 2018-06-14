%% Load workspaces 
data1 = load('abu_2018-03-28_19-15-31_multiband_roi100.mat');
data2 = load('abu_2018-03-30_18-41-25_multiband_roi100.mat');

%% Extract relevant variables 
behav1 = data1.behavSummary;
behav2 = data2.behavSummary;
neural1 = data1.chdata_broad_dns;
neural2 = data2.chdata_broad_dns;

%% Pull out trial labels and corresponding channel data 
% want to make a data table with label then timeseries data for each
% channel
% rows are trials 

labels = [behav1(:,5); behav2(:,5)];
data = [neural1; neural2];

%% Go through each trial, and save it in correct folder, for all channels 

counter = 1;
for i = 1:length(labels) 
    block = [];
    for j = 1:size(data(i,:),2)
        if ~isempty(data{i,j}) 
            block(end+1,:) = data{i,j};
        end 
    end 
    %save the block in the appropriate folder 
    save(['C:\Jaejin_Sample_Data\' upper(labels{i}) filesep 'jaejin_sample_data_' num2str(counter) '.mat'], 'block');
    counter = counter + 1;
end 