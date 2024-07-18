function [newRoute,delete_route] = delete_Operator(InitialRoute,num)
    global k_num m_num i_data I1_data I2_data I3_data dij Dij
    if num == 1
        for k=1:1:k_num+m_num
            InitialRoute{1,k}(InitialRoute{1,k}==0) = [];
        end
        k = randi([1,k_num + m_num]);
        route = InitialRoute{1,k};
        while size(route,2) == 0
            k = randi([1,k_num+m_num]);
            route = InitialRoute{1,k};
        end
        a = randi([1,size(route(:),1)]);
        b = randi([1,size(route(:),1)]);
        if a>b
            route1_ab = route(b:a);
            route(b:a) = [];
        else
            route1_ab = route(a:b);
            route(a:b) = [];
        end
        newRoute = InitialRoute;
        newRoute{1,k} = route;
        delete_route = route1_ab;
    elseif num == 3
        delete_route = [];
        for k=1:1:k_num+m_num
            InitialRoute{1,k}(InitialRoute{1,k}==0) = [];
        end
        n = randi([1,ceil(size(i_data,2)/2)]);
        for i = 1:n
            k = randi([1,k_num + m_num]);
            route = InitialRoute{1,k};
            while size(route,2) == 0
                k = randi([1,k_num+m_num]);
                route = InitialRoute{1,k};
            end
            m = randi([1,size(route,2)]);
            delete_route(end+1) = InitialRoute{1,k}(m);
            InitialRoute{1,k}(m) = [];
        end
        newRoute = InitialRoute;
     elseif num == 4
        D_time = [];
        delete_route = [];
        n = randi([1,ceil(size(i_data,2)/2)]);
        for k = 1:k_num+m_num
            route = InitialRoute{1,k};
            t = CalRouteTime(route,k);
            InitialRoute{1,k}(InitialRoute{1,k}==0) = [];
            route = InitialRoute{1,k};
            for i = 1:size(route,2)
                nroute = route;
                nroute(i) = []; 
                nroute = repair_route(nroute,k);
                tt =  CalRouteTime(nroute,k);
                D_time(1,route(i)) = t - tt;
                D_time(2,route(i)) = k;
            end
        end
        newRoute = InitialRoute;
        for nn = 1:n
            [~,maxtimeIndex] = max(D_time(1,:));
            maxtimeK = D_time(2,maxtimeIndex);
            D_time(:,maxtimeIndex) = [0,0];
            delete_route(end+1) = maxtimeIndex;
            route = newRoute{1,maxtimeK};
            b = find(route == maxtimeIndex);
            route(b) = [];
            newRoute{1,maxtimeK} = route;
            route = repair_route(route,maxtimeK);
            t = CalRouteTime(route,maxtimeK);
            for i = 1:size(route,2)
                if route(i) == 0
                    continue
                else
                    nroute = route;
                    nroute(i) = []; 
                    tt =  CalRouteTime(nroute,maxtimeK);
                    D_time(1,route(i)) = t - tt;
                    D_time(2,route(i)) = maxtimeK;
                end
            end
        end
    elseif num == 5
        alpha1 = 5;alpha2 = 3;
        I1 = size(I1_data,2);
        I2 = size(I2_data,2);
        I3 = size(I3_data,2);
        maxdij_I1 = max(max(dij(1:I1,1:I1)));
        maxdij_I2 = max(max(dij(I1+1:I1+I2,I1+1:I1+I2)));
        maxdij_I3 = max(max(dij(I1+I2+1:I1+I2+I3,I1+I2+1:I1+I2+I3)));
        maxdeij_I1 = 0;
        maxdeij_I2 = 0;
        maxdeij_I3 = 0;
        for i = 1:1:size(i_data,2)
            for j = 1:1:size(i_data,2)
                if i <= I1
                    a = abs(i_data(2,i) - i_data(2,j));
                    if a > maxdeij_I1
                        maxdeij_I1 = a;
                    end
                elseif i > I1 && i<= I1+I2      
                    b = abs(i_data(2,i) - i_data(2,j));
                    if b > maxdeij_I2
                        maxdeij_I2 = b;
                    end
                elseif i > I1+I2 
                    c = abs(i_data(2,i) - i_data(2,j));
                    if c > maxdeij_I3
                        maxdeij_I3 = c;
                    end
                end
            end
        end
        n = randi([1,ceil(size(i_data,2)/4)]);
        for i = 1:1:n
            randI = randi([1,size(i_data,2)]);
            delete_ij(1,i) = randI; 
            Qij(1:I1+I2+I3) = inf;
            if randI <= I1
                for j = 1:1:I1
                    if j ~= randI
                        Qij(j) = alpha1*dij(randI,j)/maxdij_I1 + alpha2*abs(i_data(2,randI)-i_data(2,j))/maxdeij_I1;
                    end
                end
            elseif randI > I1 && randI <= I1+I2
                for j = I1+1:1:I1+I2
                    if j ~= randI             
                        Qij(j) = alpha1*dij(randI,j)/maxdij_I2 + alpha2*abs(i_data(2,randI)-i_data(2,j))/maxdeij_I2;
                    end
                end
            elseif randI > I1+I2
                for j = I1+I2+1:1:I1+I2+I3
                    if j ~= randI
                        Qij(j) = alpha1*dij(randI,j)/maxdij_I3 + alpha2*abs(i_data(2,randI)-i_data(2,j))/maxdeij_I3;
                    end
                end
            end
            [~,randJ] = min(Qij);
            delete_ij(2,i) = randJ; 
        end
        deleteI = [delete_ij(1,:),delete_ij(2,:)];
        delete_route = unique(deleteI);
        for i = 1:1:size(delete_route,2)
            for k = 1:1:k_num+m_num
                InitialRoute{1,k}(InitialRoute{1,k}==0) = [];
                InitialRoute{1,k}(InitialRoute{1,k}==delete_route(i)) = [];
            end
        end
        newRoute = InitialRoute;
    end
end