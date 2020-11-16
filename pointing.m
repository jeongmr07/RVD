function y = pointing(relFT, relFI, q_t, q_c, cposFI, cvelFI, w_t)
% q = [0 0 0 1]
persistent old_q q_sign;

range = norm(relFT(1:3));

relpos_FI = relFI(1:3);
relvel_FI = relFI(4:6);

mu = 3.986004418*(10^14);
h = cross(cposFI,cvelFI);

% inertial frame¿¡¼­ body frame ³ªÅ¸³¿
xb = relpos_FI/(norm(relpos_FI));
xb = xb/norm(xb);
yb = -h/norm(h);
zb = cross(xb,yb);
zb = zb/norm(zb);

dcmbtoi = [xb yb zb];
dcmitob = inv(dcmbtoi);

if range > 1
    q = dcm2quat(dcmitob);
    y(5:7) = dcmitob*(cross(relpos_FI,relvel_FI)/(norm(relpos_FI)^2));
    y(1:4) = [q(2) q(3) q(4) q(1)];
    if isempty(old_q)
        q_sign = 1;
    else
        if norm(y(1:4)-old_q) > 0.001
            q_z = 1;
        else
            q_z = 0;
        end
        if q_z == 1
            q_sign = -1;
        end
    end
    y(1:4) = y(1:4)*q_sign;
else
    y(1:4) = q_t;
    if norm(y(1:4)-old_q) > 0.001
        q_z = 1;
    else
        q_z = 0;
    end
    if q_z == 1
        q_sign = -1;
    end
y(1:4) = y(1:4)*q_sign;
qt_c = qmult(qinv(q_t),q_c);
% qt_c = qmult(qinv(q_c),q_t);
y(5:7) = quat2dcm2(qt_c)*w_t;
end

old_q = y(1:4);