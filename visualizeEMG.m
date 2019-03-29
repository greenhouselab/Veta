function varargout = visualizeEMG(varargin)
%Last edit made 3/28/19 by NJ
% VISUALIZEEMG MATLAB code for visualizeEMG.fig
%      VISUALIZEEMG, by itself, creates a new VISUALIZEEMG or raises the existing
%      singleton*.
%
%      H = VISUALIZEEMG returns the handle to a new VISUALIZEEMG or the handle to
%      the existing singleton*.
%
%      VISUALIZEEMG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VISUALIZEEMG.M with the given input arguments.
%
%      VISUALIZEEMG('Property','Value',...) creates a new VISUALIZEEMG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before visualizeEMG_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to visualizeEMG_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help visualizeEMG

% Last Modified by GUIDE v2.5 28-Mar-2019 11:56:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @visualizeEMG_OpeningFcn, ...
    'gui_OutputFcn',  @visualizeEMG_OutputFcn, ...
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

%% --- Executes just before visualizeEMG is made visible.
function visualizeEMG_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to visualizeEMG (see VARARGIN)

[FileName,PathName]=uigetfile;
File= fullfile(PathName, FileName);
EMGdata=load(File);
a=1;
EMGdata.trials.corrected(:,1) = zeros;
ylims=[-2.2 2.2];

handles.display_chan=input('Enter channel of metadata to display:');


handles.ylims=ylims;
plot_figure(EMGdata,handles,a)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%update handles variables
handles.EMGdata = EMGdata;
handles.a = a;
handles.File=File;
%handles.output = hObject;

%set checkbox
if EMGdata.trials.trial_accept(a,1)==1
    set(handles.accept_checkbox,'Value',1)
else
    set(handles.accept_checkbox,'Value',0)
end

% Choose default command line output for visualizeEMG
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes visualizeEMG wait for user response (see UIRESUME)
% uiwait(handles.figure1);


%% --- Outputs from this function are returned to the command line.
function varargout = visualizeEMG_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%%
function enter_sweep_Callback(hObject, eventdata, handles)
% hObject    handle to enter_sweep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of enter_sweep as text
%        str2double(get(hObject,'String')) returns contents of enter_sweep as a double
a=str2double(get(hObject,'String'));
EMGdata=handles.EMGdata;
%handles.a=a;

%%%%%%%%%%%%%%%%%
plot_figure(EMGdata,handles,a)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%update handles variables
handles.EMGdata = EMGdata;
handles.a = a;
handles.output = hObject;
%set checkbox
if EMGdata.trials.trial_accept(a,1)==1
    set(handles.accept_checkbox,'Value',1)
else
    set(handles.accept_checkbox,'Value',0)
end
guidata(hObject, handles);


%% --- Executes during object creation, after setting all properties.
function enter_sweep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to enter_sweep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% --- Executes on button press in back_button.
function back_button_Callback(hObject, eventdata, handles)
% hObject    handle to back_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=handles.a;
EMGdata=handles.EMGdata;

%decrement
a=a-1;
%%%%%%%%%%%%%%%
plot_figure(EMGdata,handles,a)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%update handles variables
handles.EMGdata = EMGdata;
handles.a = a;
handles.output = hObject;
%set checkbox
if EMGdata.trials.trial_accept(a,1)==1
set(handles.accept_checkbox,'Value',1)
else
set(handles.accept_checkbox,'Value',0)
end

guidata(hObject, handles);


%% --- Executes on button press in forward_button.
function forward_button_Callback(hObject, eventdata, handles)
% hObject    handle to forward_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=handles.a;
EMGdata=handles.EMGdata;

%increment
a=a+1;
%handles.a=a;
%%%%%%%%%%%%%%%
plot_figure(EMGdata,handles,a)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%update handles variables
handles.EMGdata = EMGdata;
handles.a = a;
handles.output = hObject;
%set checkbox
if EMGdata.trials.trial_accept(a,1)==1
set(handles.accept_checkbox,'Value',1)
else
set(handles.accept_checkbox,'Value',0)
end

guidata(hObject, handles);


%% --- Executes on button press in accept_checkbox.
function accept_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to accept_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of accept_checkbox
EMGdata=handles.EMGdata;
a=handles.a;

%handles.accept_checkbox=accept_checkbox;
accept_checkbox=handles.accept_checkbox;
if (get(accept_checkbox,'Value') == ~get(accept_checkbox,'Max'))
    display('rejected')
    EMGdata.trials.trial_accept(a,1)=0;
end
if (get(accept_checkbox,'Value') == get(accept_checkbox,'Max'))
    display('accepted')
    EMGdata.trials.trial_accept(a,1)=1;
end

handles.EMGdata=EMGdata;
guidata(accept_checkbox, handles);

