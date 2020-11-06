function [varargout] = get_TDoAEstimate(x_ref, F, varargin)
%%
% Function to obtain TDoA estimates using Hilbert Transform
% Input parameters --------------------------------------------------------
%
% x_ref       : Signal wrt which time difference is to be calculated
% F           : Center frequency
% x_n         : nth signal
% 
% *Note: * All the input signals are row vectors
% 
% Output parameters -------------------------------------------------------
%
% t_n         : time difference of arrival between reference signal and
%               nth input signal
%--------------------------------------------------------------------------

 if(nargin < 1)
     disp('INVALID number of input signals');
     return;
 end
 
 if(nargout ~= nargin-2)
    disp('Invalid number of input signals and output delays.');
    return;
 end
 
 varargout = cell(1,nargout);
 
 x_ref_ht = imag(hilbert(x_ref));
 b = (x_ref_ht.')/(x_ref_ht*(x_ref_ht.'));
 
 for k = 1:nargin-2     
    % equation (3.16)
    varargout{k} = ...
            (1/(2*pi*F))*asin(-(varargin{k}*b));
 end
end