%Extract full covariance and diagonal values of the covariance matrix from InSamp
function [] = extract_full_diag_cov(fileNames)
%load all data and put them into matrices
%clear
%close all

dataSets = fileNames;

%dataSets={'S1_des.mat', 'A2_asc_SM_downsampled.mat','A2_des_SS_result.mat'};
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