function varargout = EMGnew1125(varargin)
%
%  visualizes data and found events. When EMGnew is executed, the user
%  selects the outputed file from findEMG
%
% EMGNEW MATLAB code for EMGnew.fig
%      EMGNEW, by itself, creates a new EMGNEW or raises the existing
%      singleton*.
%
%      H = EMGNEW returns the handle to a new EMGNEW or the handle to
%      the existing singleton*.
%
%      EMGNEW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EMGNEW.M with the given input arguments.
%
%      EMGNEW('Property','Value',...) creates a new EMGNEW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before EMGnew_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to EMGnew_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help EMGnew

% Last Modified by GUIDE v2.5 03-Sep-2018 19:40:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @EMGnew_OpeningFcn, ...
                   'gui_OutputFcn',  @EMGnew_OutputFcn, ...
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


% --- Executes just before EMGnew is made visible.
function EMGnew_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to EMGnew (see VARARGIN)
[FileName,PathName]=uigetfile;
File= fullfile(PathName, FileName);
EMGdata=load(File);
a=1;

%channel 1 plot
y=EMGdata.trials.ch1{a,1};
x=linspace(0,4,length(y));
%channel 2
y2=EMGdata.trials.ch2{a,1};
%channel 3
y3=EMGdata.trials.ch3{a,1};
%channel 4
y4=EMGdata.trials.photodiode{a,1};

x1=EMGdata.trials.MEPloc{a,1};
x2=EMGdata.trials.artloc{a,1};
x3=EMGdata.trials.EMG_burst{a,1}(1,1);
x4=EMGdata.trials.EMG_burst{a,1}(1,2);
x5=EMGdata.trials.go_stim_onset{a,1};

%plot 1
subplot(4,1,1)
z=plot(x,y);
line([x1 x1], [-.5 .5] ,'Color','red')
ylim([-.1 .1]);
xlabel('seconds');
ylabel('mV');
 if strcmp(EMGdata.trials.left_or_right(a,1),'left')
     line([x3 x3], [-.5 .5],'Color', 'red')
     line([x4 x4], [-.5 .5],'Color', 'red')
 end

% title_text = sprintf('sweepnumber: %d\n   tms: %s\n   trial type: %s,%s\n', a , EMGdata.trials.tms{a,1},EMGdata.trials.left_or_right{a,1},EMGdata.trials.go_or_catch{a,1});
% title(title_text);
%plot 2
subplot(4,1,2);
z2=plot(x,y2);
ylim([-.1 .1]);
xlabel('seconds');
ylabel('mV');
 if strcmp(EMGdata.trials.left_or_right(a,1),'right')
     line([x3 x3], [-.5 .5],'Color', 'red')
     line([x4 x4], [-.5 .5],'Color', 'red')
 end
%plot 3
subplot(4,1,3);
z3=plot(x,y3);
line([x2 x2], [-.5 .5] ,'Color','red')
ylim([-.1 .1]);
xlabel('seconds');
ylabel('mV');

%plot 4
subplot(4,1,4);
z4=plot(x,y4);
line([x5 x5], [-.5 .5] ,'Color','red')
ylim([-.25 .25]);
xlabel('seconds');
ylabel('mV');


%update handles variables
handles.EMGdata = EMGdata;
handles.a = a;
handles.File=File;
handles.output = hObject;

%set checkbox
if EMGdata.trials.trial_accept{a,1}==1
set(handles.checkbox1,'Value',1)
else
set(handles.checkbox1,'Value',0)
end


% Choose default command line output for EMGnew
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes EMGnew wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = EMGnew_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
% --- Allows user to scroll left through sweeps
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=handles.a;
EMGdata=handles.EMGdata;

%decrement
a=a-1;
handles.a=a;

%channel 1
y=EMGdata.trials.ch1{a,1};
x=linspace(0,4,length(y));
%channel 2
y2=EMGdata.trials.ch2{a,1};
%channel 3
y3=EMGdata.trials.ch3{a,1};
%channel 4
y4=EMGdata.trials.photodiode{a,1};

x1=EMGdata.trials.MEPloc{a,1};
x2=EMGdata.trials.artloc{a,1};
x3=EMGdata.trials.EMG_burst{a,1}(1,1);
x4=EMGdata.trials.EMG_burst{a,1}(1,2);
x5=EMGdata.trials.go_stim_onset{a,1};

