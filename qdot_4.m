function dq = qdot_4(u)

q = u(1:4);
w = u(5:7);
 
q = q/norm(q);

Q = [q(3) -q(2) q(1) q(4);
    q(2) q(3) -q(4) q(1);
    -q(1) q(4) q(3) q(2);
    -q(4) -q(1) -q(2) q(3)];
W = [w(1) w(2) w(3) 0]';

dq = 1/2*Q*W;