%Extract full-covariance and covariance matrix from InSamp

%load all data and put them into matrices
load('S1_asc_fault_control_dip90_width20km_result.mat')
S1_asc_cov = savestruct.covstruct.cov;
load('S1_des_fault_control_dip90_width20km_result.mat')
S1_des_cov = savestruct.covstruct.cov;
load('A2_des_fault_control_dip90_width20km_result.mat')
A2_des_cov = savestruct.covstruct.cov;

%extract size of each matrices
S1_asc_size = size(S1_asc_cov);
S1_asc_size = S1_asc_size(1);

S1_des_size = size(S1_des_cov);
S1_des_size = S1_des_size(1);

A2_des_size = size(A2_des_cov);
A2_des_size = A2_des_size(1);

%Create full covariance matrix

S1_asc_des__A2_des_cov =  [S1_asc_cov zeros(S1_asc_size, S1_des_size) zeros(S1_asc_size, A2_des_size); zeros(S1_des_size, S1_asc_size) S1_des_cov zeros(S1_des_size, A2_des_size); zeros(A2_des_size, S1_asc_size) zeros(A2_des_size,S1_des_size) A2_des_cov];
save S1_asc_des__A2_des_cov S1_asc_des__A2_des_cov -v7.3

%Extract the diagonal values of the covariance matrix
S1_asc_des__A2_des_diagcov = diag(S1_asc_des__A2_des_cov);
S1_asc_des__A2_des_diagcov = transpose(S1_asc_des__A2_des_diagcov);
S1_asc_des__A2_des_diagcov = diag(S1_asc_des__A2_des_diagcov);
save S1_asc_des__A2_des_diagcov S1_asc_des__A2_des_diagcov -v7.3