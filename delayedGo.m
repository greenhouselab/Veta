function delayedGo()
%  pause off;

%% parameters
% fields within "parameters" struct
Screen_Sync_Test = 1;
%add trial number displayed in plot
parameters.number_of_trials = 108;
parameters.number_of_practice_trials = 10;
parameters.number_of_blocks = 2;
parameters.trials_per_block = parameters.number_of_trials/parameters.number_of_blocks;
parameters.number_of_left_trials=parameters.number_of_trials/2;
parameters.proportion_catch_trials = 2/10; % only used for practice
parameters.number_of_catch_trials = 8;%was 8

%TMS
parameters.num_baseline_TMS = 20;
parameters.num_delay_TMS = 22; % per  hand

% Event times
parameters.trial_duration = 4.6;
parameters.fixation_onset = .3;
parameters.fixation_duration = .2;
parameters.cue_onset = [1 1.5]; % for jitter
parameters.cue_duration = .9;
parameters.delay_duration = .9;
parameters.target_duration = .8;
parameters.delay_pulse_times = .82; % pulse was coming 20 ms too early?
parameters.ITI_pulse_times = .2;

%% parameters for EMG & photodiode
parameters.reference_line = .025; % in mV
parameters.EMG_plot_Ylims = [-.1 .1]; % in mV
parameters.xlims=[0 4];% in mV
parameters.sampling_rate=5000;
parameters.sweep_duration=4;
parameters.save_per_sweep=0;
num_channels = 3;
diode_chan = 9;
diode=1;
%% Calculate DC offset
offset=setOffset(num_channels, diode);
subject.offset = offset;
%% Input
practice = input('Practice (1) or run (0) or debug (2): ');

switch practice
    case 0
        TMS = 1;%if not a practice trial, TMS is on, change back to 1 for experiment
        subject.ID = input('Enter subject ID #: ');%input numerical value
        time = clock;% 6 element date and time vector
        subject.time = time;
        subject.date = date;%current date string
        subject.handedness = input('Enter subject handedness (l or r): ', 's');
        subject.sex = input('Enter subject sex (m or f): ', 's');
        subject.date_of_birth = input('Enter subject date of birth: ','s');
        subject.RMT = input('Subject Resting Motor Threshold:');
        % store parameters in subject struct
        subject.parameters = parameters;
        number_of_trials = parameters.number_of_trials;
        %parameters.number_of_catch_trials = round(number_of_trials*parameters.proportion_catch_trials);
    case 1
        TMS = 0;%If practice trial, TMS is off
        subject.ID = input('Enter subject ID #: ');
        number_of_trials = parameters.number_of_practice_trials;
        parameters.number_of_catch_trials = round(number_of_trials*parameters.proportion_catch_trials);
    case 2
        TMS = 1;%if not a practice trial, TMS is on, change back to 1 for experiment
        number_of_trials = parameters.number_of_trials;
end

%% input keycodes
% Switch KbName into unified mode: It will use the names of the OS-X
% platform on all platforms in order to make this script portable:
KbName('UnifyKeyNames');

esc=KbName('ESCAPE');% 41 in this case
abort_keys = {'ESCAPE'};%make cell
keypressed = 0;
displayed_key = 0;
WaitSecs(1);%wait 1 second
% Check for key press
while ~keypressed %not
    if ~displayed_key
        disp('press left response key');
        displayed_key = 1;
    end
    [keypressed, secs, leftkeyCode] = KbCheck();
end

parameters.leftkey = find(leftkeyCode);%adds keyCode to parameters struct
display(['key = ' num2str(find(leftkeyCode))]);%key = 41

keypressed = 0;
displayed_key = 0;
WaitSecs(1);
% Check for right key press
while ~keypressed
    if ~displayed_key
        disp('press right response key');
        displayed_key = 1;
    end
    [keypressed, secs, rightkeyCode] = KbCheck();
end

parameters.rightkey = find(rightkeyCode);%adds keyCode to parameters struct
display(['key = ' num2str(find(rightkeyCode))]);

WaitSecs(1);

