function hodnota = Schweffel(vektor)

    hodnota = 0;
    for i=1:length(vektor)
        hodnota = hodnota + (-vektor(i)*sin(sqrt(abs(vektor(i)))));
    end
    
end

