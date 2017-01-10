function grd = snc_roms_get_grid(ncfile,scoord)
% grd = roms_get_grid(grd_file,scoord);
%
% Gets the lon,lat,mask,depth [and z coordinates] from netcdf grd_file
% 
% Input:
%     ncfile: The roms netcdf grid file name
%           or,
%               an existing grd structure to which the vertical coordinates 
%               are to be added or updated
%
% Optional inputs:
%     scoord:   ROMS his/rst/avg file from which the s-coord params can be
%               determined
%               or 4-element vector [theta_s theta_b Tcline N]
%            
% Output is a structure containing all the grid information
%
%


varlist = {  'angle', ...
	'lon_rho', 'lat_rho', 'mask_rho', ...
	'lon_psi', 'lat_psi', 'mask_psi', ...
	'lon_u', 'lat_u', 'mask_u', ...
	'lon_v', 'lat_v', 'mask_v', ...
	'x_rho', 'y_rho', ... 
	'x_psi', 'y_psi', ...
	'x_u', 'y_u', 'x_v', 'y_v', ...
	'pm', 'pn', ...
	'theta_s', 'theta_b', 'Tcline', ...
	's_rho', 's_w', 'sc_r', 'sc_w' ...
	'h' ...
	};



%
% Try to retrieve them as variables first.
grd = [];
num_vars = length(varlist);
k = 0;
for j = 1:num_vars
	varname = varlist{j};
	try
		vardata = nc_varget ( ncfile, varname );
		grd = setfield ( grd, varname, vardata );

		%
		% introduce it into the workspace
		command = sprintf ( '%s = vardata;', varname );
		eval ( command );

	catch

		%
		% It probably did not exist.
        k = k+1;
        missing_vars{k} = varname;
		;
	end


end

%
% Now try to retrieve whatever we did NOT find via a global attribute.
% This seems to happen in ROMS AGRIF files.
att_list = missing_vars;
num_atts = length(att_list);
for j = 1:num_atts
	attname = att_list{j};
	try
		attdata = nc_attget ( ncfile, nc_global, attname );
		grd = setfield ( grd, attname, attdata );

		%
		% introduce it into the workspace
		command = sprintf ( '%s = attdata;', attname );
		eval ( command );

	catch

		%
		% It probably did not exist.
	end


end



if (isfield ( grd, 's_rho' ) & isfield ( grd, 's_w' ) )
	sc_r = grd.s_rho;
	sc_w = grd.s_w;
elseif (isfield ( grd, 'sc_r' ) & isfield ( grd, 'sc_w' ) )
    sc_r = grd.sc_r;
    sc_w = grd.sc_w;
else
    %
    % Nothing more to do.  Return.
    return
end


    
  

if nargin > 1  
  
	% warning([ 'The option of a 4-element s-coordinate parameter ' ...
	%	  'vector has not be checked fully'])
    
	theta_s = scoord(1);
	theta_b = scoord(2);
	Tcline  = scoord(3);
	N       = scoord(4);

    grid.N  = N;

else

	N = length(sc_r);
    grd.N = N;

    %
    % If we can't determine it from the file, then we are done.
    if (~isfield ( grd, 'theta_s' ) | ~isfield(grd,'theta_b') | ~isfield(grd,'Tcline') )
        return
    end
end


% code lifted from hernan's scoord3.m
c1=1.0;
c2=2.0;
p5=0.5;
Np=N+1;
ds=1.0/N;
hmin=min(min(h));
hmax=max(max(h));
hc=min(hmin,Tcline);
[Mp Lp]=size(h);    


% rho points
Nlev=N;
lev=1:N;
sc=-c1+(lev-p5).*ds;
Ptheta=sinh(theta_s.*sc)./sinh(theta_s);
Rtheta=tanh(theta_s.*(sc+p5))./(c2*tanh(p5*theta_s))-p5;
Cs=(c1-theta_b).*Ptheta+theta_b.*Rtheta;
sc_r = sc(:);
Cs_r = Cs(:);    


% w points
Nlev=Np;
lev=0:N;
sc=-c1+lev.*ds;
Ptheta=sinh(theta_s.*sc)./sinh(theta_s);
Rtheta=tanh(theta_s.*(sc+p5))./(c2*tanh(p5*theta_s))-p5;
Cs=(c1-theta_b).*Ptheta+theta_b.*Rtheta;
sc_w = sc(:);
Cs_w = Cs(:);
    



% rho-points  
h = grd.h;
scmCshc = (sc_r-Cs_r)*hc;
z_r = repmat(scmCshc,[1 length(h(:))]) + Cs_r*h(:)';
grd.z_r = reshape(z_r,[N size(h)]);
  
% w-points  
scmCshc_w = (sc_w-Cs_w)*hc;
z_w = repmat(scmCshc_w,[1 length(h(:))]) + Cs_w*h(:)';
grd.z_w = reshape(z_w,[Np size(h)]);
clear z_r z_w
  
grd.hc = hc;
grd.sc_r = sc_r;
grd.sc_w = sc_w;
grd.Cs_r = Cs_r;
