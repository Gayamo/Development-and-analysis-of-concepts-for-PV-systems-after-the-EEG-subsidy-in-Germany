function [E2clo,Eclo2l,Eg2l,Eclo2wp,Eg2wp,Eclo2bev,Eg2bev,Eac2g,Eg2ac] = clsim(s,Eac2g,Eg2ac,Eg2l,Eg2wp,Eg2bev)

%% 1 Uebergabe der Systemparameter

% Freistrommenge Stromcloud in kWh
Eclo_frei = s.Eclo_frei;
% Mindest PV-Leistung für Stromcloud in kWp
clo_pvmin = s.clo_pvmin;
% Nominale PV-Generatorleistung in kWp
P_PV = s.P_PV;
% Nutzbare Batteriekapazität in kWh
E_BAT = s.E_BAT;
% WP-Verbrauch Strom in kWh
E_WP = s.E_WP;
% Jährliche Fahrstrecke in km
S_BEV = s.S_BEV;

%% 2 Simulation der Stromcloud

% Stromcloud nur aktiv wenn Batteriespeicher vorhanden und der Wert für Mindest PV-Leistung für Stromcloud erreicht
                if  Eclo_frei > 0  &&  E_BAT > 0  &&  P_PV >= clo_pvmin
                    Eclo_erg = Eac2g - Eg2ac; % Energiebilanz der Stromcloud in kWh
                                  
                     if Eclo_frei >= Eg2ac % Unter der Freistrommenge geblieben
                         
                                      if Eclo_erg >= 0 % Positive Stromcloudbilanz
                                          
                                                          E2clo = Eg2ac; % Einspeisung in die Stromcloud in kWh
                                                          Eac2g = Eclo_erg; % Manipulation der Netzeinspeisung in kWh
                                                          Eg2ac = 0; % Manipulation des Netzbezugs in kWh
                                  
                                              if E_WP == 0 && S_BEV == 0 % wenn keine WP und BEV aktiv
                                                          
                                                          Eclo2l = E2clo; % Stromcloudbezug für die Hauslast in kWh
                                                          Eg2l = 0; % Netzbezug für die Hauslast in kWh
                                                          Eclo2wp = 0; % Stromcloudbezug für die WP in kWh
                                                          Eg2wp = 0; % Netzbezug für die WP in kWh
                                                          Eclo2bev = 0; % Stromcloudbezug für das BEV in kWh
                                                          Eg2bev = 0; % Netzbezug für das BEV in kWh
                                                           
                                              elseif E_WP > 0 && S_BEV == 0 % wenn WP aktiv ohne BEV
                                                 
                                                          Eclo2l = Eg2l; % Stromcloudbezug für die Hauslast in kWh
                                                          Eg2l = 0; % Netzbezug für die Hauslast in kWh
                                                          Eclo2wp = Eg2wp; % Stromcloudbezug für die WP in kWh
                                                          Eg2wp = 0; % Netzbezug für die WP in kWh
                                                          Eclo2bev = 0; % Stromcloudbezug für das BEV in kWh
                                                          Eg2bev = 0; % Netzbezug für das BEV in kWh
                                                          
                                              
                                              elseif E_WP == 0 && S_BEV > 0 % wenn BEV aktiv ohne WP
                                                          
                                                          Eclo2l = Eg2l; % Stromcloudbezug für die Hauslast in kWh
                                                          Eg2l = 0; % Netzbezug für die Hauslast in kWh
                                                          Eclo2wp = 0; % Stromcloudbezug für die WP in kWh
                                                          Eg2wp = 0; % Netzbezug für die WP in kWh
                                                          Eclo2bev = Eg2bev; % Stromcloudbezug für das BEV in kWh
                                                          Eg2bev = 0; % Netzbezug für das BEV in kWh
                                              
                                              elseif E_WP > 0 && S_BEV > 0 % wenn WP und BEV aktiv
                                                  
                                                          Eclo2l = Eg2l; % Stromcloudbezug für die Hauslast in kWh
                                                          Eg2l = 0; % Netzbezug für die Hauslast in kWh
                                                          Eclo2wp = Eg2wp; % Stromcloudbezug für die WP in kWh
                                                          Eg2wp = 0; % Netzbezug für die WP in kWh
                                                          Eclo2bev = Eg2bev; % Stromcloudbezug für das BEV in kWh
                                                          Eg2bev = 0; % Netzbezug für das BEV in kWh
                                                  
                                              end
                                                          
                                      else % Negative Stromcloudbilanz
                                                          
                                                          E2clo = Eac2g; % Einspeisung in die Stromcloud in kWh 
                                                          
                                              if E_WP == 0 && S_BEV == 0 % wenn keine WP und BEV aktiv
                                                  
                                                          Eclo2l = Eg2ac; % Stromcloudbezug für die Hauslast in kWh
                                                          Eg2l = 0; % Netzbezug für die Hauslast in kWh
                                                          Eclo2wp = 0; % Stromcloudbezug für die WP in kWh
                                                          Eg2wp = 0; % Netzbezug für die WP in kWh
                                                          Eclo2bev = 0; % Stromcloudbezug für das BEV in kWh
                                                          Eg2bev = 0; % Netzbezug für das BEV in kWh
                                                          
                                                          Eac2g = 0; % Manipulation der Netzeinspeisung in kWh
                                                          Eg2ac = 0; % Manipulation des Netzbezugs in kWh
                                                          
                                              elseif E_WP > 0 && S_BEV == 0 % wenn WP aktiv ohne BEV 
                                                 
                                                          Eclo2l = Eg2l; % Stromcloudbezug für die Hauslast in kWh
                                                          Eg2l = 0; % Netzbezug für die Hauslast in kWh
                                                          Eclo2wp = Eg2wp; % Stromcloudbezug für die WP in kWh
                                                          Eg2wp = 0; % Netzbezug für die WP in kWh
                                                          Eclo2bev = 0; % Stromcloudbezug für das BEV in kWh
                                                          Eg2bev = 0; % Netzbezug für das BEV in kWh
                                                          
                                                          Eac2g = 0; % Manipulation der Netzeinspeisung in kWh
                                                          Eg2ac = 0; % Manipulation des Netzbezugs in kWh
                                                          
                                              elseif E_WP == 0 && S_BEV > 0 % wenn BEV aktiv ohne WP
                                                          
                                                          Eclo2l = Eg2l; % Stromcloudbezug für die Hauslast in kWh
                                                          Eg2l = 0; % Netzbezug für die Hauslast in kWh
                                                          Eclo2wp = 0; % Stromcloudbezug für die WP in kWh
                                                          Eg2wp = 0; % Netzbezug für die WP in kWh
                                                          Eclo2bev = Eg2bev; % Stromcloudbezug für das BEV in kWh
                                                          Eg2bev = 0; % Netzbezug für das BEV in kWh
                                                          
                                                          Eac2g = 0; % Manipulation der Netzeinspeisung in kWh
                                                          Eg2ac = 0; % Manipulation des Netzbezugs in kWh
                                                  
                                              
                                              elseif E_WP > 0 && S_BEV > 0 % wenn WP und BEV aktiv
                                                  
                                                          Eclo2l = Eg2l; % Stromcloudbezug für die Hauslast in kWh
                                                          Eg2l = 0; % Netzbezug für die Hauslast in kWh
                                                          Eclo2wp = Eg2wp; % Stromcloudbezug für die WP in kWh
                                                          Eg2wp = 0; % Netzbezug für die WP in kWh
                                                          Eclo2bev = Eg2bev; % Stromcloudbezug für das BEV in kWh
                                                          Eg2bev = 0; % Netzbezug für das BEV in kWh
                                                          
                                                          Eac2g = 0; % Manipulation der Netzeinspeisung in kWh
                                                          Eg2ac = 0; % Manipulation des Netzbezugs in kWh
                                              
                                              end
                                      end
                             
                             
                             
                     else % Über Freistrommenge 
                         
                                     if Eclo_erg >= 0 % Positive Stromcloudbilanz
                                                          
                                                          E2clo = Eclo_frei; % Einspeisung in die Stromcloud in kWh 
                                                          Eac2g = Eac2g - Eclo_frei; % Manipulation der Netzeinspeisung in kWh
                                                          Eg2ac = Eg2ac - Eclo_frei; % Manipulation des Netzbezugs in kWh
                                                            
                                              if E_WP == 0 && S_BEV == 0 % wenn keine WP und BEV aktiv
                                 
                                                          Eclo2l = Eclo_frei; % % Stromcloudbezug für die Hauslast in kWh
                                                          Eg2l = Eg2ac; % Netzbezug für die Hauslast in kWh
                                                          Eclo2wp = 0; % Stromcloudbezug für die WP in kWh
                                                          Eg2wp = 0; % Netzbezug für die WP in kWh
                                                          Eclo2bev = 0; % Stromcloudbezug für das BEV in kWh
                                                          Eg2bev = 0; % Netzbezug für das BEV in kWh
                                                          
                                              elseif E_WP > 0 && S_BEV == 0 % wenn WP aktiv ohne BEV
                                                  
                                                 Eclo2l_erg = Eclo_frei - Eg2l; % Ergebiss Stromcloud nach Hauslast in kWh
                                                 
                                                          Eclo2bev = 0; % Stromcloudbezug für das BEV in kWh
                                                          Eg2bev = 0; % Netzbezug für das BEV in kWh
                                                 
                                                     if Eclo2l_erg > 0 % Positives Stromcloudergebniss nach Hauslast
                                                         
                                                          Eclo2l = Eg2l; % Stromcloudbezug für die Hauslast in kWh
                                                          Eg2l = 0; % Netzbezug für die Hauslast in kWh
                                                          Eclo2wp = Eclo2l_erg; % Stromcloudbezug für die WP in kWh
                                                          Eg2wp = Eg2wp - Eclo2l_erg; % Netzbezug für die WP in kWh
                                                          
                                                     else % Negatives Stromcloudergebniss nach Hauslast
                                                         
                                                          Eclo2l = Eclo_frei; % Stromcloudbezug für die Hauslast in kWh
                                                          Eg2l = abs(Eclo2l_erg); % Netzbezug für die Hauslast in kWh
                                                          Eclo2wp = 0; % Stromcloudbezug für die WP in kWh
                                                         
                                                     end
                                                     
                                                     
                                              elseif E_WP == 0 && S_BEV > 0 % wenn BEV aktiv ohne WP       
                                                 
                                                 Eclo2l_erg = Eclo_frei - Eg2l; % Ergebiss Stromcloud nach Hauslast in kWh
                                                  
                                                          Eclo2wp = 0; % Stromcloudbezug für die WP in kWh
                                                          Eg2wp = 0; % Netzbezug für die WP in kWh
                                                          
                                                          
                                                     if Eclo2l_erg > 0 % Positives Stromcloudergebniss nach Hauslast
                                                         
                                                          Eclo2l = Eg2l; % Stromcloudbezug für die Hauslast in kWh
                                                          Eg2l = 0; % Netzbezug für die Hauslast in kWh
                                                          Eclo2bev = Eclo2l_erg; % Stromcloudbezug für das BEV in kWh
                                                          Eg2bev = Eg2bev - Eclo2l_erg; % Netzbezug für das BEV in kWh
                                                          
                                                     else % Negatives Stromcloudergebniss nach Hauslast
                                                         
                                                          Eclo2l = Eclo_frei; % Stromcloudbezug für die Hauslast in kWh
                                                          Eg2l = abs(Eclo2l_erg); % Netzbezug für die Hauslast in kWh
                                                          Eclo2bev = 0; % Stromcloudbezug für das BEV in kWh
                                                         
                                                     end
                                                          
                                              elseif E_WP > 0 && S_BEV > 0 % wenn WP und BEV aktiv
                                                  
                                                 Eclo2l_erg = Eclo_frei - Eg2l; % Ergebiss Stromcloud nach Hauslast in kWh
                                                  
                                                     if Eclo2l_erg > 0 % Positives Stromcloudergebniss nach Hauslast
                                                         
                                                                    Eclo2lwp_erg = Eclo_frei - Eg2l - Eg2wp; % Stromcloudergebniss nach Hauslast und WP
                                                                
                                                                    if Eclo2lwp_erg > 0 % Positives Stromcloudergebniss nach Hauslast und WP
                                                                            
                                                                            Eclo2l = Eg2l; % Stromcloudbezug für die Hauslast in kWh
                                                                            Eg2l = 0; % Netzbezug für die Hauslast in kWh
                                                                            Eclo2wp = Eg2wp; % Stromcloudbezug für die WP in kWh
                                                                            Eg2wp = 0; % Netzbezug für die WP in kWh
                                                                            Eclo2bev = Eclo2lwp_erg; % Stromcloudbezug für das BEV in kWh
                                                                            Eg2bev = Eg2bev - Eclo2lwp_erg; % Netzbezug für das BEV in kWh
                                                                        
                                                                    else % Negatives Stromcloudergebniss nach Hauslast und WP
                                                                            
                                                                            Eclo2l = Eg2l; % Stromcloudbezug für die Hauslast in kWh
                                                                            Eg2l = 0; % Netzbezug für die Hauslast in kWh
                                                                            Eclo2wp = Eclo_frei - Eclo2l; % Stromcloudbezug für die WP in kWh
                                                                            Eg2wp = abs(Eclo2lwp_erg); % Netzbezug für die WP in kWh
                                                                            Eclo2bev = 0; % Stromcloudbezug für das BEV in kWh
                                                                        
                                                                    end
                                                          
                                                     else % Negatives Stromcloudergebniss nach Hauslast
                                                          
                                                         Eclo2l = Eclo_frei; % Stromcloudbezug für die Hauslast in kWh
                                                         Eg2l = abs(Eclo2l_erg); % Netzbezug für die Hauslast in kWh
                                                         Eclo2wp = 0; % Stromcloudbezug für die WP in kWh
                                                         Eclo2bev = 0; % Stromcloudbezug für das BEV in kWh
                                                         
                                                     end
                                              end
                                  
                                  
                                     else % Negative Stromcloudbilanz
                                         
                                                          if Eac2g < Eclo_frei
                                                                    E2clo = Eac2g; % Einspeisung in die Stromcloud in kWh 
                                                                    Eac2g = 0; % Manipulation der Netzeinspeisung in kWh
                                                          else
                                                                    E2clo = Eclo_frei; % Einspeisung in die Stromcloud in kWh
                                                                    Eac2g = Eac2g - Eclo_frei; % Manipulation der Netzeinspeisung in kWh
                                                          end
                                                          
                                                          
                                                          Eg2ac = Eg2ac - Eclo_frei; % Manipulation des Netzbezugs in kWh
                                                            
                                             if E_WP == 0 && S_BEV == 0 % wenn keine WP und BEV aktiv
                                     
                                                          Eclo2l = Eclo_frei; % Stromcloudbezug für die Hauslast in kWh
                                                          Eg2l = Eg2ac; % Netzbezug für die Hauslast in kWh
                                                          Eclo2wp = 0; % Stromcloudbezug für die WP in kWh
                                                          Eg2wp = 0; % Netzbezug für die WP in kWh
                                                          Eclo2bev = 0; % Stromcloudbezug für das BEV in kWh
                                                          Eg2bev = 0; % Netzbezug für das BEV in kWh
                                  
                                             elseif E_WP > 0 && S_BEV == 0 % wenn WP aktiv ohne BEV
                                                 
                                                     Eclo2l_erg = Eclo_frei - Eg2l; % Ergebiss Stromcloud nach Hauslast in kWh
                                                     
                                                          Eclo2bev = 0; % Stromcloudbezug für das BEV in kWh
                                                          Eg2bev = 0; % Netzbezug für das BEV in kWh
                                        
                                                     if Eclo2l_erg > 0 % Positives Stromcloudergebniss nach Hauslast
                                            
                                                          Eclo2l = Eg2l; % Stromcloudbezug für die Hauslast in kWh
                                                          Eg2l = 0; % Netzbezug für die Hauslast in kWh
                                                          Eclo2wp = Eclo2l_erg; % Stromcloudbezug für die WP in kWh
                                                          Eg2wp = Eg2wp - Eclo2l_erg; % Netzbezug für die WP in kWh
                                        
                                                     else % Negatives Stromcloudergebniss nach Hauslast
                                            
                                                          Eclo2l = Eclo_frei; % Stromcloudbezug für die Hauslast in kWh
                                                          Eg2l = abs(Eclo2l_erg); % Netzbezug für die Hauslast in kWh
                                                          Eclo2wp = 0; % Stromcloudbezug für die WP in kWh
                                            
                                                     end
                                                     
                                                     
                                             elseif E_WP == 0 && S_BEV > 0 % wenn BEV aktiv ohne WP       
                                                 
                                                 Eclo2l_erg = Eclo_frei - Eg2l; % Ergebiss Stromcloud nach Hauslast in kWh
                                                  
                                                          Eclo2wp = 0; % Stromcloudbezug für die WP in kWh
                                                          Eg2wp = 0; % Netzbezug für die WP in kWh
                                                          
                                                     if Eclo2l_erg > 0 % Positives Stromcloudergebniss nach Hauslast
                                                         
                                                          Eclo2l = Eg2l; % Stromcloudbezug für die Hauslast in kWh
                                                          Eg2l = 0; % Netzbezug für die Hauslast in kWh
                                                          Eclo2bev = Eclo2l_erg; % Stromcloudbezug für das BEV in kWh
                                                          Eg2bev = Eg2bev - Eclo2l_erg; % Netzbezug für das BEV in kWh
                                                          
                                                     else % Negatives Stromcloudergebniss nach Hauslast
                                                         
                                                          Eclo2l = Eclo_frei; % Stromcloudbezug für die Hauslast in kWh
                                                          Eg2l = abs(Eclo2l_erg); % Netzbezug für die Hauslast in kWh
                                                          Eclo2bev = 0; % Stromcloudbezug für das BEV in kWh
                                                         
                                                     end
                                                          
                                              elseif E_WP > 0 && S_BEV > 0 % wenn WP und BEV aktiv        
                                                    
                                                  
                                                  Eclo2l_erg = Eclo_frei - Eg2l; % Ergebiss Stromloud nach Hauslast in kWh
                                                  
                                                     if Eclo2l_erg > 0 % Positives Stromcloudergebniss nach Hauslast
                                                         
                                                                    Eclo2lwp_erg = Eclo_frei - Eg2l - Eg2wp; % Stromcloudergebniss nach Hauslast und WP
                                                                
                                                                    if Eclo2lwp_erg > 0 % Positives Stromcloudergebniss nach Hauslast und WP
                                                                            
                                                                            Eclo2l = Eg2l; % Stromcloudbezug für die Hauslast in kWh
                                                                            Eg2l = 0; % Netzbezug für die Hauslast in kWh
                                                                            Eclo2wp = Eg2wp; % Stromcloudbezug für die WP in kWh
                                                                            Eg2wp = 0; % Netzbezug für die WP in kWh
                                                                            Eclo2bev = Eclo2lwp_erg; % Stromcloudbezug für das BEV in kWh
                                                                            Eg2bev = Eg2bev - Eclo2lwp_erg; % Netzbezug für das BEV in kWh
                                                                        
                                                                    else % Negatives Stromcloudloudergebniss nach Hauslast und WP
                                                                            
                                                                            Eclo2l = Eg2l; % Stromcloudbezug für die Hauslast in kWh
                                                                            Eg2l = 0; % Netzbezug für die Hauslast in kWh
                                                                            Eclo2wp = Eclo_frei - Eclo2l; % Stromcloudbezug für die WP in kWh
                                                                            Eg2wp = abs(Eclo2lwp_erg); % Netzbezug für die WP in kWh
                                                                            Eclo2bev = 0; % Stromcloudbezug für das BEV in kWh
                                                                        
                                                                    end
                                                          
                                                     else % Negatives Stromcloudergebniss nach Hauslast
                                                          
                                                         Eclo2l = Eclo_frei; % Stromcloudbezug für die Hauslast in kWh
                                                         Eg2l = abs(Eclo2l_erg); % Netzbezug für die Hauslast in kWh
                                                         Eclo2wp = 0; % Stromcloudbezug für die WP in kWh
                                                         Eclo2bev = 0; % Stromcloudbezug für das BEV in kWh
                                                         
                                                     end
                                              
                                                  
                                             end
                                    end % Ende negative Stromcloudbilanz
                     end
                     
                else % Wenn keine Stromcloud Aktiv
                                  E2clo = 0; % Einspeisung in die Stromcloud = Bezugs aus der Stromcloud in kWh
                                  Eclo2l = 0; % Stromcloudbezug für die Hauslast in kWh
                                  Eclo2wp = 0; % Stromcloudbezug für die WP in kWh
                                  Eclo2bev = 0; % Stromcloudbezug für das BEV in kWh
                end % Ende Stromcloudberechnung  


end
