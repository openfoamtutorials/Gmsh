//Gmsh
//Under construction. Uses baffles (infinitely thin surfaces) as airfoils.
//The baffles are constructed as Bezier spline lines of 4 points:
//leading edge and its tangential spline point, and the trailing edge and its tangential spline point.
//The spline points are positioned such that the line from the laeading/trailing edge to the spline point is at a specified angle with the chord line (defined to be the line from the leading to trailing edges).
//A distance for the spline points is also specified.

//Constants
dtr = Pi/180;

Include "functions.geo";

//INPUTS

//GENERAL
BASEDIM = 0.1;//m, base dimension so that everything can be scaled according to this number.

//BOUNDARY
BBDIM = 20*BASEDIM;//Boundaing domain square dimension.

//AIRFOIL DIMENSIONS
CHORDS[] = {BASEDIM, BASEDIM, BASEDIM};
ANGLES[] = {-10*dtr,0*dtr,10*dtr};//angles of attack for each element.
LEDISTANCES[] = {0.2,0.2,0.2};//distance from spline point to leading edge, as a factor of the chord.
TEDISTANCES[] = {0.1,0.1,0.1};
LEANGLES[] = {20*dtr,20*dtr,20*dtr};
TEANGLES[] = {10*dtr,10*dtr,10*dtr};
LEX[] = {-BASEDIM,0,BASEDIM};
LEY[] = {0,0,-.2*BASEDIM};

//GRID PARAMETERS
SURFACECL = 0.02;//characteristic length on the surfaces of the airfoils, factor of chord.
BBCL = 0.05*BBDIM;//bounding box characteristic length.
BLHEIGHT = 0.05;//factor of chord
BLEXT = 0.1;//factor of chord, length of bl extending beyond edges.
BLCELLS = 20;
BLPROG = 1.2;
EXTCELLS = 20;//
EXTPROG = 1.2;
WINGCELLS = 50;
WINGBUMP = 0.25;
DZ = 0.1*BASEDIM;//extrusion length

//PREPROCESSED VARIABLES
NE = #CHORDS[];//number of elements



//START SCRIPT
ce=0;//initialize the current entity counter.

//BOUNDING BOX
dim=BBDIM;center[]={0,0,0};z=0;cl=BBCL;Call makeSquare;
lines[]=sql[];Call autoLineLoop;
bbloop = ce;

