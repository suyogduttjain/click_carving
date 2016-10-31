function out_img = blend_mask_border(img, mask, color_val, alpha)
	r = size(img,1);
	c = size(img,2);

	img = im2double(img);

	se = strel('disk',5);
	
	t_mask = mask;
	td_mask = imdilate(t_mask,se);
	td_mask = (t_mask-td_mask) ~=0;
	mask = td_mask;
	
	mask_columns = zeros(r*c,3);
	fg_pix = find(mask == 1);
	mask_columns(fg_pix,:) = repmat(color_val, length(fg_pix),1);
            
	img = reshape(reshape(img,r*c,[]),[],3);    
	out_img = img;
	out_img(fg_pix,:) = alpha*out_img(fg_pix,:) + (1-alpha)*mask_columns(fg_pix,:);
	out_img = reshape(out_img,r,c,3);  
end
