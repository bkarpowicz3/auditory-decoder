%% get file names
% ns = dir('E:\Francisco_Sample_Data\ML\NS\*.mat');
% tx = dir('E:\Francisco_Sample_Data\ML\TX\*.mat');

a = dir('E:\Chris_Sample_Data\Stimulus_A\*.mat');
b = dir('E:\Chris_Sample_Data\Stimulus_B\*.mat');

data = [{a.name}, {b.name}];

%% load files 
all_data = cell(length(data), 1);
labels = cell(length(data), 1);

addpath(genpath('E:\Chris_Sample_Data\Stimulus_A\'));
addpath(genpath('E:\Chris_Sample_Data\Stimulus_B\'));

% load('E:\Chris_Sample_Data\filters.mat');

for i = 1:length(data)
    c = load(data{i});
    c = c.chunk(1:70000)';
    
%     for m = 1:96
%         ch = c(m, :);
%         ch = filtfilt(Hd_band.Numerator, 1, filter(Hd_notch, ch));
%         c(m,:) = ch;
%     end
    all_data{i} = c;
    
    if contains(data{i}, 'A')
        labels{i} = 'A';
    else
        labels{i} = 'B';
    end 
end

%% split into train and test 
k = 5;
inds = crossvalind('Kfold', size(data, 2), k);

%% MAIN 

all_accuracy = zeros(k,1);

for i = 1:k
    test_inds = inds == i;
    train_inds = ~test_inds;
    
    X_train = all_data(train_inds);
    X_test = all_data(test_inds);
    Y_train = labels(train_inds);
    Y_test = labels(test_inds);
    
    predictions = cell(length(Y_test), 1);
    for x = 1:length(Y_test)
        disp(['Classifying ' num2str(x) ' of ' num2str(length(Y_test))]);
        neighbors = getNeighbors(X_train, Y_train, X_test{x}, 7);
        result = getResponse(neighbors);
        predictions{x} = result;
        disp(['Predicted: ' result ', Actual: ' Y_test{x}]);
    end 
    
    accuracy = evaluate(Y_test, predictions);
    all_accuracy(i) = accuracy;
    disp(['Accuracy: ' num2str(accuracy)]);
end 
total_acc = mean(all_accuracy);
disp(['Total Accuracy: ' num2str(total_acc)]);

%% distance metric 
function d = myDist(x,y)
    [~,~,D,~] = dpfast(simmx(abs(x),abs(y)));
    d = D(end);
end

%% compute neighbors 
function neighbors = getNeighbors(training, trainingLabels, testInstance, k)
    test = testInstance;
    
    distances = cell(length(training), 2);
    for x = 1:length(training)
        train = training{x};
        d = myDist(test, train);
        distances(x, 1) = trainingLabels(x);
        distances{x, 2} = d;
    end 
    
    sorted = sortrows(distances, 2);
    neighbors = sorted(1:k,1);
end 

%% get votes 
function votes = getResponse(neighbors)
    classVotes = containers.Map('KeyType', 'char', 'ValueType', 'double');
    
    for x = 1:length(neighbors)
        response = neighbors{x};
        if isKey(classVotes, response)
            classVotes(response) = classVotes(response) + 1;
        else 
            classVotes(response) = 1;
        end 
    end 
    
   [~, sortIdx] = sort(cell2mat(classVotes.values), 'descend');
    sortedVotes = cell2mat(classVotes.keys);
    sortedVotes = sortedVotes(sortIdx);
    votes = sortedVotes(1);
end 

%% get accuracy 
function a = evaluate(testLabels, predictions)
    correct = nnz(cellfun(@strcmp, testLabels, predictions));
    a = correct/length(testLabels) * 100.0;
end 

