function x_filtered = single_freq_filter(x) 
    N = length(x);               % length of input sequence
    
    x_fft = fft(x);               % performing fft
    
    max_val = max(abs(x_fft)); % finding the maximum amplitude present in fft
    
    % Replacing other frequencies with zero 
    for k = 1:N
        if(abs(x_fft(k)) < max_val)
            x_fft(k) = 0;
        end
    end
    
    % converting back to time domain
    x_filtered = real(ifft(x_fft));
    
end