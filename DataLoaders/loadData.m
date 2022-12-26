function datastruct = loadData(processor,datafilename,zone,limitny,azo,const_los,losfilename,nx,ny,parfile,iscestack)

switch processor
    case 'ROIPAC'
        %if isempty(losfilename)
            %error('Designate a geo_incidence.unw file and path');
        %end
        
        datastruct = loadROIPAC(datafilename,zone,limitny,azo);
        datastruct = loadLOS_ROIPAC(datastruct,losfilename,azo,const_los);
    
    case 'ISCE'
        datastruct = loadISCE(datafilename, zone, limitny, azo);
        datastruct = loadLOS_ISCE(datastruct,losfilename,azo);
    
    case 'GMT'
        datastruct = loadGMT(datafilename, losfilename,nx, ny, zone, limitny, azo);
        
    case 'GAMMA'
        datastruct = loadGAMMA(datafilename, losfilename, parfile,zone);
        
    case 'MINTPY'
        datastruct = loadMINTPYISCE(datafilename,zone,limitny,azo);
        datastruct = loadLOS_MINTPYISCE(datastruct,losfilename,azo,iscestack);

    case 'TimeSeries'
        %This expects time series files in geocoded, geotiff format, in
        %units of mm/yr.
        %LOSFILENAME should be two files, look.tif and heading.tif:
        %{look.tif, heading.tif'}
        datastruct = loadTimeSeries(datafilename,losfilename,dt, zone);

    %Need to convert them to meters, positive means towards the satellite, negative means away from the satellite
    case 'ISCE_MAI'
        datastruct = loadISCE_MAI(datafilename, zone, limitny, azo);
        datastruct = loadLOS_ISCE_MAI(datastruct,losfilename,azo);       
end
