function [ux,uy,uz] = calc_ps(U,x,y,nu,dip,d,len,W,fault_type,strike, xfault,yfault, daysAfterEQ)

if(0)
if (strike==90)
    strike=89.9;
elseif (strike==45)
    strike=44.9;
elseif (strike==0)
    strike=0.1;
end
if (dip==0)
    dip=0.1;
elseif (dip==90)
    dip=90;
end
end

xfault = xfault / 1000; % Convert to km
yfault = yfault / 1000; % Convert to km
fault_length = len / 1000; % Convert to km
fault_width = W / 1000; % Convert to km
fault_depth = d / 1000; % Convert to km
if fault_type ~= 1 && fault_type ~= 2
    error('fault_type must be 1 (strike slip) or 2 (dip slip)');
end


crustalParameters = [20, 40, daysAfterEQ, 1./60, 1./60];

    % Changed Aki-Richards convention to Layered Half-space code convention
    strike = strike - 180;
    dip = -1 * dip;

    % Split strike slip and dip slip parts.
    % slip = 1;
    U = U * -1;

    % Changed from the first point of the fault to the center of the fault's top depth
    halfLength = fault_length / 2;
    xfault = xfault - halfLength*sind(strike);
    yfault = yfault - halfLength*cosd(strike);

    % load observations coordinates
    xd = x / 1000;
    yd = y /1000;

    % Put all observation coordinates into one variable
    obsCoord = [xd'; yd'];
    
    if fault_type == 1
        postSeismicInputSS = [fault_length fault_width fault_depth dip strike xfault yfault U 0 0];
        enu_disp =  Plate_over_Maxwell_Layer_over_Halfspace_Displacements(postSeismicInputSS,obsCoord(1:2,:),crustalParameters(1), crustalParameters(2), nu, crustalParameters(3), crustalParameters(4), crustalParameters(5));

    elseif fault_type == 2
        postSeismicInputDS = [fault_length fault_width fault_depth dip strike xfault yfault 0 U 0];
        enu_disp =  Plate_over_Maxwell_Layer_over_Halfspace_Displacements(postSeismicInputDS,obsCoord(1:2,:),crustalParameters(1), crustalParameters(2), nu, crustalParameters(3), crustalParameters(4), crustalParameters(5));

    end

    enu_disp =  real(enu_disp');


    ux = enu_disp(:,1);
    uy = enu_disp(:,2);
    uz = enu_disp(:,3);



end
