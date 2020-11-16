function uout = MPCController_test(currentx,currentr,t)

persistent Controller

    if t == 0
        % Compute discrete-time dynamics
        parameter = evalin('base','parameter');
        dock = abs(parameter.chaser.chaser_init.sensor(1)) + abs(parameter.target.target_init.dockframe_t(1));
        w = parameter.target.target_init.w_t;

        Aw = [0 0 0 0 0 2*w;
            0 -w^2 0 0 0 0;
            0 0 3*(w^2) -2*w 0 0];

        A = [zeros(3) eye(3); Aw];
        B = [zeros(3); eye(3)];
        C = eye(6);
        D = zeros(6,3);

        [nx, nu] = size(B);
        Ts = 1;%0.05;
        Plant = ss(A,B,C,D);
        Gd = c2d(Plant,Ts);
        Ad = Gd.A;
        Bd = Gd.B;

        % Define data for MPC controller
        po_N = parameter.control.position_ctrl.po_N;
        po_Q = parameter.control.position_ctrl.po_Q;
        po_R = parameter.control.position_ctrl.po_R;
        po_Umax = parameter.control.position_ctrl.po_Umax;
        po_Umin = parameter.control.position_ctrl.po_Umin;

        N = po_N;
        Q = diag(po_Q)*eye(6);
        R = diag(po_R)*eye(3);

        % Avoid explosion of internally defined variables in YALMIP
        yalmip('clear')

        % Setup the optimization problem
        u = sdpvar(repmat(nu,1,N),repmat(1,1,N));
        x = sdpvar(repmat(nx,1,N+1),repmat(1,1,N+1));    
        r = sdpvar(6,1);

        % Define simple standard MPC controller
        % Current state is known so we replace this
        constraints = [];
        objective = 0;

        for k = 1:N

            objective = objective + (r-C*x{k})'*Q*(r-C*x{k}) + u{k}'*R*u{k};

            constraints = [constraints, x{k+1} == Ad*x{k}+Bd*u{k}];
            constraints = [constraints, po_Umin <= u{k} <= po_Umax];
            constraints = [constraints, x{k+1}(1) <= dock];

        end

        % Define an optimizer object which solves the problem for a particular
        % initial state and reference
        Controller = optimizer(constraints,objective,sdpsettings('solver','gurobi'),{x{1},r},u{1});

        % And use it here too
        uout = Controller(currentx,currentr);

    else    
        % Almost no overhead
        uout = Controller(currentx,currentr);
    end