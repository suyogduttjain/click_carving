%% Demo to show the results of MCG
clear all;close all;home;

% Read an input image
%I = imread(fullfile(root_dir, 'demos','101087.jpg'));
I = imread(fullfile(root_dir, 'demos','0009.jpg'));
I = imread(fullfile(root_dir, 'demos','im3.JPEG'));

tic;
% Test the 'fast' version, which takes around 5 seconds in mean
[candidates_scg, ucm2_scg] = im2mcg(I,'fast');
toc;

candidates_scg
[scores, ids] = sort(candidates_scg.scores,'descend');

figure;
%% Show Object Candidates results and bounding boxes
% Candidates in rank position 11 and 12
for iter_ind = 1:200
	idx = ids(iter_ind);
	% Get the masks from superpixels and labels
	mask = ismember(candidates_scg.superpixels, candidates_scg.labels{idx});
	disp(candidates_scg.scores(idx));

	% Bboxes is a matrix that contains the four coordinates of the bounding box
	% of each candidate in the form [up,left,down,right]. See folder bboxes for
	% more function to work with them

	% Show results
	subplot(1,2,1)
	imshow(I), title('Image')
	subplot(1,2,2)
	imshow(mask), title('Candidate + Box')
	hold on
	plot([candidates_scg.bboxes(idx,4) candidates_scg.bboxes(idx,4) candidates_scg.bboxes(idx,2) candidates_scg.bboxes(idx,2) candidates_scg.bboxes(idx,4)],...
	     [candidates_scg.bboxes(idx,3) candidates_scg.bboxes(idx,1) candidates_scg.bboxes(idx,1) candidates_scg.bboxes(idx,3) candidates_scg.bboxes(idx,3)],'r-')
	pause;
end
