function convert_EMGWorks_to_Veta()

% This function will convert .mat files created with the Delsys File Utility.

EMG_channels = input('Enter the numbers of channels containing EMG in this experiment (e.g. [2] or [1 3 5]: ');

directoryname = uigetdir(pwd, 'Select Directory Containing data');

files = dir(fullfile(directoryname,'*.mat'));

trials = table();

for i = 1:length(files)
    
    EMGworks_data{i} = load(fullfile(directoryname, files(i).name));

    for chan = 1:length(EMG_channels)
        channel_data = EMGworks_data{i}.Data(EMG_channels(chan),:);
        trials.(['ch', num2str(EMG_channels(chan))]){i,1} = channel_data;        
    end

end

subject = struct();
% parameters.sampling_rate = EMGworks_data{i}.Fs;
outfile=[files(1).name(1:end-27),'_EMGWorks_to_Veta', date];
uisave({'trials', 'files', 'subject', 'EMGworks_data'},outfile);
end