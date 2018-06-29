Adir = 'E:\Chris_Sample_Data\Stimulus_A\';
cd(Adir);
stim_A_data = dir('*.mat');
Bdir = 'E:\Chris_Sample_Data\Stimulus_B\';
cd(Bdir);
stim_B_data = dir('*.mat');
cd ..

%% rms over windows

fs = 32556;
winlen = 5; %ms
winsamp = winlen * 1e-3 * fs;

%% load filters 
load filters.mat
%includes a 60 Hz notch filter and a bandpass filter ranging 150 - 5000 Hz 

%% produce images 
for j = 1:numel(stim_B_data)
    disp(['Creating plot for image ' num2str(j) ' of ' num2str(numel(stim_B_data))]);
    
    load([Bdir filesep stim_B_data(j).name]);
    
    for m = 1:16
        ch = chunk(:,m);
        ch = filtfilt(Hd_band.Numerator, 1, filter(Hd_notch, ch));
        chunk(:,m) = ch;
    end
    
    data = zeros(length(edges)-1,size(chunk,2));
    
    edges = 1:winsamp:size(chunk,1);
    edges = round(edges);
    
    for k = 1:length(edges)-1
        bite = chunk(edges(k):edges(k+1), :);
        data(k, :) = rms(bite, 1);
    end 
    f = figure(); %'Visible', 'Off'
    f.PaperPositionMode = 'auto';
    fig_pos = f.PaperPosition;
    f.PaperSize = [fig_pos(3) fig_pos(4)];
    colormap gray 
    imagesc(data)
    axis square
    
    axis off
    print(['E:\Chris_Sample_Data\Images\RMS_5_f\B\' 'rms_plot_B_' num2str(j)], '-dpng');
    close(f);
end 

run('testing_cnn.m');