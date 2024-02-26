function [alpha, logLL, scale] = fwd_nolog(seq, pi, A, b, n_state)
%% Forward algorithm
%% authors: Stefano Diomedi 
%% date: 22nd February 2024

% Prepend a dummy value to the sequence
seq = [9999, seq];
n_bin = length(seq); % Determine the length of the sequence

% Initialize alpha matrix and scaling factor
alpha = zeros(n_state, n_bin);
alpha(:, 1) = pi; % Initialize alpha with initial probabilities
scale = zeros(1, n_bin);
scale(1) = 1; % Initialize the first scaling factor as 1

% Forward algorithm loop
for count = 2:n_bin
    for state = 1:n_state
        % Calculate alpha for the current state and time step
        alpha(state, count) = b(state, seq(count)) * (sum(alpha(:, count-1) .* A(:, state)));
    end
    % Calculate scale factor to normalize alpha values
    scale(count) = sum(alpha(:, count));
    alpha(:, count) = alpha(:, count) ./ scale(count); % Normalize alpha values
end

% Calculate log likelihood of the sequence
logLL = -sum(log(scale));

end