function varargout = visualizeEMG(varargin)
% Authors: Nick Jackson (njackson@uoregon.edu) & Ian Greenhouse
%  (img@uoregon.edu)
% 
% GUI for the visualization and interactive editing of EMG data.
%
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

% Last Modified by GUIDE v2.5 05-Apr-2019 13:15:58

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

if numel(varargin)
    filename = varargin{1};
    File = fullfile(pwd, filename);
else
    [FileName,PathName]=uigetfile;
    File= fullfile(PathName, FileName);
end

EMGdata=load(File);
a=1;

if ~sum(ismember(EMGdata.trials.Properties.VariableNames,'edited'))
    EMGdata.trials.edited(:,1) = zeros;
    handles.num_start_edits = 0;
else
    handles.num_start_edits = sum(EMGdata.trials.edited);
end


% this is where to set the y-axis limits for channel plots
ylims = [-1 1; -1 1; -1 1; -1 1];

handles.ylims=ylims;
plot_figure(EMGdata,handles,a)

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

% prompt to really close without saving
% edits = struct('num_start_edits', handles.num_start_edits, 'num_edits', handles.num_edits);
% handles.figure1.UserData = edits;
set(handles.figure1, 'CloseRequestFcn', @closeGUI);

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

function closeGUI(hObject, eventdata, handles)
%      handles.num_edits = sum(handles.EMGdata.trials.edited);
%      if handles.num_start_edits < handles.num_edits
      selection = questdlg('You may have unsaved edits. Are you sure you want to close?', ...
      'Warning', ...
      'Yes','No','Yes');
         switch selection
         case 'Yes'
           delete(gcf)
         case 'No'
           return
         end
%      end

%% PLOT FIGURE
function plot_figure(EMGdata,handles,a)
ylims=handles.ylims;

% buttons to display
for n = 1:4
    set(handles.(['ch', num2str(n),'_burst']),'visible','off');
    set(handles.(['ch', num2str(n),'_clearEMG']),'visible','off');
    set(handles.(['ch', num2str(n),'_TMS_art']),'visible','off');
    set(handles.(['ch', num2str(n),'_clearTMSart']),'visible','off');
    set(handles.(['ch', num2str(n),'_MEP']),'visible','off');
    set(handles.(['ch', num2str(n),'_clearMEP']),'visible','off');
    set(handles.(['ch', num2str(n),'_CSP']),'visible','off');
    set(handles.(['ch', num2str(n),'_clearCSP']),'visible','off');    

    if EMGdata.parameters.EMG & ismember(n,EMGdata.parameters.EMG_burst_channels)
        set(handles.(['ch', num2str(n),'_burst']),'visible','on');
        set(handles.(['ch', num2str(n),'_clearEMG']),'visible','on');
    end
    if EMGdata.parameters.MEP & ismember(n,EMGdata.parameters.MEP_channels)
        set(handles.(['ch', num2str(n),'_MEP']),'visible','on');
        set(handles.(['ch', num2str(n),'_clearMEP']),'visible','on');
    end
    if EMGdata.parameters.artchan_index & ismember(n,EMGdata.parameters.artchan_index)
        set(handles.(['ch', num2str(n),'_TMS_art']),'visible','on');
        set(handles.(['ch', num2str(n),'_clearTMSart']),'visible','on');
    end
    if EMGdata.parameters.CSP & ismember(n,EMGdata.parameters.CSP_channels)
        set(handles.(['ch', num2str(n),'_CSP']),'visible','on');
        set(handles.(['ch', num2str(n),'_clearCSP']),'visible','on');
    end

end

% display photodiode or not
if any(strcmp('photodiode', EMGdata.trials.Properties.VariableNames))
    photodiode=1;
    subplot_number=EMGdata.parameters.num_channels+1;
else
    subplot_number=EMGdata.parameters.num_channels;
    photodiode=0;
end

% clear annotations
delete(findall(gcf,'type','annotation'))

% set colors for markers and buttons
MEP_color = [1 1 .5];
TMS_color = [1 0 0];
EMG_color = [.9 .7 1];
CSP_color = [.7 1 .5];
diode_color = [0 1 1];

