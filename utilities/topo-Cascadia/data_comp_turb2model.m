
function [] = data_comp_turb2model()

addpath(genpath('/mnt/data-RAID-1/danny/GitHub-NNMREC/topo-Cascadia'))
addpath(genpath('/mnt/data-RAID-1/danny/ainlet_Kristen/pong.tamu.edu/~kthyng/froude/matlab'))

% cd('/mnt/data-RAID-1/danny/ainlet_Kristen/pong.tamu.edu/~kthyng/froude/matlab/')
% cd('/mnt/data-RAID-1/danny/ainlet_Kristen/pong.tamu.edu/~kthyng/ai65/')
cd('/mnt/data-RAID-1/danny/ainlet_Kristen/pong.tamu.edu/~kthyng/')

%%
% data_comp_turb2model
% Want to compare high temporal resolution ADCP data, in TKE form, to model
% TKE. Have to find similar tidal cycles to compare between since the time
% series are not coincident.

font=16;
DX = 65; %grid res: 65 for ai65, 100 for ai100
% shift is whether to shift the model according to velocity deficiency.
% shift=2 is for just changing when TI is active (changes cutin speed)
% shift=2 doesn't change TI much. 
shift = 0;
% fin = 6; % number of part cycles to line up: 7 for dind=1; 2 for dind=2, 6 for dind=3
% which of the 4 turb sites to use. 1=1st Nodule Point ADV (17-21 Feb 2011)
% 4 = Nodule Point ADCP (same lat lon and therefore model output as 1 but 
% diff instrument properties) Feb 10 to 17 2011
% 2=1st Admiralty Head (10-21 Feb 2011), 3=2nd Admiralty Head (9 May-8 Jun 2011)
dind = 3; 
%Which plot type: 'hh' for hub height plot, 'profile' for pcolor profile,
% 'mprofile' for mean profiles, 'depthlinesTKE', 'depthlinesEPS'
% 'profileTKE', 'profileEPS', 'profileS', 'profileRI'
%plot, 'vort' for model results including vorticity, 'xy' for xy model plot
wplot = 'hh';  %DO SHIFT WITH PROFILE TO SEE WHICH IS BETTER
g = 9.81;

%% Figure name and number of consecutive matches
switch dind
    case 1
        name = 'nodule_point';
        fin = 7;
    case 2
        name = 'ah_feb';
        fin = 2;
    case 3
        name = 'ah_mayjun';
        fin = 6;
    case 4
        name = 'nodule_point_ADCP';
        fin = 7;
end

%% Load in Model Free Surface Output
% load matfiles/zeta_adcpzetasites.mat
% grid=roms_get_grid('OUT/ocean_his_0073.nc','OUT/ocean_his_0073.nc');
roms_out_file = '/mnt/data-RAID-1/danny/ainlet_Kristen/pong.tamu.edu/~kthyng/ai65/OUT/ocean_his_0073.nc'; % Danny: downloaded to local computer
grid=roms_get_grid(roms_out_file, roms_out_file); 
% model zeta pilot
% load matfiles/zeta_turblocs.mat
load ai65/matfiles/zeta_turblocs.mat % DCS: try this file instead
if dind == 4 % since dind=1 and dind=4 are some location
    mz = data(:,1); mtb = coords.tm(:,1);
else
    mz = data(:,dind); mtb = coords.tm(:,dind);
end
% ai100
% load ../ai100/matfiles/zeta_turblocs.mat  % DCS: this file was not found
load ai65/matfiles/zeta_turblocs.mat             
if dind == 4 % since dind=1 and dind=4 are some location
    mz1 = data(:,1); mtb1 = coords.tm(:,1);
else
    mz1 = data(:,dind); mtb1 = coords.tm(:,dind);
end
% mz = data(:,8); mtb = coords.tm(:,1); %mzpdt = (mzpt(2)-mzpt(1))/datenum([0 0 0 1 0 0]);
% mzpz = grid.z_r(:,op_find_index(grid.lat_rho(:,1),dvpy),op_find_index(grid.lon_rho(1,:),dvpx));
clear data
% Smooth and desample signal
[mz,mt] = op_smooth_signal(mz,mtb);
[mz1,mt1] = op_smooth_signal(mz1,mtb1);

%% Data Properties
switch dind
    case 1 % Nodule Point ADV
        n = .02; %error
        hh = 4.7; % 4.7 meter hub height
    case 2
        n = .224; % error
        hh = 8.1; % 8.1 meter hub height
    case 3
        n = .112; % error
        hh = 8.1; % 8.1 meter hub height
    case 4 % Nodule Point ADCP
        n = .156; % error
        hh = 4.7; % hub height
end
dx = [-(122+39.689/60) -(122+41.3/60) -(122+41.129/60)];
dy = [48+1.924/60 48+9.141/60 48+9.088/60];
if dind==4 % dind=1 and dind=4 have same location
    dx = dx(1); dy = dy(1);
else
    dx = dx(dind); dy = dy(dind);
end

%% Load in Data
% With new v data, try some new calculations horizontal components Uke and Vke:
% also, skip n for ADV since small anyway
% load ~/grid/adcp/nnmrec/turb/TTT_ADV_Feb2011processed_300s.mat % new with v
load /mnt/data-RAID-1/danny/ainlet_Kristen/pong.tamu.edu/~kthyng/froude/grid/adcp/nnmrec/turb/TTT_ADV_Feb2011processed_300s.mat % new with v, Danny: downloaded this onto local computer
% load /mnt/data-RAID-1/danny/ainlet_Kristen/pong.tamu.edu/~kthyng/TTT_ADV_Feb2011_phasedespiked.mat % new with v, Danny dowloaded a different version, hopefully is similar .. conclusions: no it does not work
Uke = .5*(nansum(ADV.Surawf*ADV.df));%-n^2); % U TKE (1 component)
%         THIS IS BASICALLY IDENTICAL TO Uke
%         uke2 = .5*(nansum(ADV.Suuf*ADV.df)-n^2); % U TKE (1 component)
Vke = .5*(nansum(ADV.Svrawf*ADV.df));%-n^2); % V TKE (1 component)
hke = Uke + Vke; % both horizontal components
addvke = nanmean(Uke+Vke)/nanmean(Uke);
        f = repmat(ADV.f,1,size(ADV.Suuf,2)); % frequency
ind = f>=.2;
Ukeiso = .5*(sum(ADV.Surawf*ADV.df.*ind)-n^2);
Vkeiso = .5*(sum(ADV.Svrawf*ADV.df.*ind)-n^2);
hkeiso = Ukeiso + Vkeiso;
%%%
% I=turbulence intensity; It= time for turbulence intensity
% load ~/grid/adcp/nnmrec/turb/Turbstats.mat %Jim's turb data
load /mnt/data-RAID-1/danny/ainlet_Kristen/pong.tamu.edu/~kthyng/Turbstats.mat %Jim's turb data, Danny re-downloaded it here
switch dind
    case 1
        h = ADCP.z;
        I = ADV.Iu;
        ud = ADV.ubar; % mean velocity
        upd = I.*ud/100; % uprime from corrected I
        % Need to use free surface data from ADCP file but is not the same
        % length. ADV times are contained within ADCP times, so we need to
        % pick these out
        ADVstart = op_find_index(ADCP.time,ADV.time(1));
        ADVend = op_find_index(ADCP.time,ADV.time(end));
        It = ADV.time';
        It = datenum([2010 12 30 23 57 30]) + It; % get onto matlab time
        z = ADCP.depth(ADVstart:ADVend)'; % same location as ADCP
        % Shear
        dz = h(2)-h(1);
        [~,dUdzfull] = gradient(ADCP.ubarprofile(:,ADVstart:ADVend),dz);
        dUdz = interp1(h,dUdzfull,hh);
        % Turbulent dissipation rate at hub height
        e = ADV.epsilon;
        efull = ADCP.epsilonprofile(:,ADVstart:ADVend);
        efull(31:36,:) = nan; %top of water column is messy
        efac = nanmean(e)/nanmean(efull(4,:)); % ADCP to ADV-size factor
        efull = efull*efac;
        e5 = interp1(h,efull,5); % at hub height divided by 2
        e8 = interp1(h,efull,8); % at hub height times by 2
        e11 = interp1(h,efull,11); % at hub height times by 2
        e14 = interp1(h,efull,14); % at hub height times by 2
        % Want to calculate K_M=-<u'w'>/dudz
        r = ADV.Reynolds;
        dudz = ADCP.dUdz(ADVstart:ADVend);
        KM = -r./dudz;
        % TKE from I (verified), 
        % Assuming that v'=0 overall, but not when just in classical
        % region, then assume u'=v'
        %k = .5*upd.^2; % k2 = .5*(sum(ADV.Suuf*ADV.df)-n^2); (equivalent) for HKE
%         uke = .5*(nansum(ADV.Suuf*ADV.df)-n^2); % u tke, 1 component
%         hke = addvke*uke; %USE V' ACTUAL DATA INSTEAD OF RATIO
        f = repmat(ADV.f,1,size(ADV.Suuf,2)); % frequency
        % hkeiso is calculated above with v'
