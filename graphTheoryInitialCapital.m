%Graph theory version
clear;
numBanks = 10; %number of banks
alpha = 1;
sigma = 15;
numIterations = 10000;
maxTime = 252; %252 time step # of trading days in a year
dt = 1/maxTime;
monetaryReserves = zeros(numBanks,1);
initialCapital = 0*ones(numBanks,1);
dtMonetaryReserves = zeros(numBanks,1);
realizationReserves = zeros(numBanks, maxTime);
numDefault = zeros(numBanks+1,1);
numFailed = zeros(numIterations,1);
% Spoke(edges not connected) 3 center points
% a = [   0 1 1 0 0 0 0 0 1 1;
%         1 0 0 0 0 0 1 1 0 1;
%         1 0 0 0 0 0 0 0 0 0;
%         0 0 0 0 0 0 0 0 0 1;
%         0 0 0 0 0 0 0 0 0 1;
%         0 0 0 0 0 0 0 0 0 1;
%         0 1 0 0 0 0 0 0 0 0;
%         0 1 0 0 0 0 0 0 0 0;
%         1 0 0 0 0 0 0 0 0 0;
%         1 1 0 1 1 1 0 0 0 0 ];  
        
% Spoke 1 center
% a = [0, 1, 1, 1, 1, 1, 1, 1, 1, 1; 
%     1, 0, 0, 0, 0, 0, 0, 0, 0, 0; 
%     1, 0, 0, 0, 0, 0, 0, 0, 0, 0; 
%     1, 0, 0, 0, 0, 0, 0, 0, 0, 0; 
%     1, 0, 0, 0, 0, 0, 0, 0, 0, 0; 
%     1, 0, 0, 0, 0, 0, 0, 0, 0, 0; 
%     1, 0, 0, 0, 0, 0, 0, 0, 0, 0; 
%     1, 0, 0, 0, 0, 0, 0, 0, 0, 0; 
%     1, 0, 0, 0, 0, 0, 0, 0, 0, 0; 
%     1, 0, 0, 0, 0, 0, 0, 0, 0, 0]; 

% wheel and spoke 1 center
a = [0, 1, 1, 1, 1, 1, 1, 1, 1, 1; 
    1, 0, 1, 0, 0, 0, 0, 0, 0, 1;
    1, 1, 0, 1, 0, 0, 0, 0, 0, 0; 
    1, 0, 1, 0, 1, 0, 0, 0, 0, 0; 
    1, 0, 0, 1, 0, 1, 0, 0, 0, 0; 
    1, 0, 0, 0, 1, 0, 1, 0, 0, 0; 
    1, 0, 0, 0, 0, 1, 0, 1, 0, 0; 
    1, 0, 0, 0, 0, 0, 1, 0, 1, 0; 
    1, 0, 0, 0, 0, 0, 0, 1, 0, 1; 
    1, 1, 0, 0, 0, 0, 0, 0, 1, 0 ];


     
% random initialization 
% d = ones(numBanks,1); % The diagonal values
% t = triu(round(rand(numBanks)), 1); % The upper trianglar random values
% a = diag(d)+t+t'; % Put them together in a symmetric matrix

% trivial case (all connected)
% a = ones(numBanks,numBanks) - eye(numBanks);


for k = 1:numIterations
    for t = 1:maxTime
        for i = 1:numBanks
            rateSum = 0;
            for j = 1:numBanks
                rateSum = rateSum + a(i,j)*(monetaryReserves(j)-monetaryReserves(i));
            end;
            dW = sqrt(dt)*randn;
            dtMonetaryReserves(i) = alpha/numBanks*rateSum*dt +sigma*dW;
        end;
        if(t == 1)
            monetaryReserves = dtMonetaryReserves + initialCapital;
            realizationReserves(:,t) = monetaryReserves;
        else 
            monetaryReserves = dtMonetaryReserves + monetaryReserves;
            realizationReserves(:,t) = monetaryReserves;
        end;
    end;
    for i = 1:numBanks
        if(monetaryReserves(i)<-0.7)
            numFailed(k) = numFailed(k)+1;
        end;
    end;
end;
for i = 1:numIterations
   numDefault(numFailed(i)+1) = numDefault(numFailed(i)+1) + 1;
end;

plot(numDefault/numIterations);
title(['Alpha = ', num2str(alpha)]);
xlabel('Number of Default');
% xlim([0 numBanks])
