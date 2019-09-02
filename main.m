%% PRM Workshop 5: Hypothesis Testing
%% Question 3: Likelihood Function Plots
clc, clear
% H0: Reader is not faulty
% H1: Reader is faulty

% fn_h0: Swipe card fails after n trials GIVEN THAT the
% reader is not faulty
% fn_h1: Swipe card fails GIVEN THAT the reader is
% faulty
P1 = 0.1;
P0 = 0.02;
nMax = 100;
n = 0:nMax;
pn_h1 = P1*(1-P1).^(n-1);
pn_h0 = P0*(1-P0).^(n-1);

figure(1)
stairs(n, pn_h0, 'linewidth', 1)
hold on
stairs(n, pn_h1, 'linewidth', 1)
hold off
xlabel('Number of Swipes')
ylabel('Probability')
title('Maximum Likelihood Decision Rule')
legend({
    'p_{N|H_0}(n)'
    'p_{N|H_1}(n)'
    })
grid on
saveas(figure(1), 'ML.jpg')

%% Question 4: A Posteriori Probability Plots
clc, clear
% H0: Reader is not faulty
% H1: Reader is faulty
pr_H1 = 0.22;
pr_H0 = 1 - pr_H1;

% fn__h0: Swipe card fails after n trials AND the
% reader is not faulty
% fn__h1: Swipe card fails given AND the reader is
% faulty
P1 = 0.1;
P0 = 0.02;
nMax = 100;
n = 0:nMax;
pn__h1 = pr_H1 * P1*(1-P1).^(n-1);
pn__h0 = pr_H0 * P0*(1-P0).^(n-1);

figure(2)
stairs(n, pn__h0, 'linewidth', 1)
hold on
stairs(n, pn__h1, 'linewidth', 1)
hold off
xlabel('Number of Swipes')
ylabel('Probability')
title('Maximum A Posteriori Desicion Rule')
legend({
    [num2str(pr_H0) '\cdotp_{N|H_0}(n)']
    [num2str(pr_H1)  '\cdotp_{N|H_1}(n)']
    })
grid on
saveas(figure(2), 'MAP.jpg')

%% Question 5: Cost weighted Joint Probability Plots
clc, clear
% H0: Reader is not faulty
% H1: Reader is faulty
pr_H1 = 0.22;
pr_H0 = 1 - pr_H1;

% Cost weighting of False Alarms and Misses
c_FA = 10;
c_miss = 50;
c_ratio = c_miss/c_FA;

% fn_h0: Swipe card fails after n trials given that the
% reader is not faulty
% fn_h1: Swipe card fails given that the reader is
% faulty
P1 = 0.1;
P0 = 0.02;
nMax = 100;
n = 0:nMax;
pn__h0 = pr_H0 * P0*(1-P0).^(n-1);
pn__h1 = c_ratio*pr_H1 * P1*(1-P1).^(n-1);

figure(3)
stairs(n, pn__h0, 'linewidth', 1)
hold on
stairs(n, pn__h1, 'linewidth', 1)
hold off
xlabel('Number of Swipes')
ylabel('Probability')
title('Maximum A Posteriori Desicion Rule with cost weighting')
legend({
    [num2str(pr_H0) '\cdotp_{N|H_0}(n)']
    [num2str(c_ratio*pr_H1) '\cdotp_{N|H_1}(n)']
    })
grid on

% Expected costs per test
for n = 1:nMax
    
    pr_FA = 1 - (1-P0)^n;
    pr_miss = 1 - (1 - (1-P1)^n);
    
    expCost_FA = pr_FA*pr_H0 * c_FA;
    expCost_miss = pr_miss*pr_H1 * c_miss;
    expCost_total(n,1) = expCost_miss + expCost_FA;
    
end
expCost_min = min(expCost_total)

figure(4)
stairs([1:nMax], expCost_total, 'linewidth', 1)
xlabel('Number of Swipes')
ylabel('Expected costs per test')
title({
    'Expected cost per test'
    ['c_{miss} = $' num2str(c_miss) '      c_{FA} = $' num2str(c_FA)]
    })
grid on

%% Question 7a: Simulation of Swipe Test with n_thres = 24
% Using Decision Rule from Question 5:
% Declare reader is not faulty is N >= 24, otherwise,
% reader is faulty.
clc, clear

n_thres = 24;
% The entire simulation is written in function
% swipeTest()
swipeTest(n_thres);

%% Question 7a: Simulation of Swipe Test with n_thres = 23
% Using Decision Rule from Question 6:
% Declare reader is not faulty is N >= 38, otherwise,
% reader is faulty.
clc, clear

