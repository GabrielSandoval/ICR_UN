function [FEATURES] = Diagonal_Feature_Extraction(input_image)

    [image_height,image_width] = size(input_image);
    rows = 0;
    segmentation_points = Line_Segmentation(input_image);
    z = input_image(segmentation_points(1): segmentation_points(2), 1:image_width);  

    m = 90;
    n = 60;

    input_image = imresize(z, [m n]);

    zone_number = 1;
    y = 1;
    current_row = 1;
    while y <= 9 
        x = 1;
        current_column = 1;
        while x <= 6
            zone(:,:,zone_number) = input_image(current_row:current_row+9,current_column:current_column+9);
            x = x+1;
            current_column = current_column+10;
            zone_number = zone_number+1;
        end
        y = y+1;
        current_row = current_row+10;
    end

        row = 1;
        zone_number = 1;
        while row <= 9
            column = 1;
            while column <= 6


            sub_feature(row,column) = sum(sum(zone(:,:,zone_number)))/10;    
            zone_number = zone_number+1;
            column = column+1;
            end
            row = row+1;
        end

        FEATURES = [reshape(sub_feature,1,54)];
    
end