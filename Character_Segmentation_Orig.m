function [segmentation_points] = Character_Segmentation_Orig(input_image_raw)
   
    input_image = bwmorph(input_image_raw,'thin',Inf);
    [image_height,image_width] = size(input_image);
    
    segmentation_points = 0;
    
    for n = 1 : length(input_image(1,:));
        columns(n) = sum(input_image(:,n));
    end
    
    psp(1) = 1;
    ctr_psp = 1;
    for n = 1 : length(columns)-1
       if columns(n) <= 1
        ctr_psp = ctr_psp+1;
        psp(ctr_psp) = n;
       end
    end
    
    psp(ctr_psp) = image_width;
         
% % % % % % % % % %     %%% count instances per gap
% % % % % % % % % %         gaps = [];
% % % % % % % % % %         duplicate = [];
% % % % % % % % % %         for n = 2 : length(psp)
% % % % % % % % % %            pixel_gap = psp(n) - psp(n-1);
% % % % % % % % % %            gaps = [gaps, pixel_gap];
% % % % % % % % % % 
% % % % % % % % % %            %%% remove duplicates
% % % % % % % % % %                for p = 1 : length(psp)
% % % % % % % % % %                    if length(duplicate) == 0
% % % % % % % % % %                        duplicate = [duplicate, pixel_gap];
% % % % % % % % % %                    elseif length(duplicate) > 0 && (length(find(duplicate == pixel_gap)) == 0)
% % % % % % % % % %                        duplicate = [duplicate, pixel_gap];
% % % % % % % % % %                    else
% % % % % % % % % %                    end
% % % % % % % % % %                end
% % % % % % % % % % 
% % % % % % % % % %         end
% % % % % % % % % %         
% % % % % % % % % %     duplicate = sort(duplicate);
% % % % % % % % % %     base = floor(length(duplicate)*.585);
% % % % % % % % % %     duplicate_count = [];
% % % % % % % % % %     
% % % % % % % % % %     %%% count duplicates
% % % % % % % % % %         for n = 1 : length(duplicate)
% % % % % % % % % %             count = length(find(gaps == duplicate(n)));
% % % % % % % % % %             duplicate_count = [duplicate_count, count];
% % % % % % % % % %         end
% % % % % % % % % %     
% % % % % % % % % %     character_threshold = max(duplicate(1:base));
% % % % % % % % % %     spc = 0;
% % % % % % % % % %     reference = psp(1);
% % % % % % % % % %     for n = 2 : length(psp)
% % % % % % % % % %         if (psp(n) - psp(n-1)) > character_threshold
% % % % % % % % % %             spc = spc+1;
% % % % % % % % % %             segmentation_points(spc) = floor((psp(n-1) + reference)/2);
% % % % % % % % % %             reference = psp(n);
% % % % % % % % % %         elseif (psp(n) - psp(n-1)) > 1 && psp(n) - psp(n-1) <= character_threshold
% % % % % % % % % %             reference = psp(n);
% % % % % % % % % %         else
% % % % % % % % % %         end
% % % % % % % % % %     end
% % % % % % % % % %     
% % % % % % % % % %     segmentation_points(length(segmentation_points)+1) = psp(length(psp));
% % % % % % % % % %     

    segmentation_points(1) = 1;
    reference = psp(1);
    char_segmentation_threshold = 9;
    
    ctr_sp = 1;
    for n = 2 : length(psp)
        if psp(n)- psp(n-1) > char_segmentation_threshold
            ctr_sp = ctr_sp + 1;
            segmentation_points(ctr_sp) = floor((psp(n-1) + reference)/2);
            reference = psp(n); 
        end
    end

    segmentation_points(length(segmentation_points)+1) = image_width;
    
     balancing_ratio = .5;

    number_of_char_segments = length(segmentation_points)-1;
    
    spc = number_of_char_segments+1;    
    for n = 1 : number_of_char_segments;
        if (segmentation_points(spc)- segmentation_points(spc-1)) < ((image_width*balancing_ratio)/number_of_char_segments)
            segmentation_points(spc) = [];
        end
        spc = spc-1;
    end
    
%     segmentation_points = psp;
    
end
