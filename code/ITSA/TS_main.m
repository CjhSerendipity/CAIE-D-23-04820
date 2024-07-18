 clc;
clear all;
tic
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
count = 400;
tabuLength = 10;
tabuList = cell(tabuLength,k_num+m_num+1);
candidateNum = 200;
candidatesList = cell(candidateNum,k_num+m_num+1);
initialRoute = initial_population(popsize);
Result = CalTime(initialRoute);
fitness = Result.alltime;
bestRoute = initialRoute;
bestValue = fitness;
tic;
for p = 1:1:count
    for i = 1:1:candidateNum
        action = randi([1,5]);
        if action == 5
            candidatesList(i,1:k_num+m_num+1) = initial_population(1);
        else
            candidatesList(i,1:k_num+m_num+1) = lowOperator(initialRoute,action); 
        end
        actionList(i) = action;
    end
    for i = 1:1:candidateNum
        Re = CalTime(candidatesList(i,:));
        candidatesFit(i) = Re.alltime;
    end
    bestCandidateNum = 100;
    for i = 1:1:candidateNum
        if i <= bestCandidateNum
            bestCandidate(i).ord = i;
            bestCandidate(i).route = candidatesList(i,1:k_num+m_num+1);
            bestCandidate(i).fit = candidatesFit(i);
            bestCandidate(i).action = actionList(i);
            bestCandidate(i).tabu = 0;
        else
            for j = 1:1:bestCandidateNum
                if candidatesFit(i) < bestCandidate(j).fit
                    bestCandidate(j).ord = i;
                    bestCandidate(j).route = candidatesList(i,1:k_num+m_num+1);
                    bestCandidate(j).fit = candidatesFit(i);
                    bestCandidate(i).tabu = 0;
                    break
                end
            end
        end
    end
    [~,index] = sort([bestCandidate.fit]);
    bestCandidate = bestCandidate(index);
    if bestCandidate(1).fit < bestValue
        bestValue = bestCandidate(1).fit;
        initialRoute = bestCandidate(1).route;
        bestRoute = initialRoute;
        for i = 1:1:bestCandidateNum
            if bestCandidate(i).tabu ~= 0
                bestCandidate(i).tabu = bestCandidate(i).tabu - 1;
            end
        end
        bestCandidate(i).tabu = tabuLength;
    else
        for i = 1:1:bestCandidateNum
            if bestCandidate(i).tabu == 0
                initialRoute = bestCandidate(1).route;
                for j = 1:1:bestCandidateNum
                    if bestCandidate(j).tabu ~= 0
                        bestCandidate(j).tabu = bestCandidate(j).tabu - 1;
                    end
                end
                bestCandidate(i).tabu = tabuLength;
                break
            end
        end
    end
    arrBestValue(p) = bestValue; 
    disp(p);
end
toc;                                         
time = toc;
BestRoute = bestRoute;                       
BestSatisfaction = bestValue;                        
a = CalTime(bestRoute);
numTime(num) = toc;
numBestTime(num) = BestTime;    

