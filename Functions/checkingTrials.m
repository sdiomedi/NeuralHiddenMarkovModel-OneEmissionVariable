function [DATA, MARKER, info] = checkingTrials(DATA, MARKER, info, wanted_n_trials,str_save_append)
%% Function to check and modify the number of trials for each condition
%% authors: Stefano Diomedi 
%% date: 22nd February 2024
%
%% Inputs:
%   - DATA: cell array containing spike train data
%   - MARKER: cell array containing marker event data
%   - info: structure containing information about the data
%   - wanted_n_trials: desired number of trials for each condition
%% Outputs:
%   - DATA: modified cell array containing spike train data
%   - MARKER: modified cell array containing marker event data
%   - info: modified structure containing information about the data

disp('Checking number of trials for condition')
h = waitbar(0,'Checking number of trials for condition:', 'Name', 'Processing');

neuron_to_remove = []; % Initialize list of neurons to remove

% Loop over neurons
for neuron = 1:info.number_of_neurons
    waitbar(neuron/info.number_of_neurons, h, sprintf('Checking number of trials for condition: %d%%', neuron/info.number_of_neurons*100));

    % Calculate the number of trials for each condition
    for condition = 1:info.number_of_conditions
        n_trials_for_cond(condition) = length(DATA{neuron, condition});
    end

    % Check if the number of trials matches the desired number
    if isequal(n_trials_for_cond, ones(1, length(n_trials_for_cond)) * wanted_n_trials)
        % If the number of trials matches, continue to the next neuron
        continue
    elseif all(n_trials_for_cond - ones(1, length(n_trials_for_cond)) * wanted_n_trials > 0)
        % If the number of trials is greater than the desired number for all conditions
        % randomly select 'wanted_n_trials' trials for each condition
        for condition = 1:info.number_of_conditions
            random_trials = randperm(n_trials_for_cond(condition), wanted_n_trials);
            DATA{neuron, condition} = DATA{neuron, condition}(1, random_trials);
            MARKER{neuron, condition} = MARKER{neuron, condition}(1, random_trials);
        end
    else
        % If the number of trials is not consistent across conditions, mark the neuron for removal
        neuron_to_remove = [neuron_to_remove, neuron];
    end
end

% Remove neurons marked for removal
DATA(neuron_to_remove, :) = [];
MARKER(neuron_to_remove, :) = [];

% Update information about the data
info.number_of_neurons = size(DATA, 1);
info.number_of_trials = wanted_n_trials;
delete(h)
disp('Done!')

if nargin==5
    currentDir=pwd;
    parentDir=fileparts(currentDir);
    save([parentDir,'\Data\Data_mat\' info.str_data '_preprocessed_' str_save_append],'DATA','MARKER','info')
end
end
