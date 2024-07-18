function [Route] = initial_population(popsize)
    global i_data k_num m_num k_load m_load time_window I1_data I2_data I3_data; 
    I_num =  size(i_data,2);
    rr = size(I1_data,2) + size(I2_data,2) + 1;
    r_code = 0;
    km_data2(1,:) = [1:k_num+m_num];
    km_data2(2,1:k_num) = k_load;
    km_data2(2,k_num+1:k_num+m_num) = m_load;
    Route = cell(popsize,k_num+m_num+1);
    for p = 1:1:popsize
        UnallocatedRegion = cell(1);
        [~,b] = sort(time_window(2,:));
        for a = 1:1:size(b,2)
            c = find(b == a);
            random_rank(a) = c;
        end
        % random_rank = randperm(I_num);
        km_data = km_data2;
        for k = 1:1:k_num+m_num
            route{k}(1,1) =[0];
        end
        for i = 1:1:I_num
            random_km = randi([1,k_num+m_num]);
            while random_km > k_num && random_rank(i) >= rr
                random_km = randi([1,k_num]);
            end
            if i_data(2,random_rank(i)) <= km_data(2,random_km)
                route{random_km}(end+1) = random_rank(i);
                km_data(2,random_km) =  km_data(2,random_km) - i_data(2,random_rank(i));
            else
                if random_km <= k_num && random_rank(i) >= rr
                    if  max(km_data(2,1:k_num)) >=  i_data(2,random_rank(i))
                        while i_data(2,random_rank(i)) > km_data(2,random_km)
                            random_km = randi([1,k_num]);
                        end
                        route{random_km}(end+1) = random_rank(i);
                        km_data(2,random_km) =  km_data(2,random_km) - i_data(2,random_rank(i));
                    else
                        UnallocatedRegion{1}(end+1) = random_rank(i);
                    end
                elseif random_rank(i) < rr
                    if max(km_data(2,1:k_num+m_num)) >=  i_data(2,random_rank(i)) || m_load >= i_data(2,random_rank(i))
                        while i_data(2,random_rank(i)) > km_data(2,random_km)
                            random_km = randi([1,k_num+m_num]);
                            if random_km > k_num && km_data(2,random_km) < i_data(2,random_rank(i)) && m_load >= i_data(2,random_rank(i))
                                km_data(2,random_km) = m_load;
                                route{random_km}(end+1) = 0;
                                route{random_km}(end+1) = random_rank(i);
                                km_data(2,random_km) =  km_data(2,random_km) - i_data(2,random_rank(i));
                                break
                            elseif i_data(2,random_rank(i)) <= km_data(2,random_km)
                                route{random_km}(end+1) = random_rank(i);
                                km_data(2,random_km) =  km_data(2,random_km) - i_data(2,random_rank(i));
                                break
                            end  
                        end
                    else
                        UnallocatedRegion{1}(end+1) = random_rank(i);
                    end
                end
            end
        end
        for i=1:1:k_num+m_num
            route{i}(:) =  route{i}(:)';
        end
        Route(p,1:k_num+m_num) = route(1,1:k_num+m_num);
        Route(p,k_num+m_num+1) = UnallocatedRegion(:);
    end 
end

