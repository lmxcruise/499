
N = 50; %number of banks
alpha = 1;
monetaryReserves = 10000*ones(N,1);
dtMonetaryReserves = zeros(N,1);
sigma = 1000;
maxTime = 10000;
dt = 1/maxTime;
percentChange = 0.01;
for t = 1:maxTime
    for i = 1:N
        rateSum = 0;
        for j = 1:N
            rateSum = rateSum + monetaryReserves(j)-monetaryReserves(i);
        end;
        dW = monetaryReserves(i)*percentChange*sqrt(dt)*randn;
        dtMonetaryReserves(i) = alpha/N*rateSum +sigma*dW;
    end;
    monetaryReserves = dtMonetaryReserves + monetaryReserves;
end;
monetaryReserves