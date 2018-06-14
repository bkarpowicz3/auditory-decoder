filepath = 'E:\Chris_Sample_Data\2017-10-05_11-26-41';
cd(filepath);
f = dir('*.wav');
cd .. 

%sort in order of channels 
files = {}; 
for i = 8:16
    files{i-7} = f(i).name;
end 
for i = 1:7
    files{end+1} = f(i).name;
end

%read in channels
data = zeros(119181312, 16);
for j = 1:16
    data(:,j) = audioread([filepath filesep files{j}]);
end
 
%sampling freq
fs = 32556;

%load times 
load events.mat
load sample_times.mat 

%find sample times where events are found
inds = zeros(1, length(events));
for k = 1:size(events,1)
    [~, index] = min(abs(t-events(k,1)));
    inds(k) = index;
end

inds = inds(3:end-2);
inds = inds(1:6:end);

%save chunks
stim = 'A';
for i = 1:length(inds)
    disp(['Creating file ' num2str(i) ' of ' num2str(length(inds)) '...']);

    chunk = data(inds(i):inds(i+1), :);
    
    path = ['E:\Chris_Sample_Data\Stimulus_' stim];
    filename = ['sample_data_' stim '_' num2str(i) '.mat'];

    save([path filesep filename], 'chunk');
    
    if strcmp(stim, 'A')
        stim = 'B';
    else
        stim = 'A';
    end
end 
