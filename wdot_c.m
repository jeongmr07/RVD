function dw = wdot_c(u)
% global J;
J=[0.091, 0, 0;0, 0.121, 0;0, 0, 0.044];
w = u(1:3);
Td = u(4:6);
T = u(7:9);

dw=inv(J)*(-cross(w,J*w)+T+Td);