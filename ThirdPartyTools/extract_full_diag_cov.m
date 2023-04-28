%Extract full covariance and diagonal values of the covariance matrix from InSamp
%Author: Bryan Marfito

%load all data and put them into matrices
function [] = extract_full_diag_cov(fileNames)
dataSets = fileNames;
%Extracts the covariance matrix from InSamp
covIndex = [];
sizeCell = 0;
sizeCellA = 1;
for i =1:length(dataSets)
    tmp = load(dataSets{i});
    covIndex = [covIndex {tmp.savestruct.covstruct.cov}];
    sizeCell = sizeCell + size(covIndex{i},2);
    covData1(sizeCellA:sizeCell, sizeCellA:sizeCell) = covIndex{i};
    sizeCellA = sizeCell + 1;
end
covData = chol(covData1,'lower');

save covMatrix covData -v7.3
writematrix(covData, "covMatrix.txt", 'Delimiter','space')

%Extract the diagonal values of the covariance matrix
diagcov = diag(covData);
diagcov = transpose(diagcov);
diagcov = diag(diagcov);
save diagCovMatrix  diagcov -v7.3
writematrix(diagcov, "diagCovMatrix.txt", 'Delimiter','space')