%% setup figure for EMG recording
f1 = figure(1);
EMGfigure(num_channels,parameters.EMG_plot_Ylims,parameters.reference_line,diode,f1,[],parameters.xlims)
% 
% clf
% f1 = figure(1);
% set(f1,'Position',[100 100 1400 800]);
% for i = 1:num_channels
%     if diode
%         subplot(num_channels+1,1,i)
%     else
%         subplot(num_channels,1,i)
%     end
%     xlabel('Seconds');
%     ylabel('mV');
%     ylim(EMG_plot_Ylims);
%     xlim([0 4]);
%     peakline = refline([0 MEP_ref_line]);
%     troughline = refline([0 -MEP_ref_line]);
%     peakline.Color = 'r';
%     troughline.Color = 'r';
%     hold on
%     if i==1
%         title('Trial 1');
%     end
% end
% 
% if diode
%     subplot(num_channels+1,1,num_channels+1)
%     xlabel('Seconds');
%     ylabel('Diode (mV)');
%     ylim([-.1 .1]);
%     xlim([0 4]);
%     peakline = refline([0 0.05]);
%     troughline = refline([0 -0.05]);
%     peakline.Color = 'r';
%     troughline.Color = 'r';
%     hold on
% end
WaitSecs(1);
%% Set up serial ports
delete(instrfindall); % remove old serial port objects
if TMS
serialPortObj = serial('COM1', 'BaudRate', 9600, 'DataBits', 8, 'StopBits', 1, 'Parity', 'none', 'FlowControl', 'none', 'Terminator', '?');
fopen(serialPortObj);
serialPortObj.TimerFcn = {'Rapid2_MaintainCommunication'};
end

% if TMS%If run trial, execute this block. If practice trial, don't
%     single_pulse_port = serial('COM1', 'BaudRate', 9600, 'DataBits', 8, 'StopBits', 1, 'Parity', 'none', 'FlowControl', 'none', 'Terminator', '?');%change depending on COM port number(change back to COM1)
%     EMG_port = serial('COM4');
%     fopen(single_pulse_port);%connects single_pulse_port to device
%     fopen(EMG_port);%connects EMG_port to device
% end

%% Create Trials Table
trials = table();
trials.trial_number(1:number_of_trials,1) = zeros;%creates single column of zeroes where row # = number_of_trials

trials.left_or_right(1:number_of_trials,1) = {''};
%trials.left_or_right(number_of_trials-parameters.number_of_left_trials+1:number_of_trials,1) = {'right'};
trials.left_or_right(1:2:end)= {'left'};%fills odd rows with left
trials.left_or_right(2:2:end)= {'right'};%fills even rows with right

trials.go_or_catch(1:number_of_trials-parameters.number_of_catch_trials,1) = {'go'};%creates second column with 'go' filled in number of go trials
trials.go_or_catch(number_of_trials-parameters.number_of_catch_trials+1:number_of_trials,1) = {'catch'};%fills remaining cells in table with 'catch'

%trials.tms(1:number_of_trials,1) = {'delay'};

if TMS
    trials.tms(1:36,1) = {''}; % no TMS go% parameters.noTMSgo=36
    trials.tms(37:56,1) = {'bas'}; % baseline TMS go
    trials.tms(57:100,1) = {'delay'}; % delay TMS go
    trials.tms(101:102,1) = {''}; % no TMS catch
    trials.tms(103:104,1) = {'bas'}; % baseline TMS catch
    trials.tms(105:108,1) = {'delay'}; % delay TMS catch
    %change indices to reflect number of pulse trial types
end

trials.RT(1:number_of_trials,1) = zeros;
trials.keypressed(1:number_of_trials,1) = zeros;
trials.correct(1:number_of_trials,1) = zeros;
% Randomize trial order
trials.trial_number(1:number_of_trials) = randperm(number_of_trials);%changes first column of numbers to random permutation of same numbers
trials = sortrows(trials, 'trial_number');% sorts rows according to trial number column
trials.ch1{1} = [];
trials.ch2{1} = [];
trials.ch3{1} = [];
trials.photodiode{1} = [];

%% set up screen
Screen('Preference', 'SkipSyncTests', Screen_Sync_Test);
% Child protection
AssertOpenGL;%Breaks if Screen() is not working or wrong version of Psychtoolbox

% Open onscreen window:
%screen=max(Screen('Screens'));
screen=1;
%screen=1;%sets stimulus presentation screen as "highest" screen
[win, scr_rect] = Screen('OpenWindow', screen);%Open Psychtoolbox screen, designates win as window
[winWidth, winHeight]=Screen('WindowSize', win);%sets window height and width

black=BlackIndex(screen); % Should equal 0.
white=WhiteIndex(screen); % Should equal 255.
pink = [220 0 220];
yellow = [220 220 0];
black = [0 0 0];
white = [220 220 220];
red = [220 0 0];
background=[50, 50, 50]; % gray

