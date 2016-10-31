function [proposal_data] = generate_sorted_masks(candidates_scg,curr_image,num_props)
	[sorted_scores, ids] = sort(candidates_scg.scores,'descend');	
	nr = size(curr_image,1);
	nc = size(curr_image,2);

	num_props = min(length(ids),num_props);
	masks = logical(zeros(nr,nc,num_props));
	scores = zeros(num_props,1);

	for iter_ind = 1:num_props
		idx = ids(iter_ind);
		masks(:,:,iter_ind) = ismember(candidates_scg.superpixels, candidates_scg.labels{idx});
		scores(iter_ind)=candidates_scg.scores(idx);
	end

	proposal_data.masks = masks;
	proposal_data.scores = scores;
end
