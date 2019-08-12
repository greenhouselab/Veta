x%% SICI table data
SICI_summary = table();

%findEMG
uiload()
SICI_summary.find_edited = 0;
SICI_summary.find_accepted = sum(trials.trial_accept);
SICI_summary.find_MEP_count = sum(trials.trial_accept(trials.ch1_MEP_latency>0));
SICI_summary.find_mean_MEP_latency = mean(trials.ch1_MEP_latency);
SICI_summary.find_std_MEP_latency = std(trials.ch1_MEP_latency);
SICI_summary.find_mean_MEP_amplitude = mean(trials.ch1_MEP_amplitude);
SICI_summary.find_std_MEP_amplitude = std(trials.ch1_MEP_amplitude);
SICI_summary.find_mean_MEP_duration = mean(trials.ch1_MEP_duration);
SICI_summary.find_std_MEP_duration = std(trials.ch1_MEP_duration);

%visualizeEMG
uiload()
SICI_summary.vis_edited = sum(trials.edited);
SICI_summary.vis_accepted = sum(trials.trial_accept);
SICI_summary.vis_MEP_count = sum(trials.trial_accept(trials.ch1_MEP_latency>0));
SICI_summary.vis_mean_MEP_latency = mean(trials.ch1_MEP_latency);
SICI_summary.vis_std_MEP_latency = std(trials.ch1_MEP_latency);
SICI_summary.vis_mean_MEP_amplitude = mean(trials.ch1_MEP_amplitude);
SICI_summary.vis_std_MEP_amplitude = std(trials.ch1_MEP_amplitude);
SICI_summary.vis_mean_MEP_duration = mean(trials.ch1_MEP_duration);
SICI_summary.vis_std_MEP_duration = std(trials.ch1_MEP_duration);



%% Stop Task table
Stop_summary = table();

%findEMG
uiload()
Stop_summary.find_edited = 0;
Stop_summary.find_accepted = sum(trials.trial_accept);
Stop_summary.find_EMG_count = sum(trials.trial_accept(trials.ch1_EMGburst_onset>0));
Stop_summary.find_mean_EMG_RT = mean(trials.ch1_EMG_RT(strcmp(trials.go_or_stop,'go') & trials.correct & trials.trial_accept));
Stop_summary.find_std_EMG_RT = std(trials.ch1_EMG_RT(strcmp(trials.go_or_stop,'go') & trials.correct & trials.trial_accept));

%visualizeEMG
uiload()
Stop_summary.vis_edited = sum(trials.edited);
Stop_summary.vis_accepted = sum(trials.trial_accept);
Stop_summary.vis_EMG_count = sum(trials.trial_accept(trials.ch1_EMGburst_onset>0));
Stop_summary.vis_mean_EMG_RT = mean(trials.ch1_EMG_RT(strcmp(trials.go_or_stop,'go') & trials.correct & trials.trial_accept));
Stop_summary.vis_std_EMG_RT = std(trials.ch1_EMG_RT(strcmp(trials.go_or_stop,'go') & trials.correct & trials.trial_accept));

%% Delayed Response Task table
DRT_summary = table();

%findEMG
uiload()
DRT_summary.find_edited = 0;
DRT_summary.find_accepted = sum(trials.trial_accept);
DRT_summary.find_MEP_count = sum(trials.trial_accept(trials.ch1_MEP_latency>0));
DRT_summary.find_mean_bas_MEP_onset = mean(trials.ch1_MEP_latency(strcmp(trials.tms,'bas') & trials.correct & trials.trial_accept));
DRT_summary.find_std_bas_MEP_onset = std(trials.ch1_MEP_latency(strcmp(trials.tms,'bas') & trials.correct & trials.trial_accept));
DRT_summary.find_mean_bas_MEP_amplitude = mean(trials.ch1_MEP_amplitude(strcmp(trials.tms,'bas') & trials.correct & trials.trial_accept));
DRT_summary.find_std_bas_MEP_amplitude = std(trials.ch1_MEP_amplitude(strcmp(trials.tms,'bas') & trials.correct & trials.trial_accept));
DRT_summary.find_mean_bas_MEP_duration = mean(trials.ch1_MEP_duration(strcmp(trials.tms,'bas') & trials.correct & trials.trial_accept));
DRT_summary.find_std_bas_MEP_duration = std(trials.ch1_MEP_duration(strcmp(trials.tms,'bas') & trials.correct & trials.trial_accept));

