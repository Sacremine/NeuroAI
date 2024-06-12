function dxdt = thalamic_rebound(t,x, pars)
    V = x(1);
    h = x(2);
    n = x(3);
    ht = x(4);

    GL = pars.gleak;
    GNa = pars.gnamax;
    GK = pars.gkmax;
    GT = pars.gtmax; 
    ENa = pars.ena;
    EK = pars.ek;
    ECa = pars.eca;
    EL = pars.el;
    Cm = pars.cm;
    BL = pars.baselinecurrent;
    frq = pars.baseCurrentFrq;
    inputSpikes = pars.inputSpikes(:,1);
    inputMagnitude = pars.inputSpikes(:,2);
    tau = pars.tau;
    sumWeight = pars.sumWeight;
    spikeDelay = pars.spikeDelay;

    inputCurrent = 0;
    spikeCurrents = [];
    if ~isempty(inputSpikes)
        spikeIndices = find(inputSpikes < (t - spikeDelay) & inputSpikes > (t - 5*spikeDelay));  % Find all spikes before current time
        for idx = spikeIndices'
            spikeTimeDiff = inputSpikes(idx) - (t - spikeDelay);  % This value will be negative
            spikeCurrents(end+1) = exp(spikeTimeDiff / tau) * 1e-9;  % Sum the contributions
        end
    end
    if ~isempty(spikeCurrents)
        inputCurrent = sum(spikeCurrents)*sumWeight/length(spikeCurrents);
    end
    %if ~isempty(inputSpikes)
    %    lastSpikeTimeIndex = find(inputSpikes < t, 1, 'last');        
    %    if ~isempty(lastSpikeTimeIndex)
    %        lastSpikeTime = inputSpikes(lastSpikeTimeIndex);
    %        spikeTimeDiff = lastSpikeTime - t; % this value will be negative
    %        inputCurrent = exp(spikeTimeDiff/0.01) * inputMagnitude(lastSpikeTimeIndex) * 1e-9; % 50ms exponential decay
    %    end
    %end
    
    

    Iosc = 0;
    if frq ~= 0
        Iosc = (sin(2*pi*t*frq)-1)*1e-11;
    end

    Iapp = inputCurrent + Iosc + (randn-0.5)*5e-11;

    if V == -35e-3
        am = 1e3;
    else
        am  = (1e5)*(V + 0.035)/(eps + 1 - exp(-100*(V+0.035)));
    end
    bm = 4000*exp(-1*(V+0.06)/(0.018));
    m = am / (am + bm + eps);
    
    ah = 350*exp(-50*(V+0.058));
    bh = 5000/(1 + exp(-100*(V+0.028)));
    dhdt = ah*(1-h) - bh*h;

    if V == -34e-3
        an = 500;
    else
        an = (5e4)*(V+0.034)/(eps + 1 - exp(-100*(V+0.034)));
    end
    bn = 625*exp(-12.5*(V+0.044));
    dndt = an*(1-n) - bn*n;

    mt = 1/(1 + exp(-1*(V+0.052)/0.0074));

    htss = 1/(1 + exp(500*(V+0.076)));
    if V < -0.080
        tht = 0.001*exp(15*(V+0.467));
    else
        tht = 0.028 + 0.001*exp(-(V+0.022)/0.0105);
    end
    dhtdt = (htss - ht) / (tht + eps);

    dVdt = (1/Cm)*(GL*(EL - V) + GNa*(h*m^3)*(ENa - V) + GK*(n^4)*(EK - V) + GT*(ht*mt^2)*(ECa - V) + eps + Iapp);
 
    dxdt = [ dVdt; dhdt; dndt; dhtdt];
end

