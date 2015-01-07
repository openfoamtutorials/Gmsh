#!/usr/bin/env python
# Input arguments:
# 1: Run name (to be written to Runs/)
# 2: Case name (of those in Cases/)
# 3: Mesh name (of those in Meshes/)

import sys
import shutil
import os
import subprocess

execfile('functions.py')

# Make new directories. 
if len(sys.argv) < 4:
	print "Not enough inputs! Please enter: Run Case Mesh"
	print "Exiting."
	sys.exit()
else:
	# Get inputs.
	runName = sys.argv[1]
	caseName = sys.argv[2]
	meshName = sys.argv[3]
	runDir = "Runs/"+runName
	caseDir = "Cases/"+caseName
	meshDir = "Meshes/"+meshName
	# Make run directory.	
	if not os.path.exists(runDir):
 		os.makedirs(runDir)
 	else:
 		print runDir+" already exists! Exiting."
 		sys.exit()
 	# Copy case and mesh to run directory.
	newCaseDir = runDir+"/case"
	newMeshDir = runDir+"/mesh"
	shutil.copytree(caseDir,newCaseDir)
	shutil.copytree(meshDir,newMeshDir)

# Make mesh.
os.system("gmsh -3 "+newMeshDir+"/main.geo > "+runDir+"/gmshLog")

# Convert mesh.
os.system("gmshToFoam -case "+newCaseDir+" "+newMeshDir+"/main.msh > "+runDir+"/gmshToFoamLog")

# Create baffles
# Steps:
# First delete the initial baffle entry (wings) because it is an empty set.
# Manually count the total number of faces to start the new baffle faces.
# Then call createBaffles

boundaryFileName = newCaseDir+"/constant/polyMesh/boundary"
boundaryLines = getLinesFromFile(boundaryFileName)
wingsLine = -1 # where the wing boundary condition starts.
wingsEndLine = -1 # where the wing boundary condition starts.

# Find 'wings' entry
for i in range(len(boundaryLines)):
	line = boundaryLines[i].strip()
	if line == "wings":
		wingsLine = i
	if wingsLine > 0 and wingsEndLine < 0 and line == "}":
		wingsEndLine = i
		break
# Check if 'wings' was found
if wingsLine < 0:
	print "The 'wings' entry was not found! Exiting."
	sys.exit()
# Write new file with 'wings' entry deleted.
boundaryFile = open(boundaryFileName,"w")
for i in range(0,wingsLine):
	if is_integer(boundaryLines[i].strip()):
		boundaryFile.write(str(int(boundaryLines[i].strip())-1)+"\n")
	else:
		boundaryFile.write(boundaryLines[i])
for i in range(wingsEndLine+1,len(boundaryLines)):
	boundaryFile.write(boundaryLines[i])
boundaryFile.close()

# Baffles setup.
startFace = getNumberOfFaces(newCaseDir)
addBoundary(boundaryFileName,"wings","wall","wall",startFace,0)
changeBoundaryType(boundaryFileName,"tunnel","wall","wall")
changeBoundaryType(boundaryFileName,"defaultFaces","empty","empty")
os.system("createBaffles -case "+newCaseDir+" -overwrite -dict system/baffleDict > "+newCaseDir+"/../baffleLog")