function convert_Signal_to_Veta()

% This function will convert .mat files created with the Delsys File Utility.

EMG_channels = input('Enter the numbers of channels containing EMG in this experiment (e.g. [2] or [1 3 5]: ');

[filename, pathname] = uigetfile(pwd, 'Select File Containing data');

Signal_data = load(fullfile(pathname, filename));

trials = table();

fields = fieldnames(Signal_data);
for f = 1:length(fields)
   TF = isfield(Signal_data.(fields{f}),'values');
   if TF
       value_field_index = f;
   end
end


for i = 1:size(Signal_data.(fields{value_field_index}).values,3)        

    for chan = 1:length(EMG_channels)
        channel_data = Signal_data.(fields{value_field_index}).values(:,EMG_channels(chan),i);
        trials.(['ch', num2str(EMG_channels(chan))]){i,1} = channel_data;        
    end

end

subject = struct();
outfile=[filename(1:end-4),'_EMGWorks_to_Veta', date];
uisave({'trials', 'filename', 'subject', 'Signal_data'},outfile);
end