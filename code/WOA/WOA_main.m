?clc;
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
tic;
popsize = 100;
Max_iter = 400;
empty.value = [];
empty.obj = [];
pop = repmat(empty, popsize, 1);
for p=1:1:popsize
    pop(p).value = initial_population(1);
    Result = CalTime(pop(p).value);
    pop(p).obj = Result.alltime;
end
for t = 1:1:Max_iter
    [~, CDSO] = sort([pop.obj]); 
    pop = pop(CDSO);
    n = size(i_data,2);
    a = 2-t*((2)/Max_iter);
    a2 = -1+t*((-1)/Max_iter);
    popc = repmat(empty, 100 ,1);
    for p = 1:1:size(pop,1)
        r1 = rand(); 
        r2 = rand(); 
        A = 2*a*r1-a;
        C = 2*r2;
        b = 1;
        l = (a2-1)*rand+1;
        P = rand();
        j = 1;
        pp = randi([1,popsize]);
        if P < 0.5
            if abs(A) >= 1
                popc(p).value = Swap(pop(1).value,3,C,A,b,n);
            elseif abs(A) < 1
                popc(p).value = Swap(pop(pp).value,3,C,A,b,n);
            end
        else
            popc(p).value = Swap(pop(pp).value,3,C,A,b,n);
        end
        re = CalTime(popc(p).value);
        popc(p).obj = re.alltime;
    end
    newpop = [pop; popc];
    [~, CDSO] = sort([newpop.obj]); 
    pop = newpop(CDSO);
    pop = pop(1:popsize);
    bestObj(t) = pop(1).obj;
    disp([t]);
end
toc;                                         
time = toc;
BestRoute = pop(1).value;                       
BestTime = pop(1).obj;




