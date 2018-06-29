ns = dir('E:\Francisco_Sample_Data\ML\NS\*.mat');
ts = dir('E:\Francisco_Sample_Data\ML\TS\*.mat');
tx = dir('E:\Francisco_Sample_Data\ML\TX\*.mat');
ty = dir('E:\Francisco_Sample_Data\ML\TY\*.mat');

%% rms over windows

fs = 24414;
winlen = 5; %ms
winsamp = winlen * 1e-3 * fs;

load E:\Chris_Sample_Data\filters.mat
%includes a 60 Hz notch filter and a bandpass filter ranging 150 - 5000 Hz

%% produce images 
for j = 1:numel(ns)
    disp(['Creating plot for image ' num2str(j) ' of ' num2str(numel(ns))]);
    
    load(['E:\Francisco_Sample_Data\ML\NS\' ns(j).name]);
    
    for m = 1:96
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
    f = figure('Visible', 'Off');
    colormap gray 
    imagesc(data)
    axis square
    axis off
    print(['E:\Francisco_Sample_Data\Images\RMS_5_ml-f\NS\' 'rms_plot_NS_' num2str(j)], '-dpng');
    close(f);
end 

for j = 1:numel(ts)
    disp(['Creating plot for image ' num2str(j) ' of ' num2str(numel(ts))]);
    
    load(['E:\Francisco_Sample_Data\ML\TS\' ts(j).name]);
    
    for m = 1:96
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
    f = figure('Visible', 'Off');
    colormap gray 
    imagesc(data)
    axis square
    axis off
    print(['E:\Francisco_Sample_Data\Images\RMS_5_ml-f\TS\' 'rms_plot_TS_' num2str(j)], '-dpng');
    close(f);
end 

for j = 1:numel(tx)
    disp(['Creating plot for image ' num2str(j) ' of ' num2str(numel(tx))]);
    
    load(['E:\Francisco_Sample_Data\ML\TX\' tx(j).name]);
    
    for m = 1:96
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
    f = figure('Visible', 'Off');
    colormap gray 
    imagesc(data)
    axis square
    axis off
    print(['E:\Francisco_Sample_Data\Images\RMS_5_ml-f\TX\' 'rms_plot_TX_' num2str(j)], '-dpng');
    close(f);
end 

for j = 1:numel(ty)
    disp(['Creating plot for image ' num2str(j) ' of ' num2str(numel(ty))]);
    
    load(['E:\Francisco_Sample_Data\ML\TY\' ty(j).name]);
    
    for m = 1:96
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
    f = figure('Visible', 'Off');
    colormap gray 
    imagesc(data)
    axis square
    axis off
    print(['E:\Francisco_Sample_Data\Images\RMS_5_al-f\TY\' 'rms_plot_TY_' num2str(j)], '-dpng');
    close(f);
end 