DRT_summary.find_mean_del_MEP_onset = mean(trials.ch1_MEP_latency(strcmp(trials.tms,'delay') & trials.correct & trials.trial_accept));
DRT_summary.find_std_del_MEP_onset = std(trials.ch1_MEP_latency(strcmp(trials.tms,'delay') & trials.correct & trials.trial_accept));
DRT_summary.find_mean_del_MEP_amplitude = mean(trials.ch1_MEP_amplitude(strcmp(trials.tms,'delay') & trials.correct & trials.trial_accept));
DRT_summary.find_std_del_MEP_amplitude = std(trials.ch1_MEP_amplitude(strcmp(trials.tms,'delay') & trials.correct & trials.trial_accept));
DRT_summary.find_mean_del_MEP_duration = mean(trials.ch1_MEP_duration(strcmp(trials.tms,'delay') & trials.correct & trials.trial_accept));
DRT_summary.find_std_del_MEP_duration = std(trials.ch1_MEP_duration(strcmp(trials.tms,'delay') & trials.correct & trials.trial_accept));

DRT_summary.find_mean_left_EMG_onset = mean(trials.ch1_EMG_RT(strcmp(trials.left_or_right,'left') & strcmp(trials.go_or_catch,'go') & trials.correct & trials.trial_accept));
DRT_summary.find_std_left_EMG_onset = std(trials.ch1_EMG_RT(strcmp(trials.left_or_right,'left') & strcmp(trials.go_or_catch,'go') & trials.correct & trials.trial_accept));
DRT_summary.find_mean_right_EMG_onset = mean(trials.ch2_EMG_RT(strcmp(trials.left_or_right,'right') & strcmp(trials.go_or_catch,'go') & trials.correct & trials.trial_accept));
DRT_summary.find_std_right_EMG_onset = std(trials.ch2_EMG_RT(strcmp(trials.left_or_right,'right') & strcmp(trials.go_or_catch,'go') & trials.correct & trials.trial_accept));

%visualizeEMG
uiload()
DRT_summary.vis_edited = sum(trials.edited);
DRT_summary.vis_accepted = sum(trials.trial_accept);
DRT_summary.vis_MEP_count = sum(trials.trial_accept(trials.ch1_MEP_latency>0));
DRT_summary.vis_mean_bas_MEP_onset = mean(trials.ch1_MEP_latency(strcmp(trials.tms,'bas') & trials.correct & trials.trial_accept));
DRT_summary.vis_std_bas_MEP_onset = std(trials.ch1_MEP_latency(strcmp(trials.tms,'bas') & trials.correct & trials.trial_accept));
DRT_summary.vis_mean_bas_MEP_amplitude = mean(trials.ch1_MEP_amplitude(strcmp(trials.tms,'bas') & trials.correct & trials.trial_accept));
DRT_summary.vis_std_bas_MEP_amplitude = std(trials.ch1_MEP_amplitude(strcmp(trials.tms,'bas') & trials.correct & trials.trial_accept));
DRT_summary.vis_mean_bas_MEP_duration = mean(trials.ch1_MEP_duration(strcmp(trials.tms,'bas') & trials.correct & trials.trial_accept));
DRT_summary.vis_std_bas_MEP_duration = std(trials.ch1_MEP_duration(strcmp(trials.tms,'bas') & trials.correct & trials.trial_accept));

DRT_summary.vis_mean_del_MEP_onset = mean(trials.ch1_MEP_latency(strcmp(trials.tms,'delay') & trials.correct & trials.trial_accept));
DRT_summary.vis_std_del_MEP_onset = std(trials.ch1_MEP_latency(strcmp(trials.tms,'delay') & trials.correct & trials.trial_accept));
DRT_summary.vis_mean_del_MEP_amplitude = mean(trials.ch1_MEP_amplitude(strcmp(trials.tms,'delay') & trials.correct & trials.trial_accept));
DRT_summary.vis_std_del_MEP_amplitude = std(trials.ch1_MEP_amplitude(strcmp(trials.tms,'delay') & trials.correct & trials.trial_accept));
DRT_summary.vis_mean_del_MEP_duration = mean(trials.ch1_MEP_duration(strcmp(trials.tms,'delay') & trials.correct & trials.trial_accept));
DRT_summary.vis_std_del_MEP_duration = std(trials.ch1_MEP_duration(strcmp(trials.tms,'delay') & trials.correct & trials.trial_accept));

