function [segmentation_points] = Character_Segmentation_Modified_Hist(input_image_raw)
    
    [image_height,image_width] = size(input_image_raw);
    input_image_raw = bwmorph(input_image_raw,'thin',Inf);

    col_dist = 0;

    for i = 1 : image_width
        top = 0;
        bottom = 0;
        for j = 1 :image_height
            if input_image_raw(j,i) == 1
            top = j;
            break;
            end
        end

        ka = image_height;
        for k = 1 : image_height
            if input_image_raw(ka,i) == 1
                bottom = ka;
                break;
            end
            ka = ka - 1;
        end
        col_dist(i) = bottom - top;
    end

    hist_params = 0;

    index = 1;
    for i = 1 : length(col_dist);
        copies = col_dist(i);
        if copies == 0
            continue;
        else
            for j = 1 : copies;
                hist_params(index) = i;
                index = index + 1;
            end
        end 
    end

    histogram_mins = imregionalmin(col_dist)

    reference = 1;
    psp(1) = 1;
    ctr_psp = 1;
    for n = 2 : length(histogram_mins);
        if histogram_mins(n-1) == 0 && histogram_mins(n) == 1
            reference = n;
        elseif histogram_mins(n-1) == 1 && histogram_mins(n) == 0
            ctr_psp = ctr_psp+1;
            psp(ctr_psp)= floor((reference + (n-1))/2);
            reference = 0;
        end
    end
    
    psp(ctr_psp) = image_width;
    
    segmentation_points(1) = 1;
    reference = psp(1);
    char_segmentation_threshold = 6;
    balancing_ratio = .5;
    
    ctr_sp = 1;
    for n = 2 : length(psp)
        if psp(n)- psp(n-1) > char_segmentation_threshold
            ctr_sp = ctr_sp + 1;
            segmentation_points(ctr_sp) = floor((psp(n-1) + reference)/2);
            reference = psp(n); 
        end
    end
    
    ctr_sp = ctr_sp + 1;
    segmentation_points(ctr_sp) = image_width;
        
    number_of_char_segments = length(segmentation_points)-1;
    
    spc = number_of_char_segments+1;    
    for n = 1 : number_of_char_segments;
        if (segmentation_points(spc)- segmentation_points(spc-1)) < ((image_width*balancing_ratio)/number_of_char_segments)
            segmentation_points(spc) = [];
        end
        spc = spc-1;
    end
    
end



