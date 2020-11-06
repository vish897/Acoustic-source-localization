function[x,y,z]=get_xyz(tdoa_a,tdoa_b,tdoa_d,v,d)
%%
% Function to estimate source coordinates for square configuration of the
% sensors
% Input parameters --------------------------------------------------------
%
% tdoa_a        : time difference between A and C
% tdoa_b        : time difference between B and C
% tdoa_d        : time difference between D and C
% d             : Distance between 2 adjacent sensors
% v             : sound speed
%
% Output parameters -------------------------------------------------------
%
% x     : Estimated x-coordinate of the source
% y     : Estimated y-coordinate of the source
% z     : Estimated z-coordinate of the source
%
%--------------------------------------------------------------------------

%Calculating difference between the distance traveled by sound wave from
%source to sensor (From Eq. 4.4, 4.5, 4.6, 4.7)
D_ba=v*(tdoa_b-tdoa_a);
D_bd=v*(tdoa_b-tdoa_d);
D_ac=v*(tdoa_a);
D_dc=v*(tdoa_d);

%Calculating estimated coordinates of source
%(From Eq. 4.14, 4.15, 4.16)
x=D_ba*(D_dc-D_ac)*(d^2+D_ac*D_dc) - D_dc*(D_ba-D_bd)*(d^2-D_ba*D_bd);
x=x/(2*d*(D_bd*D_dc-D_ac*D_ba));
y=(D_dc-D_ac)*(d^2+D_dc*D_ac) + 2*d*D_ac*x;
y=y/(2*d*D_dc);
z=(d^2-2*d*x-D_dc^2)/(2*D_dc);
z=sqrt(z^2-x^2-y^2);