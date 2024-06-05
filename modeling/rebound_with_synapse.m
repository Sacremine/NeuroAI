function dxdt = rebound_with_synapse(t,x, pars)
    V1 = x(1);
    h1 = x(2);
    n1 = x(3);
    ht1 = x(4);

    V2 = x(5);
    h2 = x(6);
    n2 = x(7);
    ht2 = x(8);
    s2 = x(9);

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
    
    Iosc = 0;
    if frq ~= 0
        Iosc = (sin(2*pi*t*frq*(1+randn/60)-1))*1e-11;
    end

    Iapp = Iosc + ((rand-0.5))*1e-10;

    am1  = (1e5)*(V1 + 0.035)/(eps + 1 - exp(-100*(V1 + 0.035)));

    bm1 = 4000*exp(-1*(V1 + 0.06)/(0.018));
    m1 = am1 / (am1 + bm1 + eps);
    
    ah1 = 350*exp(-50*(V1 + 0.058));
    bh1 = 5000/(1 + exp(-100*(V1 + 0.028)));
    dh1dt = ah1*(1-h1) - bh1*h1;

    an1 = (5e4)*(V1 + 0.034)/(eps + 1 - exp(-100*(V1 + 0.034)));
    
    bn1 = 625*exp(-12.5*(V1 + 0.044));
    dn1dt = an1*(1-n1) - bn1*n1;

    mt1 = 1/(1 + exp(-1*(V1 + 0.052)/0.0074));

    ht1ss = 1/(1 + exp(500*(V1 + 0.076)));
    if V1 < -0.080
        tht1 = 0.001*exp(15*(V1 + 0.467));
    else
        tht1 = 0.028 + 0.001*exp(-(V1 + 0.022)/0.0105);
    end
    dht1dt = (ht1ss - ht1) / (tht1 + eps);

    dV1dt = (1/Cm)*(GL*(EL - V1) + GNa*(h1*m1^3)*(ENa - V1) + ...
        GK*(n1^4)*(EK - V1) + GT*(ht1*mt1^2)*(ECa - V1) + ...
        + eps + Iapp);









    am2  = (1e5)*(V2 + 0.035)/(eps + 1 - exp(-100*(V2 + 0.035)));

    bm2 = 4000*exp(-1*(V2 + 0.06)/(0.018));
    m2 = am2 / (am2 + bm2 + eps);
    
    ah2 = 350*exp(-50*(V2 + 0.058));
    bh2 = 5000/(1 + exp(-100*(V2 + 0.028)));
    dh2dt = ah2*(1-h2) - bh2*h2;

    an2 = (5e4)*(V2 + 0.034)/(eps + 1 - exp(-100*(V2 + 0.034)));
    
    bn2 = 625*exp(-12.5*(V2 + 0.044));
    dn2dt = an2*(1-n2) - bn2*n2;

    mt2 = 1/(1 + exp(-1*(V2 + 0.052)/0.0074));

    ht2ss = 1/(1 + exp(500*(V2 + 0.076)));
    if V2 < -0.080
        tht2 = 0.001*exp(15*(V2 + 0.467));
    else
        tht2 = 0.028 + 0.001*exp(-(V2 + 0.022)/0.0105);
    end
    dht2dt = (ht2ss - ht2) / (tht2 + eps);

    syn_ss = 1/(1+exp(-(V1 + 15e-3)/(0.0064)));

    ds2dt = syn_a*(1 - s2)*syn_ss - syn_b*s2;

    dV2dt = (1/Cm)*(GL*(EL - V2) + GNa*(h2*m2^3)*(ENa - V2) + ...
        GK*(n2^4)*(EK - V2) + GT*(ht2*mt2^2)*(ECa - V2) + ...
        Gsyn*s2*(Esyn - V1) + eps + Iapp);



    dxdt = [ dV1dt; dh1dt; dn1dt; dht1dt; 
             dV2dt; dh2dt; dn2dt; dht2dt; 
             ds2dt ];
end