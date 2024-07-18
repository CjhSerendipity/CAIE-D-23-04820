function [newRoute] = Insertion_Operator(InitialRoute,delete_route,num)
    global k_num m_num I1_data I2_data m_load i_data k_load 
    if num == 1
        dr = size(delete_route,2);
        for k = 1:k_num+m_num
            InitialRoute{1,k} = repair_route(InitialRoute{1,k},k);
        end
        for i = 1:1:dr
            min_t = [];
            for k = 1:k_num + m_num
                if k > k_num
                    if delete_route(i) > size(I1_data,2) + size(I2_data,2) || i_data(2,delete_route(i)) > m_load
                        continue
                    end
                end
                route = InitialRoute{1,k};
                route_time = CalRouteTime(route,k);
                route(route==0) = [];
                min_t(k) = inf;
                nroute_s = route;
                nroute_s = [delete_route(i),nroute_s];
                nroute_s = repair_route(nroute_s,k);
                nroute_s_time = CalRouteTime(nroute_s,k);
                d_t_start = nroute_s_time - route_time;
                min_r{1,k} = nroute_s;
                min_t(k) =  d_t_start;
                nroute_e = route;
                nroute_e = [nroute_e,delete_route(i)];
                nroute_e = repair_route(nroute_e,k);
                nroute_e_time = CalRouteTime(nroute_e,k);
                d_t_end = nroute_e_time - route_time;
                if min_t(k) > d_t_end
                    min_r{1,k} = nroute_e;
                    min_t(k) =  d_t_end;
                end
                for j = 1:size(route,2)
                    nroute = route;
                    nroute = [nroute(1:j),delete_route(i),nroute(j+1:end)];
                    nroute = repair_route(nroute,k);
                    nroute_time = CalRouteTime(nroute,k);
                    d_t = nroute_time - route_time;
                    if d_t < min_t(k)
                        min_r{1,k} = nroute;
                        min_t(k) =  d_t;
                    end  
                end
            end
            [~,mk] = min(min_t);
            InitialRoute{1,mk} = min_r{1,mk};
        end
        newRoute = InitialRoute;
    elseif num == 2
        %     loadK(1:k_num) = k_load;
%     loadK(k_num+1:k_num + m_num) = m_load;
%     for k = 1:1:k_num
%         route = InitialRoute{1,k};
%         for i = 1:1:size(route,2)
%             loadK(k) = loadK(k) - i_data(route(i));
%         end
%     end
    for i = 1:1:size(delete_route,2)
        if delete_route(i) > size(I1_data,2) + size(I2_data,2) || i_data(2,delete_route(i)) > m_load
            randK = randi([1,k_num]);
        else
            randK = randi([1,k_num+m_num]);
        end
%         while delete_route(i) > loadK(randK)
%             randK = randi([1,k_num+m_num]);
%         end
%         if randK <= k_num
%             loadK(randK) = loadK(randK) - i_data(delete_route(i));
%         end
        route = InitialRoute{1,randK};
        if size(route,2) ~= 0
            randn = randi([1,size(route,2)]);
            if randn == 1
                route = [delete_route(i),route];
            elseif randn == size(route,2)
                route = [route,delete_route(i)];
            else
                route = [route(1:randn-1),delete_route(i),route(randn:end)];
            end
        else
            route = [delete_route(i),route];
        end
        InitialRoute{1,randK} = route;
    end
    for k = 1:k_num+m_num
        InitialRoute{1,k} = repair_route(InitialRoute{1,k},k);
    end
    newRoute = InitialRoute;
    elseif num == 3
        dr = size(delete_route,2);
        for k = 1:k_num+m_num
            InitialRoute{1,k} = repair_route(InitialRoute{1,k},k);
        end
        for i = 1:1:dr
            min_t = [];
            for k = 1:k_num + m_num
                if k > k_num
                    if delete_route(i) > size(I1_data,2) + size(I2_data,2) || i_data(2,delete_route(i)) > m_load
                        continue
                    end
                end
                route = InitialRoute{1,k};
                route_time = CalRouteTime(route,k);
                route(route==0) = [];
                min_t(k) = inf;
                nroute_s = route;
                nroute_s = [delete_route(i),nroute_s];
                nroute_s = repair_route(nroute_s,k);
                nroute_s_time = CalRouteTime(nroute_s,k);
                d_t_start = nroute_s_time - route_time;
                min_r{1,k} = nroute_s;
                min_t(k) =  d_t_start;
                nroute_e = route;
                nroute_e = [nroute_e,delete_route(i)];
                nroute_e = repair_route(nroute_e,k);
                nroute_e_time = CalRouteTime(nroute_e,k);
                d_t_end = nroute_e_time - route_time;
                if min_t(k) > d_t_end
                    min_r{1,k} = nroute_e;
                    min_t(k) =  d_t_end;
                end
                for j = 1:size(route,2)
                    nroute = route;
                    nroute = [nroute(1:j),delete_route(i),nroute(j+1:end)];
                    nroute = repair_route(nroute,k);
                    nroute_time = CalRouteTime(nroute,k);
                    d_t = nroute_time - route_time;
                    if d_t < min_t(k)
                        min_r{1,k} = nroute;
                        min_t(k) =  d_t;
                    end  
                end
            end
            [~,mk] = min(min_t);
            InitialRoute{1,mk} = min_r{1,mk};
        end
        newRoute = InitialRoute;
    end
end