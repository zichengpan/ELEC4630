function output = eigenface(testImg)
    imageNum = 6;
    Imgs = zeros(128*128, imageNum);
    for i = 1:imageNum
        [im, map] = imread(sprintf('Faces/eig/%da.bmp', i));
        origin = rgb2gray(ind2rgb(im, map));
        Imgs(:, i) = reshape(origin, [128*128, 1]);
    end

    meanFace = mean(Imgs, 2);

    sub = Imgs - meanFace;

    covariance = zeros(imageNum, imageNum);
    for i = 1:imageNum
        covariance = covariance + sub(:, i)' * sub(:, i);
    end

    [vector, values] = eig(covariance);

    values = diag(values);
    [~, idx] = sort(values, 'descend');

    u = sub * vector / norm(sub * vector, 2);

    % Number of eigen face used
    faceNum = 6;

    train_weight = zeros(imageNum, faceNum);
    for i = 1:imageNum
        train_weight(i, :) = sum(u(:, idx(1:faceNum)) .* sub(:, i));
    end

    % Test image

    test = double(reshape(testImg, [128*128, 1]));
    test = test - meanFace;

    project = sum(test .* u(:, idx(1:faceNum)));

    distances = zeros(1, imageNum);
    match_thresh = 5;
    match = 0;
    for k = 1:imageNum
        distances(1, k) = norm(project - train_weight(k, :));
        if distances(1, k) < match_thresh
            match = 1;
        end
    end
    if match == 1
        [~, output] = sort(distances, 'ascend');
    else
        output = 0;
    end
    
end

