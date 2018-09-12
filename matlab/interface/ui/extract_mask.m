function out_img = extract_mask(img, mask)
	r = size(img,1);
	c = size(img,2);

	img = im2double(img);
	
	mask_columns = ones(r*c,3);
	fg_pix = find(mask == 1);
	img = reshape(reshape(img,r*c,[]),[],3);    
	mask_columns(fg_pix,:) = img(fg_pix,:);
	out_img = reshape(mask_columns,r,c,3);  
end
