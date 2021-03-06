% ArduinoRayleighMatch
%
% Little program to do Rayleigh matches with our arduino device.
%
% The initial parameters here are close to a match with my device,
% Scotch tape as diffuser, and a Roscolux #23 orange filter
% to cut out short wavelengths.
%
% This version lets you adjust r/g mixture and yellow intensity, as in
% classic anomaloscope.  See ArduinoRayleighMatchRGY for a different set of
% controls.

% History
%   Written 2020 by David Brainard based on demo code provided by Liana Keesing.

% Put the arduino toolbox some place on you system. This
% the adds it dynamically. The Matlab add on manager doesn't
% play well with ToolboxToolbox, which is why it's done this
% way here.  Also OK to get the arduino toolbox on your path
% in some other manner.
%
% This adds the Arduino toolbox to the path if it isn't there.
if (~exist('arduinosetup.m','file'))
    addpath(genpath('/Users/dhb/Documents/MATLAB/SupportPackages/R2020a'))
end

% Initialize arduino
clear;
clear a;
a = arduino;

% Yellow LED parameters
yellow = 66;                                    % Initial yellow value
yellowDeltas = [10 5 1];                        % Set of yellow deltas
yellowDeltaIndex = 1;                           % Delta index    
yellowDelta = yellowDeltas(yellowDeltaIndex);   % Current yellow delta

% Red/green mixture parameters.  These get traded off in the
% mixture by a parameter lambda.
redAnchor = 58;                                 % Red value for lambda = 1
greenAnchor = 440;                              % Green value for lambda = 0
lambda = 0.5;                                   % Initial lambda value
lambdaDeltas = [0.02 0.005 0.001];              % Set of lambda deltas
lambdaDeltaIndex = 1;                           % Delta index
lambdaDelta = lambdaDeltas(lambdaDeltaIndex);   % Current delta

% Booleans that control whether we just show red or just green
% LED in mixture.  This is mostly useful for debugging
redOnly = false;
greenOnly = false;

% Setup character capture.  Note that if you crash out of the program
% you need to execute ListenChar(0) before you can enter keys at keyboard 
% again.
ListenChar(2);
FlushEvents;

% Loop and process characters to control yellow intensity and 
% red/green mixture
%
% 'q' - Exit program
%
% 'r' - Increase red in r/g mixture
% 'g' - Increase green in r/g mixture
% 'i' - Increase yellow intensity
% 'd' - Decrease yellow intensity
%
% '1' - Turn off green, only red in r/g mixture
% '2' - Turn off red, only green in r/g mixture
% '3' - Both red and green in r/g mixture
% 
% 'a' - Advance to next r/g delta (cyclic)
% ';' - Advance to next yellow delta (cyclic)
while true
    % Set red and green values based on current lambda
    red = round(lambda*redAnchor);
    green = round((1-lambda)*greenAnchor);
    
    % Handle special modes for red and green
    if (redOnly)
        green = 0;
    end
    if (greenOnly)
        red = 0;
    end
    
    % Tell user where we are
    fprintf('Lambda = %0.3f, Red = %d, Green = %d, Yellow = %d\n',lambda,red, green, yellow); 
    fprintf('\tLambda delta %0.3f; yellow delta %d\n',lambdaDelta,yellowDelta);
    
    % Write the current LED settings
    writeRGB(a,red,green,0);
    writeYellow(a,yellow);
    
    % Check for chars and process if one is pressed.  See comment above for
    % what each character does.
    switch GetChar
        case 'q'
            break;
            
        case 'r'
            lambda = lambda+lambdaDelta;
            if (lambda > 1)
                lambda = 1;
            end
            
        case 'g'
            lambda = lambda-lambdaDelta;
            if (lambda < 0)
                lambda = 0;
            end
            
        case 'i'
            yellow = round(yellow+yellowDelta);
            if (yellow > 255)
                yellow = 255;
            end
            
        case 'd'
            yellow = round(yellow-yellowDelta);
            if (yellow < 0)
                yellow = 0;
            end
            
        case '1'
            redOnly = true;
            greenOnly = false;
            
        case '2'
            redOnly = false;
            greenOnly = true;
            
        case '3'
            redOnly = false;
            greenOnly = false;
            
        case 'a'
            lambdaDeltaIndex = lambdaDeltaIndex+1;
            if (lambdaDeltaIndex > length(lambdaDeltas))
                lambdaDeltaIndex = 1;
            end
            lambdaDelta = lambdaDeltas(lambdaDeltaIndex);
            
        case ';'
            yellowDeltaIndex = yellowDeltaIndex+1;
            if (yellowDeltaIndex > length(yellowDeltas))
                yellowDeltaIndex = 1;
            end
            yellowDelta = yellowDeltas(yellowDeltaIndex);
            
        otherwise
            
    end
    
end

% Turn off character capture.
ListenChar(0);

% Close arduino
clear a;
