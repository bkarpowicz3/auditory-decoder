Adir = 'E:\Chris_Sample_Data\Stimulus_A\';
cd(Adir);
stim_A_data = dir('*.mat');
Bdir = 'E:\Chris_Sample_Data\Stimulus_B\';
cd(Bdir);
stim_B_data = dir('*.mat');
cd ..

%% rms over windows

fs = 32556;
winlen = 15; %ms
winsamp = winlen * 1e-3 * fs;

%% produce images 
for j = 1:numel(stim_A_data)
    disp(['Creating plot for image ' num2str(j) ' of ' num2str(numel(stim_A_data))]);
    
    load([Adir filesep stim_A_data(j).name]);
    data = zeros(length(edges)-1,size(chunk,2));
    
    edges = 1:winsamp:size(chunk,1);
    edges = round(edges);
    
    for k = 1:length(edges)-1
        bite = chunk(edges(k):edges(k+1), :);
        data(k, :) = rms(bite, 1);
    end 
    f = figure; %('Visible', 'Off');
    colormap gray 
    imagesc(data)
    axis square
    axis off
    print(['E:\Chris_Sample_Data\Images\RMS_15\A\' 'rms_plot_A_' num2str(j)], '-dpng');
    close(f);
end 

run('testing_cnn.m');