function [vysledek] = PSO(cf,dimenze)
    switch cf               % Hodnotící funkce
        case 'DeJong1' 
            CostFunction=@(x) DeJong1(x);
            prostorOd=-5.0;                     % Spodní hranice
            prostorDo= 5.0;                     % Horní hranice
        case 'DeJong2' 
            CostFunction=@(x) DeJong2(x);
            prostorOd=-2.2;                     % Spodní hranice
            prostorDo= 2.2;                     % Horní hranice
        case 'Schweffel' 
            CostFunction=@(x) Schweffel(x);
            prostorOd=0.0;                     % Spodní hranice
            prostorDo= 520.0;                     % Horní hranice
        case 'Rastrigin' 
            CostFunction=@(x) Rastrigin(x);
            prostorOd=-2.2;                     % Spodní hranice
            prostorDo= 2.2;                     % Horní hranice
        otherwise
            CostFunction=@(x) DeJong1(x);
            cf = 'DeJong1';
            prostorOd=-5.0;                     % Spodní hranice
            prostorDo= 5.0;                     % Horní hranice
    end


    populace=50;                              % Velikost populace 
    prvek=[1 dimenze];                  % Vektor øe¹ení
    iterace=(5000 * dimenze)/populace;        % Poèet iterací
    opakovani=30;                       % Poèet opakování
    wStart=0.9;                         % Setrvaènost - poèátek
    wEnd=0.4;                           % Setrvaènost - konec
    c1=2.0;                             % Personal Learning Coefficient
    c2=2.0;                             % Global Learning Coefficient
    krok = 0.001;                        % max. relativní velikost kroku

    clear NejlepsiReseniPrumerne NejlepsiReseniVse;
    
    maxKrok=krok*(prostorDo-prostorOd);
    minKrok=-maxKrok;
    NejlepsiReseniVse=zeros(opakovani,1);
    NejlepsiReseniPrumerne = zeros(iterace,opakovani);

    for k=1:opakovani
        %% Vytvoøení promìnných
        clear prazdne_pole pole NejlepsiHodnota GlobalniNejlepsi;
        w = wStart;                         % Setrvaènost
        prazdne_pole.Pozice=[];
        prazdne_pole.Hodnota=[];
        prazdne_pole.Rychlost=[];
        prazdne_pole.Nejlepsi.Pozice=[];
        prazdne_pole.Nejlepsi.Hodnota=[];
        pole=repmat(prazdne_pole,populace,1);     
        GlobalniNejlepsi.Hodnota=inf;
        NejlepsiHodnota=zeros(iterace,1);

        for i=1:populace
            pole(i).Pozice=unifrnd(prostorOd,prostorDo,prvek);      % Náhodné generování prvního prvku
            pole(i).Rychlost=zeros(prvek);                          % Rychlost = 0
            pole(i).Hodnota=CostFunction(pole(i).Pozice);           % Výpoèet hodnotící funkce

            pole(i).Nejlepsi.Pozice=pole(i).Pozice;                 % Nejlep¹í lokální
            pole(i).Nejlepsi.Hodnota=pole(i).Hodnota;               

            if pole(i).Nejlepsi.Hodnota<GlobalniNejlepsi.Hodnota    % Nejlep¹í celková
                GlobalniNejlepsi=pole(i).Nejlepsi;
            end

        end



        for it=1:iterace

            for i=1:populace

                % Výpoèet vektoru rychlosti
                pole(i).Rychlost = w*pole(i).Rychlost + c1*rand(prvek).*(pole(i).Nejlepsi.Pozice-pole(i).Pozice) + c2*rand(prvek).*(GlobalniNejlepsi.Pozice-pole(i).Pozice);

                pole(i).Rychlost = max(pole(i).Rychlost,minKrok);           % Omezení dle velikosti kroku
                pole(i).Rychlost = min(pole(i).Rychlost,maxKrok);

                pole(i).Pozice = pole(i).Pozice + pole(i).Rychlost;         % Posun na novou pozici

                for j=1:dimenze                                             % Omezení na hranice prostoru
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


                pole(i).Hodnota = CostFunction(pole(i).Pozice);             % Výpoèet hodnotící funkce

                                                                            % Kontrola zda je lep¹í ne¾ pùvodní
                if pole(i).Hodnota<=pole(i).Nejlepsi.Hodnota

                    pole(i).Nejlepsi.Pozice=pole(i).Pozice;
                    pole(i).Nejlepsi.Hodnota=pole(i).Hodnota;

                                                                            % Kontrola celkového nejlep¹ího výsledku
                    if pole(i).Nejlepsi.Hodnota<=GlobalniNejlepsi.Hodnota

                        GlobalniNejlepsi=pole(i).Nejlepsi;

                    end

                end

            end

            NejlepsiHodnota(it)=GlobalniNejlepsi.Hodnota;
            NejlepsiReseniPrumerne(it,k) = GlobalniNejlepsi.Hodnota;
            w = w - ((wStart - wEnd)/(iterace));  % oslabení

        end
        NejlepsiReseniVse(k) = GlobalniNejlepsi.Hodnota;
        disp(['Opakování: ' num2str(k) ':    Nejlep¹í hodnota = ' num2str(NejlepsiReseniVse(k))]);

    end

    %% Graf
    f=figure('PaperOrientation','landscape');
    plot(NejlepsiReseniPrumerne,'LineWidth',2);
    xlabel('Iterace');
    ylabel('Nejlep¹í øe¹ení');
    txt1 = strcat('Konvergenèní graf prùmìrného nejlep¹ího výsledku z ',num2str(opakovani),' bìhù:  funkce ',cf,'   dimenze=',num2str(dimenze),'    velikost populace=',num2str(populace));
    txt2 = strcat('Min=',num2str(min(NejlepsiReseniVse)),'  Max=',num2str(max(NejlepsiReseniVse)),'  Mean=',num2str(mean(NejlepsiReseniVse)),'  Median=',num2str(median(NejlepsiReseniVse)),'  Std.Dev.=',num2str(std(NejlepsiReseniVse)));
    title({txt1;txt2});
    saveas(f,strcat('grafy/',cf,'_dimenze_',num2str(dimenze),'_jednotlive.pdf'));
    
    f=figure('PaperOrientation','landscape');
    plot(mean(NejlepsiReseniPrumerne,2),'LineWidth',2);
    xlabel('Iterace');
    ylabel('Nejlep¹í øe¹ení');
    txt1 = strcat('Konvergenèní graf prùmìrného nejlep¹ího výsledku z ',num2str(opakovani),' bìhù:  funkce ',cf,'   dimenze=',num2str(dimenze),'    velikost populace=',num2str(populace));
    txt2 = strcat('Min=',num2str(min(NejlepsiReseniVse)),'  Max=',num2str(max(NejlepsiReseniVse)),'  Mean=',num2str(mean(NejlepsiReseniVse)),'  Median=',num2str(median(NejlepsiReseniVse)),'  Std.Dev.=',num2str(std(NejlepsiReseniVse)));
    title({txt1;txt2});
    saveas(f,strcat('grafy/',cf,'_dimenze_',num2str(dimenze),'_prumer.pdf'));
    
    vysledek = 'OK';
    
end
