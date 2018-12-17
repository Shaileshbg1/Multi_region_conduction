# Multi_region_conduction
Multi region conduction with regions defined using topoSet

As in the previous repository,'OpenFOAM cases', the physical problem addressed here is still heat transfer inside a breast with malignant tissue.
But here we have used some neat OpenFOAM utilities to simplify the process, like:
1) topoSet : Operates on cellSets/faceSets/pointSets through a dictionary
2) splitMeshRegions: Splits mesh into multiple regions, based on the cell sets created using topoSet.
3) setFields: To set properties only to some points/faces or cells inside the region.

This way we can define mutiple regions in the mesh and assign it different properties by selecting topology with topoSet and splitting mesh with splitMeshRegions as per the selected topology. Then we use changeDictionaryDict utility to define boundary conditions for each region.

Along with this template files are used to modify important properties for automatic parametric analysis using pyFoam.