n_thres = 38;
% The entire simulation is written in function
% swipeTest()
swipeTest(n_thres);

%% Question 7b: Empirical Probablity after 2e6 trials
% Using Decision Rule from Question 5:
% Declare reader is not faulty is N >= 24, otherwise,
% reader is faulty.
clc, clear
n_thres = 24;
trials = 2e6;

testResults = zeros(trials, 4);
miss = zeros(trials, 1);
falseAlarm = zeros(trials, 1);
cost = zeros(trials, 4);

for k = 1:trials
    % swipeTest0() is the same as swipeTest() with all
    % display outputs disabled.
    [testResults(k,:), falseAlarm(k), miss(k), cost(k,:)] = swipeTest0(n_thres);
end
save PRMws5_Q7b1 testResults falseAlarm miss cost
%%
clc, load PRMws5_Q7b1
% Cost weighting of False Alarms and Misses
c_FA = 10;
c_miss = 50;

% --------------------Theoretical Probabilities
% H0: Reader is not faulty
% H1: Reader is faulty
pr_H1 = 0.22;
pr_H0 = 1 - pr_H1;

% fn__h0: Swipe card fails after n trials AND the
% reader is not faulty
% fn__h1: Swipe card fails given AND the reader is
% faulty
P1 = 0.1;
P0 = 0.02;

% Theoretical Probability of False Alarm
n_thres = 24;
n = n_thres - 1;
pr_FA = 1 - (1-P0)^n;
% Theoretical Probability of Miss
pr_miss = (1-P1)^n;

% Theoretical Probabilities
pr_notFaulty__notFaulty = (1 - pr_FA)*pr_H0;
pr_faulty__faulty = (1 - pr_miss)*pr_H1;
pr_faulty__notFaulty = pr_FA*pr_H0;
pr_notFaulty__faulty = pr_miss*pr_H1;

% Theoretical expected cost per test
expCost_FA = pr_FA*pr_H0 * c_FA;
expCost_miss = pr_miss*pr_H1 * c_miss;
expCost_total = expCost_miss + expCost_FA;

% --------------------Empirical Probabilities
empPr_notFaulty__notFaulty = mean(testResults(:, 1));
empPr_faulty__faulty = mean(testResults(:, 2));
empPr_faulty__notFaulty = mean(testResults(:, 3));
empPr_notFaulty__faulty = mean(testResults(:, 4));
empPr_FA = nanmean(falseAlarm);
empPr_miss = nanmean(miss);

% Empirical expected cost per test
empExpCost_FA = mean(cost(:, 3));
empExpCost_miss = mean(cost(:, 4));
empExpCost_total = empExpCost_miss + empExpCost_FA;

% --------------------Display Results
Probability_of = {
    'Declare Not Faulty AND is Not Faulty'
    'Declare Faulty AND is Faulty'
    'Declare Faulty AND is Not Faulty'
    'Declare Not Faulty AND is Faulty'
    []
    'False Alarm'
    'Miss'
    []
    'Expected cost per test of False Alarm'
    'Expected cost per test of Miss'
    'Total Expected cost per test'
    };
Empirical_Value ={
    [num2str(empPr_notFaulty__notFaulty*100) '%']
    [num2str(empPr_faulty__faulty*100) '%']
    [num2str(empPr_faulty__notFaulty*100) '%']
    [num2str(empPr_notFaulty__faulty*100) '%']
    []
    [num2str(empPr_FA*100) '%']
    [num2str(empPr_miss*100) '%']
    []
    ['$' num2str(empExpCost_FA)]
    ['$' num2str(empExpCost_miss)]
    ['$' num2str(empExpCost_total)]
    };
Theoretical_Value ={
    [num2str(pr_notFaulty__notFaulty*100) '%']
    [num2str(pr_faulty__faulty*100) '%']
    [num2str(pr_faulty__notFaulty*100) '%']
    [num2str(pr_notFaulty__faulty*100) '%']
    []
    [num2str(pr_FA*100) '%']
    [num2str(pr_miss*100) '%']
    []
    ['$' num2str(expCost_miss)]
    ['$' num2str(expCost_FA)]
    ['$' num2str(expCost_total)]
    };
disp('Decision Rule:')
disp(['Declare reader is not faulty if N <= ' num2str(n_thres)])
disp('Otherwise, reader is faulty.')
disp(' ')
disp(table(Probability_of, Empirical_Value, Theoretical_Value))

% Check that all Empirical Probabilities add up to 1
% empPr_notFaulty__notFaulty + empPr_faulty__faulty + empPr_faulty__notFaulty + empPr_notFaulty__faulty

