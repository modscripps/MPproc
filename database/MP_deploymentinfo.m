function info = MP_deploymentinfo(sn,cruise,mooring)

% info = MP_deploymentinfo(sn,cruise,mooring)
%
% Return a structure with deployment parameters for the specified MP and cruise.
% This is also where we fill in information for all deployment.
% This calls the files CTDsensorinfo_MP and VELsensorinfo_MP, both of which
% need to be updated when the various sensors are calibrated, deployed,
% recovered, broken, spin tested, etc.
% 1/25/05 MHA
%
% 2/3/05: Added magnetic variation to structure.
% Use the calculator at http://www.ngdc.noaa.gov/seg/geomag/jsp/IGRF.jsp

info.sn=sn;
info.cruise=cruise;

switch cruise
    case 'ps03' %Puget Sound 2003: two profilers.
        switch sn
            case '101',
                info.lat=47.7145;
                info.lon=-122.4148;
                info.H=195;
                info.dates={'9/15/03-12/16/03'};
                info.pmin=30;
                info.pmax=165;
                info.dt=20/60/24;
                info.n_profiles=2117;
                info.year=2003;
                info.start_yday=274;
                info.end_yday=308;
                
                info.magvar=17;
                
                
                info.CTDsensor=CTDsensorinfo_MP('1361');
                info.VELsensor=VELsensorinfo_MP('1668');
                info.ballast=ballastFCN(11.5,30.5,1023.48,100);
                info.ballast.comments='original ballast from McLane for ps03';
                
                info.totdist=284211; %From depth_history
                info.station='MP1';
                info.comments={'spring broke after ~1 month (2117 profiles); no engineering files unpacked after this'};
            case '115',
                info.lat=47.7386;
                info.lon=-122.4032;
                info.H=195;
                info.dates={'9/15/03-12/16/03'};
                info.dt=20/60/24; %20-min
                info.pmin=30;
                info.pmax=165;
                
                info.n_profiles=3902;
                info.year=2003;
                info.start_yday=274;
                info.end_yday=350;
                
                info.magvar=17;
                
                info.CTDsensor=CTDsensorinfo_MP('1361');
                info.VELsensor=VELsensorinfo_MP('1607');
                
                info.ballast=ballastFCN(11.5,30.5,1023.48,100); %same ballasting as sn101 for ps03
                info.station='MP2';
                info.comments={'slow profile speed initially.  Profiler ran against bottom stop, so max pressure resembles tidal record.'};
            otherwise,
                disp 'I only know about 101 and 115 in ps03!'
        end %ps03
        
    case 'aeg04'
        switch sn
            case '101',
                
                info.lat=36.4552;
                info.lon=25.2153;
                info.H=180;
                info.dates={'8/30/04-11/18/04'};
                info.pmin=33;
                info.pmax=163;
                info.dt=20/60/24;
                
                info.n_profiles=5236;
                info.year=2004;
                info.start_yday=245;
                info.end_yday=321;
                
                info.magvar=2.9;
                
                info.CTDsensor=CTDsensorinfo_MP('1361');
                info.VELsensor=VELsensorinfo_MP('1668');
                
                info.ballast=ballastFCN(16.23,38.766,1028.7,50); %
                info.ballast.comments='original ballast from McLane, plus 330 g lead';
                
                info.totdist=527562; %From depth_history - first 4095 only
                
                info.comments={'5-day gap; otherwise successful'};
                info.station='mp180';
                info.experiment='AegeanSea';
            case '102',
                info.lat=36.4379;
                info.lon=25.2052;
                info.H=300;
                info.dates={'8/30/04-11/18/04'};
                info.pmin=36.5;
                info.pmax=275;
                info.dt=40/60/24;
                
                info.n_profiles=2299;
                info.year=2004;
                info.start_yday=245;
                info.end_yday=321;
                
                info.magvar=2.9;
                
                info.CTDsensor=CTDsensorinfo_MP('1368');
                info.VELsensor=VELsensorinfo_MP('1710');
                
                info.ballast=ballastFCN(15.3,38.99,1029.9,200); %original ballast from McLane
                info.ballast.comments='original ballast from McLane';
                
                info.totdist=372174; %From depth_history
                
                info.comments={'some profile speed problems'};
                info.station='mp300';
            case '103',
                info.lat=36.4030;
                info.lon=25.1753;
                info.H=430;
                info.dates={'8/30/04-11/18/04'};
                info.pmin=30.5;
                info.pmax=398;
                info.dt=60/60/24;
                
                info.n_profiles=1776;
                info.year=2004;
                info.start_yday=245;
                info.end_yday=321;
                
                info.magvar=2.9;
                
                info.CTDsensor=CTDsensorinfo_MP('1369');
                info.VELsensor=VELsensorinfo_MP('1711');
                
                info.ballast=ballastFCN(15.3,38.99,1029.9,200); %original ballast from McLane
                info.ballast.comments='original ballast from McLane';
                info.comments={'ballasted too light; failed to penetrate > 50 m after 9 days'};
                info.station='mp430';
            otherwise,
                disp 'I only know about 101, 102 and 103 in aeg04.'
        end %aeg04
        
    case 'home02' %Mamala Bay
        switch sn
            case 'WHOI102',
                info.lat=21+13.950/60;
                info.lon=-158 - 0.573/60;
                info.H=395;
                info.dates={'8/02-11/02'};
                info.pmin=40;
                info.pmax=350;
                info.dt=60/60/24;
                
                info.n_profiles=1302;
                info.year=2002;
                info.start_yday=225;
                info.end_yday=280;
                
                info.magvar=0;
                
                info.CTDsensor=CTDsensorinfo_MP('1348');
                info.VELsensor=VELsensorinfo_MP('1605');
                
                info.totdist=391928; %From depth_history
                info.ballast=ballastFCN(15.3,38.99,1029.9,200); %original ballast from McLane
                info.ballast.comments='';
                info.station='MP1';
                info.comments={'spring broke after 2 months'};
                info.experiment='MamalaBay';
        end %end sn102
        
    case 'nabos02'
        switch sn
            
            case '622', %IARC profiler used in NABOS
                info.lat=78+26.637/60;
                info.lon=125+40.194/60;
                info.H=2686;
                info.dates={'9/02/02-9/1/03'};
                info.dt=1; %daily
                info.pmin=164;
                info.pmax=2607;
                
                info.n_profiles=365;
                info.year=2002;
                info.start_yday=yearday(9,2,info.year,0,0,0);
                info.end_yday=yearday(9,1,info.year+1,0,0,0);
                
                info.magvar=0;
                
                info.CTDsensor=CTDsensorinfo_MP('1359');
                info.VELsensor=VELsensorinfo_MP('1660');
                
                info.ballast=ballastFCN(0.374,34.843,1031.49,750); %same ballasting as for sn622
                info.comments={'M1A - profiling problems after ~3 mos.'};
                
        end %nabos02
    case 'nabos03'
        switch sn
            case '474',
                info.lat=78+26.637/60;
                info.lon=125+40.194/60;
                info.H=2686;
                info.dates={'9/08/03-[LOST]'};
                info.dt=1; %daily
                info.pmin=80;
                info.pmax=1516;
                info.n_profiles=365;
                info.year=2003;
                info.start_yday=yearday(9,8,info.year,0,0,0);
                info.end_yday=yearday(9,8,info.year,0,0,0);
                
                info.magvar=0;
                
                info.CTDsensor=CTDsensorinfo_MP('1360');
                info.VELsensor=VELsensorinfo_MP('1661');
                
                info.ballast=ballastFCN(0.374,34.843,1031.49,750); %same ballasting as for sn622
                info.comments={'M1B.  Lost.  '};
                
            case '622', %IARC profiler used in NABOS
                info.lat=77+19.064/60;
                info.lon=125+6.272/60;
                info.H=1500;
                info.dates={'9/08/03-summer/04'};
                info.dt=1; %daily
                info.pmin=80;
                info.pmax=1516;
                info.n_profiles=375;
                
                info.year=2003;
                info.start_yday=yearday(9,8,info.year,0,0,0);
                info.end_yday=yearday(9,8,info.year+1,0,0,0);
                
                info.magvar=0;
                
                info.CTDsensor=CTDsensorinfo_MP('1359');
                info.VELsensor=VELsensorinfo_MP('1660');
                
                info.totdist=522063; %From depth_history
                
                info.ballast=ballastFCN(0.374,34.843,1031.49,750); %same ballasting as for sn622
                info.comments={'M2A.  Recovered from nabos02 and redeployed on same cruise with jury-rigged spring.  Mission completed normally with battery voltage 10.2 V'};
                
                
                
        end %nabos03
        
    case 'hc05d1' %Hood Canal deployment, depl 1
        switch sn
            case '115',
                %                info.lat=47+25.881/60; %Planned.
                %                info.lon=-123-06.415/60;
                info.lat=47.4271; %actual
                info.lon=-123.1082;
                info.H=125;
                info.dates={'4/21/05-5/5/05'};
                info.dt=30/60/24; %30-min (profile pairs)
                info.pmin=3;
                info.pmax=119;
                info.year=2005;
                info.start_yday=111;
                info.end_yday=125;%124.7612;
                info.n_profiles=654; %656 files; 654 good profiles
                info.magvar=17;
                
                info.CTDsensor=CTDsensorinfo_MP('SBE-MP52-002');
                info.VELsensor=VELsensorinfo_MP('1607');
                
                info.ballast=ballastFCN(11.01,30.45,1023.51,60); %ballast from Apr 2000 DOE data at Sisters Point
                % http://www.ecy.wa.gov/apps/eap/marinewq/mwdataset.asp?ec=no&scrolly=0&htmlcsvpref=csv&estuarycode=1&staID=67&theyear=2000&themonth=10
                %Using Apr 2002, I get 9.98, 29.98, 1023.43.
                info.station='MP1';
                info.comments={'Software version 3.13.  Paired profiles each hour.  First oxygen deployment.  Recovered by divers May 5, 2005.'};
                
        end %hc05d1
        
    case 'hc05d2' %Hood Canal deployment, depl 2
        switch sn
            case '115',
                %                info.lat=47+25.881/60; %Planned.
                %                info.lon=-123-06.415/60;
                info.lat=47.4271; %actual
                info.lon=-123.1082;
                info.H=125;
                info.dates={'5/5/05-8/15/05'};
                info.dt=30/60/24; %30-min (profile pairs)
                info.pmin=3;
                info.pmax=119;
                info.year=2005;
                info.start_yday=125;
                info.end_yday=226;%124.7612;
                info.n_profiles=510; %set this
                info.magvar=17;
                
                info.CTDsensor=CTDsensorinfo_MP('SBE-MP52-002');
                info.VELsensor=VELsensorinfo_MP('1607');
                
                info.ballast=ballastFCN(11.01,30.45,1023.51,60); %ballast from Apr 2000 DOE data at Sisters Point
                % http://www.ecy.wa.gov/apps/eap/marinewq/mwdataset.asp?ec=no&scrolly=0&htmlcsvpref=csv&estuarycode=1&staID=67&theyear=2000&themonth=10
                %Using Apr 2002, I get 9.98, 29.98, 1023.43.
                info.comments={'Software version 3.13.  Paired profiles each hour.'};
                
        end %hc05d2
    case 'hc05d3' %Hood Canal deployment, depl 3
        switch sn
            case '115',
                %                info.lat=47+25.881/60; %Planned.
                %                info.lon=-123-06.415/60;
                info.lat=47.4271; %nominal
                info.lon=-123.1082;
                info.H=125;
                info.dates={'8/15/05-10/11/05'};
                info.dt=45/60/24; %45-min (profile pairs)
                info.pmin=12;
                info.pmax=119;
                info.year=2005;
                info.start_yday=227;
                info.end_yday=283;%124.7612;
                info.n_profiles=781;
                info.magvar=17;
                
                info.CTDsensor=CTDsensorinfo_MP('SBE-MP52-002');
                info.VELsensor=VELsensorinfo_MP('1607');
                
                info.ballast=ballastFCN(11.01,30.45,1023.51,60); %ballast from Apr 2000 DOE data at Sisters Point
                % http://www.ecy.wa.gov/apps/eap/marinewq/mwdataset.asp?ec=no&scrolly=0&htmlcsvpref=csv&estuarycode=1&staID=67&theyear=2000&themonth=10
                %Using Apr 2002, I get 9.98, 29.98, 1023.43.
                info.comments={'Software version 3.13.  Paired profiles each 1.5 hour.'};
                
        end %hc05d3
    case 'hc05d4' %Hood Canal deployment, depl 4
        switch sn
            case '115',
                info.lat=47.4271; %nominal
                info.lon=-123.1082;
                info.H=125;
                info.dates={'10/12/05-10/18/05'};
                info.dt=45/60/24; %45-min (profile pairs)
                info.pmin=13;
                info.pmax=114;
                info.year=2005;
                info.start_yday=284;
                info.end_yday=290;%124.7612;
                info.n_profiles=187;%1677; %set this
                info.magvar=17;
                
                info.CTDsensor=CTDsensorinfo_MP('SBE-MP52-002');
                info.VELsensor=VELsensorinfo_MP('1607');
                
                info.ballast=ballastFCN(11.01,30.45,1023.51,60); %ballast from Apr 2000 DOE data at Sisters Point
                % http://www.ecy.wa.gov/apps/eap/marinewq/mwdataset.asp?ec=no&scrolly=0&htmlcsvpref=csv&estuarycode=1&staID=67&theyear=2000&themonth=10
                %Using Apr 2002, I get 9.98, 29.98, 1023.43.
                info.comments={'Recovered early since profiler was not moving imm. after deplymt.'};
                
        end %hc05d4
    case 'hc05d5' %Hood Canal deployment, depl 5
        switch sn
            case '115',
                info.lat=47.4271; %nominal
                info.lon=-123.1082;
                info.H=125;
                info.dates={'10/20/05-2/3/06'};
                info.dt=45/60/24; %45-min (profile pairs)
                info.pmin=13;
                info.pmax=114;
                info.year=2005;
                info.start_yday=yearday(20,10,2005,0,0,0);
                info.end_yday=365+yearday(3,2,2006,0,0,0);%124.7612;
                info.n_profiles=3382;%1677; %set this
                info.magvar=17;
                
                info.CTDsensor=CTDsensorinfo_MP('SBE-MP52-002');
                info.VELsensor=VELsensorinfo_MP('1607');
                
                info.ballast=ballastFCN(11.01,30.45,1023.51,60); %ballast from Apr 2000 DOE data at Sisters Point
                % http://www.ecy.wa.gov/apps/eap/marinewq/mwdataset.asp?ec=no&scrolly=0&htmlcsvpref=csv&estuarycode=1&staID=67&theyear=2000&themonth=10
                %Using Apr 2002, I get 9.98, 29.98, 1023.43.
                info.comments={'Recovered Friday 2/3/06'};
                
        end %hc05d5
    case 'hc05d6' %Hood Canal deployment, depl 6
        switch sn
            case '104',
                info.lat=47+33.437/60;
                info.lon=-123-00.540/60;
                info.H=155;
                info.dates={'9/06-1/11/07'};
                info.dt=45/60/24; %45-min (profile pairs)
                info.pmin=11;
                info.pmax=143;
                info.year=2006;
                info.start_yday=yearday(7,9,2006,0,0,0);
                info.end_yday=yearday(11,1,2006,0,0,0)+365;%124.7612;
                info.n_profiles=2587;%
                info.magvar=17;
                
                info.CTDsensor=CTDsensorinfo_MP('SBE-MP52-002');
                info.VELsensor=VELsensorinfo_MP('1845');%1845
                
                info.ballast=ballastFCN(11.01,30.45,1023.51,60);%fill in
                % http://www.ecy.wa.gov/apps/eap/marinewq/mwdataset.asp?ec=no&scrolly=0&htmlcsvpref=csv&estuarycode=1&staID=67&theyear=2000&themonth=10
                %Using Apr 2002, I get 9.98, 29.98, 1023.43.
                info.comments={'Recovered Friday 1/11/07'};
                
        end %hc05d6
    case 'hc05d7' %Hood Canal deployment, depl 7
        switch sn
            case '104',
                info.lat=47+33.437/60;
                info.lon=-123-00.540/60;
                info.H=155;
                info.dates={'1/07-4/07'};
                info.dt=2/24; %45-min (profile pairs)
                info.pmin=11;
                info.pmax=143;
                info.year=2007;
                info.start_yday=yearday(12,1,2007,0,0,0);
                info.end_yday=yearday(4,4,2007,0,0,0);%124.7612;
                info.n_profiles=1840;%
                info.magvar=17;
                
                info.CTDsensor=CTDsensorinfo_MP('SBE-MP52-002');
                info.VELsensor=VELsensorinfo_MP('1845');%1845
                
                info.ballast=ballastFCN(11.01,30.45,1023.51,60);%fill in
                % http://www.ecy.wa.gov/apps/eap/marinewq/mwdataset.asp?ec=no&scrolly=0&htmlcsvpref=csv&estuarycode=1&staID=67&theyear=2000&themonth=10
                %Using Apr 2002, I get 9.98, 29.98, 1023.43.
                info.comments={'Recovered Tuesday 6/19/07'};
                
        end %hc05d7
    case 'hc05d8' %Hood Canal deployment, depl 8
        switch sn
            case '104',
                info.lat=47+33.437/60;
                info.lon=-123-00.540/60;
                info.H=155;
                info.dates={'8/07-11/07'};
                info.dt=2/24; % (profile pairs)
                info.pmin=11;
                info.pmax=143;
                info.year=2007;
                info.start_yday=yearday(16,8,2007,0,0,0);
                info.end_yday=yearday(15,11,2007,0,0,0);%124.7612;
                info.n_profiles=3216;%
                info.magvar=17;
                
                info.CTDsensor=CTDsensorinfo_MP('SBE-MP52-002');
                info.VELsensor=VELsensorinfo_MP('1845');%1845
                
                info.ballast=ballastFCN(11.01,30.45,1023.51,60);%fill in
                % http://www.ecy.wa.gov/apps/eap/marinewq/mwdataset.asp?ec=no&scrolly=0&htmlcsvpref=csv&estuarycode=1&staID=67&theyear=2000&themonth=10
                %Using Apr 2002, I get 9.98, 29.98, 1023.43.
                info.comments={'Recovered Tuesday 11/15/07; apparently DRAGGED'};
                
        end %hc05d8
        
    case 'ore05' %Oregon slope experiment
        switch sn
            case '101',
                info.lat=43.2094; %Actual.
                info.lon=-126.2601;
                info.H=2995;
                info.dates={'9/12/05-10/26/05'};
                info.dt=0; %Continuous
                info.pmin=70;
                info.pmax=2006;
                info.year=2005;
                info.start_yday=yearday(15,9,2005,6,0,0);
                info.end_yday=yearday(25,10,2005,6,0,0);
                info.n_profiles=405; %
                info.magvar=magdev(info.lat,info.lon); %2000 magdev from Visbeck; mhatoolbox/visbeck_ladcp
                
                info.CTDsensor=CTDsensorinfo_MP('1361');
                info.VELsensor=VELsensorinfo_MP('1668');
                
                %ballast (T,S,rho, P)
                info.ballast=ballastFCN(3.682,34.412,1032.0,1000);
                
                info.comments={'Station 1.  RCM8 @ 2955 m.  Turbidity sensor.'};
                info.station='MP1';
                info.experiment='OregonSlope';
            case 'WHOI121', %bottom of mooring 2
                info.lat=43.2164; %Actual.
                info.lon=-125.3141;
                info.H=2992;
                info.dates={'9/12/05-10/26/05'};
                info.dt=0; %Continuous
                info.pmin=1548;
                info.pmax=3023;
                info.year=2005;
                info.start_yday=yearday(14,9,05,19,0,0);
                info.end_yday=NaN;
                info.n_profiles=0; %
                info.magvar=magdev(info.lat,info.lon); %2000 magdev from Visbeck; mhatoolbox/visbeck_ladcp
                
                info.CTDsensor=CTDsensorinfo_MP('1371');
                info.VELsensor=VELsensorinfo_MP('1728');
                
                %ballast (T,S,rho, P)
                %                info.ballast=ballastFCN(2.605,34.510,1034.5,1500); %if it
                %                is the only profiler on the wire
                info.ballast=ballastFCN(1.803,34.613,1038,2250); %if we have two
                
                
                info.comments={'Station 2 (bottom).  Synthetic line.  McLane S/N 11729-01. Turbidity sensor 10339.'};
                info.station='MP2';
                info.experiment='OregonSlope';
            case 'WHOI107', %4th profiler from WHOI - top of mooring 2
                info.lat=43.2164; %Actual.
                info.lon=-125.3141;
                info.H=2992;
                info.dates={'9/12/05-10/26/05'};
                info.dt=0; %Continuous
                info.pmin=70;
                info.pmax=1487;
                info.year=2005;
                info.start_yday=yearday(14,9,05,19,0,0);
                info.end_yday=NaN;
                info.n_profiles=0; %
                info.magvar=magdev(info.lat,info.lon); %2000 magdev from Visbeck; mhatoolbox/visbeck_ladcp
                
                info.CTDsensor=CTDsensorinfo_MP('1339');
                info.VELsensor=VELsensorinfo_MP('1500');
                
                %ballast (T,S,rho, P)
                info.ballast=ballastFCN(4.107,34.330,1030.9,800); %if we have two
                
                
                info.comments={'Station 2 (top).  Synthetic line.  McLane S/N 11463-01'};
                info.station='MP2';
                info.experiment='OregonSlope';
            case '103',
                info.lat=43.214; %Actual.
                info.lon=-125.2047;
                info.H=1780;
                info.dates={'9/12/05-10/26/05'};
                info.dt=0; %Continuous
                info.pmin=75;
                info.pmax=1763;
                info.year=2005;
                info.start_yday=yearday(14,9,2005,4,0,0);
                info.end_yday=NaN;
                %                info.n_profiles=614; %
                info.n_profiles=284; %
                info.magvar=magdev(info.lat,info.lon); %2000 magdev from Visbeck; mhatoolbox/visbeck_ladcp
                
                info.CTDsensor=CTDsensorinfo_MP('1369');
                info.VELsensor=VELsensorinfo_MP('1711');
                
                %ballast (T,S,rho, P)
                info.ballast=ballastFCN(3.908,34.377,1031.5,900);
                
                info.comments={'Station 3.  ADCP @ 68 m.  Turbidity sensor.'};
                info.station='MP3';
                info.experiment='OregonSlope';
            case '102',
                info.lat=43.2121; %Actual.
                info.lon=-125.0999;
                info.H=1452;
                info.dates={'9/12/05-10/24/05'};
                info.dt=0; %Continuous
                info.pmin=57;
                info.pmax=1448;
                info.year=2005;
                info.start_yday=yearday(14,9,2005,1,0,0);
                info.end_yday=yearday(24,10,2005,17,0,0);
                info.n_profiles=523; %
                info.magvar=magdev(info.lat,info.lon); %2000 magdev from Visbeck; mhatoolbox/visbeck_ladcp
                
                info.CTDsensor=CTDsensorinfo_MP('1368');
                info.VELsensor=VELsensorinfo_MP('1710');
                
                
                %ballast (T,S,rho, P)
                info.ballast=ballastFCN(4.177,34.299,1030.7,750);
                
                info.comments={'Station 4.  Turbidity sensor.'};
                info.station='MP4';
                info.experiment='OregonSlope';
            case 'WHOI122',
                info.lat=43.2131; %Actual.
                info.lon=-125.0005;
                
                info.H=1077;
                info.dates={'9/12/05-10/23/05'};
                info.dt=0; %Continuous
                info.pmin=65;
                info.pmax=1066;
                
                info.year=2005;
                info.start_yday=yearday(13,9,2005,19,0,0);
                info.end_yday=yearday(24,10,2005,18,5,0);
                info.n_profiles=594; %
                info.magvar=magdev(info.lat,info.lon); %2000 magdev from Visbeck; mhatoolbox/visbeck_ladcp
                
                info.CTDsensor=CTDsensorinfo_MP('1372');
                info.VELsensor=VELsensorinfo_MP('1597');
                
                %ballast (T,S,rho, P)
                info.ballast=ballastFCN(4.797,34.1903,1029.6,550);
                
                info.comments={'Station 5. McLane S/N 11729-02. ADCP @ 50 m.  Turbidity sensor 10340.  Unable to raise comms after recovery.'};
                info.station='MP5';
                info.experiment='OregonSlope';
            case 'WHOI123',
                info.lat=43.2119; %Actual.
                info.lon=-124.9013;
                info.H=500;
                info.dates={'9/12/05-10/9/05'};
                info.dt=0; %Continuous
                info.pmin=72;
                info.pmax=486;
                
                info.year=2005;
                info.start_yday=yearday(13,6,2005,17,0,0); %fished up
                info.end_yday=yearday(6,10,2005,17,0,0);
                info.n_profiles=945; %was 1259, then 961
                info.magvar=magdev(info.lat,info.lon); %2000 magdev from Visbeck; mhatoolbox/visbeck_ladcp
                
                info.CTDsensor=CTDsensorinfo_MP('1373');
                info.VELsensor=VELsensorinfo_MP('1730');
                
                %ballast (T,S,rho, P)
                info.ballast=ballastFCN(6.165,33.991,1028.0,270);
                
                info.comments={'Station 6. McLane S/N 11729-03. Turbidity sensor 10338.  Fished up 10/6/05.'};
                info.station='MP6';
                info.experiment='OregonSlope';
            otherwise,
                error(['I don''t show S/N ' sn ' as deployed during ' cruise '.'])
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'iwap06' %IWAP
        switch sn
            case 'WHOI112', %
                info.lat=25+29.348/60; %Actual.
                info.lon=360-165-9.29/60;
                info.H=4875;
                info.dates={'4/25/06-6/4/06'};
                info.dt=0; %Continuous
                info.pmin=85;
                info.pmax=1400;
                
                info.year=2006;
                info.start_yday=yearday(25,4,2006,0,0,0); %
                info.end_yday=yearday(4,6,2006,20,0,0);
                info.n_profiles=559; %
                info.magvar=magdev(info.lat,info.lon); %2000 magdev from Visbeck; mhatoolbox/visbeck_ladcp
                
                info.CTDsensor=CTDsensorinfo_MP('1352');
                info.VELsensor=VELsensorinfo_MP('1653');
                
                %ballast (T,S,rho, P)
                info.ballast=ballastFCN(3.6,34.35,1031.97,1000);
                
                info.comments={''};
                info.station='MP1';
                info.experiment='IWAP';
            case 'WHOI113', %
                info.lat=27+46.142/60; %Actual.
                info.lon=360-163-58.191/60;
                info.H=5461;
                info.dates={'4/25/06-6/5/06'};
                info.dt=0; %Continuous
                info.pmin=85;
                info.pmax=1400;
                
                info.year=2006;
                info.start_yday=yearday(25,4,2006,0,0,0); %
                info.end_yday=yearday(5,6,2006,0,0,0);
                info.n_profiles=695; %
                info.magvar=magdev(info.lat,info.lon); %2000 magdev from Visbeck; mhatoolbox/visbeck_ladcp
                
                info.CTDsensor=CTDsensorinfo_MP('1378');
                info.VELsensor=VELsensorinfo_MP('1654');
                
                %ballast (T,S,rho, P)
                info.ballast=ballastFCN(3.6,34.35,1031.97,1000);
                
                info.comments={''};
                info.station='MP2';
                info.experiment='IWAP';
            case 'WHOI114', %
                info.lat=28+53.974/60; %Actual.
                info.lon=360-163-29.370/60;
                info.H=5359;
                info.dates={'4/25/06-6/16/06'};
                info.dt=0; %Continuous
                info.pmin=85;
                info.pmax=1400;
                
                info.year=2006;
                info.start_yday=yearday(25,4,2006,0,0,0); %
                info.end_yday=yearday(16,6,2006,0,0,0);
                info.n_profiles=657; %
                info.magvar=magdev(info.lat,info.lon); %2000 magdev from Visbeck; mhatoolbox/visbeck_ladcp
                
                info.CTDsensor=CTDsensorinfo_MP('1353');
                info.VELsensor=VELsensorinfo_MP('1617');
                
                %ballast (T,S,rho, P)
                info.ballast=ballastFCN(3.6,34.35,1031.97,1000);
                
                info.comments={''};
                info.station='MP3';
                info.experiment='IWAP';
            case '101',
                info.lat=30+7.876/60; %Actual.
                info.lon=360-162-53.072/60;
                info.H=5736;
                info.dates={'4/25/06-6/6/06'};
                info.dt=0; %Continuous
                info.pmin=85;
                info.pmax=1400;
                
                info.year=2006;
                info.start_yday=yearday(25,4,2006,0,0,0); %
                info.end_yday=yearday(7,5,2006,14,0,0); %drive wheel failed after drop 332 on may 7
                info.n_profiles=332; %
                info.magvar=magdev(info.lat,info.lon); %2000 magdev from Visbeck; mhatoolbox/visbeck_ladcp
                
                info.CTDsensor=CTDsensorinfo_MP('1361');
                info.VELsensor=VELsensorinfo_MP('1668');
                
                
                %ballast (T,S,rho, P)
                info.ballast=ballastFCN(3.6,34.35,1031.97,1000);
                
                info.comments={''};
                info.station='MP4';
                info.experiment='IWAP';
            case '103',
                info.lat=32+54.441/60; %Actual.
                info.lon=360-161-24.193/60;
                info.H=5968;
                info.dates={'4/25/06-6/7/06'};
                info.dt=0; %Continuous
                info.pmin=85;
                info.pmax=1400;
                
                info.year=2006;
                info.start_yday=yearday(25,4,2006,0,0,0); %
                info.end_yday=yearday(7,6,2006,0,0,0);
                info.n_profiles=426; %
                info.magvar=magdev(info.lat,info.lon); %2000 magdev from Visbeck; mhatoolbox/visbeck_ladcp
                
                info.CTDsensor=CTDsensorinfo_MP('1369');
                info.VELsensor=VELsensorinfo_MP('1711');
                
                %ballast (T,S,rho, P)
                info.ballast=ballastFCN(3.6,34.35,1031.97,1000);
                
                info.comments={''};
                info.station='MP5';
                info.experiment='IWAP';
            case '102',
                info.lat=37+04.148/60; %Actual.
                info.lon=360-159-12.960/60;
                info.H=5810;
                info.dates={'4/25/06-6/16/06'};
                info.dt=0; %Continuous
                info.pmin=85;
                info.pmax=1400;
                
                info.year=2006;
                info.start_yday=yearday(25,4,2006,12,0,0); %12 hour later than rest of array
                info.end_yday=yearday(18,6,2006,0,0,0);
                info.n_profiles=623; %
                info.magvar=magdev(info.lat,info.lon); %2000 magdev from Visbeck; mhatoolbox/visbeck_ladcp
                
                info.CTDsensor=CTDsensorinfo_MP('1368');
                info.VELsensor=VELsensorinfo_MP('1710');
                
                %ballast (T,S,rho, P)
                info.ballast=ballastFCN(3.6,34.35,1031.97,1000);
                
                info.comments={''};
                info.station='MP6';
                info.experiment='IWAP';
                %%%%%%%%%%%%%%%%%%%%%%% end IWAP06
            otherwise,
                error(['I don''t show S/N ' sn ' as deployed during ' cruise '.'])
        end %iwap06
    case 'scs07' %scs07
        switch sn
            case '101', %
                info.lat=20+55.164/60; %Actual.
                info.lon=117+53.742/60;
                info.H=1518; %actual depth
                info.dates={'4/25/07-6/9/07'};
                info.dt=0; %Continuous
                info.pmin=70;
                info.pmax=1400;
                
                info.year=2007;
                info.start_yday=yearday(25,4,2007,0,0,0); %
                info.end_yday=yearday(6,9,2007,20,0,0);
                info.n_profiles=573; %
                info.magvar=magdev(info.lat,info.lon); %2000 magdev from Visbeck; mhatoolbox/visbeck_ladcp
                
                info.CTDsensor=CTDsensorinfo_MP('1361');
                info.VELsensor=VELsensorinfo_MP('1668');
                
                %ballast (T,S,rho, P)
                info.ballast=ballastFCN(6.19,34.47,1030.5,750);
                
                info.comments={''};
                info.station='MP1';
            case '102', %
                info.lat=21+4.105/60; %Actual.
                info.lon=116+30.324/60;
                info.H=322;
                info.dates={'4/25/07-6/9/07'};
                info.dt=0; %Continuous
                info.pmin=62;
                info.pmax=275;
                
                info.year=2007;
                info.start_yday=yearday(25,4,2007,0,0,0); %
                info.end_yday=yearday(6,9,2007,0,0,0);
                info.n_profiles=1319; %
                info.magvar=magdev(info.lat,info.lon); %2000 magdev from Visbeck; mhatoolbox/visbeck_ladcp
                
                info.CTDsensor=CTDsensorinfo_MP('1368');
                info.VELsensor=VELsensorinfo_MP('1710');
                
                %ballast (T,S,rho, P)
                info.ballast=ballastFCN(17.6,34.6,1025.7,150); %102
                
                info.comments={''};
                info.station='MP2';
            otherwise,
                error(['I don''t show S/N ' sn ' as deployed during ' cruise '.'])
        end %scs07
    case 'mb07' %mb07
        switch sn
            case '105', %
                info.lat=21+14.580/60; %Actual.
                info.lon=360-157-57.0960/60;
                %                21-14.580 N, 157-57.0960 W
                info.H=457;
                info.dates={'6/30/07-11/1/07'};
                info.dt=1/24; %
                info.pmin=42; %top stopper at 35
                info.pmax=435; %bottom stopper at 443
                
                info.year=2007;
                info.start_yday=yearday(30,6,2007,0,0,0); %
                info.end_yday=yearday(13,7,2007,0,0,0);
                info.n_profiles=345; %
                info.magvar=magdev(info.lat,info.lon); %2000 magdev from Visbeck; mhatoolbox/visbeck_ladcp
                
                info.CTDsensor=CTDsensorinfo_MP('SBE-MP52-026');
                info.VELsensor=VELsensorinfo_MP('1869');
                
                %ballast (T,S,rho, P)
                info.ballast=ballastFCN(19,35,1025.9,200);
                
                info.comments={''};
                info.station='MP';
            otherwise,
                error(['I don''t show S/N ' sn ' as deployed during ' cruise '.'])
        end %mb07
        
    case 'philex07' %philex07
        switch sn
            case '101', %
                info.lat=10+21.318/60; %Actual.
                info.lon=121+44.094/60;
                info.H=1535;
                info.dates={'12/23/07-2/29/08'};
                info.dt=0; %continuous
                info.pmin=80; %top stopper at 35
                info.pmax=1445; %bottom stopper at 443
                
                info.year=2007;
                info.start_yday=yearday(23,12,2007,16,0,0); %
                info.end_yday=yearday(19,2,2008,0,0,0)+365;
                info.n_profiles=794; %
                info.magvar=magdev(info.lat,info.lon); %2000 magdev from Visbeck; mhatoolbox/visbeck_ladcp
                
                info.CTDsensor=CTDsensorinfo_MP('1361');
                info.VELsensor=VELsensorinfo_MP('1668');
                
                %ballast (T,S,rho, P)
                info.ballast=ballastFCN(5.765,34.48,1030.7,770);
                % mp102         400       9.8163       34.431       1028.3
                % mp101         770       5.7654        34.48       1030.7
                % mp103        1100       3.9722       34.544       1032.5
                
                info.comments={''};
                info.station='MP2';
                info.experiment='Philex';
            case '102', %
                info.lat=12+50.26/60;
                info.lon=120+36.404/60;
                info.H=1850;
                info.dates={'12/20/07-3/2/08'};
                info.dt=1.5/24; %
                info.pmin=80;
                info.pmax=930;
                
                info.year=2007;
                info.start_yday=yearday(20,12,2007,0,0,0); %
                info.end_yday=yearday(2,3,2008,0,0,0)+365;
                info.n_profiles=1167; %
                info.magvar=magdev(info.lat,info.lon); %2000 magdev from Visbeck; mhatoolbox/visbeck_ladcp
                
                info.CTDsensor=CTDsensorinfo_MP('1368');
                info.VELsensor=VELsensorinfo_MP('1710');
                
                %ballast (T,S,rho, P)
                info.ballast=ballastFCN(5.7654,34.431,1028.3,400); %102
                
                info.comments={''};
                info.station='MP1';
                info.experiment='Philex';
            case '103', %
                info.lat=12+50.26/60;
                info.lon=120+36.404/60;
                info.H=1850;
                info.dates={'12/20/07-3/2/08'};
                info.dt=1.5/24; %
                info.pmin=960;
                info.pmax=1810;
                
                info.year=2007;
                info.start_yday=yearday(20,12,2007,0,0,0); %
                info.end_yday=yearday(2,3,2008,0,0,0)+365;
                info.n_profiles=1165; %
                info.magvar=magdev(info.lat,info.lon); %2000 magdev from Visbeck; mhatoolbox/visbeck_ladcp
                
                info.CTDsensor=CTDsensorinfo_MP('1369');
                info.VELsensor=VELsensorinfo_MP('1711');
                
                %ballast (T,S,rho, P)
                info.ballast=ballastFCN(3.9722,34.544,1032.5,1100); %103
                
                info.comments={''};
                info.station='MP1';
                info.experiment='Philex';
            otherwise,
                error(['I don''t show S/N ' sn ' as deployed during ' cruise '.'])
        end %philex07
        
    case 'mc09' %mc09
        switch sn
            case '101', %
                info.lat=36+46.546/60; %planned
                info.lon=-121-55.400/60;
                info.H=489;
                info.dates={'2/17/09-4/16/2009'};
                info.dt=1/24; %40-min
                info.pmin=45;
                info.pmax=475;
                
                info.year=2009;
                info.start_yday=yearday(19,2,2009,0,0,0); %
                info.end_yday=yearday(1,3,2009,0,0,0);
                info.n_profiles=260; %
                info.magvar=magdev(info.lat,info.lon); %2000 magdev from Visbeck; mhatoolbox/visbeck_ladcp
                
                info.CTDsensor=CTDsensorinfo_MP('1361');
                info.VELsensor=VELsensorinfo_MP('1668');
                
                %ballast (T,S,rho, P)
                info.ballast=ballastFCN(7.58,34.0412,1027.8,270);
                info.comments={'Recovered 4/16/09.  Battery voltage 0 on recovery.   Profiler stopped during profile 261.'};
                info.station='MP1';
                info.experiment='MontereyCanyon';
            case '102', %
                info.lat=36+47.232/60; %actual
                info.lon=-121-53.583/60;
                info.H=363.5;
                info.dates={'2/17/09-4/16/2009'};
                info.dt=.67/24; %40-min
                info.pmin=45;
                info.pmax=345;
                
                info.year=2009;
                info.start_yday=yearday(19,2,2009,0,0,0); %
                info.end_yday=yearday(16,4,2009,0,0,0);
                info.n_profiles=2068; %
                info.magvar=magdev(info.lat,info.lon); %2000 magdev from Visbeck; mhatoolbox/visbeck_ladcp
                
                info.CTDsensor=CTDsensorinfo_MP('1368');
                info.VELsensor=VELsensorinfo_MP('1710');
                
                %ballast (T,S,rho, P)
                info.ballast=ballastFCN(8.27,33.9568,1027.4,206); %102
                
                info.comments={'HOBO t-chain above.'};
                info.station='MP2';
                info.experiment='MontereyCanyon';
            case '103', %
                info.lat=36+47.433/60; %actual
                info.lon=-121-52.038/60;
                info.H=287.7;
                info.dates={'2/17/09-4/16/2009'};
                info.dt=.5/24; %
                info.pmin=45;
                info.pmax=270;
                
                info.year=2009;
                info.start_yday=yearday(19,2,2009,0,0,0); %
                info.end_yday=yearday(16,4,2009,0,0,0);
                info.n_profiles=2760; %
                info.magvar=magdev(info.lat,info.lon); %2000 magdev from Visbeck; mhatoolbox/visbeck_ladcp
                
                info.CTDsensor=CTDsensorinfo_MP('1369');
                info.VELsensor=VELsensorinfo_MP('1711');
                
                %ballast (T,S,rho, P)
                info.ballast=ballastFCN(8.7105,33.82,1027.0,168); %103
                
                info.comments={''};
                info.station='MP3';
                info.experiment='MontereyCanyon';
            otherwise,
                error(['I don''t show S/N ' sn ' as deployed during ' cruise '.'])
        end %mc09
    case 'mendo09' %mendo09
        switch sn
            case '105', %
                info.lat=40+19.204/60; %actual
                info.lon=-126-3.516/60;
                info.H=3700;
                info.dates={'2/20/09-4/29/09'};
                info.dt=1.5/24; %
                info.pmin=2240;
                info.pmax=3700; %bottom stopper at 443
                
                info.year=2009;
                info.start_yday=yearday(20,2,2009,20,0,0);
                info.end_yday=yearday(28,4,2009,0,0,0);
                info.n_profiles=926;%
                info.magvar=magdev(info.lat,info.lon); %2000 magdev from Visbeck; mhatoolbox/visbeck_ladcp
                
                info.CTDsensor=CTDsensorinfo_MP('SBE-MP52-026');
                info.VELsensor=VELsensorinfo_MP('1869');
                
                %ballast (T,S,rho, P)
                info.ballast=ballastFCN(1.5639,34.6519,1040.5,2790);
                info.comments={'bottom'};
                info.station='M1';
                info.experiment='MendocinoEscarpment';
            case '104',
                info.lat=40+19.204/60; %actual
                info.lon=-126-3.516/60;ontere
                info.H=3700;
                info.dates={'2/20/09-4/29/09'};
                info.dt=1.5/24; %
                info.pmin=1010;
                info.pmax=2170;
                info.year=2009;
                info.start_yday=yearday(20,2,2009,20,0,0);
                info.end_yday=yearday(28,4,2009,0,0,0);
                info.n_profiles=828;%
                info.magvar=magdev(info.lat,info.lon); %2000 magdev from Visbeck; mhatoolbox/visbeck_ladcp
                
                info.CTDsensor=CTDsensorinfo_MP('SBE-MP52-002');
                info.VELsensor=VELsensorinfo_MP('1845');%1845
                
                info.ballast=ballastFCN(2.7142,34.5484,1034.90,1590);%fill in
                % http://www.ecy.wa.gov/apps/eap/marinewq/mwdataset.asp?ec=no&scrolly=0&htmlcsvpref=csv&estuarycode=1&staID=67&theyear=2000&themonth=10
                %Using Apr 2002, I get 9.98, 29.98, 1023.43.
                info.comments={'bottom'};
                info.station='M1';
                info.experiment='MendocinoEscarpment';
            otherwise,
                error(['I don''t show S/N ' sn ' as deployed during ' cruise '.'])
        end %mendo09
        
    case 'ttp09' %ttp09
        switch sn
            case '101', %
                info.lat=47+28.534/60; %Actual.
                info.lon=-122-23.734/60;
                info.H=187.5;
                info.dates={'12/4/09-12/7/09'};
                info.dt=0; %continuous
                info.pmin=52; %top stopper at 35
                info.pmax=95; %bottom stopper at 443
                
                info.year=2009;
                info.start_yday=yearday(5,12,2009,0,0,0); %
                info.end_yday=yearday(5,12,2009,0,0,0);
                info.n_profiles=591; %
                info.magvar=magdev(info.lat,info.lon); %2000 magdev from Visbeck; mhatoolbox/visbeck_ladcp
                
                info.CTDsensor=CTDsensorinfo_MP('1361');
                info.VELsensor=VELsensorinfo_MP('1668');
                
                %ballast (T,S,rho, P)
                info.ballast=ballastFCN(11.42,30.1609,1023.2,50); %50,30.1609,11.42, 1023.20
                
                info.comments={'50 cm/s profile speed.'};
                info.station='MP-N';
            case '103', %
                info.lat=47+25.608/60;
                info.lon=-122-23.2/60;
                info.H=193;
                info.dates={'12/4/09-12/7/09'};
                info.dt=0; %
                info.pmin=42;
                info.pmax=174;
                
                info.year=2009;
                info.start_yday=yearday(5,12,2009,0,0,0); %
                info.end_yday=yearday(5,12,2009,0,0,0);
                info.n_profiles=284; %
                info.magvar=magdev(info.lat,info.lon); %2000 magdev from Visbeck; mhatoolbox/visbeck_ladcp
                
                info.CTDsensor=CTDsensorinfo_MP('1369');
                info.VELsensor=VELsensorinfo_MP('1711');
                
                %ballast (T,S,rho, P)
                info.ballast=ballastFCN(11.42,30.1609,1023.2,50); %50,30.1609,11.42, 1023.20
                
                info.comments={''};
                info.station='MP-S';
            otherwise,
                error(['I don''t show S/N ' sn ' as deployed during ' cruise '.'])
        end %ttp09
        
    case 'ps10a' %HOT profiler, Puget Sound test 1
        info.experiment='HOT';
        switch sn
            case '100',
                info.lat=47+43.373/60;
                info.lon=-122 - 23.660/60;
                info.H=168;
                info.dates={'3/31/10-4/6/10'};
                info.pmin=35;
                info.pmax=150;
                info.dt=0;
                
                info.n_profiles=458;
                info.year=2010;
                info.start_yday=yearday(31,3,2010);
                info.end_yday=yearday(6,4,2010);
                
                info.magvar=magdev(info.lat,info.lon); %2000 magdev from Visbeck; mhatoolbox/visbeck_ladcp
                
                info.CTDsensor=CTDsensorinfo_MP('SBE-MP52-026');%WRONG - fill in later
                info.VELsensor=VELsensorinfo_MP('1605'); %WRONG - fill in later
                
                info.totdist=NaN; %From depth_history
                info.ballast=ballastFCN(9,29.5,1023.3,100); %
                info.ballast.comments='Never ballasted.';
                info.comments={'First Puget Sound test.  Using 400 profiles to 120 m, 14 profiles to 150 m.'};
            otherwise,
                error(['I don''t show S/N ' sn ' as deployed during ' cruise '.'])
        end %end ps10a
    case 'ps10c' %HOT profiler, Puget Sound test 3
        info.experiment='HOT';
        switch sn
            case '100',
                info.lat=47+43.373/60;
                info.lon=-122 - 23.660/60;
                info.H=168;
                info.dates={'5/10/10-5/14/10'};
                info.pmin=35;
                info.pmax=150;
                info.dt=0;
                
                info.n_profiles=332;
                info.year=2010;
                info.start_yday=yearday(31,3,2010);
                info.end_yday=yearday(6,4,2010);
                
                info.magvar=magdev(info.lat,info.lon); %2000 magdev from Visbeck; mhatoolbox/visbeck_ladcp
                
                info.CTDsensor=CTDsensorinfo_MP('SBE-MP52-026');%WRONG - fill in later
                info.VELsensor=VELsensorinfo_MP('1605'); %WRONG - fill in later
                
                info.totdist=NaN; %From depth_history
                info.ballast=ballastFCN(9,29.5,1023.3,100); %
                info.ballast.comments='Ballast adjusted after previous test';
                info.comments={'Third Puget Sound test.  Using 400 profiles to 120 m, 14 profiles to 150 m.'};
                info.station='M1';                
            otherwise,
                error(['I don''t show S/N ' sn ' as deployed during ' cruise '.'])
        end %end ps10a
        
    case 'mp_aqdp10' %ttp09
        switch sn
            case '101', %
                info.lat=47+43.341/60; %Actual.
                info.lon=-122-23.464/60;
                info.H=156;
                info.dates={'6/17/10-6/18/10'};
                info.dt=0; %continuous
                info.pmin=35; %top stopper at 35
                info.pmax=145; %bottom stopper at 145
                
                info.year=2010;
                info.start_yday=yearday(5,12,2009,0,0,0); %
                info.end_yday=yearday(5,12,2009,0,0,0);
                info.n_profiles=90; %
                info.magvar=magdev(info.lat,info.lon); %2000 magdev from Visbeck; mhatoolbox/visbeck_ladcp
                
                info.CTDsensor=CTDsensorinfo_MP('1361');
                info.VELsensor=VELsensorinfo_MP('1668');
                
                %ballast (T,S,rho, P)
                info.ballast=ballastFCN(11.42,30.1609,1023.2,50); %50,30.1609,11.42, 1023.20
                
                info.comments={''};
                info.station='MP';
            otherwise,
                error(['I don''t show S/N ' sn ' as deployed during ' cruise '.'])
        end  %end mp_adqd10
    case 'mp_aqdp12' %
        info.experiment='PugetSound';
        switch sn
            case '107', %
                info.lat=47+43.4/60; %
                info.lon=-122-24/60;
                info.H=180.5;
                info.dates={'2/4/12-2/14/12'};
                info.dt=0; %continuous
                info.pmin=39; %top stopper
                info.pmax=167; %bottom stopper
                
                info.year=2012;
                info.start_yday=yearday(4,2,2012,0,0,0); %
                info.end_yday=yearday(16,2,2012,0,0,0);
                info.n_profiles=519; %
                info.magvar=magdev(info.lat,info.lon); %2000 magdev from Visbeck; mhatoolbox/visbeck_ladcp
                
                info.CTDsensor=CTDsensorinfo_MP('1361'); %wrong
                info.VELsensor=VELsensorinfo_MP('1668'); %wrong
                
                %ballast (T,S,rho, P)
                info.ballast=ballastFCN(11.42,30.1609,1023.2,50); %50,30.1609,11.42, 1023.20
                
                info.comments={''};
                info.station='M1';
            otherwise,
                error(['I don''t show S/N ' sn ' as deployed during ' cruise '.'])
        end  %end mp_adqd10
    case 'iwise10' %iwise10
                info.experiment='IWISE';
        switch sn
            case '102', %
                info.lat=19+48.971/60; %actual
                info.lon=120+30.079/60;
                info.H=3698;
                info.dates={'8/17/10-9/2/2010'};
                info.dt=0; %continuous
                info.pmin=90;
                info.pmax=1277;
                
                info.year=2010;
                info.start_yday=yearday(17,8,2010,4,0,0); %
                info.end_yday=yearday(2,9,2010,0,0,0);
                info.n_profiles=312; %
                info.magvar=magdev(info.lat,info.lon); %2000 magdev from Visbeck; mhatoolbox/visbeck_ladcp
                
                info.CTDsensor=CTDsensorinfo_MP('1368');
                info.VELsensor=VELsensorinfo_MP('1710');
                
                %ballast (T,S,rho, P)
                info.ballast=ballastFCN(3.4,34.3,1030.9,750); %102
                info.comments={''};
                info.station='MP-S';
            case '103', %
                info.lat=20+36.222/60;  %actual
                info.lon=121+19.924/60;
                info.H=3666;
                info.dates={'8/17/10-9/6/2010'};
                info.dt=0; %
                info.pmin=90;
                info.pmax=1580;
                
                info.year=2010;
                info.start_yday=yearday(15,8,2010,10,0,0); %
                info.end_yday=yearday(6,9,2010,0,0,0);
                info.n_profiles=663; %
                info.magvar=magdev(info.lat,info.lon); %2000 magdev from Visbeck; mhatoolbox/visbeck_ladcp
                
                info.CTDsensor=CTDsensorinfo_MP('1369');
                info.VELsensor=VELsensorinfo_MP('1711');
                
                %ballast (T,S,rho, P)
                info.ballast=ballastFCN(3.4,34.3,1030.9,750); %103
                
                info.comments={''};
                info.station='MP-N';
            otherwise,
                error(['I don''t show S/N ' sn ' as deployed during ' cruise '.'])
        end %iwise10
    case 'iwise11' %iwise11
                info.experiment='IWISE';
        switch sn
            case 'H02', %
                info.lat=19+20.147/60; %actual
                info.lon=121+1.839/60;
                info.H=2286;
                info.dates={'6/17/2011-8/6/2011'};
                info.dt=1.5;
                info.pmin=1298;
                info.pmax=2230;
                
                info.year=2011;
                info.start_yday=yearday(17,6,2011,0,0,0); %
                info.end_yday=yearday(6,8,2011,0,0,0);
                info.n_profiles=798; %
                info.magvar=magdev(info.lat,info.lon); %2000 magdev from Visbeck; mhatoolbox/visbeck_ladcp
                
                info.CTDsensor=CTDsensorinfo_MP('1368'); %FILL IN CORRECT VALUE
                info.VELsensor=VELsensorinfo_MP('1710'); %FILL IN CORRECT VALUE
                
                %ballast (T,S,rho, P)
                info.ballast=ballastFCN(2.66,34.6,1035.7,1753); %H02
                info.comments={'bottom'};
                info.station='S9';
            case 'H04', %
                info.lat=19+20.147/60; %actual
                info.lon=121+1.839/60;
                info.H=2286;
                info.dates={'6/17/2011-8/6/2011'};
                info.dt=1.5;
                info.pmin=329;
                info.pmax=1257;
                
                info.year=2011;
                info.start_yday=yearday(17,6,2011,0,0,0); %
                info.end_yday=yearday(6,8,2011,22,0,0);
                info.n_profiles=814; %
                info.magvar=magdev(info.lat,info.lon); %2000 magdev from Visbeck; mhatoolbox/visbeck_ladcp
                
                info.CTDsensor=CTDsensorinfo_MP('1368'); %FILL IN CORRECT VALUE
                info.VELsensor=VELsensorinfo_MP('1710'); %FILL IN CORRECT VALUE
                
                %ballast (T,S,rho, P)
                info.ballast=ballastFCN(5.75,34.46,1030.81,798); %H04
                info.comments={'top'};
                info.station='S9';
            case '101', %
                info.lat=20+35.624/60;  %actual
                info.lon=120+51.012/60;
                info.H=2022;
                info.dates={'6/14/2011-7/30/2011'};
                info.dt=0; %
                info.pmin=327;
                info.pmax=1160;
                
                info.year=2011;
                info.start_yday=yearday(14,6,2011,12,0,0); %
                info.end_yday=yearday(30,7,2011,0,0,0);
                info.n_profiles=783;%879;%663; %
                info.magvar=magdev(info.lat,info.lon); %2000 magdev from Visbeck; mhatoolbox/visbeck_ladcp
                
                info.CTDsensor=CTDsensorinfo_MP('1369'); %FILL IN NEW CTD VALUES
                info.VELsensor=VELsensorinfo_MP('1711'); %FILL IN CORRECT VALUES
                
                %ballast (T,S,rho, P)
                info.ballast=ballastFCN(6.15,34.46,1030.52,748); %101
                
                info.comments={'top'};
                info.station='N1';
            case '103', %
                info.lat=20+35.386/60;  %actual
                info.lon=121+1.451/60;
                info.H=1808;
                info.dates={'6/13/2011-8/15/2011'};
                info.dt=1.5; %
                info.pmin=1130;
                info.pmax=1815;
                
                info.year=2011;
                info.start_yday=yearday(13,6,2011,12,0,0); %
                info.end_yday=yearday(15,8,2011,0,0,0);
                info.n_profiles=1003;%
                info.magvar=magdev(info.lat,info.lon); %2000 magdev from Visbeck; mhatoolbox/visbeck_ladcp
                
                info.CTDsensor=CTDsensorinfo_MP('1369'); %FILL IN NEW CTD VALUES
                info.VELsensor=VELsensorinfo_MP('1711'); %FILL IN CORRECT VALUES
                
                %ballast (T,S,rho, P)
                info.ballast=ballastFCN(2.97,34.58,1034.33,1131); %103
                
                info.comments={'bottom'};
                info.station='N2';
            case 'J03', %
                info.lat=20+35.98/60;  %actual
                info.lon=121+19.672/60;
                info.H=3652;
                info.dates={'6/14/2011-7/30/2011'};
                info.dt=0; %
                info.pmin=90;
                info.pmax=1580;
                
                info.year=2010;
                info.start_yday=yearday(14,6,2011,12,0,0); %
                info.end_yday=yearday(30,7,2011,0,0,0);
                info.n_profiles=11; %
                info.magvar=magdev(info.lat,info.lon); %2000 magdev from Visbeck; mhatoolbox/visbeck_ladcp
                
                info.CTDsensor=CTDsensorinfo_MP('1369');%FILL IN CORRECT VALUES
                info.VELsensor=VELsensorinfo_MP('1711');%FILL IN CORRECT VALUES
                
                %ballast (T,S,rho, P)
                info.ballast=ballastFCN(3.43,34.56,1033.17,1033); %J03
                
                info.comments={'top'};
                info.station='MPN';
            otherwise,
                error(['I don''t show S/N ' sn ' as deployed during ' cruise '.'])
        end %iwise11

    case 'hot11a' %HOT profiler
        info.experiment='HOT';
        switch sn
            case '100',
                info.lat=22+44.800/60;
                info.lon=-158 - 01.455/60;
                info.H=4748;
                info.dates={'10/13/10-10/15/10'};
                info.pmin=110;
                info.pmax=1500;
                info.dt=0;
                
                info.n_profiles=46;
                info.year=2010;
                info.start_yday=yearday(13,10,2010);
                info.end_yday=yearday(15,10,2010);
                
                info.magvar=magdev(info.lat,info.lon); %2000 magdev from Visbeck; mhatoolbox/visbeck_ladcp
                
                info.CTDsensor=CTDsensorinfo_MP('SBE-MP52-026');%WRONG - fill in later
                info.VELsensor=VELsensorinfo_MP('1605'); %WRONG - fill in later
                
                info.totdist=NaN; %From depth_history
                info.ballast=ballastFCN(9,29.5,1023.3,100); %
                info.ballast.comments='Never ballasted.';
                info.comments={'HOT redeploy, 10/13/2010'};
                info.station='M1';
            otherwise,
                error(['I don''t show S/N ' sn ' as deployed during ' cruise '.'])
        end %end hot11a
    case 'hot10b' %HOT profiler, October deployment, 3.5 days before battery died
        info.experiment='HOT';
        switch sn
            case '100',
                info.lat=22+44.985/60;
                info.lon=-158 - 1.497/60;
                info.H=4748;
                info.dates={'10/17/10-10/20/11'};
                info.pmin=100;
                info.pmax=1500;
                info.dt=0;
                
                info.n_profiles=46;
                info.year=2010;
                info.start_yday=yearday(17,10,2010);
                info.end_yday=yearday(20,10,2010);
                
                info.magvar=magdev(info.lat,info.lon); %2000 magdev from Visbeck; mhatoolbox/visbeck_ladcp
                
                info.CTDsensor=CTDsensorinfo_MP('SBE-MP52-026');%WRONG - fill in later
                info.VELsensor=VELsensorinfo_MP('1605'); %WRONG - fill in later
                
                info.totdist=NaN; %From depth_history
                info.ballast=ballastFCN(4.877,34.312,1030.6,750); %%34.312, 4.877, 1.0306, 750

                info.ballast.comments='Ballasted in June 2010.';
                info.comments={'3.5 day deployment. No charging since battery sphere imploded.'};
                info.station='M1';
            otherwise,
                error(['I don''t show S/N ' sn ' as deployed during ' cruise '.'])
        end %end hot10b
    case 'hot12' %HOT profiler, final 2012 deployment
        info.experiment='HOT';
        switch sn
            case '100',
                info.lat=22+44.985/60;
                info.lon=-158 - 1.497/60;
                info.H=4748;
                info.dates={'7/12'};
                info.pmin=100;
                info.pmax=1500;
                info.dt=0;
                
                info.n_profiles=119;
                info.year=2012;
                info.start_yday=yearday(1,7,2012);
                info.end_yday=yearday(16,7,2012);
                
                info.magvar=magdev(info.lat,info.lon); %2000 magdev from Visbeck; mhatoolbox/visbeck_ladcp
                
                info.CTDsensor=CTDsensorinfo_MP('SBE-MP52-026');%WRONG - fill in later
                info.VELsensor=VELsensorinfo_MP('1605'); %WRONG - fill in later
                
                info.totdist=NaN; %From depth_history
                info.ballast=ballastFCN(4.877,34.312,1030.6,750); %%34.312, 4.877, 1.0306, 750

                info.ballast.comments='Ballasted in June 2010.';
                info.comments={'Short deployment (9 days?)'};
                info.station='M1';
            otherwise,
                error(['I don''t show S/N ' sn ' as deployed during ' cruise '.'])
        end %end hot12

    case 'nemo11a' %NEMO-SS
        switch sn
            case '106',
                info.lat=47.9642;
                info.lon=-124.9483;
                info.H=100;
                info.dates={'15/22/11-5/23/11'};
                info.pmin=19;
                info.pmax=83;
                info.dt=2/24;
                
                info.n_profiles=21;
                info.year=2011;
                info.start_yday=yearday(22,5,2011);
                info.end_yday=yearday(23,5,2011);
                
                info.magvar=magdev(info.lat,info.lon); %2000 magdev from Visbeck; mhatoolbox/visbeck_ladcp
                
                info.CTDsensor=CTDsensorinfo_MP('SBE-MP52-026');%WRONG - fill in later
                info.VELsensor=VELsensorinfo_MP('1605'); %WRONG - fill in later
                
                info.totdist=NaN; %From depth_history
                info.ballast=ballastFCN(7.5,33,1025.8,54); %
                info.ballast.comments='ballast at McLane.';
                info.comments={'1 day deployment, recovered since no inductive comms.'};
                info.experiment='NEMO';
                info.station='NEMO-SS';
            otherwise,
                error(['I don''t show S/N ' sn ' as deployed during ' cruise '.'])
        end %end nemo11a
    case 'nemo11b' %NEMO-SS
        switch sn
            case '106',
                info.lat=47.9642;
                info.lon=-124.9483;
                info.H=100;
                info.dates={'8/14/11-9/24/11'};
                info.pmin=19;
                info.pmax=83;
                info.dt=2/24;
                
                info.n_profiles=1128;
                info.year=2011;
                info.start_yday=yearday(14,8,2011);
                info.end_yday=yearday(24,9,2011);
                
                info.magvar=magdev(info.lat,info.lon); %2000 magdev from Visbeck; mhatoolbox/visbeck_ladcp
                
                info.CTDsensor=CTDsensorinfo_MP('SBE-MP52-026');%WRONG - fill in later
                info.VELsensor=VELsensorinfo_MP('1605'); %WRONG - fill in later
                
                info.totdist=NaN; %From depth_history
                info.ballast=ballastFCN(7.5,33,1025.8,54); %
                info.ballast.comments='ballast at McLane.';
                info.comments={'2nd deployment of NEMO-SS.'};
                info.station='NEMO-SS';
                info.experiment='NEMO';
            otherwise,
                error(['I don''t show S/N ' sn ' as deployed during ' cruise '.'])
        end %end nemo11b
    case 'nemo12' %NEMO-SS
        switch sn
            case '106',
                info.lat=47.9642;
                info.lon=-124.9483;
                info.H=100;
                info.dates={'5/12-10/12'};
                info.pmin=19;
                info.pmax=83;
                info.dt=2/24;
                
                info.n_profiles=2206;
                info.year=2012;
                info.start_yday=yearday(14,8,2011);
                info.end_yday=yearday(24,9,2011);
                
                info.magvar=magdev(info.lat,info.lon); %2000 magdev from Visbeck; mhatoolbox/visbeck_ladcp
                
                info.CTDsensor=CTDsensorinfo_MP('SBE-MP52-026');%Actually correct.
                info.VELsensor=VELsensorinfo_MP('1605'); %WRONG - fill in later
                
                info.totdist=NaN; %From depth_history
                info.ballast=ballastFCN(7.5,33,1025.8,54); %
                info.ballast.comments='appeared to be ';
                info.comments={'3nd deployment of NEMO-SS.'};
                info.station='NEMO-SS';
                info.experiment='NEMO';
            otherwise,
                error(['I don''t show S/N ' sn ' as deployed during ' cruise '.'])
        end %end nemo12
    case 'sp12' %SP12
        switch sn
            case '105',
                info.lat=-9-55.098/60;
                info.lon=-169-44.346/60;
                info.H=5227;
                info.dates={'7/24/2012-8/17/2012'};
                info.pmin=3600;
                info.pmax=5285;
                info.dt=0;
                
                info.n_profiles=327;
                info.year=2012;
                info.start_yday=yearday(24,7,2012,0,0,0);
                info.end_yday=yearday(17,8,2012,0,0,0);
                
                info.magvar=magdev(info.lat,info.lon); %2000 magdev from Visbeck; mhatoolbox/visbeck_ladcp
                
                info.CTDsensor=CTDsensorinfo_MP('SBE-MP52-026');%
                info.VELsensor=VELsensorinfo_MP('1605'); %
                
                info.totdist=NaN; %From depth_history
                info.ballast=ballastFCN(1.42,34.69,1045.8,3988); %
                info.ballast.comments='differential ballast from last deployment in MENDO.';
                info.comments={''};
                info.station='P1';
                info.experiment='SamoanPassage';
            case '104',
                info.lat=-9-38.634/60;
                info.lon=-169-48.966/60;
                info.H=4659;
                info.dates={'7/23/2012-8/17/2012'};
                info.pmin=3400;
                info.pmax=4701;
                info.dt=0;
                
                info.n_profiles=nan;
                info.year=2012;
                info.start_yday=yearday(23,7,2012);
                info.end_yday=yearday(17,8,2012);
                
                info.magvar=magdev(info.lat,info.lon); %2000 magdev from Visbeck; mhatoolbox/visbeck_ladcp
                
                info.CTDsensor=CTDsensorinfo_MP('SBE-MP52-026');%
                info.VELsensor=VELsensorinfo_MP('1605'); %
                
                info.totdist=NaN; %From depth_history
                info.ballast=ballastFCN(1.42,34.69,1045.8,3988); %
                info.ballast.comments='tank ballast at APL.';
                info.comments={''};
                info.station='P2';
                info.experiment='SamoanPassage';
            case '103',
                info.lat=-9-5.424/60;
                info.lon=-169-30.21/60;
                info.H=4582;
                info.dates={'7/25/2012-8/18/2012'};
                info.pmin=3600;
                info.pmax=4622;
                info.dt=0;
                
                info.n_profiles=457;
                info.year=2012;
                info.start_yday=yearday(25,7,2012,0,0,0);
                info.end_yday=yearday(18,8,2012,0,0,0);
                
                info.magvar=magdev(info.lat,info.lon); %2000 magdev from Visbeck; mhatoolbox/visbeck_ladcp
                
                info.CTDsensor=CTDsensorinfo_MP('SBE-MP52-026');%
                info.VELsensor=VELsensorinfo_MP('1605'); %
                
                info.totdist=NaN; %From depth_history
                info.ballast=ballastFCN(1.42,34.69,1045.8,3988); %
                info.ballast.comments='tank ballast at APL.';
                info.comments={''};
                info.station='P3';
                info.experiment='SamoanPassage';
            case '101',
                info.lat=-8-59.568/60;
                info.lon=-168 - 55.242/60;
                info.H=4664;
                info.dates={'7/25/2012-8/17/2012'};
                info.pmin=3600;
                info.pmax=4911;
                info.dt=0;
                
                info.n_profiles=231;
                info.year=2012;
                info.start_yday=yearday(25,7,2012,0,0,0);
                info.end_yday=yearday(9,8,2012,0,0,0);
                
                info.magvar=magdev(info.lat,info.lon); %2000 magdev from Visbeck; mhatoolbox/visbeck_ladcp
                
                info.CTDsensor=CTDsensorinfo_MP('SBE-MP52-026');%
                info.VELsensor=VELsensorinfo_MP('1605'); %
                
                info.totdist=300000; %From depth_history
                info.ballast=ballastFCN(1.42,34.69,1045.8,3988); %
                info.ballast.comments='differential ballast from IWISE.';
                info.comments={'Data recovered from card after sphere imploded.'};
                info.station='P4';
                info.experiment='SamoanPassage';
            case '107',
                info.lat=-8-13.710/60;
                info.lon=-168-40.590/60;
                info.H=4925;
                info.dates={'7/26/2012-8/21/2012'};
                info.pmin=3600;
                info.pmax=4974;
                info.dt=0;
                
                info.n_profiles=525;
                info.year=2012;
                info.start_yday=yearday(26,7,2012);
                info.end_yday=yearday(21,8,2012);
                
                info.magvar=magdev(info.lat,info.lon); %2000 magdev from Visbeck; mhatoolbox/visbeck_ladcp
                
                info.CTDsensor=CTDsensorinfo_MP('SBE-MP52-026');%
                info.VELsensor=VELsensorinfo_MP('1605'); %
                
                info.totdist=NaN; %From depth_history
                info.ballast=ballastFCN(1.42,34.69,1045.8,3988); %
                info.ballast.comments='tank ballast at APL.';
                info.comments={''};
                info.station='P5';
                info.experiment='SamoanPassage';
            otherwise,
                error(['I don''t show S/N ' sn ' as deployed during ' cruise '.'])
        end %end nemo11b
        
    case 'sp12monitor' %SP12monitor
        switch sn
            case '104',
                info.lat=-9-5.448/60;
                info.lon=-169 - 30.180/60;
                info.H=4582;
                info.dates={'8/24/2012-1/12/2014'};
                info.pmin=3600;
                info.pmax=4622;
                info.dt=17/24+24/60/24; %17:24 interval
                
                info.n_profiles=nan;
                info.year=2012;
                info.start_yday=yearday(23,8,2012);
                info.end_yday=yearday(12,1,2014)+365+365;
                
                info.magvar=magdev(info.lat,info.lon); %2000 magdev from Visbeck; mhatoolbox/visbeck_ladcp
                
                info.CTDsensor=CTDsensorinfo_MP('SBE-MP52-026');%
                info.VELsensor=VELsensorinfo_MP('1605'); %
                
                info.totdist=NaN; %From depth_history
                info.ballast=ballastFCN(1.42,34.69,1045.8,3988); %
                info.ballast.comments='tank ballast at APL; redeployed during SP12';
                info.comments={''};
                info.station='M7';
                info.experiment='SamoanPassage';
            case '103',
                info.lat=-9-38.664/60;
                info.lon=-169-48.924/60;
                info.H=4582;
                info.dates={'8/25/2012-1/12/2014'};
                info.pmin=3400;
                info.pmax=4701;
                info.dt=17/24+24/60/24; %17-hour 24 minute profile interval
                
                info.n_profiles=696;
                info.year=2012;
                info.start_yday=yearday(25,8,2012,0,0,0);
                info.end_yday=yearday(12,1,2014,0,0,0)+365+365;
                
                % Model Used: 	IGRF12
                % Latitude: 	9.6444° S
                % Longitude: 	169.8154° W
                % Date 	Declination
                % 2013-03-01 	10.64° E  changing by  0.02° E per year 
                info.magvar=10.64;
                
                info.CTDsensor=CTDsensorinfo_MP('SBE-MP52-026');%CHECK
                info.VELsensor=VELsensorinfo_MP('1605'); %CHECK
                
                info.totdist=NaN; %From depth_history
                info.ballast=ballastFCN(1.42,34.69,1045.8,3988); %CHECK
                info.ballast.comments='Tank ballast at APL; redeployed during SP12';
                info.comments={''};
                info.station='M5';
                info.experiment='SamoanPassage';
            case '107',
                info.lat=-8-13.674/60;
                info.lon=-168-40.620/60;
                info.H=4925;
                info.dates={'8/23/2012-1/13/2014'};
                info.pmin=3600;
                info.pmax=4974;
                info.dt=17/24+24/60/24; %17-hour 24 minute profile interval;
                
                info.n_profiles=697;
                info.year=2012;
                info.start_yday=yearday(25,8,2012);
                info.end_yday=yearday(13,1,2014)+365+365;
                
                info.magvar=magdev(info.lat,info.lon); %2000 magdev from Visbeck; mhatoolbox/visbeck_ladcp
                
                info.CTDsensor=CTDsensorinfo_MP('SBE-MP52-026');%
                info.VELsensor=VELsensorinfo_MP('1605'); %
                
                info.totdist=NaN; %From depth_history
                info.ballast=ballastFCN(1.42,34.69,1045.8,3988); %
                info.ballast.comments='';
                info.comments={''};
                info.station='M6';
                info.experiment='SamoanPassage';
            otherwise,
                error(['I don''t show S/N ' sn ' as deployed during ' cruise '.'])
        end %end sp12monitor
        
    
    case 'sp14' % SP14
      switch sn
        case '104', %104 is deployed on T1 and will likely not be redeployed during SP14 but I keep the mooring switch for consistency
          switch mooring
            case 'T1',
              info.lat = -8-15.320/60; %surveyed
              info.lon = -168 - 43.711/60;
              info.H   = 5063;
              info.dates = {'1/18/2014-2/4/2014'};
              info.pmin = 4000;
              info.pmax = 5113;
              info.dt = 0; %continuous

              info.n_profiles=201;
              info.year=2014;
              info.start_yday=yearday(18,1,2014,5,0,0);
              info.end_yday=yearday(4,2,2014,4,0,0);
              
              % http://www.ngdc.noaa.gov/geomag-web/#declination
              % Model Used: 	IGRF12
              % Latitude: 	8.2553° S
              % Longitude: 	168.7285° W
              % Date 	Declination
              % 2015-01-25 	10.41° E  changing by  0.03° E per year 
              info.magvar=10.41;

              info.CTDsensor=CTDsensorinfo_MP('SBE-MP52-026');%
              info.VELsensor=VELsensorinfo_MP('1605'); %

              info.totdist=NaN; %From depth_history
              info.ballast=ballastFCN(1.42,34.69,1045.8,3988); %
              info.ballast.comments='10 days of good data.  ACM had intermittent large noise spikes and zero K files after profile 185.  CTD had zeroK files after profile 201.  Cabling?';
              info.comments={'upstream mooring.'};
              info.station=mooring;
              info.experiment='SamoanPassage';              
            case 'T9',
              info.lat =   -9 - 36.061/60; %surveyed
              info.lon = -169 - 49.526/60;
              info.H = 4720;
              info.dates = {'2/6/2014-2/14/2014'};
              info.pmin = 3600;
              info.pmax = 4758;
              info.dt = 0; %continuous

              info.n_profiles = 119;
              info.year = 2014;
              info.start_yday = yearday(6,2,2014,20,0,0);
              info.end_yday=yearday(14,2,2014,1,0,0);
              
              % http://www.ngdc.noaa.gov/geomag-web/#declination
              % Model Used: 	IGRF12
              % Latitude: 	9.601° S
              % Longitude: 	169.8254° W
              % Date 	Declination
              % 2014-02-10 	10.65° E  changing by  0.02° E per year 
              info.magvar=10.65; %2000 magdev from Visbeck; mhatoolbox/visbeck_ladcp

              info.CTDsensor=CTDsensorinfo_MP('SBE-MP52-026');%
              info.VELsensor=VELsensorinfo_MP('1605'); %

              info.totdist=NaN; %From depth_history
              info.ballast=ballastFCN(1.42,34.69,1045.8,3988); %
              info.ballast.comments='Western of three downstream moorings at P2';
              info.comments={''};
              info.station=mooring;
              info.experiment='SamoanPassage';
          end
        case '103'
          switch mooring
            case 'T5'
              info.lat = -7-51.233/60; %surveyed
              info.lon = -168 - 38.282/60;
              info.H=5313;
              info.dates={'1/18/2014-2/3/2014'};
              info.pmin=4000;
              info.pmax=5369;
              info.dt=0; %continuous
              info.n_profiles=220;
              info.year=2014;
              info.start_yday=yearday(18,1,2014,6,0,0);
              info.end_yday=yearday(3,2,2014,20,0,0);

              % http://www.ngdc.noaa.gov/geomag-web/#declination
              % Model Used: 	IGRF12 	Help
              % Latitude: 	7.8539° S
              % Longitude: 	168.6380° W
              % Date 	Declination
              % 2015-01-25 	10.34° E  changing by  0.03° E per year 
              info.magvar= 10.34;

              info.CTDsensor=CTDsensorinfo_MP('SBE-MP52-026');%
              info.VELsensor=VELsensorinfo_MP('1605'); %

              info.totdist=NaN; %From depth_history
              info.ballast=ballastFCN(1.42,34.69,1045.8,3988); %
              info.ballast.comments='';
              info.comments={'downstream mooring at P5. Apparently successful.'};
              info.station=mooring;
              info.experiment='SamoanPassage';
          end
        case '107'
          switch mooring
            case 'T6'
              info.lat=-8-4.546/60; %surveyed
              info.lon=-168 - 36.808/60;
              info.H=5143;
              info.dates={'1/23/2012-2/4/2014'};
              info.pmin=4000;
              info.pmax=5195;
              info.dt=0; %continuous

              info.n_profiles=229;
              info.year=2014;
              info.start_yday=yearday(23,1,2014,20,0,0);
              info.end_yday=yearday(3,2,2014,23,0,0);

              % http://www.ngdc.noaa.gov/geomag-web/#declination
              % Model Used: 	IGRF12
              % Latitude: 	8.0758° S
              % Longitude: 	168.6135° W
              % Date 	Declination
              % 2014-01-25 	10.36° E  changing by  0.02° E per year 
              info.magvar=10.36;

              info.CTDsensor=CTDsensorinfo_MP('SBE-MP52-026');%
              info.VELsensor=VELsensorinfo_MP('1605'); %

              info.totdist=NaN; %From depth_history
              info.ballast=ballastFCN(1.42,34.69,1045.8,3988); %
              info.ballast.comments='new ballast at McLane';
              info.comments={'At P5 second sill.  Deployed with FSI ACM as AQDP does not have enough scatterers at depth.  Successful deployment but motor currents 500-600 mA on up, 50 mA on down.  Very heavy ballasting?'};
              info.station='T6';
              info.experiment='SamoanPassage';
            case 'T10'
              info.lat=-9-35.991/60; %surveyed
              info.lon=-169 - 48.689/60;
              info.H=4754;
              info.dates={'2/7/2012-2/14/2014'};
              info.pmin=3600;
              info.pmax=4794;
              info.dt=0; %continuous

              info.n_profiles=143;
              info.year=2014;
              info.start_yday=yearday(7,2,2014,6,0,0);
              info.end_yday=yearday(14,2,2014,5,0,0);

              % Model Used: 	IGRF12
              % Latitude: 	9.5998° S
              % Longitude: 	169.8115° W
              % Date 	Declination
              % 2014-02-10 	10.65° E  changing by  0.02° E per year 
              info.magvar=10.65;

              info.CTDsensor=CTDsensorinfo_MP('SBE-MP52-026');%
              info.VELsensor=VELsensorinfo_MP('1605'); %

              info.totdist=NaN; %From depth_history
              info.ballast=ballastFCN(1.42,34.69,1045.8,3988); %
              info.ballast.comments='Middle of three downstream moorings at P2';
              info.comments={''};
              info.station='T10';
              info.experiment='SamoanPassage';
          end
        case '108', %108 is deployed on T2 and again on T8
          switch mooring
            case 'T2',
              info.lat=-8- 12.670/60; %surveyed
              info.lon=-168 -41.430/60;
              info.H=4812;
              info.dates={'1/17/2014-1/27/2014'};
              info.pmin=4000;
              info.pmax=4853;
              info.dt=0; %continuous

              info.n_profiles=196;
              info.year=2014;
              info.start_yday=yearday(17,1,2014,17,0,0);
              info.end_yday=yearday(27,1,2014,23,0,0);

              info.magvar=magdev(info.lat,info.lon); %2000 magdev from Visbeck; mhatoolbox/visbeck_ladcp

              info.CTDsensor=CTDsensorinfo_MP('SBE-MP52-026');%
              info.VELsensor=VELsensorinfo_MP('1605'); %

              info.totdist=NaN; %From depth_history
              info.ballast=ballastFCN(1.42,34.69,1045.8,3988); %
              info.ballast.comments='Tank ballast at APL, air weight on ship, 5 blocks syntactic plus one lead round added';
              info.comments={'First deployment of ALOHA profiler as shortened/standard. Ballast way off and motor currents high; corrosion observed on pressure case and motor.  Motor bolts corroded away.'};
              info.station='T2';
              info.experiment='SamoanPassage';
            case 'T8'
              info.lat = -8-53.030/60; %surveyed. Same as target - right on target.
              info.lon = -168-55.113/60;
              info.H   = 4812;
              info.dates={'2/1/2014-2/5/2014'};
              info.pmin=3800;
              info.pmax=5025;
              info.dt=0; %continuous

              info.n_profiles=81;
              info.year=2014;
              info.start_yday=yearday(1,2,2014,4,0,0);
              info.end_yday=yearday(5,2,2014,6,0,0);
              
              % http://www.ngdc.noaa.gov/geomag-web/#declination
              % Model Used: 	IGRF12
              % Latitude: 	8.8838° S
              % Longitude: 	168.9186° W
              % Date 	Declination
              % 2015-02-03 	10.52° E  changing by  0.03° E per year 
              info.magvar = 10.52;

              info.CTDsensor=CTDsensorinfo_MP('SBE-MP52-026');%
              info.VELsensor=VELsensorinfo_MP('1605'); %

              info.totdist=NaN; %From depth_history
              info.ballast=ballastFCN(1.42,34.69,1045.8,3988); %
              info.ballast.comments='';
              info.comments={'Short test deployment with better ballasting to see if corrosion problem on T4 improved.'};
              info.station=mooring;
              info.experiment='SamoanPassage';
            case 'T12'
              info.lat=-9-40.651/60; %surveyed. Same as target - right on target.
              info.lon=-169-50.569/60;
              info.H=4923;
              info.dates={'2/8/2014-2/15/2014'};
              info.pmin=3400;
              info.pmax=4967;
              info.dt=0; %continuous

              info.n_profiles=106;
              info.year=2014;
              info.start_yday=yearday(7,2,2014,22,0,0);
              info.end_yday=yearday(14,2,2014,23,0,0);
              
              % http://www.ngdc.noaa.gov/geomag-web/#declination
              % Model Used: 	IGRF12
              % Latitude: 	9.6775° S
              % Longitude: 	169.8428° W
              % Date 	Declination
              % 2015-02-11 	10.68° E  changing by  0.03° E per year 
              info.magvar= 10.68;

              info.CTDsensor=CTDsensorinfo_MP('SBE-MP52-026');%
              info.VELsensor=VELsensorinfo_MP('1605'); %

              info.totdist=NaN; %From depth_history
              info.ballast=ballastFCN(1.42,34.69,1045.8,3988); %
              info.ballast.comments='';
              info.comments={'Upstream at P2'};
              info.station=mooring;
              info.experiment='SamoanPassage';
          end
        case '109'
          switch mooring
            case 'T3'
              info.lat=-8-12.240/60; %surveyed
              info.lon=-168 - 39.740/60;
              info.H=4949;
              info.dates={'1/17/2014-1/22/2014'};
              info.pmin=4000;
              info.pmax=4996;
              info.dt=0; %continuous

              info.n_profiles=135;
              info.year=2014;
              info.start_yday=yearday(17,1,2014,6,0,0);
              info.end_yday=yearday(22,1,2014,18,0,0);
              
              % http://www.ngdc.noaa.gov/geomag-web/#declination
              % Model Used: 	IGRF12
              % Latitude: 	8.2040° S
              % Longitude: 	168.6623° W
              % Date 	Declination
              % 2015-01-20 	10.40° E  changing by  0.03° E per year 
              info.magvar=10.40;

              info.CTDsensor=CTDsensorinfo_MP('SBE-MP52-026');%
              info.VELsensor=VELsensorinfo_MP('AQD11419'); %

              info.totdist=NaN; %From depth_history
              info.ballast=ballastFCN(1.42,34.69,1045.8,3988); %
              info.ballast.comments='new ballast at McLane';
              info.comments={'AQDP did not work well.  At P5 downstream of first sill'};
              info.station='T3';
              info.experiment='SamoanPassage';
          end
        case '105'
          switch mooring
            case 'T4'
              info.lat   = -8.1959;
              info.lon   = -168.6780;
              info.H     = 4949;
              info.dates = {'1/17/2014-1/28/2014'};
              info.pmin  = 4000;
              info.pmax  = 4996;
              info.dt    = 0;

              info.n_profiles = 274;
              info.year       = 2014;
              info.start_yday = yearday(17,1,2014,0,0,0);
              info.end_yday   = yearday(28,1,2014,1,0,0);

              % http://www.ngdc.noaa.gov/geomag-web/#declination
              % Model Used: 	IGRF12
              % Latitude: 	8.1959° S
              % Longitude: 	168.6780° W
              % Date 	Declination
              % 2015-01-20 	10.40° E  changing by  0.03° E per year 
              info.magvar = 10.4;

              info.CTDsensor = CTDsensorinfo_MP('SBE-MP52-026');%
              info.VELsensor = VELsensorinfo_MP('1605'); %

              info.totdist          = NaN; %From depth_history
              info.ballast          = ballastFCN(1.42,34.69,1045.8,3988); %
              info.ballast.comments = '';
              info.comments         = {''};
              info.station          = 'T4';
              info.experiment       = 'SamoanPassage';
            case 'T7'
              info.lat   = -8-58.431/60; %surveyed
              info.lon   = -169 -5.730/60;
              info.H     = 4917;
              info.dates = {'1/31/2014-2/5/2014'};
              info.pmin  = 4000;
              info.pmax  = 4964;
              info.dt    = 0; %continuous

              info.n_profiles=127;
              info.year=2014;
              info.start_yday=yearday(31,1,2014,0,0,0);
              info.end_yday=yearday(5,2,2014,1,0,0);

              % http://www.ngdc.noaa.gov/geomag-web/#declination
              % Model Used: 	IGRF12
              % Latitude: 	8.9739° S
              % Longitude: 	169.0955° W
              % Date 	Declination
              % 2015-02-10 	10.54° E  changing by  0.03° E per year 
              info.magvar=10.54;

              info.CTDsensor=CTDsensorinfo_MP('SBE-MP52-026');%
              info.VELsensor=VELsensorinfo_MP('1605'); %

              info.totdist=NaN; %From depth_history
              info.ballast=ballastFCN(1.42,34.69,1045.8,3988); %
              info.ballast.comments='';
              info.comments={'P4 western sill.'};
              info.station=mooring;
              info.experiment='SamoanPassage';
            case 'T11',
              info.lat=-9 - 36.076/60; %surveyed
              info.lon=-169 - 47.816/60;
              info.H=4736;
              info.dates={'2/7/2014-2/14/2014'};
              info.pmin=3600;
              info.pmax=4776;
              info.dt=0; %continuous

              info.n_profiles=159;
              info.year=2014;
              info.start_yday=yearday(7,2,2014,2,0,0);
              info.end_yday=yearday(14,2,2014,19,0,0);

              % http://www.ngdc.noaa.gov/geomag-web/#declination
              % Model Used: 	IGRF12
              % Latitude: 	9.6013° S
              % Longitude: 	169.7969° W
              % Date 	Declination
              % 2015-02-11 	10.67° E  changing by  0.03° E per year 
              info.magvar = 10.67;

              info.CTDsensor=CTDsensorinfo_MP('SBE-MP52-026');%
              info.VELsensor=VELsensorinfo_MP('1605'); %

              info.totdist=NaN; %From depth_history
              info.ballast=ballastFCN(1.42,34.69,1045.8,3988); %
              info.ballast.comments='Eastern of three downstream moorings at P2';
              info.comments={''};
              info.station=mooring;
              info.experiment='SamoanPassage';
          end % mooring
          
      otherwise
          error(['I don''t show S/N ' sn ' as deployed during ' cruise '.'])

      end % end sp14
      
  case 'TTIDE' %TTIDE
        switch sn
            case '104', %104
                switch mooring
                    case 'M3',
                        info.lat=-41-21.505/60; %surveyed
                        info.lon=148+ 46.052/60;
                        %info.H=1000;
                        %info.dates={'1/15/2015-1/24/2014'};
                        info.pmin=70;
                        info.pmax=980;
                        info.dt=1.5/24; %continuous
                        
                        %info.n_profiles=123;
                        info.year=2015;
                        info.start_yday=yearday(15,1,2015,12,0,0);
                        %info.end_yday=yearday(3,2,2014,0,0,0);
                        
                        info.magvar=magdev(info.lat,info.lon); %2000 magdev from Visbeck; mhatoolbox/visbeck_ladcp
                        
                        %info.CTDsensor=CTDsensorinfo_MP('SBE-MP52-026');%
                        %info.VELsensor=VELsensorinfo_MP('1605'); %
                        
                        info.totdist=NaN; %From depth_history
                        %info.ballast=ballastFCN(8.414,34.561,1029.26,528); %527.948	8.414	34.561	1029.260926
                        info.ballast.comments='';
                        info.comments={''};
                        info.station=mooring;
                        info.experiment='TTIDE';
