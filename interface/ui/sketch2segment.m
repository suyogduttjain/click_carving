function varargout = sketch2segment(varargin)
%SKETCH2SEGMENT M-file for sketch2segment.fig
%      SKETCH2SEGMENT, by itself, creates a new SKETCH2SEGMENT or raises the existing
%      singleton*.
%
%      H = SKETCH2SEGMENT returns the handle to a new SKETCH2SEGMENT or the handle to
%      the existing singleton*.
%
%      SKETCH2SEGMENT('Property','Value',...) creates a new SKETCH2SEGMENT using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to sketch2segment_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      SKETCH2SEGMENT('CALLBACK') and SKETCH2SEGMENT('CALLBACK',hObject,...) call the
%      local function named CALLBACK in SKETCH2SEGMENT.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help sketch2segment

% Last Modified by GUIDE v2.5 20-Mar-2016 02:25:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sketch2segment_OpeningFcn, ...
                   'gui_OutputFcn',  @sketch2segment_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
   gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before sketch2segment is made visible.
function sketch2segment_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)
set(handles.figure1, 'Name', 'Click Carving');
%set(handles.figure1, 'units', 'normalized', 'position', [0 0 1 1])

fdata = varargin{1};
disp('Initializing');
fdata.masks_votes = zeros(size(fdata.lut));
handles.fdata = fdata;
% Choose default command line output for sketch2segment
handles.output = hObject;
handles.axis_vars = cell(1,9);
for i=1:9
	handles.axis_vars{i} = ['handles.topRank' num2str(i)];
	set(eval(handles.axis_vars{i}),'Visible','off')
end
set(handles.contourmap,'Visible','off')
handles.num_clicks = 1;
handles.fdata.user_clicks = [];

% Update handles structure
guidata(hObject, handles);
imgHandle = imshow(handles.fdata.curr_image,'Parent',handles.canvas);
set(imgHandle,'ButtonDownFcn',@ClickCarvingCallback);


% UIWAIT makes sketch2segment wait for user response (see UIRESUME)
% uiwait(handles.figure1);


function ClickCarvingCallback ( hObject , eventData)
	axesHandle  = get(hObject,'Parent');
	coordinates = get(axesHandle,'CurrentPoint'); 
	coordinates = coordinates(1,1:2);

	figHandle = ancestor(hObject, 'figure');
	handles = guidata(figHandle);
	clickType = get(figHandle, 'SelectionType');
	
	handles.fdata = segment_object(handles.fdata,coordinates,clickType);
	handles.num_clicks = handles.num_clicks+1;


	good_idx = handles.fdata.good_idx(1:handles.fdata.top_k);
	top_masks  = handles.fdata.masks(:,:,good_idx);
	top_edges  = handles.fdata.mask_top_edges(:,:,good_idx);

	zero_img =zeros(handles.fdata.nr,handles.fdata.nc,3);
	
	mask_wt = sum(top_edges,3);
	wt_image = label2rgb(mask_wt,'jet','k');
	handles.fdata.wt_image = blend_images(zero_img,wt_image,0);
	
	click_mask = logical(zeros(handles.fdata.nr,handles.fdata.nc));
	negative_click_mask = logical(zeros(handles.fdata.nr,handles.fdata.nc));

	positive_clicks = handles.fdata.user_clicks(handles.fdata.user_clicks>0);
	negative_clicks = abs(handles.fdata.user_clicks(handles.fdata.user_clicks<0));

	click_mask(positive_clicks) = 1;
	se = strel('disk',4);
	se1 = strel('disk',2);
	click_mask = imdilate(click_mask,se);
	click_mask_big = imdilate(click_mask,se1);
	
	negative_click_mask(negative_clicks) = 1;
	negative_click_mask = imdilate(negative_click_mask,se);
	negative_click_mask_big = imdilate(negative_click_mask,se1);

	
	init_image = handles.fdata.curr_image;	
	click_image = blend_mask(init_image,negative_click_mask_big,[1 0 0],0);
	click_image = blend_mask(click_image,negative_click_mask,[1 0 0],0);
	click_image = blend_mask(click_image,click_mask_big,[0 1 0],0);
	click_image = blend_mask(click_image,click_mask,[0 1 0],0);

	handles.fdata.click_image = click_image;

	%Need to do this to update the handles in the global scope
	guidata(ancestor(hObject, 'figure'),handles);


	for num_prop = 1:handles.fdata.top_k
		top_img = blend_mask_border(handles.fdata.curr_image,top_masks(:,:,num_prop),[0 1 0],0);
		top_img = blend_mask(top_img,top_masks(:,:,num_prop),[0 1 0],0.5);
		axis_handle = imshow(top_img,'Parent',eval(handles.axis_vars{num_prop}));
		set(axis_handle,'ButtonDownFcn',@ClickAxisCallback);
	end

	imgHandle = imshow(handles.fdata.click_image,'Parent',handles.canvas);
	set(imgHandle,'ButtonDownFcn',@ClickCarvingCallback);
	imshow(handles.fdata.wt_image,'Parent',handles.contourmap);

% --- Outputs from this function are returned to the command line.
function varargout = sketch2segment_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
	% hObject    handle to reset (see GCBO)
	% eventdata  reserved - to be defined in a future version of MATLAB
	% handles    structure with handles and user data (see GUIDATA)
	disp('Reseting now');
	handles.fdata.masks_votes = zeros(size(handles.fdata.lut));
	handles.fdata.negative_idx = logical(zeros(1,handles.fdata.num_masks));
	handles.output = hObject;
	handles.axis_vars = cell(1,9);

	for i=1:9
		handles.axis_vars{i} = ['handles.topRank' num2str(i)];
		%Turn axis for top-k and its children (current masks) off
		set(eval(handles.axis_vars{i}),'Visible','off')
		set(get(eval(handles.axis_vars{i}),'children'),'Visible','off')
	end
	handles.num_clicks = 1;
	handles.fdata.user_clicks = [];

	set(handles.contourmap,'Visible','off')
	set(get(handles.contourmap,'children'),'Visible','off')

	% Update handles structure
	guidata(hObject, handles);
	imgHandle = imshow(handles.fdata.curr_image,'Parent',handles.canvas);
	set(imgHandle,'ButtonDownFcn',@ClickCarvingCallback);


% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
	% hObject    handle to save (see GCBO)
	% eventdata  reserved - to be defined in a future version of MATLAB
	% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in original.
function original_Callback(hObject, eventdata, handles)
	% hObject    handle to original (see GCBO)
	% eventdata  reserved - to be defined in a future version of MATLAB
	% handles    structure with handles and user data (see GUIDATA)
	%imgHandle = imshow(handles.fdata.curr_image,'Parent',handles.canvas);
	imgHandle = imshow(handles.fdata.click_image,'Parent',handles.canvas);
	set(imgHandle,'ButtonDownFcn',@ClickCarvingCallback);

function ClickAxisCallback ( hObject , eventData)
	figHandle = ancestor(hObject, 'figure');
	handles = guidata(figHandle);
	clickType = get(figHandle, 'SelectionType');
	if strcmp(clickType, 'alt')
		imgHandle = imshow(handles.fdata.click_image,'Parent',handles.canvas);
		set(imgHandle,'ButtonDownFcn',@ClickCarvingCallback);
	else
		mask_img = getimage(hObject);
		imgHandle = imshow(mask_img,'Parent',handles.canvas);
	end