%% Question 7b: Empirical Probablity after 2e6 trials
% Using Decision Rule from Question 6:
% Declare reader is not faulty is N >= 23, otherwise,
% reader is faulty.
clc, clear
n_thres = 39;
trials = 2e6;

testResults = zeros(trials, 4);
miss = zeros(trials, 1);
falseAlarm = zeros(trials, 1);
cost = zeros(trials, 4);

for k = 1:trials
    % swipeTest0() is the same as swipeTest() with all
    % display outputs disabled.
    [testResults(k,:), falseAlarm(k), miss(k), cost(k,:)] = swipeTest0(n_thres);
end
save PRMws5_Q7b2 testResults falseAlarm miss cost
%%
clc, load PRMws5_Q7b2
% Cost weighting of False Alarms and Misses
c_FA = 10;
c_miss = 50;

% --------------------Theoretical Probabilities
% H0: Reader is not faulty
% H1: Reader is faulty
pr_H1 = 0.22;
pr_H0 = 1 - pr_H1;

% fn__h0: Swipe card fails after n trials AND the
% reader is not faulty
% fn__h1: Swipe card fails given AND the reader is
% faulty
P1 = 0.1;
P0 = 0.02;

% Theoretical Probability of False Alarm
n_thres = 39;
n = n_thres - 1;
pr_FA = 1 - (1-P0)^n;
% Theoretical Probability of Miss
pr_miss = (1-P1)^n;

% Theoretical Probabilities
pr_notFaulty__notFaulty = (1 - pr_FA)*pr_H0;
pr_faulty__faulty = (1 - pr_miss)*pr_H1;
pr_faulty__notFaulty = pr_FA*pr_H0;
pr_notFaulty__faulty = pr_miss*pr_H1;

% Theoretical expected cost per test
expCost_FA = pr_FA*pr_H0 * c_FA;
expCost_miss = pr_miss*pr_H1 * c_miss;
expCost_total = expCost_miss + expCost_FA;

% --------------------Empirical Probabilities
empPr_notFaulty__notFaulty = mean(testResults(:, 1));
empPr_faulty__faulty = mean(testResults(:, 2));
empPr_faulty__notFaulty = mean(testResults(:, 3));
empPr_notFaulty__faulty = mean(testResults(:, 4));
empPr_FA = nanmean(falseAlarm);
empPr_miss = nanmean(miss);

% Empirical expected cost per test
empExpCost_FA = mean(cost(:, 3));
empExpCost_miss = mean(cost(:, 4));
empExpCost_total = empExpCost_miss + empExpCost_FA;

% --------------------Display Results
Probability_of = {
    'Declare Not Faulty AND is Not Faulty'
    'Declare Faulty AND is Faulty'
    'Declare Faulty AND is Not Faulty'
    'Declare Not Faulty AND is Faulty'
    []
    'False Alarm'
    'Miss'
    []
    'Expected cost per test of False Alarm'
    'Expected cost per test of Miss'
    'Total Expected cost per test'
    };
Empirical_Value ={
    [num2str(empPr_notFaulty__notFaulty*100) '%']
    [num2str(empPr_faulty__faulty*100) '%']
    [num2str(empPr_faulty__notFaulty*100) '%']
    [num2str(empPr_notFaulty__faulty*100) '%']
    []
    [num2str(empPr_FA*100) '%']
    [num2str(empPr_miss*100) '%']
    []
    ['$' num2str(empExpCost_FA)]
    ['$' num2str(empExpCost_miss)]
    ['$' num2str(empExpCost_total)]
    };
Theoretical_Value ={
    [num2str(pr_notFaulty__notFaulty*100) '%']
    [num2str(pr_faulty__faulty*100) '%']
    [num2str(pr_faulty__notFaulty*100) '%']
    [num2str(pr_notFaulty__faulty*100) '%']
    []
    [num2str(pr_FA*100) '%']
    [num2str(pr_miss*100) '%']
    []
    ['$' num2str(expCost_miss)]
    ['$' num2str(expCost_FA)]
    ['$' num2str(expCost_total)]
    };
disp('Decision Rule:')
disp(['Declare reader is not faulty if N >= ' num2str(n_thres)])
disp('Otherwise, reader is faulty.')
disp(' ')
disp(table(Probability_of, Empirical_Value, Theoretical_Value))

% Check that all Empirical Probabilities add up to 1
% empPr_notFaulty__notFaulty + empPr_faulty__faulty + empPr_faulty__notFaulty + empPr_notFaulty__faulty
