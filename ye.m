clear;
N = 5; %number of banks
alpha = 100;
sigma = 1;
maxTime = 252; %252 time step # of trading days in a year
dt = 1/maxTime;
monetaryReserves = zeros(N,1);
initialCapital = 0*ones(N,1);
dtMonetaryReserves = zeros(N,1);
realizationReserves = zeros(N, maxTime);

for t = 1:maxTime
    for i = 1:N
        rateSum = 0;
        for j = 1:N
            rateSum = rateSum + (monetaryReserves(j)-monetaryReserves(i));
        end;
        dW = sqrt(dt)*randn;
        dtMonetaryReserves(i) = alpha/N*rateSum*dt +sigma*dW;
    end;
    if(t == 1)
        monetaryReserves = dtMonetaryReserves + initialCapital;
        realizationReserves(:,t) = monetaryReserves;
    else 
        monetaryReserves = dtMonetaryReserves + monetaryReserves;
        realizationReserves(:,t) = monetaryReserves;
    end;
end;
monetaryReserves
t = 1:maxTime;
figure(1);

for i =1:N
    plot(t,realizationReserves(i,:));
    hold on;
end;
title(['Alpha = ', num2str(alpha), ' realization']);
xlabel('Time');
xlim([0 252]);
ylim([-3 3]);

