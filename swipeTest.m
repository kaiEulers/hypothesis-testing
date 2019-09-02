% If testResult = [1 0 0 0], reader is declared NOT
% FAULTY and it is NOT FAULTY.
% P[declaring not faulty AND is not faulty]

% If testResult = [0 1 0 0], reader is declared FAULTY
% and it is FAULTY.
% P[declaring faulty AND is faulty]

% If testResult = [0 0 1 0], reader is declared FAULTY
% but it is NOT FAULTY.
% P[false alarm]*P[not faulty]
% = P[declaring faulty|is not faulty]*P[is not faulty]
% = P[declaring faulty AND is not faulty]

% If testResult = [0 0 0 1], reader is declared NOT
% FAULTY but it is FAULTY.
% P[miss]*P[is faulty]
% = P[declaring not faulty|is faulty]*P[is faulty]
% = P[declaring not faulty AND is faulty]

% falseAlarm = 1 if reader is declared FAULTY
% given that it is NOT FAULTY.
% P[declaring faulty|is not faulty] = P[false alarm]
% falseAlarm = 0 if reader is declared NOT FAULTY
% given that it is NOT FAULTY.
% P[delcaring not faulty|is not faulty]
% Otherwise falseAlarm = NaN

% miss = 1 if reader is declared NOT FAULTY
% given that it is FAULTY.
% P[declaring not faulty|is faulty] = P[miss]
% miss = 0 if reader is declared FAULTY
% given that it is FAULTY.
% P[declaring faulty|is faulty]
% Otherwise miss = NaN

function [testResult, falseAlarm, miss, cost] = swipeTest(n_thres)
    
    % Probability that a reader of the entire
    % population is faulty
    pr_H1 = 0.22;
    % fault = 1 denotes that tested reader is actually
    % faulty fault = 0 denotes that tested reader is
    % actually faulty
    if rand() <= pr_H1
        fault = 1;
    else
        fault = 0;
    end
    
    % Simulate test executed on reader to find out if
    % it is faulty
    P1 = 0.1;
    P0 = 0.02;
    if fault == 1
        % If reader is actually faulty, the n number of
        % test swipes before a fail swipe occurs
        % follows the RV N~geometric(0.1)        
        % testSwipes = geornd(P1) + 1;
        testSwipes = 1;
        u = rand();
        while u > P1
            if u > P1
                testSwipes = testSwipes + 1;
                u = rand();
            end
        end
    else
        % If reader is actually not faulty, the n
        % number of test swipes before a fail swipe
        % occurs follows the RV N~geometric(0.02)
        % testSwipes = geornd(P0) + 1;
        testSwipes = 1;
        u = rand();
        while u > P0
            if u > P0
                testSwipes = testSwipes + 1;
                u = rand();
            end
        end
    end
    
    % --------------------Decision Rule
    % If the number of test swipes before
    % the swipe fails is more than n_thres, the reader
    % is declared NOT faulty. Otherwise, it is
    % declared faulty.
    if testSwipes >= n_thres
        declare = 0;
    else
        declare = 1;
    end
    
    % --------------------Display Results
    disp('Decision Rule:')
    disp(['Declare reader is not faulty if N >= ' num2str(n_thres)])
    disp('Otherwise, reader is faulty.')
    disp(' ')
    if fault == 0 && declare == 0
        disp('Reader is declared NOT FAULTY.')
        disp('Reader is in actual fact NOT FAULTY.')
        testResult = [1 0 0 0];
        miss = NaN;
        falseAlarm = 0;
        cost = [0 0 0 0];
    elseif fault == 1 && declare == 1
        disp('Reader is declared FAULTY.')
        disp('Reader is in actual fact FAULTY.')
        testResult = [0 1 0 0];
        miss = 0;
        falseAlarm = NaN;
        cost = [0 0 0 0];
    elseif fault == 0 && declare == 1
        disp('Reader is declared FAULTY.')
        disp('Reader is in actual fact NOT FAULTY.')
        disp('This is a FALSE ALARM.')
        testResult = [0 0 1 0];
        miss = NaN;
        falseAlarm = 1;
        cost = [0 0 0 10];
    elseif fault == 1 && declare == 0
        disp('Reader is declared NOT FAULTY.')
        disp('Reader is in actual fact FAULTY.')
        disp('This is a MISS.')
        testResult = [0 0 0 1];
        miss = 1;
        falseAlarm = NaN;
        cost = [0 0 50 0];
    end
    
end