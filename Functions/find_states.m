function [prob_states, logprob] = find_states(seq, pi, A, b, n_state)
%% Compute the probabilities of hidden states given an observation sequence.
%% authors: Stefano Diomedi 
%% date: 22nd February 2024
%
%% Inputs:
% - seq: Observation sequence.
% - pi: Initial state probabilities.
% - A: State transition matrix.
% - b: Emission matrix.
% - n_state: Number of states in the model.

% Forward algorithm to compute alpha and log likelihood
[alpha, logprob, scale_factor] = fwd_nolog(seq, pi, A, b, n_state);

% Backward algorithm to compute beta
[beta] = bwd_nolog(seq, A, b, scale_factor, n_state);

% Compute the probabilities of hidden states
prob_states = alpha .* beta;

% Remove the first column (corresponding to the dummy state)
prob_states(:, 1) = [];

end