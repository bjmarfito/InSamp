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
    covData(sizeCellA:sizeCell, sizeCellA:sizeCell) = covIndex{i};
    sizeCellA = sizeCell + 1;
end


%%Obsolete code%%%%%%%%%%%%%%%%%%%%
%load('S1_asc_stepfunc_6month.mat')
%S1_asc_cov = savestruct.covstruct.cov;
%load('S1_des_stepfunc_1year.mat')
%S1_des_cov = savestruct.covstruct.cov;
%load('A2_SM_des_downsampled.mat')
%A2_SM_des_cov = savestruct.covstruct.cov;
%load('A2_SS_des_downsampled.mat')
%A2_SS_des_cov = savestruct.covstruct.cov;

%extract size of each matrices
%S1_asc_size = size(S1_asc_cov);
%S1_asc_size = S1_asc_size(1);

%S1_des_size = size(S1_des_cov);
%S1_des_size = S1_des_size(1);

%A2_SM_des_size = size(A2_SM_des_cov);
%A2_SM_des_size = A2_SM_des_size(1);

%A2_SS_des_size=size(A2_SS_des_cov);
%A2_SS_des_size = A2_SS_des_size(1);

%Create covariance matrix
%S1_asc_des_A2_SM_SS_des_cov =  [S1_asc_cov zeros(S1_asc_size, S1_des_size) zeros(S1_asc_size, A2_SM_des_size) zeros(S1_asc_size, A2_SS_des_size); zeros(S1_des_size, S1_asc_size) S1_des_cov zeros(S1_des_size, A2_SM_des_size) zeros(S1_des_size, A2_SS_des_size); zeros(A2_SM_des_size, S1_asc_size) zeros(A2_SM_des_size,S1_des_size) A2_SM_des_cov zeros(A2_SM_des_size, A2_SS_des_size); zeros(A2_SS_des_size, S1_asc_size) zeros(A2_SS_des_size,S1_des_size) zeros(A2_SS_des_size, A2_SM_des_size) A2_SS_des];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

save covMatrix covData -v7.3
writematrix(covData, "covMatrix.txt", 'Delimiter','space')

%Extract the diagonal values of the covariance matrix
diagcov = diag(covData);
diagcov = transpose(diagcov);
diagcov = diag(diagcov);
save diagCovMatrix  diagcov -v7.3
writematrix(diagcov, "diagCovMatrix.txt", 'Delimiter','space')