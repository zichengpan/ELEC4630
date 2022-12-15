close all;
clear;

v = VideoReader('Eric2020.mp4');

frame1 = read(v, 1);
temp1=cropPowerLine(frame1);

frame_num =2;
% imshow(read(v, 1))
while hasFrame(v)
%     break
    frame2 = read(v, frame_num);
%     imshow(frame2)
    [temp2, BW, y]=cropPowerLine(frame2);
%     imshow(temp2)

    [H, T, R] = hough(temp2);
    
%     temp2=rgb2gray(frame2);
%     threshod_2=temp2 > 90;
    

    % 2D cross corrlation
%     correlations=xcorr2(double(threshod_2), double(temp1));
%     [n, index] = max(correlations(:));
%     [y, x] = ind2sub(size(correlations), index);
% 
%     length=size(temp1, 1);
%     width=size(temp1, 2);
% 
%     BW =temp2(1:y, (x-width):x);
%     power_line = verticalDots(BW);
%     y1=1;
%     y2=power_line(1,3);
%     x1=power_line(1,1);
%     x2=power_line(1,2);

%     figure(frame_num), imshow(frame2)
%     imshow(frame2)
% 
%     hold on
% 
%     line([x1+(x-width) x2+(x-width)], [y1+(y-length) y2+(y-length)],'Color','red','LineWidth',1)

%     line([x1+y+170 x2+y+170], [y1 y2],'Color','red','LineWidth',3)

%     hold off
%     
%     temp1 = BW;
%     frame_num = frame_num + 1;
    break
end



% temp2=cropPowerLine(frame2);


% img = insertShape(BW,'Line',[1 power_line(1,3) power_line(1,1) power_line(1,2)],'LineWidth',2,'Color','red');
% imshow(img)


% imshow(threshod_2((y1-length):y1, (x1-width):x1));
% hold on
% rectangle('Position',[(x1-width) (y1-length) width length], 'LineWidth', 4, 'EdgeColor', 'r');


% BW =unit8(255)-temp2((y1-length):y1, (x1-width):x1);
% BW =temp2((y1-length):y1, (x1-width):x1);
% 
% [H,T,R] = hough(BW, 'Theta',-90:0.5:-60);
% ceil(0.3*max(H(:)))
% P  = houghpeaks(H,1,'threshold',ceil(0.3*max(H(:))));
% x = T(P(:,2)); y = R(P(:,1));
% lines = houghlines(BW,T,R,P,'FillGap',5,'MinLength',7);
% figure, imshow(BW), hold on
% max_len = 0;
% % size(lines)
% for k = 1:1
%    xy = [lines(k).point1; lines(k).point2];
%    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
% 
%    % Plot beginnings and ends of lines
%    plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
%    plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
% 
%    % Determine the endpoints of the longest line segment
%    len = norm(lines(k).point1 - lines(k).point2);
%    if ( len > max_len)
%       max_len = len;
%       xy_long = xy;
%    end
% end

% hough