%         ind = f>=.2;
%         hkeiso = sum(ADV.Suuf*ADV.df.*ind)-n^2; %horizontal isotropic TKE (2 components and u'=v')
%         ukeiso = sum(ADV.Suuf*ADV.df.*ind)/2; %u horizontal isotropic TKE (1)
%         ind = f<=.2;
%         hkeaniso = .5*(sum(ADV.Suuf*ADV.df.*ind)-n^2); %horizontal anisotropic TKE (2 components but v'=0)
        vke = .5*nansum(ADV.Swwf*ADV.df); %vertical TKE (1 component)
        ind = f>=.2;
        vkeiso = sum(ADV.Swwf*ADV.df.*ind)/2; %vertical TKE (1 component)
%         ind = f<=.2;
%         vkeaniso = sum(ADV.Swwf*ADV.df.*ind)/2; %vertical TKE (1 component)
        k = hke+vke; %total TKE (3 components)
        kiso = hkeiso+vkeiso; %total isotropic TKE (3 components)
        %kfull = (ADCP.Iuprofile.*ADCP.ubarprofile).^2/100^2; %this works
        %but is missing data below cutin
        %kfull2 = ADCP.uprimeprofile.^2; % this is wrong because of doppler
        %error
        % Full water column data is HKE only - 
        kfull = .5*(ADCP.uprimeprofile.^2-ADCP.n^2);
        kfull = kfull(:,ADVstart:ADVend);
        % Add minor axis horizontal component to ADCP data at NP
        kfull = kfull*addvke;
        kfull(kfull<0) = 0;
        kfull(31:36,:) = nan; %top of water column is messy
        % ADCP to ADV-size factor. Only horizontal scales since ADCP
        % and inferred calculations are only horizontal. Both measurements
        % already have Vke (v component) added in, so includes 1.64 ratio
        kfac = nanmean(hke)/nanmean(kfull(4,:)); 
        kfull = kfull*kfac;
        k5 = interp1(h,kfull,5);
        k8 = interp1(h,kfull,8);
        k11 = interp1(h,kfull,11);
        k14 = interp1(h,kfull,14);
%         % My own turb intensity calc? but don't have mean v
%         I = (sqrt(ADV.ustddev.^2+ADV.vstddev.^2))./(
%         % Isotropic TKE Calculation: for freq>.2 Hz and corrected
%         % This is divided by 2 because at small scales the two horizontal
%         % components are about equal since it is isotropic, this is for one
%         % component, then.
%         f = repmat(ADV.f,1,size(ADV.Suuf,2)); % frequency
%         ind = f>.2; % only want frequencies above 0.2 Hz
%         kiso = sum(ADV.Suuf.*ADV.df.*ind)/2;% - n^2; % 2 horizontal comps
        % Anisotropic TKE Calculation: for freq<.2 Hz and corrected
        % This is not divided by 2 because it represents both horizontal
        % components at these low frequencies, already projected onto
        % principal component
%         ind = f<=.2; % only want fk requencies above 0.2 Hz
%         kaniso = sum(ADV.Suuf.*ADV.df.*ind);% - n^2; % 2 horizontal comps
%         % Full Vertical TKE from frequency calculation (verified)
%         vke = sum(ADV.Swwf*ADV.df)/2;
%         % Isotropic VKE, only above 0.2 Hz
%         vkeiso = sum(ADV.Swwf.*ADV.df.*ind)/2;
        % Shear Production: <u'w'>*du/dz
        sp = r.*dudz;
        % more plots in this case
        nplots = 6;%7;
    case 2 %NOT FIXED FOR UPRIME VS TKE
        z = AWAC_Feb.depth'; % free surface
        % heights
        h = AWAC_Feb.z;
        Ifull = AWAC_Feb.Iuprofile;
        I = interp1(h,Ifull,hh);
        It = AWAC_Feb.time';
        It = datenum([2010 12 30 23 57 30]) + It; % get onto matlab time
        % U mean
        udfull = AWAC_Feb.ubarprofile;
        ud = interp1(h,udfull,hh); % at hub height
        udd = interp1(h,udfull,hh/2); % at hub height divided by 2
        udu = interp1(h,udfull,hh*2); % at hub height times by 2
        % Corrected velocity fluctuation
        updfull = Ifull.*udfull/100;
        upd = interp1(h,updfull,hh); % upd = AWAC_Feb.uprime; % velocity fluctuation at hub height% UNCORRECTED
        % Turbulent dissipation rate, interpolate to hub height
        efull = AWAC_Feb.epsilonprofile;
        e = interp1(h,efull,hh);k2 = sum(ADV.Suuf*ADV.df)-n^2;
        ed = interp1(h,efull,hh/2); % at hub height divided by 2
        eu = interp1(h,efull,hh*2); % at hub height times by 2
        % TKE from I
        kfull = updfull.^2;
        k = interp1(h,kfull,hh); % This is HKE
%         % Isotropic TKE Calculation: for freq>.2 Hz and corrected
%         f = repmat(AWAC_Feb.f,1,size(AWAC_Feb.Suuf,2)); % frequency
%         ind = f>.2; % only want frequencies above 0.2 Hz
%         kiso = sum(AWAC_Feb.Suuf.*AWAC_Feb.df.*ind);% - n^2; % 2 horizontal comps
%         % Anisotropic TKE Calculation: for freq<.2 Hz and corrected
%         ind = f<=.2; % only want frequencies above 0.2 Hz
%         kaniso = sum(AWAC_Feb.Suuf.*AWAC_Feb.df.*ind);% - n^2; % 2 horizontal comps
        % Full Vertical TKE from frequency calculation (verified)
        vke = sum(AWAC_Feb.Swwf*AWAC_Feb.df)/2;
        % Isotropic VKE, only above 0.2 Hz
%         vkeiso = sum(AWAC_Feb.Swwf.*AWAC_Feb.df.*ind)/2;
        nplots = 5;
    case 3
        z = AWAC_MayJun.depth'; % free surface
        % heights
        h = AWAC_MayJun.z;
        AWAC_MayJun.Iuprofile=AWAC_MayJun.Iuprofile*100;
        Ifull = AWAC_MayJun.Iuprofile;
        I = interp1(h,Ifull,hh);
        It = AWAC_MayJun.time';
        udfull = AWAC_MayJun.ubarprofile; % mean velocity
        ud = interp1(h,udfull,hh);
        ud5 = interp1(h,udfull,5); % at hub height divided by 2
        ud8 = interp1(h,udfull,8); % at hub height times by 2
        ud11 = interp1(h,udfull,11); % at hub height times by 2
        ud14 = interp1(h,udfull,14); % at hub height times by 2
        updfull = Ifull.*udfull/100;
        upd = interp1(h,updfull,hh);
        % Shear
        dz = h(2)-h(1);
        [~,dUdzfull] = gradient(udfull,dz);
        dUdz = interp1(h,dUdzfull,hh);
        % Turbulent dissipation rate, interpolate to hub height
        efull = AWAC_MayJun.epsilonprofile;
        efull(20:25,:) = nan; %get rid of top of column
        e = interp1(h,efull,hh);
        e5 = interp1(h,efull,5); % at hub height divided by 2
        e8 = interp1(h,efull,8); % at hub height times by 2
        e11 = interp1(h,efull,11); % at hub height times by 2
        e14 = interp1(h,efull,14); % at hub height times by 2
        % TKE from I These are HKE. The following two kfull calculations 
        % are nearly identical. Both are corrected for Doppler noise and
        % both have assumed that v'=0 and represent both horizontal
        % components
        % with tke from v added in using ratio from ADV at NP!
%         kfull2 = .5*updfull.^2; 
        kfull = .5*(AWAC_MayJun.uprimeprofile.^2-n^2);
        kfull = kfull*addvke;
        kfull(20:25,:) = nan; %get rid of top of column
        k = interp1(h,kfull,hh);
        k5 = interp1(h,kfull,5);
        k8 = interp1(h,kfull,8);
        k11 = interp1(h,kfull,11);
        k14 = interp1(h,kfull,14);
        hke = k; % hke for this case 
%         % Isotropic TKE Calculation: for freq>.2 Hz and corrected
%         f = repmat(AWAC_MayJun.f,1,size(AWAC_MayJun.Suuf,2)); % frequency
%         ind = f>.2; % only want frequencies above 0.2 Hz
%         kiso = sum(AWAC_MayJun.Suuf.*AWAC_MayJun.df.*ind);% - n^2; % 2 horizontal comps
%         % Anisotropic TKE Calculation: for freq<.2 Hz and corrected
%         ind = f<=.2; % only want frequencies above 0.2 Hz
%         kaniso = sum(AWAC_MayJun.Suuf.*AWAC_MayJun.df.*ind);% - n^2; % 2 horizontal comps
        % Full Vertical TKE from frequency calculation (verified)
        vke = sum(AWAC_MayJun.Swwf*AWAC_MayJun.df)/2;
%         % Isotropic VKE, only above 0.2 Hz
%         vkeiso = sum(AWAC_MayJun.Swwf.*AWAC_MayJun.df.*ind)/2;
        k = hke+vke; % full tke (new)
        nplots = 5;
    case 4 %NOT FIXED FOR UPRIME VS TKE
        z = ADCP.depth';
        % heights
        h = ADCP.z;
        Ifull = ADCP.Iuprofile;
        I = interp1(h,Ifull,hh);
        It = ADCP.time';
        It = datenum([2010 12 30 23 57 30]) + It; % get onto matlab time
        udfull = ADCP.ubarprofile; % mean velocity
        ud = interp1(h,udfull,hh);
        ud5 = interp1(h,udfull,5); % at hub height divided by 2
        ud8 = interp1(h,udfull,8); % at hub height times by 2
        ud11 = interp1(h,udfull,11); % at hub height times by 2
        ud14 = interp1(h,udfull,14); % at hub height times by 2
        updfull = Ifull.*udfull/100;
        upd = interp1(h,updfull,hh);
        % Turbulent dissipation rate, interpolate to hub height
        efull = ADCP.epsilonprofile;
        e = interp1(h,efull,hh);
        e5 = interp1(h,efull,5); % at hub height divided by 2
        e8 = interp1(h,efull,8); % at hub height times by 2
        e11 = interp1(h,efull,11); % at hub height times by 2
        e14 = interp1(h,efull,14); % at hub height times by 2
        % TKE from I (Just horizontal!)
        kfull = updfull.^2;
        k = interp1(h,kfull,hh);
        k5 = interp1(h,kfull,5);
        k8 = interp1(h,kfull,8);
        k11 = interp1(h,kfull,11);
        k14 = interp1(h,kfull,14);
        % Isotropic TKE Calculation: for freq>.2 Hz and corrected
        f = repmat(ADCP.f,1,size(ADCP.Suuf,2)); % frequency
        ind = f>.2; % only want frequencies above 0.2 Hz
        kiso = sum(ADCP.Suuf.*ADCP.df.*ind);% - n^2; % 2 horizontal comps
        % Anisotropic TKE Calculation: for freq<.2 Hz and corrected
        ind = f<=.2; % only want frequencies above 0.2 Hz
        kaniso = sum(ADCP.Suuf.*ADCP.df.*ind);% - n^2; % 2 horizontal comps
%         % Full Vertical TKE from frequency calculation (verified)
%         vke = sum(ADCP.Swwf*ADCP.df)/2;
%         % Isotropic VKE, only above 0.2 Hz
%        vkeiso = sum(ADCP.Swwf.*ADCP.df.*ind)/2;
        nplots = 5;
end
% Smooth and desample signals
[daz,dat] = op_smooth_signal(z,It);
% z = z-max(z);
% mi = 8; % 

%% Model parameters
switch wplot
    case 'hh'
    case 'profile'
        nplots = 3;
end

% tke = \sqrt(2*tke/3)./s * 100 at hub height index zind
if dind == 4 % same location so same info for model but different data
    dind = 1;
end
% zm21 = zm21 + max(max(abs(zm21))); % switch to be height from seabed to match data
% zindm21 = op_find_index(zm21,hh);
% km2 = data(:,zindm21,dind); %model tke
% velocities
% load matfiles/u_turblocs.mat
load /mnt/data-RAID-1/danny/ainlet_Kristen/pong.tamu.edu/~kthyng/froude/ai65/matfiles/u_turblocs.mat % Danny: downloaded to local workstation
% zm22 = coords.zm(1,:,dind);
% zm22 = zm22 + max(max(abs(zm22))); % switch to be height from seabed to match data
% zindm22 = op_find_index(zm22,hh);
ufull = data; uc = coords;
% u2 = squeeze(ufull(:,zindm22,dind)); % u at hub height and at location
load /mnt/data-RAID-1/danny/ainlet_Kristen/pong.tamu.edu/~kthyng/froude/ai65/matfiles/v_turblocs.mat % Danny: downloaded to local workstation
vfull = data; vc = coords;
% Hyperviscosity term
% load matfiles/dudy_turblocs.mat; dudy=data; clear data
% load matfiles/dvdy_turblocs.mat; dvdy=data; clear data
% load matfiles/dudx_turblocs.mat; dudx=data; clear data
% load matfiles/dvdx_turblocs.mat; dvdx=data; clear data
load /mnt/data-RAID-1/danny/ainlet_Kristen/pong.tamu.edu/~kthyng/froude/ai65/matfiles/dudy_turblocs.mat; dudy=data; clear data % Danny: downloaded to local workstation
load /mnt/data-RAID-1/danny/ainlet_Kristen/pong.tamu.edu/~kthyng/froude/ai65/matfiles/dvdy_turblocs.mat; dvdy=data; clear data % Danny: downloaded to local workstation
load /mnt/data-RAID-1/danny/ainlet_Kristen/pong.tamu.edu/~kthyng/froude/ai65/matfiles/dudx_turblocs.mat; dudx=data; clear data % Danny: downloaded to local workstation
load /mnt/data-RAID-1/danny/ainlet_Kristen/pong.tamu.edu/~kthyng/froude/ai65/matfiles/dvdx_turblocs.mat; dvdx=data; clear data % Danny: downloaded to local workstation
viscu = DX/4*(ufull.*dudy.*dvdy-vfull.*dudy.*dudy);
viscv = DX/4*(vfull.*dvdx.*dudx-ufull.*dvdx.*dvdx);
viscut = squeeze(nansum(viscu)); % net visc in u
viscvt = squeeze(nansum(viscv)); % net visc in v
% average positive and negative u
viscup = viscu; viscup(viscu<0)=nan; %viscup=squeeze(nanmean(viscup));
viscun = viscu; viscun(viscu>0)=nan; %viscup=squeeze(nanmean(viscup));
viscvp = viscv; viscvp(viscv<0)=nan; %viscup=squeeze(nanmean(viscup));
viscvn = viscv; viscvn(viscv>0)=nan; %viscup=squeeze(nanmean(viscup));
viscp = sqrt(nansum(cat(4,viscup.^2,viscvp.^2),4));
viscn = sqrt(nansum(cat(4,viscun.^2,viscvn.^2),4));
visc = sqrt(viscu.^2+viscv.^2);

%%% ai100 DCS: I changed ai100 to ai65 because only files I have
% numerical mixing rate
DX1=100;
DX1=65;
load ai65/matfiles/u_turblocs.mat; ufull1=data; clear data
load ai65/matfiles/v_turblocs.mat; vfull1=data; clear data
vc1=coords; tm1=coords.tm(:,1,1);
load ai65/matfiles/dudy_turblocs.mat; dudy1=data; clear data
load ai65/matfiles/dvdy_turblocs.mat; dvdy1=data; clear data
load ai65/matfiles/dudx_turblocs.mat; dudx1=data; clear data
load ai65/matfiles/dvdx_turblocs.mat; dvdx1=data; clear data
viscu1 = DX1/4*(ufull1.*dudy1.*dvdy1-vfull1.*dudy1.*dudy1);
viscv1 = DX1/4*(vfull1.*dvdx1.*dudx1-ufull1.*dvdx1.*dvdx1);
viscut = squeeze(nansum(viscu1)); % net visc in u
viscvt = squeeze(nansum(viscv1)); % net visc in v
% average positive and negative u
viscup1 = viscu1; viscup1(viscu1<0)=nan; %viscup=squeeze(nanmean(viscup));
viscun1 = viscu1; viscun1(viscu1>0)=nan; %viscup=squeeze(nanmean(viscup));
viscvp1 = viscv1; viscvp1(viscv1<0)=nan; %viscup=squeeze(nanmean(viscup));
viscvn1 = viscv1; viscvn1(viscv1>0)=nan; %viscup=squeeze(nanmean(viscup));
viscp1 = sqrt(nansum(cat(4,viscup1.^2,viscvp1.^2),4));
viscn1 = sqrt(nansum(cat(4,viscun1.^2,viscvn1.^2),4));
visc1 = sqrt(viscu1.^2+viscv1.^2);
% Vertical Eddy Viscosity
load ai65/matfiles/AKv_turblocs.mat; akvfull1 = data; akvc1 = datacoords;
% Shear
shearu1 = (ufull1(:,1:end-2,:)-ufull1(:,3:end,:))./(vc1.zm(:,1:end-2,:)-vc1.zm(:,3:end,:));
shearv1 = (vfull1(:,1:end-2,:)-vfull1(:,3:end,:))./(vc1.zm(:,1:end-2,:)-vc1.zm(:,3:end,:));
shearfull1 = sqrt(shearu1.^2+shearv1.^2);
% drdz
load ai65/matfiles/rho_turblocs.mat
rho1 = data; rc1 = datacoords;
drdzfull1 = (rho1(:,1:end-2,:)-rho1(:,3:end,:))./(rc1.zm(:,1:end-2,:)-rc1.zm(:,3:end,:));
% Buoyancy Production: -Aks*-g/rho*drdz
load ai65/matfiles/AKs_turblocs.mat
aks1 = data; aksc1 = datacoords;
bpmfull1 = -op_resize(aks1,2)*-g/1024.*drdzfull1;
%%%

% v2 = squeeze(vfull(:,zindm22,dind));
% % Signed Speed
% %     [PA, varxp_PA] = principal_axis(u,v);
% %     ssm=u*cos(90-PA)-v*sin(90-PA);
% ssm = abs(ss_svd(u,v));
% Shear
% [] = gradient(ufull,vc.zm(:,3,dind)-vc.zm(:,2,dind));
shearu = (ufull(:,1:end-2,:)-ufull(:,3:end,:))./(vc.zm(:,1:end-2,:)-vc.zm(:,3:end,:));
shearv = (vfull(:,1:end-2,:)-vfull(:,3:end,:))./(vc.zm(:,1:end-2,:)-vc.zm(:,3:end,:));
shearfull = sqrt(shearu.^2+shearv.^2);
% AKv or vertical eddy viscosity
load ai65/matfiles/AKv_turblocs.mat
akvfull = data; akvc = datacoords;
% akv2 = squeeze(akvfull(:,zindm21,dind)); 
% tke at turb locs 1-3 above
load ai65/matfiles/tke_turblocs.mat 
kmfull = data; kmc = datacoords;
tm = datacoords.tm(:,1,dind); %zm21 = coords.zm(1,:,dind);
% Dissipation Rate
load ai65/matfiles/gls_turblocs.mat
emfull = data; ec = datacoords;
% em2 = squeeze(emfull(:,zindm21,dind)); %model turbulent dissipation rate
% drdz
load ai65/matfiles/rho_turblocs.mat
rho = data; rc = datacoords;
drdzfull = (rho(:,1:end-2,:)-rho(:,3:end,:))./(rc.zm(:,1:end-2,:)-rc.zm(:,3:end,:));
% Buoyancy Production: -Aks*-g/rho*drdz
load ai65/matfiles/AKs_turblocs.mat
aks = data; aksc = datacoords;
bpmfull = -op_resize(aks,2)*-g/1024.*drdzfull;
% bpm2 = squeeze(bpmfull(:,zindm22-1,dind));
% Vorticity: dvdx-dudy
load ai65/matfiles/dvdx_turblocs.mat
dvdx = data; dvdxc = datacoords;
load ai65/matfiles/dudy_turblocs.mat
dudy = data; dudyc = datacoords;
vort = dvdx-dudy;

dt=15*60;
% advection of tke terms
load ai65/matfiles/dkdx_turblocs.mat; dkdx=data; clear data
% change kmfull to have 22 in z not 21
dkdx = [nan(size(dkdx,1),1,size(dkdx,3)) op_resize(dkdx,2) nan(size(dkdx,1),1,size(dkdx,3))];
load ai65/matfiles/dkdy_turblocs.mat; dkdy=data; clear data
dkdy = [nan(size(dkdy,1),1,size(dkdy,3)) op_resize(dkdy,2) nan(size(dkdy,1),1,size(dkdy,3))];
load ai65/matfiles/w_turblocs.mat; w=data; clear data
w = [nan(size(w,1),1,size(w,3)) op_resize(w,2) nan(size(w,1),1,size(w,3))];
load ai65/matfiles/dkdz_turblocs.mat; dkdz=data; clear data
dkdz = [nan(size(dkdz,1),1,size(dkdz,3)) op_resize(dkdz,2) nan(size(dkdz,1),1,size(dkdz,3))];
kvisc = (-ufull.*dkdx-vfull.*dkdy-w.*dkdz+visc)*dt; % full tke from hor visc.
sfull = sqrt(ufull.^2+vfull.^2); %s = op_resize(s,2);
Imviscfull = sqrt(kvisc)./sfull*100;

% change kmfull to have 22 in z not 21
kmfull = [nan(size(kmfull,1),1,size(kmfull,3)) op_resize(kmfull,2) nan(size(kmfull,1),1,size(kmfull,3))];

% upmfull = sqrt(kmfull); % full uprime
% Imfull = upmfull./sfull*100;

% Full TKE estimated from Kolmogorov assumption and epsilon and midrange vel
kmtotfull = [nan(size(kmfull,1),1,size(kmfull,3)) ...
    3/2*1/2*(2*pi/(5*60))^(-2/3).*op_resize(emfull.^(2/3),2).*sfull(:,2:end-1,:).^(2/3) nan(size(kmfull,1),1,size(kmfull,3))];
% % Attempt at fixing turb intensity
% Im2full = sqrt(kmtotfull)./sfull*100;
% Buoyancy Frequency
N2 = -g/1024.*drdzfull;
% Richardson Number
ri = N2./shearfull.^2;
ri = [nan(size(ri,1),1,size(ri,3)) ri nan(size(ri,1),1,size(ri,3))];

% Try a shift-value to see how model does when velocity is about right.
% Multiply all relevent parameters by svalue, 1+ the ratio of model to data
% speed on average Profile
if dind ~=1
if shift == 1
    svalue = nanmean(nanmean(nanmean(udfull)))/nanmean(nanmean(nanmean(sfull)));
    sfull = sfull*svalue;
    upmfull = upmfull*svalue;
    Imfull(sfull<.8)=nan;
    km3full = km3full*svalue;
    emfull = emfull*svalue;
elseif shift == 2 % this case is just to change where cut off is.
    svalue = nanmean(nanmean(nanmean(udfull)))/nanmean(nanmean(nanmean(sfull)));
    stempfull = sfull*svalue;
    Imfull(stempfull<.8) = nan;
else
%     Eliminate Im when s<.8 like in data analysis
%     Imfull(sfull<.8)=nan; % This is the straight-forward way
%     Im2full(sfull<.8)=nan; % This is the straight-forward way
    Imviscfull(sfull<.8)=nan; % This is the straight-forward way
end
end

if strcmp(wplot,'hh') || strcmp(wplot,'xy') || strcmp(wplot,'profile') ...
        || strcmp(wplot,'depthlinesTKE') || strcmp(wplot,'depthlinesEPS')
% Interpolate onto hub height and others, but the depths change each time step
km = nan(size(tm)); u = nan(size(tm)); v = nan(size(tm));
shear = nan(size(tm)); akv = nan(size(tm)); em = nan(size(tm));
bpm = nan(size(tm)); vortm = nan(size(tm)); km3 = nan(size(tm));
viscum = nan(size(tm)); viscvm = nan(size(tm));
viscm = nan(size(tm)); kviscm = nan(size(tm));
umd = nan(size(tm)); vmd = nan(size(tm));
sheard = nan(size(tm)); akvd = nan(size(tm)); emd = nan(size(tm));
bpmd = nan(size(tm)); vortd = nan(size(tm));
viscumd = nan(size(tm)); viscvmd = nan(size(tm));
umu = nan(size(tm)); vmu = nan(size(tm));
shearu = nan(size(tm)); akvu = nan(size(tm)); emu = nan(size(tm));
bpmu = nan(size(tm)); vortu = nan(size(tm));
viscumu = nan(size(tm)); viscvmu = nan(size(tm));
umuu = nan(size(tm)); vmuu = nan(size(tm));
shearuu = nan(size(tm)); akvuu = nan(size(tm)); emuu = nan(size(tm));
bpmuu = nan(size(tm)); vortuu = nan(size(tm));
viscumuu = nan(size(tm)); viscvmuu = nan(size(tm));
km5 = nan(size(tm)); km8 = nan(size(tm)); %km9 = nan(size(tm)); 
km11 = nan(size(tm)); km14 = nan(size(tm)); 
em5 = nan(size(tm)); em8 = nan(size(tm)); %em9 = nan(size(tm)); 
em11 = nan(size(tm)); em14 = nan(size(tm)); 
sm5 = nan(size(tm)); sm8 = nan(size(tm)); %sm9 = nan(size(tm)); 
sm11 = nan(size(tm)); sm14 = nan(size(tm)); 
rihh = nan(size(tm));
rhohh = nan(size(tm));
viscnm = nan(size(tm)); viscpm = nan(size(tm));
%%% ai100
viscm1 = nan(size(tm1));
viscnm1 = nan(size(tm1)); viscpm1 = nan(size(tm1));
akv1 = nan(size(tm1)); shear1 = nan(size(tm1));
bpm1 = nan(size(tm1)); u1 = nan(size(tm1)); v1 = nan(size(tm1));
rm1 = nan(size(tm1));
for i=1:length(tm1)
    ztemp = squeeze(vc1.zm(i,:,dind));
    viscnm1(i) = interp1(ztemp,viscn1(i,:,dind),min(min(ztemp))+hh);
    viscpm1(i) = interp1(ztemp,viscp1(i,:,dind),min(min(ztemp))+hh);
    viscm1(i) = interp1(ztemp,visc1(i,:,dind),min(min(ztemp))+hh);
    u1(i) = interp1(ztemp,ufull1(i,:,dind),min(min(ztemp))+hh);
    v1(i) = interp1(ztemp,vfull1(i,:,dind),min(min(ztemp))+hh);
    ztemp = squeeze(akvc1.zm(i,:,dind));
    akv1(i) = interp1(ztemp,akvfull(i,:,dind),min(min(ztemp))+hh);
    ztemp = squeeze(vc1.zm(i,2:end-1,dind));
    shear1(i) = interp1(ztemp,shearfull1(i,:,dind),min(min(ztemp))+hh);
    ztemp = squeeze(rc1.zm(i,2:end-1,dind));
    bpm1(i) = interp1(ztemp,bpmfull1(i,:,dind),min(min(ztemp))+hh);
end
s1 = sqrt(u1.^2+v1.^2);
rm1 = akv1.*shear1;
for i=1:length(tm)
    ztemp = squeeze(uc.zm(i,:,dind)); %changed size already
    km(i) = interp1(ztemp,kmfull(i,:,dind),min(min(ztemp))+hh);
    km5(i) = interp1(ztemp,kmfull(i,:,dind),min(min(ztemp))+5);
    km8(i) = interp1(ztemp,kmfull(i,:,dind),min(min(ztemp))+8);
    km11(i) = interp1(ztemp,kmfull(i,:,dind),min(min(ztemp))+11);
    km14(i) = interp1(ztemp,kmfull(i,:,dind),min(min(ztemp))+14);
    rihh(i) = interp1(ztemp,ri(i,:,dind),min(min(ztemp))+hh);
    ztemp = squeeze(uc.zm(i,:,dind));
    u(i) = interp1(ztemp,ufull(i,:,dind),min(min(ztemp))+hh);
%     umd(i) = interp1(ztemp,ufull(i,:,dind),min(min(ztemp))+hh/2);
%     umu(i) = interp1(ztemp,ufull(i,:,dind),min(min(ztemp))+hh*2);
%     umuu(i) = interp1(ztemp,ufull(i,:,dind),min(min(ztemp))+hh*6);
    ztemp = squeeze(vc.zm(i,:,dind));
    v(i) = interp1(ztemp,vfull(i,:,dind),min(min(ztemp))+hh);
    viscnm(i) = interp1(ztemp,viscn(i,:,dind),min(min(ztemp))+hh);
    viscpm(i) = interp1(ztemp,viscp(i,:,dind),min(min(ztemp))+hh);
    sm(i) = interp1(ztemp,sfull(i,:,dind),min(min(ztemp))+hh);
    sm5(i) = interp1(ztemp,sfull(i,:,dind),min(min(ztemp))+5);
    sm8(i) = interp1(ztemp,sfull(i,:,dind),min(min(ztemp))+8);
    sm11(i) = interp1(ztemp,sfull(i,:,dind),min(min(ztemp))+11);
    sm14(i) = interp1(ztemp,sfull(i,:,dind),min(min(ztemp))+14);
%     vmd(i) = interp1(ztemp,vfull(i,:,dind),min(min(ztemp))+hh/2);
%     vmu(i) = interp1(ztemp,vfull(i,:,dind),min(min(ztemp))+hh*2);
%     vmuu(i) = interp1(ztemp,vfull(i,:,dind),min(min(ztemp))+hh*6);
    viscum(i) = interp1(ztemp,viscu(i,:,dind),min(min(ztemp))+hh);
%     viscumd(i) = interp1(ztemp,viscu(i,:,dind),min(min(ztemp))+hh/2);
%     viscumu(i) = interp1(ztemp,viscu(i,:,dind),min(min(ztemp))+hh*2);
%     viscumuu(i) = interp1(ztemp,viscu(i,:,dind),min(min(ztemp))+hh*6);
    viscvm(i) = interp1(ztemp,viscv(i,:,dind),min(min(ztemp))+hh);
%     viscvmd(i) = interp1(ztemp,viscv(i,:,dind),min(min(ztemp))+hh/2);
%     viscvmu(i) = interp1(ztemp,viscv(i,:,dind),min(min(ztemp))+hh*2);
%     viscvmuu(i) = interp1(ztemp,viscv(i,:,dind),min(min(ztemp))+hh*6);
    viscm(i) = interp1(ztemp,visc(i,:,dind),min(min(ztemp))+hh);
    kviscm(i) = interp1(ztemp,kvisc(i,:,dind),min(min(ztemp))+hh);
    ztemp = squeeze(vc.zm(i,2:end-1,dind));
    shear(i) = interp1(ztemp,shearfull(i,:,dind),min(min(ztemp))+hh);
%     sheard(i) = interp1(ztemp,shearfull(i,:,dind),min(min(ztemp))+hh/2);
%     shearu(i) = interp1(ztemp,shearfull(i,:,dind),min(min(ztemp))+hh*2);
%     shearuu(i) = interp1(ztemp,shearfull(i,:,dind),min(min(ztemp))+hh*6);
    ztemp = squeeze(akvc.zm(i,:,dind));
    akv(i) = interp1(ztemp,akvfull(i,:,dind),min(min(ztemp))+hh);
%     akvd(i) = interp1(ztemp,akvfull(i,:,dind),min(min(ztemp))+hh/2);
%     akvu(i) = interp1(ztemp,akvfull(i,:,dind),min(min(ztemp))+hh*2);
%     akvuu(i) = interp1(ztemp,akvfull(i,:,dind),min(min(ztemp))+hh*6);
    ztemp = squeeze(ec.zm(i,:,dind));
    em(i) = interp1(ztemp,emfull(i,:,dind),min(min(ztemp))+hh);
    em5(i) = interp1(ztemp,emfull(i,:,dind),min(min(ztemp))+5);
    em8(i) = interp1(ztemp,emfull(i,:,dind),min(min(ztemp))+8);
    em11(i) = interp1(ztemp,emfull(i,:,dind),min(min(ztemp))+11);
    em14(i) = interp1(ztemp,emfull(i,:,dind),min(min(ztemp))+14);
    ztemp = squeeze(rc.zm(i,2:end-1,dind));
    bpm(i) = interp1(ztemp,bpmfull(i,:,dind),min(min(ztemp))+hh);
    ztemp = squeeze(rc.zm(i,:,dind));
    rhohh(i) = interp1(ztemp,rho(i,:,dind),min(min(ztemp))+hh);
%     bpmd(i) = interp1(ztemp,bpmfull(i,:,dind),min(min(ztemp))+hh/2);
%     bpmu(i) = interp1(ztemp,bpmfull(i,:,dind),min(min(ztemp))+hh*2);
%     bpmuu(i) = interp1(ztemp,bpmfull(i,:,dind),min(min(ztemp))+hh*6);
    ztemp = squeeze(dvdxc.zm(i,:,dind));
    vortm(i) = interp1(ztemp,vort(i,:,dind),min(min(ztemp))+hh);
%     vortd(i) = interp1(ztemp,vort(i,:,dind),min(min(ztemp))+hh/2);
%     vortu(i) = interp1(ztemp,vort(i,:,dind),min(min(ztemp))+hh*2);
%     vortuu(i) = interp1(ztemp,vort(i,:,dind),min(min(ztemp))+hh*6);
end
% upm= sqrt(km); %vel fluctuation uprime for model from full tke, for hor components
% k=1/2*(u'^2+v'^2+w'^2)=1/2*(3u'^2)=3/2u'^2 -> 2u'=2\sqrt(2/3*k)
% upm = 2*sqrt(2/3*km); % two components of 3 component model tke
% Turb intensity is not matching up correctly with data. Maybe because of
% extra factor of 2 in upm above?
upm = sqrt(2/3*km); % 1 components of 3 component model tke
% Calculate Reynolds from AKv and shear: <u'w'>=-AKv*dudz (for both dir)
rm = akv.*shear;
rmd = akvd.*sheard;
rmu = akvu.*shearu;
rmuu = akvuu.*shearuu;
% Shear Production: reynolds*du/dz or Akv*(dudz^2+dvdz^2)
spm = -rm.*shear;
spmdd = -rmd.*sheard;
spmu = -rmu.*shearu;
spmuu = -rmuu.*shearuu;
% smd = sqrt(umd.^2+vmd.^2); %s = op_resize(s,2);
% smu = sqrt(umu.^2+vmu.^2); %s = op_resize(s,2);
% smuu = sqrt(umuu.^2+vmuu.^2); %s = op_resize(s,2);
s = sqrt(u.^2+v.^2); %s = op_resize(s,2);
% Im = upm./s*100; %model turbulence intensity from horizontal tke
% Full TKE estimated from Kolmogorov assumption and epsilon and midrange vel
win = 128; %5*60;
alph = .5;%.69;%.5;
% kmtot is for 2 horizontal components
kmtot = addvke*3/2*alph*(2*pi/win)^(-2/3).*em.^(2/3).*s.^(2/3);
kmtot5 = addvke*3/2*alph*(2*pi/win)^(-2/3).*em5.^(2/3).*sm5.^(2/3);
kmtot8 = addvke*3/2*alph*(2*pi/win)^(-2/3).*em8.^(2/3).*sm8.^(2/3);
kmtot11 = addvke*3/2*alph*(2*pi/win)^(-2/3).*em11.^(2/3).*sm11.^(2/3);
kmtot14 = addvke*3/2*alph*(2*pi/win)^(-2/3).*em14.^(2/3).*sm14.^(2/3);
% % Attempt at fixing turb intensity
% Im2 = sqrt(2)*sqrt(kmtot)./s*100; % 2 components
% total k for visc
kvisctot = km+kviscm;
% total TI for visc
Imvisc = sqrt(kvisctot)./s*100;
%%% ai100
% Calculate Reynolds from AKv and shear: <u'w'>=-AKv*dudz (for both dir)
rm1 = akv1.*shear1;
% Shear Production: reynolds*du/dz or Akv*(dudz^2+dvdz^2)
spm1 = -rm1.*shear1;
% inferred Im
% k=1/2*(u'^2+v'^2)=1/2*(2u'^2)=u'^2 -> 2u'=2\sqrt(k)
upmtot = sqrt(kmtot); % two components of 2 component inferred model tke
Imtot = upmtot./s*100; % 1 comp
% Imtot = sqrt(2)*upmtot./s*100; % 2 comps

% Try a shift-value to see how model does when velocity is about right.
% Multiply all relevent parameters by svalue, 1+ the ratio of model to data
% speed on average HUB HEIGHT
if shift == 1
    svalue = nanmean(ud)/nanmean(s);
    s = s*svalue;
    upm = upm*svalue;
    Im = upm./s*100; %model turbulence intensity from full tke*3
    Im(s<.8)=nan;
    km3 = km3*svalue;
    rm = rm*svalue;
elseif shift == 2 % this case is just to change where cut off is.
    Im = upm./s*100; %model turbulence intensity from full tke*3
    svalue = nanmean(ud)/nanmean(s);
    stemp = s*svalue;
    Im(stemp<.8) = nan;
else
    Im = upm./s*100; % for 1 hor component
%     Im = sqrt(2)*upm./s*100; % sqrt(2) for 2 hor components
%     Eliminate Im when s<.8 like in data analysis
    Im(s<.8)=nan; % This is the straight-forward way
%     Im2(s<.8)=nan;
    Imvisc(s<.8)=nan;
end
end

Imt = tm;
% Im2 = griddata(tm,zm,Im,tm(:,1),zm(:,end)-hh);
% Imt = (tm(:,1)-tm(1,1))/datenum([0 0 0 1 0 0]); % in hours since start of comp
% gls is epsilon the turbulent dissipation

% % %% Plot Velocity Signals as Examples
% % figure
% % plot(time,v1(:,1),'k',time,umean(:,1),'r',time,ufluc(:,1),'g')
% % legend('Full Signal','Mean Signal','Velocity Fluctuations')
% 

% %% Plot averages, if desired
% comp_turbtime(dind,emfull,ec,efull,h) % doesn't work right for dind=4
% return

%% Find matches between data and model zeta signals
% dzpi = data zeta pilot indices, mzpi = model zeta pilot indices
[dind2,mind] = data_compbyzeta(daz,dat,mz,mt);
[dind21,mind1] = data_compbyzeta(daz,dat,mz1,mt1); %ai100

% %% Plot sample zeta signal match ups
% figure
% set(gcf,'position',[20   281   969   384])
% subplot(1,2,1)
% vec=dind(3,:);
% plot(dat,daz-mean(daz),dat(vec),daz(vec)-mean(daz),'r.')
% subplot(1,2,2)
% [~,~,vec] = find(squeeze(mind(3,:,:)));
% plot(mt,mz,mt(vec),mz(vec),'r.')

%%% TEMPORARY FOR NO TURB INTENSITY
nplots = nplots-1;
%%%%

% FOR AI100
% ki=1; iplot = 1;
% %% Plot TKE Match ups
% %% Loop through data indices and see where matches are to plot
% for i = 1:size(dind21,1)-fin
%     for j = 1:size(mind1,2)-fin
%         % Use stricter plot condition in this script: Only plot if there is
%         % a nonzero index for this dzpi index AND there is one for the next
%         % part of a tidal cycle which immediately follows this one. In
%         % other words, we want matching full tidal cycles, not just part of
%         % a tidal cycle.
%         out = data_compbyzeta_ncycles(mind1,fin,i,j);
%         if out
%             switch wplot
%                 case 'hh'
%                     iplot=1;
%         figure
%         set(gcf,'position',[1          27        1024         638])%20   145   989   520])
%         %% Plot zeta signals
%         subaxis(nplots,1,iplot,'mb',.075,'ml',.12,'mt',.05,'sv',.06)
%         vecc=dind21(i,1):dind21(i+fin,2);
%         vecb = mind1(i,j,1):mind1(i+fin,j+fin,2);
%         dat2=dat(vecc);
%         dat2=(dat2-dat2(1))/datenum([0 0 0 1 0 0]); % in hours since start of comp
%         mt2=mt1(vecb);
%         mt2=(mt2-mt2(1))/datenum([0 0 0 1 0 0]); % in hours since start of comp
%         plot(dat2,daz(vecc)-mean(daz(vecc)),'k',mt2,mz1(vecb)-mean(mz1(vecb)),'r','linewidth',3)%,dat(vec),daz(vec),'k','linewidth',2)
%         set(gca,'fontsize',font,'fontweight','bold')
%         axis tight
%         ylabel(sprintf('Free\nSurface (m)'))
%         title('Properties at Hub Height')
%         set(gca,'xtick',[])
%         vecd = op_find_index(It,dat(dind21(i,1))):op_find_index(It,dat(dind21(i+fin,2)));
%         vecm = op_find_index(Imt,mt1(mind1(i,j,1))):op_find_index(Imt,mt1(mind1(i+fin,j+fin,2)));
%         Imt2 = Imt(vecm);
%         Imt2 = (Imt2-Imt2(1))/datenum([0 0 0 1 0 0]); % in hours since start of comp
%         % contourf(It(vec),z,I(vec)'), shading flat%, caxis([0 .4])
%         Itt = It(vecd);
%         Itt = (Itt-Itt(1))/datenum([0 0 0 1 0 0]); % in hours since start of comp
%         iplot =iplot+1;
%         %% Plot Velocity
%         subaxis(nplots,1,iplot) % plot ubar
%         plot(Itt,ud(vecd),'k',Imt2,s1(vecm),'r','linewidth',3)
%         axis tight
%         set(gca,'fontsize',font,'fontweight','bold')
%         ylabel('Speed (m/s)')%, xlabel('Hours into comparison')
%         set(gca,'xtick',[])
%         iplot = iplot+1;
%         if dind == 1
%             set(gca,'xtick',[])
%             %% Reynolds Stress
%             subaxis(nplots,1,iplot)
%             Itemp = r(vecd);
%             [Itemps,Itempst] = op_smooth_signal(Itemp,Itt,10);        
%             plot(Itt,abs(Itemp),'k',Imt2,abs(rm1(vecm)),'r','linewidth',3)%, axis tight
%             set(gca,'fontsize',font,'fontweight','bold')
%             ylabel(sprintf('Reynolds\nStress (m^2/s^2)')), xlabel('Hours into comparison')
%         end
%         if dind==1
%             fname = ['figures/comp_turb2model/' name num2str(ki) '_hhai100'];
%         else
%             fname = ['figures/comp_turb2model/' name num2str(ki) '_hhai100'];
%         end
% %         ki=ki+1;
% %         fname=['figures/comp_turb2model/' sprintf('corr_data%icycles%imodel%i',fin,dind2(i,1),mind(i,j,1))];
%         op_save(fname)
% %         close(gcf)
% 
% %         % Do separate plots for just TKE and dissipation rate with extra
% %         % lines
% %         figure
% %         set(gcf,'position',[6         314        1014         351])%20   145   989   520])
% %         set(gca,'position',[0.0730    0.1396    0.9102    0.7854])
% %         set(gca,'fontsize',font,'fontweight','bold')
% %         if dind == 1
% %             semilogy(Itt,kiso(vecd),'b',Imt2,km(vecm),'r',Imt2,kmtot(vecm),'g',...
% %                 Itt,k(vecd),'k','linewidth',3)%, axis tight
% %         ylim([min(min(abs(k(vecd)))) max(max(k(vecd)))])
% %         else
% %             semilogy(Imt2,km(vecm),'r',Imt2,kmtot(vecm),'g',...
% %                 Itt,k(vecd),'k','linewidth',3)%, axis tight
% %         end
% % %         axis tight
% %         ylabel(sprintf('Turbulent Kinetic Energy (m^2/s^2)')), xlabel('Hours into comparison')
% %         legend('Isotropic','Model','Kolmogorov','Data','location','best')
% %         fname = ['figures/comp_turb2model/' name num2str(ki) '_hhTKE'];
% %         op_save(fname)
% %         figure
% %         set(gcf,'position',[6         314        1014         351])%20   145   989   520])
% %         set(gca,'position',[0.0730    0.1396    0.9102    0.7854])
% %         set(gca,'fontsize',font,'fontweight','bold')
% %         semilogy(Itt,e(vecd),'k',Imt2,em(vecm),'r',Imt2,viscnm(vecm),'g',...
% %             Imt2,viscpm(vecm),'b','linewidth',3)
% % %         axis tight
% %         if dind == 1
% %             ylim([min(min(e(vecd))) max(max(e(vecd)))])
% %         end
% %         ylabel(sprintf('Turbulent Dissipation Rate (m^2/s^3)')), xlabel('Hours into comparison')
% %         legend('Data','Model','Negative Num. Mixing Rate','Positive Num. Mixing Rate','location','best')
% %         fname = ['figures/comp_turb2model/' name num2str(ki) '_hh'];
% %         op_save(fname)
%             end
%         end
%     end
% end
% %%% end ai100

