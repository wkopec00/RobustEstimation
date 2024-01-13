%% Macierz A
% Wspolczynniki dla długości
function A = MacierzA(Odleglosci, Katy, Wsp, Szukane)
[n_odl k] = size(Odleglosci);
[n_kat k] = size(Katy);
[n_punktow] = size(Wsp);
[n_nowych k] = size(Szukane);
for i=1:n_odl
    for o=1:n_nowych
        for nr=1:2 % 1 - punkt na poczaktu odcinka ; 2- punkt na koncu odcinka
            if Odleglosci(i, nr) == Szukane(o, 1)
                for p=1:2
                    Poczatkowy = Odleglosci(i, 1);
                    Koncowy = Odleglosci(i, 2);
                    for u = 1:n_punktow
                        if Poczatkowy == Wsp(u, 1)
                            Xp = Wsp(u, 2);
                            Yp = Wsp(u, 3);
                        elseif Koncowy == Wsp(u, 1)
                            Xk = Wsp(u, 2);
                            Yk = Wsp(u, 3);
                        end
                    end
                    Xpk = Xk - Xp;
                    Ypk = Yk - Yp;
                    d0 = sqrt(Xpk^2 + Ypk^2);
                    switch nr % nr == 1 -> poczatek ; nr == 2 -> koniec
                        case 1
                            switch p % p == 1 -> dx ; p == 2 -> dy
                                case 1 % i-ty wiersz A, dx o-tego wyznaczanego punktu
                                    A(i, 2*o+p-2) = -Xpk/d0; 
                                case 2 % i-ty wiersz A, dy o-tego wyznaczanego punktu
                                    A(i, 2*o+p-2) = -Ypk/d0; 
                            end
                        case 2
                            switch p % p == 1 -> dx ; p == 2 -> dy
                                case 1 % i-ty wiersz A, dx o-tego wyznaczanego punktu
                                    A(i, 2*o+p-2) = Xpk/d0; 
                                case 2 % i-ty wiersz A, dy o-tego wyznaczanego punktu
                                    A(i, 2*o+p-2) = Ypk/d0; 
                            end
                    end
                end
            end
        end
    end
end
% Wspolczynniki dla kątów
for i=n_odl+1:(n_odl+n_kat)
    for o=1:n_nowych
        for nr=1:3 % 1 - punkt Lewy ; 2- punkt Centralny ; 3 - punkt Prawy
            if Katy(i-n_odl, nr) == Szukane(o, 1)
                for p=1:2
                    Lewy = Katy(i-n_odl, 1);
                    Centralny = Katy(i-n_odl, 2);
                    Prawy = Katy(i-n_odl, 3);
                    for u = 1:n_punktow
                        if Lewy == Wsp(u, 1)
                            Xl = Wsp(u, 2);
                            Yl = Wsp(u, 3);
                        elseif Centralny == Wsp(u, 1)
                            Xc = Wsp(u, 2);
                            Yc = Wsp(u, 3);
                        elseif Prawy == Wsp(u, 1)
                            Xp = Wsp(u, 2);
                            Yp = Wsp(u, 3);
                        end
                    end
                    Xcl = Xl - Xc;
                    Ycl = Yl - Yc;
                    Xcp = Xp - Xc;
                    Ycp = Yp - Yc;

                    d2L = (Xcl^2 + Ycl^2);
                    d2P = (Xcp^2 + Ycp^2);

                    ro = 200/pi();

                    switch nr % nr == 1 -> lewy ; nr == 2 -> centralny ; nr == 3 -> prawy
                        case 1 % Lewy
                            switch p % p == 1 -> dx ; p == 2 -> dy
                                case 1 %   dxl   i-ty wiersz A, dx o-tego wyznaczanego punktu
                                    A(i, 2*o+p-2) = (Ycl/d2L)*ro;
                                case 2 %   dyl   i-ty wiersz A, dy o-tego wyznaczanego punktu
                                    A(i, 2*o+p-2) = -(Xcl/d2L)*ro;
                            end
                        case 2 % Centralny
                            switch p % p == 1 -> dx ; p == 2 -> dy
                                case 1 %  dxc    i-ty wiersz A, dx o-tego wyznaczanego punktu
                                    A(i, 2*o+p-2) = -( Ycl/d2L - Ycp/d2P)*ro; 
                                case 2 %  dyc    i-ty wiersz A, dy o-tego wyznaczanego punktu
                                    A(i, 2*o+p-2) = ( Xcl/d2L - Xcp/d2P)*ro;
                            end
                        case 3 % Prawy
                            switch p % p == 1 -> dx ; p == 2 -> dy
                                case 1 %   dxp   i-ty wiersz A, dx o-tego wyznaczanego punktu
                                    A(i, 2*o+p-2) = -(Ycp/d2P)*ro  ;
                                case 2 %   dyp   i-ty wiersz A, dy o-tego wyznaczanego punktu
                                    A(i, 2*o+p-2) = (Xcp/d2P)*ro ;
                            end
                    end
                end
            end
        end
    end
end
