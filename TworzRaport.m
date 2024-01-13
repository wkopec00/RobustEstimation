function Katyobliczone = ObliczenieKatow(Nazwa, Katy, Odleglosci, Wsp, Szukane, Odlobliczone, Katyobliczone, m0, n_iteracji, iteracja_em, rodzaj_em, metoda, k_maks, ke, kb, l, g) 

[n_punktow k] = size(Wsp);
[n_odl k] = size(Odleglosci);
[n_nowych k] = size(Szukane);
[n_kat k] = size(Katy);

fid = fopen(strcat(Nazwa, '.txt'), 'wt');
fprintf(fid, 'Raport z wyrównania sieci kątowo liniowej.\n\n');
%{
fprintf(fid, 'Dane wejściowe:\n\n');

fprintf(fid, 'Współrzędne punktów nawiązania:\nNr           X[m]              Y[m]\n');
for i = 1:n_punktow
    if Wsp(i, 4) == 1
        fprintf(fid, '%3d %15.3f %15.3f\n', Wsp(i, 1), Wsp(i, 2), Wsp(i, 3));
    end
end
fprintf(fid, '\nKąty:\nL   C   P       Kąt[g]     mKąt[g]\n');
for i = 1:n_kat
    fprintf(fid, '%3d %3d %3d %10.4f %10.4f\n', Katy(i, 1), Katy(i, 2), Katy(i, 3), Katy(i, 4), Katy(i, 5));
end
fprintf(fid, '\nDługości:\nOd   Do   Odl[m]        mOdl[m]\n');
for i = 1:n_odl
    fprintf(fid, '%3d %3d %10.3f %10.3f\n', Odleglosci(i, 1), Odleglosci(i, 2), Odleglosci(i, 3), Odleglosci(i, 4));
end
fprintf(fid, '\nLiczba obserwacji:\nKąty poziome: %d\nOdległości poziome: %d\n', n_kat, n_odl);
fprintf(fid, '\nLiczba niewiadomych:\nWspółrzędne: %d\n', n_nowych*2);
fprintf(fid, '\nLiczba obserwacji nadliczbowych: %d\n', (n_kat+n_odl)-(n_nowych*2));

%}
if iteracja_em > 0
    fprintf(fid, '\n=========== Estymacja mocna ===========\n');
    fprintf(fid, 'Wykorzystano %s metodę estymacji mocnej\n', metoda);
    fprintf(fid, 'Wykonano %d iteracji\n', iteracja_em);
    fprintf(fid, 'Parametry estymacji:\n');
    fprintf(fid, 'k = %0.3f\n', k_maks);
    if rodzaj_em == 2 % estymacja hampela
        fprintf(fid, 'kb = %0.2f\n', kb);
    elseif rodzaj_em == 3 % duńska
        fprintf(fid, 'l = %0.3f\ng = %0.3f\n', l ,g);
    end
    fprintf(fid, '=======================================\n');
end

fprintf(fid, '\n===================Wyrównanie===================\n\nm0 = %.10f\nLiczba iteracji: %d\n', m0, n_iteracji);
fprintf(fid, '\nWykaz współrzędnych po wyrównaniu:\n');
fprintf(fid, 'Nr       X[m]       Y[m]       mx[mm]     my[mm]     mp[mm]    ElipsaA[mm]    ElipsaB[mm]   ElipsaAzymut[g]\n');
for i = 1:n_nowych
    fprintf(fid, '%3d %10.3f %10.3f %10.1f %10.1f %10.1f %15.1f %15.1f %15.5f\n', Szukane(i, 1), Szukane(i, 2), Szukane(i, 3), Szukane(i, 4)*1000, Szukane(i, 5)*1000, Szukane(i, 6)*1000, Szukane(i, 7)*1000, Szukane(i, 8)*1000, Szukane(i, 9)*200/pi);
end
fprintf(fid, '\nWyrównane obserwacje kątowe\n');
fprintf(fid, 'L   C   P       Kąt[g]     v[cc]   Kąt wyr.[g]     mk[cc]     mv[cc]    v/mv\n');
for i = 1:n_kat
    fprintf(fid, '%3d %3d %3d %10.4f %10.1f %10.5f %10.1f %10.1f %10.3f\n', Katy(i, 1), Katy(i, 2), Katy(i, 3), Katy(i, 4), Katyobliczone(i, 3)*10000, Katyobliczone(i, 1), Katyobliczone(i, 4)*10000, Katyobliczone(i, 5)*10000, Katyobliczone(i,3)/Katyobliczone(i,5));
end
fprintf(fid, '\nWyrównane obserwacje odległości\n');
fprintf(fid, 'Od Do  Odległość[m]    v[mm]    Dwyr.[m]     mDwyr.[mm]     mv[mm]    v/mv\n');
for i = 1:n_odl
    fprintf(fid, '%3d %3d %10.3f %10.1f %10.3f %10.1f %10.1f %10.3f\n', Odleglosci(i, 1), Odleglosci(i,2), Odleglosci(i, 3), Odlobliczone(i, 3)*1000, Odlobliczone(i, 1), Odlobliczone(i, 4)*1000, Odlobliczone(i, 5)*1000, Odlobliczone(i,3)/Odlobliczone(i,5)); 
end

fprintf(fid, '\n\n\nAutor: Wojciech Kopeć 2 rok GiK 2021/2022');
fclose(fid);

