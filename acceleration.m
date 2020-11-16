    accx = DATA.signal2.signal5.Data(:,1);    
    accy = DATA.signal2.signal5.Data(:,2);
    accz = DATA.signal2.signal5.Data(:,3);
    le = length(accx);
    no = zeros(le,1);
    delv = zeros(le,1);
    Tdelv = zeros(le-1,1);
    delv(1,1) = (no(2,1)-no(1,1))/0.05;
    delv(2,1) = (no(3,1)-no(2,1))/0.05;
    Tdelv(1,1) = delv(1,1);
    for i = 1:le
        n = [accx(i) accy(i) accz(i)];
        no(i,1) = norm(n);
    end
    for i = 1:le-1
        delv(i,1) = (no(i+1,1)-no(i,1))*0.05;
    end
    for i = 1:le-1
        Tdelv(i+1,1) = Tdelv(i,1)+abs(delv(i+1,1));
    end
    figure(1)
    yDa = Tdelv;
    xDa = evalin('base','sim_time');
    plot(xDa,yDa);
    grid on
    figure(2)
    yDa = delv;
    plot(xDa, yDa)
    grid on
%     yDa = no;
%     plot(xDa, yDa)
%     grid on
 