function [HiddenNeuralStatesProbability] = DecodingHiddenNeuralStates(Best_HiddenMarkoModels, emision_sequence_cross, info,str_save_append)
%% Decode hidden neural states probability based on the best Hidden Markov Models.
%% authors: Stefano Diomedi 
%% date: 22nd February 2024
%
%% Inputs:
% - Best_HiddenMarkoModels: Best Hidden Markov Models selected through validation.
% - emision_sequence_cross: Cross-validated emission sequences.
% - info: Struct containing information about the models and sequences.

% Initialize temporary variable to store probabilities
tmp_prob = zeros(info.number_of_states, info.number_of_bin_for_trial);

% Iterate over each cross-validation fold
for cross = 1:info.cross_validation
    % Iterate over each emission sequence
    for seq = 1:info.number_emission_sequence_for_trial
        % Find the probabilities of hidden states for the current sequence
        [prob_states, ~] = find_states(emision_sequence_cross{cross + 1, 2}(seq, :), ...
            Best_HiddenMarkoModels{cross, 1}.pi, Best_HiddenMarkoModels{cross, 1}.A, ...
            Best_HiddenMarkoModels{cross, 1}.b, info.number_of_states);
        
        % Accumulate probabilities
        tmp_prob = tmp_prob + prob_states;
    end
end

% Average the accumulated probabilities over all sequences
HiddenNeuralStatesProbability = tmp_prob ./ size(emision_sequence_cross{12, 2}, 1);

if nargin==4
    currentDir=pwd;
    parentDir=fileparts(currentDir);
    save([parentDir,'\Data\Hidden_Neural_States_Probability\HiddenNeuralStatesProbability_' info.str_data '_' str_save_append],'HiddenNeuralStatesProbability','info')
end
end
