function RysujSzkic = RysujSzkic(Odleglosci, Wsp, Szukane, skala_elips) 
[n_punktow k] = size(Wsp);
[n_odl k] = size(Odleglosci);
[n_nowych k] = size(Szukane);
hold on
for i = 1:n_odl
    for o = 1:n_punktow
        if Wsp(o, 1) == Odleglosci(i, 1)
            xp = Wsp(o, 2);
            yp = Wsp(o, 3);
        elseif Wsp(o, 1) == Odleglosci(i, 2)
            xk = Wsp(o, 2);
            yk = Wsp(o, 3);
        end
    end
    x=[xp, xk];  
    y=[yp, yk];
    plot(y,x,'Color','k','LineWidth',1,'LineStyle','-')
end

for i = 1:n_punktow
    if(Wsp(i, 4) == 1)
        plot(Wsp(i, 3), Wsp(i, 2), '^', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g', 'MarkerSize', 10)
    else
        plot(Wsp(i, 3), Wsp(i, 2), 'o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'r', 'MarkerSize', 7)
        %%{
        for o = 1:n_nowych
            if Wsp(i, 1) == Szukane(o, 1)
                t = linspace(0,2*pi,100); % \/ rysowanie elipsy
                theta = (pi/2-Szukane(o,9));
                a=Szukane(o, 7)*skala_elips;
                b=Szukane(o, 8)*skala_elips;
                x0 = Szukane(o, 3);
                y0 = Szukane(o, 2);
                x = x0 + a*cos(t)*cos(theta) - b*sin(t)*sin(theta);
                y = y0 + b*sin(t)*cos(theta) + a*cos(t)*sin(theta);
                plot(x,y, '-k'); % /\ rysowanie elipsy
            end
        end
        %%}
    end
    text(Wsp(i, 3)+2, Wsp(i, 2)+2,  num2str(Wsp(i, 1)))
end
axis equal;
xlabel('Y');ylabel('X');