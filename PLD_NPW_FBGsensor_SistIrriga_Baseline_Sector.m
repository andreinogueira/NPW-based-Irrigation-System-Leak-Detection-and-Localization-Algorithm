% PLD NPW Method with FBG-based pressure sensors sector 1 simulation.

% Expected Leaks locations:
% LP: 5.0m 
% LD: 97.5m
% LL30: 37.5m 
% FBG-based pressure sensors locations: 0m | 12.5m | 22.5m | 32.5m | 42.5m | 57.5m

format long; 
% Pressure value with no changes.
normal_pressure = 0.20;     

% FBGs locations in Linha Principal.
Pfbgs = [0 20 40 60];      

% FBGs locations in Linha de Derivação.
Dfbgs = zeros(1,42);        
somaD = 0;
for D = 1:42
    Dfbgs(1,D) = somaD;
    somaD = somaD+5;
end

% Localizações das FBGs das linhas laterais.
Lfbgs = [0 12.5 22.5 32.5 42.5 57.5];

% NPW-times detected by Linha Principal FBGs.
npwtimesP = [0 0 3.498 0 0 0;
             0 0 3.505 0 0 0;
             0 0 3.515 0 0 0;
             0 0 3.530 0 0 0];

% Pressure changes detected by Linha Principal FBGs.
samplesfbgP = [0.15 0.20 0.15 0.20 0.20 0.20;
               0.20 0.20 0.15 0.20 0.20 0.20;
               0.20 0.20 0.15 0.20 0.20 0.20;
               0.20 0.20 0.15 0.20 0.20 0.20];

% NPW-times detected by Linha de Derivação FBGs.
npwtimesD = zeros(42,6);
npwtimesD(20,1) = 3.4981;
npwtimesD(21,1) = 3.4982;
for D = 1:19
    npwtimesD(D,1) = 4.0000;
end
for D = 22:42
    npwtimesD(D,1) = 4.0000;
end

% Pressure changes detected by Linha de Derivação FBGs.     
samplesfbgD = zeros(42,6);
samplesfbgD(:,1) = 0.15;
for D = 2:42
    samplesfbgD(:,D)=0.20;
end

% Index Matrices for Samples and NPW-times from Linhas Laterais 
samplesfbgL = zeros(6,6,80);
npwtimesL = zeros(6,6,80);

% Pressure changes detected by Linhas Laterais FBGs.
samplesfbgL(:,:,30) = 0.20;
samplesfbgL(:,6,30) = 0.15;
for L = 1:29
    samplesfbgL(:,:,L) = 0.20;
end
for L = 31:80
    samplesfbgL(:,:,L) = 0.20;
end

% NPW-times detected by Linhas Laterais FBGs.
npwtimesL(:,:,30) = 0.0;
npwtimesL(:,6,30) = 4.0;
npwtimesL(4,6,30) = 3.4985;
npwtimesL(5,6,30) = 3.4987;

% FBGs quantity in Linha Principal.
num_sensorsP = 4;

% FBGs quantity in Linha de Derivação.
num_sensorsD = 42;

% FBGs quantity in each Linha Lateral.
num_sensorsL = 6;

