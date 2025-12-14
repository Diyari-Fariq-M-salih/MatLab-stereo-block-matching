# MATLAB Stereo Block Matching – Depth Estimation & Vision Notes

This repository implements **stereo vision using block matching** in **MATLAB** to estimate **depth from two cameras**.
It is intended to serve as both:
- A **working stereo vision implementation**
- A **study notebook** for computer vision and robotics perception

Stereo block matching is a classical method widely used in:
- Robotics
- Autonomous driving
- 3D reconstruction
- Depth sensing

---

## Project Overview

Stereo vision estimates **depth** by comparing two images captured from slightly different viewpoints (left and right cameras).

The key idea:
> **Objects closer to the camera shift more between the two images than distant objects**.

This shift is called **disparity**.

---

## Typical Repository Structure

```text
MatLab-stereo-block-matching/
├── stereo_block_matching.m
├── compute_disparity.m
├── cost_function.m
├── disparity_to_depth.m
├── visualize_disparity.m
├── load_stereo_images.m
├── README.md
└── .gitattributes
```

(Filenames may vary slightly, but the logical flow remains the same.)

---

## Core Stereo Vision Geometry

### 1. Disparity

Disparity is defined as:

```
d = x_left − x_right
```

Where:
- `x_left`  = pixel coordinate in left image
- `x_right` = pixel coordinate in right image

---

### 2. Depth Equation

Depth is inversely proportional to disparity:

```
Z = (f · B) / d
```

Where:
- `Z` = depth
- `f` = focal length
- `B` = baseline (distance between cameras)
- `d` = disparity

Analogy:  
Hold your thumb up and close one eye at a time — nearby objects shift more than far ones.

---

## Block Matching Algorithm

### What Is Block Matching?

Instead of matching individual pixels, the algorithm:
- Takes a **small window (block)** around a pixel
- Searches for the best matching block in the other image

This improves robustness to noise.

---

### Cost Functions

Common similarity measures:

#### Sum of Absolute Differences (SAD)

```
SAD = Σ |I_L(x, y) − I_R(x − d, y)|
```

#### Sum of Squared Differences (SSD)

```
SSD = Σ (I_L − I_R)²
```

The disparity with **minimum cost** is chosen.

Analogy:  
Sliding a transparent patch over an image until it looks most similar.

---

## Algorithm Pipeline

### 1. Image Rectification
Ensures corresponding points lie on the same horizontal line.

### 2. Disparity Search
Search along epipolar lines for best match.

### 3. Disparity Map Construction
Each pixel stores its disparity value.

### 4. Depth Map Conversion
Disparity values are converted into depth.

---

## Visualization

### Disparity Map

- Bright pixels → closer objects
- Dark pixels → farther objects

### Depth Map

Often color-coded for easier interpretation.

Visualization helps convert **math into intuition**.

---

## Using This Repository as Study Notes

### Suggested Learning Flow
1. Inspect stereo images
2. Run block matching
3. Visualize disparity map
4. Convert disparity to depth
5. Modify window size and observe effects

### Experiments to Try
- Increase block size → smoother but less detailed depth
- Decrease block size → sharper but noisier depth
- Change cost function (SAD vs SSD)

---

## Requirements

- MATLAB
- Image Processing Toolbox (recommended)

---

## Learning Outcomes

By studying this repository, you will understand:
- Stereo camera geometry
- Disparity and depth estimation
- Block matching trade-offs
- Practical limitations of stereo vision

---

## Final Note

Stereo vision shows how **3D structure emerges from two flat images** —  
a powerful idea that underpins modern robotics and autonomous systems.
