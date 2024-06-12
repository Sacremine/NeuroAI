function out = ca1neuron(t_range, inhibitory, inputSpikes)
    pars.gleak = 10e-9;
    pars.gnamax = 3.6e-6;
    pars.gkmax = 1.6e-6;
    pars.gtmax = 0.22e-6;
    pars.ena = 55e-3;
    pars.ek = -90e-3;
    pars.eca = 120e-3;
    pars.el = -70e-3;
    pars.cm = 100e-12;
    pars.baselinecurrent = 0;
    pars.baseCurrentFrq = 0;
    pars.inputSpikes = inputSpikes;
    pars.tau = 0.03;
    pars.sumWeight = 0.5;
    pars.spikeDelay = 0.05;

    if inhibitory
        pars.baseCurrentFrq = 8;
    end

    t0 = t_range(1);
    tf = t_range(2);

    % Ensure inputSpikes is correctly initialized
    if isempty(pars.inputSpikes)
        pars.inputSpikes = zeros(0,2); % Initialize as an empty nx2 array
    end

    % Read inputs here
    pars.currentsteps = [];
    
    %options = odeset('RelTol',1e-6,'AbsTol',1e-8, 'MaxStep', 1e-4);
    [tout,xout] = ode45(@(t,x) thalamic_rebound(t,x,pars), [t0 tf],[-78e-3; 0;0;0]);

    out = [tout, xout(:,1)];
end