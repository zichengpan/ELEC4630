clear;
close all;

% Set up 3D space for the dinosaur
resolution = 1;
x = -180:resolution:90;
y = -80:resolution:70;
z = 20:resolution:460;
[L, W, H] = meshgrid(x, y, z);

weights = ones(numel(L), 1);
voxel = [L(:)'; W(:)'; H(:)'; weights'];

for i = 0:35
    
%   Find silhouette of dinosaur
    origin = imread(sprintf('dino/dino%.2d.jpg', i));
    
%   Compare between red and blue colour in the image
    grayscale = origin(:, :, 1) > origin(:, :, 3);
    [ymax, xmax] = size(grayscale);

    grayscale(1:10, :) = 0;
    grayscale(:, xmax:-1:xmax-50) = 0;

%   Get 2D coodinate
    projections = projectMatrix();
    v = projections(:, :, i + 1);
    p = v * voxel; 
    x = round(p(1, :) ./ p(3, :));
    y = round(p(2, :) ./ p(3, :));
    
%   Find the coodinate inside the image
    vaild_idx = find((x >= 1) & (x <= xmax) & ...
            (y >= 1) & (y <= ymax));
    x = x(vaild_idx);
    y = y(vaild_idx);
    
%   Find the coodinate inside the dinosaur silhouette 
    img_idx = sub2ind([ymax, xmax], y, x);
    dino_idx = vaild_idx(grayscale(img_idx) == 1);
    discard = find(grayscale(img_idx) == 0);
    x(discard) = [];
    y(discard) = [];
    
%   Update valid 2D coodinate to 3D space
    L = L(dino_idx);
    W = W(dino_idx);
    H = H(dino_idx);
    weights = weights(dino_idx);
    voxel = [L(:)'; W(:)'; H(:)'; weights'];
    
end
% Generate color space
R = double(zeros(1, size(x, 2)));
G = double(zeros(1, size(x, 2)));
B = double(zeros(1, size(x, 2)));

% Counter
count = zeros(1, size(x, 2));

% Extract color from the original image
for i = 0:35
    origin = imread(sprintf('dino/dino%.2d.jpg', i));
    grayscale = origin(:, :, 1) > origin(:, :, 3);
    [ymax, xmax] = size(grayscale);

    grayscale(1:10, :) = 0;
    grayscale(:, xmax:-1:xmax-50) = 0;
    
%   Getting color space value
    for j = 1:size(x, 2)
        if (grayscale(y(1, j), x(1, j)) == 0)
            continue
        end
        R(1, j) = R(1, j) + double(origin(y(1, j), x(1, j), 1));
        G(1, j) = G(1, j) + double(origin(y(1, j), x(1, j), 2));
        B(1, j) = B(1, j) + double(origin(y(1, j), x(1, j), 3));
        count(1, j) = count(1, j) + 1;
    end
end

count = count * 255;

% Scale the color value
R = R ./ count;
G = G ./ count;
B = B ./ count;

% Construct model space
validL = unique(L);
validW = unique(W);
validH = unique(H);
V = zeros(size(validW, 2), size(validL, 2), size(validH, 2));
r = zeros(size(validW, 2), size(validL, 2), size(validH, 2));
g = zeros(size(validW, 2), size(validL, 2), size(validH, 2));
b = zeros(size(validW, 2), size(validL, 2), size(validH, 2));

[X, Y, Z] = meshgrid(validL, validW, validH);

% Insert color and valid point into 3D space
num = length(L);
for i=1:num
    idL = (validL == L(1, i));
    idW = (validW == W(1, i));
    idH = (validH == H(1, i));
    V(idW,idL,idH) = V(idW,idL,idH) + weights(i, 1);
    r(idW,idL,idH) = r(idW,idL,idH) + R(1, i);
    g(idW,idL,idH) = g(idW,idL,idH) + G(1, i);
    b(idW,idL,idH) = b(idW,idL,idH) + B(1, i);
end

% Flip the model and scale the colour
final = zeros(size(V));
final_r = zeros(size(r));
final_g = zeros(size(g));
final_b = zeros(size(b));
for i=1:size(V, 3)
    final(:, :, i) = V(:, :, size(V, 3)+1-i);
    final_r(:, :, i) = r(:, :, size(r, 3)+1-i) * 2.6;
    final_g(:, :, i) = g(:, :, size(g, 3)+1-i) * 2.6;
    final_b(:, :, i) = b(:, :, size(b, 3)+1-i) * 2.6;
end

% Draw the 3D dinosaur
seg = patch(isosurface(X, Y, Z, final));
isonormals(X, Y, Z, final, seg)
isocolors(X, Y, Z, final_r, final_g, final_b, seg)
seg.FaceColor = 'interp';
seg.EdgeColor = 'none';

% Set the relative scale of the data units along the 
% x, y, and z-axis
daspect([1 1 1]);
xlabel('x axis');
ylabel('y axis');
zlabel('z axis');
camlight('right');
lighting gouraud;

% Control the viewing angle
% view(-115, 0);
% view(75, 0);
% view(135, 0);
view(175, 0);