%                     case 'M6',
%                         info.lat=-9-36.061/60; %surveyed
%                         info.lon=-169 - 49.526/60;
%                         info.H=4720;
%                         info.dates={'2/7/2014-2/14/2014'};
%                         info.pmin=3600;
%                         info.pmax=4758;
%                         info.dt=0; %continuous
%                         
%                         info.n_profiles=119;
%                         info.year=2014;
%                         info.start_yday=yearday(7,2,2014,20,0,0);
%                         info.end_yday=yearday(14,2,2014);
%                         
%                         info.magvar=magdev(info.lat,info.lon); %2000 magdev from Visbeck; mhatoolbox/visbeck_ladcp
%                         
%                         info.CTDsensor=CTDsensorinfo_MP('SBE-MP52-026');%
%                         info.VELsensor=VELsensorinfo_MP('1605'); %
%                         
%                         info.totdist=NaN; %From depth_history
%                         info.ballast=ballastFCN(1.42,34.69,1045.8,3988); %
%                         info.ballast.comments='Western of three downstream moorings at P2';
%                         info.comments={''};
%                         info.station=mooring;
%                         info.experiment='TTIDE';
%                         
%                     otherwise,
%                         error('No mooring specified.')
                        
                end %end sn104, TTIDE
%                    otherwise,
%                        error('No mooring specified.')
            case 'J1', %J1
                switch mooring
                    case 'A2',
                        info.lat=-42-49.357/60; %surveyed
                        info.lon=151+ 22.515/60;
                        %info.H=1000;
                        %info.dates={'1/15/2015-1/24/2014'};
                        info.pmin=70;
                        info.pmax=1817; %Handwriting looks like 1517
                        info.dt=1.5/24; 
                        
                        %info.n_profiles=123;
                        info.year=2015;
                        info.start_yday=yearday(11,1,2015,09,0,0);
                        %info.end_yday=yearday(3,2,2014,0,0,0);
                        
                        info.magvar=magdev(info.lat,info.lon); %2000 magdev from Visbeck; mhatoolbox/visbeck_ladcp
                        
                        %info.CTDsensor=CTDsensorinfo_MP('SBE-MP52-026');%
                        %info.VELsensor=VELsensorinfo_MP('1605'); %
                        
                        info.totdist=NaN; %From depth_history
                        info.ballast=ballastFCN(6.7,34.46,1030.69,802); 
                        info.ballast.comments='';
                        info.comments={''};
                        info.station=mooring;
                        info.experiment='TTIDE';
                        
                    otherwise,
                        error('No mooring specified.')
                        
                end %end snJ1, TTIDE
            case 'J2', %J2
                switch mooring
                    case 'A3',
                        info.lat=-42-37.842/60; %surveyed
                        info.lon=150+ 37.568/60;
                        info.H=4138;
                        info.dates={'1/15/2015-3/2/2014'};
                        info.pmin=70;
                        info.pmax=1517; %NOTE DISCREPANCY with A2!
                        info.dt=1.5/24; 
                        
                        info.n_profiles=85;
                        info.year=2015;
                        info.start_yday=yearday(15,1,2015,0,0,0);
                        info.end_yday=yearday(21,1,2015,0,0,0);
                        
                        info.magvar=magdev(info.lat,info.lon); %2000 magdev from Visbeck; mhatoolbox/visbeck_ladcp
                        
                        info.CTDsensor=CTDsensorinfo_MP('SBE-MP52-026');%
                        info.VELsensor=VELsensorinfo_MP('1605'); %
                        
                        info.totdist=NaN; %From depth_history
                        info.ballast=ballastFCN(6.7,34.46,1030.69,802); 
                        info.ballast.comments='';
                        info.comments={''};
                        info.station=mooring;
                        info.experiment='TTIDE';
                    
                    otherwise,
                        error('No mooring specified.')
                        
                end %end snJ2, TTIDE
