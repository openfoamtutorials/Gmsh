#!/usr/bin/env python

import sys
import shutil
import os
import subprocess

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
os.system("gmsh -3 "+newMeshDir+"/main.geo > gmshLog")

# Convert mesh.
os.system("gmshToFoam -case "+newCaseDir+" "+newMeshDir+"/main.msh > gmshToFoamLog")

