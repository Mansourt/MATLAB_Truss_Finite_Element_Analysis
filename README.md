# Matlab Truss Finite Element Analysis (FEA / FEM) 

MATLAB Code: 2D Truss (planar truss) can be analyzed using FEM 

	
	

## Usage

Just run the **EVAL1.m** and **EVAL2.m**

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

![Result of Analyzed Truss](../master/image/Truss1.jpg?raw=true "Result of Analyzed Truss")