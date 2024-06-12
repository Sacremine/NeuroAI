function spikeTimes = spikes_to_Iapp(tarray, varray, inhibitory)
    % Returns nx2 array, storing spikeTime and corresponding magnitude
    % Magnitude will be either +1 or -1 for excitatory or inhibitory input
    spikeTimes = [];
    if inhibitory
        for i = 2:length(varray)
            if varray(i-1) < 0 && varray(i) > 0
                spikeTimes(end+1,:) = [tarray(i) -1]; %#ok<*AGROW>
            end
        end
    else
        for i = 2:length(varray)
            if varray(i-1) < 0 && varray(i) > 0
                spikeTimes(end+1,:) = [tarray(i) 1]; %#ok<*AGROW>
            end
        end
    end
end

