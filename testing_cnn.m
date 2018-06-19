%% Get Training Images 
ds = imageDatastore('E:\Chris_Sample_Data\Channel_Count_Imgs\', ...
    'IncludeSubfolders', true, ...
    'FileExtensions', '.png',...
    'LabelSource', 'foldernames');
%resize images to be 227 x 227 x 3
ds.ReadSize = numpartitions(ds);
ds.ReadFcn = @(loc)imresize(imread(loc),[227,227]);
%divide data
[train, test] = splitEachLabel(ds, .7);
classes = numel(categories(ds.Labels));

%% Modify AlexNet 
net = alexnet;
layers = net.Layers;
layers(end-2) = fullyConnectedLayer(classes);
layers(end) = classificationLayer;

%% Train
options = trainingOptions('sgdm', 'InitialLearnRate', 0.001);
[trained_net, info] = trainNetwork(train, layers, options);
predictions = classify(trained_net, test);

%% Evaluate 
numequal = nnz(predictions == test.Labels);
score = numequal/numel(test.Labels);
disp(['The classification accuracy is ' num2str(score)]);

%% Confusion Matrix 
cmat = confusionmat(test.Labels, predictions);
heatmap({'A', 'B'}, {'A', 'B'}, cmat);