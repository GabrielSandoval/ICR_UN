function [FEATURES] = Diagonal_Feature_Extraction(input_image)

    [image_height,image_width] = size(input_image);
    rows = 0;
    segmentation_points = Line_Segmentation(input_image);
    z = input_image(segmentation_points(1): segmentation_points(2), 1:image_width);  

    m = 90;
    n = 60;

    input_image = imresize(z, [m n]);

%%%%%%%%%%%% GETTING 54 ZONES %%%%%%%%%%%%%%%%

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

% %%%%%%%%%%%%%% GETTING SUB FEATURES %%%%%%%%%%%%%
% 
%     zone_features = 0;
%     zone_number = 1;
%     for zone_r = 1 : 9
%         for zone_c = 1 : 6
% 
%             feature_counter = 0;
%             sub_feature = 0;
% 
%             for top_iterator = 1 : 10
%                 row = top_iterator;
%                 col = 1;
%                 sum_diagonal = 0;
% 
%                 while (row > 0)
%                     sum_diagonal = sum_diagonal + zone(row, col, zone_number);
%                     col = col+1;
%                     row = row-1;
%                 end
% 
%                 feature_counter = feature_counter + 1;
%                 sub_feature(feature_counter) = sum_diagonal/top_iterator;
%             end
% 
%             for bot_iterator = 2 : 9
%                 row = 10;
%                 col = bot_iterator;
%                 sum_diagonal = 0;
% 
%                 while (col < 11)
%                     sum_diagonal = sum_diagonal + zone(row, col, zone_number);
%                     col = col+1;
%                     row = row-1;
%                 end
% 
%                 feature_counter = feature_counter + 1;
%                 sub_feature(feature_counter) = sum_diagonal/top_iterator;
%             end
% 
%             zone_features(zone_r, zone_c) = sum(sub_feature)/19;
%             zone_number = zone_number+1;
%         end
%     end
% 
%     column = 1;
%     while column <= 6
%         vertical_feature(column) = sum(zone_features(:,column))/9;
%         column = column+1;
%     end
% 
%     row = 1;
%     while row <= 9
%         horizontal_feature(row) = sum(zone_features(row,:))/6;
%         row = row+1;
%     end
% 
%     FEATURES = [reshape(zone_features,1,54), vertical_feature, horizontal_feature];

%%%%%%%%%%%%%% NOT SO DIAGONAL FEATURE EXTRACTION

        row = 1;
        zone_number = 1;
        while row <= 9
            column = 1;
            while column <= 6


            sub_feature(row,column) = sum(sum(zone(:,:,zone_number)))/19;    
            zone_number = zone_number+1;
            column = column+1;
            end
            row = row+1;
        end

        column = 1;
        while column <= 6
            vertical_feature(column) = sum(sub_feature(:,column))/9;
            column = column+1;
        end

        row = 1;
        while row <= 9
            horizontal_feature(row) = sum(sub_feature(row,:))/6;
            row = row+1;
        end

        FEATURES = [reshape(sub_feature,1,54), vertical_feature, horizontal_feature];
    
end