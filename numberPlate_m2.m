clear;
close all;
for i=1:8
%   Pre-processing image
    origin = imread(sprintf('numberplates2020/car%d.jpg', i));
    greyScale = rgb2gray(origin);
    greyScale = imgaussfilt(greyScale, 0.8);
    binaryImg = greyScale > 139;    % Thresholding
    binaryImg = imclearborder(binaryImg);    
    
    
%   Find object with correct radio
    objects = regionprops('table',binaryImg, ...
            'BoundingBox', 'PixelIdxList');
    objects.LenWdRatio = objects.BoundingBox(:,3) ...
            ./ objects.BoundingBox(:,4); 
        
    for rows = 1:length(objects.LenWdRatio)
        if objects.LenWdRatio(rows, 1) < 2.7 ...
            || objects.LenWdRatio(rows, 1) > 6
            binaryImg(objects.PixelIdxList{rows}) = 0;
        end
    end
    
%%   Remove small objects
    binaryImg = bwareaopen(binaryImg, 1070);
    
%   Search for number plate and apply bounding box
    [x, y] = size(binaryImg);
    bottom_row = x;
    start_col = y;
    end_col = 0;
    counts=sum(binaryImg, 2);
    for row=x:-1:1
        if counts(row, 1) > 30
            bottom_row = row;
            for potential=(row-7):row
                temp1 = find(binaryImg(potential, :), 1, 'first');
                if temp1 < start_col
                    start_col=temp1;
                end
                temp2 = find(binaryImg(potential, :), 1, 'last');
                if temp2 > end_col
                    end_col=temp2;
                end
            end
            break;
        end
    end
    width=end_col-start_col;
    height = width ./ 3;
    
%   Show results and plot bounding boxes
    subplot(2,4,i),imshow(origin);
    hold on;
    rectangle('Position',[start_col bottom_row-height width height],...
         'LineWidth',2,'LineStyle','-', 'EdgeColor', 'y')
    hold off
    
end
truesize




