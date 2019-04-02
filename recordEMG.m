function recordEMG()
% April 1, 2019 Nick Jackson (njackson@uoregon.edu) & Ian Greenhouse
% (img@uoregon.edu)
% This function plots and records EMG. TMS interface capabilities are also
% supported enabling triggering of TMS pulses at prespecified times.


%% Default Parameters (edit these)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
parameters.number_of_sweeps = 4000; % number of sweeps
parameters.sampling_rate = 5000; % Hz (depends on hardware)
parameters.sweep_duration = 2; % in seconds
parameters.EMG_plot_Ylims = [-.1 .1]; % Y axis limits in V
parameters.xlims=[0 parameters.sweep_duration]; % X axis limits (time in seconds)
parameters.reference_line = .025; % target +/- EMG amplitude in V

% Save options
parameters.save_per_sweep = 0; % 1 = saves after each sweep (slows acquisition), 0 = saves at end of session

% The following parameters are for maximum voluntary contraction (MVC)
parameters.number_of_MVC_sweeps = 4; % number of sweeps if MVC is selected
parameters.MVC_percentage = .05; % calculates 5 percent maximum peak to peak amplitude
parameters.EMG_plot_Ylims_MVC = [-5 5]; % larger Y axis range for MVC
parameters.MVC_sweep_duration = 4; % in seconds
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% DAQ Vendor
% DAQ toolbox works with 'ni', 'digilent', 'directsound', 'adi', or 'mcc'.
% See https://www.mathworks.com/help/daq/ref/daq.getvendors.html
DAQ_vendor = 'ni';

%% removes previous communication interface objects used in previous scripts
delete(instrfindall);

%% Input
%user is prompted to input practice or run
save = input('Practice (0) or Run/save (1): ');

if save
    save_data = 1;%if not a practice trial, data will be saved
    
    mvc = input('Calculate Maximum Voluntary Contraction (MVC)? Yes(1) or No(0): ');
    if mvc
        num_channels = 1;
    else
        num_channels=input('Enter number of channels (1-8): ');
    end    
    time = clock;% 6 element date andtime vector
    
    subject.ID = input('Enter subject ID #: ');%input numerical value
    subject.time = time;
    subject.date = date;%current date string
    subject.handedness = input('Enter subject handedness (l or r): ', 's');
    subject.sex = input('Enter subject sex (m or f): ', 's');
    subject.date_of_birth = input('Enter subject date of birth: ','s');
    subject.RMT = input('Subject Resting Motor Threshold:');
    diode=input('Diode? Yes(1) or No(0): ');
else
    save_data = 0;%If practice trial, save is off
    mvc=0;
    num_channels=input('Enter number of channels (1-8): ');
    diode=input('Diode? Yes(1) or No(0): ');
    subject.practice = 1;
end

if diode
    diode_chan=9;
end
%% Calculate DC offset
offset=setOffset(num_channels, diode);
subject.offset = offset;

%% MVC(could be written as separate function)
if mvc
    %% Change MVC parameters
    parameters.number_of_sweeps = parameters.number_of_MVC_sweeps; %number of sweeps
    parameters.reference_line = 0; % target MEP amplitude in V
    parameters.EMG_plot_Ylims = parameters.EMG_plot_Ylims_MVC; % in V
    parameters.sweep_duration = parameters.MVC_sweep_duration;% in seconds
    parameters.xlims=[0 parameters.sweep_duration];
end

%% preallocate table
trials = table();
trials.sweep_num(1:parameters.number_of_sweeps,1) = 1:parameters.number_of_sweeps;

%% setup figure   
f1 = figure(1); %creates a figure window
EMGfigure(num_channels,parameters.EMG_plot_Ylims,parameters.reference_line,diode,f1,1,parameters.xlims)

%% DAQ setup
s = daq.createSession(DAQ_vendor); % DAQ vendor specified above
s.DurationInSeconds = parameters.sweep_duration;
s.Rate = parameters.sampling_rate;
addchannels(s,diode);

%% If stimulus presentation is desired, e.g. through Psychtoolbox, additional variables and devices can be specified here.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Sweep Loop
% If desired, stimuli can be presented within this loop. The general
% framework is compatible with most types of timed stimulus presentation.
for i=1:parameters.number_of_sweeps
    %% record EMG
    lh = addlistener(s,'DataAvailable',@plotData); % initialize EMG recording
    s.startBackground(); % start recording EMG in background
    %     if TMS
    %        success = Rapid2_TriggerPulse(serialPortObj, 0);
    %     end
    s.wait();
    %% extract data from figure
    [trials]=pulldata(diode,i,f1,num_channels,trials);
    %[trials]=pulldata011619(diode,i,f1,num_channels,trials);

    EMGfigure(num_channels,parameters.EMG_plot_Ylims,parameters.reference_line,diode,f1,[],parameters.xlims)
    %% save after each sweep
    if parameters.save_per_sweep && save_data
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
    %%
    delete(lh) % delete listener
    %savestart=GetSecs;
    assignin('base','trials',trials);
    assignin('base','subject',subject);
    %savetime=GetSecs-savestart    
    
end
%% Calculate MVC
if mvc
    for i = 1:size(trials,1)
        max_vals(i) = max(trials.ch1{i});
        min_vals(i) = min(trials.ch1{i});
    end
    max_of_max = max(max_vals);
    min_of_min = min(min_vals);
    MVC_diff = max_of_max - min_of_min;
    five_percent_MVC = MVC_diff * parameters.MVC_percentage;
    display(['+/- limit ' num2str(parameters.MVC_percentage*100) '%:', num2str(five_percent_MVC)]); % ten percent total
    subject.fivepercentMVC=five_percent_MVC;
    subject.MVCtrials=trials;
end   
%% save data to file
if save_data
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
%% close figure
close(f1);

%% callback plotData function
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
