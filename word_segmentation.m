function [segmentation_points] = Word_Segmentation(input_image)
    
    clear rows;
    clear hist_params;
    
    [image_height,image_width] = size(input_image);
    
    for n = 1 : image_height;
        rows(n) = sum(input_image(n,:));
    end
    
    spc = 0;
    for k = 1 : length(rows)-1;
        if rows(k) > 0 && rows(k+1) == 0
            spc = spc+1; 
            segmentation_points(spc) = k+1;
        elseif rows(k) == 0 && rows(k+1) > 0
            spc = spc+1;
            segmentation_points(spc) = k;
        end
    end
    
    deleted_points = [];   
    dpc = 0;
    word_segmentation_threshold = 20;
    
    reference = 2;
    for (j = 1 : floor(length(segmentation_points)/2))
        if segmentation_points(reference) - segmentation_points(reference-1) <= word_segmentation_threshold
            dpc = dpc+1;
            deleted_points(dpc) = reference-1;
        end
        reference = reference+2;
    end
    
    if length(deleted_points) > 0
        q = length(deleted_points);
        for p = 1 : length(deleted_points)
            segmentation_points(deleted_points(q)) = [];
            segmentation_points(deleted_points(q)) = [];
            q = q - 1;
        end
    end

    deleted_points = [];   
    dpc = 0;
    word_space_threshold = 35;

    
    reference = 3;
    for m = 1 : floor(length(segmentation_points)/2)-1
        if segmentation_points(reference) - segmentation_points(reference-1) <= word_space_threshold
            dpc = dpc+1;
            deleted_points(dpc) = reference-1;
        end
        reference = reference+2;
    end
    

    if length(deleted_points) > 0
        q = length(deleted_points);
        for p = 1 : length(deleted_points)
            segmentation_points(deleted_points(q)) = [];
            segmentation_points(deleted_points(q)) = [];
            q = q - 1;
        end
    end

end

