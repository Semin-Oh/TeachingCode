function phase = RandPhasePD(n)
% phase = RandPhasePD(n)
%
% Create a random phase field that is consistent with
% a real image.  This is a little buggy.  It works for
% n = 128 but may not for other n, even other powers of 2.
%
% 6/29/96  dhb  Wrote it.
% 3/5/97   dhb  Append PD to name.

% Create space
rawPhase = zeros(n,n);

% Set unconstrained entries
center = n/2+1;
n2 = n/2-1;
rawPhase(center,center) = 0;
rawPhase(1,1) = pi;
rawPhase(1,center) = pi;
rawPhase(center,1) = pi;

% Choose first col
firstCol = 2*pi*rand(n2,1)-pi;
rawPhase(n/2+2:n,1) = firstCol;
rawPhase(2:n/2,1) = -flipud(firstCol);

% Chose center column
cenCol = 2*pi*rand(n2,1)-pi;
rawPhase(n/2+2:n,center) = cenCol;
rawPhase(2:n/2,center) = -flipud(cenCol);

% Chose first row
firstRow = 2*pi*rand(1,n2)-pi;
rawPhase(1,n/2+2:n) = firstRow;
rawPhase(1,2:n/2) = -fliplr(firstRow);

% Chose center row
cenRow = 2*pi*rand(1,n2)-pi;
rawPhase(center,n/2+2:n) = cenRow;
rawPhase(center,2:n/2) = -fliplr(cenRow);

% Chose lower right quadrant
quadLR = 2*pi*rand(n2,n2)-pi;
rawPhase(n/2+2:n,n/2+2:n) = quadLR;
rawPhase(2:n/2,2:n/2) = -fliplr(flipud(quadLR));

% Choose upper right quadrant
quadUR = 2*pi*rand(n2,n2)-pi;
rawPhase(2:n/2,n/2+2:n) = quadUR;
rawPhase(n/2+2:n,2:n/2) = -fliplr(flipud(quadUR));
rawPhase(n/2+2:n,2:n/2) = fliplr(quadLR);
rawPhase(2:n/2,n/2+2:n) = -flipud(quadLR);

phase = fftshift(rawPhase);
