function LFP = lfpMeasurementRetrofitted(t, n, neuron_outputs)
    % t_range: time range [t_start, t_end]
    % neuron_outputs: cell array where each cell contains a two-column matrix [time, voltage] for each neuron

    %Modified June 11th 2024: Since in the project 3, all the neurons are
    %computed using the same ODE45 function, all the timesteps are the same
    %for every neurons.
    %%
    % % Define the common time array for interpolation
    % common_time = linspace(t_range(1), t_range(2), n);  % Example: 1000 points in the time range
    % 
    % dt = t_range(2) - t_range(1) / n;
    %%
    common_time = t;


    % Preallocate an array to store interpolated voltages
    interpolated_voltages = zeros(length(common_time) - 1, length(neuron_outputs));
    
    % Random distances from the electrode for each CA1 neuron
    distances = rand(1, length(neuron_outputs)) * 0.1 + 0.1; % Random distances between 0.1 and 0.2 meters
    
    %% unnecessary in this case
    % Interpolate each neuron's output to the common time array
    % for i = 1:length(neuron_outputs)
    %     time = neuron_outputs{i}(:, 1); 
    %     voltage = neuron_outputs{i}(:, 2);
    %     interpolated_voltages(:, i) = diff(interp1(time, voltage, common_time, 'linear', 'extrap'))/dt;
    % end
    %%

    % Compute the LFP using the inverse square law
    LFP = zeros(length(interpolated_voltages(:,1)),1);
    for i = 1:length(interpolated_voltages(1,:))
        LFP(:) = LFP(:) + interpolated_voltages(:, i) ./ (distances(i)^2);
    end
    
    %new_time = linspace(t_range(1), t_range(2), length(LFP));
    new_time = linspace(t(1), t(end), length(LFP));

    noisyLFP = arrayfun(@(i) LFP(i) + sin(8*pi*new_time(i)) + 1.3*(randn-0.5), [1:length(new_time)]);

    LFP = noisyLFP;

    % Plot the LFP
    clf
    figure;
    plot(new_time, noisyLFP);
    title('Local Field Potential (LFP)');
    xlabel('Time (s)');
    ylabel('LFP (au)');
end
