clear all;
close all;

% Add root
addpath('..')
addpath('../lib');
addpath('../class');
addpath('../lib/spaceplots');
% Add Dubins plot tool
if exist('dubins') ~= 3
    if exist('../lib/DubinsPlot') ~= 7
        error('Could not find the DubinsPlot folder.');
    end
    addpath('../lib/DubinsPlot');
    if exist('dubins') ~= 3
        error('Could not find compiled dubins mex file.');
    end
end

%=============== Settings ===============
useSubplot = true;

EPSILON_ERROR = 0.05; % error margin in length calculation

Va = 10; % (m/s) fixed airspeed
phi_max = degtorad(45); % (rad) maximum bank angle (+ and -)
g = 9.8; %(m/s^2)

r = 1;

% Path options
opts = PathOptions;
%opts.TurnRadius = Va^2/(tan(phi_max)*g); % (m) turn radius for dubins path
opts.TurnRadius = r;
opts.DubinsStepSize = 0.01; % [sec]
opts.HeadingArrowSize = 0.7;
opts.Debug = 'on';


%% Case I, R-S-R
fh1 = figure();
if useSubplot
    subplot(221);
end

% Position
startPosition = [0 -2];
startHeading = deg2rad(300); % radians
endPosition = [5 0];
endHeading = deg2rad(180); % radians

q0 = [startPosition heading2angle(startHeading)];
q1 = [endPosition heading2angle(endHeading)];

% Plotting
path = dubins(q0, q1, opts.TurnRadius, opts.DubinsStepSize);
plot([startPosition(1) endPosition(1)], [startPosition(2) endPosition(2)],...
    'ko', 'MarkerFaceColor', 'k')
L =  findDubinsLength(startPosition, startHeading, endPosition, endHeading,...
    opts.TurnRadius, 1);
set(0,'currentFigure',fh1)
hold on;
plot(path(1,1:end), path(2,1:end), 'Color', 'g');
title('Case I: R-S-R');
yl = ylim();
%text(0,yl(1)+5,sprintf('L = %.2f',L));

% Count length of path from DubinsPlot tool
Lexpected = 0;
for i=2:length(path)
    l_i = sqrt((path(1,i) - path(1,i-1))^2 + (path(2,i) - path(2,i-1))^2);
    Lexpected  = Lexpected + l_i;
end % for

set(gca, 'XTick', []);
set(gca, 'YTick', []);
set(gca,'XTickLabel','');
set(gca,'YTickLabel','');
title('');
spaceplots();
print;

%% Case II, R-S-L
if useSubplot
    subplot(222);
else
    
    fh2 = figure();
end

% Position
startPosition = [0 -2.5];
startHeading = deg2rad(330); % radians
endPosition = [5.27*r 0];
endHeading = deg2rad(22); % radians

q0 = [startPosition heading2angle(startHeading)];
q1 = [endPosition heading2angle(endHeading)];

% Plotting
path = dubins(q0, q1, opts.TurnRadius, opts.DubinsStepSize);
plot([startPosition(1) endPosition(1)], [startPosition(2) endPosition(2)],...
    'ko', 'MarkerFaceColor', 'k')
L =  findDubinsLength(startPosition, startHeading, endPosition, endHeading,...
    opts.TurnRadius, 1);
if ~useSubplot
    set(0,'currentFigure',fh2)
end
hold on;
plot(path(1,1:end), path(2,1:end), 'Color', 'g');
title('Case II: R-S-L');
yl = ylim();
%text(0,yl(1)+5,sprintf('L = %.2f',L));

% Count length of path from DubinsPlot tool
Lexpected = 0;
for i=2:length(path)
    l_i = sqrt((path(1,i) - path(1,i-1))^2 + (path(2,i) - path(2,i-1))^2);
    Lexpected  = Lexpected + l_i;
end % for

set(gca, 'XTick', []);
set(gca, 'YTick', []);
set(gca,'XTickLabel','');
set(gca,'YTickLabel','');
title('');
spaceplots();
print;

%% Case III, L-S-R
if useSubplot
    subplot(223);
else
    
    fh3 = figure();
end


% Position
startPosition = [0 4.3];
startHeading = deg2rad(232); % radians
endPosition = [4.2*r 0];
endHeading = deg2rad(290); % radians
q0 = [startPosition heading2angle(startHeading)];
q1 = [endPosition heading2angle(endHeading)];

% Plotting
path = dubins(q0, q1, opts.TurnRadius, opts.DubinsStepSize);
plot([startPosition(1) endPosition(1)], [startPosition(2) endPosition(2)],...
    'ko', 'MarkerFaceColor', 'k')
L =  findDubinsLength(startPosition, startHeading, endPosition, endHeading,...
    opts.TurnRadius, 1);
if ~useSubplot
    set(0,'currentFigure',fh3)
end
hold on;
plot(path(1,1:end), path(2,1:end), 'Color', 'g');
title('Case III: L-S-R');
yl = ylim();
%text(0,yl(1)+5,sprintf('L = %.2f',L));

% Count length of path from DubinsPlot tool
Lexpected = 0;
for i=2:length(path)
    l_i = sqrt((path(1,i) - path(1,i-1))^2 + (path(2,i) - path(2,i-1))^2);
    Lexpected  = Lexpected + l_i;
end % for

set(gca, 'XTick', []);
set(gca, 'YTick', []);
set(gca,'XTickLabel','');
set(gca,'YTickLabel','');
title('');
spaceplots();
print;

%% Case IV, L-S-L
if useSubplot
    subplot(224);
else
    
    fh4 = figure();
end


% Position
startPosition = [0 4.3];
startHeading = deg2rad(195); % radians
endPosition = [5.27*r 0];
endHeading = deg2rad(40); % radians
q0 = [startPosition heading2angle(startHeading)];
q1 = [endPosition heading2angle(endHeading)];

% Plotting
path = dubins(q0, q1, opts.TurnRadius, opts.DubinsStepSize);
plot([startPosition(1) endPosition(1)], [startPosition(2) endPosition(2)],...
    'ko', 'MarkerFaceColor', 'k')
L =  findDubinsLength(startPosition, startHeading, endPosition, endHeading,...
    opts.TurnRadius, 1);
hold on;
if ~useSubplot
    set(0,'currentFigure',fh4)
end
plot(path(1,1:end), path(2,1:end), 'Color', 'g');
title('Case IV: L-S-L');
yl = ylim();
%text(0,yl(1)+5,sprintf('L = %.2f',L));

% Count length of path from DubinsPlot tool
Lexpected = 0;
for i=2:length(path)
    l_i = sqrt((path(1,i) - path(1,i-1))^2 + (path(2,i) - path(2,i-1))^2);
    Lexpected  = Lexpected + l_i;
end % for

set(gca, 'XTick', []);
set(gca, 'YTick', []);
set(gca,'XTickLabel','');
set(gca,'YTickLabel','');
title('');
spaceplots();
print;
