ns = dir('E:\Francisco_Sample_Data\ML\NS\*.mat');
ts = dir('E:\Francisco_Sample_Data\ML\TS\*.mat');
tx = dir('E:\Francisco_Sample_Data\ML\TX\*.mat');
ty = dir('E:\Francisco_Sample_Data\ML\TY\*.mat');

fs = 24414;

disp('Designing filters...');

g = fdesign.notch('N,F0,Q', 4, 60, 10, fs);
Hd_notch = design(g);

order = 3;
fcutlow = 150 / fs; %rad/s
fcuthigh = 4000 / fs; %rad/s

h = fdesign.bandpass('Fst1,Fp1,Fp2,Fst2,Ast1,Ap,Ast2', ...
    0.001, fcutlow, fcuthigh, .5, 60,1,60);
Hd_band = design(h,'equiripple');

for i = 1:length(ns)
    disp(['Creating NS image ' num2str(i) ' of ' num2str(length(ns))]);
    d = load(['E:\Francisco_Sample_Data\ML\NS\' ns(i).name]);
    d = d.chunk;
    d = d(ceil(length(d)/3):length(d) - ceil(length(d)/3), :); %middle 1/3
    
    %define time window to chunk into 
    twin = 10e-3; %seconds
    %convert to samples 
    sampwin = twin * fs;
    %number of sample windows that will fit in data 
    numwin = ceil(size(d,1)/sampwin);
    %create windowing indices 
    win = linspace(1, size(d,1), numwin);
    
    spike_bools = zeros(numwin, 16);
    
    %go through each channel
    for j = 1:size(d,2)
        ch = d(:,j);
        x = filter(Hd_band, filter(Hd_notch, ch));

        %separate into time chunks
        %determine if spikes occurred in time chunk
        %if so, = 1, o.w. = 0
        for k = 1:numwin-1
            seg = x(win(k):win(k+1));
            %get indices of spikes 
            [~, locs] = findpeaks(seg, 'MinPeakHeight', .15);
            %which spike locations are in this window 
            spk = numel(locs);
            spike_bools(k,j) = spk > 0;
        end 
    end
    %save as image
    f = figure();
    imagesc(spike_bools);
    c = gray;
    c = flipud(c); 
    colormap(c);
    print(['E:\Francisco_Sample_Data\Images\Channels-ml\NS\' 'channel_count_' num2str(i)], '-dpng');
    close(f);
end

for i = 1:length(ts)
    disp(['Creating TS image ' num2str(i) ' of ' num2str(length(ts))]);
    
    d = load(['E:\Francisco_Sample_Data\ML\TS\' ts(i).name]);
    d = d.chunk;
    d = d(ceil(length(d)/3):length(d) - ceil(length(d)/3), :); %middle 1/3
    
    %define time window to chunk into 
    twin = 10e-3; %seconds
    %convert to samples 
    sampwin = twin * fs;
    %number of sample windows that will fit in data 
    numwin = ceil(size(d,1)/sampwin);
    %create windowing indices 
    win = linspace(1, size(d,1), numwin);
    
    spike_bools = zeros(numwin, 16);
    
    %go through each channel
    for j = 1:size(d,2)
        ch = d(:,j);
        x = filter(Hd_band, filter(Hd_notch, ch));

        %separate into time chunks
        %determine if spikes occurred in time chunk
        %if so, = 1, o.w. = 0
        for k = 1:numwin-1
            seg = x(win(k):win(k+1));
            %get indices of spikes 
            [~, locs] = findpeaks(seg, 'MinPeakHeight', .15);
            %which spike locations are in this window 
            spk = numel(locs);
            spike_bools(k,j) = spk > 0;
        end 
    end
    %save as image
    f = figure();
    imagesc(spike_bools);
    c = gray;
    c = flipud(c); 
    colormap(c);
    print(['E:\Francisco_Sample_Data\Images\Channels-ml\TS\' 'channel_count_' num2str(i)], '-dpng');
    close(f);
end

for i = 1:length(tx)
    disp(['Creating TX image ' num2str(i) ' of ' num2str(length(tx))]);
    
    d = load(['E:\Francisco_Sample_Data\ML\TX\' tx(i).name]);
    d = d.chunk;
    d = d(ceil(length(d)/3):length(d) - ceil(length(d)/3), :); %middle 1/3
    
    %define time window to chunk into 
    twin = 10e-3; %seconds
    %convert to samples 
    sampwin = twin * fs;
    %number of sample windows that will fit in data 
    numwin = ceil(size(d,1)/sampwin);
    %create windowing indices 
    win = linspace(1, size(d,1), numwin);
    
    spike_bools = zeros(numwin, 16);
    
    %go through each channel
    for j = 1:size(d,2)
        ch = d(:,j);
        x = filter(Hd_band, filter(Hd_notch, ch));

        %separate into time chunks
        %determine if spikes occurred in time chunk
        %if so, = 1, o.w. = 0
        for k = 1:numwin-1
            seg = x(win(k):win(k+1));
            %get indices of spikes 
            [~, locs] = findpeaks(seg, 'MinPeakHeight', .15);
            %which spike locations are in this window 
            spk = numel(locs);
            spike_bools(k,j) = spk > 0;
        end 
    end
    %save as image
    f = figure();
    imagesc(spike_bools);
    c = gray;
    c = flipud(c); 
    colormap(c);
    print(['E:\Francisco_Sample_Data\Images\Channels-ml\TX\' 'channel_count_' num2str(i)], '-dpng');
    close(f);
end

for i = 1:length(ty)
    disp(['Creating TY image ' num2str(i) ' of ' num2str(length(ty))]);
    
    d = load(['E:\Francisco_Sample_Data\ML\TY\' ty(i).name]);
    d = d.chunk;
    d = d(ceil(length(d)/3):length(d) - ceil(length(d)/3), :); %middle 1/3
    
    %define time window to chunk into 
    twin = 10e-3; %seconds
    %convert to samples 
    sampwin = twin * fs;
    %number of sample windows that will fit in data 
    numwin = ceil(size(d,1)/sampwin);
    %create windowing indices 
    win = linspace(1, size(d,1), numwin);
    
    spike_bools = zeros(numwin, 16);
    
    %go through each channel
    for j = 1:size(d,2)
        ch = d(:,j);
        x = filter(Hd_band, filter(Hd_notch, ch));

        %separate into time chunks
        %determine if spikes occurred in time chunk
        %if so, = 1, o.w. = 0
        for k = 1:numwin-1
            seg = x(win(k):win(k+1));
            %get indices of spikes 
            [~, locs] = findpeaks(seg, 'MinPeakHeight', .15);
            %which spike locations are in this window 
            spk = numel(locs);
            spike_bools(k,j) = spk > 0;
        end 
    end
    %save as image
    f = figure();
    imagesc(spike_bools);
    c = gray;
    c = flipud(c); 
    colormap(c);
    print(['E:\Francisco_Sample_Data\Images\Channels-ml\TY\' 'channel_count_' num2str(i)], '-dpng');
    close(f);
end