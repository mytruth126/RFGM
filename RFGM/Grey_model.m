function varargout = Grey_model(varargin)
% GREY_MODEL MATLAB code for Grey_model.fig
%      GREY_MODEL, by itself, creates a new GREY_MODEL or raises the existing
%      singleton*.
%
%      H = GREY_MODEL returns the handle to a new GREY_MODEL or the handle to
%      the existing singleton*.
%
%      GREY_MODEL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GREY_MODEL.M with the given input arguments.
%
%      GREY_MODEL('Property','Value',...) creates a new GREY_MODEL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Grey_model_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Grey_model_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Grey_model

% Last Modified by GUIDE v2.5 24-Mar-2021 22:57:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Grey_model_OpeningFcn, ...
                   'gui_OutputFcn',  @Grey_model_OutputFcn, ...
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
% End initialization code - DO NOT EDIT


% --- Executes just before Grey_model is made visible.
function Grey_model_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Grey_model (see VARARGIN)

% Choose default command line output for Grey_model
handles.output = hObject;
set(handles.axes1,'XTick',[],'YTick',[]);
set(handles.axes2,'XTick',[],'YTick',[]);
set(handles.popupmenu1,'String',{'选择累加算子';'一阶累加';'分数阶累加';'CF累加';'HF累加';'NIP累加';'邻近累加';'阻尼累加'});
set(handles.popupmenu2,'String',{'选择模型结构';'传统GM(1,1)';'DGM(1,1)';'NDGM';'Verhulst';'离散Verhulst'});
% Update handles structure
handles.acc='选择累加算子';
handles.mod='选择模型结构';
guidata(hObject, handles);

% UIWAIT makes Grey_model wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Grey_model_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName PathName]=uigetfile({'*.xlsx','Excel Files(*.xlsx)';'*.xls','Excel Files(*.xls)';'*.*','All Files(*.*)'},'Choose a file');%uigetfile用来选择读入的文件
L=length(FileName);
if L<2
   errordlg('请再次选择正确文件','File Open Error');%建立一个默认参数的错误对话框
    return;
end 
str=[PathName FileName];
set(handles.edit1,'string',str);%使打来的文件路径和文件名显示在edit1
h=waitbar(0,'please wait a moment,reading the file now ............');
X0=xlsread(str);
if size(X0,1)~=1 && size(X0,2)~=1 
    errordlg('输入数据格式错误，请参考“数据.xlsx”，再次选择正确文件','File Open Error');%建立一个默认参数的错误对话框
    return;
end
waitbar(1,h,'Finished');delete(h);
handles.X0=X0; handles.datapath=PathName;
guidata(hObject, handles);

function pushbutton3_CreateFcn(hObject, eventdata, handles)
handles.X0=[];
handles.X0F=[];
guidata(hObject, handles);



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%开始计算
dbstop if error;
warning off;
global X0 accumulation_method model_equation n nf;
X0=handles.X0;
if numel(X0)==0
    errordlg('请读取文件','Loading Error');%建立一个默认参数的错误对话框
    return
end    
accumulation_method=handles.acc;
switch accumulation_method
    case '选择累加算子'
        errordlg('请选择累加算子','Setting Error');%建立一个默认参数的错误对话框
        return
end
model_equation=handles.mod;
switch model_equation
    case '选择模型结构'
        errordlg('请选择模型结构','File Open Error');%建立一个默认参数的错误对话框
        return
end
nf_str=handles.edit2_str;
if isnan(str2double(nf_str))
    errordlg('请在外推值个数的框里输入数字','Setting Error');%建立一个默认参数的错误对话框
    return
end
nf= str2double(nf_str);
h=waitbar(0,'请等待，计算中 ............');
[ MAPE,X0F,r ] = main(  );
if exist('X0F')==0
    errordlg('出现错误，请检查','Error');%建立一个默认参数的错误对话框
    return
end
handles.MAPE=MAPE;
handles.X0F=X0F;
handles.r=r;
axes(handles.axes3)
cla;
hand1=plot(1:n,X0);
set(hand1,'DisplayName','真实值','LineWidth',1,'Marker','o','markersize',4,'MarkerFaceColor',[0 0.447058826684952 0.74117648601532],...
    'MarkerEdgeColor',[0 0.447058826684952 0.74117648601532]) 
hold on;  
hand2=plot(1:n+nf,X0F); 
set(hand2,'linestyle','--','DisplayName','预测数据','MarkerFaceColor',[1 0 0],...
    'MarkerEdgeColor',[1 0 0],...
    'MarkerSize',4,...
    'Marker','diamond',...
    'LineWidth',2)
legend('真实值','预测数据');
title('灰色模型预测结果');
waitbar(1,h,'完成');delete(h);
guidata(hObject, handles);



% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if numel(handles.X0F)==0
    errordlg('请先计算结果','Error');
    return
end
Save_result(handles);
guidata(hObject, handles);

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear ;clc;  
close all;

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
val1=get(handles.popupmenu1,'Value');
str1=get(handles.popupmenu1,'String');
accumulation_method= str1{val1};
handles.acc=accumulation_method;
switch accumulation_method
    case '选择累加算子'
        return
    case '一阶累加'    
        axes(handles.axes1);
        cData=imread([accumulation_method,'.jpg']);
        image(cData);
        set(handles.axes1,'XTick',[],'YTick',[]);
    case '分数阶累加'
        axes(handles.axes1);
        cData=imread([accumulation_method,'.jpg']);
        image(cData);
        set(handles.axes1,'XTick',[],'YTick',[]);
    otherwise
        axes(handles.axes1);
        cData=imread('Noshow.jpg');
        image(cData);
        set(handles.axes1,'XTick',[],'YTick',[]);
end
guidata(hObject, handles);


% 导入图片



% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2

val2=get(hObject,'Value');
str2=get(hObject,'String');
model_equation=str2{val2};
handles.mod=model_equation;
switch model_equation
    case '选择模型结构'
        return
    otherwise
        cData=imread([model_equation,'.jpg']);        
end
axes(handles.axes2);
image(cData);
set(handles.axes2,'XTick',[],'YTick',[]);
guidata(hObject, handles);
% 导入图片

% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double

str=get(hObject,'String');
handles.edit2_str=str;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
str=get(hObject,'String');
handles.edit2_str=str;
guidata(hObject, handles);


% --------------------------------------------------------------------
function Menu_1_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Menu_2_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
msgbox('版本V1.0, 不一定会有下一版本','关于');


% --------------------------------------------------------------------
function Menu_3_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
msgbox('我也不知道你哪里需要帮助，有事就给我发邮件 mytruth@126.com','帮助');

% --------------------------------------------------------------------
function Menu_1_1_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_1_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h=questdlg('评价一下！(>ω<) ','给软件打分','1分','2分','3分','3分');
if exist('h')
    if h=='3分'
        msgbox('你不会真以为这个程序能打分吧？','?');
    end
end

% --------------------------------------------------------------------
function Menu_1_2_Callback(hObject, eventdata, handles)
add0=mfilename;%当前M文件名
add1=mfilename('fullpath');%当前m文件路径
i=length(add0);
j=length(add1);
local_address=add1(1:j-i-1);
msgbox(['源码在',local_address],'源码位置');

% --------------------------------------------------------------------
function Menu_1_3_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_1_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear ;clc;  
close all;
