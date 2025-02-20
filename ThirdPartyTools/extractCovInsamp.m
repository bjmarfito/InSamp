function extractCovInsamp(fileNames)

    %% Extract covariance matrix from InSamp
    %% Author: Bryan Marfito
    %%
    %% Usage: extractCovInsamp(InSamp file outputs)
    %% Example: extractCovInsamp({'S1_des.mat', 'A2_asc.mat'})

    if nargin < 1
        help extractCovInsamp
        return
    end

    dataSets = fileNames;

    % Extracts the covariance matrix from InSamp
    covIndex = [];
    sizeCell = 0;
    sizeCellA = 1;
    for i =1:length(dataSets)
        tmp = load(dataSets{i});
        covIndex = [covIndex {tmp.savestruct.covstruct.cov}];
        sizeCell = sizeCell + size(covIndex{i},2);
        covMatrix(sizeCellA:sizeCell, sizeCellA:sizeCell) = covIndex{i};
        sizeCellA = sizeCell + 1;
    end

    % save covMatrix covMatrix -v7.3
    writematrix(covMatrix, "covMatrix.txt", 'Delimiter','space')

    disp("Apply Cholesky decomposition and extract the lower triangular matrix factor.")

end