xcenter=winWidth/2;
ycenter=winHeight/2;
center_rect = [xcenter - 10, ycenter - 10, xcenter + 10, ycenter + 10];%fixation
left_arc = [xcenter - 150, ycenter - 75, xcenter, ycenter + 75];%index cue
right_arc = [xcenter, ycenter - 75, xcenter + 150, ycenter + 75];%pinky cue
target_position_left = [xcenter - 100, ycenter - 10, xcenter - 80,  ycenter + 10];%index target
target_position_right = [xcenter + 80, ycenter - 10, xcenter + 100,  ycenter + 10];%pinky target

% for photodiode
corner_rect = [winWidth - 50, 0, winWidth, 50];%upper right corner

% Clear screen to background color:
Screen('FillRect', win, background);

% Initial display and sync to timestamp:
vbl=Screen('Flip',win);

theFont='Arial';
Screen('TextSize',win,45);
Screen('TextFont',win,theFont);
Screen('TextColor',win,white);

% Give the display a moment to recover from the change of display mode when
% opening a window. It takes some monitors and LCD scan converters a few seconds to resync.
WaitSecs(2);

%% Task Instructions

experiment_title = sprintf('Delay Period Experiment: %s', date);

%each %display_instructions line is for trigger happy subjects
%display_instructions(win, experiment_title, 'keyboard', 15, background, black);%calls display instructions function
%display_instructions(win, experiment_title, 'keyboard', 15, background, black);
%display_instructions(win, experiment_title, 'keyboard', 15, background, black);
instruct1={{'In this experiment you will be asked to knock the ball into the goal'}...
    {'by laterally flexing your index fingers.'}...
    {'The goal will appear first near the center of the screen and will be followed by a delay'}...
    {'before the ball appears. When the ball appears, please respond as quickly as possible'}...
    {'with the correct finger.'}...
    {''}...
    {''}...
    {'Please push the spacebar when you are ready to continue.'}};

display_instructions(win, instruct1, 'keyboard', 20, background, white);
%% DAQ setup
s = daq.createSession('ni');
s.DurationInSeconds = parameters.sweep_duration;
s.Rate = parameters.sampling_rate;
addchannels(s,diode);
%% Trial Loop
for trial = 1:number_of_trials
    EMG_start = GetSecs; % returns time in seconds at beginning of trial
    
%     % Initiate EMG sweep
%     s = daq.createSession('ni');
%     s.DurationInSeconds = 4;
%     s.Rate=5000; % sampling rate
    
