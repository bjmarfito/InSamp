%Plot sampled data location points
function [] = plot_insamp_result(matFilename)
load(matFilename)
data = [savestruct.data.data];
X = [savestruct.data.X];
Y = [savestruct.data.Y];
k =  numel(data);

figure
scatter(X,Y,24,data,'filled')
axis image; shading flat
c = colorbar;
c.Label.String = 'LOS displacement (m)';
c.Location = 'southoutside';
c.Ticks = [-0.15 -0.10 -0.05 0 0.05 0.10 0.15 0.20 0.25 0.30 0.35];
title(['No. of points = ' num2str(k)])


%Plot resampled data
%data = [savestruct.data.data];
%trix = [savestruct.data.trix];
%triy = [savestruct.data.triy];
%k =  numel(data);

%figure
%patch(trix,triy,data)
%axis image; shading flat
%c = colorbar;
%c.Label.String = 'LOS displacement (m)';
%c.Location = 'southoutside';
%c.Ticks = [-0.15 -0.10 -0.05 0 0.05 0.10 0.15 0.20 0.25 0.30 0.35];
%title(['No. of points = ' num2str(k)])

end