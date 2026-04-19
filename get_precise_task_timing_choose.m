function timing_output = get_precise_task_timing_choose(subjnum)
%% this function create timepoints for three events: 
% 1. start of target 
% 2. start of delay
% 3. start of response
load('/Users/shanshan/Desktop/GLM_in_AFNI/mutha_choosewm/subjinfo/subjinits.mat')
load('/Users/shanshan/Desktop/GLM_in_AFNI/mutha_choosewm/subjinfo/sessionlist.mat')
load('/Users/shanshan/Desktop/GLM_in_AFNI/mutha_choosewm/subjinfo/runlist.mat')
% Align behavioral and fmri data in a big table
% received from Sarah, edited for Hsin's data
% updated 0528 for exp 1
%% about init_log.mat data:
%% Important difference - tommy's log separate between sessions, need to read them all into one big file
% behavioral dir
% data file: t_map - 1st column delay start, 2nd response start;
% eg: AY = load('/d/DATD/datd/wmChoose_scanner/wmChoose_behav/AY_MGSMap1_behav.mat');
%% Feb 15: get precise timing dir change:     
% directory changed: /d/DATD/datd/wmChoose_scanner/wmChoose_behav/AY_MGSMap1_behav.mat
datapath = '/d/DATD/datd/wmChoose_scanner/wmChoose_behav';
subjname = subjinits{subjnum};
sessions = length(sessionlist{subjnum});
delay_start = []; trial_start = []; resp_start = [];

for sess = 1:sessions
    clear c_map p_map r_map coords_map  t_map runsess
    session = sessionlist{subjnum}{sess};
    session = sscanf(session, 'MGSMap%d');
    filename = [subjname '_MGSMap' num2str(session) '_behav.mat'];
    load([datapath '/' filename]);
    delay_start_sess = t_map(:,1);
    trial_start_sess = delay_start_sess - 0.5; % true value is about 0.5085 second 
    resp_start_sess = t_map(:,2);
    delay_start = [delay_start; delay_start_sess]; 
    trial_start = [trial_start; trial_start_sess]; resp_start = [resp_start; resp_start_sess]; 
end %end session  

% 1. number of runs
runs = size(trial_start,1)/16;
% 2. run start use to be one number, now should be number of runs
all_times_choose = [trial_start delay_start resp_start];
all_times_choose = reshape(all_times_choose',numel(all_times_choose),1);
%% add in other information column
all_events = repmat([1; 2; 3],16,1);
all_runs = repelem([1:runs],length(all_events))';

all_events = repmat(all_events,runs,1);
all_trials = repelem([1:16],3)'; all_trials = repmat(all_trials, runs, 1);
timing_table = [all_times_choose all_events all_trials all_runs];

timing_output = table;
% label in table for clarity
timing_output.times = timing_table(:,1);
timing_output.events = timing_table(:,2);
timing_output.trial = timing_table(:,3);
timing_output.run = timing_table(:,4);
end