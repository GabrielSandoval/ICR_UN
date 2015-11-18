function otsu_threshold = Otsu(gray_x)

    GS_hist=imhist(gray_x);
   
    sum_all=sum(sum(gray_x));
    
    wht_back=0;
    wht_fore=0;
    varMax=0;
    threshold=0;
    sum_temp=0;
    total=sum(GS_hist);
    for t=1:256
        wht_back=wht_back+GS_hist(t);
        
        if(wht_back==0)
            continue;
        end
        wht_fore=total-wht_back;
        
        if(wht_fore==0)
            break;
        end
        sum_temp=sum_temp+((t-1)*GS_hist(t));

        mB=sum_temp/wht_back; %mean Backgroud
        mF=(sum_all-sum_temp)/wht_fore; %mean Foreground

        var_Between = wht_back * wht_fore * (mB - mF) * (mB - mF);

        if(var_Between > varMax) 
          varMax = var_Between;
          threshold = t-1;
        end
    end

    thres_percent=threshold/255;

    otsu_threshold = thres_percent;
end