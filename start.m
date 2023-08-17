dimenzeX = [10 30];
funkceX = ["DeJong1" "DeJong2" "Schweffel" "Rastrigin"];

for a = 1:length(funkceX)
    for b = 1:length(dimenzeX)
        disp('Funkce: ' + funkceX(a) + '    Dimenze=' + num2str(dimenzeX(b)));
        v = PSO(funkceX(a),dimenzeX(b));
        disp('-------------------------------------------------------');
    end
end