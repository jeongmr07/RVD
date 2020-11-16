function dw = wdot_t(u)
% global J;
J=[0.091, 0, 0;0, 0.121, 0;0, 0, 0.044];
w = u(1:3);

dw=inv(J)*(-cross(w,J*w));