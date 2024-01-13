% Wyrównanie sieci kątowo liniowej
clc
clear
format LONG
%-------------------------------------------------------------------
zadana_dokladnosc = 1e-04;   % przykladowa dokladnosc 
                             % - róznica wsp. z sasiednich iteracji
max_iteracji = 10; % zadana maksymalna liczba iteracji
n_iteracji = 1;      % zlicza liczbę iteracji (min. 1 iteracja)
kolejna_iteracja = 1; % zmienna do sprawdzenia, czy jeszcze iterować

max_iteracji_em = 1000; % maksymalna liczba iteracji przy estymacji mocnej
k_maks = 4.685; % Przedziały ufności: y = 95% -> k=2; y=98.8% -> k=2.5; y=99.7% -> k=3
            % Huber: 2, Tukey: 4.685, Duńska: 2.2, ZWA: 2, 
            % Hampel: 1.5-1.7, Cauchy: 2.385
ke = 0.05; % precyzja przedziału k
rodzaj_em = 0; % 1 = funkcja Hubera, 2 = funkcja Hampela, 3 = funkcja Duńska, 4 = Tukeya, 5 = ZWA

kb = 6; % kb = 4,...,6 - liczba dodatkowych przedziałów w funkcji Hampela

% parametry sterujące - f.duńska
l = 0.1;
g = 2;

wybrana_em = containers.Map({0, 1, 2, 3, 4, 5, 6}, {'Brak', 'Hubera', 'Hampela', 'Duńską', 'Tukeya', 'ZWA', 'Cauchyego'});
%-------------------------------------------------------------------

%% załadowanie wsp
% tekst = 'Podaj nazwe pliku n_kat którym znajdują się współrzędne: ';
%plik = input(tekst, 's');
%disp('Wybrany plik:')
%disp(plik)
plik = 'wsp.txt';
fid = fopen(plik, 'r');
fgetl(fid);
i=1;
while ~feof(fid)
	wiersz = fgetl(fid);
    if isempty(wiersz)
        continue
    end
	podzial = strsplit(wiersz);
	for o = 1:4
        Wsp(i,o) = str2double(podzial{1,o});
    end
	i=i+1;
end
fclose(fid);

%% Załadowanie kątów
%tekst = 'Podaj nazwe pliku którym znajdują się kąty (L C P Kąt[g] Odch.st.[g]): ';
%plik = input(tekst, 's');
%disp('Wybrany plik:')
%disp(plik)
plik = 'wkaty.txt';
fid = fopen(plik, 'r');
fgetl(fid);
i=1;
while ~feof(fid)
	wiersz = fgetl(fid);
    if isempty(wiersz)
        continue
	end
	podzial = strsplit(wiersz);
	for o = 1:5
        Katy(i,o) = str2double(podzial{1,o});
    end
	i=i+1;
end
fclose(fid);
%% Załadowanie dlugosci
%tekst = 'Podaj nazwe pliku n_kat którym znajdują się długości (Od do Odl[m] odch.st[m]): ';
%plik = input(tekst, 's');
%disp('Wybrany plik:')
%disp(plik)
plik = 'wdlugosci.txt';
fid = fopen(plik, 'r');
fgetl(fid);
i=1;
while ~feof(fid)
	wiersz = fgetl(fid);
    if isempty(wiersz)
        continue
	end
	podzial = strsplit(wiersz);
	for o = 1:4
        Odleglosci(i,o) = str2double(podzial(1,o));
    end
	i=i+1;
end
fclose(fid);
clear fid;

[n_punktow k] = size(Wsp);
[n_odl k] = size(Odleglosci);
[n_kat k] = size(Katy);

% Ile punktow do obliczenia?
Szukane = 0;, n_nowych=0;
    for i=1:n_punktow
        if Wsp(i,4) == 0
            n_nowych=n_nowych+1;
            Szukane(n_nowych, 1) = Wsp(i, 1);
        end
    end
    n_stalych = n_punktow-n_nowych;
