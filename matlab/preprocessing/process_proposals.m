function [] = process_proposals(image_dir,image_name,num_props)
	im_path =  [image_dir,image_name];
	im_prefix = image_name;
	im_prefix = im_prefix(1:end-4);
	
	curr_image = imread(im_path);	

	static_proposal_path =  [image_dir,im_prefix,'_static.mat'];
	static_proposal_data_path =  [image_dir,im_prefix,'_static_data.mat'];
		
	fprintf('Processing MCG proposals..\n');
	load(static_proposal_path,'candidates_static','ucm2_static');
	static_proposal_data = generate_sorted_masks(candidates_static,curr_image,num_props);
	save(static_proposal_data_path,'static_proposal_data','-v7.3');
end
