function [cut] = cut_timestamps(vector_stamps, vector_marker, m_t, p_t, n_marker)
%% Function to cut timestamps based on a specified marker and time window
%% authors: Stefano Diomedi 
%% date: 22nd February 2024
%
%% Inputs:
%      vector_stamps: Vector of timestamps
%      vector_marker: Vector of markers
%      m_t: Time before the marker (in seconds)
%      p_t: Time after the marker (in seconds)
%      n_marker: Index of the marker (from 1 to 14)
%
%% Outputs:
%      cut: Cut timestamps within the specified time window around the marker

% Calculate the start and end times of the window relative to the marker
start_time = vector_marker(n_marker) - m_t;
end_time = vector_marker(n_marker) + p_t;

% Find timestamps within the specified time window
indices = (vector_stamps > start_time) & (vector_stamps < end_time);
% Extract timestamps within the specified time window
cut = vector_stamps(indices);
end
