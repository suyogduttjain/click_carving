function [hC vC] = colordiff(im)
    vC = zeros(size(im,1),size(im,2));
    for c=1:3
      tmp = im(:,:,c);
      tmpim = [zeros(1,size(im,2)); tmp(1:end-1,:)];
      vC = vC + (tmpim - tmp).^2;
    end
    beta = 1/2/mean(vC(:)*5);
    vC = exp(-beta * vC);

    hC = zeros(size(im,1),size(im,2));
    for c=1:3
      tmp = im(:,:,c);
      tmpim = [zeros(size(im,1),1) tmp(:,1:end-1)];
      hC = hC + (tmpim - tmp).^2;
    end
    beta = 1/2/mean(hC(:)*5);
    hC = exp(-beta * hC);
end
