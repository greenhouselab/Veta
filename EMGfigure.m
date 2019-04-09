function EMGfigure(num_channels,EMG_plot_Ylims,MEP_refline,diode,f1,setup,xlims, trial)
% March 23, 2019 Nick Jackson (njackson@uoregon.edu) & Ian Greenhouse
% (igreenhouse@uoregon.edu)
% This function plots data across multiple channels. It is called by the
% EMGrecord function. For example usage refer to EMGrecord.
clf
if setup
set(f1,'Position',[10 10 1600 900]); % position figure
disp('setup');
end
% loop through channels and diode to create subplots
for i = 1:num_channels 
    if diode
        subplot(num_channels+1,1,i)
    else
        subplot(num_channels,1,i)
    end
%     if i=num_channels
%     xlabel('Seconds');
%     end
    ylabel('mV');
    ylim(EMG_plot_Ylims(i,:));
    xlim(xlims);%recently changed
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
    %peakline = refline([0 0.05]);
    %troughline = refline([0 -0.05]);
    peakline.Color = 'r';
    troughline.Color = 'r';
    hold on
end


end
