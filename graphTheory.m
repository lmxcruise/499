%Graph theory version
N = 10; %number of banks
alpha = 1;
monetaryReserves = 1000*ones(N,1);
dtMonetaryReserves = zeros(N,1);
sigma = 1;
maxTime = 100;
dt = 1/maxTime;

for t = 1:maxTime
    for i = 1:N
        rateSum = 0;
        for j = 1:N
            rateSum = rateSum + monetaryReserves(j)-monetaryReserves(i);
        end;
        dW = monetaryReserves(i)*sqrt(dt)*randn;
        dtMonetaryReserves(i) = alpha/N*rateSum +sigma*dW;
    end;
    monetaryReserves = dtMonetaryReserves + monetaryReserves;
end;
monetaryReserves