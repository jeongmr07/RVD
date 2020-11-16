function out=error_quaternion(in)

qc=in(1:4);
q=in(5:8);

qe=qmult(qinv(qc),q);
if qe(4) > 0
    qe = qe;
else
    qe = -qe;
end
out=qe(1:3);
