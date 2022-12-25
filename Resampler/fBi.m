function [f1,f2,f3] = fBi(sig, eta, parvec, p, q);

% Pull out parameters form parvec
% parvec = [a, delta, fault_type]

a          = parvec(1);
delta      = parvec(2);
fault_type = parvec(3);

%

epsn  = 1.0e-15;
cosDelta  = cos(delta);
sinDelta  = sin(delta);
tand  = tan(delta);
cosDelta2 = cos(delta)^2;
sinDelta2 = sin(delta)^2;
cssnd = cos(delta)*sin(delta);

R     = sqrt(sig.^2 + eta.^2 + q.^2);
X     = sqrt(sig.^2 + q.^2);		
ytil  = eta*cosDelta + q*sinDelta;		
dtil  = eta*sinDelta - q*cosDelta;		

Rdtil = R + dtil;			
Rsig  = R + sig;			
Reta  = R + eta;			
RX    = R + X;
			
lnRdtil = log(Rdtil);		
lnReta  = log(Reta);	
lnReta0 = -log(R-eta);	
ORRsig  = 1 ./ (R .* Rsig);			
OReta   = 1 ./ Reta;			
ORReta  = 1 ./ (R .* Reta);

indfix  = find(abs(Reta) < epsn);		%check for bad values
if (~isempty(indfix))
  lnReta(indfix) = lnReta0(indfix);		
  OReta(indfix)  = 0 * indfix;
  ORReta(indfix) = 0 * indfix;
end

indfix  = find(abs(Rsig) < epsn);		
if (~isempty(indfix))
  ORsig(indfix)  = 0 * indfix;
  ORRsig(indfix) = 0 * indfix;
end

%%%%% theta term with q = 0 fix

%betatop=sig.*eta;
%betabottom=q.*R;
%nz=find(betabottom~=0);
%theta=pi/2*sign(betatop);
%theta(nz)=atan(betatop(nz)./betabottom(nz));
%theta(find(abs(q) > epsn))  = atan((sig.*eta)./(q.*R));		
indfix = find(abs(q) <= epsn);
if (~isempty(indfix))
  theta(indfix) = 0 * indfix;
  indfix = find(abs(q) > epsn);
  theta(indfix) = atan((sig(indfix).*eta(indfix))./(q(indfix).*R(indfix)));
 else
  theta = atan((sig.*eta)./(q.*R));
end

%%%%% The I_12345 factors %%%%%

if abs(cosDelta) < epsn
%%%%% cosDelta = 0 fix [eqn. (29)]
  I5 = -a   .* sig .* sinDelta ./ Rdtil;
  I4 = -a   .* q ./ Rdtil;
  I3 =  a/2 .* (eta ./ Rdtil + (ytil .* q) ./ (Rdtil.^2) - lnReta );
  I2 = -a   .* lnReta - I3;
  I1 = -a/2 .* (sig .* q) ./ (Rdtil.^2);
else
%%%%% default [eqn. (28)]
%   sigtemp(indfix) = epsn;
%  I5 = a * 2 ./ cosDelta .* atan2( (eta.*(X+q.*cosDelta) + X.*RX.*sinDelta),...
%                             (sig.*RX.*cosDelta) );
%%  indfix = find(abs(sig)<epsn);
   I5 = a * 2 ./ cosDelta .* ...
     atan( (eta.*(X+q.*cosDelta) + X.*RX.*sinDelta)./(sig.*RX.*cosDelta) ); 
  indfix = find(abs(sig)<epsn);
  if (~isempty(indfix))
   I5(indfix) = 0 * indfix;
  end
  I4 = a ./ cosDelta .* (lnRdtil - sinDelta .* lnReta);
  I3 = a * (1 ./ cosDelta .* ytil ./ Rdtil - lnReta) + tand .* I4;
  I2 = -a .* lnReta - I3;
  I1 = -a ./ cosDelta .* sig ./ Rdtil - tand .* I5;
end

%%%%% The fault specific parameters %%%%%

if fault_type == 1;  		%%%%% Strike Slip [eqn. (25)]

  f1 = (sig .* q)  .* ORReta + theta + I1 .* sinDelta;
  f2 = (ytil .* q) .* ORReta + (q .* cosDelta) .* OReta + I2 .* sinDelta;
  f3 = (dtil .* q) .* ORReta + (q .* sinDelta) .* OReta + I4 .* sinDelta;

elseif fault_type == 2;  	%%%%% Dip Slip  [eqn. (26)]

  f1 = q./R - I3 .* cssnd;
  f2 = (ytil .* q) .* ORRsig + cosDelta .* theta - I1 .* cssnd;
  f3 = (dtil .* q) .* ORRsig + sinDelta .* theta - I5 .* cssnd;

elseif fault_type == 3;		%%%%% Tensile [eqn. (27)]

  f1 = q.^2 .* ORReta - I3 .* sinDelta2;
  f2 = (-dtil .* q) .* ORRsig ...
     - sinDelta .* ((sig .* q) .* ORReta - theta) - I1 .* sinDelta2;
  f3 = (ytil .* q) .* ORRsig ...
     + cosDelta .* ((sig .* q) .* ORReta - theta) - I5 .* sinDelta2;

end
