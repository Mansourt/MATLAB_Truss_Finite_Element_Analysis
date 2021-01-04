function TrussPlotter(trussData,stateId)
%% Data Extracing 
nodes0         = trussData.node;
nodesDis       = trussData.nodalDisplacement;
elements       = trussData.element;
elementsStress = trussData.elementStress;
supports       = trussData.support;
externalForces = trussData.force;
% primary graphic setting--------------------------------------------------
h1 = figure(1); set(h1,'color',[.8 .9 .9],'toolbar','none','menubar','none',...
    'NumberTitle','off','name','Defined truss by user');
axes('PlotBoxAspectRatio',[3 4 4],'PlotBoxAspectRatioMode','manual',...
    'visible', 'off', 'DataAspectRatio',[1 1 1]);

% check for the stateId----------------------------------------------------
% finding the  range of x & y data to design supports
Rx = max(nodes0(:,1))-min(nodes0(:,1));Ry = max(nodes0(:,2))-min(nodes0(:,2));
Rm = abs(mean([Rx Ry]));
ScaledNodesDis = nodesDis/max(max(abs(nodesDis)))*Rm*0.1;
if ~stateId
    nodes = nodes0;
else
    nodes = nodes0+ScaledNodesDis;
end

%% link plotting------------------------------------------------------------
if ~stateId
    for i = 1:size(elements,1)
        x1 = nodes(elements(i,1),1); x2 = nodes(elements(i,2),1);
        y1 = nodes(elements(i,1),2); y2 = nodes(elements(i,2),2);
        line([x1, x2], [y1, y2],'linewidth',5, 'color',[0 0 1])
        text(mean([x1, x2]), mean([y1, y2]),['[',num2str(i),']'],'fontweight','bold','fontsize',14,'color','k');
        hold on
    end
else
    eS = elementsStress; minS = min(eS); maxS = max(eS);
    for i = 1:size(elements,1)
        % color determination
        R = (eS(i)-minS)/(maxS-minS);
        line([nodes(elements(i,1),1), nodes(elements(i,2),1)], [nodes(elements(i,1),2),...
            nodes(elements(i,2),2)],'linewidth',5, 'color',[R 0 1-R])
        % primary state
        x1 = nodes0(elements(i,1),1); x2 = nodes0(elements(i,2),1);
        y1 = nodes0(elements(i,1),2); y2 = nodes0(elements(i,2),2);
        line([x1, x2], [y1, y2],'linewidth',1,'lineStyle','--','color',[0 0 1]);
        text(mean([x1, x2]), mean([y1, y2]),['[',num2str(i),']'],'fontweight','bold','fontsize',14,'color','k');
        hold on
    end
end


%% support plotting---------------------------------------------------------
for i = 1:size(supports,1)
    if supports(i,2) == 1
        if supports(i,3) == 1
            x0 = nodes(supports(i,1),1); y0 = nodes(supports(i,1),2);
            % circle
            xc = x0+(0.2*Rm)*0.866; yc = [y0+(0.2*Rm)*0.25, y0+(0.2*Rm)*0.25];
            t = 0:.1:2*pi; Xc = xc+(Rm/60)*cos(t); Yc(1,:) = yc(1)+(Rm/60)*sin(t); Yc(2,:) = yc(1)+(Rm/60)*sin(t);
            fill(Xc,Yc(1,:),[1 0 0]); fill(Xc,Yc(2,:),[1 0 0])
            % triangle
            fill([x0, x0+(0.2*Rm)*0.866, x0+(0.2*Rm)*0.866, x0], [y0, y0+(0.2*Rm)*0.5,...
                y0-(0.2*Rm)*0.5, y0],[1 1 0])
        elseif supports(i,3) == 2
            x0 = nodes(supports(i,1),1); y0 = nodes(supports(i,1),2);
            % circle
            xc = [x0+(0.2*Rm)*0.25, x0-(0.2*Rm)*0.25] ; yc = y0-(0.2*Rm)*0.866;
            t = 0:.1:2*pi; Xc(1,:) = xc(1)+(Rm/60)*cos(t); Xc(2,:) = xc(2)+(Rm/60)*cos(t); Yc(1,:) = yc(1)+(Rm/60)*sin(t);
            fill(Xc(1,:),Yc,[1 0 0]); fill(Xc(2,:),Yc,[1 0 0])
            % triangle
            fill([x0, x0+(0.2*Rm)*0.5, x0-(0.2*Rm)*0.5, x0], [y0, y0-(0.2*Rm)*0.866,...
                y0-(0.2*Rm)*0.866, y0],[1 1 0])
        end
    elseif supports(i,2) == 2
        x0 = nodes(supports(i,1),1); y0 = nodes(supports(i,1),2);
        % beneath cross
        X = linspace(x0-(0.2*Rm)*0.5,x0+(0.2*Rm)*0.5,5); Y = ones(5,1)*[y0-(0.2*Rm)*0.866];
        plot(X,Y,'x','markersize',10)
        % triagle
        fill([x0, x0+(0.2*Rm)*0.5, x0-(0.2*Rm)*0.5, x0], [y0, y0-(0.2*Rm)*0.866,...
            y0-(0.2*Rm)*0.866, y0],[1 1 0])
        
    end
end
%% force plotting-----------------------------------------------------------

for i = 1:size(externalForces,1)
    % line arrow
    nId = externalForces(i,1); Mag = externalForces(i,2); th = externalForces(i,3)/180*pi;
    Xend = nodes(nId,1)+(Rm*.3)*cos(th); Yend = nodes(nId,2)+(Rm*0.3)*sin(th);
    line([nodes(nId,1),Xend],[nodes(nId,2),Yend],'color',[1 .5 .8],'LineWidth',2);
    % head arrow
    plot(Xend,Yend,'O','MarkerSize',11,'color',[1 .5 .8])
    text(Xend*1.01,Yend,['\{',num2str(i),'\}:',num2str(Mag)],'color','b','fontweight','bold');
end

%% node ploting-------------------------------------------------------------
if ~stateId
    plot(nodes(:,1),nodes(:,2),'o' ,'linewidth',8, 'markersize',5, 'color',[0.45 0.26 0.26])
else
    plot(nodes(:,1), nodes(:,2),'o' ,'linewidth',8, 'markersize',5, 'color',[0.45 0.26 0.26])
    plot(nodes0(:,1),nodes0(:,2),'.', 'markersize',20, 'color',[0 0 0])
end
for i = 1:size(nodes,1)
    text(nodes(i,1),nodes(i,2),['  (',num2str(i),')'],'FontSize',11,'FontWeight','Bold')
end
axis off




