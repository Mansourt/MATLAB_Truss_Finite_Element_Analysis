# Matlab Truss Finite Element Analysis (FEA / FEM) 

MATLAB Code: 2D Truss (planar truss) Analyzer toolbox using FEM 
	

## Usage

Just run the **EVAL1.m** and **EVAL2.m**

### Example 1

``` MATLAB
%%  Truss Definition
clc, clear

T.node  = [0, 0; 0, 1; 1, 1];
T.element  = [2, 3, 8e-5, 200e9; 1, 3, 8e-5, 200e9];
T.force = [3, 1000, -90]; 
T.support  = [1, 2, 0; 2, 2, 0];
           
%% FEM Analysis 

Tr = TrussFEA(T);     % FEM Solver 
TrussPlotter(Tr, 1);  % Graphical visualization

```
<p align="center">
  <img src="../master/image/Truss1.png" />
</p>

### Example 2

``` MATLAB
%%  Truss Definition

clc, clear

T.node = [0, 0; 4, 0; 4, 4; 8, 0; 8, 6; 12, 0;12 4; 16, 0];
El_n = [1 2;1 3; 2 3; 3 4; 2 4; 3 5; 4 5; 4 7;4 6; 5 7; 6 7; 6 8; 7 8];
A = 1e-4; E = 200e9;
T.element = [El_n, A*ones(13,1), E*ones(13,1)];
T.force = [2, 3e3, -90; 4, 5e3, -90; 6, 4e3, -90];
T.support = [1 2 0; 8, 1, 2];

%% FEM Analysis 
Tr = TrussFEA(T); 		% FEM Solver 
TrussPlotter(Tr, 1);	% Graphical visualization

```
<p align="center">
  <img src="../master/image/Truss2.png" />
</p>

## Contact
Email: smtoraabi@ymail.com


## Video Tutorial [In Persian]

[1. Truss Analysis usign FEM - Part 1: Theory](https://www.aparat.com/v/0ZBFo)
تحلیل سازه خرپا به روش المان محدود - بخش 1: تئوری

[2. Truss Analysis using FEM - Part 2: Implementation In MATLAB](https://www.aparat.com/v/JoERK)
تحلیل سازه خرپا به روش المان محدود - بخش 2: پیاده سازی در متلب MATLAB