%% --- Executes on button press in save_button.
function save_button_Callback(hObject, eventdata, handles)
% hObject    handle to save_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
EMGdata=handles.EMGdata;
File=handles.File;
subject=EMGdata.subject;
parameters=EMGdata.parameters;
handles.EMGdata=EMGdata;
outfile=[File(1:end-4),'_visualized'];
trials=EMGdata.trials;
uisave({'trials','subject','parameters'},outfile);
display('saved');

%% --- Executes on button press in ch1_MEP.
function ch1_MEP_Callback(hObject, eventdata, handles)
% hObject    handle to ch1_MEP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=handles.a;
EMGdata=handles.EMGdata;
%manually select onset and offset point for bursts
x_new=ginput(1)
EMGdata.trials.ch1_MEP_onset_time(a,1)=x_new(1) - EMGdata.trials.artloc(a,1);

MEPchannel=EMGdata.trials.ch1{a,1};
MEPsearchrange = MEPchannel(x_new(1)* EMGdata.parameters.sampling_rate:(x_new(1)+EMGdata.parameters.pre_TMS_reference_window) * EMGdata.parameters.sampling_rate);
[max_MEP_value,MEP_max_sample_point] = max(MEPsearchrange);
[min_MEP_value,MEP_min_sample_point] = min(MEPsearchrange);
EMGdata.trials.ch1_MEPamplitude(a,1)=max_MEP_value-min_MEP_value;

EMGdata.trials.corrected(a,1) = EMGdata.trials.corrected(a,1)+1;
handles.EMGdata = EMGdata;
plot_figure(EMGdata,handles,a)
guidata(hObject, handles);


% --- Executes on button press in ch2_MEP.
function ch2_MEP_Callback(hObject, eventdata, handles)
% hObject    handle to ch2_MEP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=handles.a;
EMGdata=handles.EMGdata;
%manually select onset and offset point for bursts
x_new=ginput(1);
EMGdata.trials.ch2_MEP_onset_time(a,1)=x_new(1) - EMGdata.trials.artloc(a,1);
MEPchannel=EMGdata.trials.ch2{a,1};
MEPsearchrange = MEPchannel(x_new(1)* EMGdata.parameters.sampling_rate:(x_new(1)+EMGdata.parameters.pre_TMS_reference_window) * EMGdata.parameters.sampling_rate);
[max_MEP_value,MEP_max_sample_point] = max(MEPsearchrange);
[min_MEP_value,MEP_min_sample_point] = min(MEPsearchrange);
EMGdata.trials.ch2_MEPamplitude(a,1)=max_MEP_value-min_MEP_value;
EMGdata.trials.corrected(a,1) = EMGdata.trials.corrected(a,1)+1;
handles.EMGdata = EMGdata;
plot_figure(EMGdata,handles,a)
guidata(hObject, handles);


% --- Executes on button press in ch3_MEP.
function ch3_MEP_Callback(hObject, eventdata, handles)
% hObject    handle to ch3_MEP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=handles.a;
EMGdata=handles.EMGdata;
%manually select onset and offset point for bursts
x_new=ginput(1);
EMGdata.trials.ch3_MEP_onset_time(a,1)=x_new(1) - EMGdata.trials.artloc(a,1);
MEPchannel=EMGdata.trials.ch3{a,1};
MEPsearchrange = MEPchannel(x_new(1)* EMGdata.parameters.sampling_rate:(x_new(1)+EMGdata.parameters.pre_TMS_reference_window) * EMGdata.parameters.sampling_rate);
[max_MEP_value,MEP_max_sample_point] = max(MEPsearchrange);
[min_MEP_value,MEP_min_sample_point] = min(MEPsearchrange);
EMGdata.trials.ch3_MEPamplitude(a,1)=max_MEP_value-min_MEP_value;
EMGdata.trials.corrected(a,1) = EMGdata.trials.corrected(a,1)+1;
handles.EMGdata = EMGdata;
plot_figure(EMGdata,handles,a)
guidata(hObject, handles);


% --- Executes on button press in ch4_MEP.
function ch4_MEP_Callback(hObject, eventdata, handles)
% hObject    handle to ch4_MEP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=handles.a;
EMGdata=handles.EMGdata;
%manually select onset and offset point for bursts
x_new=ginput(1);
EMGdata.trials.ch4_MEP_onset_time(a,1)=x_new(1) - EMGdata.trials.artloc(a,1);
MEPchannel=EMGdata.trials.ch4{a,1};
MEPsearchrange = MEPchannel(x_new(1)* EMGdata.parameters.sampling_rate:(x_new(1)+EMGdata.parameters.pre_TMS_reference_window) * EMGdata.parameters.sampling_rate);
[max_MEP_value,MEP_max_sample_point] = max(MEPsearchrange);
[min_MEP_value,MEP_min_sample_point] = min(MEPsearchrange);
EMGdata.trials.ch4_MEPamplitude(a,1)=max_MEP_value-min_MEP_value;
EMGdata.trials.corrected(a,1) = EMGdata.trials.corrected(a,1)+1;
handles.EMGdata = EMGdata;
plot_figure(EMGdata,handles,a)
guidata(hObject, handles);

