function out=pd_controller_q(in)

qe=in(1:3);
w=in(4:6);

parameter = evalin('base','parameter');
wn = parameter.control.attitude_ctrl.nf;
ze = parameter.control.attitude_ctrl.dr;
J = parameter.chaser.chaser_init.moi_c;

K=J*wn^2;
C=J*2*ze*wn;

T= K*qe+C*w;

out=-T;
