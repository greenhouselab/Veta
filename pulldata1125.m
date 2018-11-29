function [trials]=pulldata1125(diode,i,f1,num_channels,trials)
%% Pulls data from figure, called from EMGrecord
%
% Parameters:
%   diode: boolean
%       1:diode used, 0: no diode used
%   i : int
%       sweepnumber from EMGrecord
%   f1 : figure
%       live figure
%   num_channels : int
%       number of EMG channels recording from
%   trials: table
%       trials table with previous sweep data
% Output:
%   trials: table
%       updated trials table with data from current sweep
%%
chan_plot_number = 1; % increment the channel number accurately
    if diode
        numplotchannels=num_channels+1;
    end
    for m = numplotchannels:-1:1 % plots are indexed backwards
%         channel_data = [];
        FileName1=f1.Children(m).Children; % call global variable Children to name file
        FileName2 = get(FileName1, 'YData');
        channel_data=[]; % preallocate channel_data     
        r = [1:(size(FileName2,1)-2)];
        for n = r
            exdata1 = FileName2{n,1};
            channel_data = [channel_data, exdata1];
            trials.(['ch', num2str(chan_plot_number)]){i} = flip(channel_data);
            % inputs channel data to trials
        end
        chan_plot_number = chan_plot_number+1;
    end
end
    