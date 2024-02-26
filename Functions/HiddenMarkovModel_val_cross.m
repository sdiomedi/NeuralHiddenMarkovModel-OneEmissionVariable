function [Best_HiddenMarkoModels, info] = HiddenMarkovModel_val_cross(HiddenMarkovModels, emision_sequence_cross, info,str_save_append)
%% Validate and select the best Hidden Markov Models (HMMs) using cross-validation.
%% authors: Stefano Diomedi 
%% date: 22nd February 2024
%
%% Inputs:
% - HiddenMarkovModels: Trained HMMs from cross-validation.
% - emision_sequence_cross: Cross-validated emission sequences.
% - info: Struct containing information about the models and sequences.

disp('Validation HiddenMarkovModels')
h = waitbar(0,'Validation HiddenMarkovModels:', 'Name', 'Processing');

% Initialize cell array to store hidden states probabilities and log likelihoods
HiddenStates = cell(info.cross_validation, info.number_of_start_condition);

% Iterate over each cross-validation fold
for cross = 1:info.cross_validation
    % Display progress
    waitbar(cross / info.cross_validation, h, sprintf('Validation HiddenMarkovModels: %d%%', cross / info.cross_validation * 100));

    % Extract emission sequences for the current fold
    tmp_seqs = emision_sequence_cross{cross + 1, 2};

    % Iterate over each start condition
    for start_condition = 1:info.number_of_start_condition
        % Extract parameters of the trained HMM
        pi = HiddenMarkovModels{cross, start_condition}.pi;
        A = HiddenMarkovModels{cross, start_condition}.guess_A;
        b = HiddenMarkovModels{cross, start_condition}.guess_b;

        tmp = [];
        tmp_loglikelihood = [];
        
        % Iterate over each emission sequence
        for seq = 1:info.number_emission_sequence_for_trial
            % Find the most probable hidden states and compute likelihood
            [prob_states, likelihood] = find_states(tmp_seqs(seq, :), pi, A, b, info.number_of_states);
            tmp = [tmp; prob_states];
            tmp_loglikelihood = [tmp_loglikelihood; likelihood];
        end
        
        % Store probabilities and likelihoods for the current start condition
        HiddenStates{cross, start_condition}.prob_states = tmp;
        HiddenStates{cross, start_condition}.loglikelihood = tmp_loglikelihood;
    end
end

% Select the best HMMs based on mean log likelihood across cross-validation folds
Best_HiddenMarkoModels = cell(info.cross_validation, 1);
meanloglikelihood = zeros(info.cross_validation, info.number_of_start_condition);

for cross = 1:info.cross_validation
    for start_condition = 1:info.number_of_start_condition
        % Compute mean log likelihood for each start condition
        meanloglikelihood(cross, start_condition) = mean(HiddenStates{cross, start_condition}.loglikelihood);
    end
end

% Select the HMM with the highest mean log likelihood for each cross-validation fold
index = [];
for cross = 1:info.cross_validation
    [~, kkk] = max(meanloglikelihood(cross, :));
    index = [index, kkk];
end

% Store the best HMMs and corresponding information
for cross = 1:1:info.cross_validation
    Best_HiddenMarkoModels{cross, 1}.pi = HiddenMarkovModels{cross, index(cross)}.pi;
    Best_HiddenMarkoModels{cross, 1}.A = HiddenMarkovModels{cross, index(cross)}.guess_A;
    Best_HiddenMarkoModels{cross, 1}.b = HiddenMarkovModels{cross, index(cross)}.guess_b;
    Best_HiddenMarkoModels{cross, 1}.loglikes = HiddenMarkovModels{cross, index(cross)}.loglikes;
end

% Store the index of the selected best model for each cross-validation fold
info.selected_best_mododel_index = index;
delete(h);
disp('Done!')

if nargin==4
    currentDir=pwd;
    parentDir=fileparts(currentDir);
    save([parentDir,'\Data\Best_Models\Best_HMM_' info.str_data '_' str_save_append],'Best_HiddenMarkoModels','info')
end
end
