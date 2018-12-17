#!/bin/sh
# Source tutorial run functions
. $WM_PROJECT_DIR/bin/tools/CleanFunctions
. $WM_PROJECT_DIR/bin/tools/RunFunctions

# Breast meshing
                                               
cleanCase
runApplication pyFoamFromTemplate.py system/blockMeshDict "{'br':0.072}"
rm log.pyFoamFromTemplate.py
runApplication blockMesh                          # base structured blockMesh
runApplication pyFoamFromTemplate.py system/snappyHexMeshDict "{'br':0.072}"
rm log.pyFoamFromTemplate.py
runApplication snappyHexMesh -overwrite               # snappy hex mesh to chisel into curved shape

# TOPOSET TO DEFINE DIFFERENT CELL ZONES
runApplication pyFoamFromTemplate.py system/topoSetDict  "{'x':0, 'y':0.05, 'z':0, 'r':0.01, 'gr':0.072}"
rm log.pyFoamFromTemplate.py
runApplication topoSet

# SPLIT MESH AS PER DIFFERENT ZONES
runApplication splitMeshRegions -cellZones -overwrite 

# RUN changeDictionary TO DEFINE INITIAL CONDITIONS FOR EACH REGION 
for i in gland tumor
do
   runApplication -s $i changeDictionary -region $i
done

runApplication setFields -region gland                     

# SETTING METABOLIC HEAT GENERATION RATE OF TUMOR
runApplication pyFoamFromTemplate.py constant/tumor/fvOptions "{'r':0.005}"

# RUN SOLVER ON SINGLE PROCESSOR

runApplication pyFoamPlotRunner.py --hardcopy --progress chtMultiRegionSimpleFoam
#runApplication chtMultiRegionSimpleFoam -postProcess -func surfaces 
#runApplication `getApplication`

# RUN CASE REPORT TO CHECK THE BOUNDARY CONDITIONS
runApplication pyFoamCaseReport.py --short-bc .

# Decompose
#runApplication decomposePar -allRegions

# Run
#runParallel `getApplication`

# Reconstruct
#runApplication reconstructPar -allRegions

# POST PROCESSING
echo
echo "creating files for paraview post-processing"
echo
paraFoam -touchAll

runApplication touch all.foam
#runApplication paraview all.foam

