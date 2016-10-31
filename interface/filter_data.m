function fdata = filter_data(static_proposal_data,num_select,nr,nc)

	mask_edges = logical(zeros(nr,nc,num_select));
	mask_top_edges = logical(zeros(nr,nc,num_select));
	masks = logical(zeros(nr,nc,num_select));
	
	num_objects = size(static_proposal_data.scores,2);


	mask_edges(:,:,1:num_select)     = static_proposal_data.masks_edges(:,:,1:num_select,3);
	mask_top_edges(:,:,1:num_select)     = static_proposal_data.masks_edges(:,:,1:num_select,1);
	masks(:,:,1:num_select)           = static_proposal_data.masks(:,:,1:num_select);

	%Used for voting
	fdata.masks = masks;
	fdata.mask_edges = mask_edges;

	%User for displaying weight image
	fdata.mask_top_edges = mask_top_edges;

end
