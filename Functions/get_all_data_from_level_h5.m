function [spikes, markers, all_strings] = get_all_data_from_level_h5(filename,str)

% The function extracts the spikes and the markers from a .h5 dataset
%% authors: Francesco E. Vaccari
%% date: 22nd February 2024
%
% INPUT: 
%     filename = a string that identify the h5 file from which extract data
%     str = the group from which extract the data. The function
%     automatically extracts every dataset of the group

% OUTPUT:
%     spikes = contains the extracted spike timing for each dataset
%     markers = contains the extracted marker timing for each dataset
%     all_strings = keeps track of the datasets extracted

% Francesco E. Vaccari 10/2022 


if ~isempty(strfind(str,'trial'))
    lev = 4;
elseif ~isempty(strfind(str,'condition'))
    lev = 3;
elseif ~isempty(strfind(str,'unit'))
    lev = 2;
elseif ~isempty(strfind(str,'DATA'))
    lev = 1;
else
    disp('str is not correct')
end

info = h5info(filename,str);

count = 1;

switch lev
    case 4
        spikes{count} = h5read(filename,[str '/spike_trains']);
        markers{count} = h5read(filename,[str '/events_markers']);

    case 3
        for trial = 1:length(info.Groups)
            str_trial = [str '/trial_' sprintf('%02d',trial)];
            spikes{count} = h5read(filename,[str_trial '/spike_trains']);
            markers{count} = h5read(filename,[str_trial '/events_markers']);
            all_strings{count} = str_trial;
            count = count+1;
        end

    case 2
        str2check = str; %check how many conditions for this unit
        info2check = h5info(filename,str2check);
        num_cond = length(info2check.Groups);
        for cond = 1:length(info.Groups)
            str2check = [str '/condition_' sprintf('%02d',cond)]; %check how many trials for this unit / condition
            info2check = h5info(filename,str2check);
            num_trial = length(info2check.Groups);
            for trial = 1:length(info.Groups(cond).Groups)
                str_trial = [str '/condition_' sprintf('%02d',cond) '/trial_' sprintf('%02d',trial)];
                spikes{count} = h5read(filename,[str_trial '/spike_trains']);
                markers{count} = h5read(filename,[str_trial '/events_markers']);
                all_strings{count} = str_trial;
                count = count+1;
            end
        end

    case 1
        for neu = 1:length(info.Groups)
            str2check = [str '/unit_' sprintf('%02d',neu)]; %check how many conditions for this unit 
            info2check = h5info(filename,str2check);
            num_cond = length(info2check.Groups);
            for cond = 1:num_cond
                str2check = [str '/unit_' sprintf('%02d',neu) '/condition_' sprintf('%02d',cond)]; %check how many trials for this unit / condition
                info2check = h5info(filename,str2check);
                num_trial = length(info2check.Groups);
                for trial = 1:num_trial
                    str_trial = [str '/unit_' sprintf('%02d',neu) '/condition_' sprintf('%02d',cond) '/trial_' sprintf('%02d',trial)];
                    spikes{count} = h5read(filename,[str_trial '/spike_trains']);
                    markers{count} = h5read(filename,[str_trial '/events_markers']);
                    all_strings{count} = str_trial;
                    count = count+1;
                end
            end
        end

end

spikes = spikes'; markers = markers'; all_strings = all_strings';


end