for n=1:subplot_number
    subplot_handle = subplot(subplot_number,1,n);
    if photodiode && n < subplot_number || ~photodiode
        y=EMGdata.trials.(['ch',num2str(n)]){a,1};
    else
        y=EMGdata.trials.photodiode{a,1};
    end
    x = linspace(0,(length(y)/EMGdata.parameters.sampling_rate),length(y));%y can eventually be samplingrate*sweepduration
    p = plot(x,y,'k');
    
    % add y label
    if ~photodiode || n<subplot_number
        ylabel(['ch ',num2str(n),' (mV)'],'FontSize',14, 'FontName', 'Arial', 'FontWeight', 'bold');%add channel label
    elseif photodiode && n==subplot_number
        ylabel('photodiode','FontSize',14, 'FontName', 'Arial', 'FontWeight', 'bold');
    end
    
    %add x label
    if n==subplot_number
        xlabel('Time (s)', 'FontSize',14, 'FontName', 'Arial', 'FontWeight', 'bold');
    end
    
    % y limits
    ylim(handles.ylims(n,:));
    
    if EMGdata.parameters.MEP % if TMS was used        
        % add MEP line
        if ismember(n,EMGdata.parameters.MEP_channels) && EMGdata.trials.(['ch', num2str(n),'_MEP_time'])(a,1)
            MEP_on = EMGdata.trials.(['ch', num2str(n),'_MEP_time'])(a,1);
            MEP_off = EMGdata.trials.artloc(a,1) + EMGdata.trials.(['ch', num2str(n),'_MEP_offset'])(a,1);
            patch([MEP_on MEP_on MEP_off MEP_off], [ylims(n, 1) ylims(n, 2) ylims(n, 2) ylims(n, 1)], MEP_color);
            alpha(.7);
            if (EMGdata.parameters.EMG && ~ismember(n,EMGdata.parameters.EMG_burst_channels)) | ((EMGdata.parameters.CSP && ~ismember(n,EMGdata.parameters.CSP_channels)))
                set(gca,'children',flipud(get(gca,'children')))%plots patch behind trace
            elseif ~EMGdata.parameters.EMG & ~EMGdata.parameters.CSP
                set(gca,'children',flipud(get(gca,'children')))%plots patch behind trace
            end                     
        end
    end
    
    %add CSP patch
    if EMGdata.parameters.CSP && ismember(n,EMGdata.parameters.CSP_channels)
        CSP_on=EMGdata.trials.(['ch', num2str(n), '_CSP_onset'])(a,1);
        CSP_off=EMGdata.trials.(['ch', num2str(n), '_CSP_offset'])(a,1);
        patch([CSP_on CSP_on CSP_off CSP_off],[ylims(n, 1) ylims(n, 2) ylims(n, 2) ylims(n, 1)],CSP_color);
        alpha(.7);
        if (EMGdata.parameters.EMG && ~ismember(n,EMGdata.parameters.EMG_burst_channels)) | ((EMGdata.parameters.MEP && ismember(n,EMGdata.parameters.MEP_channels)))
            set(gca,'children',flipud(get(gca,'children')))%plots patch behind trace
        elseif ~EMGdata.parameters.EMG & ~EMGdata.parameters.MEP
            set(gca,'children',flipud(get(gca,'children')))%plots patch behind trace
        end                
    end

    %add TMS artefact
    if (EMGdata.parameters.CSP | EMGdata.parameters.MEP) && EMGdata.parameters.artchan_index==n
        if EMGdata.trials.artloc(a,1)
            line([EMGdata.trials.artloc(a,1) EMGdata.trials.artloc(a,1)], ylims(n, :) ,'Color',TMS_color,'Marker','o')
        end
    end        
    
    %add EMG burst patch
    if EMGdata.parameters.EMG && ismember(n,EMGdata.parameters.EMG_burst_channels)
        burst_on=EMGdata.trials.(['ch', num2str(n), '_EMGburst_onset'])(a,1);
        burst_off=EMGdata.trials.(['ch', num2str(n), '_EMGburst_offset'])(a,1);
        patch([burst_on burst_on burst_off burst_off],[ylims(n, 1) ylims(n, 2) ylims(n, 2) ylims(n, 1)],EMG_color);
        alpha(.7);
        set(gca,'children',flipud(get(gca,'children')))%plots patch behind trace
    end    

    %add diode
    if photodiode && n==subplot_number && EMGdata.trials.stim_onset(a,1)
        line([EMGdata.trials.stim_onset(a,1) EMGdata.trials.stim_onset(a,1)], ylims(n, :) ,'Color',diode_color,'Marker','o')
    end
    
    % subplot position
    subplot_position = subplot_handle.Position;
    subplot_right_edge = subplot_position(1)+subplot_position(3);
    subplot_top = subplot_position(2)+subplot_position(4);
    
    % position and format buttons
    button_width = .04;
    button_height = .04;
    
    if (EMGdata.parameters.MEP | EMGdata.parameters.CSP) && ismember(n,EMGdata.parameters.artchan_index)
        set(handles.(['ch', num2str(n),'_TMS_art']),'Position', [subplot_position(1)-(3*button_width) subplot_top-button_height button_width button_height]);
        set(handles.(['ch', num2str(n),'_TMS_art']),'BackgroundColor', 'red');
        set(handles.(['ch', num2str(n),'_TMS_art']),'FontWeight', 'bold');
        
        set(handles.(['ch', num2str(n),'_clearTMSart']),'Position', [subplot_position(1)-(2*button_width) subplot_top-button_height button_width button_height]);
        set(handles.(['ch', num2str(n),'_clearTMSart']),'BackgroundColor', 'red');
        set(handles.(['ch', num2str(n),'_clearTMSart']),'FontWeight', 'bold');
    end
    
    if EMGdata.parameters.MEP && ismember(n,EMGdata.parameters.MEP_channels)
        set(handles.(['ch', num2str(n),'_MEP']),'Position', [subplot_position(1)-(3*button_width) subplot_top-(2*button_height) button_width button_height]);
        set(handles.(['ch', num2str(n),'_MEP']),'BackgroundColor', MEP_color);
        set(handles.(['ch', num2str(n),'_MEP']),'FontWeight', 'bold');
        
        set(handles.(['ch', num2str(n),'_clearMEP']),'Position', [subplot_position(1)-(2*button_width) subplot_top-(2*button_height) button_width button_height]);
        set(handles.(['ch', num2str(n),'_clearMEP']),'BackgroundColor', MEP_color);
        set(handles.(['ch', num2str(n),'_clearMEP']),'FontWeight', 'bold');
    end
    
    if EMGdata.parameters.EMG && ismember(n,EMGdata.parameters.EMG_burst_channels)
        set(handles.(['ch', num2str(n),'_burst']),'Position', [subplot_position(1)-(3*button_width) subplot_top-(3*button_height)  button_width button_height]);
        set(handles.(['ch', num2str(n),'_burst']),'BackgroundColor', EMG_color);
        set(handles.(['ch', num2str(n),'_burst']),'FontWeight', 'bold');
        
        set(handles.(['ch', num2str(n),'_clearEMG']),'Position', [subplot_position(1)-(2*button_width) subplot_top-(3*button_height) button_width button_height]);
        set(handles.(['ch', num2str(n),'_clearEMG']),'BackgroundColor', EMG_color);
        set(handles.(['ch', num2str(n),'_clearEMG']),'FontWeight', 'bold');
    end
    
    if EMGdata.parameters.CSP && ismember(n,EMGdata.parameters.CSP_channels)
        set(handles.(['ch', num2str(n),'_CSP']),'Position', [subplot_position(1)-(3*button_width) subplot_top-(4*button_height)  button_width button_height]);
        set(handles.(['ch', num2str(n),'_CSP']),'BackgroundColor', CSP_color);
        set(handles.(['ch', num2str(n),'_CSP']),'FontWeight', 'bold');
        
        set(handles.(['ch', num2str(n),'_clearCSP']),'Position', [subplot_position(1)-(2*button_width) subplot_top-(4*button_height) button_width button_height]);
        set(handles.(['ch', num2str(n),'_clearCSP']),'BackgroundColor', CSP_color);
        set(handles.(['ch', num2str(n),'_clearCSP']),'FontWeight', 'bold');
    end
    
    % add text to plots    
    title_text = sprintf('Sweep #: %d', a);
    if n==1
        th = annotation('textbox', [(subplot_position(1)+subplot_position(3))/2 subplot_top+.02 .09 .02], 'String', title_text,'FontSize',18, 'FontName', 'Arial');
        th.LineStyle = 'none';
    end
    
    if sum(ismember(EMGdata.trials.Properties.VariableNames,['ch' num2str(n) '_EMG_RT']))
        subplot_text = sprintf(' EMG RT (s): %0.3f\n EMG duration (s): %0.3f\n EMG burst area (mV/s): %0.3f', ...
            EMGdata.trials.(['ch' num2str(n) '_EMG_RT'])(a,1), ...
            EMGdata.trials.(['ch' num2str(n) '_EMGburst_offset'])(a,1) - EMGdata.trials.(['ch' num2str(n) '_EMGburst_onset'])(a,1), ...
            EMGdata.trials.(['ch' num2str(n) '_EMGburst_area'])(a,1));
        
        th = annotation('textbox', [subplot_right_edge subplot_top-.01 .1 .02], 'String', subplot_text);
        th.LineStyle = 'none';
    end
    
    if sum(ismember(EMGdata.trials.Properties.VariableNames,['ch' num2str(n) '_MEP_latency']))
        subplot_text = sprintf(' preTMS RMS: %0.3f\n MEP latency (s): %0.3f\n MEP amp. (mV): %0.3f\n MEP area (mV/s): %0.3f\n MEP duration (s): %0.3f', ...
            EMGdata.trials.(['ch',num2str(n),'_RMS_preMEP'])(a,1), ...
            EMGdata.trials.(['ch',num2str(n),'_MEP_latency'])(a,1), ...
            EMGdata.trials.(['ch',num2str(n),'_MEP_amplitude'])(a,1), ...
            EMGdata.trials.(['ch',num2str(n),'_MEP_area'])(a,1), ...
            EMGdata.trials.(['ch',num2str(n),'_MEP_duration'])(a,1));
        
        th = annotation('textbox', [subplot_right_edge subplot_top-.15 .1 .1], 'String', subplot_text);
        th.LineStyle = 'none';        
    end
    
    if sum(ismember(EMGdata.trials.Properties.VariableNames,['ch' num2str(n) '_CSP_onset']))
        subplot_text = sprintf(' CSP duration: %0.3f', ...
            EMGdata.trials.(['ch' num2str(n) '_CSP_offset'])(a,1) - EMGdata.trials.(['ch' num2str(n) '_CSP_onset'])(a,1));
        
        th = annotation('textbox', [subplot_right_edge subplot_top-.25 .1 .1], 'String', subplot_text);
        th.LineStyle = 'none';        
    end
    