DRT_summary.vis_mean_left_EMG_onset = mean(trials.ch1_EMG_RT(strcmp(trials.left_or_right,'left') & strcmp(trials.go_or_catch,'go') & trials.correct & trials.trial_accept));
DRT_summary.vis_std_left_EMG_onset = std(trials.ch1_EMG_RT(strcmp(trials.left_or_right,'left') & strcmp(trials.go_or_catch,'go') & trials.correct & trials.trial_accept));
DRT_summary.vis_mean_right_EMG_onset = mean(trials.ch2_EMG_RT(strcmp(trials.left_or_right,'right') & strcmp(trials.go_or_catch,'go') & trials.correct & trials.trial_accept));
DRT_summary.vis_std_right_EMG_onset = std(trials.ch2_EMG_RT(strcmp(trials.left_or_right,'right') & strcmp(trials.go_or_catch,'go') & trials.correct & trials.trial_accept));

%% CSP
CSP_summary = table();

%findEMG
uiload()
CSP_summary.find_edited = 0;
CSP_summary.find_accepted = sum(trials.trial_accept);
CSP_summary.find_MEP_count = sum(trials.trial_accept(trials.ch1_MEP_latency>0));
CSP_summary.find_mean_MEP_latency = mean(trials.ch1_MEP_latency);
CSP_summary.find_std_MEP_latency = std(trials.ch1_MEP_latency);
CSP_summary.find_mean_MEP_amplitude = mean(trials.ch1_MEP_amplitude);
CSP_summary.find_std_MEP_amplitude = std(trials.ch1_MEP_amplitude);
CSP_summary.find_mean_MEP_duration = mean(trials.ch1_MEP_duration);
CSP_summary.find_std_MEP_duration = std(trials.ch1_MEP_duration);
CSP_summary.find_CSP_count = sum(trials.trial_accept(trials.ch1_CSP_onset>0));
CSP_summary.find_mean_CSP_duration = mean(trials.ch1_CSP_offset(trials.ch1_CSP_offset>0) - trials.ch1_CSP_onset(trials.ch1_CSP_offset>0));
CSP_summary.find_std_CSP_duration = std(trials.ch1_CSP_offset(trials.ch1_CSP_offset>0) - trials.ch1_CSP_onset(trials.ch1_CSP_offset>0));
    
%visualizeEMG
uiload()
CSP_summary.vis_edited = sum(trials.edited);
CSP_summary.vis_accepted = sum(trials.trial_accept);
CSP_summary.vis_MEP_count = sum(trials.trial_accept(trials.ch1_MEP_latency>0));
CSP_summary.vis_mean_MEP_latency = mean(trials.ch1_MEP_latency);
CSP_summary.vis_std_MEP_latency = std(trials.ch1_MEP_latency);
CSP_summary.vis_mean_MEP_amplitude = mean(trials.ch1_MEP_amplitude);
CSP_summary.vis_std_MEP_amplitude = std(trials.ch1_MEP_amplitude);
CSP_summary.vis_mean_MEP_duration = mean(trials.ch1_MEP_duration);
CSP_summary.vis_std_MEP_duration = std(trials.ch1_MEP_duration);
CSP_summary.find_CSP_count = sum(trials.trial_accept(trials.ch1_CSP_onset>0));
CSP_summary.find_mean_CSP_duration = mean(trials.ch1_CSP_offset(trials.ch1_CSP_offset>0) - trials.ch1_CSP_onset(trials.ch1_CSP_offset>0));
CSP_summary.find_std_CSP_duration = std(trials.ch1_CSP_offset(trials.ch1_CSP_offset>0) - trials.ch1_CSP_onset(trials.ch1_CSP_offset>0));
