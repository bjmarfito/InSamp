%Modified for MintPy outputs
function datastruct = loadLOS_MINTPYISCE(datastruct,losfilename,azo)

if(azo==1)
    % changed to use heading from input .rsc file EJF 2010/4/29
    heading  = load_rscs(losfilename,'HEADING_DEG')
    S        = zeros(datastruct.ny,datastruct.nx,3);
    S(:,:,1) = sind(heading);
    S(:,:,2) = cosd(heading);
    S(:,:,3) = 0;
else
    
    nx     = datastruct.nx;
    ny     = datastruct.ny;
    extrax = datastruct.extrax;
    extray = datastruct.extray;
    ox     = nx-extrax;
    oy     = ny-extray;
    
    fid          = fopen(losfilename,'r','native');
    [temp,count] = fread(fid,[ox,oy*2],'real*4');
    status       = fclose(fid);
    %Modified for MintPy, indices were changed from ROIPAC format
    look    = temp(1:ox,1:oy);
    heading = temp(1:ox,oy+1:oy*2);
    %Modified for MintPy, make nan = 0
    look(isnan(look))=0;
    heading(isnan(heading))=0;
    heading = 180-flipud(heading'); %Puts heading into same convention as ROI_PAC geo_incidence.unw
    look    = flipud(look');
    
    heading     = heading.*pi/180;
    look        = look.*pi/180;

    id          = find(heading==0);
    jd          = find(heading~=0);
    heading(id) = mean(heading(jd));
    look(id)    = mean(look(jd));

    S1 = [sin(heading).*sin(look)];
    S2 = [cos(heading).*sin(look)];
    S3 = [ -cos(look)];

    S1      = blkdiag(S1,zeros(extray,extrax));
    S2      = blkdiag(S2,zeros(extray,extrax));
    S3      = blkdiag(S3,zeros(extray,extrax));
    badid   = find(S1(:)==0);
    S1(badid) = S1(1); % set to average in load_los
    S2(badid) = S2(1);
    S3(badid) = S2(1);

    S(:,:,1)  = S1;
    S(:,:,2)  = S2;
    S(:,:,3)  = S3;
    
end

datastruct.S=S;
