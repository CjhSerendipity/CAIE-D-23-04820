function [Route] = repair_(Route,illegal)
    global k_num m_num i_data k_load m_load I1 Dij lamda r_code;
    unallocated = Route{1,k_num+m_num+1};
    for k = 1:1:k_num+m_num
        if k <= k_num
            Route{1,k}(Route{1,k} == 0) = [];
            route = Route{1,k};
            aa = [];
            for i = 1:1:size(illegal,2)
                if ismember(illegal(i),route)
                    route(route == illegal(i)) = [];
                    aa(end+1) = illegal(i);
                end
            end
            newroute = route;
            kk = [];
            for i = 1:1:size(route,2)
                if ismember(route(i),I1)
                    kk(end+1) = route(i);
                end
            end
            for i = 1:1:size(aa,2)
                [c,a] = min(Dij(illegal(i),kk));
                if 2*c <= lamda
                    b = find(newroute==kk(a));
                    newroute = [newroute(1:b) aa(i) newroute(b+1:end)];
                else
                    newroute = [newroute aa(i)];
                end
            end
            Route{1,k} = newroute;
        end
    end
    for k=1:1:k_num+m_num
        if k <= k_num
            route = Route{1,k};
            newroute = [0];
            newroute = [newroute,route];
            Route{1,k} = newroute;
        end
    end
end

