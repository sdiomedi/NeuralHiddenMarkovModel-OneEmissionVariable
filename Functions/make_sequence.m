function [seq] = make_sequence(data_set)
%% Function to generate emission sequence for a given trial across neurons
%% authors: Stefano Diomedi 
%% date: 22nd February 2024
%
%% Inputs:
%      data_set: Binned timestamps matrix (n_neu x n_bin)
%% Outputs:
%      seq: Emission sequence generated for the trial

n_bin = size(data_set, 2);  % Number of bins

for j = 1:1:n_bin
    tmp_bin = data_set(:, j);  % Extract timestamps for the current bin
    indx = find(tmp_bin);  % Find neurons that fired in the current bin
    
    if sum(indx) > 0  % Check if any neuron fired in the current bin
        in = randi(length(indx));  % Choose a random neuron index
        seq(j) = indx(in);  % Assign the neuron index as the symbol for the bin
    else
        seq(j) = 0;  % If no neuron fired, assign symbol 0 to the bin
    end
end

seq = seq + 1;  % Add 1 to all elements in the sequence (MATLAB simbols starts from 1)

end

