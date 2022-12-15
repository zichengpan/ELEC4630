% Get start and end point of the power cable, also return the end point
% row on image
function output = verticalDots(input_image)
    [x, y] = size(input_image);
    first_row = input_image(1, :);
    [start_loc, posible] = find_line(first_row, y);
    temp=size(posible);
    separate = temp(1, 2);
%   Get the posible start point
    if separate < 2
        start_loc = max(start_loc);
    else
        start_loc = max(posible(1:2));
    end
%   Find pantograph
    for temp = 2:x
        end_loc = find_line(input_image(temp, :), y);
        if ismember(-1, end_loc)
            end_row = temp-5;
            break;
        end
    end
    
    end_loc = find_line(input_image(end_row, :), y);
%   Find end point
    min_distance = 100;
    final_end = 0;
    for check=1:length(end_loc)
        if abs(start_loc - end_loc(1, check)) < min_distance
            final_end = end_loc(1, check);
            min_distance = abs(start_loc - end_loc(1, check));
        end
    end
    
    output = [start_loc, final_end, end_row];
end

% Find the line on a row of pixels
function [target, posible] = find_line(row_pixels, y)
    connected = 0;
    target = [];
    posible = [];
    max = 0;
    for len=1:y
        if row_pixels(1, len) < 70
            connected = connected + 1;
        else if connected > 0
            if connected > 15
%               Find the pantograph instead of a point
                target = -1;
                break

            else if connected > max
                max = connected;
                target = [target, len-3];
                end
            end
            posible = [posible, len-3];
            connected = 0;
        end
        end
    end
end
