function hist_params = Hist_Params(input_image)
clear rows;
clear hist_params;
rows = 0;
    for n = 1 : length(input_image(1,:));
        rows(n) = sum(input_image(:,n));
    end

    index = 1;
    for i = 1 : length(rows);
       copies = rows(i);
       if copies == 0
           continue;
       else
           for j = 1 : copies;
              hist_params(index) = i;
               index = index + 1;
           end
       end 
    end

end
