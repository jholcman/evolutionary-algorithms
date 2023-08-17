function hodnota = DeJong2(vektor)

    hodnota = 0;
    for i=1:length(vektor)-1
        hodnota = hodnota + 100*(vektor(i)^2-vektor(i+1))^2+(1-vektor(i))^2;
    end
    
end

