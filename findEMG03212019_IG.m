function findEMG03142019_IG
% This function finds EMG/MEP events. When script is run, user is prompted to
% open file that was output by EMGrecord.
% output:
%   original file named appended with "preprocessed"
%       parameters: struct
%            analysis parameters
%   updated trials table with the following additional columns:
%       ch#_EMGburst_onset: double
%           EMG burst onset for channel (# specified)
%       ch#_EMGburst_offset: double
%           EMG burst offset for channel (# specified)
%       RMS_preMEP: double
%           Root mean square of signal in epoch preceding MEP
%       MEP_onset_time: double
%           location of MEP in seconds
%       artloc: double
%           location of TMS artefact, used to find MEPloc
%       MEPamplitude: double
%           amplitude of MEP
%       trial accept: boolean
%           1:accept;0:reject
%       stim_onset: boolean
%           photodiode event, if used

%% define analysis parameters (edit these)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
parameters.sampling_rate = 5000; % samples per second (Hz)
parameters.emg_burst_threshold = .3; % raw threshold in mV to consider for EMG
parameters.emg_onset_std_threshold = 2.5; % number of std to consider for EMG burst onsets/offsets
parameters.tms_artefact_threshold = .03; % raw threshold magnitude in mV to consider for TMS artefact
parameters.MEP_window_post_artefact = .1; % time in s after TMS to measure MEP in seconds
parameters.pre_TMS_reference_window = .1;  % time before TMS to serve as reference baseline for MEP onset
parameters.MEP_onset_std_threshold = 3; % number of std to consider for MEP onsets
parameters.min_TMS_to_MEP_onset_time = .018; % number of secs after TMS to begin MEP onset detection
parameters.preMEP_EMG_activity_window = .1; % time before MEP to inspect for EMG activity
parameters.RMS_preMEP_EMG_tolerance = .05; % root mean square EMG tolerance for including MEP

% parameters for removing TMS artefact & MEP when detecting EMG in same channel as MEP
parameters.time_prior_to_TMS_artefact = .005; % time in s prior to TMS artefact to set to zero
parameters.end_of_MEP_relative_to_TMS = .1; % time in s of end of MEP relative to TMS artefact
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% open file with finder/file explore
[FileName,PathName] = uigetfile;
File= fullfile(PathName, FileName);
load(File);

%% set number of channels
trials.trial_accept(:,1) = 1;
chs = ["ch1","ch2","ch3","ch4","ch5","ch6","ch7","ch8"];
parameters.num_channels = sum(contains(trials.Properties.VariableNames,chs));

%% Toggles EMG and TMS functionality
parameters.EMG = input('Do you want to find EMG bursts? yes(1) or no(0):');

if parameters.EMG
    parameters.EMG_burst_channels = input('Enter the channels to be analyzed for EMG bursts (e.g. [2] or [1 3 5]: ');
end

parameters.TMS = input('Did you want to detect MEPs? yes(1) or no(0):');

if parameters.TMS
    trials.artloc(:,1) = 0;
    trials.MEP_onset_time(:,1) = 0;
    trials.MEPamplitude(:,1) = 0;
    trials.RMS_preMEP(:,1) = 0;
    parameters.artchan_index = input('Enter TMS artefact channel #:');
    parameters.MEPchan_index = input('Enter MEP channel #:');
end

%% find photodiode event
if any(strcmp('photodiode', trials.Properties.VariableNames))
    trials = findDiode(trials,parameters);
end

%% Find TMS, MEP, and EMG events
trials = findEvents(trials,parameters);

%% save file
outfile=[File(1:end-4),'_preprocessed'];
save(outfile, 'trials','subject','parameters');
end

%% HELPER FUNCTIONS
%% Find Diode
function trials=findDiode(trials,parameters)
% detects large changes in photodiode signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for i=1:height(trials)
        %% photodiode event
        diff_diode = diff(trials.photodiode{i});
        [max_diode_value,max_diode_index] = max(diff_diode);
        trials.stim_onset(i,1) = max_diode_index/parameters.sampling_rate; % location for GUI
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Find TMS, MEP, and EMG
function trials = findEvents(trials,parameters) % parameterize these
%% finds both EMG and TMS events(will flesh out)
% input
%     trials:table
%     parameters:struct
% output
%     trials:table
%     updated with new information
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% initialize burst columns
if parameters.EMG
    for chan = 1:length(parameters.EMG_burst_channels)
        trials.(['ch', num2str(parameters.EMG_burst_channels(chan)), '_EMGburst_onset'])(:,1) = 0;
        trials.(['ch', num2str(parameters.EMG_burst_channels(chan)), '_EMGburst_offset'])(:,1) = 0;
    end
end

%% identify MEP and non-MEP channels
if parameters.TMS & parameters.EMG
    non_MEP_channels = parameters.EMG_burst_channels(parameters.EMG_burst_channels ~= parameters.MEPchan_index); % do not want to detect MEPs as EMG bursts, so ignore MEP channel
elseif parameters.EMG
    non_MEP_channels = parameters.EMG_burst_channels;
end

%% sweep loop
    for i = 1:height(trials)
        %create temporary table
    %     temptrials=trials;% for some reason when defined before the loop this doesn't work
        %artefact channel
        if parameters.TMS
            
            artchannel = trials.(['ch', num2str(parameters.artchan_index)]){i,1}; % was brackets
            MEPchannel = trials.(['ch', num2str(parameters.MEPchan_index)]){i,1};
            [min_artefact_value, TMS_artefact_sample_index] = min(artchannel);
            
            if min_artefact_value < -1 * abs(parameters.tms_artefact_threshold) % TMS artefact must exceed a threshold to be classified as an artefact
                trials.artloc(i,1) = TMS_artefact_sample_index/parameters.sampling_rate;%artefact location scaled for visualization                

                %define MEP search range
                lower_limit_MEP_window = TMS_artefact_sample_index + (parameters.min_TMS_to_MEP_onset_time * parameters.sampling_rate);
                upper_limit_MEP_window = TMS_artefact_sample_index + (parameters.MEP_window_post_artefact * parameters.sampling_rate);
                
                % define lower limit of pre-TMS artefact reference window
                % for determining threshold for MEP.
                preTMS_reference_window_lower_limit = TMS_artefact_sample_index - (parameters.pre_TMS_reference_window * parameters.sampling_rate);

                %redefine range if it extends beyond upper x limit
                if upper_limit_MEP_window > length(trials.ch1{1,1})
                    upper_limit_MEP_window=length(trials.ch1{1,1})-1;
                end

                %look only in range after artefact
                preTMS_MEP_reference_data = MEPchannel(preTMS_reference_window_lower_limit:TMS_artefact_sample_index);
                MEPsearchrange = MEPchannel(lower_limit_MEP_window:upper_limit_MEP_window);
                [max_MEP_value,MEP_max_sample_point] = max(MEPsearchrange);
                [min_MEP_value,MEP_min_sample_point] = min(MEPsearchrange);
%                 MEP_max_peak_sample_index = MEP_max_sample_point + lower_limit_MEP_window;
%                 MEP_min_peak_sample_index = MEP_min_sample_point + lower_limit_MEP_window;

                % identify MEP onset
                MEP_onset_index = find(abs(MEPsearchrange) > parameters.MEP_onset_std_threshold * std(abs(preTMS_MEP_reference_data)),1); % first value that exceeds std threshold within rectified MEP search range
                trials.MEP_onset_time(i,1) = ((MEP_onset_index + lower_limit_MEP_window)/parameters.sampling_rate) - trials.artloc(i,1);            
                trials.MEPamplitude(i,1) = max_MEP_value - min_MEP_value;

                %set range to look for preMEP EMG activity to calculate RMS
                lower_rms_bound = MEP_onset_index - (parameters.preMEP_EMG_activity_window*parameters.sampling_rate);
                upper_rms_bound = MEP_onset_index;
                %redefine range if it extends beyond lower x limit
                if lower_rms_bound < 0
                    lower_rms_bound = 1;
                end   
                RMS_of_preMEP_window = rms(MEPchannel(lower_rms_bound:upper_rms_bound));
                trials.RMS_preMEP(i,1) = RMS_of_preMEP_window;

                % reject trial if RMS is above tolerance threshold
                if RMS_of_preMEP_window < parameters.RMS_preMEP_EMG_tolerance
                    trials.trial_accept(i,1)=1;
                else
                    trials.trial_accept(i,1)=0;
                end  
            end
        end

        %% find EMG bursts
        
        % detect EMG burst in MEP channel
        if parameters.EMG & parameters.TMS & sum(ismember(parameters.EMG_burst_channels, parameters.MEPchan_index)) % if EMG burst detection is required in MEP channel
            
            signal_burst = MEPchannel;
            
            if trials.artloc(i,1)
                % remove MEP to evaluate EMG activity in the absence of TMS and MEP
                % influence on EMG trace
                preTMS_timepoint = (trials.artloc(i,1) - parameters.time_prior_to_TMS_artefact) * parameters.sampling_rate; %weird sci notation issue, round necessary
                MEP_end_timepoint = preTMS_timepoint + (parameters.end_of_MEP_relative_to_TMS * parameters.sampling_rate); % end of MEP

                %clear MEP activity from channel before looking for bursts
                signal_burst(round(preTMS_timepoint):round(MEP_end_timepoint)) = mean(MEPchannel);
            end
            
            
            if max(signal_burst) > parameters.emg_burst_threshold
                emg_burst_onset_time = (find(abs(signal_burst) > parameters.emg_onset_std_threshold * std(signal_burst),1)) / parameters.sampling_rate; % find first deviation greater than # std.
                emg_burst_offset_time_from_end = find(abs(signal_burst(end:-1:1)) > parameters.emg_onset_std_threshold * std(signal_burst),1);
                emg_burst_offset_time_from_start = (length(signal_burst) - emg_burst_offset_time_from_end)/parameters.sampling_rate; % find last deviation greater than # std.
                trials.(['ch', num2str(parameters.MEPchan_index) '_EMGburst_onset'])(i,1) = emg_burst_onset_time; % EMG burst onset
                trials.(['ch', num2str(parameters.MEPchan_index) '_EMGburst_offset'])(i,1) = emg_burst_offset_time_from_start; % EMG burst offset
                if trials.stim_onset(i,1)
                    trials.(['ch', num2str(parameters.MEPchan_index) '_EMG_RT'])(i,1) = emg_burst_onset_time - trials.stim_onset(i,1);
                end
            end
        end
        
        if parameters.EMG & ~isempty(non_MEP_channels)
            
            for n = 1:length(non_MEP_channels)
                emgcomp(i,n) = max(abs(trials.(['ch', num2str(non_MEP_channels(n))]){i,1}));
            end
            
            [burstsize,burstchan_index] = max(emgcomp(i,:));
            burstchan = non_MEP_channels(burstchan_index);            
         
            % Detect bursts in non-MEP channels
            for chan = 1:length(non_MEP_channels) %loop through and see which channels surpass the threshold
                if emgcomp(i,chan) > parameters.emg_burst_threshold
                    signal_burst = trials.(['ch', num2str(non_MEP_channels(chan))]){i,1};
                    emg_burst_onset_time = (find(abs(signal_burst) > parameters.emg_onset_std_threshold * std(signal_burst),1)) / parameters.sampling_rate; % find first deviation greater than # std.
                    emg_burst_offset_time_from_end = find(abs(signal_burst(end:-1:1)) > parameters.emg_onset_std_threshold * std(signal_burst),1);
                    emg_burst_offset_time_from_start = (length(signal_burst) - emg_burst_offset_time_from_end)/parameters.sampling_rate; % find last deviation greater than # std.
                    trials.(['ch', num2str(non_MEP_channels(chan)) '_EMGburst_onset'])(i,1) = emg_burst_onset_time;
                    trials.(['ch', num2str(non_MEP_channels(chan)) '_EMGburst_offset'])(i,1) = emg_burst_offset_time_from_start;
                    if trials.stim_onset(i,1)
                        trials.(['ch', num2str(non_MEP_channels(chan)) '_EMG_RT'])(i,1) = emg_burst_onset_time - trials.stim_onset(i,1);
                    end
                end
            end

        end
        
    end % end trial loop
    
end % end findEvent function