//SPLINED LINES
blloops[]={};
For i In {0:NE-1}
	//SPLINE
	splinepoints[]={};
	//leading edge.
	Point(ce++)={LEX[i],LEY[i],0,SURFACECL};splinepoints[]+=ce;
	//le spline.
	dist = LEDISTANCES[i]*CHORDS[i];
	angle=LEANGLES[i];Call prepTrig;
	Point(ce++)={LEX[i]+dist*cs,LEY[i]+dist*sn,0,SURFACECL};splinepoints[]+=ce;
	//te spline.
	dist = TEDISTANCES[i]*CHORDS[i];
	angle=Pi-TEANGLES[i];Call prepTrig;
	tex = LEX[i]+CHORDS[i];
	tey = LEY[i];
	Point(ce++)={tex+dist*cs,tey+dist*sn,0,SURFACECL};splinepoints[]+=ce;
	//trailing edge.
	Point(ce++)={tex,tey,0,SURFACECL};splinepoints[]+=ce;
	//BOUNDARY LAYER
	leblpoints[]={};
	teblpoints[]={};
	//leading edge.
	blh = BLHEIGHT*CHORDS[i];
	ble = BLEXT*CHORDS[i];
	angle=LEANGLES[i]+Pi/2;Call prepTrig;
	toplebl[] ={LEX[i]+blh*cs,LEY[i]+blh*sn};
	Point(ce++)={toplebl[0],toplebl[1],0,SURFACECL};leblpoints[]+=ce;
	angle=LEANGLES[i]+Pi;Call prepTrig;
	Point(ce++)={toplebl[0]+ble*cs,toplebl[1]+ble*sn,0,SURFACECL};leblpoints[]+=ce;
	angle=LEANGLES[i]+Pi;Call prepTrig;
	midlebl[] ={LEX[i]+ble*cs,LEY[i]+ble*sn};
	Point(ce++)={midlebl[0],midlebl[1],0,SURFACECL};leblpoints[]+=ce;
	angle=LEANGLES[i]+3*Pi/2;Call prepTrig;
	Point(ce++)={midlebl[0]+blh*cs,midlebl[1]+blh*sn,0,SURFACECL};leblpoints[]+=ce;
	angle=LEANGLES[i]+3*Pi/2;Call prepTrig;
	bottomlebl[] ={LEX[i]+blh*cs,LEY[i]+blh*sn};
	Point(ce++)={bottomlebl[0],bottomlebl[1],0,SURFACECL};leblpoints[]+=ce;
	//trailing edge.
	angle=Pi-TEANGLES[i]-Pi/2;Call prepTrig;
	toptebl[] ={tex+blh*cs,tey+blh*sn};
	Point(ce++)={toptebl[0],toptebl[1],0,SURFACECL};teblpoints[]+=ce;
	angle=Pi-TEANGLES[i]-Pi;Call prepTrig;
	Point(ce++)={toptebl[0]+ble*cs,toptebl[1]+ble*sn,0,SURFACECL};teblpoints[]+=ce;
	angle=Pi-TEANGLES[i]-Pi;Call prepTrig;
	midtebl[] ={tex+ble*cs,tey+ble*sn};
	Point(ce++)={midtebl[0],midtebl[1],0,SURFACECL};teblpoints[]+=ce;
	angle=Pi-TEANGLES[i]-3*Pi/2;Call prepTrig;
	Point(ce++)={midtebl[0]+blh*cs,midtebl[1]+blh*sn,0,SURFACECL};teblpoints[]+=ce;
	angle=Pi-TEANGLES[i]-3*Pi/2;Call prepTrig;
	bottomtebl[] ={tex+blh*cs,tey+blh*sn};
	Point(ce++)={bottomtebl[0],bottomtebl[1],0,SURFACECL};teblpoints[]+=ce;
	//Boundary layer spline lines.
	topblsplinepoints[]={};
	bottomblsplinepoints[]={};
	bldc = (toptebl[0]-toplebl[0])/CHORDS[i]-1;//get the chord length change in the bl spline lines.
	angle=LEANGLES[i];Call prepTrig;
	dist = LEDISTANCES[i]*CHORDS[i];
	Point(ce++)={toplebl[0]+(1+bldc)*dist*cs,toplebl[1]+(1+bldc)*dist*sn,0,SURFACECL};topblsplinepoints[]+=ce;
	Point(ce++)={bottomlebl[0]+(1-bldc)*dist*cs,bottomlebl[1]+(1-bldc)*dist*sn,0,SURFACECL};bottomblsplinepoints[]+=ce;
	angle=Pi-TEANGLES[i];Call prepTrig;
	dist = TEDISTANCES[i]*CHORDS[i];
	Point(ce++)={toptebl[0]+(1+bldc)*dist*cs,toptebl[1]+(1+bldc)*dist*sn,0,SURFACECL};topblsplinepoints[]+=ce;
	Point(ce++)={bottomtebl[0]+(1-bldc)*dist*cs,bottomtebl[1]+(1-bldc)*dist*sn,0,SURFACECL};bottomblsplinepoints[]+=ce;

	//rotate the spline and boudnary layer points.
	points[] = {splinepoints[],leblpoints[],teblpoints[],topblsplinepoints[],bottomblsplinepoints[]};rc[] = {LEX[i],LEY[i],0};angle = -ANGLES[i];Call rotatePoints2D;
	BSpline(ce++)=splinepoints[];splineline=ce;

	//top bl vertical lines.
	topblvertlines[]={};
	Line(ce++)={leblpoints[2],leblpoints[1]};topblvertlines[]+=ce;
	Line(ce++)={splinepoints[0],leblpoints[0]};topblvertlines[]+=ce;
	Line(ce++)={splinepoints[3],teblpoints[0]};topblvertlines[]+=ce;
	Line(ce++)={teblpoints[2],teblpoints[1]};topblvertlines[]+=ce;
	//bottom bl vertical lines.
	bottomblvertlines[]={};
	Line(ce++)={leblpoints[2],leblpoints[3]};bottomblvertlines[]+=ce;
	Line(ce++)={splinepoints[0],leblpoints[4]};bottomblvertlines[]+=ce;
	Line(ce++)={splinepoints[3],teblpoints[4]};bottomblvertlines[]+=ce;
	Line(ce++)={teblpoints[2],teblpoints[3]};bottomblvertlines[]+=ce;
	//le extension lines.
	leextlines[]={};
	Line(ce++)={leblpoints[0],leblpoints[1]};leextlines[]+=ce;
	Line(ce++)={splinepoints[0],leblpoints[2]};leextlines[]+=ce;
	Line(ce++)={leblpoints[4],leblpoints[3]};leextlines[]+=ce;
	//te extension lines.
	teextlines[]={};
	Line(ce++)={teblpoints[0],teblpoints[1]};teextlines[]+=ce;
	Line(ce++)={splinepoints[3],teblpoints[2]};teextlines[]+=ce;
	Line(ce++)={teblpoints[4],teblpoints[3]};teextlines[]+=ce;
	//bl spline lines.
	blsplinelines[]={};//top, bottom
	BSpline(ce++)={leblpoints[0],topblsplinepoints[],teblpoints[0]};blsplinelines[]+=ce;
	BSpline(ce++)={leblpoints[4],bottomblsplinepoints[],teblpoints[4]};blsplinelines[]+=ce;

	//gridding
	Transfinite Line{teextlines[],leextlines[]} = EXTCELLS+1 Using Progression EXTPROG;
	Transfinite Line{topblvertlines[],bottomblvertlines[]} = BLCELLS+1;
	Transfinite Line{topblvertlines[{1:2}],bottomblvertlines[{1:2}]} = BLCELLS+1 Using Progression BLPROG;
	Transfinite Line{blsplinelines[],splineline} = WINGCELLS+1 Using Bump WINGBUMP;

	//external bl loops.
	lines[]={leextlines[0],blsplinelines[0],teextlines[0],
		topblvertlines[3],bottomblvertlines[3],
		teextlines[2],blsplinelines[1],leextlines[2],
		bottomblvertlines[0],topblvertlines[0]};
	Call autoLineLoop;
	blloops[]+=ce;
	//internal bl loops.
	//le surfaces
	lines[] = {leextlines[0],topblvertlines[1],leextlines[1],topblvertlines[0]};
	Call autoLineLoop;
	Call PSS;
	b=ce;l[]={0,0,DZ};c=1;p=1;Call extrude;
	lines[] = {leextlines[1],bottomblvertlines[1],leextlines[2],bottomblvertlines[0]};
	Call autoLineLoop;
	Call PSS;
	b=ce;l[]={0,0,DZ};c=1;p=1;Call extrude;
	//te surfaces
	lines[] = {teextlines[0],topblvertlines[2],teextlines[1],topblvertlines[3]};
	Call autoLineLoop;
	Call PSS;
	b=ce;l[]={0,0,DZ};c=1;p=1;Call extrude;
	lines[] = {teextlines[1],bottomblvertlines[2],teextlines[2],bottomblvertlines[3]};
	Call autoLineLoop;
	Call PSS;
	b=ce;l[]={0,0,DZ};c=1;p=1;Call extrude;
	//wing surfaces
	lines[] = {splineline,topblvertlines[1],blsplinelines[0],topblvertlines[2]};
	Call autoLineLoop;
	Call PSS;
	b=ce;l[]={0,0,DZ};c=1;p=1;Call extrude;
	lines[] = {splineline,bottomblvertlines[1],blsplinelines[1],bottomblvertlines[2]};
	Call autoLineLoop;
	Call PSS;
	b=ce;l[]={0,0,DZ};c=1;p=1;Call extrude;
EndFor

//Surface from bls to boundary.
Plane Surface(ce++)={bbloop,blloops[]};
Recombine Surface{ce};
b=ce;l[]={0,0,DZ};c=1;p=1;Call extrude;
