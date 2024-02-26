function [binned, cut] = from_timestamps_to_binned(DATA, MARKER, neuron, trial, condition, central_marker, bin, m_time, p_time)
%% Function to convert timestamps to binned format
%% authors: Stefano Diomedi 
%% date: 22nd February 2024
%
%% Inputs:
%      DATA: Timestamp dataset
%      MARKER: Corresponding marker dataset
%      neuron: Neuron index
%      trial: Trial index
%      condition: Condition index
%      central_marker: Index of the central marker
%      bin: Bin size in milliseconds (e.g., bin = 5 ms)
%      m_time: Time before the marker to consider
%      p_time: Time after the marker to consider
%% Outputs:
%      binned: This variable contains the binned format of the timestamps. It represents the spike counts within each bin around the central marker for the specified neuron, trial, and condition.
%      cut: This variable contains the cut timestamps, which are the timestamps within the time window specified by m_time and p_time around the central marker for the specified neuron, trial, and condition.
%
% Example of timestamp cutting:
% [marker_time - m_time, ..., marker_time, ..., marker_time + p_time]

if p_time == 0
    p_time = 0.1; % Avoid division by zero if p_time is zero
end
if m_time == 0
    m_time = 0.1; % Avoid division by zero if m_time is zero
end

% Extract vector of timestamps and markers for the specified neuron, trial, and condition
vector_stamps = DATA{neuron, condition}{1, trial}'; % select_timestamps(DATA, neuron, condition, trial, info);
vector_marker = MARKER{neuron, condition}{1, trial}'; % select_marker(MARKER, neuron, condition, trial, info);

% Time of the considered marker
time_marker = vector_marker(central_marker);

% Cut the timestamps vector
cut = cut_timestamps(vector_stamps, vector_marker, m_time, p_time, central_marker);

% Convert to binned format
[binned, ~] = histcounts(cut, time_marker - m_time:bin:time_marker + p_time);
end
