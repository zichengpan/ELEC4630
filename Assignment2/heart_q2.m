clear;
close all;

areas = zeros(1, 16);
frame_num = [1:16];

for i=1:16
    % Pre-processing images
    origin=imread(sprintf('MRIheart/MRI1_%.2d.png', i));
    whole = imcrop(origin, [275-85, 357-80, 170, 160]);
    temp = whole;
    X = imadjust(whole);

% Threshold image - manual threshold
BW = X > 68;

% Active contour
iterations = 8;
BW = activecontour(X, BW, iterations, 'Chan-Vese');

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
maskedImage = X;
maskedImage(~BW) = 0;
BW = bwareaopen(BW, 2900);

inner=bwconvhull(BW);
final_inner = zeros(size(origin));
final_inner(357-80:357+80, 275-85:275+85) = inner;
objects = regionprops('table',inner,'FilledArea');
maxArea= max(objects.FilledArea);
areas(i)=maxArea; 

[x, y] = size(whole);
for j=1:x
    for k = 1:y
        if inner(j, k) == 1
            whole(j, k) = uint8(23);
            continue;
        end
    end
end
X = imadjust(whole);

% Create empty mask.
BW = false(size(X,1),size(X,2));

% Flood fill
row = 86;
column = 103;
tolerance = 12;
addedRegion = grayconnected(X, row, column, tolerance);
BW = BW | addedRegion;

% Open mask with disk
radius = 2;
decomposition = 0;
se = strel('disk', radius, decomposition);
BW = imopen(BW, se);

% Fill holes
BW = imfill(BW, 'holes');

% Create masked image.
maskedImage = X;
maskedImage(~BW) = 0;
checkPoint = 0;
for k = y:-1:1
    if BW(int16(x/2) + 9, k) == 1
        checkPoint = k - 5;
%         return;
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

final_outer = zeros(size(origin));
final_outer(357-80:357+80, 275-85:275+85) = outer;

    subplot(2, 8, i), ...
    imshow(origin)
    hold on
    visboundaries(final_outer, 'LineWidth', 1, 'Color', 'blue')
    hold on
    visboundaries(final_inner, 'LineWidth', 1)
    hold off
%     
%     adj_origin = imadjust(origin);
%     edgeImg = adj_origin > 52;
%     radius = 6;
%     decomposition = 0;
%     se = strel('disk', radius, decomposition);
%     
%     % Morphological operations
%     edgeImg = imclose(edgeImg, se);
% 
%     % Clear borders
%     edgeImg = imclearborder(edgeImg);
% 
%     % Create masked image.
%     maskedImage = adj_origin;
%     maskedImage(~edgeImg) = 0;
% 
%     % Find largest object and discard other objects.
%     objects = regionprops('table',edgeImg, ...
%                 'BoundingBox', 'PixelIdxList', 'FilledArea', 'Centroid');
% 
%     [~, idx] = max(objects.FilledArea);
%     for rows = 1:length(objects.FilledArea)
%         if rows ~= idx
%             edgeImg(objects.PixelIdxList{rows}) = 0;
%         end
%     end
%     
%     % Get the centre of the object, which used for cropping later
%     centre = objects.Centroid(idx, :);
% 
%     % Generate convex hull image
%     inner=bwconvhull(edgeImg);
%     objects = regionprops('table',inner,'FilledArea');
%     
%     % Record inner ventricle area
%     maxArea= max(objects.FilledArea);
%     areas(i)=maxArea;  
%     
%     % Crop ventricle part from image
%     whole = imcrop(origin, [int16(centre(1, 1))-83, ...
%         int16(centre(1, 2))-93, 166, 186]);
%     mask = imcrop(inner, [int16(centre(1, 1))-83, ...
%         int16(centre(1, 2))-93, 166, 186]);
%     inverse = uint8(255) - whole;
%     [x, y] = size(whole);
% 
%     % Create a new image with same size as cropped image
%     mod = zeros(size(whole));
%     
%     % Fill the inner wall area with similar colour of the area between
%     % inner wall and outer wall
%     for j=1:x
%         for k = 1:y
%             if mask(j, k) == 1
%                 mod(j, k) = uint8(23);
%                 continue;
%             end
%             mod(j, k) = whole(j, k);
%         end
%     end
%     mod = mat2gray(mod);
%     
%     adj_mod = imadjust(mod);
%     % Create empty mask.
%     BW = false(size(adj_mod,1),size(adj_mod,2));
% 
%     % Flood fill
%     row = 70;
%     column = 89;
%     tolerance = 5.000000e-02;
%     addedRegion = grayconnected(adj_mod, row, column, tolerance);
%     BW = BW | addedRegion;
% 
%     % Open mask with disk
%     radius = 1;
%     decomposition = 0;
%     se = strel('disk', radius, decomposition);
%     BW = imclose(BW, se);
% 
%     % Erode mask with rectangle
%     dimensions = [2 2];
%     se = strel('rectangle', dimensions);
%     BW = imerode(BW, se);
% 
%     % Fill holes
%     BW = imfill(BW, 'holes');
% 
%     % Create masked image.
%     maskedImage = adj_mod;
%     maskedImage(~BW) = 0;
% 
%     BW = bwareaopen(BW, 2900);
%     BW=bwconvhull(BW);
%     final = zeros(size(origin));
%     final(int16(centre(1, 2))-93:int16(centre(1, 2))+93, ...
%         int16(centre(1, 1))-83:int16(centre(1, 1))+83) = BW;
%     BW=bwconvhull(final);
%     
%     subplot(2, 8, i), ...
%     imshow(origin)
%     hold on
%     visboundaries(final, 'LineWidth', 1, 'Color', 'blue')
%     hold on
%     visboundaries(inner, 'LineWidth', 1)
%     hold off
%     return
end

truesize
% return
figure(2), plot(frame_num, areas)
title('Area vs frame')
xlabel('Frames')
ylabel('Area of the inner ventricle (pixels)')
