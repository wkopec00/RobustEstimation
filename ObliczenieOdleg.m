function Odlobliczone = ObliczenieOdleg(Odleglosci, Wsp)      
%% Obliczenie dlugosci
[n_odl k] = size(Odleglosci);
[n_punktow k] = size(Wsp);
for i=1:n_odl
    X1 = 0;, Y1 = 0;, X2 = 0;, Y2 = 0;
    for o=1:n_punktow
        x = 0;
        if(Wsp(o, 1) == Odleglosci(i, 1))
            X1 = Wsp(o, 2);
            Y1 = Wsp(o, 3);
            x = x+1;
        end
        if(Wsp(o, 1) == Odleglosci(i, 2))
            X2 = Wsp(o, 2);
            Y2 = Wsp(o, 3);
            x = x+1;
        end
        if x == 2 break; end
    end
    dX = X2 - X1;
    dY = Y2 - Y1;
    Odl2 = dX^2 + dY^2;
    Odl = sqrt(Odl2);
    Odlobliczone(i,1) = Odl;
    Odlobliczone(i,2) = Odleglosci(i,3) - Odl;
end