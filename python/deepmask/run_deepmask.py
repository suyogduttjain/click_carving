#python run_deepmask.py ./datasets/grabcut/
import os
import sys
import torchfile
import numpy as np
import scipy.sparse

data_dir = sys.argv[1]
image_dir = os.path.join(data_dir,'images')
output_dir = os.path.join(data_dir,'deepmask')
cmd = 'mkdir -p ' + output_dir
os.system(cmd)

num_proposals = 500

image_list = os.listdir(image_dir)
for img_name in image_list:
    img_prefix = img_name.split('.')[0]
    img_path    = os.path.join(image_dir,img_name)
    output_path = os.path.join(output_dir,img_prefix + '.t7')
    print(img_path)
    
    cmd = 'th deepmask/computeProposals.lua deepmask/pretrained/shapemask/' 
    cmd += ' -np ' + str(num_proposals) 
    cmd += ' -img ' + img_path
    cmd += ' -output ' + output_path

    os.system(cmd)