ki=1; iplot = 1;
%% Plot TKE Match ups
%% Loop through data indices and see where matches are to plot
for i = 1:size(dind2,1)-fin
    for j = 1:size(mind,2)-fin
        % Use stricter plot condition in this script: Only plot if there is
        % a nonzero index for this dzpi index AND there is one for the next
        % part of a tidal cycle which immediately follows this one. In
        % other words, we want matching full tidal cycles, not just part of
        % a tidal cycle.
        out = data_compbyzeta_ncycles(mind,fin,i,j);
        [i j]
        if out
            disp('out')
        else
            disp('not out')
        end
        
        if out
            disp('out')
            switch wplot
                case 'maxprofiles'
                    % Do top maxes for comparison periods and for each: speed, tke, gls, ri
                    figure
                    set(gcf,'position',[ 6         188        1014         477])
        vecd = op_find_index(It,dat(dind2(i,1))):op_find_index(It,dat(dind2(i+fin,2)));
        vecm = op_find_index(Imt,mt(mind(i,j,1))):op_find_index(Imt,mt(mind(i+fin,j+fin,2)));
        zm = abs(vc.zm(vecm,:,dind));
        zm = max(max(zm(:,2:end)))-zm;
        zm = nanmean(zm,1);
                    % Find max indices
                    [udmax,idmax]=findpeaks(ud(vecd),'minpeakdistance',30,'npeaks',3);
                    [smax,immax]=findpeaks(s(vecm),'minpeakdistance',10,'npeaks',3);
                    % plot
                    lines = {'-^';'-s';'-.'};
                    subplot(1,4,1) % Speed
                    hold on
                    for ii=1:length(idmax)
                    plot(udfull(:,vecd(idmax(ii))),h,['k' lines{ii}],...
                        sfull(vecm(immax(ii)),:,dind),zm,['r' lines{ii}],...
                        'linewidth',3)
                    end
                    subplot(1,4,2) % Dissipation
                    for ii=1:length(idmax)
                    semilogx(efull(:,vecd(idmax(ii))),h,['k' lines{ii}],...
                        emfull(vecm(immax(ii)),:,dind),op_resize(zm,2),['r' lines{ii}],...
                        'linewidth',3)
                    hold on
                    end
                    subplot(1,4,3) % TKE
                    for ii=1:length(idmax)
                    plot(kfull(:,vecd(idmax(ii))),h,['k' lines{ii}],...
                        kmfull(vecm(immax(ii)),:,dind),zm,['r' lines{ii}],...
                        kmtotfull(vecm(immax(ii)),:,dind),zm,['g' lines{ii}],...
                        'linewidth',3)
                    hold on
                    end
                    subplot(1,4,4) % Ri
                    for ii=1:length(idmax)
                    plot(ri(vecm(immax(ii)),:,dind),zm,['r' lines{ii}],...
                        'linewidth',3)
                    hold on
                    end
                    xlim([0 15])
                case 'xy' % Make model xy plots for these comp times
        vecm = op_find_index(Imt,mt(mind(i,j,1))):op_find_index(Imt,mt(mind(i+fin,j+fin,2)));
                    data_turb_xyplots(vecm,dx,dy,hh,Imt(vecm),s(vecm),km(vecm),vortm(vecm),rhohh(vecm),name,ki)
