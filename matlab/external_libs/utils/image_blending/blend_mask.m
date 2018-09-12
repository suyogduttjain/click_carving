%img: hxwx3 rgb image
%mask: hxw logical mask
%color_val: 3x1 rgb triplet (values between 0 an 1)
%alpha: value between 0 and 1 decides amount of blending
%blend_type: 0: blend full mask, 1: blend only boundary
function out_img = blend_mask(img, mask, color_val, alpha, blend_type)
	r = size(img,1);
	c = size(img,2);
	nch = size(img,3);

	if nch == 1
		img = repmat(img,[1 1 3]);
	end

	img = im2double(img);

	if blend_type == 1
		se = strel('disk',2);
		mask_out = imdilate(mask,se);
		mask_in  = imerode(mask,se);
		mask_out = (mask_out-mask)~=0;
		mask_in = (mask-mask_in)~=0;			
		mask = mask_in | mask_out;
	end
	
	mask_columns = zeros(r*c,3);
	fg_pix = find(mask == 1);
	mask_columns(fg_pix,:) = repmat(color_val, length(fg_pix),1);
            
	img = reshape(reshape(img,r*c,[]),[],3);    
	out_img = img;
	out_img(fg_pix,:) = alpha*out_img(fg_pix,:) + (1-alpha)*mask_columns(fg_pix,:);
	out_img = reshape(out_img,r,c,3);  
end
