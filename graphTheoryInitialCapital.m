%Graph theory version
clear;
numBanks = 10; %number of banks
alpha = 10;
sigma = 0.001;
numIterations = 100;
maxTime = 252; %252 time step # of trading days in a year
dt = 1/maxTime;
monetaryReturns = zeros(numBanks,1);
Capital = 100*exprnd(1:numBanks)';
initialCapital = Capital;
averageCapital = mean(Capital);
dtMonetaryReturns = zeros(numBanks,1);
realizationReturns = zeros(numBanks, maxTime);
realizationCapital = zeros(numBanks, maxTime);
numDefault = zeros(numBanks+1,1);
numFailed = zeros(numIterations,1);


     
% random initialization 
% d = ones(numBanks,1); % The diagonal values
% t = triu(round(rand(numBanks)), 1); % The upper trianglar random values
% a = diag(d)+t+t'; % Put them together in a symmetric matrix

% trivial case (all connected)
a = ones(numBanks,numBanks) - eye(numBanks);


for k = 1:numIterations
    for t = 1:maxTime
        realizationReturns(:,t) = monetaryReturns;
        realizationCapital(:,t) = Capital;
        for i = 1:numBanks
            rateSum = 0;
            for j = 1:numBanks
                rateSum = rateSum + a(i,j)*(monetaryReturns(j)-monetaryReturns(i)*Capital(j));
            end;
            dW = sqrt(dt)*randn;
            dtMonetaryReturns(i) = alpha/(numBanks*averageCapital)*rateSum*dt + sigma*dW;
        end;
        
        monetaryReturns = dtMonetaryReturns + monetaryReturns;
        Capital = 10.^(monetaryReturns).*Capital;
            
    end;
    for i = 1:numBanks
        if(Capital(i)<.75*initialCapital(i))
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
xlim([0 numBanks])


figure(3);
% A realization of bank reserves
t = 1:maxTime;
for i =1:numBanks
    plot(t,realizationReturns(i,:));
    hold on;
end;
title(['Alpha = ', num2str(alpha), ' realizationReturns']);
xlabel('Time');
xlim([0 252]);
ylim([-0.002 0.002]);

figure(2);
for i = 1:numBanks
    plot(t,realizationCapital(i,:));
    hold on;
end;
title(['Alpha = ', num2str(alpha), ' realizationCapital']);
xlabel('Time');
xlim([0 252]);

% ylim([-3 3]);
