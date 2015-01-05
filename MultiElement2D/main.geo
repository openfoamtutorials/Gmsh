//Gmsh

//Constants
dtr = Pi/180;

//INPUTS
BASEDIM = 0.1;//m, base dimension so that everything can be scaled according to this number.
BBDIM = 20*BASEDIM;//Boundaing domain square dimension.

//AIRFOIL DIMENSIONS
CHORDS = {BASEDIM, BASEDIM, BASEDIM};
ANGLES = {-10*dtr,0*dtr,10*dtr};


//GRID PARAMETERS
SURFACECL = BASEDIM/50;//characteristic length on the surfaces of the airfoils.

//START SCRIPT
ce=0;//initialize the current entity counter.

