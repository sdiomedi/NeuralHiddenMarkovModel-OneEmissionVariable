function [binned, cut] = from_markertime_to_binned(MARKER, neuron, trial, condition, center_marker, bin, m_time, p_time)
%% Function to convert event markers to binned format
%% authors: Stefano Diomedi 
%% date: 22nd February 2024
%
%% Inputs:
%      MARKER: Event marker dataset
%      neuron: Neuron index
%      trial: Trial index
%      condition: Condition index
%      center_marker: Index of the central marker
%      bin: Bin size in milliseconds (e.g., bin = 5 ms)
%      m_time: Time before the marker to consider
%      p_time: Time after the marker to consider
%% Outputs:
%      binned: This variable contains the binned format of the event markers. 
%      cut: This variable contains the cut event markes
%
% Example of timestamp cutting:
% [marker_time - m_time, ..., marker_time, ..., marker_time + p_time]

% If m_time or p_time is zero, set them to a small value to avoid division by zero
if p_time == 0
    p_time = 0.1;
end
if m_time == 0
    m_time = 0.1;
end

% Extract vector of markers for the specified neuron, trial, and condition
vector_marker = MARKER{neuron, condition}{1, trial}'; % select_marker(MARKER, neuron, condition, trial);

% Time of the considered marker
time_marker = vector_marker(center_marker);

% Cut the vector of markers
cut = cut_timestamps(vector_marker, vector_marker, m_time, p_time, center_marker);

% Convert to binned format
[binned, ~] = histcounts(cut, time_marker - m_time:bin:time_marker + p_time);
end
