function out_img = blend_images(img, img_t,alpha)
	r = size(img,1);
	c = size(img,2);

	img = im2double(img);
	img_orig = img;
	img_t = im2double(img_t);
	
	img_t_col = reshape(reshape(img_t,r*c,[]),[],3);    
	img_t_sum = sum(img_t_col,2);
	mask_columns = zeros(r*c,3);
	bg_pix = find(img_t_sum == 0);
            
	img = reshape(reshape(img,r*c,[]),[],3);    
	%out_img = img_t;
	
	out_img = alpha*img_orig + (1-alpha)*img_t;
	out_img = reshape(reshape(out_img,r*c,[]),[],3);    
	out_img(bg_pix,:) = img(bg_pix,:);
	out_img = reshape(out_img,r,c,3);  
end
