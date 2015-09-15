function [ length ] = findDubinsLength( p_s, x_s, p_e, x_e, r, debugMode)
%FINDDUBINSLENGTH Find the length of the shortest Dubins path
%   Parameters:
%       p_s     Start position as a 1-by-2 matrix
%       x_s     Start angle in radians
%       p_e     End position as a 1-by-2 matrix
%       x_e     End angle in radians
%       r       Turn radius
%       debugMode   Plots Dubins circles TODO plot course
%   Returns:
%       length  Length of the path
%
DEBUG_VERBOSE = 0;
%============= Input Validation ===============
if nargin < 1
    error('No input arguments given!');
elseif nargin > 6
    error('Too many arguments given!');
end
if (debugMode & strcmpi(debugMode,'off'))
    debugMode = 0;
end

if norm(p_s - p_e) < 3*r
    error('Start and end position distance must be larger than 3 times the radius.');
end

[~,pdim] = size(p_s);
if (pdim < 3)
    p_s = [p_s 0];
end
[~,pdim] = size(p_e);
if (pdim < 3)
    p_e = [p_e 0]; 
end

theta_s = heading2Theta(x_s);
theta_e = heading2Theta(x_e);

% Inline function for right-handed rotation of theta about z-axis
% TODO be sure we aren't using anonymous functions anywhere. They are slow.
%rotm = @(theta) [cos(theta) sin(theta) 0; -sin(theta) cos(theta) 0; 0 0 1]';

% TODO replace everywhere with wrapTo2Pi()
%wrap = @(theta) mod(theta,2*pi);


% Find circles for each case
% TODO determine why these are wrong
%c_rs = p_s' + r*rotm(pi/2)*[cos(x_s) sin(theta_s) 0]';
%c_ls = p_s' + r*rotm(-pi/2) * [cos(x_s) sin(theta_s) 0]';
%c_re = p_e' + r*rotm(pi/2) * [cos(x_e) sin(x_e) 0]';
%c_le = p_e' + r*rotm(-pi/2) * [cos(x_e) sin(x_e) 0]';
% 
c_rs = p_s' + r*[cos(theta_s - pi/2) sin(theta_s - pi/2) 0]';
c_ls = p_s' + r*[cos(theta_s + pi/2) sin(theta_s + pi/2) 0]';
c_re = p_e' + r*[cos(theta_e - pi/2) sin(theta_e - pi/2) 0]';
c_le = p_e' + r*[cos(theta_e + pi/2) sin(theta_e + pi/2) 0]';

%============ Calculate Lengths ===============
if (debugMode)
    plotScenario(p_s, x_s, p_e, x_e, c_rs, c_ls, c_re, c_le,r)
end

% Case I, R-S-R
theta = findHeadingFrom(c_rs,c_re);
L1 = norm(c_rs - c_re) + r*wrapTo2Pi(2*pi + wrapTo2Pi(theta - pi/2) - wrapTo2Pi(x_s - pi/2))...
    + r*wrapTo2Pi(2*pi + wrapTo2Pi(x_e - pi/2) - wrapTo2Pi(theta - pi/2));
if (debugMode & DEBUG_VERBOSE)
    L1
end

% Case II, R-S-L
len = norm(c_le - c_rs);
theta = findHeadingFrom(c_rs,c_le);
theta2 = theta - pi/2 + asin((2*r)/len);
L2 = sqrt(len^2 - 4*r^2)+r*wrapTo2Pi(2*pi + wrapTo2Pi(theta2) - wrapTo2Pi(x_s - pi/2))...
    + r*wrapTo2Pi(2*pi + wrapTo2Pi(theta2 + pi) - wrapTo2Pi(x_e + pi/2));
if (debugMode & DEBUG_VERBOSE)
    L2
end

% Case III, L-S-R
len = norm(c_re - c_ls);
theta = findHeadingFrom(c_ls,c_re);
theta2 = acos((2*r)/len);

if (2*r/len) > 1 || (2*r/len) < -1
    error('Error in case III');
end

L3 = sqrt(len^2 - 4*r^2) + r*wrapTo2Pi(2*pi + wrapTo2Pi(x_s + pi/2) - wrapTo2Pi(theta + theta2))...
    + r*wrapTo2Pi(2*pi + wrapTo2Pi(x_e - pi/2) - wrapTo2Pi(theta + theta2 - pi));
if (debugMode & DEBUG_VERBOSE)
    L3
end

% Case IV, L-S-L
theta = findHeadingFrom(c_ls,c_le);
L4 = norm(c_ls - c_le) + r*wrapTo2Pi(2*pi + wrapTo2Pi(x_s + pi/2) - wrapTo2Pi(theta + pi/2))...
    + r*wrapTo2Pi(2*pi + wrapTo2Pi(theta + pi/2) - wrapTo2Pi(x_e + pi/2));
if (debugMode & DEBUG_VERBOSE)
    L4
end

% Return the length of the minimum length Dubins path
length = min([L1, L2, L3, L4]);

end


%% 
function plotCircle(x,y,r)
%x and y are the coordinates of the center of the circle
%r is the radius of the circle
%0.01 is the angle step, bigger values will draw the circle faster but
%you might notice imperfections (not very smooth)
ang=0:0.01:2*pi; 
xp=r*cos(ang);
yp=r*sin(ang);
plot(x+xp,y+yp);
end

%%

function plotScenario(p_s, x_s, p_e, x_e, c_rs, c_ls, c_re, c_le, r)
hold on;
% Plot center of circles and line between them
%scatter([c_s(1) c_e(1)],[c_s(2) c_e(2)],'r+');
%plot([c_s(1) c_e(1)],[c_s(2) c_e(2)],'k--');
% Plot circles
plotCircle(c_rs(1), c_rs(2), r);
plotCircle(c_re(1), c_re(2), r);
plotCircle(c_ls(1), c_ls(2), r);
plotCircle(c_le(1), c_le(2), r);
text(c_rs(1), c_rs(2), 'c_{rs}', 'FontSize', 12);
text(c_re(1), c_re(2), 'c_{re}', 'FontSize', 12);
text(c_ls(1), c_ls(2), 'c_{ls}', 'FontSize', 12);
text(c_le(1), c_le(2), 'c_{le}', 'FontSize', 12);

% Change graph dimensions
xl = xlim;
yl = ylim;
maxDimLen = max(abs(xl(1) - xl(2)),abs(yl(1) - yl(2)));
xld = abs(xl(1) - xl(2));
yld = abs(yl(1) - yl(2));
xlim([xl(1) - xld*0.1, xl(2) + maxDimLen*0.1]);
ylim([yl(1) - yld*0.1, yl(2) + maxDimLen*0.1]);

% Plot headings
hAx = gca;
scatter([p_s(1) p_e(1)], [p_s(2) p_e(2)], 'r');
drawHeadingArrow(hAx, p_s(1:2), x_s, r/3, 'b');
drawHeadingArrow(hAx, p_e(1:2), x_e, r/3, 'b');

hold off;
end

%% Rotation matrix right-handed about z-axis by theta
function M = rotm(theta)
M = [cos(theta) sin(theta) 0; -sin(theta) cos(theta) 0; 0 0 1]';
end