%     %pair channel 1
%     channel1 = addAnalogInputChannel(s,'Dev1','ai0','Voltage');
%     channel1.TerminalConfig = 'SingleEnded';
%     %pair channel 2
%     channel2 = addAnalogInputChannel(s,'Dev1','ai1','Voltage');
%     channel2.TerminalConfig = 'SingleEnded';
%     %pair channel 3
%     channel3 = addAnalogInputChannel(s,'Dev1','ai2','Voltage');
%     channel3.TerminalConfig = 'SingleEnded';
%     %pair channel4
%     channel4 = addAnalogInputChannel(s,'Dev1','ai3','Voltage');
%     channel4.TerminalConfig = 'SingleEnded';
%     %pair channel5
%     channel5 = addAnalogInputChannel(s,'Dev1','ai4','Voltage');
%     channel5.TerminalConfig = 'SingleEnded';
%     %pair channel6
%     channel6 = addAnalogInputChannel(s,'Dev1','ai5','Voltage');
%     channel6.TerminalConfig = 'SingleEnded';
%     %pair channel7
%     channel7 = addAnalogInputChannel(s,'Dev1','ai6','Voltage');
%     channel7.TerminalConfig = 'SingleEnded';
%     %pair channel8
%     channel8 = addAnalogInputChannel(s,'Dev1','ai7','Voltage');
%     channel8.TerminalConfig = 'SingleEnded';
% 
%     if diode
%         channel9 = addAnalogInputChannel(s,'Dev1','ai8','Voltage');
%         channel9.TerminalConfig = 'SingleEnded';
%     end
    
    lh = addlistener(s,'DataAvailable',@plotData);
    s.startBackground();
   
    trial_start = GetSecs;
    
    Screen('FillRect', win, black, corner_rect); % Fills photodiode rectangle with black
    Screen('Flip',win);
    
    while GetSecs-trial_start<parameters.fixation_onset % waits until fixation onset time is met before proceeding
        pause(0)
    end
    
    % Present Fixation
    Screen('FillRect', win, white, center_rect);%fixation
    Screen('FillRect', win, black, corner_rect);%Fills photodiode rectangle with black
    Screen('Flip',win);
    fixation_onset_time = GetSecs;
    fixation_offset_time = fixation_onset_time + parameters.fixation_duration;
    
    % Baseline TMS pulse
    if TMS && strcmp(trials.tms(trial,1),'bas') % string compare, if TMS and trial is baseline
        while GetSecs-trial_start < parameters.ITI_pulse_times % Wait to deliver TMS until ITI pulse time is met
            pause(0)
        end
        success = Rapid2_TriggerPulse(serialPortObj, 0); % trigger TMS via serial port
    end
    
    while GetSecs < fixation_offset_time
        pause(0) % continue once fixation offset time is met
    end
    
    Screen('Flip', win);
    
    % Jitter Cue onset
    post_fixation_wait_time = parameters.cue_onset(1) + (parameters.cue_onset(2)-parameters.cue_onset(1)).*rand(1);%creates random post fixation wait time within a range
    while GetSecs-trial_start < post_fixation_wait_time
        pause(0) % continue once post fixation wait time is met
    end
    
    
    % Present Cue - left or right
    if strcmp(trials.left_or_right(trial,1),'left')
        Screen('FrameArc',win, white, left_arc, 45, 90, 20, 20);
    elseif strcmp(trials.left_or_right(trial,1),'right')
        Screen('FrameArc',win, white, right_arc, 225, 90, 20, 20);
    end
    Screen('FillRect', win, black, corner_rect); % photodiode rectangle black
    Screen('Flip',win);
    cue_onset_time = GetSecs;
    cue_offset_time = cue_onset_time + parameters.cue_duration;    
    
    % Delay TMS pulse
    if TMS && strcmp(trials.tms(trial,1),'delay')
        while GetSecs - cue_onset_time < parameters.delay_pulse_times
            pause(0)
        end
        success = Rapid2_TriggerPulse(serialPortObj, 0); % trigger TMS via serial port
    end
 
    % Prepare Go stimulus
    if strcmp(trials.left_or_right(trial,1),'left') & strcmp(trials.go_or_catch(trial,1),'go')
        Screen('FrameArc',win, white, left_arc, 45, 90, 20, 20);
        Screen('FrameArc',win, white, target_position_left, 0, 360, 20, 20);
        Screen('FillRect', win, white, corner_rect);%photodiode rectangle white
    elseif strcmp(trials.left_or_right(trial,1),'right') & strcmp(trials.go_or_catch(trial,1),'go')
        Screen('FrameArc',win, white, right_arc, 225, 90, 20, 20);
        Screen('FrameArc',win, white, target_position_right, 0, 360, 20, 20);
        Screen('FillRect', win, white, corner_rect);%photodiode rectangle white
        %         elseif strcmp(trials.target(trial,1),'X'), %
        %             Screen('DrawLine',win, white, xcenter-45,ycenter-45,xcenter+45,ycenter+45,10);
        %             Screen('DrawLine',win, white, xcenter+45,ycenter-45,xcenter-45,ycenter+45,10);
        %             Screen('FillRect', win, white, corner_rect);
    end    
    
    % Wait remainder of delay period
    while GetSecs < cue_offset_time % continue once cue offset time is met
        pause(0)
    end
    
    % Present Target   
    if ~strcmp(trials.go_or_catch(trial,1),'catch')
        Screen('Flip',win); % refresh blank screen
