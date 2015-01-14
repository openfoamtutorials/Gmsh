#!/usr/bin/env python
# 1: case name
# 2: mesh name
# 3: Wing cells
# 4: first angle (deg)
# 5: last angle (deg)
# 6: angle increment (deg)

import sys
import os
import time

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
		if line.count("GLOBALAOA") > 0:
			lines[i] = "GLOBALAOA = "+str(aoa)+"*dtr;\n"
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

if len(sys.argv) < 7:
	print "You must supply all inputs! Exiting."
	sys.exit()

CASENAME = sys.argv[1]
MESHNAME = sys.argv[2]
WINGCELLS = sys.argv[3]
a0 = int(sys.argv[4])
af = int(sys.argv[5])
ai = int(sys.argv[6])
ANGLES = range(a0,af+ai,ai)

MESHFILE = "Meshes/"+MESHNAME+"/main.geo"

success = changeWingCells(MESHFILE,WINGCELLS)
if not success:
	print "Wing cell count in mesh could not be changed! Exiting."
	sys.exit()

BASENAME = CASENAME+"_"+MESHNAME+"_"+str(WINGCELLS)
performanceFile = open("Runs/"+BASENAME+"_timings","w")
startTime = time.clock()
prevTime = startTime
for angle in ANGLES:
	print "Working on AOA of "+str(angle)+" degrees"
	success = changeAOA(MESHFILE,angle)
	if not success:
		print "AOA in mesh could not be changed! Exiting."
		sys.exit()
	RUNNAME = BASENAME+"_"+str(angle)
	os.system("./run.py "+RUNNAME+" "+CASENAME+" "+MESHNAME)
	currentTime = time.clock()
	performanceFile.write("AOA = "+str(angle)+" run time: "+str(currentTime-prevTime)+" seconds\n")
	prevTime = currentTime
finishTime = time.clock()
elapsedTime = finishTime - startTime
print "Total run time: "+str(elapsedTime)+" seconds"
performanceFile.close()
