function [newRoute,delete_route] = illegal_delete(InitialRoute,illegalI)
    global k_num m_num;
    for k=1:1:k_num+m_num
        InitialRoute{1,k}(InitialRoute{1,k}==0) = [];
    end
    k = randi([1,k_num + m_num]);
    for i = size(illegalI,2)
        for k = 1:1:k_num + m_num
            InitialRoute{1,k}(InitialRoute{1,k}==illegalI(i)) = [];
        end
    end
    newRoute = InitialRoute;
    delete_route = illegalI;
end
        
  