function trussData = TrussFEA(trussData)
% "Truss analyzer using Finite Element Method (FEM)" 

% trussData is a structure variable which contain all the truss data:

%   1-trussData.node   : contains all node data in a truss
%   2-trussData.element: contain a matrix which determine element position 
%                        between defined nodes in the truss and also structural
%                        info of each element
%   3-trussData.force:   contains information aboust external forces
%   4-trussData.support: contains information about supports

% trussData structure fields:
% .node         : column 1: x position
%               : column 2: y position

% .element      : column 1&2: location
%               : column 3: area cross section
%               : column 4: elasticity

% .force        : column 1: location
%               : column 2: force magnitude 
%               : column 3: force angle

% .support      : column 1: location 
%               : column 2: type [1:roller, 2:pin]
%               : column 3: orientation [roller(1: H|2: V), pin(0:)]

%% Primary process
% extracting data from trussData
Nodes          = trussData.node;
Elements       = trussData.element;
Supports       = trussData.support;
ExternalForces = trussData.force;


% loop for calculating each element' angle, length and stiffness matrix
for i = 1:size(Elements,1)
    
    n1 = Elements(i,1);
    n2 = Elements(i,2);
    
    x1 = Nodes(n1,1); 
    x2 = Nodes(n2,1); 
    Dx = x2-x1;
    
    y1 = Nodes(n1,2); 
    y2 = Nodes(n2,2); 
    Dy = y2-y1;
 
    L  = sqrt(Dx^2+Dy^2);   % Element Length
    Th = atan2(Dy,Dx);      % Element Angles
       
    A = Elements(i,3);         % Cross-sectional area
    E = Elements(i,4);         % Young's Modulus
    
    S = sin(Th);    % sine of theta      
    C = cos(Th);    % cosine of theta
    
    % Element stiffness matrix
    k{i} = A*E/L * [C^2 S*C -C^2 -S*C; 
                    S*C S^2 -S*C -S^2; 
                    -C^2 -S*C C^2 S*C; 
                    -S*C -S^2 S*C S^2];
                 
    % Saving element' info   
    Elements(i, 5) = L;
    Elements(i, 6) = Th;

end

% Saving data for output
trussData.element = Elements;
%% (3) Assembling global stiffness matrix

K  = zeros(2*size(Nodes,1)); % Pre-allocation
K0 = K;

for i = 1:size(Elements,1)

    n1 = Elements(i,1); 
    n2 = Elements(i,2);
    
    K0(2*n1-1:2*n1, 2*n1-1:2*n1) = k{i}(1:2,1:2);
    K0(2*n1-1:2*n1, 2*n2-1:2*n2) = k{i}(1:2,3:4);
    K0(2*n2-1:2*n2, 2*n1-1:2*n1) = k{i}(3:4,1:2);
    K0(2*n2-1:2*n2, 2*n2-1:2*n2) = k{i}(3:4,3:4);
    
    % Constructing assembled matrix    
    K = K + K0;
    K0(:,:) = 0;
end

%% (4) Applying external forces in the equation

F0 = zeros(2*size(Nodes,1),1);

for i = 1:size(ExternalForces,1)
    
    Fnode  = ExternalForces(i,1);
    Fmag   = ExternalForces(i,2);
    Ftheta = ExternalForces(i,3)/180*pi;
    
    fx = Fmag * cos(Ftheta);
    fy = Fmag * sin(Ftheta);
    
    F0(2*Fnode-1:2*Fnode, 1) = [fx; fy];
end

%% (5) Applying supports (Boundary Conditions) in the equation, 

cnt = 0;
for i = 1:size(Supports,1);  
    
    Snode  = Supports(i,1); % Support node
    Stype  = Supports(i,2); % Support type (Roller or Pin)
    Sorien = Supports(i,3); % Support Orientation
    
    if Stype == 1     % if Roller
        if Sorien == 1         % if Horizontal
            cnt    = cnt+1; 
            uu_zero(cnt) = 2*Snode-1;
        elseif Sorien == 2     % if Vertical
            cnt = cnt+1; 
            uu_zero(cnt) = 2*Snode;
        end        
    elseif Stype == 2 % if Pin
        cnt = cnt+2; 
        uu_zero(cnt-1:cnt) = 2*Snode-1:2*Snode;
    end
end

%% (6) Solving equation
% Condensing stiffness matrix and force array
Kc = K;
Fc = F0;

Kc(:, uu_zero) = [];  % Removing Columns
Kc(uu_zero, :) = [];  % Removing Rows

Fc(uu_zero,:)  = [];  % Removing Rows from "Force" Vector

U0 = Kc^-1*Fc;        % Nodal displacements 

uu_all     = 1:2*size(Nodes,1); 
uu_nonzero = uu_all; 
uu_nonzero(uu_zero) = [];

U(uu_all,1)     = 0; 
U(uu_nonzero,1) = U0;   % Nodal displacements array

F = K*U;                % Nodal forces array

% saving nodal displacements and forces
trussData.nodalDisplacement = reshape(U, 2, length(U)/2).';
trussData.nodalForce        = reshape(F, 2, length(F)/2).';
%% (6) Solving equation-Post Process: Element Force, Stress

for i = 1:size(Elements,1);
    
    L  = Elements(i, 5);
    Th = Elements(i, 6);
    
    S = sin(Th); 
    C = cos(Th);
    
    n1 = Elements(i,1); 
    n2 = Elements(i,2);
    
    % Element Elongation
    Delta = [-C,-S,C,S]*[U(2*n1-1); U(2*n1); U(2*n2-1); U(2*n2)];
    
    A = Elements(i,3); 
    E = Elements(i,4);
   
    P = A*E/L * Delta;
    
    El_result(i, 1) = Delta;  % Element elongation
    El_result(i, 2) = P;      % Element axial force
    El_result(i, 3) = P/A;    % Element stress
end

% Saving element' data
trussData.elementElongation = El_result(:,1);
trussData.elementForce      = El_result(:,2);
trussData.elementStress     = El_result(:,3);