function [ beta ] = bwd_nolog(seq, A, b, s, n_state)
%% Backward algorithm
%% authors: Stefano Diomedi 
%% date: 22nd February 2024

% Prepend a dummy value to the sequence
seq = [9999, seq];
n_bin = length(seq); % Determine the length of the sequence

% Initialize the beta matrix with ones
beta = ones(n_state, n_bin);

% Loop backwards through the sequence
for count = n_bin - 1:-1:1
    % Iterate through each state
    for state = 1:n_state
        % Check if s(count+1) is smaller than eps
        if s(count+1) < eps
            s(count+1) = eps; % Set s(count+1) to eps
        end
        % Calculate beta value for the current state and time step
        beta(state, count) = (1 / s(count+1)) * sum(A(state, :)' .* beta(:, count+1) .* b(:, seq(count+1))); 
    end
end
end