% Samples analysis.
for N = 1:6
    % Leaks occurrence analysis at Linha Principal. 
    if (samplesfbgP(:,N)==normal_pressure)==1
        disp(['No leaks in Linha Principal at sample ',num2str(N)]);
     else
         control = 0;       
                for S = 1:num_sensorsP
                    if samplesfbgP(S,N) == normal_pressure
                        control = control+1;
                    end
                end
                if control == (num_sensorsP-1)
                   disp(['No leaks in Linha Principal at sample ',num2str(N)]);
                else
                    [t1,n1] = min(npwtimesP(:,N));
                    if n1 == 1
                        t2 = (npwtimesP((n1+1),N));
                        n2 = (n1+1);
                        deltaT = (t1 - t2);
                    elseif (npwtimesP((n1+1),N))<(npwtimesP((n1-1),N))
                        t2 = (npwtimesP((n1+1),N));
                        n2 = (n1+1);
                        deltaT = (t1-t2);
                    else
                        t2 = (npwtimesP((n1-1),N));
                        n2 = (n1-1);
                        deltaT = (t2-t1);
                    end
                    %deltaT = sqrt((t1-t2)*(t1-t2));
                    if n1<n2
                        Lsensors = (Pfbgs(n2)-Pfbgs(n1));
                        nFirst = n1;
                    else
                        Lsensors = (Pfbgs(n1)-Pfbgs(n2));
                        nFirst = n2;
                    end
                    velocityNPW = 1259.2; 
                    X = (Lsensors+((velocityNPW)*(deltaT)))/2;
                    XFinal = (Pfbgs(nFirst)-Pfbgs(1))+X;
                    disp('---------------------------------');
                    disp(['Leak occurrence in Linha Principal at sample ',num2str(N)]); 
                    disp(['Distance from Base: ',num2str(XFinal),' m.']);
                    disp('---------------------------------');
                end
     end
    
     % Linha de Derivação. 
     if (samplesfbgD(:,N)==normal_pressure)==1
            disp(['No leaks in Linha de Derivação at sample ',num2str(N)]);
      else
          control = 0;     
                for S = 1:num_sensorsD
                    if samplesfbgD(S,N) == normal_pressure
                        control = control+1;
                    end
                end
                if control == (num_sensorsD-1)
                   disp(['No leaks in Linha de Derivação at sample ',num2str(N)]);
                else
                    [t1,n1] = min(npwtimesD(:,N));
                    if n1 == 1
                        t2 = (npwtimesD((n1+1),N));
                        n2 = (n1+1);
                        deltaT = (t1 - t2);
                    elseif (npwtimesD((n1+1),N))<(npwtimesD((n1-1),N))
                        t2 = (npwtimesD((n1+1),N));
                        n2 = (n1+1);
                        deltaT = (t1-t2);
                    else
                        t2 = (npwtimesD((n1-1),N));
                        n2 = (n1-1);
                        deltaT = (t2-t1);
                    end
                    %deltaT = sqrt((t1-t2)*(t1-t2));
                    if n1<n2
                        Lsensors = (Dfbgs(n2)-Dfbgs(n1));
                        nFirst = n1;
                    else
                        Lsensors = (Dfbgs(n1)-Dfbgs(n2));
                        nFirst = n2;
                    end
                    velocityNPW = 1259.2; %(Lsensors)/(deltaT);
                    X = (Lsensors+((velocityNPW)*(deltaT)))/2;
                    XFinal = (Dfbgs(nFirst)-Dfbgs(1))+X;
                    disp('---------------------------------');
                    disp(['Leak occurrence in Linha de Derivação from Sector 1 at sample ',num2str(N)]); 
                    disp(['Distance from Linha Principal: ',num2str(XFinal),' m.']);
                    disp('---------------------------------');
               end
     end
end

% Leaks occurrence analysis at Linhas Laterais. 
for N = 1:6
    for L = 1:80
        if (samplesfbgL(:,N,L)==normal_pressure) ~= 1
            %disp(['No leaks in Linha Principal at sample ',num2str(N)]);
        %else
         control = 0;       
                for S = 1:num_sensorsL
                    if samplesfbgL(S,N,L) == normal_pressure
                        control = control+1;
                    end
                end
                if control ~= (num_sensorsL-1)
                    [t1,n1] = min(npwtimesL(:,N,L));
                    if n1 == 1
                        t2 = (npwtimesL((n1+1),N,L));
                        n2 = (n1+1);
                        deltaT = (t1 - t2);
                    elseif (npwtimesL((n1+1),N,L))<(npwtimesL((n1-1),N,L))
                        t2 = (npwtimesL((n1+1),N,L));
                        n2 = (n1+1);
                        deltaT = (t1-t2);
                    else
                        t2 = (npwtimesL((n1-1),N,L));
                        n2 = (n1-1);
                        deltaT = (t2-t1);
                    end
                    %deltaT = sqrt((t1-t2)*(t1-t2));
                    if n1<n2
                        Lsensors = (Lfbgs(n2)-Lfbgs(n1));
                        nFirst = n1;
                    else
                        Lsensors = (Lfbgs(n1)-Lfbgs(n2));
                        nFirst = n2;
                    end
                    velocityNPW = 1259.2; 
                    X = (Lsensors+((velocityNPW)*(deltaT)))/2;
                    XFinal = (Lfbgs(nFirst)-Lfbgs(1))+X;
                    disp('---------------------------------');
                    disp(['Leak occurrence in Linha Lateral ',num2str(L),' at sample ',num2str(N)]); 
                    disp(['Distance from Linha de Derivação: ',num2str(XFinal),' m.']);
                    disp('---------------------------------');
                end
        end
    end
end
