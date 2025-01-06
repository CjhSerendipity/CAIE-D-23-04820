function [Result] = CalTime(InitialRoute)
    global Dij dij i_data k_num m_num time_window f_load I1 v_k v_f v_m u U lamda s_i;
    r = size(i_data,2) + 1;
    TT = 0;
    MDT = 0;
    TDT = 0;
    DDT = 0;
    TDCT = 0;
    TDN = 0;
    MDN = 0;
    DDN = 0;
    illegalI = [];
    for k = 1:1:k_num+m_num
        route = InitialRoute{1,k};
        route(1) = r;
        poi_km = r;
        route_k = [poi_km];
        poi_f = poi_km;
        route_f = [poi_f];
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
                    MDN = MDN + 1;
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
                route_k(end+1) = poi_km;
            end
            MDT = t_km + MDT;
            Result.routek{k}(:) = route_k;
        else
            stop_f = [0];
            for i = 1:1:size(route,2)-1
                j = i + 1;
                if ismember(route(j),I1)
                    lenij = dij(poi_km,route(j));
                    t = lenij/v_k;
                    t_km = t_km + t + s_i;
                    TDT = TDT + t + s_i;
                    TDN = TDN + 1;
                    if t_km <= time_window(1,route(j))
                        illegalI(end+1) = route(j);
                    elseif t_km > time_window(2,route(j))
                        illegalI(end+1) = route(j);
                    end     
                    if poi_km == poi_f
                        poi_km = route(j);
                        route_k(end+1) = route(j);
                        poi_f = poi_km;
                        t_f = t_km;
                        route_f(end+1) = poi_f;
                    else
                        poi_km = route(j);
                        route_k(end+1) = route(j);
                        if poi_km == poi_f
                            TDCT = max(t_f-t_km,0)+ U + TDCT;
                            t_km = max(t_km,t_f) + U;
                            t_f = t_km;
                        end
                    end
                else 
                    DDN = DDN + 1;
                    lenij = Dij(poi_f,route(j));
                    if 2*lenij > lamda
                        illegalI(end+1) = route(j);
                    end
                    t = lenij/v_f;
                    fin = ceil(i_data(2,route(j))/f_load);
                    t_f = t_f + (fin-1)*(u+U+s_i + 2*t) + u + t + s_i;
                    DDT = DDT + (fin-1)*(u+U+s_i + 2*t) + u + t + s_i;
                    TDCT = TDCT + (fin-1)*(u+U+s_i + 2*t) + u + t + s_i;
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
                    route_f(end+1) = route(j);
                    if j == size(route,2)
                        t_km = t_f + t + U;
                        DDT = DDT + t + U;
                        TDCT = TDCT + t + U;
                        t_f = t_km;
                        poi_f = poi_km;
                        route_f(end+1) = poi_f;
                        continue
                    end
                    if  ~ismember(route(j+1),I1)
                        t_km = t_f + t + U;
                        DDT = DDT + t + U;
                        TDCT = TDCT + t + U;
                        t_f = t_km;
                        poi_f = poi_km;
                        route_f(end+1) = poi_f;
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
                                TDCT = TDCT - t - s_i;
                                poi_f = ii_num(ii);
                                route_f(end+1) = ii_num(ii);
                                t_f = t_f + Dij(route(j),ii_num(ii))/v_f;
                                DDT = DDT + Dij(route(j),ii_num(ii))/v_f;
                                break
                            else
                                t_km = t_f + t + U;
                                DDT = DDT + t + U;
                                TDCT = TDCT + t + U;
                                t_f = t_km;
                                poi_f = poi_km;
                                route_f(end+1) = poi_f;
                            end
                        end
                    end
                end
            end
            Result.routek{k}(:) = route_k;
            Result.routef{k}(:) = route_f;
        end
        Result.time(k) =  t_km;
        TT = t_km + TT;
    end
    Result.alltime = sum(Result.time);
    Result.timeAnum = [TT,TDT,DDT,MDT,TDCT,TDN,DDN,MDN];
    Result.illegalI = illegalI;
    if size(InitialRoute{1,k_num+m_num+1},2) ~= 0  || size(illegalI,2) > 0
        Result.alltime = Result.alltime + size(illegalI,2)*1000+ size(InitialRoute{1,k_num+m_num+1},2)*1000;
    end
end
