%%  Truss Definition

clc, clear

T.node = [0, 0; 4, 0; 4, 4; 8, 0; 8, 6; 12, 0;12 4; 16, 0];

El_n = [1 2;1 3; 2 3; 3 4; 2 4; 3 5; 4 5; 4 7;4 6; 5 7; 6 7; 6 8; 7 8];

A = 1e-4; E = 200e9;
T.element = [El_n, A*ones(13,1), E*ones(13,1)];

T.force = [2, 3e3, -90; 4, 5e3, -90; 6, 4e3, -90];
T.support = [1 2 0; 8, 1, 2];


%% FEM Analysis 

Tr = TrussFEA(T);
TrussPlotter(Tr, 1);
%% Displaying Results

fprintf('\n')
Elements = Tr.element;

for i = 1:size(Elements,1);    
   fprintf('Element (%g) Elongation: %g um\n',i, Tr.elementElongation(i)*1e6)      
end

fprintf('\n')

for i = 1:size(Elements,1);    
   fprintf('Element (%g) Force     : %g  N\n',i, Tr.elementForce(i))
end

fprintf('\n')

for i = 1:size(Elements,1);    
   fprintf('Element (%g) Stress    : %g  MPa\n',i, Tr.elementStress(i)/1e6)
end