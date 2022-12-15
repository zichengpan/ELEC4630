clear;
close all;
for i=1:8
%%   Edge detection by Sobel edge detector
    origin=imread(sprintf('numberplates2020/car%d.jpg', i));
    greyScale = rgb2gray(origin);
    greyScale = imgaussfilt(greyScale, 0.8);
    edgeImg = edge(greyScale, 'sobel');

%%   Morphological operation
    image = imdilate(edgeImg, strel('diamond',2));
    image = imfill(image, 'holes');
    image = imclearborder(image);
    image=imerode(image, strel('diamond',10));
    final=bwareaopen(image, 1000);
    
%   Locating number plate
    info = regionprops(final,'Boundingbox');
    if isempty(info)
        subplot(2,4,i), imshow(a);
        continue;
    end
%   Change data format
    info=struct2cell(info);
    info=info(end);
    info=cell2mat(info);
    info=int64(info);

    subplot(2,4,i), imshow(origin);
    hold on;
    rectangle('Position',info,...
          'Curvature',1,...
         'LineWidth',2,...
         'EdgeColor','r');
    hold off;
end
truesize


