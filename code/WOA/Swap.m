function [newpop] = Swap(pop,action,C,A,b,n)
    global k_num m_num;
    for k=1:1:k_num+m_num
        pop{1,k}(pop{1,k}==0) = [];
        len1(k) = size(pop{1,k},2);
    end
    value1 = [];
    if action == 0
        jj = 1;
        kk = abs(jj + round(C*n/A)) - n * round(abs(jj + round(C/A)*n)/n) + 1;
        for k = 1:1:k_num+m_num+1
            for i =1:1:len1(k)
                value1(end+1) = pop{1,k}(1,i);
            end
        end
        r_j = value1(jj);
        r_k = value1(kk);
        value1(kk) = r_j;
        value1(jj) = r_k;
        pop{1,1} = value1(1:len1(1));
        for k = 2:1:k_num+m_num+1
            pop{1,k} = value1(len1(k-1)+1:len1(k-1)+len1(k));
        end 
    elseif action == 1
        k = randi([1,k_num+m_num]);
        route = pop{1,k};
        while size(route(:),1) == 0
            k = randi([1,k_num+m_num]);
            route = pop{1,k};
        end
        a = randi([1,size(route(:),1)]);
        b = randi([1,size(route(:),1)]);
        if a>b
            route1_ab = route(b:a);
            route1_ab = fliplr(route1_ab);
            route(b:a) = route1_ab;
        else
            route1_ab = route(a:b);
            route1_ab = fliplr(route1_ab);
            route(a:b) = route1_ab;
        end
        pop{1,k} = route;
    elseif action == 2
        k = randi([1,k_num+m_num]);
        route = pop{1,k};
        while size(route(:),1) == 0
            k = randi([1,k_num+m_num]);
            route = pop{1,k};
        end
        a = randi([1,size(route(:),1)]);
        b = randi([1,size(route(:),1)]);
        r_a = route(a);
        r_b = route(b);
        route(a) = r_b;
        route(b) = r_a;
        pop{1,k} = route;
    elseif action == 3
        jj = 1;
        kk = abs(jj + round(C*n/A)) - n * round(abs(jj + round(C/A)*n)/n) + 1;
        k1 = randi([1,k_num+m_num]);
        k2 = randi([1,k_num+m_num]);
        while k2 == k1
            k2 = randi([1,k_num+m_num]);
        end
        route1 = pop{1,k1};
        route2 = pop{1,k2};
        while size(route1(:),1) == 0 || size(route2(:),1) == 0
            k1 = randi([1,k_num+m_num]);
            k2 = randi([1,k_num+m_num]);
            while k2 == k1
                k2 = randi([1,k_num+m_num]);
            end
            route1 = pop{1,k1};
            route2 = pop{1,k2};
        end
        a = randi([1,size(route1(:),1)]);
        b = randi([1,size(route2(:),1)]);
        r1 = route1(a);
        r2 = route2(b);
        route1(a) = r2;
        route2(b) = r1;
        pop{1,k1} = route1;
        pop{1,k2} = route2;
    elseif action == 4
        k1 = randi([1,k_num+m_num]);
        k2 = randi([1,k_num+m_num]);
        while k2 == k1
            k2 = randi([1,k_num+m_num]);
        end
        route1 = pop{1,k1};
        route2 = pop{1,k2};
        while size(route1(:),1) == 0 
            k1 = randi([1,k_num+m_num]);
            while k2 == k1
                k1 = randi([1,k_num+m_num]);
            end
            route1 = pop{1,k1};
        end
        a = randi([1,size(route1(:),1)]);
        b = randi([1,size(route1(:),1)]);
        if size(route2(:),1) == 0 
            c = 0;
        else
            c = randi([1,size(route2(:),1)]);
        end
        if a>b
            route1_ab = route1(b:a);
            route1(b:a) = [];
        else
            route1_ab = route1(a:b);
            route1(a:b) = [];
        end
        route2_c = route2(1:c);
        route2_end = route2(c+1:end);
        route2(c+1:c+length(route1_ab)) = route1_ab;
        route2(c+length(route1_ab)+1:c+length(route1_ab)+length(route2_end)) = route2_end;
        pop{1,k1} = route1;
        pop{1,k2} = route2;
    end
    newpop = repairPopsize(pop);
end

