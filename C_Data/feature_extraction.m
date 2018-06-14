%% Loading Data Files
Adir = 'E:\Chris_Sample_Data\Stimulus_A\';
cd(Adir);
stim_A_data = dir('*.mat');
Bdir = 'E:\Chris_Sample_Data\Stimulus_B\';
cd(Bdir);
stim_B_data = dir('*.mat');
cd ..
cd ..

addpath(genpath('Chris_Sample_Data\audioFeatureExtraction'));

%% RMS & Zero Crossing Rate
%for each file, for each channel, compute the RMS
%store in a table that is # files x # channels in size

fs = 32556;

root_mean_square = zeros(numel(stim_A_data) + numel(stim_B_data), 16);
zero_crossing = zeros(numel(stim_A_data) + numel(stim_B_data), 16);
spectral_centroid = zeros(numel(stim_A_data) + numel(stim_B_data), 16);
spectral_rolloff = zeros(numel(stim_A_data) + numel(stim_B_data), 16);
spectral_flux = zeros(numel(stim_A_data) + numel(stim_B_data), 16);
mfc_coeff1 = zeros(numel(stim_A_data) + numel(stim_B_data), 16);
mfc_coeff2 = zeros(numel(stim_A_data) + numel(stim_B_data), 16);
mfc_coeff3 = zeros(numel(stim_A_data) + numel(stim_B_data), 16);


for i = 1:length(stim_A_data)
    d = load([Adir filesep stim_A_data(i).name]);
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
end

for i = 1:length(stim_B_data)
    d = load([Bdir filesep stim_B_data(i).name]);
    d = d.chunk;
    if ~isempty(d)
        for j = 1:size(d, 2)
            data = d(:,j);
            data = data(ceil(length(data)/3):length(data) - ceil(length(data)/3));
            root_mean_square(i + length(stim_A_data),j) = rms(data);
            zero_crossing(i + length(stim_A_data),j) = sum(abs(diff(data>0)))/length(data);
            F = computeAllStatistics(data, .05, .05);
            spectral_centroid(i + length(stim_A_data),j) = F(4);
            spectral_rolloff(i + length(stim_A_data),j) = F(3);
            spectral_flux(i + length(stim_A_data),j) = F(5);
            coeffs = mean(mfcc(data, fs, 'NumCoeffs', 2));
            mfc_coeff1(i + length(stim_A_data), j) = coeffs(1);
            mfc_coeff2(i + length(stim_A_data), j) = coeffs(2);
            mfc_coeff3(i + length(stim_A_data), j) = coeffs(3);
        end
    end
end

%% Data Table Formatting & Saving
%create label vectors
Y = cell(numel(stim_A_data) + numel(stim_B_data), 1);
for i = 1:length(stim_A_data)
    Y{i} = 'A';
end
for i = 1:length(stim_B_data)
    Y{i+length(stim_A_data)} = 'B';
end

%make table
T = array2table(root_mean_square, 'VariableNames', {'ch1_rms', 'ch2_rms', 'ch3_rms', 'ch4_rms', ...
    'ch5_rms', 'ch6_rms', 'ch7_rms', 'ch8_rms', 'ch9_rms', 'ch10_rms', 'ch11_rms', 'ch12_rms', ...
    'ch13_rms', 'ch14_rms', 'ch15_rms', 'ch16_rms'});
T2 = array2table(zero_crossing, 'VariableNames', {'ch1_zc', 'ch2_zc', 'ch3_zc', 'ch4_zc', ...
    'ch5_zc', 'ch6_zc', 'ch7_zc', 'ch8_zc', 'ch9_zc', 'ch10_zc', 'ch11_zc', 'ch12_zc', 'ch13_zc', ...
    'ch14_zc', 'ch15_zc', 'ch16_zc'});
T3 = array2table(spectral_centroid, 'VariableNames', {'ch1_centr', 'ch2_centr', 'ch3_centr', 'ch4_centr', ...
    'ch5_centr', 'ch6_centr', 'ch7_centr', 'ch8_centr', 'ch9_centr', 'ch10_centr','ch11_centr', ...
    'ch12_centr', 'ch13_centr', 'ch14_centr','ch15_centr','ch16_centr'});
T4 = array2table(spectral_flux, 'VariableNames', {'ch1_flux', 'ch2_flux', 'ch3_flux', 'ch4_flux', ...
    'ch5_flux', 'ch6_flux', 'ch7_flux', 'ch8_flux', 'ch9_flux', 'ch10_flux','ch11_flux', ...
    'ch12_flux', 'ch13_flux', 'ch14_flux','ch15_flux','ch16_flux'});
T5 = array2table(spectral_rolloff, 'VariableNames', {'ch1_ro', 'ch2_ro', 'ch3_ro', 'ch4_ro', ...
    'ch5_ro', 'ch6_ro', 'ch7_ro', 'ch8_ro', 'ch9_ro', 'ch10_ro','ch11_ro', ...
    'ch12_ro', 'ch13_ro', 'ch14_ro','ch15_ro','ch16_ro'});
T6 = array2table(mfc_coeff1, 'VariableNames', {'ch1_mfcc1', 'ch2_mfcc1', 'ch3_mfcc1', 'ch4_mfcc1', ...
    'ch5_mfcc1', 'ch6_mfcc1','ch7_mfcc1','ch8_mfcc1','ch9_mfcc1','ch10_mfcc1','ch11_mfcc1','ch12_mfcc1', ...
    'ch13_mfcc1','ch14_mfcc1','ch15_mfcc1','ch16_mfcc1'});
T7 = array2table(mfc_coeff2, 'VariableNames', {'ch1_mfcc2', 'ch2_mfcc2', 'ch3_mfcc2', 'ch4_mfcc2', ...
    'ch5_mfcc2', 'ch6_mfcc2','ch7_mfcc2','ch8_mfcc2','ch9_mfcc2','ch10_mfcc2','ch11_mfcc2','ch12_mfcc2', ...
    'ch13_mfcc2','ch14_mfcc2','ch15_mfcc2','ch16_mfcc2'});
T8 = array2table(mfc_coeff3, 'VariableNames', {'ch1_mfcc3', 'ch2_mfcc3', 'ch3_mfcc3', 'ch4_mfcc3', ...
    'ch5_mfcc3', 'ch6_mfcc3','ch7_mfcc3','ch8_mfcc3','ch9_mfcc3','ch10_mfcc3','ch11_mfcc3','ch12_mfcc3', ...
    'ch13_mfcc3','ch14_mfcc3','ch15_mfcc3','ch16_mfcc3'});
T = [T T2 T3 T4 T5 T6 T7 T8];
T = addvars(T,categorical(Y),'After','ch16_mfcc3');
T.Properties.VariableNames{'Var129'} = 'Label';
save('rms_zc_spec3_mfcc3_table.mat', 'T');

% %% MFCC only
% T_MFCC = [T6 T7 T8];
% T_MFCC = addvars(T_MFCC, categorical(Y), 'After', 'ch16_mfcc3');
% T_MFCC.Properties.VariableNames{'Var49'} = 'Label';
% save('mfcc_only_table.mat', 'T_MFCC');