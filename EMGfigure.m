function EMGfigure(num_channels,EMG_plot_Ylims,MEP_refline,diode,f1,setup)
% setups and refreshes figure for visualizing EMG sweeps
%
%Parameters:
%   num_channels : int
%       number of EMG channels recording from
%   EMG_plot_Ylims : 1x2 double
%       Y limits in mV
%   MEP_refline: double
%       Reference line for finding resting motor threshold, default=.5(50
%       microvolts)
%   diode: boolean
%       1:diode used, 0: no diode used
%   f1 : figure
%       live figure
%   setup : boolean
%       1: setup figure before first sweep, 0:refresh figure for upcoming
%       sweep
%
%clears figurespace 
clf
if setup
    set(f1,'Position',[10 10 1600 900]);
end
for i = 1:num_channels
    if diode
        subplot(num_channels+1,1,i)
    else
        subplot(num_channels,1,i)
    end
    % EMG figure parameters
    xlabel('Seconds');
    ylabel('mV');
    ylim(EMG_plot_Ylims);
    xlim([0 2]);
    peakline = refline([0 MEP_refline]);
    troughline = refline([0 -MEP_refline]);
    peakline.Color = 'r';
    troughline.Color = 'r';
    hold on
end

if diode % adds diode subplot
    subplot(num_channels+1,1,num_channels+1)
    xlabel('Seconds');
    ylabel('Diode (mV)');
    ylim([-.1 .1]);
    xlim([0 2]);
    peakline = refline([0 0.05]);
    troughline = refline([0 -0.05]);
    peakline.Color = 'r';
    troughline.Color = 'r';
    %holds figure on monitor to
    hold on
end
end