%         pause(0) % not sure why this was here IG 6/29/18
    end
    target_onset = GetSecs;
    
    %         % set up stop signal
    %         if trials.staircase(trial,1),
    %             trials.SSD(trial,1) = parameters.SSD_staircase(trials.staircase(trial,1));
    %             SSD = trials.SSD(trial,1);
    %             Screen('DrawLine', win, red, xcenter-45, ycenter-45, xcenter+45, ycenter+45, 10);
    %             Screen('DrawLine', win, red, xcenter+45, ycenter-45, xcenter-45, ycenter+45, 10);
    %             Screen('FillRect', win, red, corner_rect);
    %
    %         end
    
    target_offset = target_onset + parameters.target_duration;
    
    keypressed = 0;
    %         stop_signal = 0;
    
    %         while ~keypressed & GetSecs<target_offset & ~stop_signal;
    %
    %             [keypressed, secs, keyCode, deltaSecs] = KbCheck(parameters.input_device);   %% updated for two keypads
    %
    %             if trials.SSD(trial,1) & GetSecs > target_onset+SSD,
    %                 stop_signal = 1;
    %             end
    %
    %         end
    
    %         Screen('Flip', win); % update display if button pressed or stop signal
    
    while ~keypressed && GetSecs<target_offset
        [keypressed, secs, keyCode] = KbCheck();   %% updated for two keypads
        pause(0)
    end
    Screen('Flip', win); % update display if button pressed or stop signal
    trial_end_time = trial_start + parameters.trial_duration;
    
    while GetSecs < trial_end_time
        pause(0)
        while ~keypressed && GetSecs<trial_end_time
            
            [keypressed, secs, keyCode] = KbCheck();   %% updated for two keypads
            pause(0)
        end
    end
    
    if keypressed
        trials.RT(trial,1) = secs - target_onset;%stores reaction time in trail
        trials.keypressed(trial,1) = find(keyCode);%
    end
    if ~strcmp(trials.go_or_catch(trial,1),'catch') & keypressed % If key is pressed during go trial, then response is marked correct
        trials.correct(trial,1)=1;
    elseif strcmp(trials.go_or_catch(trial,1),'catch') & ~keypressed %If key is not pressed during catch trail, the trial is  correct
        trials.correct(trial,1)=1;
    end
    
    %% extract data from figure (channels are indexed in backwards order)
