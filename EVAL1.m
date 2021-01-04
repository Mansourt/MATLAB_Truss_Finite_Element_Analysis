%%  Truss Definition

clc, clear

T.node  = [0, 0; 0, 1; 1, 1];

T.element  = [2, 3, 8e-5, 200e9; 1, 3, 8e-5, 200e9];

T.force = [3, 1000, -90]; 

T.support  = [1, 2, 0; 2, 2, 0];
           
%% FEM Analysis 

Tr = TrussFEA(T);     % FEM Solver 
TrussPlotter(Tr, 1);  % Graphical visualization

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