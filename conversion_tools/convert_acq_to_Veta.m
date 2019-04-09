function convert_acq_to_Veta()

% This function will convert .acq files into .mat Veta files.

EMG_channels = input('Enter the numbers of channels containing EMG in this experiment (e.g. [2] or [1 3 5]: ');

directoryname = uigetdir(pwd, 'Select Directory Containing .acq data');

files = dir(fullfile(directoryname,'*.acq'));

trials = table();

for i = 1:length(files)
    
    acq_data{i} = load_acq(fullfile(directoryname, files(i).name));

    for chan = 1:length(EMG_channels)
        channel_data = acq_data{i}.data(:,EMG_channels(chan));
        trials.(['ch', num2str(EMG_channels(chan))]){i,1} = channel_data;        
    end

end
subject = struct();
outfile=[files(1).name(1:end-9),'_acq_to_Veta', date];
uisave({'trials', 'files', 'subject'},outfile);
end