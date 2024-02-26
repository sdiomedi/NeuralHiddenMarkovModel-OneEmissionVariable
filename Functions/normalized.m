function [t] = normalized(v)
%% Normalize the input vector or matrix such that the rows sum up to 1.
%% authors: Stefano Diomedi 
%% date: 22nd February 2024
%
%% Input:
% - v: Input vector or matrix to be normalized.

if size(v, 1) == 1
    % If v is a row vector
    k = length(v);
    su = 0;
    for i = 1:k
        su = su + v(i);
    end
    t = v ./ su; % Normalize the vector by dividing each element by the sum
else
    % If v is a matrix
    t = v;
    for i = 1:size(v, 1)
        % Iterate over each row of the matrix
        tmp = sum(v(i, :)); % Calculate the sum of elements in the row
        t(i, :) = t(i, :) ./ tmp; % Normalize the row by dividing each element by the sum
    end
end

end