# IMU-Aided Adaptive Mesh-Grid Based Video Motion Deblurring

This repository contains the implementation of the algorithm presented in the paper **"IMU-Aided Adaptive Mesh-Grid Based Video Motion Deblurring"**. The code is designed to handle non-uniform motion blur in videos by utilizing an adaptive mesh-grid approach, with a focus on balancing deblurring quality and computational efficiency.

## Overview

Traditional deblurring methods often assume uniform blur, which is computationally efficient but ineffective for non-uniform blur scenarios. Our proposed method addresses this limitation by:

- Dividing the video frame into a mesh-grid structure.
- Estimating the blur Point Spread Function (PSF) using data from an Inertial Measurement Unit (IMU).
- Adapting the size of the mesh-grid cells based on the spatial variance of blur magnitude in each frame.
- Offering two versions of the algorithm: one optimized for the best deblurring quality and another for a balance between quality and computational cost.
- Providing a trade-off parameter to adjust the mesh-grid size according to specific application needs.

## Features

- **Adaptive Mesh-Grid**: The grid size dynamically adjusts to handle areas with varying levels of blur, improving PSF estimation accuracy where needed.
- **IMU Integration**: Inertial sensor data is used to aid in accurate blur estimation, particularly for non-uniform motion.
- **Performance Options**: Choose between high-quality deblurring or a balanced approach with reduced computational requirements.
- **Trade-Off Parameter**: Customize the algorithm to fit your application's performance and quality needs.

## Dataset

The image dataset used in this study is generated from the videos that are available in the following links:
https://www.youtube.com/watch?v=wz3BGn--UIA
https://pixabay.com/videos/buddha-buddhism-asia-zen-203408/
