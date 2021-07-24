%% SIMULATIONSMODELL EINER PV-ANLAGE NACH 20 BETRIEBSJAHREN

%% 1 Import der Eingangsdaten

load('Eingangsdaten.mat')

% ppv090: spezifische AC-Leistungsabgabe des PV-Systems mit Ost-Ausrichtung in kW/kWp
% ppv180: spezifische AC-Leistungsabgabe des PV-Systems mit Süd-Ausrichtung in kW/kWp
% ppv270: spezifische AC-Leistungsabgabe des PV-Systems mit West-Ausrichtung in kW/kWp
% pl: spezifische elektrische Leistungsaufnahme der Hauslast in kWh/kWh
% pwp: spezifische elektrische Leistungsaufnahme der Wärmepumpe in kWh/kWh
% pbev: elektrische Energieaufnahme des Elektrofahrzeuges: 1. Spalte = Start Standzeit in Minute des Jahres; 2. Spalte = Prozentuale Ladeenergie der Jahresenergie

%% 2 Definition der unveraenderlichen Systemparameter

% ggf. vorhandene Variable s löschen
clear s
% Simulationszeitschrittweite in min
s.dt=1/60;

% BATTERIESPEICHER (BS)
% Lesistungsaufnahme des Batterisystems in kW
s.P_AC2BAT = 2.5;
% Lesistungsabgabe des Batterisystems in kW
s.P_BAT2AC = 2.5;
% Mittlerer Umwandlungswirkungsgrad des Batteriewechselrichters im Ladebetrieb 
s.eta_ac2bat=0.93;
% Mittlerer Umwandlungswirkungsgrad des Batteriewechselrichters im Entladebetrieb 
s.eta_bat2ac=0.93;
% Mittlerer Umwandlungswirkungsgrad des Batteriespeichers
s.eta_bat = 0.95;

% STROMCLOUD
% Mindest PV-Leistung für Stromcloud in kWp
s.clo_pvmin = 2.5;

% HEIZSTAB (HS)
% Minimale Heizstableistung in W
s.HS_Pmin = 500;
% Maximale Heizstableistung in W
s.HS_Pmax = 4000;
% Maximale tägliche Wärmeproduktion ausserhalb der Heizperiode in kWh therm.
s.HS_Emaxtag = 6;
% Kosten für Erzeugung der Wärme mit Gas/Öl in €/kWh
s.Eur_heiz = 0.065;

% ELEKTROFAHRZEUG (BEV)
% Mittlerer Umwandlungswirkungsgrad des Ladevorgangs in %
s.eta_ac2bev = 0.9;
% Mittlerer Umwandlungswirkungsgrad des Batteriespeichers
s.eta_bat_bev = 0.95;
% Ladeleistung in W
s.P2BEV = 11000;
% Anteil Laden Zuhause in %
s.Crg_hom = 0.8;
% Vebrauch in Wh/km
s.E_BEV_km = 190;

%% 3 Definition der Start- und Endwerte sowie der Schrittweite der zu variierenden Systemparameter

% 01. Variable: Nominale PV-Generatorleistung in kWp
s.P_PV_s = 1; % Startwert
s.P_PV_i = 1; % Schrittweite (engl. increment)
s.P_PV_e = 10; % Endwert
s.P_PV_v = s.P_PV_s : s.P_PV_i : s.P_PV_e; % Vektor mit allen Werten
s.P_PV_n = numel(s.P_PV_v); % Anzahl (engl. number) der Werte

% 02. Variable: Azimut Ausrichtung des PV-Generators in Grad (0°=Norden/180°=Süden)
s.AZI_PV_s = 90; % Startwert
s.AZI_PV_i = 90; % Schrittweite (engl. increment)
s.AZI_PV_e = 270; % Endwert
s.AZI_PV_v = s.AZI_PV_s : s.AZI_PV_i : s.AZI_PV_e; % Vektor mit allen Werten
s.AZI_PV_n = numel(s.AZI_PV_v); % Anzahl (engl. number) der Werte

