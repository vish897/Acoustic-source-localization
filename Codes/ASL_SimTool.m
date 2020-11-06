%% Acoustic Source Localization Simulation Tool
% ---------------------------------------------------------------------
% A modular simulation toolkit for testing acoustic source localization
% in terrestrial environment. This toolkit is the product of the project
% titled *Acoustic Source Localization Techniques*.
% ---------------------------------------------------------------------
% 
% Creators: Vishva Nilesh Bhate and Mayank Navneet Mehta
% .....................................................................

%% Clearing workspace

close all
clear
clc

fprintf('Welcome to ASL-SimTool\n\n');

%% Environmental configuration

disp('---ENVIRONMENTAL CONFIGURATION---');

fprintf("\nDescribe the terrestrial environment");

T = input('\nRoom temperature (in degree C): ');
if isempty(T)
    disp('Invalid temperature');
    return;
end

P = input('Absolute pressure (in Pascals | at sea-level:101.325e5) : ');
if isempty(P)
    disp('Invalid pressure');
    return;
end

RH = input('Relative humidity in between [0,1]: ');
if isempty(RH) || (RH > 1 || RH < 0)
    disp('Invalid relative humidity');
    return;
end

SNR = input('Noise level (in dB): ');
if isempty(SNR)
    disp('Invalid signal to noise ration');
    return;
end

%% Sensor configuration

fprintf('\n---SENSOR CONFIGURATION---');

fprintf("\nSelect your sensor configuration:\n[1] Right triangle\n[2] Square");

sensor_config = input('\nYour option: ');

if ~isempty(sensor_config)
    if ~(isequal(sensor_config,1) || isequal(sensor_config,2))
        disp('Invalid configuration. Enter number 1 or 2 only.');
        return;
    end
else
    disp('Invalid configuration');
    return;
end

if (sensor_config == 1)
    sens_coord = zeros(2,1);    % sensor coordinate vector
    fprintf('Sensor R is located at the origin (0,0)');
    sens_coord(2) = input('\nEnter the x-coordinate of Q (in m): ');
    sens_coord(1) = input('Enter the y-coordinate of P (in m): ');
elseif (sensor_config == 2)
    sens_coord = zeros(4,3);    % sensor coordinate vector
    fprintf('Sensor C is located at the origin (0,0)');
    fprintf('\nSince it is a square configuration distance between adjacent sensors is same');
    fprintf('\n*A(0,d,0)   *B(d,d,0)');
    fprintf('\n                     ');
    fprintf('\n*C(0,0,0)   *D(d,0,0)');
    size_square = input('\nEnter distance between any two sensors, d(in m): ');
    sens_coord(1,:) = [0 size_square 0];
    sens_coord(2,:) = [size_square size_square 0];
    sens_coord(3,:) = [0 0 0];
    sens_coord(4,:) = [size_square 0 0];
end

Fs = input('Enter the sampling frequency (in Hz): ');
if isempty(Fs)
    disp('Invalid sampling frequency');
    return;
end

N = input('Enter the buffer size (preferable power of 2): ');
if isempty(N)
    disp('Invalid buffer size');
    return;
end

%% Source configuration

fprintf('\n---SOURCE CONFIGURATION---');

F = input('\nEnter the source frequency: ');
if isempty(F)
    disp('Invalid source frequency');
    return;
elseif ~(F < Fs/2)
    disp('WARNING: Nyquist theorem in time domain is not statisfied.');
end

A = input('Enter the source amplitude: ');
if isempty(A)
    disp('Invalid source amplitude');
    return;
end

src_function = input('Source function:\n[1] Sine\n[2] Cosine\nYour option: ');
if ~(src_function == 1 || src_function == 2)
    disp('Invalid source function');
end

if (sensor_config == 1)
    src_coord = zeros(2,1);    % source coordinate vector
    src_coord(1) = input('Enter the x-coordinate of S (in m): ');
    src_coord(2) = input('Enter the y-coordinate of S (in m): ');
elseif (sensor_config == 2)
    src_coord = zeros(3,1);    % source coordinate vector
    src_coord(1) = input('Enter the x-coordinate of S (in m): ');
    src_coord(2) = input('Enter the y-coordinate of S (in m): ');
    src_coord(3) = input('Enter the z-coordinate of S (in m): ');
end

[v,alpha] = get_SoundSpeed(T, P, RH, F);
lambda = v/F;                    % source wavelength
% Validating far-field condition and spatial sampling theorem
if (sensor_config == 1)
    if ~((sens_coord(1) <= lambda/2) && (sens_coord(2) <= lambda/2) )
        disp('WARNING: Nyquist theorem in spatial domain is not statisfied.');
    end
    
    if ~((sqrt(src_coord(1)^2 + src_coord(2)^2) > (2*(sens_coord(1)^2)/lambda))...
  &&(sqrt(src_coord(1)^2 + src_coord(2)^2) > (2*(sens_coord(2)^2)/lambda)))

        disp('Please change the parameters to satisfy the far field condition');
        return;
    end
    
elseif (sensor_config == 2)
    if ~(size_square <= lambda/2)
        disp('WARNING: Nyquist theorem in spatial domain is not statisfied.');
    end
    if ~((sqrt(src_coord(1)^2 + src_coord(2)^2 + src_coord(3)^2)) > (2*(sens_coord(1)^2)/lambda))...
  &&((sqrt(src_coord(1)^2 + src_coord(2)^2 + src_coord(3)^2)) > (2*(sens_coord(2)^2)/lambda))...
  &&((sqrt(src_coord(1)^2 + src_coord(2)^2 + src_coord(3)^2)) > (2*(sens_coord(3)^2)/lambda))
        disp('Please change the parameters to satisfy the far field condition');
        return;
    end
end

