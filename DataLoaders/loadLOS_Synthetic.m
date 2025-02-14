%Modified for MintPy outputs
function datastruct = loadLOS_Synthetic(datastruct,losfilename)

    fid = fopen(losfilename, 'r');
    dataValue = textscan(fid, '%f %f %f %f %f %f');
    fclose(fid);

    S1 = dataValue{3};
    S2 = dataValue{4};
    S3 = dataValue{5};

    fid = fopen('syntheticDataParam.txt', 'r');
    paramValue = textscan(fid, '%f %f %f %f', 'CommentStyle', '#');
    fclose(fid);
    paramValue =  cell2mat(paramValue);

    S1 = reshape(S1, paramValue(2), paramValue(1));
    S2 = reshape(S2, paramValue(2), paramValue(1));
    S3 = reshape(S3, paramValue(2), paramValue(1));

    S1 = flipud(S1);
    S2 = flipud(S2);
    S3 = flipud(S3);
    
    badid   = find(S1(:)==0);
    S1(badid) = S1(1); % set to average in load_los
    S2(badid) = S2(1);
    S3(badid) = S2(1);

    % Transform to ENU convention of InSamp
    S(:,:,1)  = -1*S1;
    S(:,:,2)  = -1*S2;
    S(:,:,3)  = -1*S3;

    datastruct.S=S;

end