%                end
            case 'J4', %J4
                switch mooring
                    case 'A4',
                        info.lat=-42-02.042/60; %surveyed
                        info.lon=150+ 39.058/60;
                        info.H=4530;
                        %info.dates={'1/13/2015-1/24/2014'};
                        info.pmin=80;
                        info.pmax=1517; 
                        info.dt=1.5/24; %continuous
                        
                        info.n_profiles=39;
                        info.year=2015;
                        info.start_yday=yearday(13,1,2015,14,0,0);
                        info.end_yday=yearday(15,1,2015,15,0,0);
                        
                        info.magvar=magdev(info.lat,info.lon); %2000 magdev from Visbeck; mhatoolbox/visbeck_ladcp
                        
                        info.CTDsensor=CTDsensorinfo_MP('SBE-MP52-026');%
                        info.VELsensor=VELsensorinfo_MP('1605'); %
                        
                        info.totdist=NaN; %From depth_history
                        info.ballast=ballastFCN(6.7,34.46,1030.69,802); 
                        info.ballast.comments='';
                        info.comments={''};
                        info.station=mooring;
                        info.experiment='TTIDE';
                    
                    otherwise,
                        error('No mooring specified.')
                        
                end %end snJ4, TTIDE
                
            case '105', %105
                switch mooring
                    case 'M1',
                        info.lat=-41-19.363/60; %surveyed
                        info.lon=149+ 03.390/60;
                        info.H=2357;
                        info.dates={'1/15/2015-3/5/2014'};
                        info.pmin=72;
                        info.pmax=1380;
                        info.dt=1.5/24; %continuous
                        
                        info.n_profiles=394;
                        info.year=2015;
                        info.start_yday=yearday(15,1,2015,03,0,0);
                        info.end_yday=yearday(3,5,2014,0,0,0);
                        
                        info.magvar=magdev(info.lat,info.lon); %2000 magdev from Visbeck; mhatoolbox/visbeck_ladcp
                        
                        info.CTDsensor=CTDsensorinfo_MP('SBE-MP52-026');%
                        info.VELsensor=VELsensorinfo_MP('1605'); %
                        
                        info.totdist=NaN; %From depth_history
                        info.ballast=ballastFCN(6.7,34.46,1030.69,802); %wrong
                        info.ballast.comments='';
                        info.comments={''};
                        info.station=mooring;
                        info.experiment='TTIDE';
                    
                    otherwise,
                        error('No mooring specified.')
                        
                end %end sn105, TTIDE
                     
            case '103', %103
                switch mooring
                    case 'M1',
                        info.lat=-41-19.363/60; %surveyed
                        info.lon=149+ 03.390/60;
                        info.H=2357;
                        info.dates={'1/15/2015-2/14/2015'};
                        info.pmin=1439; %Given Depth 1422m
                        info.pmax=2362; %Given Depth 2330m
                        info.dt=1.5/24; %continuous
                        
                        info.n_profiles=463;
                        info.year=2015;
                        info.start_yday=yearday(15,1,2015,03,0,0);
                        info.end_yday=yearday(14,2,2015,0,0,0);
                        
                        info.magvar=magdev(info.lat,info.lon); %2000 magdev from Visbeck; mhatoolbox/visbeck_ladcp
                        
                        info.CTDsensor=CTDsensorinfo_MP('SBE-MP52-026');%
                        info.VELsensor=VELsensorinfo_MP('1605'); %
                        
                        info.totdist=NaN; %From depth_history
                        info.ballast=ballastFCN(2.5,34.6,1035.77,1770);
                        info.ballast.comments='';
                        info.comments={''};
                        info.station=mooring;
                        info.experiment='TTIDE';
                    
                    otherwise,
                        error('No mooring specified.')
                        
                end %end sn103, TTIDE
                    
            case 'J3', %J3
                switch mooring
                    case 'M2',
                        info.lat=-41-19.775/60; %surveyed
                        info.lon=148+ 54.297/60;
                        %info.H=1000;
                        %info.dates={'1/15/2015-1/24/2014'};
                        info.pmin=72; %Given Depth 72m
                        info.pmax=1342; %Given Depth 1327m
                        info.dt=1.5/24; %continuous
                        
                        %info.n_profiles=123;
                        info.year=2015;
                        info.start_yday=yearday(15,1,2015,07,0,0);
                        %info.end_yday=yearday(3,2,2014,0,0,0);
                        
                        info.magvar=magdev(info.lat,info.lon); %2000 magdev from Visbeck; mhatoolbox/visbeck_ladcp
                        
                        %info.CTDsensor=CTDsensorinfo_MP('SBE-MP52-026');%
                        %info.VELsensor=VELsensorinfo_MP('1605'); %
                        
                        info.totdist=NaN; %From depth_history
                        info.ballast=ballastFCN(6.7,34.46,1030.69,802); 
                        info.ballast.comments='';
                        info.comments={''};
                        info.station=mooring;
                        info.experiment='TTIDE';
                    
                    otherwise,
                        error('No mooring specified.')
                        
                end %end snJ3, TTIDE
                
            case '109', %109
                switch mooring
                    case 'M2',
                        info.lat=-41-19.775/60; %surveyed
                        info.lon=148+ 54.297/60;
                        %info.H=1000;
                        %info.dates={'1/15/2015-1/24/2014'};
                        info.pmin=1384; %Given Depth 1369m
                        info.pmax=1663; %Given Depth 1643m
                        info.dt=0.5/24; %continuous
                        
                        %info.n_profiles=123;
                        info.year=2015;
                        info.start_yday=yearday(15,1,2015,07,0,0);
                        %info.end_yday=yearday(3,2,2014,0,0,0);
                        
                        info.magvar=magdev(info.lat,info.lon); %2000 magdev from Visbeck; mhatoolbox/visbeck_ladcp
                        
                        %info.CTDsensor=CTDsensorinfo_MP('SBE-MP52-026');%
                        %info.VELsensor=VELsensorinfo_MP('1605'); %
                        
                        info.totdist=NaN; %From depth_history
                        info.ballast=ballastFCN(6.7,34.46,1030.69,802); 
                        info.ballast.comments='';
                        info.comments={''};
                        info.station=mooring;
                        info.experiment='TTIDE';
                    
                    otherwise,
                        error('No mooring specified.')
                        
                end %end sn109, TTIDE
                
            case 'H3', %H03
                switch mooring
                    case 'M4',
                        info.lat=-43-03.225/60; %surveyed
                        info.lon=148+ 29.780/60;
                        info.H=2349;
                        info.dates={'1/14/2015-3/6/2015'};
                        info.pmin=75; 
                        info.pmax=1195; 
                        info.dt=1.5/24; %continuous
                        
                        info.n_profiles=682;
                        info.year=2015;
                        info.start_yday=yearday(14,1,2015,02,0,0);
                        info.end_yday=yearday(3,6,2014,0,0,0);
                        
                        info.magvar=magdev(info.lat,info.lon); %2000 magdev from Visbeck; mhatoolbox/visbeck_ladcp
                        
                        info.CTDsensor=CTDsensorinfo_MP('SBE-MP52-026');%
                        info.VELsensor=VELsensorinfo_MP('1605'); %
                        
                        info.totdist=NaN; %From depth_history
                        info.ballast=ballastFCN(6.7,34.46,1030.69,802); 
                        info.ballast.comments='';
                        info.comments={''};
                        info.station=mooring;
                        info.experiment='TTIDE';
                    
                    otherwise,
                        error('No mooring specified.')
                        
                end %end snH03, TTIDE
                
            case '108', %108
                switch mooring
                    case 'M4',
                        info.lat=-43-03.225/60; %surveyed
                        info.lon=148+ 29.780/60;
                        info.H=2349;
                        info.dates={'1/14/2015-3/6/2015'};
                        info.pmin=1197; 
                        info.pmax=2350; 
                        info.dt=1.5/24; %continuous
                        
                        info.n_profiles=1271;
                        info.year=2015;
                        info.start_yday=yearday(14,1,2015,02,0,0);
                        info.end_yday=yearday(3,6,2014,0,0,0);
                        
                        info.magvar=magdev(info.lat,info.lon); %2000 magdev from Visbeck; mhatoolbox/visbeck_ladcp
                        
                        info.CTDsensor=CTDsensorinfo_MP('SBE-MP52-026');%
                        info.VELsensor=VELsensorinfo_MP('1605'); %
                        
                        info.totdist=NaN; %From depth_history
                        info.ballast=ballastFCN(6.7,34.46,1030.69,802); 
                        info.ballast.comments='';
                        info.comments={''};
                        info.station=mooring;
                        info.experiment='TTIDE';
                    
                    otherwise,
                        error('No mooring specified.')
                        
                end %end sn108, TTIDE
                
            case 'H2', %H02
                switch mooring
                    case 'M5',
                        %Target Lat Lon
                        info.lat=-42-57.844/60; %surveyed
                        info.lon=148+ 22.491/60;
                        info.H=1138;
                        info.dates={'1/14/2015-3/7/2015'};
                        info.pmin=75; 
                        info.pmax=816; 
                        info.dt=1.3333/24; 
                        
                        info.n_profiles=1065;
                        info.year=2015;
                        info.start_yday=yearday(13,1,2015,13,0,0);
                        info.end_yday=yearday(7,3,2015,0,0,0);
                        
                        info.magvar=magdev(info.lat,info.lon); %2000 magdev from Visbeck; mhatoolbox/visbeck_ladcp
                        info.CTDsensor=CTDsensorinfo_MP('SBE-MP52-026');%
                        info.VELsensor=VELsensorinfo_MP('1605'); %
                        
                        info.totdist=NaN; %From depth_history
                        info.ballast=ballastFCN(8.7,34.598,1028.855,445); 
                        info.ballast.comments='';
                        info.comments={''};
                        info.station=mooring;
                        info.experiment='TTIDE';
                    
                    otherwise,
                        error('No mooring specified.')
                        
                end %end snH02, TTIDE
                
                case '107', %107
                switch mooring
                    case 'M5',
                        %Target Lat Lon
                        info.lat=-42-57.844/60; %surveyed
                        info.lon=148+ 22.491/60;
                        info.H=1138;
                        info.dates={'1/14/2015-3/7/2015'};
                        info.pmin=837; 
                        info.pmax=1120; 
                        info.dt=30/60/24; %30-min
                        
                        info.n_profiles=2523;
                        info.year=2015;
                        info.start_yday=yearday(13,1,2015,13,0,0);
                        info.end_yday=yearday(7,3,2015,0,0,0);
                        
                        info.magvar=magdev(info.lat,info.lon); %2000 magdev from Visbeck; mhatoolbox/visbeck_ladcp
                        
                        info.CTDsensor=CTDsensorinfo_MP('SBE-MP52-026');%
                        info.VELsensor=VELsensorinfo_MP('1605'); %
                        
                        info.totdist=NaN; %From depth_history
                        info.ballast=ballastFCN(8.6,34.584,1028.983,471); 
                        info.ballast.comments='';
                        info.comments={''};
                        info.station=mooring;
                        info.experiment='TTIDE';
                    
                    otherwise,
                        error('No mooring specified.')
                        
                end %end sn107, TTIDE
                
            otherwise,
                error(['I don''t show S/N ' sn ' as deployed during ' cruise '.'])
        end %end TTIDE
      
  case 'ArcticMix15' % ArcticMix15
    switch sn
      case '107'
        switch mooring
            case 'AM1',
              info.lat = 72 + 35.646/60; %surveyed
              info.lon = -145 - 01.002/60;
              info.H=3460;
              info.dates={'9/1/2015-9/30/2015'};
              info.pmin=42;
              info.pmax=958;
              info.dt=0; %continuous

              info.n_profiles=220;
              info.year=2015;
              info.start_yday=yearday(1,9,2015,0,0,0);
              info.end_yday=yearday(30,9,2015,0,0,0);

%             http://www.ngdc.noaa.gov/geomag-web/#declination
%             Model Used: 	WMM2015
%             Latitude: 	72.5941° N
%             Longitude: 	145.0167° W
%             2015-09-15 	20.96° E  ± 0.79°  changing by  0.69° W per year
              info.magvar=20.96;

              info.CTDsensor=CTDsensorinfo_MP('SBE-MP52-026');%
              info.VELsensor=VELsensorinfo_MP('AQD 9340'); %

              info.totdist=NaN; %From depth_history
              info.ballast=ballastFCN(1.42,34.69,1045.8,3988); %
              info.ballast.comments=[];
              info.comments = {'testing re-written MP processing toolbox'};
              info.station = mooring;
              info.experiment='Arctic';
        end
    end
  
  otherwise,
    disp('No such cruise.')
               
end % cruise

% 1/16/2012: add deployment as the same as the cruise - henceforth we will
% specify deployment not cruise but this is for backwards compatibility
info.deployment = info.cruise;
