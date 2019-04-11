function EMGfigure(num_channels,EMG_plot_Ylims,MEP_refline,diode,f1,setup,xlims, trial)
%{ 
April 10, 2019 Nick Jackson (njackso6@uoregon.edu) & Ian Greenhouse
(igreenhouse@uoregon.edu)

This function plots data across multiple channels. It is called by the
EMGrecord function. For example usage refer to EMGrecord.

Input: type
        num_channels: double - Number of channels of data to extract
        EMG_plot_Ylims: double - y limits for each subplot
        MEP_refline: line used for MEP thresholding
        diode: bool - indicates whether if diode data should be pulled
        f1: Figure - to pull data from
        setup: bool - toggle on when initializing figure
        xlims: double - x limits for each subplot
%}
clf
if setup
set(f1,'Position',[10 10 1600 900]); 
disp('setup');
end
for i = 1:num_channels 
    if diode
        subplot(num_channels+1,1,i)
    else
        subplot(num_channels,1,i)
    end
    ylabel('mV');
    ylim(EMG_plot_Ylims(i,:));
    xlim(xlims);
    peakline = refline([0 MEP_refline]);
    troughline = refline([0 -MEP_refline]);
    peakline.Color = 'r';
    troughline.Color = 'r';
    hold on
    if i==1
        title_text = ['Sweep: ' num2str(trial)];
        title(title_text);
    end
end

if diode
    subplot(num_channels+1,1,num_channels+1)
    xlabel('Seconds');
    ylabel('Diode (mV)');
    ylim([-.5 .5]);
    xlim(xlims);
    peakline.Color = 'r';
    troughline.Color = 'r';
    hold on
end
end
