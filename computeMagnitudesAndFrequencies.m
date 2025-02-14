function [unique_magnitudes, frequencies] = computeMagnitudesAndFrequencies(complex_array)
    % calculate magnitudes of the complex array
    magnitudes = abs(complex_array);
    
    % find unique magnitudes
    unique_magnitudes = unique(magnitudes);
    
    % calculate frequency for each magnitude
    frequencies = zeros(size(unique_magnitudes));
    for i = 1:length(unique_magnitudes)
        
        frequencies(i) = sum(magnitudes == unique_magnitudes(i));
    end
    frequencies = frequencies/length(complex_array);
end