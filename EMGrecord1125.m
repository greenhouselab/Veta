function EMGrecord1125(num_channels, sweepnumber, sweep_duration, diode)
%% Records EMG from a specified number of channels (num_channels; default = 2) for 
% a specified number of sweeps (sweepnumber; default = 500) 
% and duration (sweep_duration; default = 4s). 
% 
% If a photodiode is used, the diode input can be set (0 = no diode; 1 = diode).
% Default is diode == 1.
%
% outputs:
%   file with that contains subject struct and trials table
% helper functions:
%   EMGfiguure
%      creates and refreshes figure for visualizing signals
%   addchannels
%      adds EMG channels to be recorded during visualization
%   pulldata
%      extracts data from figure
% callback function:
%   plotData
%   -live plots data from session obect
%% input arguments
if ~nargin
    num_channels = 2; % EMG channels
    sweepnumber = 500; % number of sweeps
    sweep_duration=4; % in seconds
    diode = 1;    
elseif nargin == 1
    sweepnumber = 500; % number of sweeps
    sweep_duration=4; % in seconds
    diode = 1;
end
    
%% plot parameters
MEP_refline = .025; % target MEP amplitude in mV
EMG_plot_Ylims = [-.2 .2]; % in mV
%% Input
% user is prompted to input practice or run
practice = input('Practice (1) or run (0): ');
if ~practice
    TMS = 1 ;% if not a practice trial, TMS is on so pulses will be automatically administered during the sweep and the data will be saved(line 54)
    subject.ID = input('Enter subject ID #: '); % input numerical value
    time = clock; % 6 element date and time vector
    subject.time = time;
    subject.date = date; % current date string
    subject.handedness = input('Enter subject handedness (l or r): ', 's');
    subject.sex = input('Enter subject sex (m or f): ', 's');
    subject.date_of_birth = input('Enter subject date of birth: ','s');
    subject.RMT = input('Subject Resting Motor Threshold:');
else
    TMS = 0; % If practice trial, TMS is off
end

% removes previous communication interface objects
delete(instrfindall);

%% setup figure
f1 = figure(1); % creates a figure window
% set(f1,'Position',[10 10 1600 900]); % set figure position
EMGfigure(num_channels,EMG_plot_Ylims,MEP_refline,diode,f1,1) % calls EMGfigure function
%% pre-allocate trials table
trials = table();
number_of_trials = sweepnumber;
% trials.trial_number(1:number_of_trials,1) = zeros; % creates single column of zeroes where row # = number_of_trials
% trials.ch1{1} = [];
% trials.ch2{1} = [];
%% Sweep Loop
for i=1:sweepnumber  % input sweep data into sweep structure
    s = daq.createSession('ni'); % create session object for matlab to reference
    s.DurationInSeconds = sweep_duration; % [s]
    s.Rate=5000; % [Hz]
    addchannels(s,diode); % see 'addchannels.m', local fxn
    lh = addlistener(s,'DataAvailable',@plotData); % waits: when data is available, plots structure s (line 88)
    s.startBackground(); % continues recording data in background while plotting
    %     if TMS
    %        success = Rapid2_TriggerPulse(serialPortObj, 0);
    %     end
    s.wait();
    
    %% extract data from figure
    [trials]=pulldata(diode,i,f1,num_channels,trials); % see 'pulldata.m', local fxn
    EMGfigure(num_channels,EMG_plot_Ylims,MEP_refline,diode,f1,[]) % see 'EMGfigure.m', local fxn
    %% Save Block
    if TMS
        cur_path = pwd; %defines current working path as cur_path
        
        if isdir([cur_path,'/data']) % if directory, proceed
        else mkdir(cur_path,'/data'),% if no directory exists, create directory
        end
        
        if ischar(subject.ID) % makes folder for subject if none exists already, if subject id is composed of characters or numbers
            if isdir([cur_path,'/data/',subject.ID]) % if subject exists, use current directory
            else mkdir([cur_path,'/data/',subject.ID]); % if new subject, make directory
            end
            subject_ID = subject.ID; % retrieve subject id
        elseif isnumeric(subject.ID) % if the subject id is a number
            subject_ID = sprintf('%d',subject.ID); % translates numeric id to character id
            if isdir([cur_path,'/data/',subject_ID]) % if subject id is already stored, do nothing
            else mkdir([cur_path,'/data/',subject_ID]); %if subject id is not already stored, store
                % (prevents duplicate directory/subject id)
            end
        end
        
        outfile=sprintf('%s_hotspot_data_%s.mat', subject_ID, date); % moves data to storage in outfile
        
        try
            save(['data/',subject_ID,filesep,outfile],'trials', 'subject');
        catch % in case save doesn't work, write to outfile
            fprintf('couldn''t save %s\n saving to conditional_stop_TMS.mat\n',outfile);
            subject_ID = sprintf('%d',subject_ID); % format data into string
            save(subject_ID);
        end
    end
    
end
end
%% data visualization
function plotData(src,event) % creates fxn 'plotdata'
num_channels = 2; % # must match line 25
diode_chan = 9; % this will depend on line 26. comment out if line 26 is 0
plot_data = [];
for chan = 1:num_channels % for each channel plot data
    plot_data{chan} = event.Data(:,chan) - mean(event.Data(:,chan)); % this should be changed to match the method used for diode!
end
if diode_chan
    plot_data{num_channels+1} = event.Data(:,diode_chan) - 0.2422; %if diode data, plot it, remove noise
end

plots = size(plot_data,2); % how many plots you need
for chan = 1:plots
    subplot(plots,1,chan); % allows all electrode channels data to be viewed together
    plot(event.TimeStamps,plot_data{chan},'k'); % plots data
end
end