%                     ki = ki+1;
                case 'hh'
                    iplot=1;
        figure
        set(gcf,'position',[1          27        1024         638])%20   145   989   520])
        %% Plot zeta signals
        subaxis(nplots,1,iplot,'mb',.075,'ml',.12,'mt',.05,'sv',.06)
        vecc=dind2(i,1):dind2(i+fin,2);
%         vecc=dind2(i,1)-50:dind2(i+fin,2)+50;
%         vec=dind2(i,1):dind2(i+fin,2);
        vecb = mind(i,j,1):mind(i+fin,j+fin,2);
        
        disp(['start time index = ' num2str(vecb(1))])
        disp(['end   time index = ' num2str(vecb(end))])
        
        dat2=dat(vecc);
        dat2=(dat2-dat2(1))/datenum([0 0 0 1 0 0]); % in hours since start of comp
        mt2=mt(vecb);
        mt2=(mt2-mt2(1))/datenum([0 0 0 1 0 0]); % in hours since start of comp
        plot(dat2,daz(vecc)-mean(daz(vecc)),'k',mt2,mz(vecb)-mean(mz(vecb)),'r','linewidth',3)%,dat(vec),daz(vec),'k','linewidth',2)
%         plot(dat2,daz(vecc),'k','linewidth',2)%,dat(vec),daz(vec),'k','linewidth',2)
        set(gca,'fontsize',font,'fontweight','bold')
%         datetick('x',13,'keeplimits','keepticks')%2,'keeplimits')
        axis tight
        ylabel(sprintf('Free\nSurface (m)'))
        title('Properties at Hub Height')
