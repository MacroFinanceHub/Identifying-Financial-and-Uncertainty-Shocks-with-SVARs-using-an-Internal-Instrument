clear
close all

yplus = linspace(0,1,100);
xplus = -( 1 - yplus.^2 ).^(0.5);
resplus = xplus.*yplus + ( (1-xplus.^2).*(1-yplus.^2) ).^(0.5);

yminus = linspace(-1,0,100);
xminus = ( 1 - yminus.^2 ).^(0.5);
resminus = xminus.*yminus + ( (1-xminus.^2).*(1-yminus.^2) ).^(0.5);

sum(resplus.^2 + resminus.^2)







asd

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
y0              = 0.01;
y1              = 0.01;
c               = 0;
b0grid          = linspace(0,1,1000);
b1grid          = linspace(0,1,1000);
alp             = 1/3;
R0              = 1.5;
R1              = 1.2;

optP0           = alp*(y0 + b0grid  - c).^(alp - 1) - R0;
[~, loc0]       = min(optP0.^2);
b0opt           = b0grid(loc0);
optP1           = alp*(y1 + b1grid  - c).^(alp - 1) - R1;
[~, loc1]       = min(optP1.^2);
b1opt           = b0grid(loc1);
c               = 0.101;
func            = (y0 + b0opt - c).^alp - R0*b0opt + ...
      (y1 + b1opt + c).^alp - R1*b1opt

























return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
close all

filename = 'Daily';
sheet    = 'Sheet1';
range    = 'A1:I8213';
[data, ~] = xlsread(filename,sheet,range);


k = 1;
for i = 1:length(data)
      i;
      locvec = [data(i,4) == data(i:end,1)];
      loc = find(locvec,1,'first');
      if isempty(loc) == 0
                  DATA(k,:) = [data(loc+i-1,1:3) data(i,4:end)];
                  k = k + 1
      end
end

filename = 'Daily_objs.xlsx';
xlswrite(filename,DATA)





asd

filename = 'SP500_Daily';
sheet    = 'SP500';
range    = 'A1:J17273';
[data, variables] = xlsread(filename,sheet,range);

% Assess names to each variable as an array
for i = 1:size(data,2)
      eval([variables{i} ' = data(:,i);']);
end

j = 1;
i = 2;
m = 1;
y = 1950;
while i <= size(data,1)
      SqReturn_sum = 0;
      while Day(i) - Day(i-1) >= 0 && i < size(data,1)
            SqReturn_sum = SqReturn_sum + DailyRV(i);
            i = i + 1;
      end
      MonthlyRV(j) = SqReturn_sum;
      monthly(j)            = m;
      j = j + 1;
      i = i + 1;
      if m < 12
            m = m + 1;
      else
            m = 1;
            y = y + 1;
      end
end
Months = monthly';
Datamonthly = [Months MonthlyRV'];

j = 1;
for i = 1:length(ciccio)
      if floor(((i - 1)/3)) == (i - 1)/3 && length(ciccio) - i > 3
            Quarterlyciccio(j) = mean(ciccio(i:i+2));
            j = j + 1;
      end
end
RVq = QuarterlyRV';

% filename = 'RVq.xlsx';
% xlswrite(filename,RVq)



return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load aggu

uncertainty = squeeze(mean(ut,2));
%plot(dates,uncertainty(:,1))

dates(1,1)

j = 1;
for i = 1:length(uncertainty)
      if floor(((i - 1)/3)) == (i - 1)/3 && length(uncertainty) - i > 3
            u_quarterly(j,:) = mean(uncertainty(i+2:i+2+2,:),1);
            j = j + 1;
      end
end

u_quarterly = [mean(uncertainty(1:2,:),1); u_quarterly];
time = [1960.25:0.25:2011.5]';
hold on
plot(u_quarterly(:,1))

%xlswrite('uncertainty',[time u_quarterly])

Inflation = [23.943
      23.917
      23.717
      23.660
      23.587
      23.767
      24.203
      24.693
      25.697
      25.947
      25.933
      26.317
      26.417
      26.487
      26.667
      26.697
      26.620
      26.720
      26.843
      26.890
      26.953
      26.910
      26.840
      26.757
      26.793
      26.757
      26.777
      26.857
      26.860
      27.037
      27.317
      27.550
      27.777
      28.013
      28.263
      28.400
      28.737
      28.930
      28.913
      28.943
      28.993
      29.043
      29.193
      29.370
      29.397
      29.573
      29.590
      29.780
      29.840
      29.830
      29.947
      29.990
      30.107
      30.220
      30.307
      30.380
      30.477
      30.533
      30.720
      30.803
      30.930
      30.980
      31.050
      31.193
      31.290
      31.490
      31.583
      31.750
      32.047
      32.337
      32.617
      32.883
      32.967
      33.167
      33.500
      33.867
      34.200
      34.533
      35.000
      35.433
      35.867
      36.433
      36.933
      37.500
      38.100
      38.633
      39.033
      39.600
      39.933
      40.300
      40.700
      41.000
      41.333
      41.600
      41.933
      42.367
      43.033
      43.933
      44.800
      45.933
      47.300
      48.567
      49.933
      51.467
      52.567
      53.200
      54.267
      55.267
      55.900
      56.400
      57.300
      58.133
      59.200
      60.233
      61.067
      61.967
      63.033
      64.467
      65.967
      67.500
      69.200
      71.400
      73.700
      76.033
      79.033
      81.700
      83.233
      85.567
      87.933
      89.767
      92.267
      93.767
      94.600
      95.967
      97.633
      97.933
      98.000
      99.133
      100.100
      101.100
      102.533
      103.500
      104.400
      105.300
      106.267
      107.233
      107.900
      109.000
      109.567
      109.033
      109.700
      110.467
      111.800
      113.067
      114.267
      115.333
      116.233
      117.567
      119.000
      120.300
      121.667
      123.633
      124.600
      125.867
      128.033
      129.300
      131.533
      133.767
      134.767
      135.567
      136.600
      137.733
      138.667
      139.733
      140.800
      142.033
      143.067
      144.100
      144.767
      145.967
      146.700
      147.533
      148.900
      149.767
      150.867
      152.100
      152.867
      153.700
      155.067
      156.400
      157.300
      158.667
      159.633
      160.000
      160.800
      161.667
      162.000
      162.533
      163.367
      164.133
      164.733
      165.967
      167.200
      168.433
      170.100
      171.433
      173.000
      174.233
      175.900
      177.133
      177.633
      177.500
      178.067
      179.467
      180.433
      181.500
      183.367
      183.067
      184.433
      185.133
      186.700
      188.167
      189.367
      191.400
      192.367
      193.667
      196.600
      198.433
      199.467
      201.267
      203.167
      202.333
      204.317
      206.631
      207.939
      210.490
      212.770
      215.538
      218.861
      213.849
      212.378
      213.507
      215.344
      217.030
      217.374
      217.297
      217.934
      219.699
      222.044
      224.568
      226.033
      227.047
      228.326
      228.808
      229.841
      231.369
      232.299
      232.045
      233.300
      234.163
      235.608
      236.839
      237.459
      236.920
      235.355
      236.912
      237.816
      237.888
      237.848
      239.452
      240.548
      242.177
      243.949
      244.010
      245.297
      247.301
      249.442
      250.468];

for ii = 1:length(Inflation)-4
      yearInflation(ii) = log(Inflation(ii+4)) - log(Inflation(ii));
end
yearInflation = [NaN; NaN; NaN; NaN; yearInflation'];

%plot(yearInflation)






















