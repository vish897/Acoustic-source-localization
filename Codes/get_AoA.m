function theta_est = get_AoA(d_pr, d_qr, t_pr, t_qr, v)
%%
% Function to estimate theta - Right Triangle case
% Input parameters --------------------------------------------------------
%
% d_pr          : distance between P and R
% d_qr          : distance between Q and R
% t_pr          : time difference between P and R
% t_qr          : time difference between P and Q
% v             : sound speed
%
% Output parameters -------------------------------------------------------
%
% theta_est     : theta estimate
%
%--------------------------------------------------------------------------

% Calculating theta from t_pr
    theta_est_pr = real(acosd((abs(t_pr)*v)/abs(d_pr)));
    
% Calculating theta from t_qr
    theta_est_qr = real(asind((abs(t_qr)*v)/abs(d_qr)));
    
% Determining quadrant
    if(t_pr > 0 && t_qr > 0)
        % Quadrant I
        theta_est_qr = 90 - theta_est_qr;
        theta_est_pr = 90 - theta_est_pr;
    elseif(t_pr > 0 && t_qr < 0)
        % Quadrant II
        theta_est_qr = 90 + theta_est_qr;
        theta_est_pr = 90 + theta_est_pr;
    elseif(t_pr < 0 && t_qr < 0)
        % Quadrant III
        theta_est_qr = 270 - theta_est_qr;
        theta_est_pr = 270 - theta_est_pr;
    elseif(t_pr < 0 && t_qr > 0)
        % Quadrant IV
        theta_est_qr = 270 + theta_est_qr;
        theta_est_pr = 270 + theta_est_pr;
    end
 
 theta_est = mean([theta_est_pr theta_est_qr]);

end