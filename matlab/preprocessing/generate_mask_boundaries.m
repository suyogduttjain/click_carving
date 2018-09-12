function [boundary_data] = generate_mask_boundaries(masks,curr_image)
	nr = size(curr_image,1);
	nc = size(curr_image,2);

	num_masks = size(masks,3);
	num_types = 4;
	masks_edges = logical(zeros([size(masks) num_types ]));
	
	se = cell(1,num_types);	
	se{1} = strel(ones(3));
	se{2} = strel('disk',5);
	se{3} = strel('disk',10);
	se{4} = strel('disk',20);

	for i=1:num_masks
		mcg_mask = masks(:,:,i);
		for j = 1:num_types
			mcg_mask_out = imdilate(mcg_mask,se{j});
			mcg_mask_in  = imerode(mcg_mask,se{j});
			mcg_mask_out = (mcg_mask_out-mcg_mask)~=0;			
			mcg_mask_in = (mcg_mask-mcg_mask_in)~=0;			
			mcg_boundary = mcg_mask_in | mcg_mask_out;
			masks_edges(:,:,i,j) = mcg_boundary;
		end
	end

	boundary_data.masks_edges = masks_edges;

end
