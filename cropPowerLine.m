function [grayImage, start_col]=cropPowerLine(frame)
%   Pre-processing
    gray = rgb2gray(frame);
    threashhold = gray > 90;
    
%   Get rid of subtitle
    F=bwlabel(threashhold(2:400, :));
    F_row=sum(F, 2);
    max_row = min(F_row);
    rows = find(F_row==max_row);
    end_row = rows(1:1)+20;
    cropped_image = threashhold(1:end_row, 170:734);
    grayImage = gray(1:end_row, 170:734);
    
%   Get rid of black space on both sides
    F=bwlabel(cropped_image);
    F_col=sum(F);
    max_col=min(F_col);
    cols=find(F_col==max_col);
    start_col=cols(1:1) - 180;
    end_col = cols(1:1) + 200;
    
%   Check if the pixel is out of range
    if end_col > 564
        end_col = 564;
    end
    if start_col < 1
        start_col = 1;
    end
    grayImage = grayImage(:, start_col:end_col);
end
    