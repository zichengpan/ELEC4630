origin = imread('SyntheticFaces/20200513_053018_Mouth_Slightly_Open_pos.png');
grayscale = rgb2gray(origin);
grayscale = imresize(grayscale, [128 128]);
imwrite(grayscale,'test_img.bmp');

