function [newpop] = Cross(pop,action)
    global k_num m_num;
    for k=1:1:k_num+m_num
        pop{1,k}(pop{1,k}==0) = [];
    end
    if action == 1
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

    end
    newpop = repairPopsize(pop);
end

