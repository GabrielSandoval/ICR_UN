
function [slope, num_centroid] = Skew_Correction(input_image);
   
    %bw = imfill(bw, 'holes');                                  %fill holes with pixels
    [label num] = bwlabel(input_image), title('num');           %determines the number of bounding boxes to be created

    props = regionprops(label, 'BoundingBox');                  %extract bounding box and centroid properties of the image
box = [props.BoundingBox];                                      %bounding box position and sizes to another matrix
box = reshape(box, [4 num]);                                    %reshape matrix to 4 rows, num columns

box_threshold = 5;                                          
i = 1;
while i<=num                                                      %remove small bounding boxes
    if box(3,i) <= box_threshold && box(4,i) <= box_threshold     %if box width and height <= box_threshold, remove.
        box(:,i) = [];
        num = num-1;
    end
    i = i+1;
end

[row, column] = size(box);
num = column;

for i=1:num;
   rectangle('position', box(:,i), 'edgecolor', 'r');       %label bounding boxes on output
end

for i=1:num;                                                %determine centroid for each bounding box
   box(5,i) = box(3,i) / 2;                                 %center of width
   box(6,i) = box(4,i) / 2;                                 %center of length
   box(7,i) = box(1,i) + box(5,i);
   box(8,i) = box(2,i) + box(6,i);
end

 plot(box(7,:), box(8, :), 'b*');                            %plot centroid on output
 
if num==1                                                   %check if num==1. If true, do slant correction.
    
    a = -40;
    max_peak_average = 0;

        for n = 1 : 18;

            if (n == 18)
                a = 0;
            end

            rotated_image = imrotate(input_image, a);
            
            rows = 0;
            for i = 1 : length(rotated_image(1,:));
                rows(i) = sum(rotated_image(:,i));
            end

            peaks = 0;
            peaks = findpeaks(rows);
            
            if max_peak_average < mean(peaks);
               max_peak_average = mean(peaks);
               slope = a;
            end
            
            a = a+5;
            
        end
   
        num_centroid = 1;
        
else
    leftmost = box(7,1);                                    %determine topleft centroid
    topmost_l = box(8,1);
    for i=1:num
        if leftmost >= box(7,i)  && topmost_l >= box(8,i); 
            leftmost = box(7,i);
            topmost_l = box(8,i);
            topleft = i;
        end
    end
    
    check = 1;                                              %check if each iteration has increasing height and width (for test_skew.png)
    for i=1:num-1;
       if box(7:8,i) < box(7:8,i+1)
           check = check+1;
       end
    end
    
    
    rightmost = box(7,1);                                   %determine topright centroid
    topmost_r = box(8,1);
    %top_right = box(7:8, 1);
    for i=num:-1:1;
        if rightmost <= box(7,i) && topmost_r >= box(8,i) || (rightmost <= box(7,i) && topmost_r <= box(8,i) && check==num)
                rightmost = box(7,i);
                topmost_r = box(8,i);
                topright = i;
        end
    end
    
    height = box(8,topright) - box(8,topleft), title('height');
    width = box(7,topright) - box(7,topleft), title('width');
    slope = height/width, title('slope');                   %slope to be used as skew angle
    
    num_centroid = num;

end

end