function hexGrid = drawHexGrid(radius, numRings, iflabelhex)
    % This function draws a hexagonal grid and returns the coordinates of
    % the top-left vertices of each hexagon in a matrix.
    gray = ones(1,3)*230/255;
    % Parameters
    if nargin < 1
        radius = 1; % default radius if not provided
    end
    if nargin < 2
        numRings = 2; % default number of rings if not provided
    end

    % Hexagon vertex coordinates
    theta = (0:5) * pi / 3+pi/6;
    x_hex = radius * cos(theta);
    y_hex = radius * sin(theta);
    
    figure;
    hold on;
    axis equal;
    grid on;
    
    % Initialize the array to store top-left vertices of hexagons
    hexGrid = [];
    
    % Function to plot a single hexagon
    function plotHexagon(x_center, y_center)
        x = x_center + x_hex;
        y = y_center + y_hex;
        %fill(x, y, 'w');
        plot(x, y, 'Color',gray,'LineWidth',1.5);
    end
    
    % Plot the hexagonal grid
    hexIndex = 1;
    for q = -numRings:numRings
        for r = max(-numRings, -q-numRings):min(numRings, -q+numRings)
            x_center = radius * sqrt(3) * (q + r/2)+radius*sqrt(3)/2;
            y_center = radius * 1.5 * r-0.5*radius;
            plotHexagon(x_center, y_center);
            % Calculate the bot vertex of the hexagon
            bot_vertex = [x_center, y_center - radius];
            hexGrid(hexIndex, :) = bot_vertex;
            % Label the hexagon
            if iflabelhex
                text(x_center, y_center, num2str(hexIndex), 'HorizontalAlignment', 'center');
            end
            hexIndex = hexIndex + 1;
        end
    end
    
    hold off;
end
