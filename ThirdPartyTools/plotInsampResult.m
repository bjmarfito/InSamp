%Plot sampled data location points
function [] = plotInsampResult(matFilename)
load(matFilename)
data = [savestruct.data.data];
X = [savestruct.data.X];
Y = [savestruct.data.Y];
trix = [savestruct.data.trix];
triy = [savestruct.data.triy];
k =  numel(data);

minData =min(data);
maxData =max(data);
cTicks = [minData:0.05:maxData];

figure
scatter(X,Y,24,data,'filled')
axis image; shading flat
c = colorbar;
c.Label.String = 'LOS displacement (m)';
c.Location = 'southoutside';
c.Ticks = cTicks;
title(['No. of points = ' num2str(k)])
crameri('-roma')


%Plot triangular data
figure
patch(trix,triy,data)
axis image; shading flat
c = colorbar;
c.Label.String = 'LOS displacement (m)';
c.Location = 'southoutside';
c.Ticks = cTicks;
title(['No. of points = ' num2str(k)])
crameri('-roma')

end