%         legend('Data','Model','location','best')
        set(gca,'xticklabel',[])
        vecd = op_find_index(It,dat(dind2(i,1))):op_find_index(It,dat(dind2(i+fin,2)));
        vecm = op_find_index(Imt,mt(mind(i,j,1))):op_find_index(Imt,mt(mind(i+fin,j+fin,2)));
        Imt2 = Imt(vecm);
        Imt2 = (Imt2-Imt2(1))/datenum([0 0 0 1 0 0]); % in hours since start of comp
        % contourf(It(vec),z,I(vec)'), shading flat%, caxis([0 .4])
        Itt = It(vecd);
        Itt = (Itt-Itt(1))/datenum([0 0 0 1 0 0]); % in hours since start of comp
        iplot =iplot+1;
        %% Plot Velocity
        %sz = .05; % z shift
        subaxis(nplots,1,iplot) % plot ubar
        plot(Itt,ud(vecd),'k',Imt2,s(vecm),'r','linewidth',3)
%         if dind == 2 || dind == 3
%             hold on
%             plot(Itt,udd(vecd),'k:',Imt2,smd(vecm),'r:',...
%                 Itt,udu(vecd),'k--',Imt2,smu(vecm),'r--','linewidth',2)
%             %legend('
%         end
%         plot(Itt,ud(vecd),'k',Imt2,s(vecm),'r',Imt2,ssm(vecm),'g','linewidth',2)
        axis tight
        set(gca,'fontsize',font,'fontweight','bold')
        ylabel('Speed (m/s)')%, xlabel('Hours into comparison')
        set(gca,'xticklabel',[])
        iplot = iplot+1;
%         %% Plot turb intensity
%         subaxis(nplots,1,iplot) 
%         Itemp = I(vecd); % TI
%         [Itemps,Itempst] = op_smooth_signal(Itemp,Itt,10);        
% %         plot(Itt,Itemp,'k',Imt2,Im(vecm),'r',Imt2,Im2(vecm),'g',Imt2,Imvisc(vecm),'b',...
%         plot(Itt,Itemp,'k',Imt2,Im(vecm),'r',Imt2,Im2(vecm),'g',...
%             'linewidth',2,'handlevisibility','off'), axis tight
%         set(gca,'fontsize',font,'fontweight','bold')
%         ylabel(sprintf('Turbulence\nIntensity (%%)'))
%         set(gca,'xtick',[])
%         iplot=iplot+1;
        %% Plot TKE
        subaxis(nplots,1,iplot) 
%         Itemp = k(vecd); %TKE
        if dind == 1
            plot(Imt2,km(vecm),'r',... % no correction
                Itt,k(vecd),'k','linewidth',3), axis tight
%             plot(Itt,kiso(vecd),'b',Imt2,km(vecm),'r',Imt2,kmtot(vecm),'g',...
%                 Itt,hke(vecd),'k','linewidth',3), axis tight
%                 Itt,k(vecd),'k','linewidth',3), axis tight
        else
            plot(Imt2,km(vecm),'r',...
                Itt,k(vecd),'k','linewidth',3), axis tight
%             plot(Imt2,km(vecm),'r',Imt2,kmtot(vecm),'g',...
%                 Itt,k(vecd),'k','linewidth',3), axis tight
        end
        set(gca,'fontsize',font,'fontweight','bold')
%         ylim([min(min(abs(k(vecd))))/10 max(max(k(vecd)))*10])
%         set(gca,'ytick',logspace(min(min(abs(k(vecd))))/10,10*max(max(k(vecd))),3))
        ylabel(sprintf('TKE (m^2/s^2)'))
        set(gca,'xticklabel',[])
        if dind == 1
%             legend('Classical','Model','Inferred','Data','location','best')
            legend('Model','Data','location','best') % no correction
        else
            legend('Model','Data','location','best') % no correction
%             legend('Model','Inferred','Data','location','best')
        end 
        iplot=iplot+1;
%         %% Plot vertical tke
%         % Divide model TKE by 3 for VKE
%         subaxis(nplots,1,iplot) 
%         Itemp = vke(vecd); % VKE
%         [Itemps,Itempst] = op_smooth_signal(Itemp,Itt,10);        
%         plot(Itt,Itemp,'k',Imt2,km(vecm)/3,'r',...
%             Itt,kiso(vecd),'g','linewidth',2,'handlevisibility','off'), axis tight
% %             'linewidth',2,'handlevisibility','off'), axis tight
%         set(gca,'fontsize',font,'fontweight','bold')
%         ylabel(sprintf('VKE (m^2/s^2)'))
%         set(gca,'xtick',[])
%         iplot=iplot+1;
        %% Dissipation Rate
        subaxis(nplots,1,iplot)
        plot(Itt,e(vecd),'k',Imt2,em(vecm),'r','linewidth',3)
        axis tight
        set(gca,'fontsize',font,'fontweight','bold')
%         ylim([min(min(e(vecd))) max(max(e(vecd)))])
        ylabel(sprintf('Turbulent\nDissipation\nRate (m^2/s^3)'))%, xlabel('Hours into comparison')
        iplot=iplot+1;
        if dind == 1
            set(gca,'xticklabel',[])
%             %% Shear Production
%             subaxis(nplots,1,5)
%             Itemp = sp(vecd);
%             [Itemps,Itempst] = op_smooth_signal(Itemp,Itt,10);        
%     %         plot(Itt,Itemp/max(Itemp),'k',Itempst,Itemps/max(Itemps),'k--',Imt2,Im(vecm)/max(Im(vecm)),'r','linewidth',2), axis tight
% %             plot(Itt,Itemp,'k',Itempst,Itemps,'k--',Imt2,em(vecm),'r','linewidth',2), axis tight
%             plot(Itt,Itemp,'k',Imt2,spm(vecm),'r','linewidth',2), axis tight
%             set(gca,'fontsize',font,'fontweight','bold')
%             ylabel(sprintf('Shear\nProduction\n(m^2/s^3)'))%, xlabel('Hours into comparison')
%         set(gca,'xtick',[])
            %% Reynolds Stress
            subaxis(nplots,1,iplot)
            Itemp = r(vecd);
            [Itemps,Itempst] = op_smooth_signal(Itemp,Itt,10);        
    %         plot(Itt,Itemp/max(Itemp),'k',Itempst,Itemps/max(Itemps),'k--',Imt2,Im(vecm)/max(Im(vecm)),'r','linewidth',2), axis tight
%             plot(Itt,abs(Itemp),'k',Itempst,abs(Itemps),'k--',Imt2,abs(rm(vecm)),'r','linewidth',2), axis tight
            plot(Itt,abs(Itemp),'k',Imt2,abs(rm(vecm)),'r','linewidth',3)%, axis tight
            set(gca,'fontsize',font,'fontweight','bold')
            ylabel(sprintf('Reynolds\nStress (m^2/s^2)')), xlabel('Hours into comparison')
        else
            xlabel('Hours into comparison')
        end
        if dind==1
            fname = ['figures/comp_turb2model/' name num2str(ki) '_hhold']; % no correction
%             fname = ['figures/comp_turb2model/' name num2str(ki) '_hhinf'];
        else
            fname = ['figures/comp_turb2model/' name num2str(ki) '_hhold']; % no correction
%             fname = ['figures/comp_turb2model/' name num2str(ki) '_hhinf'];
        end
%         ki=ki+1;
%         fname=['figures/comp_turb2model/' sprintf('corr_data%icycles%imodel%i',fin,dind2(i,1),mind(i,j,1))];
        op_save(fname)
%         close(gcf)

        % Turbulent intensity
        figure
        Imtemp = Im(vecm); Imtemp(sm(vecm)<.8)=nan;
        Imtemp2 = Imtot(vecm); Imtemp2(sm(vecm)<.8)=nan;
        Itemp = I(vecd); Itemp(ud(vecd)<.8) = nan;
        set(gcf,'position',[6         397        1014         268])%20   145   989   520])
        set(gca,'position',[0.1055    0.2015    0.8777    0.7235])
        plot(Itt',Itemp,'k',Imt2,Imtemp,'r',Imt2,Imtemp2,'g','linewidth',3)
%         if dind == 1
%             plot(Itt,kiso(vecd),'b',Imt2,km(vecm),'r',Imt2,kmtot(vecm),'g',...
%                 Itt,k(vecd),'k','linewidth',3)%, axis tight
% %         ylim([min(min(abs(k(vecd)))) max(max(k(vecd)))])
%         else
%             plot(Imt2,km(vecm),'r',Imt2,kmtot(vecm),'g',...
%                 Itt,k(vecd),'k','linewidth',3)%, axis tight
%         end
%         axis tight
        set(gca,'fontsize',font,'fontweight','bold')
        axis tight
        ylabel('Turbulence Intensity %'), xlabel('Hours into comparison')
        %legend('Classical','Model','Inferred','Data','location','best')
        fname = ['figures/comp_turb2model/' name num2str(ki) '_hhI'];
        op_save(fname)
        % Do separate plots for just TKE and dissipation rate with extra
        % lines
        figure
        set(gcf,'position',[6         397        1014         268])%20   145   989   520])
        set(gca,'position',[0.1055    0.2015    0.8777    0.7235])
        if dind == 1
            % first two 3D second two 2D horizontal only
            plot(Itt,kiso(vecd),'b',Imt2,km(vecm),'r',...
                Itt,hke(vecd),'k',Imt2,kmtot(vecm),'g','linewidth',3)%, axis tight
        set(gca,'fontsize',font,'fontweight','bold')
        legend('Classical','Model','Data','Inferred','location','best')
%         ylim([min(min(abs(k(vecd)))) max(max(k(vecd)))])
        else
            % all horizontal only
            plot(Itt,hke(vecd),'k',Imt2,2/3*km(vecm),'r',Imt2,kmtot(vecm),'g',...
                'linewidth',3)%, axis tight
        set(gca,'fontsize',font,'fontweight','bold')
        legend('Data','Model','Inferred','location','best')
        end
%         axis tight
        axis tight
        ylabel(sprintf('Turbulent Kinetic\nEnergy (m^2/s^2)')), xlabel('Hours into comparison')
        fname = ['figures/comp_turb2model/' name num2str(ki) '_hhTKE'];
        op_save(fname)
% Model I vs. Data I
figure
set(gcf,'position',[38    45   730   620])
snew = interp1(Imt2,s(vecm),Itt);
Imnew = interp1(Imt2,Im(vecm),Itt);
Imtotnew = interp1(Imt2,Imtot(vecm),Itt);
Ivecd = I(vecd);
Ivecd(ud(vecd)<.8)=nan;
Imnew(snew<.8) = nan;
% I is too high with inferred TKE
plot(...
    Ivecd,Imnew,'k.',Ivecd,Imtotnew,'g.',...
    [0 20],[0 20],'k--','linewidth',2,'markersize',20)
%     k(vecd),interp1(Imt2,kmtot(vecm),Itt),'m.',...
%     k(vecd),interp1(Imt2,kvisctot(vecm),Itt),'k.',...
axis([0 20 0 20])
set(gca,'fontsize',18,'fontweight','bold')
legend('Model','Inferred Model')%,...
%     'Data TKE v. New Model TKE','location','best')
ylabel('Model Turbulence Intensity (%)')
xlabel('Data Turbulence Intensity (%)')
title([name],'interpreter','none')
fname = ['figures/comp_turb2model/' name num2str(ki) '_I'];
op_save(fname)
%         figure
%         set(gcf,'position',[6         397        1014         268])%20   145   989   520])
%         set(gca,'position',[0.0917    0.2015    0.8915    0.6530])
%         plot(Itt,e(vecd),'k',Imt2,em(vecm),'r',Imt2,viscnm(vecm),'g',...
%             Imt2,viscpm(vecm),'b','linewidth',3)
%         axis tight
%         set(gca,'fontsize',font,'fontweight','bold')
% %         axis tight
% %         if dind == 1
% %             ylim([min(min(e(vecd))) max(max(e(vecd)))])
% %         end
%         ylabel(sprintf('Turbulent Dissipation\nRate (m^2/s^3)')), xlabel('Hours into comparison')
%         legend('Data','Model','Negative Num. Dissipation','Positive Num. Dissipation','location','best')
%         fname = ['figures/comp_turb2model/' name num2str(ki) '_hhDISS'];
%         op_save(fname)
%%
                case 'mprofile'
                    figure
                    set(gcf,'position',[ 6         188        1014         477])
        vecd = op_find_index(It,dat(dind2(i,1))):op_find_index(It,dat(dind2(i+fin,2)));
        vecm = op_find_index(Imt,mt(mind(i,j,1))):op_find_index(Imt,mt(mind(i+fin,j+fin,2)));
        zm = abs(vc.zm(vecm,:,dind));
        zm = max(max(zm(:,2:end)))-zm;
        zm = nanmean(zm,1);
        indd = udfull<.8; % data: eliminate things below cut-in speed
        indm22 = sfull<.8; % model: eliminate things below cut-in speed
        indm21 = op_resize(sfull,2)<.8; % model: eliminate things below cut-in speed
                    %% Mean profiles
                    % Speed
                    nplots=4;
        subaxis(1,nplots,1,'sh',.04,'mb',.12,'ml',.06,'mr',.03)
%                 udfull(indd)=nan;
%         sfull(indm22)=nan;
        [z,c] = op_interp_depth(vc.zm(vecm,:,dind),squeeze(sfull(vecm,:,dind))); %interp to fixed depths
            plot(nanmean(udfull(:,vecd),2),h,'k',...
                        nanmean(c,1),op_depth2height(z),'r','linewidth',2)
                    ylim([0 max(h)])
                    set(gca,'fontweight','bold','fontsize',14)
        ylabel('Height Above Seabed (m)')
        xlabel('Speed')
                    % Dissipation
                    subaxis(1,nplots,2)
%         efull(indd)=nan;
%         emfull(indm21)=nan;
        [z,c] = op_interp_depth(vc.zm(vecm,:,dind),squeeze(emfull(vecm,:,dind))); %interp to fixed depths
        semilogx(nanmean(efull(:,vecd),2),h,'k',...
            nanmean(c,1),op_depth2height(z),'r','linewidth',2)
        ylim([0 max(h)])
        set(gca,'fontweight','bold','fontsize',14)
        xlabel('Dissipation Rate (m^2/s^3)')
                    % Full TKE
                    subaxis(1,nplots,3)
%         kfull(indd)=nan;
%         kmfull(indm21)=nan; kmtotfull(indm21)=nan; kvisc(indm22)=nan;
        [z,c] = op_interp_depth(vc.zm(vecm,:,dind),squeeze(kmtotfull(vecm,:,dind))); %interp to fixed depths
        [z2,c] = op_interp_depth(vc.zm(vecm,:,dind),squeeze(kmfull(vecm,:,dind))); %interp to fixed depths
        plot(nanmean(kfull(:,vecd),2),h,'k',nanmean(z,1),z,'g',...
            nanmean(z2,1),op_depth2height(z),'r','linewidth',2)
        ylim([0 max(h)])
        xlim([0 max(max(nanmean(kfull(:,vecd),2)))])
        set(gca,'fontweight','bold','fontsize',14)
        xlabel('Full TKE (m^2/s^2)')
        legend('Data','Inferred','Model')%,'location','best')
%                     % Turbulence Intensity
%                     subaxis(1,nplots,4)
%         Ifull(indd)=nan;
%         Imfull(indm22)=nan; Im2full(indm22)=nan; Imviscfull(indm22)=nan;
%                     plot(nanmean(Ifull(:,vecd),2),h,'k',nanmean(Im2full(vecm,:,dind),1),zm,'g',...
%                         nanmean(Imfull(vecm,:,dind),1),zm,'r','linewidth',2)
%                     ylim([0 max(h)])
%                     xlim([0 max(max(nanmean(Ifull(:,vecd),2)))])
%                     set(gca,'fontweight','bold','fontsize',14)
%                 xlabel('Turbulence Intensity (%)')
                    % Richardson Number
                    subaxis(1,nplots,4)
%         ri(indm22)=nan;
        [z,c] = op_interp_depth(vc.zm(vecm,:,dind),squeeze(ri(vecm,:,dind))); %interp to fixed depths
        plot(nanmean(c,1),op_depth2height(z),'r','linewidth',2)
        ylim([0 max(h)])
        %xlim([0 max(max(nanmean(ri(vecm,:,dind),2)))])
        set(gca,'fontweight','bold','fontsize',14)
                xlabel('Richardson Number')
fname = ['figures/comp_turb2model/' name num2str(ki) '_mprofile'];
        op_save(fname)
