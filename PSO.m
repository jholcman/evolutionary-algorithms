function [vysledek] = PSO(cf,dimenze)
    switch cf               % Hodnot�c� funkce
        case 'DeJong1' 
            CostFunction=@(x) DeJong1(x);
            prostorOd=-5.0;                     % Spodn� hranice
            prostorDo= 5.0;                     % Horn� hranice
        case 'DeJong2' 
            CostFunction=@(x) DeJong2(x);
            prostorOd=-2.2;                     % Spodn� hranice
            prostorDo= 2.2;                     % Horn� hranice
        case 'Schweffel' 
            CostFunction=@(x) Schweffel(x);
            prostorOd=0.0;                     % Spodn� hranice
            prostorDo= 520.0;                     % Horn� hranice
        case 'Rastrigin' 
            CostFunction=@(x) Rastrigin(x);
            prostorOd=-2.2;                     % Spodn� hranice
            prostorDo= 2.2;                     % Horn� hranice
        otherwise
            CostFunction=@(x) DeJong1(x);
            cf = 'DeJong1';
            prostorOd=-5.0;                     % Spodn� hranice
            prostorDo= 5.0;                     % Horn� hranice
    end


    populace=50;                              % Velikost populace 
    prvek=[1 dimenze];                  % Vektor �e�en�
    iterace=(5000 * dimenze)/populace;        % Po�et iterac�
    opakovani=30;                       % Po�et opakov�n�
    wStart=0.9;                         % Setrva�nost - po��tek
    wEnd=0.4;                           % Setrva�nost - konec
    c1=2.0;                             % Personal Learning Coefficient
    c2=2.0;                             % Global Learning Coefficient
    krok = 0.001;                        % max. relativn� velikost kroku

    clear NejlepsiReseniPrumerne NejlepsiReseniVse;
    
    maxKrok=krok*(prostorDo-prostorOd);
    minKrok=-maxKrok;
    NejlepsiReseniVse=zeros(opakovani,1);
    NejlepsiReseniPrumerne = zeros(iterace,opakovani);

    for k=1:opakovani
        %% Vytvo�en� prom�nn�ch
        clear prazdne_pole pole NejlepsiHodnota GlobalniNejlepsi;
        w = wStart;                         % Setrva�nost
        prazdne_pole.Pozice=[];
        prazdne_pole.Hodnota=[];
        prazdne_pole.Rychlost=[];
        prazdne_pole.Nejlepsi.Pozice=[];
        prazdne_pole.Nejlepsi.Hodnota=[];
        pole=repmat(prazdne_pole,populace,1);     
        GlobalniNejlepsi.Hodnota=inf;
        NejlepsiHodnota=zeros(iterace,1);

        for i=1:populace
            pole(i).Pozice=unifrnd(prostorOd,prostorDo,prvek);      % N�hodn� generov�n� prvn�ho prvku
            pole(i).Rychlost=zeros(prvek);                          % Rychlost = 0
            pole(i).Hodnota=CostFunction(pole(i).Pozice);           % V�po�et hodnot�c� funkce

            pole(i).Nejlepsi.Pozice=pole(i).Pozice;                 % Nejlep�� lok�ln�
            pole(i).Nejlepsi.Hodnota=pole(i).Hodnota;               

            if pole(i).Nejlepsi.Hodnota<GlobalniNejlepsi.Hodnota    % Nejlep�� celkov�
                GlobalniNejlepsi=pole(i).Nejlepsi;
            end

        end



        for it=1:iterace

            for i=1:populace

                % V�po�et vektoru rychlosti
                pole(i).Rychlost = w*pole(i).Rychlost + c1*rand(prvek).*(pole(i).Nejlepsi.Pozice-pole(i).Pozice) + c2*rand(prvek).*(GlobalniNejlepsi.Pozice-pole(i).Pozice);

                pole(i).Rychlost = max(pole(i).Rychlost,minKrok);           % Omezen� dle velikosti kroku
                pole(i).Rychlost = min(pole(i).Rychlost,maxKrok);

                pole(i).Pozice = pole(i).Pozice + pole(i).Rychlost;         % Posun na novou pozici

                for j=1:dimenze                                             % Omezen� na hranice prostoru
                    if (pole(i).Pozice(j) < prostorOd)
                        pole(i).Pozice(j)=prostorOd + (prostorOd - pole(i).Pozice(j));
                    end
                    if (pole(i).Pozice(j) > prostorDo)
                        pole(i).Pozice(j)=prostorDo - (pole(i).Pozice(j)-prostorDo);
                    end
                     if (pole(i).Pozice(j) < prostorOd)
                        pole(i).Pozice(j)=prostorOd;
                    end
                    if (pole(i).Pozice(j) > prostorDo)
                        pole(i).Pozice(j)=prostorDo;
                    end
               end


                pole(i).Hodnota = CostFunction(pole(i).Pozice);             % V�po�et hodnot�c� funkce

                                                                            % Kontrola zda je lep�� ne� p�vodn�
                if pole(i).Hodnota<=pole(i).Nejlepsi.Hodnota

                    pole(i).Nejlepsi.Pozice=pole(i).Pozice;
                    pole(i).Nejlepsi.Hodnota=pole(i).Hodnota;

                                                                            % Kontrola celkov�ho nejlep��ho v�sledku
                    if pole(i).Nejlepsi.Hodnota<=GlobalniNejlepsi.Hodnota

                        GlobalniNejlepsi=pole(i).Nejlepsi;

                    end

                end

            end

            NejlepsiHodnota(it)=GlobalniNejlepsi.Hodnota;
            NejlepsiReseniPrumerne(it,k) = GlobalniNejlepsi.Hodnota;
            w = w - ((wStart - wEnd)/(iterace));  % oslaben�

        end
        NejlepsiReseniVse(k) = GlobalniNejlepsi.Hodnota;
        disp(['Opakov�n�: ' num2str(k) ':    Nejlep�� hodnota = ' num2str(NejlepsiReseniVse(k))]);

    end

    %% Graf
    f=figure('PaperOrientation','landscape');
    plot(NejlepsiReseniPrumerne,'LineWidth',2);
    xlabel('Iterace');
    ylabel('Nejlep�� �e�en�');
    txt1 = strcat('Konvergen�n� graf pr�m�rn�ho nejlep��ho v�sledku z ',num2str(opakovani),' b�h�:  funkce ',cf,'   dimenze=',num2str(dimenze),'    velikost populace=',num2str(populace));
    txt2 = strcat('Min=',num2str(min(NejlepsiReseniVse)),'  Max=',num2str(max(NejlepsiReseniVse)),'  Mean=',num2str(mean(NejlepsiReseniVse)),'  Median=',num2str(median(NejlepsiReseniVse)),'  Std.Dev.=',num2str(std(NejlepsiReseniVse)));
    title({txt1;txt2});
    saveas(f,strcat('grafy/',cf,'_dimenze_',num2str(dimenze),'_jednotlive.pdf'));
    
    f=figure('PaperOrientation','landscape');
    plot(mean(NejlepsiReseniPrumerne,2),'LineWidth',2);
    xlabel('Iterace');
    ylabel('Nejlep�� �e�en�');
    txt1 = strcat('Konvergen�n� graf pr�m�rn�ho nejlep��ho v�sledku z ',num2str(opakovani),' b�h�:  funkce ',cf,'   dimenze=',num2str(dimenze),'    velikost populace=',num2str(populace));
    txt2 = strcat('Min=',num2str(min(NejlepsiReseniVse)),'  Max=',num2str(max(NejlepsiReseniVse)),'  Mean=',num2str(mean(NejlepsiReseniVse)),'  Median=',num2str(median(NejlepsiReseniVse)),'  Std.Dev.=',num2str(std(NejlepsiReseniVse)));
    title({txt1;txt2});
    saveas(f,strcat('grafy/',cf,'_dimenze_',num2str(dimenze),'_prumer.pdf'));
    
    vysledek = 'OK';
    
end
