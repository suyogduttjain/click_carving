function [overlap_score] = compute_overlap_score(predicted_label_img, gt_label_img)
    predicted_label_img = predicted_label_img(:);
    gt_label_img = gt_label_img(:);

    intersect_score = sum(predicted_label_img & gt_label_img);
    union_score = sum(predicted_label_img | gt_label_img);
    
    if (union_score == intersect_score)
	    overlap_score = 1;
    else
	    overlap_score = intersect_score/union_score;
    end

end
