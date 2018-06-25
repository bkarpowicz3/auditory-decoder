%% Loading Data Files
ns_data = dir('E:\Francisco_Sample_Data\ML\NS\*.mat');
tx_data = dir('E:\Francisco_Sample_Data\ML\TX\*.mat');
ty_data = dir('E:\Francisco_Sample_Data\ML\TY\*.mat');
ts_data = dir('E:\Francisco_Sample_Data\ML\TS\*.mat');

addpath(genpath('E:\Chris_Sample_Data\audioFeatureExtraction'));

%% RMS & Zero Crossing Rate
%for each file, for each channel, compute the RMS
%store in a table that is # files x # channels in size

fs = 24414;

N = numel(ns_data) + numel(ts_data) + numel(tx_data) + numel(ty_data);

root_mean_square = zeros(N, 96);
zero_crossing = zeros(N, 96);
spectral_centroid = zeros(N, 96);
spectral_rolloff = zeros(N, 96);
spectral_flux = zeros(N, 96);
mfc_coeff1 = zeros(N, 96);
mfc_coeff2 = zeros(N, 96);
mfc_coeff3 = zeros(N, 96);
labels = cell(N, 1);

disp('Extracting NS features')
for i = 1:length(ns_data)
    d = load(['E:\Francisco_Sample_Data\ML\NS\' ns_data(i).name]);
    d = d.chunk;
    if ~isempty(d)
        for j = 1:size(d, 2)
            data = d(:,j);
            data = data(ceil(length(data)/3):length(data) - ceil(length(data)/3));
            root_mean_square(i,j) = rms(data);
            zero_crossing(i, j) = sum(abs(diff(data>0)))/length(data);
            F = computeAllStatistics(data, .05, .05);
            spectral_centroid(i, j) = F(4);
            spectral_rolloff(i, j) = F(3);
            spectral_flux(i,j) = F(5);
            coeffs = mean(mfcc(data, fs, 'NumCoeffs', 2));
            mfc_coeff1(i, j) = coeffs(1);
            mfc_coeff2(i, j) = coeffs(2);
            mfc_coeff3(i, j) = coeffs(3);
        end
    end
    labels{i} = 'NS';
end

curr_length = numel(ns_data);

disp('Extracting TS features')
for i = 1:length(ts_data)
    d = load(['E:\Francisco_Sample_Data\ML\TS\' ts_data(i).name]);
    d = d.chunk;
    if ~isempty(d)
        for j = 1:size(d, 2)
            data = d(:,j);
            data = data(ceil(length(data)/3):length(data) - ceil(length(data)/3));
            root_mean_square(i + curr_length,j) = rms(data);
            zero_crossing(i + curr_length, j) = sum(abs(diff(data>0)))/length(data);
            F = computeAllStatistics(data, .05, .05);
            spectral_centroid(i + curr_length, j) = F(4);
            spectral_rolloff(i + curr_length, j) = F(3);
            spectral_flux(i + curr_length,j) = F(5);
            coeffs = mean(mfcc(data, fs, 'NumCoeffs', 2));
            mfc_coeff1(i + curr_length, j) = coeffs(1);
            mfc_coeff2(i + curr_length, j) = coeffs(2);
            mfc_coeff3(i + curr_length, j) = coeffs(3);
        end
    end
    labels{i + curr_length} = 'TS';
end

curr_length = numel(ns_data) + numel(ts_data);

disp('Extracting TY features')
for i = 1:length(ty_data)
    d = load(['E:\Francisco_Sample_Data\ML\TY\' ty_data(i).name]);
    d = d.chunk;
    if ~isempty(d)
        for j = 1:size(d, 2)
            data = d(:,j);
            data = data(ceil(length(data)/3):length(data) - ceil(length(data)/3));
            root_mean_square(i + curr_length,j) = rms(data);
            zero_crossing(i + curr_length, j) = sum(abs(diff(data>0)))/length(data);
            F = computeAllStatistics(data, .05, .05);
            spectral_centroid(i + curr_length, j) = F(4);
            spectral_rolloff(i + curr_length, j) = F(3);
            spectral_flux(i + curr_length,j) = F(5);
            coeffs = mean(mfcc(data, fs, 'NumCoeffs', 2));
            mfc_coeff1(i + curr_length, j) = coeffs(1);
            mfc_coeff2(i + curr_length, j) = coeffs(2);
            mfc_coeff3(i + curr_length, j) = coeffs(3);
        end
    end
    labels{i+curr_length} = 'TY';
end

curr_length = numel(ns_data) + numel(ts_data) + numel(ty_data);

disp('Extracting TX features');
for i = 1:length(tx_data)
    d = load(['E:\Francisco_Sample_Data\ML\TX\' tx_data(i).name]);
    d = d.chunk;
    if ~isempty(d)
        for j = 1:size(d, 2)
            data = d(:,j);
            data = data(ceil(length(data)/3):length(data) - ceil(length(data)/3));
            root_mean_square(i + curr_length,j) = rms(data);
            zero_crossing(i + curr_length, j) = sum(abs(diff(data>0)))/length(data);
            F = computeAllStatistics(data, .05, .05);
            spectral_centroid(i + curr_length, j) = F(4);
            spectral_rolloff(i + curr_length, j) = F(3);
            spectral_flux(i + curr_length,j) = F(5);
            coeffs = mean(mfcc(data, fs, 'NumCoeffs', 2));
            mfc_coeff1(i + curr_length, j) = coeffs(1);
            mfc_coeff2(i + curr_length, j) = coeffs(2);
            mfc_coeff3(i + curr_length, j) = coeffs(3);
        end
    end
    labels{i + curr_length} = 'TX';
end

%% Data Table Formatting & Saving
labels = categorical(labels);

%make table
T = array2table(root_mean_square);
T2 = array2table(zero_crossing);
T3 = array2table(spectral_centroid);
T4 = array2table(spectral_flux);
T5 = array2table(spectral_rolloff);
T6 = array2table(mfc_coeff1);
T7 = array2table(mfc_coeff2);
T8 = array2table(mfc_coeff3);
T = [T T2 T3 T4 T5 T6 T7 T8];
T = addvars(T,labels);
save('rms_zc_spec3_mfcc3_table_ML.mat', 'T');

% %% MFCC only
% T_MFCC = [T6 T7 T8];
% T_MFCC = addvars(T_MFCC, categorical(Y), 'After', 'ch16_mfcc3');
% T_MFCC.Properties.VariableNames{'Var49'} = 'Label';
% save('mfcc_only_table.mat', 'T_MFCC');