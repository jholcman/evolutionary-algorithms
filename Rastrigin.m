function hodnota = Rastrigin(vektor)

    hodnota = 0;
    for i=1:length(vektor)
        hodnota = hodnota + ((vektor(i)*vektor(i))-(10*(cos(2*pi*vektor(i)))));
    end
    hodnota = 2*length(vektor)*hodnota;
end

