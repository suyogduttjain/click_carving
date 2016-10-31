function [bbox_mask bbox_rect] = estimate_bbox_mask(mask)

	r = size(mask,1);
	c = size(mask,2);
	
	bbox_mask = logical(zeros(size(mask)));

	bbox = regionprops(mask,'Area','BoundingBox');
	if length(bbox)> 0
		[~,ind] = max(cat(1,bbox.Area));
		rect = bbox(ind).BoundingBox;
		xmin = rect(1);
		ymin = rect(2);
		xmax = min(rect(3) + xmin,c);
		ymax = min(rect(4) + ymin,r);

		bbox_mask(ymin:ymax,xmin:xmax) = 1;
		bbox_rect = [xmin ymin rect(3) rect(4)];
	else
		bbox_rect = [0 0 0 0];
	end
	
end
