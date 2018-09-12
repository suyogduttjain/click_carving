function [fdata] = segment_object(fdata,user_click,clickType)
	
	nr = fdata.nr;
	nc = fdata.nc;

	masks_votes = fdata.masks_votes;

	x = user_click(1);
	y = user_click(2);
	x = min(ceil(x),nc);
	y = min(ceil(y),nr);
						
	ind = sub2ind([nr nc],y,x);

	if strcmp(clickType, 'alt')
		neg_masks_idx = logical(fdata.lut_masks(ind,:));
		fdata.negative_idx = fdata.negative_idx | neg_masks_idx;
		fdata.user_clicks = [fdata.user_clicks ; -1*ind];
	else
		masks_votes(ind,:) = masks_votes(ind,:) + fdata.lut(ind,:);
		fdata.user_clicks = [fdata.user_clicks ; ind];
	end
	
	t_sum = sum(masks_votes,1);
	t_sum(fdata.negative_idx) = 0;
	[sort_sum, good_idx] = sort(t_sum,'descend');		
	
	fdata.masks_votes = masks_votes;
	fdata.good_idx = good_idx;
			
end