%         ki=ki+1;
        %%
                case 'depthlinesTKE' %TKE horizontal only!
        vecd = op_find_index(It,dat(dind2(i,1))):op_find_index(It,dat(dind2(i+fin,2)));
        vecm = op_find_index(Imt,mt(mind(i,j,1))):op_find_index(Imt,mt(mind(i+fin,j+fin,2)));
        Imt2 = Imt(vecm);
        Imt2 = (Imt2-Imt2(1))/datenum([0 0 0 1 0 0]); % in hours since start of comp
        % contourf(It(vec),z,I(vec)'), shading flat%, caxis([0 .4])
        Itt = It(vecd);
        Itt = (Itt-Itt(1))/datenum([0 0 0 1 0 0]); % in hours since start of comp
        zm = abs(vc.zm(vecm,:,dind));
        zm = max(max(zm(:,2:end)))-zm;
        zm = nanmean(zm,1);
%         indd = udfull<.8; % data: eliminate things below cut-in speed
%         indm22 = sfull<.8; % model: eliminate things below cut-in speed
%         indm21 = op_resize(sfull,2)<.8; % model: eliminate things below cut-in speed
        figure
        set(gcf,'position',[171         173        1282         774])
        nplots=4;
        subaxis(nplots,6,1,1,5,1,'mb',.08,'ml',.06,'sh',.03,'sv',.02,'mt',.05)
        plot(Itt,k14(:,vecd),'k',Imt2,2/3*km14(vecm),'r',Imt2,kmtot14(vecm),'g','linewidth',3)
        set(gca,'fontweight','bold','fontsize',16)
        set(gca,'xticklabel',[])
         title('TKE in Time at Various Depths')
       axis tight
        subaxis(nplots,6,1,2,5,1)
        plot(Itt,k11(:,vecd),'k',Imt2,2/3*km11(vecm),'r',Imt2,kmtot11(vecm),'g','linewidth',3)
        set(gca,'fontweight','bold','fontsize',16)
        set(gca,'xticklabel',[])
        axis tight
         subaxis(nplots,6,1,3,5,1)
        plot(Itt,k8(:,vecd),'k',Imt2,2/3*km8(vecm),'r',Imt2,kmtot8(vecm),'g','linewidth',3)
        set(gca,'fontweight','bold','fontsize',16)
        set(gca,'xticklabel',[])
        axis tight
         subaxis(nplots,6,1,4,5,1)
        plot(Itt,k5(:,vecd),'k',Imt2,2/3*km5(vecm),'r',Imt2,kmtot5(vecm),'g','linewidth',3)
        set(gca,'fontweight','bold','fontsize',16)
        xlabel('Hours into Comparison')
        legend('Data','Model','Inferred','location','best')
        axis tight
        % Mean profile
%         kfull(indd)=nan;
%         kmfull(indm21)=nan; kmtotfull(indm21)=nan; %kvisc(indm22)=nan;
        subaxis(nplots,6,6,1,1,nplots)
        [z,c] = op_interp_depth(vc.zm(vecm,:,dind),squeeze(kmtotfull(vecm,:,dind))); %interp to fixed depths
        [z2,c2] = op_interp_depth(vc.zm(vecm,:,dind),squeeze(2/3*kmfull(vecm,:,dind))); %interp to fixed depths
        plot(nanmean(kfull(:,vecd),2),h,'k',nanmean(c2,1),op_depth2height(z),'r',...
            nanmean(c,1),op_depth2height(z),'g','linewidth',3)
%         axis tight
        hold on
        d = xlim;
        plot(d,5*ones(size(d)),'b--',d,8*ones(size(d)),'b--',...
            d,11*ones(size(d)),'b--',d,14*ones(size(d)),'b--','linewidth',2)
        set(gca,'fontweight','bold','fontsize',16)
        ylim([0 max(h)])
        xlim([0 max(max(nanmean(kfull(:,vecd),2)))])
        xlabel(sprintf('Mean'))
        fname=['figures/comp_turb2model/' name num2str(ki) '_depthlinesHTKE'];
        op_save(fname)
        %%
        case 'depthlinesEPS' %dissipation
        vecd = op_find_index(It,dat(dind2(i,1))):op_find_index(It,dat(dind2(i+fin,2)));
        vecm = op_find_index(Imt,mt(mind(i,j,1))):op_find_index(Imt,mt(mind(i+fin,j+fin,2)));
        Imt2 = Imt(vecm);
        Imt2 = (Imt2-Imt2(1))/datenum([0 0 0 1 0 0]); % in hours since start of comp
        % contourf(It(vec),z,I(vec)'), shading flat%, caxis([0 .4])
        Itt = It(vecd);
        Itt = (Itt-Itt(1))/datenum([0 0 0 1 0 0]); % in hours since start of comp
        zm = abs(vc.zm(vecm,:,dind));
        zm = max(max(zm(:,2:end)))-zm;
        zm = nanmean(zm,1);
%         indd = udfull<.8; % data: eliminate things below cut-in speed
%         indm22 = sfull<.8; % model: eliminate things below cut-in speed
%         indm21 = op_resize(sfull,2)<.8; % model: eliminate things below cut-in speed
        figure
        set(gcf,'position',[171         173        1282         774])
        nplots=4;
        subaxis(nplots,6,1,1,5,1,'mb',.1,'ml',.06,'sh',.03,'sv',.065,'mt',.05)
        plot(Itt,e14(:,vecd),'k',Imt2,em14(vecm),'r','linewidth',3)
        set(gca,'fontweight','bold','fontsize',16)
        set(gca,'xticklabel',[])
         title('Dissipation Rate in Time at Various Depths')
       axis tight
        subaxis(nplots,6,1,2,5,1)
        plot(Itt,e11(:,vecd),'k',Imt2,em11(vecm),'r','linewidth',3)
        set(gca,'fontweight','bold','fontsize',16)
        set(gca,'xticklabel',[])
        axis tight
         subaxis(nplots,6,1,3,5,1)
        plot(Itt,e8(:,vecd),'k',Imt2,em8(vecm),'r','linewidth',3)
        set(gca,'fontweight','bold','fontsize',16)
        set(gca,'xticklabel',[])
        axis tight
        subaxis(nplots,6,1,4,5,1)
        plot(Itt,e5(:,vecd),'k',Imt2,em5(vecm),'r','linewidth',3)
        set(gca,'fontweight','bold','fontsize',16)
        xlabel('Hours into Comparison')
        legend('Data','Model','location','best')
        axis tight
        % Mean profile
%         efull(indd)=nan;
%         emfull(indm21)=nan; 
        subaxis(nplots,6,6,1,1,nplots)
        [z,c] = op_interp_depth(coords.zm(vecm,:,dind),squeeze(emfull(vecm,:,dind))); %interp to fixed depths
        % Top of water column messy in model
        c(:,86:end)=nan;
        plot(nanmean(efull(:,vecd),2),h,'k',...
            nanmean(c,1),op_depth2height(z),'r','linewidth',3)
        hold on
        d = xlim;
        plot(d,5*ones(size(d)),'b--',d,8*ones(size(d)),'b--',...
            d,11*ones(size(d)),'b--',...
            d,14*ones(size(d)),'b--','linewidth',2)
        set(gca,'fontweight','bold','fontsize',16)
        ylim([0 max(h)])
        xlim([0 max(max(nanmean(efull(:,vecd),2)))])
        xlabel(sprintf('Mean'))
        fname=['figures/comp_turb2model/' name num2str(ki) '_depthlinesEPS'];
        op_save(fname)
        %%
                case 'profileTKE'
        nplots=3;
        vecc=dind2(i,1):dind2(i+fin,2);
        vecb = mind(i,j,1):mind(i+fin,j+fin,2);
        dat2=dat(vecc);
        dat2=(dat2-dat2(1))/datenum([0 0 0 1 0 0]); % in hours since start of comp
        mt2=mt(vecb);
        mt2=(mt2-mt2(1))/datenum([0 0 0 1 0 0]); % in hours since start of comp
        vecd = op_find_index(It,dat(dind2(i,1))):op_find_index(It,dat(dind2(i+fin,2)));
        vecm = op_find_index(Imt,mt(mind(i,j,1))):op_find_index(Imt,mt(mind(i+fin,j+fin,2)));
        Imt2 = Imt(vecm);
        Imt2 = (Imt2-Imt2(1))/datenum([0 0 0 1 0 0]); % in hours since start of comp
        Itt = It(vecd);
        Itt = (Itt-Itt(1))/datenum([0 0 0 1 0 0]); % in hours since start of comp
        %% Profile snapshots
        zm = abs(vc.zm(vecm,:,dind));
        zm = nanmean(max(max(zm(:,2:end)))-zm);
        num = 6; 
        % Find max indices
        [udmax,idmax]=findpeaks(ud(vecd),'minpeakdistance',32,'npeaks',6);
        [smax,immax]=findpeaks(s(vecm),'minpeakdistance',10,'npeaks',6);
%         switch dind
%             case 1
%                 inds = [17 40 85 110 140 185]; %dind=1
%             case 3
%                 inds = [17 45 88 110 145 170];
%         end
        figure
        set(gcf,'position',[1          27        1024         638])
        % zeta
        subaxis(2,num,1,1,num,1,'mb',.1,'sv',.07,'sh',.025,'ml',.09,'mt',.06)
        plot(Itt,k(vecd),'k',Imt2,km(vecm),'r',Imt2,kmtot(vecm),'g','linewidth',3)
        axis tight
        set(gca,'fontsize',16,'fontweight','bold')
        title('TKE Profiles as Points in Time')
        ylabel('TKE at Hub Height (m^2/s^2)')
        xlabel('Hours into Comparison')
        legend('Data','Model','Inferred Model','location','best')
%         plot(dat2,daz(vecc)-mean(daz(vecc)),'k',mt2,mz(vecb)-mean(mz(vecb)),'r','linewidth',2)
        hold on
        for ii = 1:length(idmax)
%             ind = op_find_index(Itt,Imt2(inds(ii))); % in terms of Itt/kfull
            subaxis(2,num,1,1,num,1)
            plot([Itt(idmax(ii)) Itt(idmax(ii))],[0 max(k(vecd))],'k--',...
                [Imt2(immax(ii)) Imt2(immax(ii))],[0 max(k(vecd))],'r--', 'linewidth',2)
            subaxis(2,num,ii,2)
            switch dind
                case 1
            semilogx(k(vecd(idmax(ii))),hh,'ko',kmfull(vecm(immax(ii)),:,dind),zm,'r',...
                kmtotfull(vecm(immax(ii)),:,dind),zm,'g','linewidth',2) %dind=1
%             axis tight
%             xlim([0 2*k(vecd(idmax(ii)))])
                case {2,3,4}
            semilogx(kfull(:,vecd(idmax(ii))),h,'k',kmfull(vecm(immax(ii)),:,dind),zm,'r',...
                kmtotfull(vecm(immax(ii)),:,dind),zm,'g','linewidth',4)
            end
            set(gca,'fontsize',16,'fontweight','bold')
        if ii~=1
            set(gca,'yticklabel',[])
        end
        if ii==1
            ylabel('Height Above Seabed (m)')
        end
        
        ylim([0 max(h)])
%        xlim([0 max(max(kfull(:,vecd(idmax(ii)))))])
        end
        fname = ['figures/comp_turb2model/' name num2str(ki) '_profileTKE'];
        op_save(fname)
                case 'profileEPS'
        nplots=3;
        vecc=dind2(i,1):dind2(i+fin,2);
        vecb = mind(i,j,1):mind(i+fin,j+fin,2);
        dat2=dat(vecc);
        dat2=(dat2-dat2(1))/datenum([0 0 0 1 0 0]); % in hours since start of comp
        mt2=mt(vecb);
        mt2=(mt2-mt2(1))/datenum([0 0 0 1 0 0]); % in hours since start of comp
        vecd = op_find_index(It,dat(dind2(i,1))):op_find_index(It,dat(dind2(i+fin,2)));
        vecm = op_find_index(Imt,mt(mind(i,j,1))):op_find_index(Imt,mt(mind(i+fin,j+fin,2)));
        Imt2 = Imt(vecm);
        Imt2 = (Imt2-Imt2(1))/datenum([0 0 0 1 0 0]); % in hours since start of comp
        Itt = It(vecd);
        Itt = (Itt-Itt(1))/datenum([0 0 0 1 0 0]); % in hours since start of comp
        %% Profile snapshots
        zm = abs(vc.zm(vecm,:,dind));
        zm = nanmean(max(max(zm(:,2:end)))-zm);
        num = 6; 
        % Find max indices
        [udmax,idmax]=findpeaks(ud(vecd),'minpeakdistance',32,'npeaks',6);
        [smax,immax]=findpeaks(s(vecm),'minpeakdistance',10,'npeaks',6);
        figure
        set(gcf,'position',[1          27        1024         638])
        % zeta
        subaxis(2,num,1,1,num,1,'mb',.1,'sv',.07,'sh',.035,'ml',.07,'mt',.06)
        plot(Itt,e(vecd),'k',Imt2,em(vecm),'r','linewidth',3)
        set(gca,'fontsize',16,'fontweight','bold')
        title('Diss. Profiles as Points in Time')
        ylabel('Diss. at Hub Height (m^2/s^3)')
        xlabel('Hours into Comparison')
        legend('Data','Model','location','best')
        hold on
        for ii = 1:length(idmax)
            subaxis(2,num,1,1,num,1)
            dmax = max( max(e(vecd)),max(em(vecm)));
            plot([Itt(idmax(ii)) Itt(idmax(ii))],[0 dmax],'k--',...
                [Imt2(immax(ii)) Imt2(immax(ii))],[0 dmax],'r--', 'linewidth',2)
            axis tight
            subaxis(2,num,ii,2)
            axis tight
            switch dind
                case 1
            semilogx(e(vecd(idmax(ii))),hh,'ko',emfull(vecm(immax(ii)),:,dind),op_resize(zm,2),'r',...
                'linewidth',2) %dind=1
            %set(gca,'xtick',logspace(min(min(emfull(vecm(immax(ii)),:,dind))),max(max(emfull(vecm(immax(ii)),:,dind))),4))
            %xlim([0 2*e(vecd(idmax(ii)))])
                case {2,3,4}
            semilogx(efull(:,vecd(idmax(ii))),h,'k',emfull(vecm(immax(ii)),:,dind),op_resize(zm,2),'r',...
                'linewidth',4)
            end
            set(gca,'fontsize',16,'fontweight','bold')
        if ii~=1
            set(gca,'yticklabel',[])
        end
        if ii==1
            ylabel('Height Above Seabed (m)')
        end
        %ylim([0 max(h)])
        %xlim([0 max(max(efull(:,vecd(idmax(ii)))))])
        end
        fname = ['figures/comp_turb2model/' name num2str(ki) '_profileEPS'];
        op_save(fname)
                case 'profileS'
        nplots=3;
        vecc=dind2(i,1):dind2(i+fin,2);
        vecb = mind(i,j,1):mind(i+fin,j+fin,2);
        dat2=dat(vecc);
        dat2=(dat2-dat2(1))/datenum([0 0 0 1 0 0]); % in hours since start of comp
        mt2=mt(vecb);
        mt2=(mt2-mt2(1))/datenum([0 0 0 1 0 0]); % in hours since start of comp
        vecd = op_find_index(It,dat(dind2(i,1))):op_find_index(It,dat(dind2(i+fin,2)));
        vecm = op_find_index(Imt,mt(mind(i,j,1))):op_find_index(Imt,mt(mind(i+fin,j+fin,2)));
        Imt2 = Imt(vecm);
        Imt2 = (Imt2-Imt2(1))/datenum([0 0 0 1 0 0]); % in hours since start of comp
        Itt = It(vecd);
        Itt = (Itt-Itt(1))/datenum([0 0 0 1 0 0]); % in hours since start of comp
        %% Profile snapshots
        zm = abs(vc.zm(vecm,:,dind));
        zm = nanmean(max(max(zm(:,2:end)))-zm);
        num = 6; 
        % Find max indices
        [udmax,idmax]=findpeaks(ud(vecd),'minpeakdistance',32,'npeaks',6);
        [smax,immax]=findpeaks(s(vecm),'minpeakdistance',10,'npeaks',6);
        figure
        set(gcf,'position',[1          27        1024         638])
        % zeta
        subaxis(2,num,1,1,num,1,'mb',.1,'sv',.07,'sh',.025,'ml',.07,'mt',.06)
        plot(Itt,ud(vecd),'k',Imt2,s(vecm),'r','linewidth',3)
        set(gca,'fontsize',16,'fontweight','bold')
        title('Speed Profiles as Points in Time')
        ylabel('Speed at Hub Height (m/s)')
        xlabel('Hours into Comparison')
        legend('Data','Model','location','best')
        hold on
        for ii = 1:length(idmax)
            subaxis(2,num,1,1,num,1)
            plot([Itt(idmax(ii)) Itt(idmax(ii))],[0 max(ud(vecd))],'k--',...
                [Imt2(immax(ii)) Imt2(immax(ii))],[0 max(s(vecm))],'r--', 'linewidth',2)
            subaxis(2,num,ii,2)
            switch dind
                case 1
            plot(ud(vecd(idmax(ii))),hh,'ko',sfull(vecm(immax(ii)),:,dind),zm,'r',...
                'linewidth',2) %dind=1
                case {2,3,4}
            plot(udfull(:,vecd(idmax(ii))),h,'k',sfull(vecm(immax(ii)),:,dind),zm,'r',...
                'linewidth',4)
            end
            set(gca,'fontsize',16,'fontweight','bold')
        if ii~=1
            set(gca,'yticklabel',[])
        end
        if ii==1
            ylabel('Height Above Seabed (m)')
        end
        %ylim([0 max(h)])
        %xlim([min(min(udfull(:,vecd(idmax(ii))))) max(max(udfull(:,vecd(idmax(ii)))))])
        axis tight
        end
        fname = ['figures/comp_turb2model/' name num2str(ki) '_profileS'];
        op_save(fname)
                case 'profileRI'
        nplots=3;
        vecc=dind2(i,1):dind2(i+fin,2);
        vecb = mind(i,j,1):mind(i+fin,j+fin,2);
        dat2=dat(vecc);
        dat2=(dat2-dat2(1))/datenum([0 0 0 1 0 0]); % in hours since start of comp
        mt2=mt(vecb);
        mt2=(mt2-mt2(1))/datenum([0 0 0 1 0 0]); % in hours since start of comp
        vecd = op_find_index(It,dat(dind2(i,1))):op_find_index(It,dat(dind2(i+fin,2)));
        vecm = op_find_index(Imt,mt(mind(i,j,1))):op_find_index(Imt,mt(mind(i+fin,j+fin,2)));
        Imt2 = Imt(vecm);
        Imt2 = (Imt2-Imt2(1))/datenum([0 0 0 1 0 0]); % in hours since start of comp
        Itt = It(vecd);
        Itt = (Itt-Itt(1))/datenum([0 0 0 1 0 0]); % in hours since start of comp
        %% Profile snapshots
        zm = abs(vc.zm(vecm,:,dind));
        zm = nanmean(max(max(zm(:,2:end)))-zm);
        num = 6; 
        % Find max indices
        [udmax,idmax]=findpeaks(ud(vecd),'minpeakdistance',32,'npeaks',6);
        [smax,immax]=findpeaks(s(vecm),'minpeakdistance',10,'npeaks',6);
        figure
        set(gcf,'position',[1          27        1024         638])
        subaxis(2,num,1,1,num,1,'mb',.1,'sv',.18,'sh',.025,'ml',.07,'mt',.06,'mr',.07)
        [ax2,h1,h2]=plotyy(Imt2,rihh(vecm),Imt2,em(vecm),'semilogy','plot');
        set(ax2(1),'fontsize',16,'fontweight','bold')
        set(ax2(2),'fontsize',16,'fontweight','bold')
        title('Ri-Related Profiles as Points in Time')
        ylabel(ax2(1),'Ri at Hub Height (m/s)'), ylabel(ax2(2),'\epsilon at Hub Height (m/s)')
        xlabel('Hours into Comparison')
        hold on
        plot([Imt2(immax) Imt2(immax)],[min(rihh(vecm)) max(rihh(vecm))],'r')
        for ii = 1:length(idmax)
            subaxis(2,num,ii,2)
            [ax,h1,h2]=plotxx(N2(vecm(immax(ii)),:,dind),zm(2:end-1),...
                shearfull(vecm(immax(ii)),:,dind).^2,zm(2:end-1));%,...
            set(ax(1),'fontsize',16,'fontweight','bold')
            set(ax(2),'fontsize',16,'fontweight','bold')
            xlabel(ax(1),'N^2'), xlabel(ax(2),'Shear^2')
        if ii~=1
            set(ax(1),'yticklabel',[])
            set(ax(2),'yticklabel',[])
        end
        if ii==1
            ylabel(ax(1),'Height Above Seabed (m)')
            set(ax(2),'yticklabel',[])
        end
        set(findobj('Type','line'),'linewidth',3)
        end
        fname = ['figures/comp_turb2model/' name num2str(ki) '_profileRI'];
        op_save(fname)
%         %% Mean Comp
%         figure
%         subaxis(1,2,1)
%         % for dind=1
%         plot(nanmean(k(vecd)),hh,'ko',nanmean(kmfull(:,:,dind),1),zm,'r',...
%             nanmean(kmtotfull(:,:,dind),1),zm,'g')
%         %% Plot TKE
% %         cmax = max(max(max(udfull(:,vecd))),max(max(sfull(vecm,:,dind))));
%         subaxis(nplots,2,1,2,2,1,'sh',.04,'mr',.01) % plot ubar
% %         plot(kfull(:,vecd(30)),h,'k','linewidth',2)
%         imagesc(Itt,h,kfull(:,vecd)), colorbar, axis xy
% %         caxis([0 cmax])
%         hold on
%         plot(Itt(35)+kfull(:,vecd(35)),h,'k','linewidth',4)
%         set(gca,'fontsize',font,'fontweight','bold')
%         ylabel('Speed (m/s)')%, xlabel('Hours into comparison')
%         set(gca,'xtick',[])
%         freezeColors, cbfreeze
%         subaxis(nplots,2,1,3,2,1)
%         zm = abs(vc.zm(vecm,:,dind));
%         zm = nanmean(max(max(zm(:,2:end)))-zm);
%         pcolorjw(Imt2,zm,kmfull(vecm,:,dind)'), colorbar, axis xy
%         ylim([0 max(h)])
% %         caxis([0 cmax])
%         set(gca,'fontsize',font,'fontweight','bold')
%         set(gca,'xtick',[])
%         freezeColors, cbfreeze
%         %% Plot Velocity
% %         cmax = max(max(max(udfull(:,vecd))),max(max(sfull(vecm,:,dind))));
%         subaxis(nplots,2,1,2,2,1,'sh',.04,'mr',.01) % plot ubar
%         imagesc(Itt,h,udfull(:,vecd)), colorbar, axis xy
% %         caxis([0 cmax])
%         hold on
%         plot(Itt(35)+udfull(:,vecd(35)),h,'k','linewidth',4)
%         set(gca,'fontsize',font,'fontweight','bold')
%         ylabel('Speed (m/s)')%, xlabel('Hours into comparison')
%         set(gca,'xtick',[])
%         freezeColors, cbfreeze
%         subaxis(nplots,2,2,2,1,1)
%         zm = abs(vc.zm(vecm,:,dind));
%         zm = max(max(zm(:,2:end)))-zm;
%         contourf(vc.tm(vecm,:,dind),zm,sfull(vecm,:,dind)), colorbar
%         ylim([0 max(h)])
% %         caxis([0 cmax])
%         set(gca,'fontsize',font,'fontweight','bold')
%         set(gca,'xtick',[])
%         freezeColors, cbfreeze
%         %% Dissipation Rate
% %         cmax = max(max(max(efull(:,vecd))),max(max(emfull(vecm,:,dind))));
%         subaxis(nplots,2,1,3,1,1) % plot ubar
%         T = real2rgb(log(efull(:,vecd)),'jet');
%         surf(It(vecd),h,efull(:,vecd),T)
%         view(2), shading interp, axis tight
%         set(gca,'zscale','log','clim',[min(min(efull(:,vecd))) max(max(efull(:,vecd)))])
%         colormap jet
%         hh=colorbar;
%         set(hh,'yscale','log')
%         ylim([0 max(h)])
% %         contourf(It(vecd),h,efull(:,vecd)), colorbar
% %         caxis([0 cmax])
%         set(gca,'fontsize',font,'fontweight','bold')
%         ylabel(sprintf('Turbulent\nDissipation\nRate (m^2/s^3)')), xlabel('Hours into comparison')
% %         freezeColors, cbfreeze%%% CHANGE ALL TO SURF TO PCOLOR?
%         subaxis(nplots,2,2,3,1,1)
%         zm = abs(ec.zm(vecm,:,dind));
%         zm = max(max(zm(:,2:end)))-zm;
%         % Trying to get a log scale to work out
%         T = real2rgb(log(emfull(vecm,:,dind)),'jet');
%         surf(ec.tm(vecm,:,dind),zm,emfull(vecm,:,dind),T)
%         view(2), shading interp, axis tight
%         set(gca,'zscale','log','clim',[min(min(emfull(vecm,:,dind))) max(max(emfull(vecm,:,dind)))])
%         colormap jet
%         hh=colorbar;
%         set(hh,'yscale','log')
%         ylim([0 max(h)])
% %         caxis([0 max(max(emfull(vecm,:,dind)))])
% %         caxis([0 cmax])
%         set(gca,'fontsize',font,'fontweight','bold')
%         xlabel('Hours into comparison')
%         fname = ['figures/comp_turb2model/' name num2str(ki) '_profile'];
%         fname=['figures/comp_turb2model/' sprintf('corr_data%icycles%imodel%i',fin,dind2(i,1),mind(i,j,1))];
        %op_save(fname)
%         close(gcf)
            end
        ki=ki+1;
        end
    end
end
% if strcmp(wplot,'hh')
% % Recreate Jim's Figure 10: Model and Data (when available) Shear production vs. Dissipation
% figure
% set(gcf,'position',[203   207   565   458])
% if dind == 1
%     loglog(abs(e),abs(sp),'k.',abs(em),abs(spm),'r.',[1e-9 1e-3],[1e-9 1e-3],'k--')
% else
%     loglog(abs(emu),abs(spmu),'b.',abs(emd),abs(spmdd),'g.',abs(emuu),abs(spmuu),'m.',...
%         abs(em),abs(spm),'r.',[1e-9 1e-3],[1e-9 1e-3],'k--')    
% end
% axis([1e-9 1e-3 1e-9 1e-3])
% set(gca,'fontsize',font,'fontweight','bold')
% if dind == 1
%     legend('Data','Model','location','best')
% else
%     legend('Hub Height * 2','Hub Height * 1/2','Hub Height * 6','Hub Height','location','best')
% end
% xlabel('Dissipation Rate \epsilon (m^2/s^3)')
% ylabel('Shear Production <u''w''>dU/dz (m^2/s^3)')
% title([name ' , Model Output'],'interpreter','none')
% fname = ['figures/comp_turb2model/' name '_shearproductionvdissipation'];
% op_save(fname)
% % Model VKE vs. Reynolds (with data when available)
% figure
% set(gcf,'position',[203   207   565   458])
% % cutoff model vke below cutin speed of .8 m/s
% % ind = s<.8;
% % km(ind) = nan;
% if dind == 1
%     loglog(abs(vke),abs(r),'k.',abs(km),abs(rm),'r.',[1e-7 1e-2],[1e-7 1e-2],'k--')
% else
%     loglog(abs(kmu),abs(rmu),'b.',abs(kmd),abs(rmd),'g.',abs(kmuu),abs(rmuu),'m.',...
%         abs(km),abs(rm),'r.',[1e-7 1e-2],[1e-7 1e-2],'k--')
%     legend('Hub Height * 2','Hub Height * 1/2','Hub Height * 6','Hub Height','location','best')
% end
% % axis([1e-4 1e-2 1e-4 1e-2])%, axis square
% set(gca,'fontsize',font,'fontweight','bold')
% if dind ==1
%     legend('Data','Model','location','best')
% end
% xlabel('Vertical TKE (m^2/s^2)')
% ylabel('Reynolds Stress <u''w''> (m^2/s^2)')
% title([name ' , Model Output'],'interpreter','none')
% fname = ['figures/comp_turb2model/' name '_vkevreynolds'];
% op_save(fname)
% % Model Shear production vs. Buoyancy Production
% figure
% set(gcf,'position',[203   207   565   458])
% loglog(abs(bpmu),abs(spmu),'b.',abs(bpmd),abs(spmdd),'g.',...%abs(bpmuu),abs(spmuu),'m.',...
%     abs(bpm),abs(spm),'r.',[1e-9 1e-3],[1e-9 1e-3],'k--')
% axis([1e-9 1e-3 1e-9 1e-3])
% set(gca,'fontsize',font,'fontweight','bold')
% legend('Hub Height * 2','Hub Height * 1/2','Hub Height','location','best')
% xlabel('Buoyancy Production (m^2/s^3)')
% ylabel('Shear Production <u''w''>dU/dz (m^2/s^3)')
% title([name ' , Model Output'],'interpreter','none')
% fname = ['figures/comp_turb2model/' name '_shearproductionvbproduction'];
% op_save(fname)
% % % Model and some data turbulence properties vs. speed
% % figure
% % set(gcf,'position',[1          27        1024         638])%20   145   989   520])
% % subplot(2,2,1), semilogy(s,km,'r.',abs(ud),vke,'k.')
% % set(gca,'fontsize',font,'fontweight','bold')
% % ylabel('vke (m^2/s^2)'), legend('Model','Data','location','best')
% % subplot(2,2,2), semilogy(s,abs(em),'r.',abs(ud),abs(e),'k.')
% % set(gca,'fontsize',font,'fontweight','bold')
% % ylim([1e-8 1e-4])
% % ylabel('dissipaton rate (m^2/s^3)')%, legend('Model','Data','location','best')
% % if dind == 1
% %     subplot(2,2,3), semilogy(s,abs(spm),'r.',abs(ud),abs(sp),'k.')
% % else
% %     subplot(2,2,3), semilogy(s,abs(spm),'r.')%,smd,abs(spmdd),'g.',smu,abs(spmu),'b.')
% % end
% % set(gca,'fontsize',font,'fontweight','bold')
% % ylabel('shear production (m^2/s^3)'), xlabel('speed (m/s)')
% % subplot(2,2,4), semilogy(s,abs(bpm),'r.')
% % set(gca,'fontsize',font,'fontweight','bold')
% % ylabel('buoyancy production (m^2/s^3)'), xlabel('speed (m/s)')
% % fname = ['figures/comp_turb2model/' name '_turbvspeed'];
% % op_save(fname)
% end
% % Model Shear production + Buoyancy Production vs. Dissipation
% figure
% set(gcf,'position',[203   207   565   458])
% loglog(emu,abs(bpmu+spmu),'b.',emd,abs(bpmd+spmdd),'g.',...
%     em,abs(bpm+spm),'r.',[1e-9 1e-3],[1e-9 1e-3],'k--')
% axis([1e-9 1e-3 1e-9 1e-3])
% set(gca,'fontsize',font,'fontweight','bold')
% legend('Hub Height * 2','Hub Height * 1/2','Hub Height','location','best')
% ylabel('Buoyancy and Shear Production (m^2/s^3)')
% xlabel('Dissipation (m^2/s^3)')
% title([name ' , Model Output'],'interpreter','none')
% fname = ['figures/comp_turb2model/' name '_spbp_v_e'];
% op_save(fname)
% % Model Shear production - Buoyancy Production vs. Dissipation
% figure
% set(gcf,'position',[203   207   565   458])
% loglog(emu,abs(-bpmu+spmu),'b.',emd,abs(-bpmd+spmdd),'g.',...
%     emuu,abs(-bpmuu+spmuu),'m.',...
%     em,abs(-bpm+spm),'r.',[1e-9 1e-3],[1e-9 1e-3],'k--')
% axis([1e-9 1e-3 1e-9 1e-3])
% set(gca,'fontsize',font,'fontweight','bold')
% legend('Hub Height * 2','Hub Height * 1/2','Hub Height * 6','Hub Height','location','best')
% ylabel('Shear-Buoyancy Production (m^2/s^3)')
% xlabel('Dissipation (m^2/s^3)')
% title([name ' , Model Output'],'interpreter','none')
% fname = ['figures/comp_turb2model/' name '_sp-bp_v_e'];
% op_save(fname)
% % Model Shear production vs. Buoyancy Production + Dissipation
% figure
% set(gcf,'position',[203   207   565   458])
% loglog(abs(bpmu+emu),abs(spmu),'b.',abs(bpmd+emd),abs(spmdd),'g.',...
%     abs(bpmuu+emuu),abs(spmuu),'m.',...
%     abs(bpm+em),abs(spm),'r.',[1e-9 1e-3],[1e-9 1e-3],'k--')
% axis([1e-9 1e-3 1e-9 1e-3])
% set(gca,'fontsize',font,'fontweight','bold')
% legend('Hub Height * 2','Hub Height * 1/2','Hub Height * 6','Hub Height','location','best')
% ylabel('Shear Production (m^2/s^3)')
% xlabel('Buoyancy Production + Dissipation (m^2/s^3)')
% title([name ' , Model Output'],'interpreter','none')
% fname = ['figures/comp_turb2model/' name '_sp_v_bp+e'];
% op_save(fname)
% % Model Viscosity vs. Shear production, Buoyancy Production, Dissipation
% figure
% set(gcf,'position',[31    31   737   634])
% loglog(viscnm,abs(em),'g.',viscnm,abs(spm),'b.',...viscnm,abs(bpm),'r.',...
%     [1e-10 1e-3],[1e-10 1e-3],'k--','markersize',20)
% axis([1e-10 1e-3 1e-10 1e-3])
% set(gca,'fontsize',18,'fontweight','bold')
% legend('Turb. Dissipation Rate','Shear Production','location','best')
% % legend('Turb. Dissipation Rate','Shear Production','Buoyancy Production','location','best')
% % ylabel('Shear + Buoyancy Production + Dissipation (m^2/s^3)')
% xlabel('Numerical sink (m^2/s^3)')
% title([name ', Model Output'],'interpreter','none')
% fname = ['figures/comp_turb2model/' name '_viscn'];
% op_save(fname)
% figure
% set(gcf,'position',[31    31   737   634])
% loglog(viscpm,abs(em),'g.',viscpm,abs(spm),'b.',...viscpm,abs(bpm),'r.',...
%     [1e-10 1e-3],[1e-10 1e-3],'k--','markersize',20)
% axis([1e-10 1e-3 1e-10 1e-3])
% set(gca,'fontsize',18,'fontweight','bold')
% legend('Turb. Dissipation Rate','Shear Production','location','best')
% % legend('Dissipation Rate','Shear Production','Buoyancy Production','location','best')
% % ylabel('Shear + Buoyancy Production + Dissipation (m^2/s^3)')
% xlabel('Numerical source (m^2/s^3)')
% title([name ', Model Output'],'interpreter','none')
% fname = ['figures/comp_turb2model/' name '_viscp'];
% op_save(fname)
% %%% ai100
% figure
% set(gcf,'position',[31    31   737   634])
% loglog(viscnm1,abs(spm1),'b.',viscnm1,abs(bpm1),'r.',...
%     [1e-10 1e-3],[1e-10 1e-3],'k--','markersize',20)
% axis([1e-10 1e-3 1e-10 1e-3])
% set(gca,'fontsize',18,'fontweight','bold')
% legend('Shear Production','Buoyancy Production','location','best')
% % ylabel('Shear + Buoyancy Production + Dissipation (m^2/s^3)')
% xlabel('Negative Numerical Mixing Rate (m^2/s^3)')
% title([name ', ai100 Model Output'],'interpreter','none')
% fname = ['figures/comp_turb2model/' name '_viscn1'];
% op_save(fname)
% figure
% set(gcf,'position',[31    31   737   634])
% loglog(viscpm1,abs(spm1),'b.',viscpm1,abs(bpm1),'r.',...
%     [1e-10 1e-3],[1e-10 1e-3],'k--','markersize',20)
% axis([1e-10 1e-3 1e-10 1e-3])
% set(gca,'fontsize',18,'fontweight','bold')
% legend('Shear Production','Buoyancy Production','location','best')
% % ylabel('Shear + Buoyancy Production + Dissipation (m^2/s^3)')
% xlabel('Positive Numerical Mixing Rate (m^2/s^3)')
% title([name ', ai100 Model Output'],'interpreter','none')
% fname = ['figures/comp_turb2model/' name '_viscp1'];
% op_save(fname)
% % Numerical Mixing profiles
% figure
% [z,p] = op_interp_depth(vc.zm(:,:,dind),squeeze(viscp(:,:,dind)));
% [z1,p1] = op_interp_depth(vc1.zm(:,:,dind),squeeze(viscp1(:,:,dind)));
% [z,n] = op_interp_depth(vc.zm(:,:,dind),squeeze(viscn(:,:,dind)));
% [z1,n1] = op_interp_depth(vc1.zm(:,:,dind),squeeze(viscn1(:,:,dind)));
% semilogx(nanmean(p,1),op_depth2height(z),'k',nanmean(p1,1),op_depth2height(z1),'r',...
%     nanmean(n,1),op_depth2height(z),'k--',nanmean(n1,1),op_depth2height(z1),'r--','linewidth',2)
% set(gca,'fontsize',font,'fontweight','bold')
% ylabel('Height Above Seabed (m)'), xlabel('Mean Numerical Mixing Rate')
% legend('ai65 Positive','ai100 Positive','ai65 Negative','ai100 Negative','location','best')
% % cumulative mean
% cumv=nan(size(viscp,1),size(viscp,2)); cumv1=nan(size(viscp1,1),size(viscp1,2));
% for i=1:size(viscp,1)
%     cumv(i,:) = nanmean(viscp(1:i,:,dind),1);
% end
% for i=1:size(viscp1,1)
%     cumv1(i,:) = nanmean(viscp1(1:i,:,dind),1);
% end
% figure
% [ax,h1,h2]=plotyy(tm-tm(1),cumv(:,10),tm1-tm1(1),cumv1(:,10));
% set(ax(1),'fontsize',font,'fontweight','bold')
% set(ax(2),'fontsize',font,'fontweight','bold')
% ylabel(ax(1),'ai65'), ylabel(ax(2),'ai100')
% title('Cumulative Horizontal Numerical Mixing Rates')

