# Matlab_buit-in_solvers_bvp4c_and_bvp5c
This project explores the theoretical foundations and numerical solutions of Boundary Value Problems (BVPs), focusing on MATLAB's built-in solvers **bvp4c** and **bvp5c**. 

## Project Overview
The study analyzes collocation-based methods, specifically the **Lobatto IIIa** formulas, to understand the differences in accuracy, stability, and computational efficiency between the 4th-order (bvp4c) and 5th-order (bvp5c) implementations.

## Key Features
* **Theoretical Analysis:** Deep dive into collocation methods as a subset of weighted residual methods.
* **Interactive GUI:** A custom-built MATLAB App Designer interface to experiment with different BVP cases, providing immediate visual and quantitative feedback.
* **Case Studies Included:**
    * Falkner-Skan equation (infinite intervals).
    * Problems with singularities at the origin.
    * Three-point BVPs (domain decomposition).
    * Periodic solutions (free boundary problems).

## Tech Stack
* **Language:** MATLAB
* **Tools:** MATLAB App Designer, BVP Solvers (bvp4c, bvp5c)

## Conclusion
The project highlights the trade-off between the robustness of **bvp4c** (better for rough initial guesses) and the high-order efficiency of **bvp5c** (optimal for smooth solutions and high accuracy requirements).
