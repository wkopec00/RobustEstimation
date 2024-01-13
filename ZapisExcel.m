function ZapisExcel = ZapisExcel(Katy, Odleglosci, Wsp, Szukane, Odlobliczone, Katyobliczone, Metoda)

% Nagłówki kolumn
naglowki_katy = {'L', 'C', 'P', 'KatWyr', 'v[g]', 'mk[g]', 'mv', 'v/mv'};
naglowki_odl = {'Od', 'Do', 'OdlWyr', 'vd', 'md', 'mv', 'v/mv'};
naglowki_pkt = {'Nr', 'Xw', 'Yw', 'mx', 'my', 'mp'};

Macierz_Katy = horzcat(Katy(:, 1:3), Katyobliczone(:, [1, 3:6]));
Macierz_Odl = horzcat(Odleglosci(:, 1:2), Odlobliczone(:, [1, 3:6]));
Macierz_pkt = Szukane(:, 1:6);

% Podanie nazwy pliku Excela
nazwa_pliku = sprintf('Wyrownanie-%s.xlsx', Metoda);

% Zapisanie danych do arkusza pkt
xlswrite(nazwa_pliku, naglowki_pkt, 'Punkty', 'A1');
xlswrite(nazwa_pliku, Macierz_pkt, 'Punkty', 'A2');

% Zapisanie danych do arkusza odl
xlswrite(nazwa_pliku, naglowki_odl, 'Odleglosci', 'A1');
xlswrite(nazwa_pliku, Macierz_Odl, 'Odleglosci', 'A2');

% Zapisanie danych do arkusza katow
xlswrite(nazwa_pliku, naglowki_katy, 'Katy', 'A1');
xlswrite(nazwa_pliku, Macierz_Katy, 'Katy', 'A2');