% % Model I vs. Data I
% figure
% set(gcf,'position',[38    45   730   620])
% snew = interp1(Imt2,s(vecm),Itt);
% Imnew = interp1(Imt2,Im(vecm),Itt);
% Imtotnew = interp1(Imt2,Imtot(vecm),Itt);
% Ivecd = I(vecd);
% Ivecd(ud(vecd)<.8)=nan;
% Imnew(snew<.8) = nan;
% % I is too high with inferred TKE
% plot(...
%     Ivecd,Imnew,'k.',...Ivecd,Imtotnew,'g.',...
%     [0 15],[0 15],'k--','linewidth',2,'markersize',20)
% %     k(vecd),interp1(Imt2,kmtot(vecm),Itt),'m.',...
% %     k(vecd),interp1(Imt2,kvisctot(vecm),Itt),'k.',...
% axis([0 15 0 15])
% set(gca,'fontsize',18,'fontweight','bold')
% % legend('Data TKE v. Model TKE','Isotropic Data v. Model TKE')%,...
% %     'Data TKE v. New Model TKE','location','best')
% ylabel('Model Turbulence Intensity (%)')
% xlabel('Data Turbulence Intensity (%)')
% title([name],'interpreter','none')
% fname = ['figures/comp_turb2model/' name '_I'];
% op_save(fname)
% % Model EPS vs. Data EPS
% figure
% set(gcf,'position',[38    45   730   620])
% emnew = interp1(Imt2,em(vecm),Itt);
% loglog(...
%     e(vecd),emnew,'k.',...kiso(vecd),kmnew,'g.',...
%     [1e-7 10e-4],[1e-7 10e-4],'k--','linewidth',2,'markersize',20)
% %     k(vecd),interp1(Imt2,kmtot(vecm),Itt),'m.',...
% %     k(vecd),interp1(Imt2,kvisctot(vecm),Itt),'k.',...
% axis([1e-7 10e-4 1e-7 10e-4])
% set(gca,'fontsize',18,'fontweight','bold')
% % legend('Data TKE v. Model TKE','Isotropic Data v. Model TKE')%,...
% %     'Data TKE v. New Model TKE','location','best')
% ylabel('Model Dissipation Rate (m^2/s^3)')
% xlabel('Data Dissipation Rate (m^2/s^3)')
% title([name ' , Model Output'],'interpreter','none')
% fname = ['figures/comp_turb2model/' name '_eps'];
% op_save(fname)
% % Model TKE vs. Data TKE - no VKE
% figure
% set(gcf,'position',[38    45   730   620])
% kmnew = interp1(Imt2,km(vecm),Itt);
% % plot(...
% %     k(vecd),kmnew,'b.',kiso(vecd),kmnew,'g.',...
% %     [1e-5 10e-2],[1e-5 10e-2],'k--','linewidth',2,'markersize',20)
% loglog(...
%     k(vecd),kmnew,'b.',kiso(vecd),kmnew,'g.',...
%     [1e-5 10e-2],[1e-5 10e-2],'k--','linewidth',2,'markersize',20)
%     k(vecd),interp1(Imt2,kmtot(vecm),Itt),'m.',...
%     k(vecd),interp1(Imt2,kvisctot(vecm),Itt),'k.',...
% axis([1e-5 10e-2 1e-5 10e-2])
% set(gca,'fontsize',18,'fontweight','bold')
% legend('Data TKE v. Model TKE','Classical Data v. Model TKE')%,...
% %     'Data TKE v. New Model TKE','location','best')
% ylabel('Model TKE (m^2/s^2)')
% xlabel('Data TKE (m^2/s^2)')
% title([name ' , Model Output'],'interpreter','none')
% fname = ['figures/comp_turb2model/' name '_tkenovke'];
% op_save(fname)
% % Model TKE vs. Data TKE
% figure
% set(gcf,'position',[38    45   730   620])
% kmnew = interp1(Imt2,km(vecm),Itt);
% loglog(vkeiso(vecd),kmnew/3,'r.',...
%     kiso(vecd),kmnew,'g.',k(vecd),kmnew,'b.',...
%     [1e-5 10e-2],[1e-5 10e-2],'k--','linewidth',2,'markersize',20)
% %     k(vecd),interp1(Imt2,kmtot(vecm),Itt),'m.',...
% %     k(vecd),interp1(Imt2,kvisctot(vecm),Itt),'k.',...
% axis([1e-5 10e-2 1e-5 10e-2])
% set(gca,'fontsize',18,'fontweight','bold')
% legend('Data VKE v. Model TKE/3','Classical Data v. Model TKE','Data TKE v. Model TKE')%,...
% %     'Data TKE v. New Model TKE','location','best')
% ylabel('Model TKE (m^2/s^2)')
% xlabel('Data TKE (m^2/s^2)')
% title([name ' , Model Output'],'interpreter','none')
% fname = ['figures/comp_turb2model/' name '_tke'];
% op_save(fname)
% % ADV Recreation of loglog Energy Spectrum data plot from paper
% figure
% set(gcf,'position',[203   207   565   458])
% % loglog(ADV.f,ADV.Swwf,'g',ADV.f,ADV.Suuf,'r','handlevisibility','off')
% % hold on
% load ~/grid/adcp/nnmrec/turb/TTT_ADV_Feb2011processed_300s.mat
% loglog(ADV.f,nanmean(ADV.Surawf,2),'k',ADV.f,nanmean(ADV.Svrawf,2),'k--',...
%     ADV.f,nanmean(ADV.Swwf,2),'k-.','linewidth',4)
% hold on
% % loglog([.2 2],[1e-3*(.2)^(-5/3) 1e-3*(2)^(-5/3)],':k','linewidth',2)
% loglog([10^(-2) 2],[1e-3*(10^(-2))^(-5/3) 1e-3*(2)^(-5/3)],':k','linewidth',2)
% axis([1e-2 10 1e-5 1])
% legend('U TKE Mean','V TKE Mean','W TKE','f^{-5/3}','location','best')
% set(gca,'fontsize',font,'fontweight','bold')
% ylabel('TKE (m^2/s^2 Hz^{-1})')
% xlabel('Frequency (Hz)')
% % title('Nodule Point, Model Output')
% % fname = ['figures/comp_turb2model/nodule_point_spectrum_meansonly_withv'];
% fname = ['figures/comp_turb2model/nodule_point_spectrum_meansonly_extension_withv'];
% % fname = ['figures/comp_turb2model/nodule_point_spectrum'];
% op_save(fname)
% % AH MayJun Recreation of loglog Energy Spectrum data plot from paper
% figure
% set(gcf,'position',[203   207   565   458])
% loglog(AWAC_MayJun.f,AWAC_MayJun.Swwf,'g',AWAC_MayJun.f,AWAC_MayJun.Suuf,'r','handlevisibility','off')
% hold on
% loglog(AWAC_MayJun.f,nanmean(AWAC_MayJun.Suuf,2),'k',AWAC_MayJun.f,nanmean(AWAC_MayJun.Swwf,2),'b--','linewidth',4)
% axis([1e-2 10 1e-5 1])
% set(gca,'fontsize',font,'fontweight','bold')
% legend('Horizontal Mean','Vertical Mean','location','best')
% ylabel('TKE (m^2/s^2 Hz^{-1}')
% xlabel('Frequency (Hz)')
% title([name ' , Model Output'],'interpreter','none')
% fname = ['figures/comp_turb2model/ah_mayjun_spectrum'];
% op_save(fname)
% % AH Feb Recreation of loglog Energy Spectrum data plot from paper
% figure
% set(gcf,'position',[203   207   565   458])
% loglog(AWAC_Feb.f,AWAC_Feb.Swwf,'g',AWAC_Feb.f,AWAC_Feb.Suuf,'r','handlevisibility','off')
% hold on
% loglog(AWAC_Feb.f,nanmean(AWAC_Feb.Suuf,2),'k',AWAC_Feb.f,nanmean(AWAC_Feb.Swwf,2),'b--','linewidth',4)
% axis([1e-2 .5 1e-3 1])
% set(gca,'fontsize',font,'fontweight','bold')
% legend('Horizontal Mean','Vertical Mean','location','best')
% ylabel('TKE (m^2/s^2 Hz^{-1}')
% xlabel('Frequency (Hz)')
% title([name ' , Model Output'],'interpreter','none')
% fname = ['figures/comp_turb2model/' name '_spectrum'];
% op_save(fname)

