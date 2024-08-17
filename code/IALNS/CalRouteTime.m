function [time] = CalRouteTime(Route,k)
   global Dij dij i_data k_num time_window f_load I1 v_k v_f v_m u U lamda s_i;
    r = size(i_data,2) + 1;
    illegalI = [];
    route = Route;
    route(1) = r;
    poi_km = r;
    poi_f = poi_km;
    t_km = 0;
    t_f = 0;
    if k > k_num
        for i = 1:1:size(route,2)-1
            j = i +1;
            if route(j) == 0
                route(j) = r;
            end
            lenij = dij(poi_km,route(j));
            t = lenij/v_m;
            if route(j) ~= r
                t_km = t_km + t + s_i;
                if t_km <= time_window(1,route(j))
                    illegalI(end+1) = route(j);
                elseif t_km > time_window(2,route(j))
                    illegalI(end+1) = route(j);
                end                
            else
                t_km = t_km + t + s_i;
            end
            poi_km = route(j);
        end
    else
        for i = 1:1:size(route,2)-1
            j = i + 1;
            if ismember(route(j),I1)
                lenij = dij(poi_km,route(j));
                t = lenij/v_k;
                t_km = t_km + t + s_i;
                if t_km <= time_window(1,route(j))
                    illegalI(end+1) = route(j);
                elseif t_km > time_window(2,route(j))
                    illegalI(end+1) = route(j);
                end     
                if poi_km == poi_f
                    poi_km = route(j);
                    poi_f = poi_km;
                    t_f = t_km;
                else
                    poi_km = route(j);
                    if poi_km == poi_f
                        t_km = max(t_km,t_f) + U;
                        t_f = t_km;
                    end
                end
            else 
                lenij = Dij(poi_f,route(j));
                if 2*lenij > lamda
                    illegalI(end+1) = route(j);
                end
                t = lenij/v_f;
                fin = ceil(i_data(2,route(j))/f_load);
                t_f = t_f + (fin-1)*(u+U+s_i + 2*t) + u + t + s_i;
                if t_km <= time_window(1,route(j))
                    if ~ismember(route(j),illegalI)
                        illegalI(end+1) = route(j);
                    end
                elseif t_km > time_window(2,route(j))
                    if ~ismember(route(j),illegalI)
                        illegalI(end+1) = route(j);
                    end
                end     
                poi_f = route(j);
                if j == size(route,2)
                    t_km = t_f + t + U;
                    t_f = t_km;
                    poi_f = poi_km;
                    continue
                end
                if  ~ismember(route(j+1),I1)
                    t_km = t_f + t + U;
                    t_f = t_km;
                    poi_f = poi_km;
                else
                    ii_num = [];
                    for ii = j+1:1:size(route,2)
                        if ismember(route(ii),I1)
                            ii_num(end+1) = route(ii);
                        else
                            break
                        end
                    end
                    for ii = size(ii_num,2):-1:1
                        if lenij + Dij(route(j),ii_num(ii)) <= lamda
                            t_km = t_f - t - s_i;
                            poi_f = ii_num(ii);
                            t_f = t_f + Dij(route(j),ii_num(ii))/v_f;
                            break
                        else
                            t_km = t_f + t + U;
                            t_f = t_km;
                            poi_f = poi_km;
                        end
                    end
                end
            end
        end
    end
    time = t_km + size(illegalI,2)*1000;
end