%plot 1
subplot(4,1,1)
z=plot(x,y);
line([x1 x1], [-.5 .5] ,'Color','red')
ylim([-.1 .1]);
xlabel('seconds');
ylabel('mV');
 if strcmp(EMGdata.trials.left_or_right(a,1),'left')
     line([x3 x3], [-.5 .5],'Color', 'red')
     line([x4 x4], [-.5 .5],'Color', 'red')
 end

title_text = sprintf('sweepnumber: %d\n   tms: %s\n   trial type: %s,%s\n', a , EMGdata.trials.tms{a,1},EMGdata.trials.left_or_right{a,1},EMGdata.trials.go_or_catch{a,1});
title(title_text);
%plot 2
subplot(4,1,2);
z2=plot(x,y2);
ylim([-.1 .1]);
xlabel('seconds');
ylabel('mV');
 if strcmp(EMGdata.trials.left_or_right(a,1),'right')
     line([x3 x3], [-.5 .5],'Color', 'red')
     line([x4 x4], [-.5 .5],'Color', 'red')
 end
%plot 3
subplot(4,1,3);
z3=plot(x,y3);
line([x2 x2], [-.5 .5] ,'Color','red')
ylim([-.1 .1]);
xlabel('seconds');
ylabel('mV');

%plot 4
subplot(4,1,4);
z4=plot(x,y4);
line([x5 x5], [-.5 .5] ,'Color','red')
ylim([-.25 .25]);
xlabel('seconds');
ylabel('mV');


%update handles variables
handles.EMGdata = EMGdata;
handles.a = a;
handles.output = hObject;
%set checkbox
if EMGdata.trials.trial_accept{a,1}==1
set(handles.checkbox1,'Value',1)
else
set(handles.checkbox1,'Value',0)
end

guidata(hObject, handles);


% --- Executes on button press in pushbutton2.
% --- Allows user to scroll right through sweeps
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=handles.a;
EMGdata=handles.EMGdata;

%increment
a=a+1;
handles.a=a;

%channel 1
y=EMGdata.trials.ch1{a,1};
x=linspace(0,4,length(y));
%channel 2
y2=EMGdata.trials.ch2{a,1};
%channel 3
y3=EMGdata.trials.ch3{a,1};
%channel 4
y4=EMGdata.trials.photodiode{a,1};

x1=EMGdata.trials.MEPloc{a,1};
x2=EMGdata.trials.artloc{a,1};
x3=EMGdata.trials.EMG_burst{a,1}(1,1);
x4=EMGdata.trials.EMG_burst{a,1}(1,2);
x5=EMGdata.trials.go_stim_onset{a,1};

%plot 1
subplot(4,1,1)
z=plot(x,y);
line([x1 x1], [-.5 .5] ,'Color','red')
ylim([-.1 .1]);
xlabel('seconds');
ylabel('mV');
if strcmp(EMGdata.trials.left_or_right(a,1),'left')
    line([x3 x3], [-.5 .5],'Color', 'red')
    line([x4 x4], [-.5 .5],'Color', 'red')
end
% 
title_text = sprintf('sweepnumber: %d\n   tms: %s\n   trial type: %s,%s\n', a , EMGdata.trials.tms{a,1},EMGdata.trials.left_or_right{a,1},EMGdata.trials.go_or_catch{a,1});
title(title_text);
%plot 2
subplot(4,1,2);
z2=plot(x,y2);
ylim([-.1 .1]);
xlabel('seconds');
ylabel('mV');
if strcmp(EMGdata.trials.left_or_right(a,1),'right')
    line([x3 x3], [-.5 .5],'Color', 'red')
    line([x4 x4], [-.5 .5],'Color', 'red')
end
%plot 3
subplot(4,1,3);
z3=plot(x,y3);
line([x2 x2], [-.5 .5] ,'Color','red')
ylim([-.1 .1]);
xlabel('seconds');
ylabel('mV');

%plot 4
subplot(4,1,4);
z4=plot(x,y4);
line([x5 x5], [-.5 .5] ,'Color','red')
ylim([-.25 .25]);
xlabel('seconds');
ylabel('mV');


%update handles variables
handles.EMGdata = EMGdata;
handles.a = a;
%handles.File=File;
handles.output = hObject;
%set checkbox
if EMGdata.trials.trial_accept{a,1}==1
set(handles.checkbox1,'Value',1)
else
set(handles.checkbox1,'Value',0)
end

guidata(hObject, handles);



% --- Allows user to enter sweep number to go to
% --- Int should be entered
function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
%handles.checkbox=checkbox;
a=str2double(get(hObject,'String'));
EMGdata=handles.EMGdata;
handles.a=a;

