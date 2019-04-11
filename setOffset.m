function offset=setOffset(num_channels, diode)
%{ 
March 23, 2019 Nick Jackson (njackson@uoregon.edu) & Ian Greenhouse
(igreenhouse@uoregon.edu)

Calculates electrode voltage offset for each channel. Aids in data visualization and later analysis.

Input: type
  num_channels: double
       number of channels to calculate offset
   diode: boolean
       toggles diode visualization
Output: type
   offset: double
       offset on mV to be substracted from trace for further sweep visualizations
%}
%removes previous communication interface objects used in previous scripts 
delete(instrfindall);
%% plot parameters
sweepnumber = 1;%number of sweeps
MEP_refline = .025; % target MEP amplitude in mV
EMG_plot_Ylims = [-.2 .2; -.2 .2; -.2 .2; -.2 .2; -.2 .2; -.2 .2; -.2 .2; -.2 .2]; % in mV
sweep_duration=0.5;% in seconds
xlims=[0 sweep_duration];

if diode
    diode_chan=9;
end
%% setup figure
f1 = figure(1); %creates a figure window
% set(f1,'Position',[10 10 1600 900]);
EMGfigure(num_channels,EMG_plot_Ylims,MEP_refline,diode,f1,1,xlims, 1)%calls EMGfigure function
%% pre-allocate trials table
trials = table();
%% Sweep Loop
s = daq.createSession('ni');
s.DurationInSeconds = sweep_duration;
s.Rate=5000;
addchannels(s,diode);

for i=1:sweepnumber
    lh = addlistener(s,'DataAvailable',@plotData);
    s.startBackground();
    %     if TMS
    %        success = Rapid2_TriggerPulse(serialPortObj, 0);
    %     end
    s.wait();

    %% extract data from figure
    [trials]=pulldata(diode,i,f1,num_channels,trials);
    %% Save Block
    delete(lh)
    savestart=GetSecs;
    assignin('base','trials',trials);
    %savetime=GetSecs-savestart
%     EMGfigure(num_channels,EMG_plot_Ylims,MEP_refline,diode,f1,[],xlims)
end
for chan_num = 1:num_channels
    offset(chan_num)=mean(trials.(['ch',num2str(chan_num)]){1});
end
clf
assignin('base','offset',offset)
%%
% function plotData(src,event)
% diode_chan = 0;
% plot_data = [];
% for chan = 1:num_channels
%     plot_data{chan}=event.Data(:,chan);
% end
% if diode_chan
%     plot_data{num_channels+1}=event.Data(:,diode_chan);
% end
% 
% plots = size(plot_data,2);
% for chan = 1:plots
%     subplot(plots,1,chan);
%     plot(event.TimeStamps,plot_data{chan},'k');
% end
% end
    function plotData(src,event)
        %diode_chan = 9;
        plot_data = [];
        for chan = 1:num_channels
            plot_data{chan}=event.Data(:,chan);
        end
        if diode
            plot_data{num_channels+1}=event.Data(:,diode_chan);
        end
        
        
        plots = size(plot_data,2);
        for chan = 1:plots
            subplot(plots,1,chan);
            plot(event.TimeStamps,plot_data{chan},'k');
        end
    end
end
