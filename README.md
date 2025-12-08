# Stereo Block Matching – TP Stereovision

Implementation of a stereo vision pipeline for disparity estimation using block matching.

## Features

- Load stereo image pairs (Venus dataset)
- Block matching disparity estimation (SAD/SSD/NCC)
- Contrast filtering for homogeneous blocks
- Hole filling and disparity refinement
- Left-right consistency check
- Global optimization:
  - Relaxation
  - Dynamic programming
- Evaluation metrics:
  - Mean Relative Error (MRE)
  - Reprojection error
