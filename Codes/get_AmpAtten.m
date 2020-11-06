function [amp_ref, amp_1, amp_2, varargout] = get_AmpAtten(A, alpha, s, rx)
%%
% Function to obtain environmental attenuation parameters
% Input parameters --------------------------------------------------------
%
% A           : amplitude of source
% s           : [2x1] or [3x1] vector of source coordinates
% rx          : [2x2] or [3x2] vector of receiver coordinates.
%
% Output parameters -------------------------------------------------------
%
% amp_ref     : amplitude of signal received at reference node
% amp_1       : amplitude of signal received at node 1
% amp_2       : amplitude of signal received at node 2
% amp_3       : amplitude of signal received at node 3
%--------------------------------------------------------------------------  
 
 nargoutchk(3,4);  
 
 if(nargout == 3)
     amp_ref = A*exp(-alpha*sqrt( s(1)^2  + s(2)^2 ));
     amp_1 = A*exp(-alpha*sqrt( (s(1) - rx(1,1))^2 + (s(2) - rx(2,1))^2 ));
     amp_2 = A*exp(-alpha*sqrt( (s(1) - rx(1,2))^2 + (s(2) - rx(2,2))^2 )); 
 elseif (nargout == 4)
    amp_ref = A*exp(-alpha*sqrt( (s(1) - rx(1,1))^2 + (s(2) - rx(2,1))^2 + (s(3) - rx(3,1))^2 ));
    amp_1 = A*exp(-alpha*sqrt( (s(1) - rx(1,2))^2 + (s(2) - rx(2,2))^2 + (s(3) - rx(3,2))^2 ));
    amp_2 = A*exp(-alpha*sqrt( (s(1) - rx(1,3))^2 + (s(2) - rx(2,3))^2 + (s(3) - rx(3,3))^2 ));
    varargout{1} = A*exp(-alpha*sqrt( (s(1) - rx(1,4))^2 + (s(2) - rx(2,4))^2 + (s(3) - rx(3,4))^2 ));
 end
            
end