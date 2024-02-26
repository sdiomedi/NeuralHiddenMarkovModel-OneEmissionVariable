function [start_A] = generate_startcondition(n_states, n_start_condition)
%% Generate random initial transition matrices for Hidden Markov Models.
%% authors: Stefano Diomedi 
%% date: 22nd February 2024

% Inputs:
% - n_states: Number of states for which to generate the transition matrix.
% - n_start_condition: Number of different initial conditions to generate.


% Define the range for diagonal values of the transition matrix
a = 0.99;
b = 0.999;

start_A = cell(1, n_start_condition);

for k = 1:n_start_condition
    % Generate random diagonal values for the transition matrix
    diagonal = a + (b - a) .* rand(n_states, 1);
    A = diag(diagonal);

    % Fill the upper triangular part of the matrix with non-diagonal values
    for i = 1:n_states
        for j = i + 1:n_states
            if i ~= j
                A(i, j) = (1 - diagonal(i)) / (n_states - 1);
            end
        end
    end

    % Normalize the upper triangular matrix to obtain a stochastic transition matrix
    start_A{k} = normalized(triu(A));
end

end


