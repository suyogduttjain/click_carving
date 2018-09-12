function [] = compute_mcg_static(image_dir,image_name,mcg_path)

	im_path =  [image_dir,image_name];
	im_prefix = image_name;
	im_prefix = im_prefix(1:end-4);
	
	curr_image = imread(im_path);	
	
	fprintf('Computing MCG proposals..\n');
	static_proposal_path =  [image_dir,im_prefix,'_static.mat'];
	[candidates_static, ucm2_static] = im2mcg(mcg_path,curr_image,[],'fast',0);
	save(static_proposal_path,'candidates_static','ucm2_static');
end
