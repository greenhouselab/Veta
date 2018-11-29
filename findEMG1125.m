% This script finds EMG/MEP events.When script is run, user is prompted to
% open file that was output by EMGrecord
% output:
%   original file named appended with "preprocessed"
%   updated table with the following additional columns:
%       EMG_burst : 1x2 double
%           EMG burst onset and offset
%       MEPloc: double
%           location of MEP in seconds
%       artloc: double
%           location of TMS artefact, used to find MEPloc
%       trial accept: boolean
%           1:accept;0:reject
%% open file with finder/file explore
[FileName,PathName]=uigetfile;
File= fullfile(PathName, FileName);
load(File);
%% default parameters for analyses
emg_threshold = 2.5; % number of std to consider for EMG burst
emg_burst_threshold = .3;
sampling_rate = 5000;
sweepnumber=108;
% Fills new columns with zeros
trials.artloc(:,1)={0};
trials.MEPloc(:,1)={0};
trials.MEPamplitude(:,1)={0};
trials.EMG_burst(:,1)={[0,0]};
trials.trial_accept(:,1)={0};
%% analysis loop
for i=1:sweepnumber
    %assigns signal associated with left and right hand
    signal_data_left=trials.ch1{i,1};
    signal_data_right=trials.ch2{i,1};
    % looks at trials where TMS was administered
    % Here we administered TMS during a task, at baseline and during a delay period
    if strcmp(trials.tms(i,1),'delay') || strcmp(trials.tms(i,1),'bas')
        %find artefact location if TMS
        [M,I] = max(trials.ch3{i,1});
        J=I/sampling_rate;%location
        trials.artloc{i,1}=J;
        %set range to look for MEP
        lowerMEP=I;
        upperMEP=I+1000;
        %look only in range after artefact
        %sets channel where we would find MEP
        MEPchannel= trials.ch1{i,1};
        %if upper range is beyond data then set it below 20000
        if upperMEP > 20000
            upperMEP = 19999;
        end
        if lowerMEP < 0
            lowerMEP =1;
        end
        MEPchannel=MEPchannel';
        MEPchannel=MEPchannel(lowerMEP:upperMEP,1);
        amplitude = max(MEPchannel) - min(MEPchannel);
        [M,K] = max(MEPchannel);
        L=K+I;
        K=L/sampling_rate;%location
        trials.MEPloc{i,1}=K;
        trials.MEPamplitude{i,1}=amplitude;
        %set range to look for preMEP noise
        lowernoise=L-500;
        if lowernoise < 0
            lowernoise = 1;
        end
        uppernoise=L;
        y=trials.ch1{i,1};
        y=y';
        z=rms(y(lowernoise:uppernoise,1));
        %if burst occured before MEP, then the trial is not accepted
        if z<emg_burst_threshold
            trials.trial_accept{i,1}=1;
        else
            trials.trial_accept{i,1}=0;
        end
        %clear signal around artefact in order to isolate EMG data of interest
        signal_data_left(trials.artloc{i}*sampling_rate-20:trials.artloc{i}*sampling_rate+1000)=0;
        signal_data_right(trials.artloc{i}*sampling_rate-20:trials.artloc{i}*sampling_rate+1000)=0;
        % if there is more EMG activity in the left channel
        if max(abs(signal_data_left))>max(abs(signal_data_right)) && max(abs(signal_data_left)) > emg_burst_threshold;
            deviation_from_baseline_index(1,1) = (find(abs(signal_data_left)>emg_threshold*std(signal_data_left),1))/sampling_rate; % find first deviation greater than 2 std.
            emg_offset_index = find(abs(signal_data_left(end:-1:1))>emg_threshold*std(signal_data_left),1);
            deviation_from_baseline_index(1,2) = (length(signal_data_left) - emg_offset_index)/sampling_rate; % find last deviation greater than 2 std.
            trials.EMG_burst{i,1} = deviation_from_baseline_index;
            % if there is more EMG activity in the right channel
        elseif max(abs(signal_data_right))>max(abs(signal_data_left)) && max(abs(signal_data_right)) > emg_burst_threshold;
            deviation_from_baseline_index(1,1) = (find(abs(signal_data_right)>emg_threshold*std(signal_data_right),1))/sampling_rate; % find first deviation greater than 2 std.
            emg_offset_index = find(abs(signal_data_right(end:-1:1))>emg_threshold*std(signal_data_right),1);
            deviation_from_baseline_index(1,2) = (length(signal_data_right) - emg_offset_index)/sampling_rate; % find last deviation greater than 2 std.
            trials.EMG_burst{i,1} = deviation_from_baseline_index;
        end
    else%Finds EMG burst in non-TMS trials
        if max(abs(signal_data_left))>max(abs(signal_data_right)) && max(abs(signal_data_left)) > emg_burst_threshold;
            deviation_from_baseline_index(1,1) = (find(abs(signal_data_left)>emg_threshold*std(signal_data_left),1))/sampling_rate; % find first deviation greater than 2 std.
            emg_offset_index = find(abs(signal_data_left(end:-1:1))>emg_threshold*std(signal_data_left),1);
            deviation_from_baseline_index(1,2) = (length(signal_data_left) - emg_offset_index)/sampling_rate; % find last deviation greater than 2 std.
            trials.EMG_burst{i,1} = deviation_from_baseline_index; % EMG burst onset
        elseif max(abs(signal_data_right))>max(abs(signal_data_left)) && max(abs(signal_data_right)) > emg_burst_threshold;
            deviation_from_baseline_index(1,1) = (find(abs(signal_data_right)>emg_threshold*std(signal_data_right),1))/sampling_rate; % find first deviation greater than 2 std.
            emg_offset_index = find(abs(signal_data_right(end:-1:1))>emg_threshold*std(signal_data_right),1);
            deviation_from_baseline_index(1,2) = (length(signal_data_right) - emg_offset_index)/sampling_rate; % find last deviation greater than 2 std.
            trials.EMG_burst{i,1} = deviation_from_baseline_index; % EMG burst onset
        end
    end
end
outfile=[File(1:end-4),'preprocessed'];
save(outfile, 'trials','subject');


