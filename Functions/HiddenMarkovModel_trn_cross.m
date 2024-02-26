function [HiddenMarkovModels, info] = HiddenMarkovModel_trn_cross(emission_sequence_cross, number_of_states, number_of_start_condition, init, tol, maxiter, parfor_enabled,info, str_save_append)
%% This function trains Hidden Markov Models (HMMs) using cross-validation.
%% authors: Stefano Diomedi 
%% date: 22nd February 2024
%
%% Inputs:
% - emission_sequence_cross: Cross-validation emission sequences
% - number_of_states: number of states for the hidden markov model.
% - number_of_start_condition: numebr of initial condition for the hidden markov model.
% - init: initial probability.
% - tol: tollerance for convergence of the model.
% - maxiter: maximum number of iteration for the training phase.
% - info: structure containing additional information about the data
% - parfor_enabled: if 1 enable parallel computing.
% - save_opt: if 1 save all the trained models in the .\Models folder.

%% Outputs:
% - HiddenMarkovModels: trained models for each initial condition and cross validation
% - info: structure containing updated information about the data and models

disp('Training HiddenMarkovModels')

info.number_of_states = number_of_states;
info.number_of_start_condition = number_of_start_condition;
info.tol=tol;
info.maxiter=maxiter;
% Initial parameters for HMM
pi = zeros(1, number_of_states);
pi(init) = 1;

HiddenMarkovModels = cell(info.cross_validation, number_of_start_condition);

for cross = 1:info.cross_validation
    start_A = generate_startcondition(number_of_states, number_of_start_condition);
    start_b = ones(number_of_states, info.number_of_neurons + 1) * (1 / (info.number_of_neurons + 1));

    if parfor_enabled == 1
        duplication_of_emission_for_parfor = cell(1, number_of_start_condition);
        for i=1:number_of_start_condition
            duplication_of_emission_for_parfor{i}=emission_sequence_cross{cross+1,1};
        end
        % Parfor loop for parallel execution
        parfor k = 1:number_of_start_condition
            disp(['Training on cross-validation ' num2str(cross) ', using initial condition ' num2str(k)])

            [guess_A, guess_b, loglikes] = hmm_training(duplication_of_emission_for_parfor{k}, pi, start_A{k}, start_b, info);

            HiddenMarkovModels{cross, k}.pi = pi;
            HiddenMarkovModels{cross, k}.guess_A = guess_A;
            HiddenMarkovModels{cross, k}.guess_b = guess_b;
            HiddenMarkovModels{cross, k}.loglikes = loglikes;
        end

    else
        for k = 1:number_of_start_condition
            disp(['Training on cross-validation ' num2str(cross) ', using initial condition ' num2str(k)])

            [guess_A, guess_b, loglikes] = hmm_training(emission_sequence_cross{cross + 1, 1}, pi, start_A{k}, start_b, info);
            HiddenMarkovModels{cross, k}.pi = pi;
            HiddenMarkovModels{cross, k}.guess_A = guess_A;
            HiddenMarkovModels{cross, k}.guess_b = guess_b;
            HiddenMarkovModels{cross, k}.loglikes = loglikes;
        end
    end

    if nargin==9 
        currentDir=pwd;
    parentDir=fileparts(currentDir);
    save([parentDir,'\Data\Trained_Models\HHM_trained_models_' info.str_data '_' str_save_append],'HiddenMarkovModels','info')
    end
        
end
