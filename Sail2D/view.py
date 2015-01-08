#!/usr/bin/env python
# 1: the name of the run to execute 'paraFoam'.


import os
import sys

execfile('functions.py')

if len(sys.argv) < 2:
	print "Run name not supplied! Exiting."
	sys.exit()

RUNNAME = sys.argv[1]

caseDir = "Runs/"+RUNNAME+"/case"
properChdir(caseDir)
os.system("paraFoam")