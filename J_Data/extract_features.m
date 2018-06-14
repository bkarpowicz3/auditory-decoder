%% Getting Data Files 
Fdir = 'E:\Jaejin_Sample_Data\F\';
cd(Fdir);
F_data = dir('*.mat');
Hdir = 'E:\Jaejin_Sample_Data\H\';
cd(Hdir);
H_data = dir('*.mat');
Mdir = 'E:\Jaejin_Sample_Data\M\';
cd(Mdir);
M_data = dir('*.mat');
cd ..

%% RMS, Zero Crossing, Spectral, FMCC 

fs = 20000;

root_mean_square = zeros(numel(F_data) + numel(H_data) + numel(M_data), 136);
zero_crossing = zeros(numel(F_data) + numel(H_data) + numel(M_data), 136);
spectral_centroid = zeros(numel(F_data) + numel(H_data) + numel(M_data), 136);
spectral_rolloff = zeros(numel(F_data) + numel(H_data) + numel(M_data), 136);
spectral_flux = zeros(numel(F_data) + numel(H_data) + numel(M_data), 136);
mfc_coeff1 = zeros(numel(F_data) + numel(H_data) + numel(M_data), 136);
mfc_coeff2 = zeros(numel(F_data) + numel(H_data) + numel(M_data), 136);
mfc_coeff3 = zeros(numel(F_data) + numel(H_data) + numel(M_data), 136);

for i = 1:length(H_data)
    d = load([Hdir filesep H_data(i).name]);
    d = d.block;
    for j = 1:size(d, 1)
        data = d(j, :);
        root_mean_square(i,j) = rms(data);
        zero_crossing(i, j) = sum(abs(diff(data>0)))/length(data);
        F = computeAllStatistics(data', .005, .005);
        spectral_centroid(i, j) = F(4);
        spectral_rolloff(i, j) = F(3);
        spectral_flux(i,j) = F(5);
        coeffs = mean(mfcc(data', fs));
        mfc_coeff1(i, j) = coeffs(1);
        mfc_coeff2(i, j) = coeffs(2);
        mfc_coeff3(i, j) = coeffs(3);
    end 
end 

for i = 1:length(F_data)
    d = load([Fdir filesep F_data(i).name]);
    d = d.block;
    for j = 1:size(d, 1)
        data = d(j,:);
        root_mean_square(i+length(H_data),j) = rms(data);
        zero_crossing(i+length(H_data), j) = sum(abs(diff(data>0)))/length(data);
        F = computeAllStatistics(data', .05, .05);
        spectral_centroid(i+length(H_data), j) = F(4);
        spectral_rolloff(i+length(H_data), j) = F(3);
        spectral_flux(i+length(H_data),j) = F(5);
        coeffs = mean(mfcc(data', fs));
        mfc_coeff1(i+length(H_data), j) = coeffs(1);
        mfc_coeff2(i+length(H_data), j) = coeffs(2);
        mfc_coeff3(i+length(H_data), j) = coeffs(3);
    end 
end 

for i = 1:length(M_data)
    d = load([Mdir filesep M_data(i).name]);
    d = d.block;
    for j = 1:size(d, 1)
        data = d(j,:);
        root_mean_square(i+length(H_data)+length(F_data),j) = rms(data);
        zero_crossing(i+length(H_data)+length(F_data), j) = sum(abs(diff(data>0)))/length(data);
        F = computeAllStatistics(data', .05, .05);
        spectral_centroid(i+length(H_data)+length(F_data), j) = F(4);
        spectral_rolloff(i+length(H_data)+length(F_data), j) = F(3);
        spectral_flux(i+length(H_data)+length(F_data),j) = F(5);
        coeffs = mean(mfcc(data', fs));
        mfc_coeff1(i+length(H_data)+length(F_data), j) = coeffs(1);
        mfc_coeff2(i+length(H_data)+length(F_data), j) = coeffs(2);
        mfc_coeff3(i+length(H_data)+length(F_data), j) = coeffs(3);
    end 
end 

%% Data Table Formatting & Saving 
%create label vectors 
Y = cell(numel(F_data) + numel(H_data) + numel(M_data), 1);
for i = 1:length(H_data)
    Y{i} = 'H';
end 
for i = 1:length(F_data)
    Y{i+length(H_data)} = 'F';
end 
for i = 1:length(M_data)
   Y{i+length(H_data)+length(F_data)} = 'M';
end

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

T = addvars(T,categorical(Y),'After','mfc_coeff3136');
T.Properties.VariableNames{'Var1089'} = 'Label';

writetable(T, 'j_data_features.csv');