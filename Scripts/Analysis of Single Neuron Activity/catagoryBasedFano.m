function [mean_vec_cat,var_vec_cat,SpikeTrain_it_all] = catagoryBasedFano(SpikeTrain_it_all,catagory,catagoryLabel,mean_vec_cat,var_vec_cat,...
    number_of_neurons,sliding_step,window_length,number_of_time_slices)

    for i = 1:number_of_neurons
        cm =  SpikeTrain_it_all(i).cm;
        SpikeTrain_it = SpikeTrain_it_all(i).data;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
        if(strcmp('face',catagory) == 1)

            data_face  = [];

            for k = 1:length(catagoryLabel)
                test_face = find(catagoryLabel(k) == cm);
                data_face = [data_face ; SpikeTrain_it(test_face,:)];
            end
            SpikeTrain_it_all(i).faceData = data_face;
            SpikeTrain_it_face = SpikeTrain_it_all(i).faceData;
            spike_count_2_face = zeros(size(SpikeTrain_it_face,1),number_of_time_slices);
    
            for j = 1:size(SpikeTrain_it_face,1)
                for u = 1:number_of_time_slices
                    temp = SpikeTrain_it_face(j,1+sliding_step*(u-1):window_length+sliding_step*(u-1));
                    spike_count_2_face(j,u) = sum(temp);
                end
            end
    
            SpikeTrain_it_all(i).countSpikes_face = spike_count_2_face;
    
            for u = 1:number_of_time_slices
                mean_vec_cat(i,u) = mean(SpikeTrain_it_all(i).countSpikes_face(:,u));
                var_vec_cat(i,u)  = var(SpikeTrain_it_all(i).countSpikes_face(:,u));
            end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
        elseif(strcmp('body',catagory) == 1)
            
            data_body = [];
            
            for k = 1:length(catagoryLabel)
                test_body = find(catagoryLabel(k) == cm);
                data_body = [data_body ; SpikeTrain_it(test_body,:)];
            end
   
            SpikeTrain_it_all(i).BodyData = data_body;
            SpikeTrain_it_body = SpikeTrain_it_all(i).BodyData;
    
            spike_count_2_body = zeros(size(SpikeTrain_it_body,1),number_of_time_slices);
    
            for j = 1:size(SpikeTrain_it_body,1)
               for u = 1:number_of_time_slices
                   temp = SpikeTrain_it_body(j,1+sliding_step*(u-1):window_length+sliding_step*(u-1));
                   spike_count_2_body(j,u) = sum(temp);
               end
            end
    
            SpikeTrain_it_all(i).countSpikes_body = spike_count_2_body;
    
            for u = 1:number_of_time_slices
                mean_vec_cat(i,u) = mean(SpikeTrain_it_all(i).countSpikes_body(:,u));
                var_vec_cat(i,u)  = var(SpikeTrain_it_all(i).countSpikes_body(:,u));
            end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
        elseif(strcmp('natural',catagory) == 1)
            
            data_natural = [];
            for k = 1:length(catagoryLabel)
                test_natural = find(catagoryLabel(k) == cm);
                data_natural = [data_natural ; SpikeTrain_it(test_natural,:)];
            end
   
            natural_counter = 0;
            SpikeTrain_it_all(i).NaturalData = data_natural;
            SpikeTrain_it_natural = SpikeTrain_it_all(i).NaturalData;
    
            spike_count_2_natural = zeros(size(SpikeTrain_it_natural,1),number_of_time_slices);
    
            for j = 1:size(SpikeTrain_it_natural,1)
                for u = 1:number_of_time_slices
                    temp = SpikeTrain_it_natural(j,1+sliding_step*(u-1):window_length+sliding_step*(u-1));
                    spike_count_2_natural(j,u) = sum(temp);
                end
            end
    
            SpikeTrain_it_all(i).countSpikes_natural = spike_count_2_natural;
    
            for u = 1:number_of_time_slices
                mean_vec_cat(i,u) = mean(SpikeTrain_it_all(i).countSpikes_natural(:,u));
                var_vec_cat(i,u)  = var(SpikeTrain_it_all(i).countSpikes_natural(:,u));
            end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
        elseif(strcmp('artifact',catagory) == 1)
            data_artifact = [];
            for k = 1:length(catagoryLabel)
                test_artifact = find(catagoryLabel(k) == cm);
                data_artifact = [data_artifact ; SpikeTrain_it(test_artifact,:)];
            end
   
            SpikeTrain_it_all(i).AtifactData = data_artifact;
            SpikeTrain_it_artifact = SpikeTrain_it_all(i).AtifactData;
    
            spike_count_2_artifact = zeros(size(SpikeTrain_it_artifact,1),number_of_time_slices);
    
            for j = 1:size(SpikeTrain_it_artifact,1)
                for u = 1:number_of_time_slices
                    temp = SpikeTrain_it_artifact(j,1+sliding_step*(u-1):window_length+sliding_step*(u-1));
                    spike_count_2_artifact(j,u) = sum(temp);
                end
            end
    
            SpikeTrain_it_all(i).countSpikes_artifact = spike_count_2_artifact;
    
            for u = 1:number_of_time_slices
                mean_vec_cat(i,u) = mean(SpikeTrain_it_all(i).countSpikes_artifact(:,u));
                var_vec_cat(i,u)  = var(SpikeTrain_it_all(i).countSpikes_artifact(:,u));
            end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
        else
            data_nonface = [];
            for k = 1:length(catagoryLabel)
                test_nonface= find(catagoryLabel(k) == cm);
                data_nonface= [data_nonface ; SpikeTrain_it(test_nonface,:)];
            end
   
            SpikeTrain_it_all(i).nonfaceData = data_nonface;
            SpikeTrain_it_nonface = SpikeTrain_it_all(i).nonfaceData;
    
            spike_count_2_nonface = zeros(size(SpikeTrain_it_nonface,1),number_of_time_slices);
    
            for j = 1:size(SpikeTrain_it_nonface,1)
                for u = 1:number_of_time_slices
                    temp = SpikeTrain_it_nonface(j,1+sliding_step*(u-1):window_length+sliding_step*(u-1));
                    spike_count_2_nonface(j,u) = sum(temp);
                end
            end
    
            SpikeTrain_it_all(i).countSpikes_nonface = spike_count_2_nonface;
    
            for u = 1:number_of_time_slices
                mean_vec_cat(i,u) = mean(SpikeTrain_it_all(i).countSpikes_nonface(:,u));
                var_vec_cat(i,u)  = var(SpikeTrain_it_all(i).countSpikes_nonface(:,u));
            end 
        end
    end
end