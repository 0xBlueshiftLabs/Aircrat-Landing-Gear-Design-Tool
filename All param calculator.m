clear

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% rob@perdax.co.uk %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Landing Gear Design %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%% CONSTSANTS %%%
NtoLBS = 0.2247; % Newtons to Pounds [lbs] conversion
inToM = 0.0254; % inches to meters conversion
g = 9.81; % acceleration due to gravity [ms^-2]
msToKTS = 1.94384;

%%% GENERAL INPUTS %%%
noseToN = 3.83; % [m]
NToFwd = 9.92+0.47; % [m]
fwdToW = 0.14; % [m]
WToAft = 0.32; % [m]
d = 2.62 % distance between aft cg and fuselage gear [m]
wheelbase = NToFwd+fwdToW+WToAft+d; % [m]

Nfwd = ((fwdToW+((WToAft+d)/2))/(NToFwd+fwdToW+((WToAft+d)/2))); % total load on nose for fwd cg
Naft = ((((WToAft+d)/2)-WToAft)/(NToFwd+fwdToW+WToAft+((WToAft+d)/2)-WToAft)); % total load on nose for aft cg
BMainMax = d+fwdToW+WToAft; % max distance from main gear to cg [m]
BMainMin = d; % min distance from main gear to cg [m]

massMax = 33500; % [kg]
massMin = 23500; % mass without fuel [kg]
MTOW = massMax*g;
emptyW = massMin*g% [N]

%%% STATIC LOADS %%%
maxLoadOnNose = Nfwd*MTOW; % [N]
minLoadOnNose = Naft*emptyW; % [N]
minLoadOnMain = (1-Naft)*emptyW; % [N]
maxLoadOnMain = (1-Nfwd)*MTOW; % [N]

%%% VERTICAL CG HEIGHT %%%
HcgEmpty = 1.25-0.076+1.13; % (bottom to centerline-offset+ground clearence) height of cg location [m]
HcgMTOW = 1.25-0.44+1.13; % (bottom to centerline-offset+ ground clearnece) height of cg location [m]

%%% ACCELERATIONS %%%
aLanding = 1.3*g; % acceleration of landing [ms^-2]
aTO = 2.8*g; % acceleration of take off [ms^-2]

%%% LOADS %%%
FNoseDynamic = ((MTOW*aLanding*HcgMTOW)/(g*wheelbase)); % max dynamic force on nose [N]
FNoseDynamicEmpty = ((emptyW*aLanding*HcgEmpty)/(g*wheelbase)); % max dynamic force on nose [N]

FMainDynamic = ((MTOW*aTO*HcgMTOW)/(g*wheelbase)); % max dynamic force on main [N]
FMainDynamicEmpty = ((emptyW*aTO*HcgEmpty)/(g*wheelbase)); % max dynamic force on main [N]

FNose = maxLoadOnNose + FNoseDynamic; % max total force on nose [N]
FMain = maxLoadOnMain + FMainDynamic; % max total force on main [N]

noseTyre = FNose/2
noseTyreLBS = (FNose/2)*NtoLBS
mainTyre = FMain/4
mainTyreLBS = (FMain/4)*NtoLBS

%%% ROSKAM %%%

tireLoadMain = (maxLoadOnMain*1.07*1.25*0.25); % [N]
tireLoadMainLBS = tireLoadMain*NtoLBS; % [lbs]
tireLoadNose = (maxLoadOnNose*1.07*1.25*0.5); % [N]
tireLoadNoseLBS = tireLoadNose*NtoLBS; % [lbs]

%%% max load %%%
noseMax = FNose*NtoLBS*0.5; % [lbs]
mainMax = FMain*NtoLBS*0.25; % [lbs]

%%%%%%%%%%%%%%%

%%% TIRE SIZE ESTIMATION %%%
Ad = 2.69;
Bd = 0.251;
Aw =1.170;
Bw = 0.216;

DtMain = Ad*((maxLoadOnMain/4)*NtoLBS)^Bd; % tire diamter [inch]
WtMain = Aw*((maxLoadOnMain/4)*NtoLBS)^Bw; % tire width [inch]

DtNose = Ad*((maxLoadOnNose/2)*NtoLBS)^Bd; % tire diamter [inch]
WtNose = Aw*((maxLoadOnNose/2)*NtoLBS)^Bw; % tire width [inch]

%%% SELECTED TIRE INPUTS %%%
DtMainSelected = 36; % [inches]
WtMainSelected = 11; % [inches]
RrMain = 14.93; % rolling radius (from maufacturer catalogue)
plyMain = 30;
iPmain = 317; % inflation pressure unloaded [psi] 
ratedMain = 35800; % 
speedMain = 227; % [kts] 262mph

DtNoseSelected = 25.5; % [inches]
WtNoseSelected = 8; % [inches]
RrNose = 11.5; % rolling radius (from maufacturer catalogue)
plyNose = 20;
iPnose = 310; % inflation pressure unloaded [psi]
ratedNose = 16200;
speedNose = 217; % [kts] 250mph

DtWingSelected = 27.75; % [inches]
WtWingSelected = 8.75; % [inches]
RrWing = 12; % rolling radius (from maufacturer catalogue)
plyWing = 24;
iPwing = 320; % inflation pressure unloaded [psi]
ratedWing = 21500;
speedWing = 225; % [kts] 259mph

%%% DEBATABLE TIRE OUTPUTS %%%
ApMain = 2.3*(sqrt(DtMainSelected*WtMainSelected))*((DtMainSelected/2)-RrMain);
Pmain = maxLoadOnMain/ApMain; % CHECK THIS
ApNose = 2.3*(sqrt(DtNoseSelected*WtNoseSelected))*((DtNoseSelected/2)-RrNose);
Pnose = maxLoadOnNose/ApNose; % CHECK THIS