% 03. Variable: Hausverbrauch Strom in kWh
s.E_LE_s = 0; % Startwert
s.E_LE_i = 1000; % Schrittweite (engl. increment)
s.E_LE_e = 5000; % Endwert
s.E_LE_v = s.E_LE_s : s.E_LE_i : s.E_LE_e; % Vektor mit allen Werten
s.E_LE_n = numel(s.E_LE_v); % Anzahl (engl. number) der Werte

% 04. Variable: Nutzbare Batteriekapazität in kWh
s.E_BAT_s = 0; % Startwert
s.E_BAT_i = 2.5; % Schrittweite (engl. increment)
s.E_BAT_e = 10; % Endwert
s.E_BAT_v = s.E_BAT_s : s.E_BAT_i : s.E_BAT_e; % Vektor mit allen Werten
s.E_BAT_n = numel(s.E_BAT_v); % Anzahl (engl. number) der Werte 

% 05. Variable: Freistrommenge Stromcloud in kWh
s.Eclo_frei_s = 0; % Startwert
s.Eclo_frei_i = 1000; % Schrittweite (engl. increment)
s.Eclo_frei_e = 4000; % Endwert
s.Eclo_frei_v = s.Eclo_frei_s : s.Eclo_frei_i : s.Eclo_frei_e; % Vektor mit allen Werten
s.Eclo_frei_n = numel(s.Eclo_frei_v); % Anzahl (engl. number) der Werte

% 06. Variable: Heizstab ein/aus
s.HS_s = 0; % Startwert
s.HS_i = 1; % Schrittweite (engl. increment)
s.HS_e = 1; % Endwert
s.HS_v = s.HS_s : s.HS_i : s.HS_e; % Vektor mit allen Werten
s.HS_n = numel(s.HS_v); % Anzahl (engl. number) der Werte

% 07. Variable: WP-Verbrauch Strom in kWh
s.E_WP_s = 0; % Startwert
s.E_WP_i = 2000; % Schrittweite (engl. increment)
s.E_WP_e = 6000; % Endwert
s.E_WP_v = s.E_WP_s : s.E_WP_i : s.E_WP_e; % Vektor mit allen Werten
s.E_WP_n = numel(s.E_WP_v); % Anzahl (engl. number) der Werte

% 08. Variable: Jährliche Fahrstrecke in km
s.S_BEV_v = [0 , 8000 , 12000 , 16000]; % Vektor mit allen Werten
s.S_BEV_n = numel(s.S_BEV_v); % Anzahl (engl. number) der Werte

% 09. Variable: Einspeisevergütung in €/kWh
s.Eur_ein_v = [0 , 0.02 , 0.03 , 0.04]; % Vektor mit allen Werten
s.Eur_ein_n = numel(s.Eur_ein_v); % Anzahl (engl. number) der Werte

% 10. Variable: Bezugspreis Strom in €/kWh
s.Eur_bez_s = 0.25; % Startwert
s.Eur_bez_i = 0.05; % Schrittweite (engl. increment)
s.Eur_bez_e = 0.35; % Endwert
s.Eur_bez_v = s.Eur_bez_s : s.Eur_bez_i : s.Eur_bez_e; % Vektor mit allen Werten
s.Eur_bez_n = numel(s.Eur_bez_v); % Anzahl (engl. number) der Werte

% 11. Variable: Laufende Kosten in €/Monat
s.Eur_lau_s = 0; % Startwert
s.Eur_lau_i = 20; % Schrittweite (engl. increment)
s.Eur_lau_e = 80; % Endwert
s.Eur_lau_v = s.Eur_lau_s : s.Eur_lau_i : s.Eur_lau_e; % Vektor mit allen Werten
s.Eur_lau_n = numel(s.Eur_lau_v); % Anzahl (engl. number) der Werte

