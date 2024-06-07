function dxdt = generate_neuron_model(t, x, pars, conn_matrix)
    % Number of neurons
    num_neurons = size(conn_matrix, 1);
    
    % Initialize state derivatives
    dxdt = zeros(num_neurons * 5, 1);
    
    % Unpack parameters
    GL = pars.gleak;
    GNa = pars.gnamax;
    GK = pars.gkmax;
    GT = pars.gtmax; 
    ENa = pars.ena;
    EK = pars.ek;
    ECa = pars.eca;
    EL = pars.el;
    Cm = pars.cm;
    frq = pars.baseCurrentFrq;
    syn_a = pars.syn_a;
    syn_b = pars.syn_b;
    Gsyn = pars.gsynmax;
    Esyn = pars.esyn;
    noise = pars.noise; % bool
    
    % Iterate over each neuron
    for i = 1:num_neurons
        % Indices for state variables of the ith neuron
        V_idx = (i - 1) * 5 + 1;
        h_idx = V_idx + 1;
        n_idx = V_idx + 2;
        ht_idx = V_idx + 3;
        s_idx = V_idx + 4;
        
        V = x(V_idx);
        h = x(h_idx);
        n = x(n_idx);
        ht = x(ht_idx);
        s = x(s_idx);
        
        % Synaptic current from other neurons
        Isyn = 0;
        for j = 1:num_neurons
            if conn_matrix(j, i) == 1
                V_pre_idx = (j - 1) * 5 + 1; % presynaptic neuron V index
                Isyn = Isyn + Gsyn * s * (Esyn - x(V_pre_idx));
            end
        end
        
        % Applied current
        Iosc = 0;
        if frq ~= 0
            Iosc = (sin(2 * pi * t * frq * (1 + randn*noise) - 1)) * 1e-11;
        end
        Iapp = Iosc + ((rand - 0.5)) * 1e-10 * noise;
        
        % Compute gating variables and their derivatives
        am  = (1e5) * (V + 0.035) / (eps + 1 - exp(-100 * (V + 0.035)));
        bm = 4000 * exp(-1 * (V + 0.06) / (0.018));
        m = am / (am + bm + eps);
        
        ah = 350 * exp(-50 * (V + 0.058));
        bh = 5000 / (1 + exp(-100 * (V + 0.028)));
        dhdt = ah * (1 - h) - bh * h;
        
        an = (5e4) * (V + 0.034) / (eps + 1 - exp(-100 * (V + 0.034)));
        bn = 625 * exp(-12.5 * (V + 0.044));
        dndt = an * (1 - n) - bn * n;
        
        mt = 1 / (1 + exp(-1 * (V + 0.052) / 0.0074));
        ht_ss = 1 / (1 + exp(500 * (V + 0.076)));
        if V < -0.080
            tht = 0.001 * exp(15 * (V + 0.467));
        else
            tht = 0.028 + 0.001 * exp(-(V + 0.022) / 0.0105);
        end
        dhtdt = (ht_ss - ht) / (tht + eps);
        
        % Synaptic gating variable dynamics
        if i > 1
            V_pre_idx = (i - 2) * 5 + 1; % presynaptic neuron V index
            syn_ss = 1 / (1 + exp(-(x(V_pre_idx) + 15e-3) / 0.0064));
            dsdt = syn_a * (1 - s) * syn_ss - syn_b * s;
        else
            dsdt = 0;
        end
        
        % Membrane potential dynamics
        dVdt = (1 / Cm) * (GL * (EL - V) + GNa * (h * m^3) * (ENa - V) + ...
            GK * (n^4) * (EK - V) + GT * (ht * mt^2) * (ECa - V) + ...
            Isyn + eps + Iapp);
        
        % Assign derivatives to the output vector
        dxdt(V_idx) = dVdt;
        dxdt(h_idx) = dhdt;
        dxdt(n_idx) = dndt;
        dxdt(ht_idx) = dhtdt;
        if i > 1
            dxdt(s_idx) = dsdt;
        end
    end
end
