function [best_id] = find_best_rep_mask(gt_bbox_mask, rep_bbox_masks)

	r = size(gt_bbox_mask,1);
	c = size(gt_bbox_mask,2);

	oscores = [];

	num_reps = length(rep_bbox_masks);

	for r=1:num_reps
		r_mask = rep_bbox_masks{r};
		oscore = compute_overlap_score(gt_bbox_mask, r_mask);
		oscores = [oscores ; oscore];
	end

	[os os_idx]= max(oscores);
	best_id = os_idx;
	if os<=0.3
		best_id = -1;
	end
end
