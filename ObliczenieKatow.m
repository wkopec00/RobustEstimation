function Katyobliczone = ObliczenieKatow(Katy, Wsp)    
%% Obl kątów
[n_kat k] = size(Katy);
[n_punktow k] = size(Wsp);
for i=1:n_kat
    XL = 0;, YL = 0;, XC = 0;, YC = 0;, XP = 0;, YP = 0;
    for o=1:n_punktow
        x = 0;
        if(Wsp(o, 1) == Katy(i, 1))
            XL = Wsp(o, 2);
            YL = Wsp(o, 3);
            x = x+1;
        end
        if(Wsp(o, 1) == Katy(i, 2))
            XC = Wsp(o, 2);
            YC = Wsp(o, 3);
            x = x+1;
        end
        if(Wsp(o, 1) == Katy(i, 3))
            XP = Wsp(o, 2);
            YP = Wsp(o, 3);
            x = x+1;
        end
        if x == 3 break; end
    end
    dXL = XL - XC;
    dYL = YL - YC;
    dXP = XP - XC;
    dYP = YP - YC;
    f1 = dXL*dYP - dXP*dYL;
    f2 = dXL*dXP + dYL*dYP;
    Dospr = atan(f1/f2)*200/pi();
    if f2<0
        Dospr = Dospr+200;
    % elseif (f1<0)&(f2>=0) - polecam stosować &&
    elseif (f1<0)&&(f2>=0)
        Dospr = Dospr+400;
    else
        Dospr = Dospr;
    end
    Katyobliczone(i, 1) = Dospr;
    Katyobliczone(i, 2) = Katy(i, 4)-Dospr;
end