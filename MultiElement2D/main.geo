//Gmsh
//Under construction. Uses the spline foil shape.

//Constants
dtr = Pi/180;

//INPUTS
BASEDIM = 0.1;//m, base dimension so that everything can be scaled according to this number.
BBDIM = 20*BASEDIM;//Boundaing domain square dimension.

//AIRFOIL DIMENSIONS
NE = 3;//number of elements.
CHORDS = {BASEDIM, BASEDIM, BASEDIM};
ANGLES = {-10*dtr,0*dtr,10*dtr};
SPAN = {180, 10};//deg, leading, trailing, as per splineFoil specifications for s1 and s2
LERADIUS = 0.1;//factor for leading edge radii (multiple of chord).
ROTATIONS = {10,10};//deg, leading, trailing; splineFoil input.

//GRID PARAMETERS
SURFACECL = BASEDIM/50;//characteristic length on the surfaces of the airfoils.
BBCL = 10*BASEDIM;//bounding box characteristic length.

//PREPROCESSED VARIABLES

//START SCRIPT
ce=0;//initialize the current entity counter.

For k In {0:NE-1}
	Printf('%g',k);
EndFor