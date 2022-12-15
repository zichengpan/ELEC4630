clear;
close all;

imageNum = 6;
Imgs = zeros(128*128, imageNum);

% Turn the training images to vectors 
for i = 1:imageNum
    [im, map] = imread(sprintf('Faces/eig/%da.bmp', i));
    origin = rgb2gray(ind2rgb(im, map));
    Imgs(:, i) = reshape(origin, [128*128, 1]);
end

% Mean face calculation
meanFace = mean(Imgs, 2);

sub = Imgs - meanFace;
covariance = zeros(imageNum, imageNum);
for i = 1:imageNum
    covariance = covariance + sub(:, i)' * sub(:, i);
end

% Get eigenvectors for all the training images
[vector, values] = eig(covariance);
values = diag(values);
[values, idx] = sort(values, 'descend');

u = sub * vector / norm(sub * vector, 2);

% Number of eigen face used
faceNum = 6;

% Project the training images onto the eigenvectors
train_weight = zeros(imageNum, faceNum);
for i = 1:imageNum
    train_weight(i, :) = sum(u(:, idx(1:faceNum)) .* sub(:, i));
end


Alphabet = 'abcdefghijkl';
correct = 0;
incorrect = 0;
% Test image
for i = 1:imageNum
    imgList = dir(sprintf('Faces/%d/*.bmp', i));
    for j = 1:size(imgList, 1)
        [im, map] = imread(sprintf('Faces/%d/%d%c.bmp', ...
            i, i, Alphabet(j)));
        
        test = rgb2gray(ind2rgb(im, map));
        test = reshape(test, [128*128, 1]);
        test = test - meanFace;

        project = sum(test .* u(:, idx(1:faceNum)));

        distances = zeros(1, imageNum);
        for k = 1:imageNum
            distances(1, k) = norm(project - train_weight(k, :));
        end
%       Check if the recognition is correct
        [~, id] = min(distances);
        if id == i
            correct = correct + 1;
        else
            incorrect = incorrect + 1;
            fprintf('incorrect: %d%c, recongize as: %da\r\n', ...
                i, Alphabet(j), id);
        end
    end
end

% Show the correct reconition rate
rate = correct / (correct + incorrect)


