% Extract covariance matrix from InSamp
% Author: Bryan Marfito

function [] = extractCov(fileNames)

%% Usage: extractCov(InSamp file outputs)
%% Example: extractCov({'S1_des.mat', {'A2_asc.mat'})

clc
dataSets = fileNames;

% Extracts the covariance matrix from InSamp
covIndex = [];
sizeCell = 0;
sizeCellA = 1;
for i =1:length(dataSets)
    tmp = load(dataSets{i});
    covIndex = [covIndex {tmp.savestruct.covstruct.cov}];
    sizeCell = sizeCell + size(covIndex{i},2);
    covData(sizeCellA:sizeCell, sizeCellA:sizeCell) = covIndex{i};
    sizeCellA = sizeCell + 1;
end
covData = chol(covData,'lower');

% Extract the diagonal values since the data noise is assumed to be a result of random process.
% Reference: Environmental Data Analysis by Menke
covData = diag(covData);
covData = transpose(covData);
covMatrix = diag(covData);
clear covData
save covMatrix covMatrix -v7.3
writematrix(covMatrix, "covMatrix.txt", 'Delimiter','space')

clear
end
