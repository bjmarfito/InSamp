function [] = plotInsampResult(matFilename)

%% Plot sampled data location points
%% Usage plotInsampResult('InSampData.mat')

load(matFilename)
data = [savestruct.data.data];
X = [savestruct.data.X];
Y = [savestruct.data.Y];
trix = [savestruct.data.trix];
triy = [savestruct.data.triy];
covarianceMat = [savestruct.covstruct.cov];
k = numel(data);

maxData = max(abs(data));


figure(1)
scatter(X,Y,24,data,'filled')
axis image; shading flat
c = colorbar;
c.Label.String = 'LOS displacement (m)';
c.Location = 'southoutside';
% c.Ticks = cTicks;
title(['No. of points = ' num2str(k)])
colormapSlip = 'vik.mat';
    checkCrameri = exist(colormapSlip,"file");
    if checkCrameri ~=0
        load(colormapSlip)
        colormap(vik);
    else
        colormap(jet);
    end
clim([-maxData maxData]);
ax = gca;
ax.FontSize = 14;

%Plot triangular data
figure(2)
patch(trix,triy,data)
axis image; shading flat
c = colorbar;
c.Label.String = 'LOS displacement (m)';
c.Location = 'southoutside';
title(['No. of points = ' num2str(k)])

colormapSlip = 'vik.mat';
    checkCrameri = exist(colormapSlip,"file");
    if checkCrameri ~=0
        load(colormapSlip)
        colormap(vik);
    else
        colormap(jet);
    end
clim([-maxData maxData]);
ax = gca;
ax.FontSize = 14;



%Plot covariance matrix
figure(3)
imagesc(covarianceMat)
axis image; shading flat
c = colorbar;
c.Label.String = 'm^2';
c.Location = 'southoutside';
title(['No. of points = ' num2str(k)])

colormapSlip = 'lajolla.mat';
    checkCrameri = exist(colormapSlip,"file");
    if checkCrameri ~=0
        load(colormapSlip)
        colormap(lajolla);
    else
        colormap(jet);
    end

maxCovariance = max(covarianceMat(:));
clim([0 maxCovariance]);
ax = gca;
ax.FontSize = 14;


%Plot covariance matrix
figure(4)
unitCovMat = chol(covarianceMat,'lower');
imagesc(unitCovMat)
axis image; shading flat
c = colorbar;
c.Label.String = 'm^2';
c.Location = 'southoutside';
title(['No. of points = ' num2str(k)])

colormapSlip = 'lajolla.mat';
    checkCrameri = exist(colormapSlip,"file");
    if checkCrameri ~=0
        load(colormapSlip)
        colormap(lajolla);
    else
        colormap(jet);
    end

maxUnitCovMat = max(unitCovMat(:));
clim([0 maxUnitCovMat]);
ax = gca;
ax.FontSize = 14;

end