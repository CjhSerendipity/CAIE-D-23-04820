clc;
clear all;
global Dij dij i_data k_num m_num k_load m_load time_window f_load I1_data I2_data I3_data v_k v_f v_m u U nodeij I1 I2 I3 lamda s_i;
i_data = xlsread('data/i_data.xlsx');
nodeij = xlsread('data/nodeij.xlsx');
for i = 1:1:size(nodeij,1)
    for j = 1:1:size(nodeij,1)
        dij(i,j) = sqrt(power(nodeij(i,1)-nodeij(j,1),2)+power(nodeij(i,2)-nodeij(j,2),2))*500;
    end
end
I1_data = i_data(:,1:25);
I2_data = i_data(:,26:45);
I3_data = i_data(:,46:50);
I1 = [1:25];
I2 = [26:45];
I3 = [46:50];
Dij = dij;
time_window = i_data(3:5,:);
k_num = 2;
k_load = 300;
m_num = 4;
m_load = 30;
f_load = 5;
v_k = 900;
v_m = 1200;
v_f = 1500;
u = 1/3;
U = 1/3;
lamda = 30000;
s_i = 0.5;
popsize = 100;
maxGen = 400;
pc = 0.9;
nc = 90;
mu = 0.5;
empty.value = [];
empty.obj = [];
empty.allTime = [];
empty.cumP = [];
pop = repmat(empty, popsize, 1);
for p=1:1:popsize
    initialRoute = initial_population(1);
    pop(p).value = initialRoute;
    Result(p) = CalTime(pop(p).value);
    pop(p).obj = Result(p).alltime;
end
tic
for p = 1:1:maxGen
    popc = repmat(empty, nc ,1);
    for i = 1:2:nc
        p1 = pop(i);
        p2 = pop(i+1);
        p1.value = Cross(p1.value,1);
        p2.value = Cross(p2.value,2);
        popc(i).value = p1.value;
        popc(i+1).value = p2.value;
    end
    for i = 1:1:nc
        if rand <= mu
           popc(i).value = mutate(popc(i).value,3);
        end
        popc(i).value = repair_all_route(popc(i).value);
        newResult(i) = CalTime(popc(i).value);
        popc(i).obj = newResult(i).alltime;
    end
    newpop = [pop; popc];
    [~, CDSO] = sort([newpop.obj] ); 
    pop = newpop(CDSO);
    pop = pop(1:popsize);
    bestObj(p) = pop(1).obj;
    disp([p]);
end
BestRoute = pop(1).value;                       
BestTime = pop(1).obj;                       
toc;                                        
time = toc;


