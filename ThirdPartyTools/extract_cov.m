% Extract covariance matrix from InSamp
% Author: Bryan Marfito

% Load all data and put them into matrices
function [] = extract_full_diag_cov(fileNames)
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

% Obsolete code
%save covMatrix covData -v7.3
%writematrix(covData, "covMatrix.txt", 'Delimiter','space')
%%

% Extract the diagonal values
covData = diag(covData);
covData = transpose(covData);
covMatrix = diag(covData);
save covMatrix covMatrix -v7.3
writematrix(covMatrix, "covMatrix.txt", 'Delimiter','space')

clear
end