%% --- Executes on button press in ch1_burst.
function ch1_burst_Callback(hObject, eventdata, handles)
% hObject    handle to ch1_burst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=handles.a;
EMGdata=handles.EMGdata;
%manually select onset and offset point for bursts
x_new=ginput(2);
EMGdata.trials.ch1_EMGburst_onset(a,1)=x_new(1,1);
EMGdata.trials.ch1_EMGburst_offset(a,1)=x_new(2,1);
EMGdata.trials.ch1_EMG_RT(a,1) = EMGdata.trials.ch1_EMGburst_onset(a,1) - EMGdata.trials.stim_onset(a,1);
EMGdata.trials.corrected(a,1) = EMGdata.trials.corrected(a,1)+1;
handles.EMGdata = EMGdata;
plot_figure(EMGdata,handles,a)
guidata(hObject, handles);


%% --- Executes on button press in ch2_burst.
function ch2_burst_Callback(hObject, eventdata, handles)
% hObject    handle to ch2_burst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=handles.a;
EMGdata=handles.EMGdata;
%manually select onset and offset point for bursts
x_new=ginput(2);
EMGdata.trials.ch2_EMGburst_onset(a,1)=x_new(1,1);
EMGdata.trials.ch2_EMGburst_offset(a,1)=x_new(2,1);
EMGdata.trials.ch2_EMG_RT(a,1) = EMGdata.trials.ch2_EMGburst_onset(a,1) - EMGdata.trials.stim_onset(a,1);
EMGdata.trials.corrected(a,1) = EMGdata.trials.corrected(a,1)+1;
handles.EMGdata = EMGdata;
plot_figure(EMGdata,handles,a)
guidata(hObject, handles);


%% --- Executes on button press in ch3_burst.
function ch3_burst_Callback(hObject, eventdata, handles)
% hObject    handle to ch3_burst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=handles.a;
EMGdata=handles.EMGdata;
%manually select onset and offset point for bursts
x_new=ginput(2);
EMGdata.trials.ch3_EMGburst_onset(a,1)=x_new(1,1);
EMGdata.trials.ch3_EMGburst_offset(a,1)=x_new(2,1);
EMGdata.trials.ch3_EMG_RT(a,1) = EMGdata.trials.ch3_EMGburst_onset(a,1) - EMGdata.trials.stim_onset(a,1);
EMGdata.trials.corrected(a,1) = EMGdata.trials.corrected(a,1)+1;
handles.EMGdata = EMGdata;
plot_figure(EMGdata,handles,a)
guidata(hObject, handles);


%% --- Executes on button press in ch4_burst.
function ch4_burst_Callback(hObject, eventdata, handles)
% hObject    handle to ch4_burst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=handles.a;
EMGdata=handles.EMGdata;
%manually select onset and offset point for bursts
x_new=ginput(2);
EMGdata.trials.ch4_EMGburst_onset(a,1)=x_new(1,1);
EMGdata.trials.ch4_EMGburst_offset(a,1)=x_new(2,1);
EMGdata.trials.ch4_EMG_RT(a,1) = EMGdata.trials.ch4_EMGburst_onset(a,1) - EMGdata.trials.stim_onset(a,1);
EMGdata.trials.corrected(a,1) = EMGdata.trials.corrected(a,1)+1;
handles.EMGdata = EMGdata;
plot_figure(EMGdata,handles,a)
guidata(hObject, handles);

%%
function plot_figure(EMGdata,handles,a)
ylims=handles.ylims;

%this could be improved probably
if ~EMGdata.parameters.EMG %no EMG, hide all burst brush buttons
    for n = 1:4 % 4 is number of plots
            set(handles.(['ch', num2str(n),'_burst']),'visible','off');
    end
else %if EMG, hide non burst channels [IAN: WHY NOT JUST THIS?]
    for n = 1:4
        if ~ismember(n,EMGdata.parameters.EMG_burst_channels)
            set(handles.(['ch', num2str(n),'_burst']),'visible','off');
        end
    end
end

if ~EMGdata.parameters.TMS %no TMS, hide all MEP brush buttons
    for n = 1:4 % 4 is number of plots
            set(handles.(['ch', num2str(n),'_MEP']),'visible','off');
    end
