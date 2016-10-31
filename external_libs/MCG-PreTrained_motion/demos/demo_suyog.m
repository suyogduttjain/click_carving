
%% Demo to show the results of MCG
clear all;close all;home;

% Read an input image
%I = imread(fullfile(root_dir, 'demos','101087.jpg'));
I = imread(fullfile(root_dir, 'demos','0009.jpg'));

tic;
% Test the 'fast' version, which takes around 5 seconds in mean
[candidates_scg, ucm2_scg] = im2mcg(I,'fast');
toc;

tic;
% Test the 'accurate' version, which tackes around 30 seconds in mean
[candidates_mcg, ucm2_mcg] = im2mcg(I,'accurate');
toc;

%% Show UCM results (dilated for visualization)
figure;
subplot(1,3,1)
imshow(I), title('Image')

subplot(1,3,2)
imshow(imdilate(ucm2_scg,strel(ones(3))),[]), title('Fast UCM (SCG)')

subplot(1,3,3)
imshow(imdilate(ucm2_mcg,strel(ones(3))),[]), title('Accurate UCM (MCG)')


figure;
%% Show Object Candidates results and bounding boxes
% Candidates in rank position 11 and 12
for id1 = 1:200
	% Get the masks from superpixels and labels
	mask1 = ismember(candidates_mcg.superpixels, candidates_mcg.labels{id1});

	% Bboxes is a matrix that contains the four coordinates of the bounding box
	% of each candidate in the form [up,left,down,right]. See folder bboxes for
	% more function to work with them

	% Show results
	subplot(1,2,1)
	imshow(I), title('Image')
	subplot(1,2,2)
	imshow(mask1), title('Candidate + Box')
	hold on
	plot([candidates_mcg.bboxes(id1,4) candidates_mcg.bboxes(id1,4) candidates_mcg.bboxes(id1,2) candidates_mcg.bboxes(id1,2) candidates_mcg.bboxes(id1,4)],...
	     [candidates_mcg.bboxes(id1,3) candidates_mcg.bboxes(id1,1) candidates_mcg.bboxes(id1,1) candidates_mcg.bboxes(id1,3) candidates_mcg.bboxes(id1,3)],'r-')
	pause;
end
