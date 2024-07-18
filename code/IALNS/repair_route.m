function [newRoute] = repair_route(InitialRoute,k)
    global k_num i_data m_load ;
    route = InitialRoute;
    newroute = [0];
    if k > k_num
        load(k) = m_load;
        for i=1:1:size(route,2)
            if load(k) >= i_data(2,route(i))
                newroute(end+1) = route(i);
                load(k) = load(k) - i_data(2,route(i));
            elseif load(k) < i_data(2,route(i)) && m_load >= i_data(2,route(i))
                newroute(end+1) = 0;
                newroute(end+1) = route(i);
                load(k) = m_load - i_data(2,route(i));
            end
        end
    else
        newroute = [0,InitialRoute];
    end
    newRoute = newroute;
end