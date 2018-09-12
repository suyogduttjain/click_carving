function [] = click_carving(image_dir,image_name)
	im_path =  [image_dir,image_name];
	im_prefix = image_name;
	im_prefix = im_prefix(1:end-4);

	curr_image = imread(im_path);	

	static_proposal_path =  [image_dir,im_prefix,'_static.mat'];
	static_proposal_data_path =  [image_dir,im_prefix,'_static_data.mat'];
	static_proposal_boundary_path =  [image_dir,im_prefix,'_static_boundary.mat'];

	load(static_proposal_data_path,'static_proposal_data');
	load(static_proposal_boundary_path,'static_proposal_boundary_data');
	
	static_proposal_data.masks_edges = static_proposal_boundary_data.masks_edges;

	nr = size(curr_image,1);
	nc = size(curr_image,2);
		
	num_static = size(static_proposal_data.scores,1);
	fdata = filter_data(static_proposal_data,num_static,nr,nc);


	masks = fdata.masks;
	mask_edges = fdata.mask_edges;
	num_masks = size(masks,3);

	lut = reshape(mask_edges,size(mask_edges,1)*size(mask_edges,2),num_masks);
	lut_masks = reshape(masks,size(masks,1)*size(masks,2),num_masks);


	fdata.lut = lut;
	fdata.lut_masks = lut_masks;
	fdata.num_masks = num_masks;
	fdata.negative_idx = logical(zeros(1,num_masks));
	fdata.curr_image = curr_image;
	fdata.nr = nr;
	fdata.nc = nc;
	fdata.top_k = 9;
	sketch2segment(fdata);
end
