img = imread('input.png');
gt = logical(rgb2gray(imread('mask.png')));

blend_img = blend_mask(img,gt,[0 1 0],0.5,0);
imshow(blend_img);
pause;
blend_img = blend_mask(img,gt,[0 1 0],0,1);
imshow(blend_img);
