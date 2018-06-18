Adir = 'E:\Chris_Sample_Data\Stimulus_A\';
cd(Adir);
stim_A_data = dir('*.mat');
Bdir = 'E:\Chris_Sample_Data\Stimulus_B\';
cd(Bdir);
stim_B_data = dir('*.mat');
cd ..

fs = 32556;

g = fdesign.notch('N,F0,Q', 4, 60, 10, fs);
Hd_notch = design(g);

%         [b,a] = butter(order,[fcutlow,fcuthigh]/(fs/2), 'bandpass');
        
%         d = fdesign.bandpass('N,Fst1,Fp1,Fp2,Fst2,C',20,...
%             fcutlow,fcutlow * 2,fcuthigh/2,fcuthigh,fcuthigh);

order = 3;
fcutlow = 50 / fs; %rad/s
fcuthigh = 5000 / fs; %rad/s

h = fdesign.bandpass('Fst1,Fp1,Fp2,Fst2,Ast1,Ap,Ast2', ...
    0.001, fcutlow, fcuthigh, .5, 60,1,60);
Hd_band = design(h,'equiripple');

for i = 1:length(stim_A_data)
    d = load([Adir filesep stim_A_data(i).name]);
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
    print([Adir filesep 'Images' filesep 'channel_count_' num2str(i)], '-dpng');
    close(f);
end

%repeat for B images 
for i = 1:length(stim_B_data)
    d = load([Bdir filesep stim_B_data(i).name]);
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
    print([Bdir filesep 'Images' filesep 'channel_count_' num2str(i + length(stim_A_data))], '-dpng');
    close(f);
end