function addchannels1125(s,diode)
%% Adds EMG channels to record
%
% Parameters:
%   s: session object
%       data acquisiton session created in EMGrecoed
%   diode: boolean
%       1:diode used, 0: no diode used
%%
% Each new pair channel line adds a new data acquisition analog input voltage channel 'ai' on device 'Dev1'
    %pair channel 1
    channel1 = addAnalogInputChannel(s,'Dev1','ai0','Voltage');
    channel1.TerminalConfig = 'SingleEnded';
    %pair channel 2
    channel2 = addAnalogInputChannel(s,'Dev1','ai1','Voltage');
    channel2.TerminalConfig = 'SingleEnded';
    %pair channel 3
    channel3 = addAnalogInputChannel(s,'Dev1','ai2','Voltage');
    channel3.TerminalConfig = 'SingleEnded';
    %pair channel4
    channel4 = addAnalogInputChannel(s,'Dev1','ai3','Voltage');
    channel4.TerminalConfig = 'SingleEnded';
    %pair channel5
    channel5 = addAnalogInputChannel(s,'Dev1','ai4','Voltage');
    channel5.TerminalConfig = 'SingleEnded';
    %pair channel6
    channel6 = addAnalogInputChannel(s,'Dev1','ai5','Voltage');
    channel6.TerminalConfig = 'SingleEnded';
    %pair channel7
    channel7 = addAnalogInputChannel(s,'Dev1','ai6','Voltage');
    channel7.TerminalConfig = 'SingleEnded';
    %pair channel8
    channel8 = addAnalogInputChannel(s,'Dev1','ai7','Voltage');
    channel8.TerminalConfig = 'SingleEnded';
    %diode channel
    if diode
    channel9 = addAnalogInputChannel(s,'Dev1','ai8','Voltage');
    channel9.TerminalConfig = 'SingleEnded';
end