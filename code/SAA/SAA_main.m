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
popsize = 1;
pop.value = initial_population(1);
Result = CalTime(pop.value);
a = Result.alltime;
pop.obj = a(1,1);
maxObj = pop.obj;
tic;
T0 = 100 ;
T = T0;
r = 0.997 ; 
Ts = 1 ; 
iter = 400;
LK = 200;
tic
for it = 1:1:iter
    arrBest(it) = maxObj;
    arrPopObj(it) = pop.obj;
    for i = 1:1:LK
        a = randi([1,4]);
        newpopvalue = lowOperator(pop.value,a);
        bRe = CalTime(newpopvalue);
        b = bRe.alltime;
        newpopobj = b(1,1);
        if newpopobj < pop.obj
            pop.value = newpopvalue;
            pop.obj = newpopobj;
        else
            p = exp(-(newpopobj-pop.obj)/T);
            if rand(1) < p
                pop.value = newpopvalue;
                pop.obj = newpopobj;
            end
        end
        if pop.obj < maxObj
            maxObj = pop.obj;
            bestRoute = pop.value;
        end
    end
    T = r*T;
    disp(it);
end
toc;                                       
time = toc;
BestPop = pop;
BestTime = maxObj;                        





