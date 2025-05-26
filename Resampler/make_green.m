function [green,greenX,greenY,greenZ]=make_green(varargin)
%ss +=left-lateral
%ds +=thrust

patchstruct =  varargin{1};
datastruct = varargin{2};
greensFunc = varargin{3};
daysAfterEQ = varargin{4};

if nargin < 3
    daysAfterEQ = 0; % Default value if not provided
    greensFunc = "okada"; % Default Green's function type
end

x    = [];
y    = [];
S    = [];

numfiles = length(datastruct);
Npatch   = length(patchstruct);

for i=1:numfiles
  x    = [x; datastruct(i).X];
  y    = [y; datastruct(i).Y];
  S    = [S datastruct(i).S];
end
S=S';
np=length(x);

green=zeros(np,Npatch*2);
if (nargout>1)
  greenX=zeros(np,Npatch*2);
  greenY=zeros(np,Npatch*2);
  greenZ=zeros(np,Npatch*2);
end

%h=waitbar(0,'Calculating Green''s Functions');
for j=1:2
 for i=1:Npatch
   id     = i+(j-1)*Npatch;
   x0     = patchstruct(i).x0;
   y0     = patchstruct(i).y0;
   z0     = patchstruct(i).z0;
   L      = patchstruct(i).L;
   W      = patchstruct(i).W;
   strike = patchstruct(i).strike;
   dip    = patchstruct(i).dip;

   if greensFunc == "viscoelastic"
    [ux,uy,uz]  = calc_ps(1,x,y,.25,dip,z0,L,W,j,strike, x0,y0, daysAfterEQ);
   else
    [ux,uy,uz]  = calc_okada(1,x-x0,y-y0,.25,dip,z0,L,W,j,strike);

    end

   green(:,id) = [ux.*S(:,1)+uy.*S(:,2)+uz.*S(:,3)];
 
  if (nargout>1)
    greenX(:,id)= ux;
    greenY(:,id)= uy;
    greenZ(:,id)= uz;
  end
 % waitbar(id/Npatch/2,h);
 end
end

%close(h)