end

%%
%%%%%%%%%%%%%%%%%%%%%%%%%% GUI ELEMENTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function enter_sweep_Callback(hObject, eventdata, handles)
% hObject    handle to enter_sweep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of enter_sweep as text
%        str2double(get(hObject,'String')) returns contents of enter_sweep as a double
a = str2double(get(hObject,'String'));
EMGdata = handles.EMGdata;

plot_figure(EMGdata,handles,a)

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
if a>1
    a=a-1;
end
plot_figure(EMGdata,handles,a)

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
if a < height(EMGdata.trials)
    a=a+1;
end
plot_figure(EMGdata,handles,a)

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
handles.num_start_edits = sum(EMGdata.trials.edited);
display('saved');


%% --- Executes on button press in ch1_TMS_art.
function ch1_TMS_art_Callback(hObject, eventdata, handles)
% hObject    handle to ch1_TMS_art (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a = handles.a;
EMGdata = handles.EMGdata;
% manually select TMS artefact point
x_new = ginput(1);
EMGdata.trials.artloc(a,1) = x_new(1);
EMGdata.trials.edited(a,1) = EMGdata.trials.edited(a,1)+1;
handles.EMGdata = EMGdata;
plot_figure(EMGdata,handles,a)
guidata(hObject, handles);

%% --- Executes on button press in ch2_TMS_art.
function ch2_TMS_art_Callback(hObject, eventdata, handles)
% hObject    handle to ch2_TMS_art (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a = handles.a;
EMGdata = handles.EMGdata;
% manually select TMS artefact point
x_new = ginput(1);
EMGdata.trials.artloc(a,1) = x_new(1);
EMGdata.trials.edited(a,1) = EMGdata.trials.edited(a,1)+1;
handles.EMGdata = EMGdata;
plot_figure(EMGdata,handles,a)
guidata(hObject, handles);

%% --- Executes on button press in ch3_TMS_art.
function ch3_TMS_art_Callback(hObject, eventdata, handles)
% hObject    handle to ch3_TMS_art (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a = handles.a;
EMGdata = handles.EMGdata;
% manually select TMS artefact point
x_new = ginput(1);
EMGdata.trials.artloc(a,1) = x_new(1);
EMGdata.trials.edited(a,1) = EMGdata.trials.edited(a,1)+1;
handles.EMGdata = EMGdata;
plot_figure(EMGdata,handles,a)
guidata(hObject, handles);

%% --- Executes on button press in ch4_TMS_art.
function ch4_TMS_art_Callback(hObject, eventdata, handles)
% hObject    handle to ch4_TMS_art (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a = handles.a;
EMGdata = handles.EMGdata;
% manually select TMS artefact point
x_new = ginput(1);
EMGdata.trials.artloc(a,1) = x_new(1);
EMGdata.trials.edited(a,1) = EMGdata.trials.edited(a,1)+1;
handles.EMGdata = EMGdata;
plot_figure(EMGdata,handles,a)
guidata(hObject, handles);

%% --- Executes on button press in ch1_clearTMSart.
function ch1_clearTMSart_Callback(hObject, eventdata, handles)
% hObject    handle to ch1_clearTMSart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=handles.a;
EMGdata=handles.EMGdata;

EMGdata.trials.artloc(a,1)=0;
EMGdata.trials.edited(a,1) = EMGdata.trials.edited(a,1)+1;

handles.EMGdata = EMGdata;
plot_figure(EMGdata,handles,a);
guidata(hObject, handles);


%% --- Executes on button press in ch2_clearTMSart.
function ch2_clearTMSart_Callback(hObject, eventdata, handles)
% hObject    handle to ch2_clearTMSart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=handles.a;
EMGdata=handles.EMGdata;

EMGdata.trials.artloc(a,1)=0;
EMGdata.trials.edited(a,1) = EMGdata.trials.edited(a,1)+1;

handles.EMGdata = EMGdata;
plot_figure(EMGdata,handles,a);
guidata(hObject, handles);

%% --- Executes on button press in ch3_clearTMSart.
function ch3_clearTMSart_Callback(hObject, eventdata, handles)
% hObject    handle to ch3_clearTMSart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=handles.a;
EMGdata=handles.EMGdata;

EMGdata.trials.artloc(a,1)=0;
EMGdata.trials.edited(a,1) = EMGdata.trials.edited(a,1)+1;

handles.EMGdata = EMGdata;
plot_figure(EMGdata,handles,a);
guidata(hObject, handles);

%% --- Executes on button press in ch4_clearTMSart.
function ch4_clearTMSart_Callback(hObject, eventdata, handles)
% hObject    handle to ch4_clearTMSart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=handles.a;
EMGdata=handles.EMGdata;

EMGdata.trials.artloc(a,1)=0;
EMGdata.trials.edited(a,1) = EMGdata.trials.edited(a,1)+1;

handles.EMGdata = EMGdata;
plot_figure(EMGdata,handles,a);
guidata(hObject, handles);

%% --- Executes on button press in ch1_MEP.
function ch1_MEP_Callback(hObject, eventdata, handles)
% hObject    handle to ch1_MEP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a = handles.a;
EMGdata = handles.EMGdata;
% manually select onset point for MEP
x_new = ginput(2);
EMGdata.trials.ch1_MEP_time(a,1) = x_new(1);
EMGdata.trials.ch1_MEP_latency(a,1) = x_new(1) - EMGdata.trials.artloc(a,1);
EMGdata.trials.ch1_MEP_offset(a,1) = x_new(2) - EMGdata.trials.artloc(a,1);

MEPchannel=EMGdata.trials.ch1{a,1};
MEPsearchrange = MEPchannel(round(x_new(1) * EMGdata.parameters.sampling_rate):round(x_new(2) * EMGdata.parameters.sampling_rate));
[max_MEP_value,MEP_max_sample_point] = max(MEPsearchrange);
[min_MEP_value,MEP_min_sample_point] = min(MEPsearchrange);
EMGdata.trials.ch1_MEP_amplitude(a,1)=max_MEP_value-min_MEP_value;
EMGdata.trials.ch1_MEP_area(a,1) = sum(abs(MEPsearchrange)) / (round(x_new(2) * EMGdata.parameters.sampling_rate) - round(x_new(1) * EMGdata.parameters.sampling_rate));
EMGdata.trials.ch1_MEP_duration(a,1) = EMGdata.trials.ch1_MEP_offset(a,1)-EMGdata.trials.ch1_MEP_latency(a,1);

EMGdata.trials.edited(a,1) = EMGdata.trials.edited(a,1)+1;
handles.EMGdata = EMGdata;
plot_figure(EMGdata,handles,a)
guidata(hObject, handles);


%% --- Executes on button press in ch2_MEP.
function ch2_MEP_Callback(hObject, eventdata, handles)
% hObject    handle to ch2_MEP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a = handles.a;
EMGdata = handles.EMGdata;

% manually select onset point for MEP
x_new = ginput(2);
EMGdata.trials.ch2_MEP_time(a,1) = x_new(1);
EMGdata.trials.ch2_MEP_latency(a,1) = x_new(1) - EMGdata.trials.artloc(a,1);
EMGdata.trials.ch2_MEP_offset(a,1) = x_new(2) - EMGdata.trials.artloc(a,1);

MEPchannel = EMGdata.trials.ch2{a,1};
MEPsearchrange = MEPchannel(round(x_new(1) * EMGdata.parameters.sampling_rate):round(x_new(2) * EMGdata.parameters.sampling_rate));
[max_MEP_value,MEP_max_sample_point] = max(MEPsearchrange);
[min_MEP_value,MEP_min_sample_point] = min(MEPsearchrange);
EMGdata.trials.ch2_MEP_amplitude(a,1)=max_MEP_value-min_MEP_value;
EMGdata.trials.ch2_MEP_area(a,1) = sum(abs(MEPsearchrange)) / (round(x_new(2) * EMGdata.parameters.sampling_rate) - round(x_new(1) * EMGdata.parameters.sampling_rate));
EMGdata.trials.ch2_MEP_duration(a,1) = EMGdata.trials.ch2_MEP_offset(a,1)-EMGdata.trials.ch2_MEP_latency(a,1);

EMGdata.trials.edited(a,1) = EMGdata.trials.edited(a,1)+1;
handles.EMGdata = EMGdata;
plot_figure(EMGdata,handles,a)
guidata(hObject, handles);

%% --- Executes on button press in ch3_MEP.
function ch3_MEP_Callback(hObject, eventdata, handles)
% hObject    handle to ch3_MEP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=handles.a;
EMGdata=handles.EMGdata;

% manually select onset point for MEP
x_new = ginput(2);
EMGdata.trials.ch3_MEP_time(a,1) = x_new(1);
EMGdata.trials.ch3_MEP_latency(a,1) = x_new(1) - EMGdata.trials.artloc(a,1);
EMGdata.trials.ch3_MEP_offset(a,1) = x_new(2) - EMGdata.trials.artloc(a,1);

MEPchannel=EMGdata.trials.ch3{a,1};
MEPsearchrange = MEPchannel(round(x_new(1) * EMGdata.parameters.sampling_rate):round(x_new(2) * EMGdata.parameters.sampling_rate));
[max_MEP_value,MEP_max_sample_point] = max(MEPsearchrange);
[min_MEP_value,MEP_min_sample_point] = min(MEPsearchrange);
EMGdata.trials.ch3_MEP_amplitude(a,1)=max_MEP_value-min_MEP_value;
EMGdata.trials.ch3_MEP_area(a,1) = sum(abs(MEPsearchrange)) / (round(x_new(2) * EMGdata.parameters.sampling_rate) - round(x_new(1) * EMGdata.parameters.sampling_rate));
EMGdata.trials.ch3_MEP_duration(a,1) = EMGdata.trials.ch3_MEP_offset(a,1)-EMGdata.trials.ch3_MEP_latency(a,1);

EMGdata.trials.edited(a,1) = EMGdata.trials.edited(a,1)+1;
handles.EMGdata = EMGdata;
plot_figure(EMGdata,handles,a)
guidata(hObject, handles);

%% --- Executes on button press in ch4_MEP.
function ch4_MEP_Callback(hObject, eventdata, handles)
% hObject    handle to ch4_MEP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=handles.a;
EMGdata=handles.EMGdata;

% manually select onset point for MEP
x_new = ginput(2);
EMGdata.trials.ch4_MEP_time(a,1) = x_new(1);
EMGdata.trials.ch4_MEP_latency(a,1) = x_new(1) - EMGdata.trials.artloc(a,1);
EMGdata.trials.ch4_MEP_offset(a,1) = x_new(2) - EMGdata.trials.artloc(a,1);

MEPchannel=EMGdata.trials.ch4{a,1};
MEPsearchrange = MEPchannel(round(x_new(1) * EMGdata.parameters.sampling_rate):round(x_new(2) * EMGdata.parameters.sampling_rate));
[max_MEP_value,MEP_max_sample_point] = max(MEPsearchrange);
[min_MEP_value,MEP_min_sample_point] = min(MEPsearchrange);
EMGdata.trials.ch4_MEP_amplitude(a,1)=max_MEP_value-min_MEP_value;
EMGdata.trials.ch4_MEP_area(a,1) = sum(abs(MEPsearchrange)) / (round(x_new(2) * EMGdata.parameters.sampling_rate) - round(x_new(1) * EMGdata.parameters.sampling_rate));
EMGdata.trials.ch4_MEP_duration(a,1) = EMGdata.trials.ch4_MEP_offset(a,1)-EMGdata.trials.ch4_MEP_latency(a,1);

EMGdata.trials.edited(a,1) = EMGdata.trials.edited(a,1)+1;
handles.EMGdata = EMGdata;
plot_figure(EMGdata,handles,a)
guidata(hObject, handles);

%% --- Executes on button press in ch1_clearMEP.
function ch1_clearMEP_Callback(hObject, eventdata, handles)
% hObject    handle to ch1_clearMEP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=handles.a;
EMGdata=handles.EMGdata;

EMGdata.trials.ch1_MEP_latency(a,1)=0;
EMGdata.trials.ch1_MEP_time(a,1)=0;
EMGdata.trials.ch1_MEP_amplitude(a,1)=0;
EMGdata.trials.ch1_RMS_preMEP(a,1)=0;
EMGdata.trials.edited(a,1) = EMGdata.trials.edited(a,1)+1;

handles.EMGdata = EMGdata;
plot_figure(EMGdata,handles,a);
guidata(hObject, handles);

%% --- Executes on button press in ch2_clearMEP.
function ch2_clearMEP_Callback(hObject, eventdata, handles)
% hObject    handle to ch2_clearMEP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=handles.a;
EMGdata=handles.EMGdata;

EMGdata.trials.ch2_MEP_latency(a,1)=0;
EMGdata.trials.ch2_MEP_time(a,1)=0;
EMGdata.trials.ch2_MEP_amplitude(a,1)=0;
EMGdata.trials.ch2_RMS_preMEP(a,1)=0;
EMGdata.trials.edited(a,1) = EMGdata.trials.edited(a,1)+1;

handles.EMGdata = EMGdata;
plot_figure(EMGdata,handles,a);
guidata(hObject, handles);

%% --- Executes on button press in ch3_clearMEP.
function ch3_clearMEP_Callback(hObject, eventdata, handles)
% hObject    handle to ch3_clearMEP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=handles.a;
EMGdata=handles.EMGdata;

EMGdata.trials.ch3_MEP_latency(a,1)=0;
EMGdata.trials.ch3_MEP_time(a,1)=0;
EMGdata.trials.ch3_MEP_amplitude(a,1)=0;
EMGdata.trials.ch3_RMS_preMEP(a,1)=0;
EMGdata.trials.edited(a,1) = EMGdata.trials.edited(a,1)+1;

handles.EMGdata = EMGdata;
plot_figure(EMGdata,handles,a);
guidata(hObject, handles);

%% --- Executes on button press in ch4_clearMEP.
function ch4_clearMEP_Callback(hObject, eventdata, handles)
% hObject    handle to ch4_clearMEP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=handles.a;
EMGdata=handles.EMGdata;

EMGdata.trials.ch4_MEP_latency(a,1)=0;
EMGdata.trials.ch4_MEP_time(a,1)=0;
EMGdata.trials.ch4_MEP_amplitude(a,1)=0;
EMGdata.trials.ch4_RMS_preMEP(a,1)=0;
EMGdata.trials.edited(a,1) = EMGdata.trials.edited(a,1)+1;

handles.EMGdata = EMGdata;
plot_figure(EMGdata,handles,a);
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

EMGchannel=EMGdata.trials.ch1{a,1};
EMGrange = EMGchannel(round(x_new(1) * EMGdata.parameters.sampling_rate):round(x_new(2) * EMGdata.parameters.sampling_rate));

EMGdata.trials.ch1_EMGburst_onset(a,1)=x_new(1,1);
EMGdata.trials.ch1_EMGburst_offset(a,1)=x_new(2,1);
EMGdata.trials.ch1_EMG_RT(a,1) = EMGdata.trials.ch1_EMGburst_onset(a,1) - EMGdata.trials.stim_onset(a,1);
EMGdata.trials.ch1_EMGburst_area(a,1) = sum(abs(EMGrange)) / (round(x_new(2) * EMGdata.parameters.sampling_rate) - round(x_new(1) * EMGdata.parameters.sampling_rate));
EMGdata.trials.edited(a,1) = EMGdata.trials.edited(a,1)+1;
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

EMGchannel=EMGdata.trials.ch2{a,1};
EMGrange = EMGchannel(round(x_new(1) * EMGdata.parameters.sampling_rate):round(x_new(2) * EMGdata.parameters.sampling_rate));

EMGdata.trials.ch2_EMGburst_onset(a,1)=x_new(1,1);
EMGdata.trials.ch2_EMGburst_offset(a,1)=x_new(2,1);
EMGdata.trials.ch2_EMG_RT(a,1) = EMGdata.trials.ch2_EMGburst_onset(a,1) - EMGdata.trials.stim_onset(a,1);
EMGdata.trials.ch2_EMGburst_area(a,1) = sum(abs(EMGrange)) / (round(x_new(2) * EMGdata.parameters.sampling_rate) - round(x_new(1) * EMGdata.parameters.sampling_rate));
EMGdata.trials.edited(a,1) = EMGdata.trials.edited(a,1)+1;
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

EMGchannel=EMGdata.trials.ch3{a,1};
EMGrange = EMGchannel(round(x_new(1) * EMGdata.parameters.sampling_rate):round(x_new(2) * EMGdata.parameters.sampling_rate));

EMGdata.trials.ch3_EMGburst_onset(a,1)=x_new(1,1);
EMGdata.trials.ch3_EMGburst_offset(a,1)=x_new(2,1);
EMGdata.trials.ch3_EMG_RT(a,1) = EMGdata.trials.ch3_EMGburst_onset(a,1) - EMGdata.trials.stim_onset(a,1);
EMGdata.trials.ch2_EMGburst_area(a,1) = sum(abs(EMGrange)) / (round(x_new(2) * EMGdata.parameters.sampling_rate) - round(x_new(1) * EMGdata.parameters.sampling_rate));
EMGdata.trials.edited(a,1) = EMGdata.trials.edited(a,1)+1;
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

EMGchannel=EMGdata.trials.ch4{a,1};
EMGrange = EMGchannel(round(x_new(1) * EMGdata.parameters.sampling_rate):round(x_new(2) * EMGdata.parameters.sampling_rate));

EMGdata.trials.ch4_EMGburst_onset(a,1)=x_new(1,1);
EMGdata.trials.ch4_EMGburst_offset(a,1)=x_new(2,1);
EMGdata.trials.ch4_EMG_RT(a,1) = EMGdata.trials.ch4_EMGburst_onset(a,1) - EMGdata.trials.stim_onset(a,1);
EMGdata.trials.ch2_EMGburst_area(a,1) = sum(abs(EMGrange)) / (round(x_new(2) * EMGdata.parameters.sampling_rate) - round(x_new(1) * EMGdata.parameters.sampling_rate));
EMGdata.trials.edited(a,1) = EMGdata.trials.edited(a,1)+1;
handles.EMGdata = EMGdata;
plot_figure(EMGdata,handles,a)
guidata(hObject, handles);
%% --- Executes on button press in ch1_clearEMG.
function ch1_clearEMG_Callback(hObject, eventdata, handles)
% hObject    handle to ch1_clearEMG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=handles.a;
EMGdata=handles.EMGdata;

EMGdata.trials.ch1_EMGburst_onset(a,1)=0;
EMGdata.trials.ch1_EMGburst_offset(a,1)=0;
EMGdata.trials.ch1_EMG_RT(a,1)=0;
EMGdata.trials.edited(a,1) = EMGdata.trials.edited(a,1)+1;

handles.EMGdata = EMGdata;
plot_figure(EMGdata,handles,a);
guidata(hObject, handles);

%% --- Executes on button press in ch2_clearEMG.
function ch2_clearEMG_Callback(hObject, eventdata, handles)
% hObject    handle to ch2_clearEMG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=handles.a;
EMGdata=handles.EMGdata;

EMGdata.trials.ch2_EMGburst_onset(a,1)=0;
EMGdata.trials.ch2_EMGburst_offset(a,1)=0;
EMGdata.trials.ch2_EMG_RT(a,1)=0;
EMGdata.trials.edited(a,1) = EMGdata.trials.edited(a,1)+1;

handles.EMGdata = EMGdata;
plot_figure(EMGdata,handles,a);
guidata(hObject, handles);

%% --- Executes on button press in ch3_clearEMG.
function ch3_clearEMG_Callback(hObject, eventdata, handles)
% hObject    handle to ch3_clearEMG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=handles.a;
EMGdata=handles.EMGdata;

EMGdata.trials.ch3_EMGburst_onset(a,1)=0;
EMGdata.trials.ch3_EMGburst_offset(a,1)=0;
EMGdata.trials.ch3_EMG_RT(a,1)=0;
EMGdata.trials.edited(a,1) = EMGdata.trials.edited(a,1)+1;

handles.EMGdata = EMGdata;
plot_figure(EMGdata,handles,a);
guidata(hObject, handles);

%% --- Executes on button press in ch4_clearEMG.
function ch4_clearEMG_Callback(hObject, eventdata, handles)
% hObject    handle to ch4_clearEMG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=handles.a;
EMGdata=handles.EMGdata;

EMGdata.trials.ch4_EMGburst_onset(a,1)=0;
EMGdata.trials.ch4_EMGburst_offset(a,1)=0;
EMGdata.trials.ch4_EMG_RT(a,1)=0;
EMGdata.trials.edited(a,1) = EMGdata.trials.edited(a,1)+1;

handles.EMGdata = EMGdata;
plot_figure(EMGdata,handles,a);
guidata(hObject, handles);

%% --- Executes on button press in ch1_CSP.
function ch1_CSP_Callback(hObject, eventdata, handles)
% hObject    handle to ch1_CSP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=handles.a;
EMGdata=handles.EMGdata;
%manually select onset and offset point for bursts
x_new=ginput(2);
EMGdata.trials.ch1_CSP_onset(a,1)=x_new(1,1);
EMGdata.trials.ch1_CSP_offset(a,1)=x_new(2,1);
EMGdata.trials.edited(a,1) = EMGdata.trials.edited(a,1)+1;

handles.EMGdata = EMGdata;
plot_figure(EMGdata,handles,a)
guidata(hObject, handles);

%% --- Executes on button press in ch2_CSP.
function ch2_CSP_Callback(hObject, eventdata, handles)
% hObject    handle to ch2_CSP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=handles.a;
EMGdata=handles.EMGdata;
%manually select onset and offset point for bursts
x_new=ginput(2);
EMGdata.trials.ch2_CSP_onset(a,1)=x_new(1,1);
EMGdata.trials.ch2_CSP_offset(a,1)=x_new(2,1);
EMGdata.trials.edited(a,1) = EMGdata.trials.edited(a,1)+1;

handles.EMGdata = EMGdata;
plot_figure(EMGdata,handles,a)
guidata(hObject, handles);

%% --- Executes on button press in ch3_CSP.
function ch3_CSP_Callback(hObject, eventdata, handles)
% hObject    handle to ch3_CSP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=handles.a;
EMGdata=handles.EMGdata;
%manually select onset and offset point for bursts
x_new=ginput(2);
EMGdata.trials.ch3_CSP_onset(a,1)=x_new(1,1);
EMGdata.trials.ch3_CSP_offset(a,1)=x_new(2,1);
EMGdata.trials.edited(a,1) = EMGdata.trials.edited(a,1)+1;

handles.EMGdata = EMGdata;
plot_figure(EMGdata,handles,a)
guidata(hObject, handles);

%% --- Executes on button press in ch4_CSP.
function ch4_CSP_Callback(hObject, eventdata, handles)
% hObject    handle to ch4_CSP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=handles.a;
EMGdata=handles.EMGdata;
%manually select onset and offset point for bursts
x_new=ginput(2);
EMGdata.trials.ch4_CSP_onset(a,1)=x_new(1,1);
EMGdata.trials.ch4_CSP_offset(a,1)=x_new(2,1);
EMGdata.trials.edited(a,1) = EMGdata.trials.edited(a,1)+1;

handles.EMGdata = EMGdata;
plot_figure(EMGdata,handles,a)
guidata(hObject, handles);

%% --- Executes on button press in ch1_clearCSP.
function ch1_clearCSP_Callback(hObject, eventdata, handles)
% hObject    handle to ch1_clearCSP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=handles.a;
EMGdata=handles.EMGdata;

EMGdata.trials.ch1_CSP_onset(a,1)=0;
EMGdata.trials.ch1_CSP_offset(a,1)=0;
EMGdata.trials.edited(a,1) = EMGdata.trials.edited(a,1)+1;

handles.EMGdata = EMGdata;
plot_figure(EMGdata,handles,a);
guidata(hObject, handles);

%% --- Executes on button press in ch2_clearCSP.
function ch2_clearCSP_Callback(hObject, eventdata, handles)
% hObject    handle to ch2_clearCSP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=handles.a;
EMGdata=handles.EMGdata;

EMGdata.trials.ch2_CSP_onset(a,1)=0;
EMGdata.trials.ch2_CSP_offset(a,1)=0;
EMGdata.trials.edited(a,1) = EMGdata.trials.edited(a,1)+1;

handles.EMGdata = EMGdata;
plot_figure(EMGdata,handles,a);
guidata(hObject, handles);

%% --- Executes on button press in ch3_clearCSP.
function ch3_clearCSP_Callback(hObject, eventdata, handles)
% hObject    handle to ch3_clearCSP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=handles.a;
EMGdata=handles.EMGdata;

EMGdata.trials.ch3_CSP_onset(a,1)=0;
EMGdata.trials.ch3_CSP_offset(a,1)=0;
EMGdata.trials.edited(a,1) = EMGdata.trials.edited(a,1)+1;

handles.EMGdata = EMGdata;
plot_figure(EMGdata,handles,a);
guidata(hObject, handles);

%% --- Executes on button press in ch4_clearCSP.
function ch4_clearCSP_Callback(hObject, eventdata, handles)
% hObject    handle to ch4_clearCSP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=handles.a;
EMGdata=handles.EMGdata;

EMGdata.trials.ch4_CSP_onset(a,1)=0;
EMGdata.trials.ch4_CSP_offset(a,1)=0;
EMGdata.trials.edited(a,1) = EMGdata.trials.edited(a,1)+1;

handles.EMGdata = EMGdata;
plot_figure(EMGdata,handles,a);
guidata(hObject, handles);
