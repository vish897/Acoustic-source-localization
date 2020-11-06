function [sound_speed, alpha] = get_SoundSpeed(T, P, RH, f)
%%
% Function to obtain speed of sound
% Input parameters --------------------------------------------------------
%
% T           : room temperature in degree C
% P           : pressure in Pascals
% RH          : relative humidity as fraction. 0 <= RH <= 1.
%
% Output parameters -------------------------------------------------------
%
% alpha       : attenuation parameter
% velo        : velocity of sound in air
%
%--------------------------------------------------------------------------
 
 % Calculating viscosity (Sutherland's Law of Viscosity)
 eta = (1.716e-5 * (273.15/T+273.15)^(3/2)) * (383.55/(T + 383.55));
 
 % Calculating air density
    % Calculating water vapour pressure (Herman Wobus' Equation)
    c = [0.99999683 -0.90826951e-2 0.78736169e-4 -0.61117958e-6 0.43884187e-8 ...
        -0.29883885e-10 0.21874425e-12 -0.17892321e-14 0.11112018e-16 ...
        -0.30994571e-19];
    p = (c(1)+T*(c(2)+T*(c(3)+T*(c(4)+T*(c(5)+T*(c(6)+T*(c(7)+T*(c(8)+T*(c(9)+T*(c(10)))))))))));
    
    Pv = RH * (6.1078/(p^8));   % mb
    Pv = Pv*100;                % pascal
 
 Pd = P - Pv;
 rho = (Pd/(287.05*(T+273.25))) + (Pv/(461.495*(T+273.25)));
 
 % Calculating speed of sound
 sound_speed = 331.1*sqrt(1 + (T/273.15));

 % Calculating attenuation coefficient
 alpha = (2*eta*(2*pi*f)^2)/(3*rho*(sound_speed^3));
 
end