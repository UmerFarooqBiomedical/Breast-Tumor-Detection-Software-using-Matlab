%Defualt code - No Need to change
function varargout = BCDS(varargin)
clc;
disp('hello')
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @BCDS_OpeningFcn, ...
                   'gui_OutputFcn',  @BCDS_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

function BCDS_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = BCDS_OutputFcn(hObject, ~, handles) 
% Get default command line output from handles structure
varargout{1} = handles.output;
%End of Default Initialization code - Do Not Change


axes(handles.axes1);
imshow('E:\Meeshal FYP\updated\Train C\pink2.jpg');
axes(handles.axes4);
imshow('E:\Meeshal FYP\updated\Train C\white4.jpg');
axes(handles.axes3);
imshow('E:\Meeshal FYP\updated\Train C\pink2.jpg');


% --- Executes on button press in input.
function input_Callback(hObject, eventdata, handles) %Input button push function

[number dire]=uigetfile('*.jpg','input');
if number==0
    return
end
img=imread(fullfile(dire,number));

axes(handles.axes5);
imag(img); %separates imaginary points
imshow(img);
setappdata(0,'saved_image',img)

% --- Executes on button press in detect.
function detect_Callback(hObject, eventdata, handles)
img = getappdata(0,'saved_image');

bw=im2bw(img,0.6);
label=bwlabel(bw);
stats=regionprops(label,'Solidity','Area');
density=[stats.Solidity];
area=[stats.Area];
high_dense_area=density>0.5;
max_area=max(area(high_dense_area));
if max_area>5000;
    set(handles.text3, 'String', 'No Tumor Detected');
    set(handles.text4, 'String', 'Status: Normal');
    axes(handles.axes6);
    imshow(img);
    %title('Tumor Alone');
    axes(handles.axes7);
    imshow(img);
    
else
    tumor_label=find(area==max_area);
    tumor=ismember(label,tumor_label);
    se=strel('square',4);
    tumor=imdilate(tumor,se);
    [B,L]=bwboundaries(tumor,'noholes');
    set(handles.text3, 'String', 'Tumor Detected');
    set(handles.text4, 'String', 'Status: Abnormal');
    axes(handles.axes6);
    imshow(tumor,[]);
    %title('Tumor Alone');
    axes(handles.axes7);
    imshow(img,[]);
    hold on
    for i=1:length(B)
        plot(B{i}(:,2),B{i}(:,1), 'y' ,'linewidth',1.45);

        end

    hold off;
end

function axes1_CreateFcn(hObject, eventdata, handles)


function axes3_CreateFcn(hObject, eventdata, handles)


function axes4_CreateFcn(hObject, eventdata, handles)
