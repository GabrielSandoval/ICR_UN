function [E] = Euler_Number(character_segment)
   
    euler_padding = 10;
    ZZ = (padarray(character_segment, [euler_padding euler_padding], 0));
    [n,m] = size(ZZ);
    euler_character = reshape(ZZ, 1, m*n);

    cx = 0;
    cc = 0;
    dg = 0;
    z = 0;
    E = 0;
    x = 1;
    i = 1;

    while i <= (m - 1) * (n - 1)
        z = euler_character(x) + euler_character(x+1) + euler_character(x+n) + euler_character(x+n+1);
        if (z==1)
            cx = cx+1;
        elseif(z == 3)
            cc = cc+1;
        elseif (z == 2 & ~(euler_character(x) ==  + euler_character(x+1)) & ~(euler_character(x) == euler_character(x+n)))
            dg = dg+1;
        end
        x = x+1;
        i = i+1;
    end

    if (cx == 0 & cc == 0 & dg == 0)
        output = 'no character';
    else
        E = (cx - cc - 2 * dg) / 4;

        sprintf('Euler Number = %d', E);

        if(E == 1)
             output = 'CLASS: NO holes';
        elseif(E == 0)
             output = 'CLASS: ONE hole';
        elseif(E == -1)
             output = 'CLASS: TWO holes';
        elseif(E == -2)
             output = 'CLASS: THREE holes';
        elseif (E <= -3)
            output = 'CLASS: MANY holes';
        end
    end
    
end
