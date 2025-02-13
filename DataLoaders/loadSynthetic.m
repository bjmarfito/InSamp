function datastruct = loadSynthetic(filename,zone, azo)
    if(exist([matlabroot '/toolbox/map/mapproj'])==7)
        goodmap=1;
    else
        disp('No mapping toolbox found, using clugy utm2ll for lat/lon conversion')
        goodmap=0;
    end

    pathname =[];

    if(nargin<3)
        azo=0;
    end
    if(nargin<2)
        zone=0;
    end



    if(nargin<1)
            [infilename, pathname]=uigetfile({'*.txt','Unwrapped files (*.unw)'}, ...
                'Pick an input file');
        filename=[pathname infilename];
    end
    
    fid = fopen(filename, 'r');
    dataValue = textscan(fid, '%f %f %f %f %f %f');
    fclose(fid);
    phsData  = dataValue{6};
    x1 = min(dataValue{1});
    y2 = min(dataValue{2});


    fid = fopen('syntheticDataParam.txt', 'r');
    paramValue = textscan(fid, '%f %f %f %f', 'CommentStyle', '#');
    fclose(fid);
    paramValue =  cell2mat(paramValue);

    data = reshape(phsData, paramValue(2), paramValue(1));
    data = flipud(data);
    nx = paramValue(1);
    ny = paramValue(2);
    dx = paramValue(3);
    dy = paramValue(4);


    y1=y2+dy*(ny-1);
    x2=x1+dx*(nx-1);

    x=x1:dx:x2;
    y=y1:-dy:y2;

    [X,Y]=meshgrid(x,y);
    % if(strcmp(xunit,'meters'))
    %     pixelsize=mean([sqrt((X(1)-X(2))^2+(Y(1)-Y(2))^2) sqrt((X(nx*ny-1)-X(nx*ny))^2+(Y(nx*ny-1)-Y(nx*ny))^2)]);
    %     X=X+pixelsize/2;
    %     Y=Y-pixelsize/2;
    %     zone=[];
    % else
        if(zone)
        else
            if(goodmap)
                [jnk1,jnk2,zone]=my_utm2ll(mean(x),mean(y),2);
            else
                [jnk1,jnk2,zone]=utm2ll(mean(x),mean(y),0,2);
            end
            zone=char(inputdlg(['which zone (-1=nogeo), ' num2str(zone) '?']));

        end
        if(str2num(zone)<=-1)
            disp('not setting zone')
        else
            if(goodmap)
                [X,Y]=my_utm2ll(X,Y,2,zone);
            else
                [X,Y]=utm2ll(X,Y,2,zone);
            end
            pixelsize=mean([sqrt((X(1)-X(2))^2+(Y(1)-Y(2))^2) sqrt((X(nx*ny-1)-X(nx*ny))^2+(Y(nx*ny-1)-Y(nx*ny))^2)]);
            X=X+pixelsize/2;
            Y=Y-pixelsize/2;

        end
    % end


    if(azo)
        %azimuth offset type
        disp('just using offsets, no scale')
    end

%look for bad points
baddata         = mode(data(:));
badid           = find(data==baddata);
data(badid)     = NaN;
disp(['setting ' num2str(length(badid)) ' pts with phs=' num2str(baddata) ' to NaN']);


datastruct=struct('data',data,'X',X,'Y',Y,'pixelsize',pixelsize, ...
    'zone',zone,'nx',nx,'ny',ny,'filename',filename);