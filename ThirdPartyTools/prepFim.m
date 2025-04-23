function [] = prepFim(matFilename)
    %% Transform InSAMP data from UTM to lon lat and dump data, and enu vectors into a text file
    %% with a format lon lat east west up dlos(m)
    load(matFilename)
    matFilename = erase(matFilename,".mat");
    outputFilename = strcat(matFilename,".txt");
    X = [savestruct.data.X];
    Y = [savestruct.data.Y];
    data = [savestruct.data.data];
    %Create an array for the lon lat and utm
    [m, n] = size(X);
    lon = ones(m,n);
    lat = ones(m,n);
    utmZ = str2double(savestruct.zone(1:2));

    for a = m:n
        [lon(m,a), lat(m,a)]= utm2ll(X(m,a), Y(m,a),utmZ, 2);
    end

    lon = transpose(lon);
    lat = transpose(lat);
    enuVector = [savestruct.data.S];
    enuVector = transpose(enuVector) .* -1;
    enuVector(enuVector(:, 3) == -0, 3) = 0;
    data = transpose(data);
    vectormatrix = [lon lat enuVector data];
    writematrix(vectormatrix, outputFilename, 'Delimiter','space')
end
