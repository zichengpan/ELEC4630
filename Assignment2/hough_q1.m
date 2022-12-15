close all;
clear;

% Pre-processing
origin=imread('morgan.jpg');
greyScale = rgb2gray(origin);
greyScale = imgaussfilt(greyScale, 0.8);
edgeImg = edge(greyScale, 'canny', 0.5);
% Remove small objects
edgeImg=bwareaopen(edgeImg, 100);

% Hough transform
[H,theta,rho] = hough(edgeImg, 'Theta', -90:-87);
P = houghpeaks(H,1,'threshold',ceil(0.3*max(H(:))));
x = theta(P(:,2));
y = rho(P(:,1));
lines = houghlines(edgeImg,theta,rho,P,'FillGap', 20, 'MinLength',100);
imshow(origin), hold on
max_len = 0;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',3,'Color','red');
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end

% Circular Hough transform
fillImg = imfill(edgeImg, 'holes');
[centers, radii, metric] = imfindcircles(fillImg,[55 100]);
centersStrong5 = centers(1:2,:); 
radiiStrong5 = radii(1:2);
metricStrong5 = metric(1:2);
viscircles(centersStrong5, radiiStrong5,'EdgeColor','b', 'LineWidth', 3);

