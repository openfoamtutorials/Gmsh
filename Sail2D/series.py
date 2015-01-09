#!/usr/bin/env python
# 1: series base name
# 2: case name
# 3: mesh name
# 4: first angle (deg)
# 5: last angle (deg)
# 6: angle increment (deg)
# 7: wing cells

import sys
import os

execfile('functions.py')
def changeAOA(path,aoa):
	"""
	Changes the gmsh file (at 'path') for a new angle of attack.
	aoa: degrees.
	For the flatplate mesh.
	"""
	lines = getLinesFromFile(path)
	success = 0
	for i in range(len(lines)):
		line = lines[i]
		if line.count("ANGLES[]") > 0 and line.count("EANGLES[]") == 0:
			lines[i] = "ANGLES[] = {"+str(aoa)+"*dtr};//angles of attack for each element.\n"
			success = 1
			break
	writeToFile(path,lines)
	return success

def changeWingCells(path,nc):
	"""
	Changes the gmsh file (at 'path') for a new resolution.
	nc: number of cells.
	For the flatplate mesh.
	"""
	lines = getLinesFromFile(path)
	success = 0
	for i in range(len(lines)):
		line = lines[i]
		if line.count("WINGCELLS") > 0:
			lines[i] = "WINGCELLS = "+str(nc)+";\n"
			success = 1
			break
	writeToFile(path,lines)
	return success

if len(sys.argv) < 8:
	print "You must supply all inputs! Exiting."
	sys.exit()

BASENAME = sys.argv[1]
CASENAME = sys.argv[2]
MESHNAME = sys.argv[3]
a0 = int(sys.argv[4])
af = int(sys.argv[5])
ai = int(sys.argv[6])
ANGLES = range(a0,af+ai,ai)
WINGCELLS = sys.argv[7]

MESHFILE = "Meshes/"+MESHNAME+"/main.geo"

success = changeWingCells(MESHFILE,WINGCELLS)
if not success:
	print "Wing cell count in mesh could not be changed! Exiting."
	sys.exit()
for angle in ANGLES:
	print "Working on AOA of "+str(angle)+" degrees"
	success = changeAOA(MESHFILE,angle)
	if not success:
		print "AOA in mesh could not be changed! Exiting."
		sys.exit()
	os.system("./run.py "+BASENAME+"_"+str(angle)+"_"+str(WINGCELLS)+" "+CASENAME+" "+MESHNAME)
