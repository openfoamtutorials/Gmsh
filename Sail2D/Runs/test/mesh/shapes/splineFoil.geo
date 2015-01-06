//Gmsh
Function splineFoil//s1,s2,ler,te[],ls,d1,d2,r1,r2,cc,aoa
	//s1: leading edge spans
	//s2: trailing edge spans
	//ler: leading edge radius
	//te[]: trailing edge coordinates
	//ls: length characteristic
	//d1: leading edge spline point tangential distance
	//d2: trailing edge spline point tangential distance
	//r1: rotation of the leading edge (including spline points)
	//r2: rotation of the trailing edge (including spline points)
	//cc: chord
	//aoa: angle of attack
	//outputs as 'spl[]' the resulting lines.
	
	//TRAILING EDGE
	st[]={};
	sb[]={};
	Point(ce++)={te[0],te[1],0,ls};st[0]=ce;sb[0]=ce;
	tesp[]={};
	Point(ce++)={Cos(Pi-s2/2)*d2+te[0],Sin(Pi-s2/2)*d2+te[1],0,ls};tesp[]+=ce;st[1]=ce;
	Point(ce++)={Cos(Pi+s2/2)*d2+te[0],Sin(Pi+s2/2)*d2+te[1],0,ls};tesp[]+=ce;sb[1]=ce;
	Rotate {{0,0,1},{te[0],te[1],0},-r2}{ Point{tesp[]}; }
	//LEADING EDGE
	lecx=te[0]-cc+ler;
	Point(ce++)={lecx,te[1],0,ls};lecp=ce;
	lesp[]={};
	Point(ce++)={lecx+Cos(Pi-s1/2)*ler,te[1]+Sin(Pi-s1/2)*ler,0,ls};lesp[]+=ce;st[3]=ce;
	Point(ce++)={lecx+Cos(Pi+s1/2)*ler,te[1]+Sin(Pi+s1/2)*ler,0,ls};lesp[]+=ce;sb[3]=ce;
	Point(ce++)={lecx+Cos(Pi-s1/2)*ler+d1*Cos(Pi/2-s1/2),te[1]+Sin(Pi-s1/2)*ler+d1*Sin(Pi/2-s1/2),0,ls};lesp[]+=ce;st[2]=ce;
	Point(ce++)={lecx+Cos(Pi+s1/2)*ler+d1*Cos(3*Pi/2+s1/2),te[1]+Sin(Pi+s1/2)*ler+d1*Sin(3*Pi/2+s1/2),0,ls};lesp[]+=ce;sb[2]=ce;
	Rotate {{0,0,1},{lecx,te[1],0},r1}{ Point{lesp[]}; }
	Rotate {{0,0,1},{te[0],te[1],0},-aoa}{ Point{lecp,lesp[],tesp[]}; }
	//OUTPUT LINES
	spl[]={};
	Circle(ce++)={sb[3],lecp,st[3]};spl[]+=ce;
	BSpline(ce++)=st[];spl[]+=ce;
	BSpline(ce++)=sb[];spl[]+=ce;
Return
