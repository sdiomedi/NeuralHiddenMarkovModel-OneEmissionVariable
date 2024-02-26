%% Demo script
%% Demo file for running HiddenMarkovModel training and decoding on emission sequences form neural spiking data
%% authors: Stefano Diomedi 
%% date: 22nd February 2024

%% For every details regarding the implementation and logic of these functions please refer to 
% Diomedi, S., Vaccari, F. E., Galletti, C., Hadjidimitrakis, K., & Fattori, P. (2021). Motor-like neural dynamics in two parietal areas during arm reaching. Progress in Neurobiology, 205, 102116. https://doi.org/10.1016/j.pneurobio.2021.102116
%% If you use these scripts and function please cite:
% Diomedi, S., Vaccari, F. E., Galletti, C., Hadjidimitrakis, K., & Fattori, P. (2021). Motor-like neural dynamics in two parietal areas during arm reaching. Progress in Neurobiology, 205, 102116. https://doi.org/10.1016/j.pneurobio.2021.102116

%% ATTENTION: 
% the STEP 1 is mandatory only in you use H5 file structured as in the repository:
% Diomedi S, Vaccari FE, Gamberini M, De Vitis M, Filippini M, Fattori P (2023) Single-cell recordings from three cortical parietal areas during an instructed-delay reaching task. G-Node. https://doi.org/10.12751/g-node.84zql6
% in other case you have to arrange your dataset in cell of arrays: 
% for example if you have N number of neurons and C condition and T
% repetition/trial for each condition and you have M marker events for each trial
% 
%   - DATA: cell array N x C, each cell will contain other T cells for each trial containing spike trains.
%   - MARKER: cell array N x C, each cell will contain other T cells for each trial containing timing of event markers.
%   - info: structure info.number_of_neurons = N (double)
%                     info.number_of_conditions = C(double)
%                     info.marker_labels = string (Mx1) with labels of event markers
%                     info.number_of_marker_events= M (double)
%                     info.condition_labels= cell (1xC) with labels of conditions
%   you can find an example of this in the \Data folder
clear 
close all

%% adding dependencies
currentDir=pwd;
parentDir=fileparts(currentDir);

addpath([parentDir '\Functions'])
addpath([parentDir '\Data'])
addpath(genpath([parentDir '\Data']));

%% parameters to set for data preprocessing
condition=1; % The chosen condition for generating emission sequences to train and validate the models.
bin=2; % Time window in milliseconds to convert spike times in spike count.
central_marker=2; % Reference event marker for segmenting spike trains.
m_time=200; % negative offset in milliseconds to define the time windows of interest relative to the central_marker.
p_time=200; % positive offset in milliseconds to define the time windows of interest relative to the central_marker. 
wanted_trials=10;% number of trials to check. If a neuron does not have the desired number of trials for a condition, it is removed from the dataset.
                 % If a neuron has multiple trials, they are randomly chosen to achieve the desired number of trials.
number_emission_seq_for_trial=50; % number of emission sequences generated for each trial

%% parameters for the hidden markov model
n_state=2; % number of states for the hidden markov model.
n_start_condition=1; % number of initial condition for the hidden markov model.
init=1; % initial probability.
tol=1e-06; % tolerance for convergence of the model.
maxiter=1; % maximum number of iteration for the training phase.
parfor_enabled=1; % if 1 enable parallel computing.

str_save_append='example';
%% STEP 1) converting H5 in CELL of array containing spiking activity and event markers 
[DATA,MARKER,info] = fromH5DFtoDATAandMARKER('SintData.h5',str_save_append);

%% STEP 2) checking the number of trials for each condition
[DATA,MARKER,info] = checkingTrials(DATA,MARKER,info,wanted_trials,str_save_append);

%% STEP 3) binning and cutting dataset on a particular condition
[DATA_and_MARKER_binned ,info ] = binning_and_cutting( DATA , MARKER , bin , condition , central_marker , m_time , p_time , info, str_save_append);

%% STEP 4) generating emission sequences
[emision_sequence_cross,info ] = make_sequences_cross( DATA_and_MARKER_binned, number_emission_seq_for_trial,info,str_save_append);

%% STEP 5) training of the models
[ HiddenMarkovModels,info] = HiddenMarkovModel_trn_cross( emision_sequence_cross ,n_state,n_start_condition,init ,tol,maxiter,parfor_enabled,info,str_save_append);

%% STEP 6) validating of the models
[Best_HiddenMarkoModels,info]=HiddenMarkovModel_val_cross( HiddenMarkovModels , emision_sequence_cross,info,str_save_append );

%% STEP 7) decoding hidden states probability
[HiddenNeuralStatesProbability] = DecodingHiddenNeuralStates(Best_HiddenMarkoModels , emision_sequence_cross,info,str_save_append );

%% STEP 8) plotting hidden states probability
figure;
for state=1:info.number_of_states
    plot(HiddenNeuralStatesProbability(state,:))
    hold on
end
ylim([0 1])