% 12. Variable: Notwendige einmalige Investitionen in €
s.Eur_inv_v = [0 , 1000 , 3000 , 5000 , 7000 , 10000]; % Vektor mit allen Werten
s.Eur_inv_n = numel(s.Eur_inv_v); % Anzahl (engl. number) der Werte

%% 4 Vorinitialisierung der Ergebnismatrix 

% Gesamtanzahl der zu simulierenden Varianten durch Multiplikation der Anzahl der
% Werte pro Variable ermitteln
n_var = s.P_PV_n * s.AZI_PV_n * s.E_LE_n * s.E_BAT_n * s.Eclo_frei_n * s.HS_n * s.E_WP_n * s.S_BEV_n * s.Eur_ein_n * s.Eur_bez_n * s.Eur_lau_n * s.Eur_inv_n; 

% Anzahl der zu speichernden Ergebnisvariablen 
n_erg = 41;

% Ergebnismatrix vorinitialisieren
ERG = zeros(n_var,n_erg);

%% 5 Durchfuehrung der Parametervariation

% Beginn der Zeitmessung
tic
% Startwert der Laufvariable fuer die Zeilennummer in der Ergebnismatrix
znr = 0;

for v01 = 1 : s.P_PV_n % 1. Variable
    
   for v02 = 1 : s.AZI_PV_n % 2. Variable
    
        for v03 = 1 : s.E_LE_n % 3. Variable 
        
            for v04 = 1 : s.E_BAT_n % 4. Variable
                    
                for v05 = 1 : s.Eclo_frei_n % 5. Variable
              
                    for v06 = 1 : s.HS_n % 6. Variable
                            
                        for v07 = 1 : s.E_WP_n % 7. Variable
                          
                            for v08 = 1 : s.S_BEV_n % 8. Variable
                              
                                for v09 = 1 : s.Eur_ein_n % 9. Variable
                                        
                                    for v10 = 1 : s.Eur_bez_n % 10. Variable
                                               
                                        for v11 = 1 : s.Eur_lau_n % 11. Variable
                                                
                                            for v12 = 1 : s.Eur_inv_n % 12. Variable
                                               
                % Zeilennummer bei jedem weiteren Simulationsdurchlauf um den Wert 1 erhoehen
                znr = znr + 1;
                
                % ANPASSEN DER SYSTEMPARAMETER
                % 01. Variable: Nominale PV-Generatorleistung in kWp
                s.P_PV = s.P_PV_v(v01);
                % 02. Variable: 
                s.AZI_PV = s.AZI_PV_v(v02);
                % 03. Variable: Elektrischer Verbrauch in kWh/a
                s.E_LE = s.E_LE_v(v03);
                % 04. Variable: Nutzbare Batteriekapazität in kWh
                s.E_BAT = s.E_BAT_v(v04);
                % 05. Variable: Stromcloud
                s.Eclo_frei = s.Eclo_frei_v(v05);
                % 06. Variable: Heizstab
                s.HS = s.HS_v(v06);
                % 07. Variable: Stromverbrauch WP
                s.E_WP = s.E_WP_v(v07);
                % 08. Variable: Fahrstrecke BEV
                s.S_BEV = s.S_BEV_v(v08);
                % 09. Variable: Einspeisevergütung in ct/kWh
                s.Eur_ein = s.Eur_ein_v(v09);
                % 10. Variable: Bezugspreis Strom in €/kWh
                s.Eur_bez = s.Eur_bez_v(v10);
                % 11. Variable: Laufende Kosten in €/Monat
                s.Eur_lau = s.Eur_lau_v(v11);
                % 12. Variable: Notwendige Investitionen in €
                s.Eur_inv = s.Eur_inv_v(v12);
                
                % ZUWEISUNG UND NORMIERUNG DER EINGANGSZEITREIHEN
                % Auswahl Erzeugungsprofil des PV-Generators
                if s.AZI_PV == 90 % Ostausrichtung
                    ppv = ppv090; % Zuweisung Erzeugungsprofil für Ostausrichtung
                elseif s.AZI_PV == 180 % Südausrichtung
                    ppv = ppv180; % Zuweisung Erzeugungsprofil für Südausrichtung
                elseif s.AZI_PV == 270 % Westausrichtung
                    ppv = ppv270; % Zuweisung Erzeugungsprofil für Westausrichtung
                else
                    break
                end 
                % Ausgangsleistung des PV-Systems in W 
                Ppv = ppv * 1000 * s.P_PV;
                % Zuweisung der Hauslast elektrisch in W
                Pl = pl * 1000 * s.E_LE * 60;
                % Zuweisung Last WP in W
                if s.E_WP > 0 % Wenn WP vorhanden
                    Pwp = pwp * 1000 * s.E_WP * 60;
                else % Keine WP
                    Pwp = 0;
                end 
                % Erzeugung Lastprofil BEV in W
                if s.S_BEV > 0 % Wenn BEV vorhanden 
                                  E_bev_hom = (s.S_BEV * s.E_BEV_km * s.Crg_hom)/(s.eta_ac2bev * s.eta_bat_bev); % Jahresbedarf zuhause in Wh mit Anpassung an Wirkungsgrade des Landevorgangs und Speichern
                                  start_bev_hom = pbev(:, 1); % Start standzeiten in Minute des Jahres
                                  lng_bev = length(start_bev_hom);
                                  bedarf_bev_hom = round(pbev(:, 2) * E_bev_hom * 60,1); % Bedarf pro Standzeit in kWmin
                                  Pbev(1:525600,1) = 0; % Leistung auf 0 stellen
                                  for i_bev = 1:lng_bev
                                        min_Pbev_hom = bedarf_bev_hom(i_bev)/s.P2BEV;
                                        min_Pbev_hom_r = floor(min_Pbev_hom); % Minuten mit voller Ladeleistung
                                        Pbev(start_bev_hom(i_bev) : start_bev_hom(i_bev)+(min_Pbev_hom_r-1)) = s.P2BEV; % Zuweisung Minuten mit voller Ladeleistung
                                        Pbev(start_bev_hom(i_bev)+min_Pbev_hom_r) = (min_Pbev_hom-min_Pbev_hom_r)*s.P2BEV; % Zuweisung Minuten mit restlicher Ladeleistung
                                  end
                else % Kein BEV
                                  E_bev_hom = 0; % Jahresbedarf zuhause
                                  Pbev = 0; %  Lastprofil BEV
                end % Ende erzeugung Lastprofil BEV
                
                % DIFFERENZLEISTUNG DER LASTEN ZUR PV LEISTUNG IN W
                % Nach Hauslast
                if s.E_LE > 0
                    Ppv_pl = Ppv - Pl; % PV Leistung nach Hauslast in W
                    P2l = Ppv_pl; % Anderweitiger Leistungsbezug der Hauslast in W
                    P2l(P2l > 0) = 0; % positive Werte auf 0 stellen
                    Ppv_pl(Ppv_pl < 0) = 0; % negative Werte auf 0 stellen
                    Epv2l = sum(min(Ppv,Pl))/60/1000; % PV-Direktversorgung Hauslast in kWh
                else
                    Ppv_pl = Ppv; % PV Leistung nach Hauslast
                    P2l = 0; % Anderweitiger Leistungsbezug der Hauslast
                    Epv2l = 0; % PV-Direktversorgung Hauslast
                end
                % Nach Wärmepumpe
                if s.E_WP > 0
                    Ppv_wp = Ppv_pl - Pwp; % PV Leistung nach Hauslast und WP in W
                    P2wp = Ppv_wp; % Anderweitiger Leistungsbezug der WP in W
                    P2wp(P2wp > 0) = 0; % positive Werte auf 0 stellen
                    Ppv_wp(Ppv_wp < 0) = 0; % negative Werte auf 0 stellen
                    Epv2wp = sum(min(Ppv_pl,Pwp))/60/1000; % PV-Direktversorgung WP in kWh
                else
                    Ppv_wp = Ppv_pl; % PV Leistung nach Hauslast und WP
                    P2wp = 0; % Anderweitiger Leistungsbezug der WP
                    Epv2wp = 0; % PV-Direktversorgung WP
                end
                % Nach Elektrofahrzeug
                if s.S_BEV > 0
                    Ppv2bev = min(Ppv_wp,Pbev); % PV-Direktversorgung BEV in W
                    Epv2bev = sum(Ppv2bev)/60/1000; % PV-Direktversorgung BEV in kWh
                else
                    Ppv2bev = 0; % PV-Direktversorgung BEV in W
                    Epv2bev = 0; % PV-Direktversorgung BEV in kWh
                end
                % Differenzleisung in W
                Pd = Ppv - Pl - Pwp - Ppv2bev;
                
                % SIMULATION DES BATTERIESYSTEMS
                % Aufruf des Simulationsmodells Batteriesystem
                [Pbs,Pbat,soc ] = bssim(s,Pd);
                % Durchschnittlicher Ladeszustand Batteriespeichers in %
                soc_dur = mean(soc)*100;
                
                % BESTIMMUNG DER HAUSNETZLEISTUNG IN W
                Pg_hom = Ppv - Pl - Pwp - Pbs - Ppv2bev;
                
                % SIMULATION DES HEIZSTABES
                % Aufruf des Simulationsmodells Heizstab
                [Phs,Pg_hom ] = hssim(s,Pg_hom,Ppv,Pl,Pbs,Pwp);
                
                % ENERGIESUMMEN
                % Elektrischer Energieverbrauch im Haus in kWh
                El = sum(Pl)/60/1000;
                % AC-Energieabgabe des PV-Systems in kWh
                Epv = sum(Ppv)/60/1000;
                % AC-Energieaufnahme des Batteriesystems in kWh
                Eac2bs = sum(max(0,Pbs))/60/1000;
                % DC-Energieaufnahme des Batteriespeichers in kWh
                Ebatin = sum(max(0,Pbat))/60/1000;
                % DC-Energieabgabe des Batteriespeichers in kWh
                Ebatout = sum(abs(min(0,Pbat)))/60/1000;
                % AC-Energieabgabe des Batteriesystems in kWh
                Ebs2ac = sum(abs((min(0,Pbs))))/60/1000;
                % AC-Energieaufnahme des Heizstabs in kWh
                Epv2hs = sum(Phs)/60/1000;
                % AC-Energieaufnahme der WP in kWh
                Ewp = sum(Pwp)/60/1000;
                % AC-Energieaufnahme des BEV zuhause in kWh
                Ebev = sum(Pbev)/60/1000;
                % Netzeinspeisung in kWh
                Eac2g = sum(max(0,Pg_hom))/60/1000;
                % Netzbezug in kWh
                Eg2ac = sum(abs((min(0,Pg_hom))))/60/1000 + (Ebev - Epv2bev);
                % Bezug aus öffentlchem Netz
                % Leistungsabgabe Batteriesystem in W
                Pbs2ac = Pbs;
                Pbs2ac(Pbs2ac > 0) = 0; % positive Werte auf 0 stellen
                Pbs2ac = abs(Pbs2ac);
                % Batteriesystemleistung nach Hauslast in W
                Pbs_l = Pbs2ac + P2l;
                % Netzbezug für Hauslast
                Pg2l = Pbs_l;
                Pg2l(Pg2l > 0) = 0; % positive Werte auf 0 stellen
                Pbs_l(Pbs_l < 0) = 0; % negative Werte auf 0 stellen
                % Netzbezug für WP
                if s.E_WP > 0
                    Pg2wp = P2wp + Pbs_l;
                else
                    Pg2wp = 0;
                end
                % Netzbezug für Hauslast in kWh
                Eg2l = sum(abs(Pg2l))/60/1000;
                % Netzbezug für WP in kWh
                Eg2wp = sum(abs(Pg2wp))/60/1000;
                % Netzbezug für BEV in kWh
                Eg2bev = Ebev - Epv2bev;
                % Nutzung Batteriesystem
                % Batterienutzung Hauslast in kWh
                Ebs2l =  El - Epv2l - Eg2l;
                % Batterienutzung WP in kWh
                Ebs2wp =  Ewp - Epv2wp - Eg2wp;
                
                % SIMULATION DER STROMCLOUD 
                % Aufruf des Simulationsmodells Heizstab
                [E2clo,Eclo2l,Eg2l,Eclo2wp,Eg2wp,Eclo2bev,Eg2bev,Eac2g,Eg2ac] = clsim(s,Eac2g,Eg2ac,Eg2l,Eg2wp,Eg2bev);
                
                % WIRTSCHAFTLICHE BETRACHTUNG
                % Eingespartes Kapital durch Selbstverbrauch in €/a
                Eur_s_bez = (Epv2l + Epv2wp + Ebs2ac + E2clo + Epv2bev) * s.Eur_bez;  
                % Eingespartes Kapital mit Heizstab in €/a
                Eur_s_hs = Epv2hs * s.Eur_heiz;
                % Erwirtschaftetes Kapital durch Einspeisung in €/a
                Eur_w_ein = Eac2g * s.Eur_ein;
                
                % ENERGETISCHE BETRACHTUNG
                % Direktversorgung mit PV in kWh
                Epvdir = Epv2l + Epv2wp + Epv2bev + Epv2hs;
                % Versorgung über Zwischenspeicheung mit PV in kWh
                Epvsp = Eac2bs + E2clo;
                % Autarkiegrad ermitteln
                a = (Epv2l + Epv2wp + Epv2bev + Ebs2ac + Eclo2l + Eclo2wp + Eclo2bev)/(El + Ewp + Ebev);
                a(isnan(a)) = 0; % NaN auf 0 stellen
                a(a == -Inf) = 0; % -Inf auf 0 stellen
                % Eigenverbrauchsanteil ermitteln
                e = (Epv2l + Epv2wp + Epv2bev + Eac2bs + E2clo + Epv2hs)/Epv;
                e(isnan(e)) = 0; % NaN auf 0 stellen
                % Speziefischer Ertrag des PV-Systems in kWh/kWp
                Espez = Epv/s.P_PV;
                Espez(isnan(Espez)) = 0; % NaN auf 0 stellen
                
                % ZUSAMMENFASSUNG DER ERGEBNISSE
                % Veränderbare Systemparameter sowie Ergebnisvariablen in der Ergebnismatrix speichern
                % Zeilennummer:    1      2          3        4        5          6          7        8        9         10            11            12           13      14      15      16      17       18       19       20        21      22      23      24       25       26      27        28        29        30      31     32      33       34       35       36      37      38       39          40          41     
                ERG(znr,1:n_erg)=[znr , s.P_PV , s.AZI_PV, s.E_LE , s.E_BAT , s.Eclo_frei , s.HS , s.E_WP , s.S_BEV , s.Eur_ein , s.Eur_bez*100 , s.Eur_lau , s.Eur_inv , Epv , Epvdir , Epv2l , Epv2hs , Epv2wp , Epv2bev , Epvsp , Eac2bs , E2clo , Eac2g , Ebs2ac , Ebs2l , Ebs2wp , Eclo2l , Eclo2wp , Eclo2bev , Eg2ac , Eg2l , Eg2wp , Eg2bev , Espez , soc_dur , a*100 , e*100 , Ebev , Eur_s_bez , Eur_w_ein , Eur_s_hs ];
                
                                                
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end 
            end
        end
    end
end          



% Ende der Zeitmessung
toc

%% 4 Speicherung der Ergebnisse
save('Ergebnisse.mat','ERG')