% % Do mean profile plots overall
% switch wplot
%     case 'mprofile'
%   disp('fix these averages before using')
%         zm = abs(vc.zm(:,:,dind));
%         zm = max(max(zm(:,2:end)))-zm;
%         zm = nanmean(zm,1);
%         nplots = 4;
%         figure
%         set(gcf,'position',[ 6         188        1014         477])
%         %% Mean profiles
%         indd = udfull<.8; % data: eliminate things below cut-in speed
%         indm22 = sfull<.8; % model: eliminate things below cut-in speed
%         indm21 = op_resize(sfull,2)<.8; % model: eliminate things below cut-in speed
%         % Speed
%         subaxis(1,nplots,1,'sh',.04,'mb',.12,'ml',.06,'mr',.03)
% %         udfull(indd)=nan;
% %         sfull(indm22)=nan;
%         plot(nanmean(udfull,2),h,'k',...
%             nanmean(sfull(:,:,dind),1),zm,'r','linewidth',2)
%         ylim([0 max(h)])
%         set(gca,'fontsize',14,'fontweight','bold')
%         ylabel('Height Above Seabed (m)')
%         xlabel('Speed')
%         % Dissipation
%         subaxis(1,nplots,2)
% %         efull(indd)=nan;
% %         emfull(indm21)=nan;
%         semilogx(nanmean(efull,2),h,'k',...
%             nanmean(emfull(:,:,dind),1),op_resize(zm,2),'r','linewidth',2)
%         ylim([0 max(h)])
%         set(gca,'yticklabel',[])
%         set(gca,'fontsize',14,'fontweight','bold')
%         xlabel('Dissipation Rate (m^2/s^3)')
%         % Full TKE
%         subaxis(1,nplots,3)
% %         kfull(indd)=nan;
% %         kmfull(indm21)=nan; kmtotfull(indm21)=nan; kvisc(indm22)=nan;
%         plot(nanmean(kfull,2),h,'k',nanmean(kmtotfull(:,:,dind),1),zm,'g',...
%             nanmean(kmfull(:,:,dind),1),zm,'r',...%nanmean(kvisc(:,:,dind),1),zm,'b',...
%             'linewidth',2)
%         ylim([0 max(h)])
%         set(gca,'yticklabel',[])
%         set(gca,'fontsize',14,'fontweight','bold')
%         xlabel('Full TKE (m^2/s^2)')
%         xlim([0 max(max(nanmean(kfull,2)))])
%         legend('Data','Kolmogorov','Model')%,'location','best')
% %         % Turbulence Intensity
% %         subaxis(1,nplots,4)
% %         Ifull(indd)=nan;
% %         Imfull(indm22)=nan; Im2full(indm22)=nan; Imviscfull(indm22)=nan;
% %         plot(nanmean(Ifull,2),h,'k',nanmean(Im2full(:,:,dind),1),zm,'g',...
% %             nanmean(Imfull(:,:,dind),1),zm,'r',...%nanmean(Imviscfull(:,:,dind)),zm,'b',
% %             'linewidth',2)
% %         ylim([0 max(h)])
% %         set(gca,'yticklabel',[])
% %         set(gca,'fontsize',14,'fontweight','bold')
% %         xlabel('Turbulence Intensity (%)')
% %         xlim([0 max(max(nanmean(Ifull,2)))])
%         % Richardson Number
%         subaxis(1,nplots,4)
% %         Ifull(indd)=nan;
% %         Imfull(indm22)=nan; Im2full(indm22)=nan; Imviscfull(indm22)=nan;
%         plot(nanmean(ri(:,:,dind),1),zm,'r',...%nanmean(Imviscfull(:,:,dind)),zm,'b',
%             'linewidth',2)
%         ylim([0 max(h)])
%         set(gca,'yticklabel',[])
%         set(gca,'fontsize',14,'fontweight','bold')
%         xlabel('Richardson Number')
%         xlim([0 max(max(nanmean(Ifull,2)))])
%         fname = ['figures/comp_turb2model/' name '_means'];
%         op_save(fname)
% end