%channel 1
y=EMGdata.trials.ch1{a,1};
x=linspace(0,4,length(y));
%channel 2
y2=EMGdata.trials.ch2{a,1};
%channel 3
y3=EMGdata.trials.ch3{a,1};
%channel 4
y4=EMGdata.trials.photodiode{a,1};

x1=EMGdata.trials.MEPloc{a,1};
x2=EMGdata.trials.artloc{a,1};
x3=EMGdata.trials.EMG_burst{a,1}(1,1);
x4=EMGdata.trials.EMG_burst{a,1}(1,2);
x5=EMGdata.trials.go_stim_onset{a,1};

%plot 1
subplot(4,1,1)
z=plot(x,y);
line([x1 x1], [-.5 .5] ,'Color','red')
ylim([-.1 .1]);
xlabel('seconds');
ylabel('mV');
if strcmp(EMGdata.trials.left_or_right(a,1),'left')
    line([x3 x3], [-.5 .5],'Color', 'red')
    line([x4 x4], [-.5 .5],'Color', 'red')
end

title_text = sprintf('sweepnumber: %d\n   tms: %s\n   trial type: %s,%s\n', a , EMGdata.trials.tms{a,1},EMGdata.trials.left_or_right{a,1},EMGdata.trials.go_or_catch{a,1});
title(title_text);
%plot 2
subplot(4,1,2);
z2=plot(x,y2);
ylim([-.1 .1]);
xlabel('seconds');
ylabel('mV');
if strcmp(EMGdata.trials.left_or_right(a,1),'right')
    line([x3 x3], [-.5 .5],'Color', 'red')
    line([x4 x4], [-.5 .5],'Color', 'red')
end
%plot 3
subplot(4,1,3);
z3=plot(x,y3);
line([x2 x2], [-.5 .5] ,'Color','red')
ylim([-.1 .1]);
xlabel('seconds');
ylabel('mV');

%plot 4
subplot(4,1,4);
z4=plot(x,y4);
line([x5 x5], [-.5 .5] ,'Color','red')
ylim([-.25 .25]);
xlabel('seconds');
ylabel('mV');


%update handles variables
handles.EMGdata = EMGdata;
handles.a = a;
handles.output = hObject;
%set checkbox
if EMGdata.trials.trial_accept{a,1}==1
set(handles.checkbox1,'Value',1)
else
set(handles.checkbox1,'Value',0)
end

guidata(hObject, handles);


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


% --- Executes on button press in checkbox1.
% --- Allows user to accept or reject sweeps by pressing checkbox
% --- checked = accepted
function checkbox1_Callback(checkbox, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%checkbox=handles.checkbox;
handles.checkbox=checkbox;
EMGdata=handles.EMGdata;
a=handles.a;
if (get(checkbox,'Value') == ~get(checkbox,'Max'))
    display('rejected')
    EMGdata.trials.trial_accept{a,1}=0;
end
if (get(checkbox,'Value') == get(checkbox,'Max'))
    display('accepted')
    EMGdata.trials.trial_accept{a,1}=1;
end

handles.EMGdata=EMGdata;
guidata(checkbox, handles);


% --- Executes on button press in pushbutton3.
% --- Allows user to save changes(brushes ,checks)to data
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
EMGdata=handles.EMGdata;
File=handles.File;
subject=EMGdata.subject;
%CHANGE emg burst indices for those that aren't zero
for i=1:108
    if ~isempty(EMGdata.trials.indeces_on{i,1})
EMGdata.trials.EMG_burst{i,1}(1,1)=EMGdata.trials.indeces_on{i,1};
EMGdata.trials.EMG_burst{i,1}(1,2)=EMGdata.trials.indeces_off{i,1};
    end
end
handles.EMGdata=EMGdata;

outfile=File;
trials=EMGdata.trials;
uisave({'trials','subject'},outfile);
%save('test.mat','trials','-append');
display('saved');

% --- Executes on button press in brush.
% --- Allows user to correct for misidentified EMGburst onsets and offsets.
% --- When 'brush' button is pressed, first select the correct EMG burst
% onset, then press correct EMG burst offset
function brush_Callback(hObject, eventdata, handles)
% hObject    handle to brush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=handles.a;
EMGdata=handles.EMGdata;
%manually select onset and offset point for bursts
xs=ginput(2);
EMGdata.trials.indeces_on{a,1}=xs(1,1);
EMGdata.trials.indeces_off{a,1}=xs(2,1);
handles.EMGdata = EMGdata;
guidata(hObject, handles);
