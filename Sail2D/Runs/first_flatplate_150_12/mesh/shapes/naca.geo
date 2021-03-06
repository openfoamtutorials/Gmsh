//Gmsh
Function y_naca_symmetric//From x and bladeChord, calculates y.
	t=.12;
	r=x/bladeChord;
	term1=0.2969*Sqrt(r);
	term2=-0.1260*r;
	term3=-0.3516*r^2;
	term4=0.2843*r^3;
	term5=-0.1015*r^4;
	y=t/0.2*bladeChord*(term1+term2+term3+term4+term5);
Return
Function y_naca_cambered//From x and bladeChord, calculates y.
	p=0.4;//non-dimensional location of maximum camber.
	t=.12;//non-dimensional thickness.
	m=1;//non-dimensional maximum camber.
	r=x/bladeChord;//non-dimensional chord position.
	If(r>p)
		y=m*((c-x)/(1-p)^2)*(1+r-2*p);
	EndIf
	If(r<=p)
		y=m*x/p^2*(2*p-r);
	EndIf
	y=t/0.2*bladeChord*(term1+term2+term3+term4+term5);
Return
Function drawNaca//from bladeChord,ce,bladels,and le[], aoa; the Bspline line drawn.
	resolution=50;
	limit=6;
	points[]={};
	For k In {resolution:0:-1}
		x=k/resolution*bladeChord;
		Call y_naca_symmetric;
		If(k<=limit)
			Point(ce++)={le[0]+x,le[1]+y,0,bladels};
		EndIf
		If(k>limit)
			Point(ce++)={le[0]+x,le[1]+y,0,bladels};
		EndIf
		points[]+=ce;
	EndFor
	For k In {1:resolution}
		x=k/resolution*bladeChord;
		Call y_naca_symmetric;
		If(k<=limit)
			Point(ce++)={le[0]+x,le[1]-y,0,bladels};
		EndIf
		If(k>limit)
			Point(ce++)={le[0]+x,le[1]-y,0,bladels};
		EndIf
		points[]+=ce;
	EndFor
	points[]+=points[0];
	BSpline(ce++)=points[];
	Rotate {{0, 0, 1}, {le[0], le[1], 0}, -aoa} {
 		Line{ce};
	}
Return
