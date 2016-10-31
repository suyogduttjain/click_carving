function [] = proposal_boundaries(image_dir,image_name)
	im_path =  [image_dir,image_name];
	im_prefix = image_name;
	im_prefix = im_prefix(1:end-4);
	
	curr_image = imread(im_path);	

	static_proposal_path =  [image_dir,im_prefix,'_static.mat'];
	static_proposal_data_path =  [image_dir,im_prefix,'_static_data.mat'];
	static_proposal_boundary_path =  [image_dir,im_prefix,'_static_boundary.mat'];
		
	fprintf('Compute edges..\n');
	
	load(static_proposal_data_path,'static_proposal_data');
	static_proposal_boundary_data = generate_mask_boundaries(static_proposal_data.masks,curr_image);
	save(static_proposal_boundary_path,'static_proposal_boundary_data','-v7.3');

end