% ============================= iteracje ============================
iterowac = n_iteracji<=max_iteracji;
while kolejna_iteracja && iterowac
	fprintf('Iteracja: %d\n------------\n\n',n_iteracji);  

    Katyobliczone = ObliczenieKatow(Katy,Wsp);  % Obliczenie katow
    Odlobliczone = ObliczenieOdleg(Odleglosci,Wsp); % Obliczenie odl
    
    A = MacierzA(Odleglosci, Katy, Wsp, Szukane);   % Macierz A

    %% Macierz P i L
    for i=1:n_odl
        P(i, i) = 1/(Odleglosci(i, 4)^2);
        L(i, 1) = Odlobliczone(i, 2);
    end
    for i=n_odl+1:n_odl+n_kat
        P(i, i) = 1/(Katy(i-n_odl, 5)^2);
        L(i, 1) = Katyobliczone(i-n_odl, 2);
    end
    %% Obliczenie x
    x = inv(A'*P*A)*A'*P*L;
    %-------------------------------------------------------------------
    kolejna_iteracja = 0;  % traktuje jako zmienna logiczna
    for ii=1:n_nowych
        if abs(x(ii))>zadana_dokladnosc
          kolejna_iteracja=1;
        end
    end
    if kolejna_iteracja
        n_iteracji=n_iteracji+1;
    end
    %-------------------------------------------------------------------

    %% Zapisanie wyrownanych wsp
    for i = 1:n_punktow
        for o = 1:n_nowych
            if Wsp(i, 1) == Szukane(o, 1)
                for p = 1:2
                    switch p
                        case 1 
                            Szukane(o, 2) = Wsp(i, 2) + x(2*o+p-2, 1);
                            Wsp(i, 2)=Szukane(o, 2);    %--------

                        case 2
                            Szukane(o, 3) = Wsp(i, 3) + x(2*o+p-2, 1);
                            Wsp(i, 3)=Szukane(o, 3);     % -------------   

                    end
                end
            end
        end
    end

end % iteracje
% ============================= iteracje - koniec =======================
%% Analiza dokładności
v = A*x - L; % Macierz v  

m0kw = (v'*P*v)/((n_odl+n_kat)-2*n_nowych); % (m0)^2
m0 = sqrt(m0kw) % m0

CovXY = m0kw*inv(A'*P*A); % Macierz Cov(XY)
for i = 1:n_nowych
    Szukane(i, 4) = sqrt(CovXY(2*i-1, 2*i-1)); % mx
	Szukane(i, 5) = sqrt(CovXY(2*i, 2*i)); % my
    Szukane(i, 6) = sqrt(Szukane(i, 5)^2 + Szukane(i, 4)^2); %mp
end

CovOBS = A*CovXY*A';
CovV2 = m0kw*(inv(P) - A*inv(A'*P*A)*A');
for i = 1:n_odl
    Odlobliczone(i, 3) = v(i, 1); % Zapis poprawek dla poszczegolnych odległości
    Odlobliczone(i, 4) = sqrt(CovOBS(i, i)); % Obl. + zapis błędów md -||-
    Odlobliczone(i, 5) = sqrt(abs(CovV2(i, i))); % Obl. + zapis błędów mv
	Odlobliczone(i, 6) = abs(Odlobliczone(i,3)/Odlobliczone(i,5));
end
for i = 1:n_kat
    Katyobliczone(i, 3) = v(i+n_odl, 1); % Zapis poprawek
    Katyobliczone(i, 4) = sqrt(CovOBS(i+n_odl, i+n_odl)); % Obl. + zapis błędów malfa
    Katyobliczone(i, 5) = sqrt(abs(CovV2(i+n_odl, i+n_odl))); % Obl. + zapis błędów mv
    Katyobliczone(i, 6) = abs(Katyobliczone(i,3)/Katyobliczone(i,5)); %v/mv
end

estymacja_m = 0; % Zmienna logiczna, czy potrzeba estymacji mocnej
% Sprawdzenie, czy potrzebna estymacja mocna + zapisanie v i mv do jednej
% zmiennej
for i = 1:n_odl
    v_em(i, 1) = Odlobliczone(i,3);  % v
    v_em(i, 2) = Odlobliczone(i,5);  % mv
    v_em(i, 3) = abs(Odlobliczone(i,3)/Odlobliczone(i,5)); % v/mv
    if (abs(v_em(i,3)) >= k_maks)
        estymacja_m = 1; % konieczna estymacja
    end
end
for i = 1:n_kat
    v_em(i+n_odl, 1) = Katyobliczone(i,3);  % v
    v_em(i+n_odl, 2) = Katyobliczone(i,5);  % mv
    v_em(i+n_odl, 3) = abs(Katyobliczone(i,3)/Katyobliczone(i,5)); % v/mv
    if (abs(v_em(i,3)) >= k_maks)
        estymacja_m = 1; % konieczna estymacja
    end
end
if estymacja_m == 1
	fprintf('Estymacja mocna konieczna\n');
else
    fprintf('Estymacja mocna nie jest konieczna. Czy mimo to, chcesz ją wykonać?\n');
    estymacja_m = input('1 => Tak\n0 => Nie\n');
end
iteracja_em = 0;
%% Estymacja mocna
if estymacja_m == 1
	rodzaj_em = input('Podaj wybraną metode estymacji mocnej:\n0 => brak estymacji mocnej\n1 => funkcja Hubera,\n2 => funkcja Hampela,\n3 => funkcja Duńska\n4 => funkcja Tukeya\n5 => ZWA\n6 => funkcja Cauchyego\n');
    if rodzaj_em ~= 0
        fprintf('Wybrałeś metode estymacji: %s\n', wybrana_em(rodzaj_em));
    end

    while estymacja_m && iteracja_em < max_iteracji_em && rodzaj_em ~= 0
        T = zeros(n_odl+n_kat, n_odl+n_kat);
        switch(rodzaj_em)
            case 1 % estymacja Hubera
                for i = 1:n_odl+n_kat
                    if v_em(i,3) >= (k_maks)
                        T(i,i) = 0;
                    else
                        T(i,i) = 1;
                    end
                end
            case 2 % estymacja Hampela
                for i = 1:n_odl+n_kat
                    if v_em(i,3) > kb % v > kb
                        T(i,i) = 0;
                    elseif v_em(i,3) >= (k_maks) % v = (k;kb>
                        T(i,i) = (v_em(i,3)-kb)/(k_maks-kb); 
                    else
                        T(i,i) = 1;
                    end
                end
            case 3 % estymacja Duńska
                for i = 1:n_odl+n_kat
                    if v_em(i,3) >= (k_maks)
                        T(i,i) = exp(-v_em(i,3)/k_maks);
                    else
                        T(i,i) = 1;
                    end
                end
            case 4 % estymacja Tukey'a
                for i = 1:n_odl+n_kat
                    if v_em(i,3) >= (k_maks)
                        T(i,i) = 0;
                    else
                        T(i,i) = (1-(v_em(i,3)/k_maks)^2)^2;
                    end
                end
            case 5 % Zasada wyboru alternatywy
                for i = 1:n_odl+n_kat
                    T(i,i) = exp(-((v_em(i,3)^2)/(k_maks*m0kw)));
                end
            case 6 % Cauchy - Preweda
                for i = 1:n_odl+n_kat
                    T(i,i) = 1/(1+(v_em(i,3)/k_maks)^2);
                end
        end
        P = T*P;
        %{
        dokladnosc = 1e-10;
        for i=1:n_odl+n_kat
            if P(i,i) <= dokladnosc
                P(i,i) = dokladnosc;
            end
        end
        %}
        Odlobliczone = ObliczenieOdleg(Odleglosci,Wsp);
        Katyobliczone = ObliczenieKatow(Katy,Wsp);
        
        % macierz L
        for i=1:n_odl
            L(i, 1) = Odlobliczone(i, 2);
        end
        for i=n_odl+1:n_odl+n_kat
            L(i, 1) = Katyobliczone(i-n_odl, 2);
        end
        
        % macierz A
        A = MacierzA(Odleglosci, Katy, Wsp, Szukane);
        
        x_em = inv(A'*P*A)*A'*P*L;
        for i=1:n_nowych
            if abs(x_em(i))<(1e-8)
              estymacja_m = 0;
            end
        end
        iteracja_em = iteracja_em+1;
        %% Analiza dokładności po estymacji mocnej
        v = A*x_em - L; % Macierz v  

        m0kw = (v'*P*v)/((n_odl+n_kat)-2*n_nowych); % (m0)^2
        m0 = sqrt(m0kw); % m0

        CovXY = m0kw*inv(A'*P*A); % Macierz Cov(XY)
        for i = 1:n_nowych
            Szukane(i, 4) = sqrt(CovXY(2*i-1, 2*i-1)); % mx
            Szukane(i, 5) = sqrt(CovXY(2*i, 2*i)); % my
            Szukane(i, 6) = sqrt(Szukane(i, 5)^2 + Szukane(i, 4)^2); %mp
        end

        CovOBS = A*CovXY*A'; % Macierz Cov(Obserwacji)
        CovV2 = m0kw*(inv(P) - A*inv(A'*P*A)*A');
        for i = 1:n_odl
            Odlobliczone(i, 3) = v(i, 1); % Zapis poprawek dla poszczegolnych odległości
            Odlobliczone(i, 4) = sqrt(CovOBS(i, i)); % Obl. + zapis błędów md -||-
            Odlobliczone(i, 5) = sqrt(abs(CovV2(i, i))); % Obl. + zapis błędów mv
            Odlobliczone(i, 6) = abs(Odlobliczone(i,3)/Odlobliczone(i,5));
        end
        for i = 1:n_kat
            Katyobliczone(i, 3) = v(i+n_odl, 1); % Zapis poprawek
            Katyobliczone(i, 4) = sqrt(CovOBS(i+n_odl, i+n_odl)); % Obl. + zapis błędów malfa
            Katyobliczone(i, 5) = sqrt(abs(CovV2(i+n_odl, i+n_odl))); % Obl. + zapis błędów mv
            Katyobliczone(i, 6) = abs(Katyobliczone(i,3)/Katyobliczone(i,5)); %v/mv
        end
        for i = 1:n_odl
            v_em(i, 1) = Odlobliczone(i,3);  % v
            v_em(i, 2) = Odlobliczone(i,5);  % mv
            v_em(i, 3) = abs(Odlobliczone(i,3)/Odlobliczone(i,5)); % v/mv
        end
        for i = 1:n_kat
            v_em(i+n_odl, 1) = Katyobliczone(i,3);  % v
            v_em(i+n_odl, 2) = Katyobliczone(i,5);  % mv
            v_em(i+n_odl, 3) = abs(Katyobliczone(i,3)/Katyobliczone(i,5)); % v/mv
        end
            %% Zapisanie wyrownanych wsp
        for i = 1:n_punktow
            for o = 1:n_nowych
                if Wsp(i, 1) == Szukane(o, 1)
                    for p = 1:2
                        switch p
                            case 1 
                                Szukane(o, 2) = Wsp(i, 2) + x_em(2*o+p-2, 1);
                                Wsp(i, 2)=Szukane(o, 2);    %--------

                            case 2
                                Szukane(o, 3) = Wsp(i, 3) + x_em(2*o+p-2, 1);
                                Wsp(i, 3)=Szukane(o, 3);     % -------------   

                        end
                    end
                end
            end
        end
    end
end
%% Elipsa błędów
for i = 1:n_nowych
    VX = CovXY(2*i - 1, 2*i - 1);
    VY = CovXY(2*i, 2*i);
    Cov = CovXY(2*i, 2*i-1);
    Licznik = 2*Cov; %'Y' do azymutu
    Mianownik = VX-VY; %'X' do azymutu
    Szukane(i, 7) = sqrt(((VX + VY)/2) + sqrt(((VX - VY)/2)^2+(Cov)^2)); % Parametr A elipsy
    Szukane(i, 8) = sqrt(((VX + VY)/2) - sqrt(((VX - VY)/2)^2+(Cov)^2)); % Parametr B elipsy
    dwabeta = atan(abs(Licznik/Mianownik))/2;

    if Licznik > 0 && Mianownik > 0 % I ćw.
        Azymut = dwabeta;
    elseif Licznik > 0 && Mianownik < 0  % II ćw.
        Azymut = (3/2*pi - dwabeta);
    elseif Licznik < 0 && Mianownik < 0  % III ćw.
        Azymut = (3/2*pi + dwabeta);
    elseif Licznik < 0 && Mianownik > 0  % IV ćw.
        Azymut = (pi - dwabeta);
    elseif Licznik == 0 && Mianownik > 0 % Azymut 0
        Azymut = 0;
    elseif Licznik == 0 && Mianownik < 0 % Azymut 200
        Azymut = pi/2;
    elseif Licznik > 0 && Mianownik == 0 % Azymut 100
        Azymut = pi/4;
    elseif Licznik < 0 && Mianownik == 0 % Azymut 300
        Azymut = 3*pi/2;
    else % brak azymutu
        Azymut = 0;
    end
    Szukane(i, 9) = Azymut;
end
%% Przedziały ufności 95%
% pustoo
%% Raport txt
TworzRaport('RaportWyrownania',Katy,Odleglosci,Wsp,Szukane,Odlobliczone,Katyobliczone, m0, n_iteracji, iteracja_em, rodzaj_em, wybrana_em(rodzaj_em), k_maks, ke, kb, l, g);
%xlswrite('Wyrownanie.xls', Szukane(1:end,1:3));
%% Zapis do excela
%ZapisExcel(Katy, Odleglosci, Wsp, Szukane, Odlobliczone, Katyobliczone, wybrana_em(rodzaj_em))
%% Rysowanie

%tekst = 'Podaj skale elips ( --- :1) : ';
%skala_elips = str2num(input(tekst, 's'));
skala_elips = 1000
RysujSzkic(Odleglosci, Wsp, Szukane, skala_elips)
clear('skala_elips','plik','podzial','o','wiersz','Azymut','ans','fid','ii','iterowac','p','VX','VY'); % czyszczenie zbędnych zmiennych