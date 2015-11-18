function skew_angle = oneWordSkewCorrection(input_image)

      form_image = imrotate(input_image, 90);
      [image_height, image_width] = size(form_image);
      angle = -45;
      
      for ite=1:10
        rot_image = imrotate(form_image,angle);
        col_dist = 0;
        for i = 1 : image_width
            top = 0;
            bottom = 0;
            for j = 1 :image_height
                if rot_image(j,i) == 1
                top = j;
                break;
                end
            end

            ka = image_height;
            for k = 1 : image_height
                if rot_image(ka,i) == 1
                    bottom = ka;
                    break;
                end
                ka = ka - 1;
            end
            col_dist(i) = bottom - top;
        end
        
%         peaks = findpeaks(col_dist);
%         area(ite) = mean(peaks);

        area(ite) = mean(col_dist);
        angle = angle + 10;
      end

      [max_v, max_i] = max(area);
      skew_angle = -45 + (max_i*10);
end