%%% STROKE, OLEO DIMENSIONS & STIFFNESS' %%%
StireMain = ((DtMain/2)-RrMain); % stroke length of main tire [inches]
StireNose = ((DtNose/2)-RrNose); % stroke length of nose tire [inches]

Vvertical = 22*0.3048; % max vertical velocity converted to [m/s]
eta = 0.8; % shock efficiency
etaTire = 0.47; % shock tire efficiency
Ngear = 6; % Gear load factor

Smain = (((Vvertical)^2)/(2*9.81*eta*Ngear))-((etaTire*StireMain*inToM)/eta); % [m]
LoleoGroundMain = Smain/0.60; % [m]
LoleoExtendedMain = 2.5*Smain; % [m]
kMain = ((0.5*FMain)/(LoleoExtendedMain-LoleoGroundMain)); % [N/m]

Snose = (((Vvertical)^2)/(2*9.81*eta*Ngear))-((etaTire*StireNose*inToM)/eta); % [m]
LoleoGroundNose = Snose/0.60; % [m]
LoleoExtendedNose = 2.5*Snose; % [m]
kNose = ((FNose)/(LoleoExtendedNose-LoleoGroundNose)); % [N/m]

%%% OLEO DIAMETERS %%%
DoleoInternalMain = inToM*0.035*(sqrt((maxLoadOnMain/2)*NtoLBS)); % [m]
DoleoExternalMain = 1.3*DoleoInternalMain; % [m]

DoleoInternalNose = inToM*0.035*(sqrt(maxLoadOnNose*NtoLBS)); % [m]
DoleoExternalNose = 1.3*DoleoInternalNose; % [m]
%%% above asssumes oleo pressure of 1800 psi %%%

%%% GEAR HEIGHT Hg %%%
HgMain = LoleoGroundMain+((inToM*DtMainSelected)/2); % [m]
HgNose = LoleoGroundNose+((inToM*DtNoseSelected)/2); % [m]

%%% CLEARANCE ANGLE ac %%%
AB = 18.535-(wheelbase+noseToN); % distance between main gear attachment point and the end of the fuselage [m]
ac = atand(1.13/AB); % clearance angle [degrees]

%%% MIN 180 TURN RADIUS r180min %%%
betaMax = 60; % max steering angle [degrees]
trackWithout = 2; % track of fuselage gear as wing gear on caster syle wheels [m]
trackWith = 4.9; % [m]
r180min = (trackWithout*(tand(90-betaMax)))+(wheelbase/2); % minimum 180 degree turn radius [m]
r180minWith = (trackWith*(tand(90-betaMax)))+(wheelbase/2); % minimum 180 degree turn radius [m]

%%% TURNING VELOCITIES %%%
turningVmaxWithout = sqrt((r180min*trackWithout*g)/(2*HcgEmpty)) % max turning velocity without wing gear [m/s]
turningVmaxWithoutKTS = turningVmaxWithout*msToKTS % above but [knotts]
turningVmaxWith = sqrt((r180min*trackWith*g)/(2*HcgEmpty)) % max turning velocity with wing gear [m/s]
turningVmaxWithKTS = turningVmaxWith*msToKTS % above but [knotts]
turningVmaxWithMTOW = sqrt((r180min*trackWith*g)/(2*HcgMTOW)) % max turning velocity with wing gear [m/s]
turningVmaxWithKTSMTOW = turningVmaxWithMTOW*msToKTS % above but [knotts]

%%% MAX CROSSWIND VELOCITIES %%%
rho = 1.225 % air density at sea level [kg/m^3]
As = 71 % cross sectional area of side view [m^2]
Cds = 0.8 % coefficient of drag for side view
maxWindVwithoutEmpty = sqrt((trackWithout*massMin*9.81)/(rho*As*Cds*HcgEmpty)) % [m/s]
maxWindVwithEmpty = sqrt((trackWith*massMin*9.81)/(rho*As*Cds*HcgEmpty)) % [m/s]
maxWindVwithoutMTOW = sqrt((trackWithout*MTOW)/(rho*As*Cds*HcgMTOW)) % [m/s]
maxWindVwithMTOW = sqrt((trackWith*MTOW)/(rho*As*Cds*HcgMTOW)) % [m/s]

%%% OVERTURN ANGLES %%%
alpha = atand((trackWith/2)/(NToFwd+fwdToW))
xFwd = (sind(alpha))*(NToFwd/sind(90))
xAft = (sind(alpha))*((NToFwd+fwdToW+WToAft)/sind(90))

overturnMTOW = atand(HcgMTOW/xFwd)
overturnEmpty = atand(HcgEmpty/xAft)

%%% SIDE WAYS TURNOVER ANGLE %%%
staMTOW = atand((HcgMTOW)/(NToFwd*sind(atand((trackWith)/(2*wheelbase)))))
staEmpty = atand((HcgEmpty)/((NToFwd+fwdToW+WToAft)*sind(atand((trackWith)/(2*wheelbase)))))

%%% PERMISSABLE ROLL ANGLE %%%
dihedral = 5 % wing dihedral [degrees]
span = 25 % wing span [m]
sweep = 36 % wing sweep [degrees]
avPitch = 13 % [degrees]
phi = atand(tand(dihedral)+(((2*HgMain)/(span-trackWith))*(tand(avPitch)*tand(sweep)))) % permissable roll angle [degrees]