else %if TMS, hide non burst channels [IAN: WHY NOT JUST THIS?]
    for n = 1:4
        if ~ismember(n,EMGdata.parameters.MEPchan_index)
            set(handles.(['ch', num2str(n),'_MEP']),'visible','off');
        end
    end
end

for n = 1:4
    if sum(ismember(EMGdata.trials.Properties.VariableNames,['ch' num2str(n) '_EMG_RT'])) && EMGdata.trials.(['ch' num2str(n) '_EMG_RT'])(a,1)
       EMG_RT = EMGdata.trials.(['ch' num2str(n) '_EMG_RT'])(a,1);
    end
    if ~exist('EMG_RT')
        EMG_RT = 0;
    end
end

if any(strcmp('photodiode', EMGdata.trials.Properties.VariableNames))
    photodiode=1;
    subplot_number=EMGdata.parameters.num_channels+1;
else
    subplot_number=EMGdata.parameters.num_channels;
    photodiode=0;
end

for n=1:subplot_number
    subplot(subplot_number,1,n)
    if photodiode && n < subplot_number || ~photodiode
        y=EMGdata.trials.(['ch',num2str(n)]){a,1};
    else
        y=EMGdata.trials.photodiode{a,1};
    end
    x = linspace(0,(length(y)/EMGdata.parameters.sampling_rate),length(y));%y can eventually be samplingrate*sweepduration
    p = plot(x,y,'k');   
    
    if n==1
        if EMGdata.parameters.EMG && ~EMGdata.parameters.TMS
            title_text = sprintf('Sweep #: %d\n EMG RT (s): %0.3f', ...
                a, ... 
                EMG_RT);
        else            
            title_text = sprintf('Sweep #: %d\n RMS: %0.3f\n MEP onset (s): %0.3f\n MEP amplitude (mV): %0.3f\n EMG RT (s): %0.3f', ...
                a, ... 
                EMGdata.trials.(['ch',num2str(handles.display_chan),'_RMS_preMEP'])(a,1), ...
                EMGdata.trials.(['ch',num2str(handles.display_chan),'_MEP_onset_time'])(a,1), ...
                EMGdata.trials.(['ch',num2str(handles.display_chan),'_MEPamplitude'])(a,1), ...
                EMG_RT);
        end
        title(title_text,'FontSize',14, 'FontName', 'Arial', 'FontWeight', 'normal');%make font bigger
    end
    %add y label
    if ~photodiode || n<subplot_number
        ylabel({['ch ',num2str(n)],'mV'},'FontSize',14, 'FontName', 'Arial', 'FontWeight', 'bold');%add channel label
    elseif photodiode && n==subplot_number
                ylabel('photodiode','FontSize',14, 'FontName', 'Arial', 'FontWeight', 'bold');
    end
    %add x label
    if n==subplot_number
        xlabel('Time (s)', 'FontSize',14, 'FontName', 'Arial', 'FontWeight', 'bold');
    end

    ylim(handles.ylims);

    if EMGdata.parameters.TMS % if TMS was used
        %add MEP line %%%insert blah here parameters.MEPchan_index
        %EMGdata.trials.(['ch', num2str(n),'_MEP_onset_time'])(a,1)
        if EMGdata.trials.artloc(a,1) && ismember(n,EMGdata.parameters.MEPchan_index)
            line([EMGdata.trials.(['ch', num2str(n),'_MEP_onset_time'])(a,1)+EMGdata.trials.artloc(a,1) EMGdata.trials.(['ch', num2str(n),'_MEP_onset_time'])(a,1)+EMGdata.trials.artloc(a,1)], ylims ,'Color',[.2 .4 1],'Marker','o')
        end
        %add TMS artefact
        if EMGdata.trials.artloc(a,1) && EMGdata.parameters.artchan_index==n
            line([EMGdata.trials.artloc(a,1) EMGdata.trials.artloc(a,1)], ylims ,'Color','red','Marker','o')
        end
    end
    %add EMG burst lines
    if EMGdata.parameters.EMG && ismember(n,EMGdata.parameters.EMG_burst_channels)
        burst_on=EMGdata.trials.(['ch', num2str(n), '_EMGburst_onset'])(a,1);
        burst_off=EMGdata.trials.(['ch', num2str(n), '_EMGburst_offset'])(a,1);
        patch([burst_on burst_on burst_off burst_off],[ylims(1) ylims(2) ylims(2) ylims(1)],[.7 .9 1]);
        set(gca,'children',flipud(get(gca,'children')))%plots patch behind trace
    end
    
    %add diode
    if photodiode && n==subplot_number && EMGdata.trials.stim_onset(a,1)
        line([EMGdata.trials.stim_onset(a,1) EMGdata.trials.stim_onset(a,1)], ylims ,'Color','magenta','Marker','o')
    end  
end


