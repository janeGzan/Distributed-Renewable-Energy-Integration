%Counter Clear
    x           = 1;
    y           = 1;

%Constants (Kone's Constant)
    dK          = 0.403972753299517;

%Inputs
    Vrms        = 250;
    P           = 1000;
    fdes        = 50;
    
    Rnpu        = 0.1;
    Lnpu        = 0.1;
    
    Ms          = 1:0.5:20;
    
    for Qf      = 1:0.2:20
        %Natural to Frequency
            syms fnet
            wosc        = 2 * pi * fdes;

        %RLC Oscillator
            Rosc        = Vrms^2 / P;
            Losc        = Vrms^2 / (wosc * P * Qf);
            Cosc        = (P * Qf) / (wosc * Vrms^2);

        %RL Network Branch
            Rnet        = (Vrms^2 * Rnpu) / P;
            Lnet        = (Vrms^2 * Lnpu) / (P * wosc);

        %System Impedance Magnitude
            zsymconj    = ((fnet^2 * fdes^2 * (fnet^2 * Lnpu^2 + fdes^2 * Qf^2 * Rnpu^2) * Vrms^4)/(P^2 * (fnet^4 * fdes^2 * Lnpu^2 + fnet^2 * (fnet^2 * Lnpu - fdes^2 * (1 + Lnpu))^2 * Qf^2 + 2 * fnet^2 * fdes^4 * Qf^2 * Rnpu + fdes^2 * Qf^2 * (fnet^2 * fdes^2 + (fnet^2 - fdes^2)^2 * Qf^2) * Rnpu^2)));

        %Differentiate zsymconj, Find Root & Then Use Root to find Max
            cond1a      = diff(zsymconj)==0;
            cond1b      = fnet > 0;
            condac      = fnet < 10^18;

            cond        = [cond1a cond1b condac];

            zsysDifRoot = real(vpa(solve(cond,fnet)));
            zsysSupr    = double((zsysDifRoot^2 * fdes^2 * (zsysDifRoot^2 * Lnpu^2 + fdes^2 * Qf^2 * Rnpu^2) * Vrms^4) / (P^2 * (zsysDifRoot^4 * fdes^2 * Lnpu^2 + zsysDifRoot^2 * (zsysDifRoot^2 * Lnpu - fdes^2 * (1 + Lnpu))^2 * Qf^2 + 2 * zsysDifRoot^2 * fdes^4 * Qf^2 * Rnpu + fdes^2 * Qf^2 * (zsysDifRoot^2 * fdes^2 + (zsysDifRoot^2 - fdes^2)^2 * Qf^2) * Rnpu^2)));

        %Slope Upper Limit & Slope Itself
            k           = double(Ms / zsysSupr);

        %Find Delta
            del         = dK * Vrms * sqrt(2);

        %Johnsons Epsilon
            epsil(y,:) = sqrt(Losc / Cosc) * (k - (1 / Rosc));
            y           = y+1;
    end