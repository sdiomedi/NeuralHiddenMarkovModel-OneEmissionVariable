function [emision_sequence_cross, info] = make_sequences_cross(DATA_and_MARKER_binned, n_seq_for_trial, info, str_save_append)
%% Function to generate emission sequences of neurons for leave-one-out cross-validation
%% authors: Stefano Diomedi 
%% date: 22nd February 2024
%
%% Inputs:
%      DATA_and_MARKER_binned: Binned timestamps and markers dataset
%      n_seq_for_trial: Number of sequences for each trial
%      info: Information struct
%% Outputs:
%      emision_sequence_cross: Cross-validation emission sequences
%      info: Updated info struct

disp(['Generating emission sequences for condition ' info.label_binned_condition])
h = waitbar(0,['Generating emission sequences for condition ' info.label_binned_condition ':'], 'Name', 'Processing');

% Extract binned timestamps
timestamps_binned = DATA_and_MARKER_binned.timestamps_binned;

count = 1;
tot_iteration=info.number_of_trials * n_seq_for_trial;
% Generate emission sequences for each trial and neuron
for j = 1:info.number_of_neurons:info.number_of_neurons * info.number_of_trials
    i = j + info.number_of_neurons - 1;
    for k = 1:1:n_seq_for_trial
        % Display loading bar
        waitbar(count/tot_iteration, h, sprintf( ['Generating emission sequences for condition ' info.label_binned_condition ': %d%%'], round(count/tot_iteration*100)));
        % Generate emission sequence for the current trial
        emission_seq(count, :) = make_sequence(timestamps_binned(j:i, :));
        count = count + 1;
      
    end
end

% Split sequences into training and validation sets using leave-one-out cross-validation
from = 1:n_seq_for_trial:n_seq_for_trial * info.number_of_trials;
to = n_seq_for_trial:n_seq_for_trial:n_seq_for_trial * info.number_of_trials;

emision_sequence_cross{1, 1} = 'TRN'; emision_sequence_cross{1, 2} = 'VAL';

for i = 2:length(from) + 1
    tmp = emission_seq;
    tmp_val = tmp(from(i - 1):to(i - 1), :);
    tmp(from(i - 1):to(i - 1), :) = [];
    tmp_trn = tmp;
    emision_sequence_cross{i, 1} = tmp_trn;
    emision_sequence_cross{i, 2} = tmp_val;
    emision_sequence_cross{i, 3} = ['trial #', num2str(i - 1), ' out'];
end

emision_sequence_cross{length(from) + 2, 2} = emission_seq;
emision_sequence_cross{length(from) + 2, 3} = 'all trial';

% Update information in the info struct
info.total_number_of_emission_sequences = info.number_of_trials * n_seq_for_trial;
info.number_emission_sequence_for_trial = n_seq_for_trial;
info.cross_validation = length(from);

delete(h)
disp('Done!')

if nargin==4
    currentDir=pwd;
    parentDir=fileparts(currentDir);
    save([parentDir,'\Data\Emission_sequences\EmissionSequences_' info.str_data '_binned_' num2str(info.bin) 'ms_' str_save_append],'emision_sequence_cross','info')
end
end