clear lambda;       % clearing lambda variable as it is of no use

%% THE SIMULATION

fprintf('\n---SIMULATING---');

% Time instances of sampling; length(n) = N
n = 0:1/Fs:(N-1)/Fs;

% Generating noise
if (sensor_config == 1)
    noise = zeros(3,length(n));
    noise(1,:) = randn(size(n));
    noise(2,:) = randn(size(n));
    noise(3,:) = randn(size(n));
elseif (sensor_config == 2)
    noise = zeros(4,length(n));
    noise(1,:) = randn(size(n));
    noise(2,:) = randn(size(n));
    noise(3,:) = randn(size(n));
    noise(4,:) = randn(size(n));
end


if (sensor_config == 1)    
    % Get attenuation parameters
    [amp_c, amp_a, amp_b] = get_AmpAtten(A, alpha, src_coord,...
                                [0 sens_coord(2);sens_coord(1) 0]); 
    % Get actual time delays
    [t_ac, t_bc] = get_ActualTimeDiff(src_coord, sens_coord, v);
    
    fprintf('\nActual time delay:\nt_pr = %f \nt_qr = %f', t_ac, t_bc);
    
    % Generating signal
    if(src_function == 1)
        % Sine
        x_c = amp_c*sin(2*pi*F*n);
        x_a = amp_a*sin(2*pi*F*(n + t_ac));
        x_b = amp_b*sin(2*pi*F*(n + t_bc));
    elseif (src_function == 2)
        % Cosine
        x_c = amp_c*cos(2*pi*F*n);
        x_a = amp_a*cos(2*pi*F*(n + t_ac));
        x_b = amp_b*cos(2*pi*F*(n + t_bc));
    end
    
    % Adding noise
    x_c = x_c + ((norm(x_c)/norm(noise(1,:))) * 10^(-SNR/20))*noise(1,:);
    x_a = x_a + ((norm(x_a)/norm(noise(2,:))) * 10^(-SNR/20))*noise(2,:);
    x_b = x_b + ((norm(x_b)/norm(noise(3,:))) * 10^(-SNR/20))*noise(3,:);
    
    % Filtering
    x_a_filt = single_freq_filter(x_c);
    x_b_filt = single_freq_filter(x_a);
    x_c_filt = single_freq_filter(x_b);
    
    % TDoA Estimation
    [tau_est_p, tau_est_q] = get_TDoAEstimate(x_a_filt, F, x_b_filt, x_c_filt);
    
    fprintf('\nEstimate time delay:\ntau_est_p = %f \ntau_est_q = %f',...
            tau_est_p, tau_est_q);
    
    % AoA Estimation
    theta_est = get_AoA(sens_coord(1),sens_coord(2),tau_est_p, tau_est_q,v);
    
    fprintf('\nActual angle: %f\nEstimated angle: %f',...
            rad2deg(atan2(src_coord(2),src_coord(1))),theta_est);
    
elseif (sensor_config == 2)
    % Get attenuation parameters
    [amp_c, amp_a, amp_b, amp_d] = get_AmpAtten(A, alpha, src_coord,...
                                [sens_coord(3,1) sens_coord(1,1) sens_coord(2,1) sens_coord(4,1);sens_coord(3,2) sens_coord(1,2) sens_coord(2,2) sens_coord(4,2);sens_coord(3,3) sens_coord(1,3) sens_coord(2,3) sens_coord(4,3)]); 
    % Get actual time delays
    [t_ac, t_bc, t_dc] = get_ActualTimeDiff(src_coord, sens_coord, v);
    
    fprintf('\nActual time delay:\nt_ac = %f \nt_bc = %f \nt_dc = %f', t_ac, t_bc, t_dc);
    
    % Generating signal
    if(src_function == 1)
        % Sine
        x_c = amp_c*sin(2*pi*F*n);
        x_a = amp_a*sin(2*pi*F*(n + t_ac));
        x_b = amp_b*sin(2*pi*F*(n + t_bc));
        x_d = amp_d*sin(2*pi*F*(n + t_dc));
    elseif (src_function == 2)
        % Cosine
        x_c = amp_c*cos(2*pi*F*n);
        x_a = amp_a*cos(2*pi*F*(n + t_ac));
        x_b = amp_b*cos(2*pi*F*(n + t_bc));
        x_d = amp_d*cos(2*pi*F*(n + t_dc));
    end
    
    % Adding noise
    x_c = x_c + ((norm(x_c)/norm(noise(1,:))) * 10^(-SNR/20))*noise(1,:);
    x_a = x_a + ((norm(x_a)/norm(noise(2,:))) * 10^(-SNR/20))*noise(2,:);
    x_b = x_b + ((norm(x_b)/norm(noise(3,:))) * 10^(-SNR/20))*noise(3,:);
    x_d = x_d + ((norm(x_d)/norm(noise(4,:))) * 10^(-SNR/20))*noise(4,:);
    
    % Filtering
    x_a_filt = single_freq_filter(x_a);
    x_b_filt = single_freq_filter(x_b);
    x_c_filt = single_freq_filter(x_c);
    x_d_filt = single_freq_filter(x_d);
    
    %TDoA Estimation
    [tau_est_ac, tau_est_bc, tau_est_dc] = get_TDoAEstimate(x_c_filt, F, x_a_filt, x_b_filt, x_d_filt);
    
    fprintf('\nEstimate time delay:\ntau_est_ac = %f \ntau_est_bc = %f \ntau_est_dc = %f',...
            tau_est_ac, tau_est_bc, tau_est_dc);
    
    % Source coordinates estimation
    [x,y,z] = get_xyz(tau_est_ac, tau_est_bc, tau_est_dc,v,size_square);
    
    fprintf('\nx: %f \ny: %f \nz: %f',...
            x,y,z);
end

