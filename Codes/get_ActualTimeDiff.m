function [td_1, td_2, varargout] = get_ActualTimeDiff(s, rx, v)
%%
% Function to obtain actual time delay
% Input parameters --------------------------------------------------------
%
% s           : [2x1] or [3x1] vector of source coordinates
% rx          : [2x1] vector consisting of distance between origin and receiver
%               (in m) or [4x3] vector of receiver coordinates
% v           : speed of sound (in m/s)
%
% Output parameters -------------------------------------------------------
%
% td_1     : TDoA between reference and node 1
% td_2     : TDoA between reference and node 2
% td_3     : TDoA between reference and node 3
%--------------------------------------------------------------------------  
 
 nargoutchk(2,3);  
 
 if(nargout == 2)
     src_ang = atan2(s(2),s(1));
     % equation (3.2)
     td_1 = rx(1)*sin(src_ang)/v;       
     td_2 = rx(2)*cos(src_ang)/v;
 elseif (nargout == 3)
    td_1 = (1/v)*(sqrt((s(1) - rx(1,1))^2 + (s(2) - rx(1,2))^2 + (s(3) - rx(1,3))^2) - sqrt((s(1)-rx(3,1))^2 + (s(2)-rx(3,2))^2 + (s(3)-rx(3,3))^2));
    td_2 = (1/v)*(sqrt((s(1) - rx(2,1))^2 + (s(2) - rx(2,2))^2 + (s(3) - rx(2,3))^2) - sqrt((s(1)-rx(3,1))^2 + (s(2)-rx(3,2))^2 + (s(3)-rx(3,3))^2));
    varargout{1} = (1/v)*(sqrt((s(1) - rx(4,1))^2 + (s(2) - rx(4,2))^2 + (s(3) - rx(4,3))^2) - sqrt((s(1)-rx(3,1))^2 + (s(2)-rx(3,2))^2 + (s(3)-rx(3,3))^2));
 end
            
end