function prepInsamp2distSlipMat(matFilename)

% Convert InSamp downsampled data to a format that can be read by the distSlipMatCode
% Author: Bryan Marfito, EOS-RS

    for k = 1:length(matFilename)
        disp(strcat("Processing file: ", matFilename{k}))
        load(matFilename{k});
        matFilenameVal = erase(matFilename{k},".mat");
        outputFilename = strcat(matFilenameVal,".lltnde");
        X = [savestruct.data.X];
        Y = [savestruct.data.Y];
        losdata = [savestruct.data.data];
        % Create an array for the lon lat and utm
        [m, n] = size(X);
        lon = ones(m,n);
        lat = ones(m,n);
        utmZ = str2num(savestruct.zone(1:2));

        % Check if elevation exists in InSamp data
        % If it doesn't, pad with zeros
        if isfield(savestruct.data,'hgt')
            elevationData = [savestruct.data.hgt];
        else
            elevationData = zeros(length(X),1);
            fprintf('No elevation info found in InSamp downsampled data\nPadding with zeros\n\n')
        end
        % Used utm2ll from InSamp since the results are different from the utm2ll in the original code
        for a = m:n
            [lon(m,a), lat(m,a)]= utm2ll(X(m,a), Y(m,a),utmZ, 2);
        end
        lon = transpose(lon);
        lat = transpose(lat);
        enuVector = [savestruct.data.S];
        enuVector = transpose(enuVector) .* -1;
        enuVector(enuVector(:, 3) == -0, 3) = 0;
        losdata = transpose(losdata);
        % Convert los to cm
        losdata = losdata .*100;
        % Create an array for the covariance matrix
        covMat = savestruct.covstruct.cov;
        % Apply Cholesky decomposition and extract the lower triangular matrix factor
        covMat = chol(covMat,'lower');
        % Convert to cm
        diagCovMat = diag(covMat) .*100;

        % Save memory by clearing the covariance matrix
        clear covMat

        % Write the data to a file
        vectormatrix = [lon lat elevationData enuVector losdata diagCovMat];
        writematrix(vectormatrix, outputFilename, 'Delimiter','space', 'FileType','text')

        % Clear variables except for the filename list and loop index
        clearvars -except matFilename k

    end
end