%     for m = num_channels+1:-1:2       
%         FileName1=f1.Children(m).Children;
%         FileName2 = get(FileName1, 'YData');
%         channel_data=[];     
%         r = [1:(size(FileName2,1)-2)];
%         for n = r(end:-1:1) % the last chunk of data is plotted first (order matters!!!)
%             exdata1 = FileName2{n,1};
%             channel_data = [channel_data, exdata1];
%             trials.(['ch', num2str(m-1)]){trial} = channel_data;
%         end
%     end
%  
%     if diode
%         m = 1;
%         FileName1=f1.Children(m).Children;
%         FileName2 = get(FileName1, 'YData');
%         channel_data=[];     
%         r = 1:(size(FileName2,1)-2);
%         for n = r(end:-1:1) % the last chunk of data is plotted first (order matters!!!)
%             exdata1 = FileName2{n,1};
%             channel_data = [channel_data, exdata1];
%             trials.photodiode{trial,1} = channel_data;
%         end
%     end

    %% Save Data
    if ~practice && parameters.save_per_sweep%only saves data if run trial
        
        cur_path = pwd;
        
        if isdir([cur_path,'/data']),
        else mkdir(cur_path,'/data'),%if variable
        end
        
        if ischar(subject.ID)%makes folder for subject if none exists already, if subject id is composed of characters or numbers
            if isdir([cur_path,'/data/',subject.ID]),
            else mkdir([cur_path,'/data/',subject.ID]);
            end
            subject_ID = subject.ID;
        elseif isnumeric(subject.ID),
            subject_ID = sprintf('%d',subject.ID);
            if isdir([cur_path,'/data/',subject_ID]),
            else mkdir([cur_path,'/data/',subject_ID]);
            end
        end
        
        outfile=sprintf('%s_%s_go_task_trials_TMS_%s.mat', subject_ID, date);
        
        try
            save(['data/',subject_ID,filesep,outfile],'trials', 'subject');
        catch%in case save doesn't work
            fprintf('couldn''t save %s\n saving to conditional_stop_TMS.mat\n',outfile);
            subject_ID = sprintf('%d',subject_ID);%format data into string
            save(subject_ID);
        end
        
    end

        s.wait();
        %% extract data from figure, refresh figure
        [trials]=pulldata(diode,trial,f1,num_channels,trials);
    EMGfigure(num_channels,parameters.EMG_plot_Ylims,parameters.reference_line,diode,f1,[],parameters.xlims)
    %%
    delete(lh) % delete listener
    %savestart=GetSecs;
    assignin('base','trials',trials);
    assignin('base','subject',subject);
    
    % Escape trial loop
    while GetSecs - trial_start < parameters.trial_duration,
        [keyIsDown, secs, keyCode] = KbCheck(parameters.input_device);
        if sum(find(keyCode)==KbName(abort_keys)),
            sca%Screen('CloseAll')
            pause(0)
        end
    end
    
    if mod(trial,parameters.trials_per_block)==0 && ~practice
        %modulo operator
        instruct1={{'Take a break'.'}...
            {''}...
            {'Please press any key when you are ready to continue.'}};
        display_instructions(win, instruct1, 'keyboard', 25, background, white);%press spacebar to exit
        %display_instructions(win, instruct1, 'keyboard', 25, background, black);
    end
    
    if mod(trial,parameters.number_of_trials/parameters.number_of_blocks)==0 && ~practice & trial==parameters.number_of_trials
        %modulo operator
        instruct1={{'You are done with the trial'.'}...
            {''}...
            {'Please press any key when you are ready to exit.'}};
        display_instructions(win, instruct1, 'keyboard', 25, background, white);%press spacebar to exit
        %display_instructions(win, instruct1, 'keyboard', 25, background, black);
    end
    %emgdata has to be accessed after wait function 

%     try
%          save(['data/',subject_ID,filesep,outfile],'trials', 'subject');
%     catch%in case save doesn't work
%         fprintf('couldn''t save %s\n',outfile);
%         subject_ID = sprintf('%d',subject_ID);%format data into string
%         uisave;
%     end;
%% present blank EMG & diode plot
%     clf
%     for i = 1:num_channels
%         if diode
%             subplot(num_channels+1,1,i)
%         else
%             subplot(num_channels,1,i)
%         end
%         xlabel('Seconds');
%         ylabel('mV');
%         ylim(EMG_plot_Ylims);
%         xlim([0 4]);
%         peakline = refline([0 MEP_ref_line]);
%         troughline = refline([0 -MEP_ref_line]);
%         peakline.Color = 'r';
%         troughline.Color = 'r';
%         hold on
%         if i==1
%             title(['Trial ', num2str(trial)])
%         end
%     end
%     if diode
%         subplot(num_channels+1,1,num_channels+1)
%         xlabel('Seconds');
%         ylabel('Diode (mV)');
%         ylim([-.1 .1]);
%         xlim([0 4]);
%         peakline = refline([0 0.05]);
%         troughline = refline([0 -0.05]);
%         peakline.Color = 'r';
%         troughline.Color = 'r';
%         hold on
%     end
    
end
if save_data && ~parameters.save_per_sweep
    cur_path = pwd;

    if isdir([cur_path,'/data'])
    else
        mkdir(cur_path,'/data')
    end

    if ischar(subject.ID)%makes folder for subject if none exists already, if subject id is composed of characters or numbers
        if isdir([cur_path,'/data/',subject.ID])
        else mkdir([cur_path,'/data/',subject.ID]);
        end
        subject_ID = subject.ID;
    elseif isnumeric(subject.ID)
        subject_ID = sprintf('%d',subject.ID);
        if isdir([cur_path,'/data/',subject_ID])
        else mkdir([cur_path,'/data/',subject_ID]);
        end
    end
    if mvc
        outfile=sprintf('%s_MVC_EMGrecord_data_%s.mat', subject_ID, date);
    else
        outfile=sprintf('%s_EMGrecord_data_%s.mat', subject_ID, date);
    end
    
    save(['data/',subject_ID,filesep,outfile]','trials', 'subject'); % save data
end 
sca%Screen('CloseAll')
stop(s);

%% plotData callback function
% function plotData(src,event)
% num_channels = 3;
% diode_chan = 9;
% plot_data = [];
% %offset= -0.017584;
%     for chan = 1:num_channels
%         plot_data{chan}=event.Data(:,chan) - offset; %mean(event.Data(:,chan));
%     end
%     if diode_chan
% %         plot_data{num_channels+1}=event.Data(:,diode_chan) - mean(event.Data(:,diode_chan));
%         plot_data{num_channels+1} = event.Data(:,diode_chan) - 0.2422; % estimated mean of diode signal
%     end
% 
%     plots = size(plot_data,2);
%     for chan = 1:plots
%         subplot(plots,1,chan);
%         plot(event.TimeStamps,plot_data{chan},'k');
%     %     hold on
%     end
% 
% end
function plotData(src,event)
        plot_data = [];
        for chan = 1:num_channels
            plot_data{chan}=event.Data(:,chan)-offset(chan);
        end
        if diode
            plot_data{num_channels+1}=event.Data(:,diode_chan);%-offset(chan); % check for fixed diode offset value
        end
        
        plots = size(plot_data,2);
        for chan = 1:plots
            subplot(plots,1,chan);
            plot(event.TimeStamps,plot_data{chan},'k');
        end
    end
end
