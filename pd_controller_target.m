function out=pd_controller_target(in)

qe=in(2:4);
w=in(5:7);

J=[0.091, 0, 0;0, 0.121, 0;0, 0, 0.044];

tr = 20; ts = 30; % sec
wn = 1.8/tr;
ze= 4.6/(ts*wn);

K=J*2*wn^2;
C=J*2*ze*wn;

T= K*qe+C*w;

out=-T;