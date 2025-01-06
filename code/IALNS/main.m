clc;
clear all;
global Dij dij i_data k_num m_num k_load m_load time_window f_load I1_data I2_data I3_data v_k v_f v_m u U nodeij I1 I2 I3 lamda s_i;

load data.mat
initialRoute = initial_population(1);
while size(initialRoute{k_num+m_num+1},1) ~= 0
    initialRoute = initial_population(1);
end
Result = CalTime(initialRoute);
Time = Result.alltime;
bestTime = Result.alltime;
bestRoute = initialRoute;
maxT = 400;
iter = 10;
s_d1 = 20;s_d2 = 12;s_d3 = 8;
T = 100;
c = 0.997;
wde(1:5) = 1;
win(1:3) = 1;
ude(1:5) = 0;
uin(1:3) = 0;
sde(1:5) = 0;
sin(1:3) = 0;
tic
for t = 1:maxT
    choice_delete = wde;
    choice_delete = choice_delete./sum(choice_delete);
    choice_pc = cumsum(choice_delete,2);
    if size(Result.illegalI,2) > 0
        choice_index = 2;
        ude(choice_index) = ude(choice_index) + 1;
    else
        rr = rand(1);
        tar = find(choice_pc >= rr);
        choice_index = tar(1);
        while choice_index == 2
            rr = rand(1);
            tar = find(choice_pc >= rr);
            choice_index = tar(1);
        end
        ude(choice_index) = ude(choice_index) + 1;
    end    
    if choice_index == 1
        [newRoute,delete_route] =  delete_Operator(initialRoute,1);
    elseif choice_index == 2
        [newRoute,delete_route] =  illegal_delete(initialRoute,Result.illegalI);
    elseif choice_index == 3
        [newRoute,delete_route] =  delete_Operator(initialRoute,3);
    elseif choice_index == 4
        [newRoute,delete_route] =  delete_Operator(initialRoute,4);
    elseif choice_index == 5
        [newRoute,delete_route] =  delete_Operator(initialRoute,5);
    end
    choice_insert = win;
    choice_insert = choice_insert./sum(choice_insert);
    [~,choice_insert_index] = max(choice_insert);
    uin(choice_insert_index) = uin(choice_insert_index) + 1;
    if choice_insert_index == 1
        newRoute = Insertion_Operator(newRoute,delete_route,1);
    elseif choice_insert_index == 2
        newRoute = Insertion_Operator(newRoute,delete_route,2);
    elseif choice_insert_index == 3
        newRoute = Insertion_Operator(newRoute,delete_route,3);
    end
    newRoute = RRoute(newRoute);
    Result = CalTime(newRoute);
    newRoute = adjust(newRoute,Result.illegalI);
    Result = CalTime(newRoute);
    newTime = Result.alltime;
    if newTime < bestTime
        bestRoute = newRoute;
        initialRoute = newRoute;
        Time = newTime;
        bestTime = newTime;
        sde(choice_index) = sde(choice_index) + s_d1;
        sin(choice_insert_index) = sin(choice_insert_index) + s_d1;
    elseif newTime < Time
        initialRoute = newRoute;
        Time = newTime;
        sde(choice_index) = sde(choice_index) + s_d2;
        sin(choice_insert_index) = sin(choice_insert_index) + s_d2;
    elseif newTime >= Time
        if rand<exp(-(newTime-Time)/T)
            initialRoute = newRoute;
            Time = newTime;
            sde(choice_index) = sde(choice_index) + s_d3;
            sin(choice_insert_index) = sin(choice_insert_index) + s_d3;
        end
    end
    if mod(t,iter) == 0
        for w = 1:1:size(wde,2)
            if ude(w) == 0
                wde(w) = wde(w);
            else
                wde(w) = (1-0.8)*wde(w) + 0.8*sde(w)/ude(w);
            end
        end
        for w = 1:1:size(win,2)
            if uin(w) == 0
                win(w) = win(w);
            else
                win(w) = (1-0.8)*win(w) + 0.8*sin(w)/uin(w);
            end
        end
        ude(1:5) = 0;
        uin(1:3) = 0;
        sde(1:5) = 0;
        sin(1:3) = 0;
    end
    T = T*c;
    disp(t);
    bestTimeArry(t) = bestTime;
end
toc; 
bestResult = CalTime(bestRoute);
figure(1);
plot(bestTimeArry,'linewidth',1.5);
xlabel('iter');
ylabel('Time');
ylim([0,2000])
grid on;
toc; 
RT = toc;
