function [DATA,MARKER,info] = fromH5DFtoDATAandMARKER(str_h5_filename,str_save_append)
%% Function to convert data from an HDF5 file into DATA and MARKER arrays
%% author: Stefano Diomedi
%% date: 21/02/2024
%
%% Inputs:
%   - str_h5_filename: string containing the name of the HDF5 file
%% Outputs:
%   - DATA: cell array containing spike train data
%   - MARKER: cell array containing marker event data
%   - info: structure containing additional information about the data
disp('Converting H5 into DATA and MARKER')
h = waitbar(0, 'Converting H5 into DATA and MARKER:', 'Name', 'Processing');
% Define the path to read marker labels and target labels from
str2read_marker_labels = ['/DATA/unit_01/condition_01/trial_01/event_markers'];
% Retrieve additional information from the HDF5 file
info.str_data=str_h5_filename(1:end-3);
info.number_of_neurons = h5readatt(str_h5_filename, '/DATA', 'Total neurons');
info.number_of_conditions = h5readatt(str_h5_filename, '/DATA', 'Total conditions');
info.marker_labels = h5readatt(str_h5_filename, str2read_marker_labels, 'Marker labels');
info.number_of_marker_events = length(info.marker_labels);
for condition=1:info.number_of_conditions
    str2read_conditions=['/DATA/unit_01/condition_0' num2str(condition)];
    tmp_condition_label{condition}=h5readatt(str_h5_filename, str2read_conditions, 'Target label');
end

info.condition_labels=tmp_condition_label;
% Loop over neurons and conditions to extract data 
for neuron = 1:info.number_of_neurons
    % Display loading bar
    waitbar(neuron/info.number_of_neurons, h, sprintf('Converting H5 into DATA and MARKER: %d%%', round(neuron/info.number_of_neurons*100)));
    for condition = 1:info.number_of_conditions
        % Get the number of trials for the current condition
        number_of_trials = length(h5info(str_h5_filename, ['/DATA/unit_', sprintf('%02d', neuron), '/condition_', sprintf('%02d', condition)]).Groups);
        % Loop over trials to extract spike train and marker event data
        for trial = 1:number_of_trials
            DATA{neuron, condition}{1, trial} = h5read(str_h5_filename, ['/DATA/unit_', sprintf('%02d', neuron), '/condition_', sprintf('%02d', condition), '/trial_', sprintf('%02d', trial), '/spike_trains']);
            MARKER{neuron, condition}{1, trial} = h5read(str_h5_filename, ['/DATA/unit_', sprintf('%02d', neuron), '/condition_', sprintf('%02d', condition), '/trial_', sprintf('%02d', trial), '/event_markers']);
        end
    end
end
delete(h)
disp('Done!')
if nargin==2
    currentDir=pwd;
    parentDir=fileparts(currentDir);
    save([parentDir,'\Data\Data_mat\' info.str_data '_' str_save_append],'DATA','MARKER','info')
end