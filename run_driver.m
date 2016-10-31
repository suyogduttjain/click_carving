clear all;
warning off;
addpath(genpath('./interface/'));
addpath(genpath('./preprocessing/'));
addpath(genpath('./external_libs/'));

image_dir = './data/';
%image_name = 'puppy.jpg';
image_name = 'cat.jpg';
disp(image_name);

num_proposals = 500;
compute_mcg_static(image_dir,image_name);
process_proposals(image_dir,image_name,num_proposals);
proposal_boundaries(image_dir,image_name);
click_carving(image_dir,image_name);
