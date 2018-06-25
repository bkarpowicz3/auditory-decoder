%% get file names 
% AL 
alfiles = dir('E:\Francisco_Sample_Data\SAM-180615_al\*.mat');
% ML 
mlfiles = dir('E:\Francisco_Sample_Data\SAM-180615_ml\*.mat');

%% get meta data 
load metadata.mat
meta = meta.trial(:,1:2);

%% load channels into large matrix
% AL = cell(1, 96);
% for i = 1:numel(alfiles) 
%     disp(['Loading AL channel ' num2str(i)]);
%     load(['E:\Francisco_Sample_Data\SAM-180615_al\' alfiles(i).name]);
%     AL{i} = data;
% end 

ML = cell(1, 96);
for i = 1:numel(mlfiles)
    disp(['Loading ML channel ' num2str(i)]);
    load(['E:\Francisco_Sample_Data\SAM-180615_ml\' mlfiles(i).name]);
    ML{i} = data;
end

%% get labels
load Jun15_18.mat
events = {Jun15_18.CurrentParam};

for i = 1:numel(events)
    str = events{i};
    str = strsplit(str, '.');
    events{i} = str{4};
end 

%% chunk data
% 
% for i = 1:size(meta, 1)
%     chunk = [];
%     inds = meta(i, :);
%     for j = 1:numel(alfiles)
%         ch = AL{j};
%         chunk = [chunk, ch(inds(1):inds(2))'];
%     end 
%     
%     filename = ['SAM_AL_' num2str(i) '.mat'];
%     savepath = ['E:\Francisco_Sample_Data\AL\' events{i} '\' filename];
%     save(savepath, 'chunk');
% end 

for i = 1:size(meta, 1)
    disp(['Saving file ' num2str(i) ' of ' num2str(size(meta,1))]);
    
    chunk = [];
    inds = meta(i, :);
    for j = 1:numel(mlfiles)
        ch = ML{j};
        chunk = [chunk, ch(inds(1):inds(2))'];
    end 
    
    filename = ['SAM_ML_' num2str(i) '.mat'];
    savepath = ['E:\Francisco_Sample_Data\ML\' events{i} '\' filename];
    save(savepath, 'chunk');
end 