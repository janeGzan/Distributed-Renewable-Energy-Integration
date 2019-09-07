%RMS Voltage
    %Convert the Voltage Levels to p.u.
        RMS_PU_Inv1                 = RMS_Inv1 / 250;
        RMS_PU_Inv2                 = RMS_Inv2 / 250;
        RMS_PU_Inv3                 = RMS_Inv3 / 250;
        
    %Removing Yuckiness
        %Inv1
            for y = 1:96
                for x = 1:39
                    if RMS_PU_Inv1(y,x) > 2
                        RMS_PU_Cleaned_Inv1(y,x)    = NaN;
                    elseif RMS_PU_Inv1(y,x) < 0
                        RMS_PU_Cleaned_Inv1(y,x)    = NaN;
                    else
                        RMS_PU_Cleaned_Inv1(y,x)    = RMS_PU_Inv1(y,x);
                    end
                end
            end
        %Inv2
            for y = 1:96
                for x = 1:39
                    if RMS_PU_Inv2(y,x) > 2
                        RMS_PU_Cleaned_Inv2(y,x)    = NaN;
                    elseif RMS_PU_Inv2(y,x) < 0
                        RMS_PU_Cleaned_Inv2(y,x)    = NaN;
                    else
                        RMS_PU_Cleaned_Inv2(y,x)    = RMS_PU_Inv2(y,x);
                    end
                end
            end
        %Inv3
            for y = 1:96
                for x = 1:39
                    if RMS_PU_Inv3(y,x) > 2
                        RMS_PU_Cleaned_Inv3(y,x)    = NaN;
                    elseif RMS_PU_Inv3(y,x) < 0
                        RMS_PU_Cleaned_Inv3(y,x)    = NaN;
                    else
                        RMS_PU_Cleaned_Inv3(y,x)    = RMS_PU_Inv3(y,x);
                    end
                end
            end
        
    %Average for Inv 1, 2 & 3
        RMS_PU_Cleaned_Average      = (RMS_PU_Cleaned_Inv1 + RMS_PU_Cleaned_Inv2 + RMS_PU_Cleaned_Inv3) / 3;
            
    %Square Error with Relation to 0
        RMS_ErrorSquared_Inv1       = (RMS_PU_Cleaned_Inv1 - 1).^2;
        RMS_ErrorSquared_Inv2       = (RMS_PU_Cleaned_Inv2 - 1).^2;
        RMS_ErrorSquared_Inv3       = (RMS_PU_Cleaned_Inv3 - 1).^2;
        
%Frequency
    %Convert to p.u.
        Freq_PU_Inv1                = Freq_Inv1 / 50;
        Freq_PU_Inv2                = Freq_Inv2 / 50;
        Freq_PU_Inv3                = Freq_Inv3 / 50;
        
    %Square Error with Relation to 0
        Freq_ErrorSquared_Inv1      = (Freq_PU_Inv1 - 1).^2;
        Freq_ErrorSquared_Inv2      = (Freq_PU_Inv2 - 1).^2;
        Freq_ErrorSquared_Inv3      = (Freq_PU_Inv3 - 1).^2;
        
%Phase
    %Error Squared
        Pha_ErrorSquared_Inv12      = ((Pha_Inv1 - Pha_Inv2) / 180).^2;
        Pha_ErrorSquared_Inv13      = ((Pha_Inv1 - Pha_Inv3) / 180).^2;
        Pha_ErrorSquared_Inv23      = ((Pha_Inv2 - Pha_Inv3) / 180).^2;

%THD (Total Harmonic Distortion)
    %Square the Absolute Error with Relation to 1
        THD_ErrorSquared_Inv1       = THD_Inv1.^2;
        THD_ErrorSquared_Inv2       = THD_Inv2.^2;
        THD_ErrorSquared_Inv3       = THD_Inv3.^2;
    
%Optimisation
    %Sum of Errors Squared
        Inv1_Optimisation           = RMS_ErrorSquared_Inv1 + Freq_ErrorSquared_Inv1 + Pha_ErrorSquared_Inv12 + Pha_ErrorSquared_Inv13 + (THD_ErrorSquared_Inv1 * 0.1);
        Inv2_Optimisation           = RMS_ErrorSquared_Inv2 + Freq_ErrorSquared_Inv2 + Pha_ErrorSquared_Inv12 + Pha_ErrorSquared_Inv23 + (THD_ErrorSquared_Inv2 * 0.1);
        Inv3_Optimisation           = RMS_ErrorSquared_Inv3 + Freq_ErrorSquared_Inv3 + Pha_ErrorSquared_Inv13 + Pha_ErrorSquared_Inv23 + (THD_ErrorSquared_Inv3 * 0.1);

    %Average
        Optimisation_Average        = (Inv1_Optimisation + Inv2_Optimisation + Inv3_Optimisation) / 3;