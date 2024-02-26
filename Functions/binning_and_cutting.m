function [DATA_and_MARKER_binned, info] = binning_and_cutting(DATA, MARKER, bin, condition, marker, m_time, p_time,info,str_save_append)
%% Function to bin spike times and event markers for each neuron and trial
%% authors: Stefano Diomedi 
%% date: 22nd February 2024
% 
%% Inputs:
% - DATA: Raw spike data
% - MARKER: Event marker data
% - info: Struct containing information about the data
% - bin: Bin size in milliseconds
% - condition: Condition index
% - marker: Marker index
% - m_time: Time before marker in milliseconds
% - p_time: Time after marker in milliseconds
%% Outputs:
% - data_binned: Binned data and corresponding cut data
% - info: Updated info struct

disp(['Binning spike times and event markers for condition ' info.condition_labels{condition}])
h = waitbar(0,['Binning spike times and event markers for condition ' info.condition_labels{condition} ':'], 'Name', 'Processing');

% Update info struct with time parameters and bin size
info.m_time = m_time;
info.p_time = p_time;
info.bin = bin;
info.number_of_bin_for_trial = (m_time + p_time) / bin;
info.central_marker = marker;

% Preallocate memory for binned timestamps and markers
timestamps_binned = zeros(info.number_of_neurons * info.number_of_trials, (m_time + p_time) / bin);
marker_binned = zeros(info.number_of_neurons * info.number_of_trials, (m_time + p_time) / bin);

% Cell arrays to store cut timestamps and markers
timestamps_cut = cell(info.number_of_neurons * info.number_of_trials, 1);
marker_cut = cell(info.number_of_neurons * info.number_of_trials, 1);
tot_iteration=info.number_of_trials*info.number_of_neurons;
count = 1;
for trial = 1:info.number_of_trials
    for neuron = 1:info.number_of_neurons
        % Display loading bar
        waitbar(count/tot_iteration, h, sprintf( ['Binning spike and markers for condition ' info.condition_labels{condition} ': %d%%'], round(count/tot_iteration*100)));
        
        % Bin spike times
        [timestamps_binned_, timestamps_cut_] = from_timestamps_to_binned(DATA, MARKER, neuron, trial, condition, marker, bin, m_time, p_time);
        
        % Bin event markers
        [marker_binned_, marker_cut_] = from_markertime_to_binned(MARKER, neuron, trial, condition, marker, bin, m_time, p_time);
        
        % Store binned data
        timestamps_binned(count, :) = timestamps_binned_;
        timestamps_cut{count, 1} = timestamps_cut_;
        marker_binned(count, :) = marker_binned_;
        marker_cut{count, 1} = marker_cut_;
        
        count = count + 1;
    end
end

% Store binned data and information in output variables
DATA_and_MARKER_binned.timestamps_binned = timestamps_binned;
DATA_and_MARKER_binned.timestamps_cut = timestamps_cut;
DATA_and_MARKER_binned.marker_binned = marker_binned;
DATA_and_MARKER_binned.marker_cut = marker_cut;


info.number_binned_condition = condition;
info.label_binned_condition = info.condition_labels{condition};
delete(h)
disp('Done!')
if nargin==9
    currentDir=pwd;
    parentDir=fileparts(currentDir);
    save([parentDir,'\Data\Data_mat\' info.str_data '_binned_' num2str(info.bin) 'ms_' str_save_append],'DATA_and_MARKER_binned','info')
end
end


