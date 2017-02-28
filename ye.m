clear;
numBanks = 10; %number of banks
alpha = 100;
sigma = 5;
numIterations = 10000;
maxTime = 252; %252 time step # of trading days in a year
dt = 1/maxTime;
monetaryReserves = zeros(numBanks,1);
initialCapital = 0*ones(numBanks,1);
dtMonetaryReserves = zeros(numBanks,1);
realizationReserves = zeros(numBanks, maxTime);
numDefault = zeros(numBanks+1,1);
numFailed = zeros(numIterations,1);

for k = 1:numIterations
    for t = 1:maxTime
        for i = 1:numBanks
            rateSum = 0;
            for j = 1:numBanks
                rateSum = rateSum + (monetaryReserves(j)-monetaryReserves(i));
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

monetaryReserves
plot(numDefault/numIterations);
title(['Alpha = ', num2str(alpha)]);
xlabel('Number of Default');
% xlim([0 numBanks])
numDefault



% t = 1:maxTime;
% figure(1);


% A realization of bank reserves
% for i =1:N
%     plot(t,realizationReserves(i,:));
%     hold on;
% end;
% title(['Alpha = ', num2str(alpha), ' realization']);
% xlabel('Time');
% xlim([0 252]);
% ylim([-3 3]);

