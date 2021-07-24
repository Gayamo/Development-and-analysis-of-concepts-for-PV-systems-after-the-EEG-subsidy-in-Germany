function [Phs,Pg_hom]=hssim(s,Pg_hom,Ppv,Pl,Pbs,Pwp)

%% 1 Uebergabe der Systemparameter

% Heizstab ein/aus
HS = s.HS;
% Minimale Heizstableistung in W
HS_Pmin = s.HS_Pmin;
% Maximale Heizstableistung in W
HS_Pmax = s.HS_Pmax;
% Maximale tägliche Wärmeproduktion ausserhalb der Heizperiode in kWh therm.
HS_Emaxtag = s.HS_Emaxtag;
% Nominale PV-Generatorleistung in kWp
P_PV = s.P_PV;
% Hausverbrauch Strom in kWh
E_LE = s.E_LE;
% WP-Verbrauch Strom in kWh
E_WP = s.E_WP;

%% 2 Zeitschrittsimulation des Heizstabes

    % Heizstab nur wenn eingeschaltet, PV > 0, Eigenverbrauch > 0, WP nicht aktiv 
    if HS == 1  &&  P_PV > 0  &&  E_LE > 0   &&  E_WP == 0 % Heizstab aktiv
    	% Erzeugung Heizstab-Lastprofil in W
    	% Negative Werte im Hausprofil auf 0 stellen
        Phs_max = max(Pg_hom,0);
    	% Werte kleiner als Minimale Leistungsaufnahme auf 0 Stellen
    	Phs_max(Phs_max < HS_Pmin) = 0;
    	% Werte gröser als Maximalleistung auf Maximalleistung stellen
    	Phs_max(Phs_max > HS_Pmax) = s.HS_Pmax; 
      	% Heizstab-Lastprofil realistisch anpassen
     	Phs = Phs_max;
        % Außerhalb der Heizperiode
            for i=129600:393120
            	% Ist die Erzeugung in den 12h vorher gröser als max vorgegeben         
                if sum(Phs((i-721):(i-1)))/60/1000 > HS_Emaxtag
                    Phs(i) = 0;
                end  
            end
        	% Update Hausnetzleistung
          	Pg_hom = Ppv - Pl - Pbs - Pwp - Phs;
   else % Kein Heizstab
            Phs = 0;
   end % Ende Heizsstabberechnung
end
