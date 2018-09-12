import os
import sys
import numpy as np
import torchfile as tf
from skimage.util import img_as_ubyte
from skimage import io as skio
from skimage.morphology import dilation,binary_dilation, disk
from skimage.draw import circle, circle_perimeter
import json
import flask
import tornado.wsgi
import tornado.httpserver
from PIL import Image
import base64
import io

#Obtain the flask app object
app = flask.Flask(__name__)

def start_tornado(app, port=5000):
    http_server = tornado.httpserver.HTTPServer(
        tornado.wsgi.WSGIContainer(app))
    http_server.listen(port)
    print("Tornado server starting on port {}".format(port))
    tornado.ioloop.IOLoop.instance().start()

def load_proposals(proposal_path, num_masks=None):
    data = tf.load(proposal_path)
    masks = data[b'masks']
    scores = data[b'scores']
    scores = scores[:,0]
    
    if num_masks is not None:
        masks = masks[:num_masks,:,:]
        scores = scores[:num_masks]

    return [masks, scores]

def dilate_proposals(masks, radius=6):
    selem = disk(radius)
    dilated = np.empty(masks.shape)
    num_masks = dilated.shape[0]
    for i in range(num_masks):
        dilated[i,:,:] = binary_dilation(masks[i,:,:], selem)
        
    dilated = dilated.astype(np.uint8)
    
    return dilated

def load_image(img_path):
    img = skio.imread(img_path)
    
    return img

def embed_image_html(image):
    image_pil = Image.fromarray((image).astype('uint8'))
    buffer = io.BytesIO()
    image_pil.save(buffer, format='PNG')
    buffer.seek(0)
    data = base64.b64encode(buffer.read()).decode('ascii')
    return 'data:image/png;base64,' + data

def process_click(click_str):
    if len(click_str)==0:
        return None
    tokens = click_str.split('|')
    if len(tokens)!=3:
        return None

    c = {}

    for tok in tokens:
        k,v = tok.split(':')
        c[k] = np.uint16(v)

    return c

def draw_point(input_img, image_click):
    rr, cc = circle(image_click['y'], image_click['x'], 10, input_img.shape)
    rrp, ccp = circle_perimeter(image_click['y'], image_click['x'], 10,'bresenham',input_img.shape)
    if image_click['t']==2:
        input_img[rr,cc,:] = (255, 0, 0)
    else:
        input_img[rr,cc,:] = (0, 255, 0)
        
    input_img[rrp,ccp,:] = (0, 0, 0)
    
def blend_mask(input_img, binary_mask, alpha=0.5):
    
    if input_img.ndim==2:
        return input_img
    
    mask_image = np.zeros(input_img.shape,np.uint8)
    mask_image[:,:,1] = 255
    mask_image = mask_image*np.repeat(binary_mask[:,:,np.newaxis],3,axis=2)

    blend_image = input_img[:,:,:]
    pos_idx = binary_mask>0
    for ind in range(input_img.ndim):
        ch_img1 = input_img[:,:,ind]
        ch_img2 = mask_image[:,:,ind]
        ch_img3 = blend_image[:,:,ind]
        ch_img3[pos_idx] = alpha*ch_img1[pos_idx] + (1-alpha)*ch_img2[pos_idx]
        blend_image[:,:,ind] = ch_img3
    return blend_image

def get_top_ranked(cc_data, image_click, top_k):
    row = image_click['y'] 
    col = image_click['x']
    c_type = image_click['t']
    global pos_wts
    global neg_wts

    m = cc_data['dilated']
    s = cc_data['scores']
    if c_type==2:
        neg_wts = neg_wts + m[:,row,col]
    else:
        pos_wts = pos_wts + m[:,row,col]

    pwt = np.copy(pos_wts)
    pwt[neg_wts>0] = -1
    
    result = np.zeros((s.shape[0],4))
    result[:,0] = np.copy(pos_wts)
    result[:,1] = np.copy(neg_wts)
    result[:,2] = pwt
    result[:,3] = np.copy(s)

    ind = np.lexsort((result[:,3],result[:,2]))
    ind =  ind[::-1]
    return ind[:top_k]

@app.route('/')
def index():
    global response
    global cc_data 
    global pos_wts
    global neg_wts

    base_dir = app.config['base_dir']
    img_name = app.config['img_name']
    img_prefix = img_name.split('.')[0]

    img_dir      = os.path.join(base_dir,'images')
    img_path = os.path.join(img_dir,img_name)
    print(img_path)
    print('Loading image and proposals, please wait')

    proposal_dir = os.path.join(base_dir,'proposal')
    proposal_path = os.path.join(proposal_dir,img_prefix+'.t7')

    img = load_image(img_path)

    masks,scores = load_proposals(proposal_path,400)
    dilated = dilate_proposals(masks)

    pos_wts = np.zeros(masks.shape[0])
    neg_wts = np.zeros(masks.shape[0])

    print('Loading done')

    img_h = img.shape[0]
    img_w = img.shape[1]
    print('Image height {} and width {}'.format(img_h,img_w))

    cc_data = {}
    cc_data['img_h'] = img_h
    cc_data['img_w'] = img_w
    cc_data['masks'] = masks
    cc_data['scores'] = scores
    cc_data['dilated'] = dilated
    cc_data['orig'] = np.copy(img)
    cc_data['render'] = np.copy(img)
    cc_data['clicks'] = []

    img_stream = embed_image_html(cc_data['render'])
    
    response = {}
    response['input_img'] = img_stream
    response['im_width']  = img_w
    response['im_height'] = img_h
    response['show_error'] = False
    return flask.render_template('index.html', response=response)


@app.route('/click_carving', methods=['GET'])
def click_carving():
    image_click = flask.request.args.get('image_clicks', '')
    image_click = process_click(image_click)
    
    if image_click is None:
        return flask.render_template('index.html', response=response)
    
    cc_data['clicks'].append(image_click)
    draw_point(cc_data['render'], image_click)
        
    img_stream = embed_image_html(cc_data['render'])
    response['input_img'] = img_stream

    top_k = 8
    ranking = get_top_ranked(cc_data, image_click, top_k)
    
    response['ranked'] = []
    for i in range(top_k):
        original_img = np.copy(cc_data['orig'])
        rank_img = blend_mask(original_img,cc_data['masks'][ranking[i],:,:])
        rank_img = embed_image_html(rank_img)
        response['ranked'].append(rank_img)

    return flask.render_template('index.html', response=response)

if __name__ == '__main__':
    app.config['base_dir'] = sys.argv[1]
    app.config['img_name'] = sys.argv[2]

    start_tornado(app, 5000)

