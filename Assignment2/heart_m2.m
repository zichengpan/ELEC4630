clear;
close all;

areas = zeros(1, 16);
frame_num = [1:16];

for i=1:16
    % Pre-processing images
    origin=imread(sprintf('MRIheart/MRI1_%.2d.png', i));
    whole = imcrop(origin, [190, 287, 170, 160]);
    adj_heart = imadjust(whole);

    % Threshold image - manual threshold
    BW = adj_heart > 68;

    % Active contour
    iterations = 8;
    BW = activecontour(adj_heart, BW, iterations, 'Chan-Vese');

    % Fill holes
    BW = imfill(BW, 'holes');

    % Clear borders
    BW = imclearborder(BW);

    % Close mask with disk
    radius = 7;
    decomposition = 0;
    se = strel('disk', radius, decomposition);
    BW = imclose(BW, se);

    % Create masked image.
    maskedImage = adj_heart;
    maskedImage(~BW) = 0;
    BW = bwareaopen(BW, 2900);
    inner=bwconvhull(BW);
    
%   Put the inner wall convex hull back to the original image
%   Find the area
    final_inner = zeros(size(origin));
    final_inner(357-80:357+80, 275-85:275+85) = inner;
    objects = regionprops('table',inner,'FilledArea');
    maxArea= max(objects.FilledArea);
    areas(i)=maxArea; 

%   Fill in the inner ventricle with similar color with surounding
    [x, y] = size(whole);
    for j=1:x
        for k = 1:y
            if inner(j, k) == 1
                whole(j, k) = uint8(23);
            end
        end
    end
    adj_out = imadjust(whole);

    % Create empty mask.
    BW = false(size(adj_out,1),size(adj_out,2));

    % Flood fill
    row = 86;
    column = 103;
    tolerance = 12;
    addedRegion = grayconnected(adj_out, row, column, tolerance);
    BW = BW | addedRegion;

    % Open mask with disk
    radius = 2;
    decomposition = 0;
    se = strel('disk', radius, decomposition);
    BW = imopen(BW, se);

    % Fill holes
    BW = imfill(BW, 'holes');

    % Create masked image.
    maskedImage = adj_out;
    maskedImage(~BW) = 0;
    checkPoint = 0;
    
%   Get rid of some common objects in the image
    for k = y:-1:1
        if BW(int16(x/2) + 9, k) == 1
            checkPoint = k - 5;
            break;
        end
    end
    for k = checkPoint:y
        for j = 1:(int16(x/2) - 40)
            if BW(j, k) == 1
                BW(j, k) = 0;
            end
        end
        for j = (int16(x/2) + 35):x
            if BW(j, k) == 1
                BW(j, k) = 0;
            end
        end
    end
    
    imfill(BW, 'holes');
    imclose(BW, strel('disk', 10));
    BW=bwareaopen(BW, 2);
    outer=bwconvhull(BW);

%   Get the outer wall on the original image
    final_outer = zeros(size(origin));
    final_outer(357-80:357+80, 275-85:275+85) = outer;

    subplot(2, 8, i), ...
    imshow(origin)
    hold on
    visboundaries(final_outer, 'LineWidth', 1, 'Color', 'blue')
    hold on
    visboundaries(final_inner, 'LineWidth', 1)
    hold off
end

% Plot the area vs frames
truesize
figure(2), plot(frame_num, areas)
title('Area vs frame')
xlabel('Frames')
ylabel('Area of the inner ventricle (pixels)')
