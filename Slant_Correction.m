function slant_angle = Slant_Correction(input_image)

a = -0.90;

peak_average = 0;
angles = 0;
index = 1;
    for n = 1 : 14;

        if (n == 14)
            a = 0;
        end

        T = maketform('affine', [1 0 0; a 1 0; 0 0 1] );
        transformed_image = imtransform(input_image,T, 'FillValues', 0);
        
        columns = 0;
        for n = 1 : length(transformed_image(1,:));
            columns(n) = sum(transformed_image(:,n));
        end

        peaks = 0;
        peaks = findpeaks(columns);
        
        peak_average(index) = mean(peaks);
        angles(index) = a;
        index = index + 1;
        
        a = a+0.15;
    end
    
    [max_value, max_index] = max(peak_average);
    slant_angle = angles(max_index);
    
end
