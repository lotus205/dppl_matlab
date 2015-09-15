function drawHeadingArrow(hAx, origin, psi, arrowSize, color)
% DRAWHEADINGARROW draws an annotation arrow at the heading psi

% =================== Check Arguments ========================
if nargin < 1
    error('No input arguments given!');
elseif nargin > 5
    error('Too many arguments given!');
end

if isempty(hAx)
    error('hAx not given!');
end
if isempty(origin)
    error('origin is empty!');
end
if isempty(psi)
    error ('psi not given!');
end
if isempty(arrowSize)
    error('arrowSize not given!');
end
if (isempty(color))
    error('color not given!');
end

headLength = 10; %arrowSize *2;
headWidth = 10; %arrowSize *2;

% ================== Draw Arrow =======================
ox = origin(1);
oy = origin(2);

if (psi < 0 || psi >= 2*pi)
    error('Unexpected psi value: %f', psi);
elseif (psi < pi/2)
    px = ox + arrowSize*sin(psi);
    py = oy + arrowSize*sin(pi/2 - psi);
elseif (psi < pi)
    psi = psi - pi/2;
    px = ox + arrowSize*sin(pi/2 - psi);
    py = oy - arrowSize*sin(psi);
elseif (psi < 3*pi/2)
    psi = psi - pi;
    px = ox - arrowSize*sin(psi);
    py = oy - arrowSize*sin(pi/2 - psi);
else
    psi = psi - 3*pi/2;
    px = ox - arrowSize*sin(pi/2 - psi);
    py = oy + arrowSize*sin(psi);
end

[oxf, oyf] = ds2nfu(hAx, ox, oy);
[pxf, pyf] = ds2nfu(hAx, px, py);
annotation('arrow', [oxf pxf], [oyf pyf], 'Color', color,...
    'HeadLength', headLength, 'HeadWidth', headWidth);

end % function drawHeadingArrow()