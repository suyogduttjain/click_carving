clear all;
warning off;
%addpath(genpath('/vision/vision_users/suyog/active_video_annotation/external_libs/toolbox/'));
addpath(genpath('/vision/vision_users/suyog/active_video_annotation/external_libs/utils/'));
addpath(genpath('/vision/vision_users/suyog/active_video_annotation/external_libs/object_line_int/'));
addpath(genpath('/vision/vision_users/suyog/active_video_annotation/external_libs/edges/'));
addpath(genpath('/vision/vision_users/suyog/active_video_annotation/external_libs/SLIC/'));
addpath(genpath('/vision/vision_users/suyog/active_video_annotation/external_libs/BSR/'));
addpath(genpath('/vision/vision_users/suyog/active_video_annotation/external_libs/MCG-PreTrained_motion/'));
addpath(genpath('./ui/'));

db_type = 5;

if db_type == 1
	base_dir = '/vision/vision_users/suyog/active_video_annotation/data/segtrack_v2/';

	vid_names = {
	'birdfall2',
	'bird_of_paradise',
	'bmx',
	'cheetah',
	'drift',
	'frog',
	'girl',
	'hummingbird',
	'monkey',
	'monkeydog',
	'parachute',
	'penguin',
	'soldier',
	'worm'};
	for k=3:length(vid_names)
		vid_name = vid_names{k};
		disp(vid_name);
		img_id = 1;
		simulate_segmentation_segtrack(base_dir,vid_name,img_id);
		break;
	end
end

if db_type == 2
	base_dir = '/vision/vision_users/suyog/active_video_annotation/data/vsb100/';
	db_type = 'Train';
	vid_file = [base_dir db_type '_videos.txt'];
	disp(vid_file);
	video_names = textread(vid_file,'%s');
	num_videos = length(video_names);
	for i=39:num_videos
		vid_name = video_names{i};
		disp(vid_name);
		img_id = 1;
		simulate_segmentation_vsb(base_dir,db_type,vid_name,img_id);
		break;
	end
end

if db_type == 3
	base_dir = '/vision/vision_users/suyog/active_video_annotation/data/ivideoseg/';
	db_type = '';
	vid_file = [base_dir db_type 'videos.txt'];
	disp(vid_file);
	video_names = textread(vid_file,'%s');
	num_videos = length(video_names);
	for i=42:num_videos
		vid_name = video_names{i};
		disp(vid_name);
		img_id = 1;
		simulate_segmentation_ivideoseg(base_dir,db_type,vid_name,img_id);
		break;
	end
end

if db_type == 4
	base_dir = '/vision/vision_users/suyog/cvpr16_danna/active_segmentation/data/';
	db_name = 'BU-BIL-Fluorescence';
	img_id = 118;
	simulate_segmentation_biomedical(base_dir,db_name,img_id);
end

if db_type == 5
	base_dir = '/vision/vision_users/suyog/cvpr16_danna/active_segmentation/data/';
	db_name = 'BU-BIL-PhaseContrast';
	img_id = 6;
	simulate_segmentation_biomedical(base_dir,db_name,img_id);
end

