function [repairRoute] = repairPopsize(Route)
    global k_num m_num i_data k_load m_load I1_data I2_data I3_data;
    unallocated = Route{1,k_num+m_num+1};
    rr = size(I1_data,2) + size(I2_data,2) + 1;
    for k=1:1:k_num+m_num
        route = Route{1,k};
        newroute = [0];
        if k<=k_num
            load(k) = k_load;
            for i=1:1:size(route,2)
                if load(k) >= i_data(2,route(i))
                    newroute(end+1) = route(i);
                    load(k) = load(k) - i_data(2,route(i));
                else
                    unallocated(end+1) = route(i);
                end
            end
        else
            load(k) = m_load;
            for i=1:1:size(route,2)
                if route(i) >= rr
                    unallocated(end+1) = route(i);
                else
                    if load(k) >= i_data(2,route(i))
                        newroute(end+1) = route(i);
                        load(k) = load(k) - i_data(2,route(i));
                    elseif load(k) < i_data(2,route(i)) && m_load >= i_data(2,route(i))
                        newroute(end+1) = 0;
                        newroute(end+1) = route(i);
                        load(k) = m_load - i_data(2,route(i));
                    elseif m_load < i_data(2,route(i))
                        unallocated(end+1) = route(i);
                    end
                end
            end
        end
        Route{1,k} = newroute;
    end
    un = unallocated;
    if isempty(unallocated)~=1
        for i=1:1:size(unallocated,2)
            if unallocated(i) < rr
                for k=1:1:k_num+m_num 
                    if i_data(2,unallocated(i)) <= load(k) && k <= k_num 
                        Route{1,k}(end+1) = unallocated(i);
                        load(k) = load(k) - i_data(2,unallocated(i));
                        un(un==unallocated(i)) = [];
                        break
                    elseif i_data(2,unallocated(i)) <= load(k) && k > k_num   
                        Route{1,k}(end+1) = unallocated(i);
                        load(k) = load(k) - i_data(2,unallocated(i));
                        un(un==unallocated(i)) = [];
                        break
                    elseif i_data(2,unallocated(i)) > load(k) && k > k_num && i_data(2,unallocated(i)) <= m_load
                        Route{1,k}(end+1) = 0;
                        Route{1,k}(end+1) = unallocated(i);
                        load(k) = m_load - i_data(2,unallocated(i));
                        un(un==unallocated(i)) = [];
                        break
                    end
                end
            else
                for k=1:1:k_num
                    if i_data(2,unallocated(i)) <= load(k)
                        Route{1,k}(end+1) = unallocated(i);
                        load(k) = load(k) - i_data(2,unallocated(i));
                        un(un==unallocated(i)) = [];
                        break
                    end
                end
            end
        end
    end
    Route{1,k_num+m_num+1} = un(:)';
    repairRoute = Route;
end

