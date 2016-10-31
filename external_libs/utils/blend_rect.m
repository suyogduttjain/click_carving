function out_img = blend_rect(img, mask, color_val, alpha)
	r = size(img,1);
	c = size(img,2);

	bbox_mask = logical(zeros(size(mask)));

	bbox = regionprops(mask,'Area','BoundingBox');
	[~,ind] = max(cat(1,bbox.Area));
	ind = uint16(ind);

	if ~isempty(ind)
		rect = bbox(ind).BoundingBox;
		xmin = rect(1);
		ymin = rect(2);
		xmax = min(rect(3) + xmin,c);
		ymax = min(rect(4) + ymin,r);
		bbox_mask(ymin:ymax,xmin:xmax) = 1;
		se = strel('disk',5);
		bbox_dilate = imdilate(bbox_mask,se);
		temp_mask = bbox_dilate-bbox_mask;
		mask = logical(temp_mask~=0);
	else
		mask = logical(zeros(r,c));
	end

	img = im2double(img);
	
	mask_columns = zeros(r*c,3);
	fg_pix = find(mask == 1);
	mask_columns(fg_pix,:) = repmat(color_val, length(fg_pix),1);
            
	img = reshape(reshape(img,r*c,[]),[],3);    
	out_img = img;
	out_img(fg_pix,:) = alpha*out_img(fg_pix,:) + (1-alpha)*mask_columns(fg_pix,:);
	out_img = reshape(out_img,r,c,3);  
end
