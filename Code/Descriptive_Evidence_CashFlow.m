%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%  Marco Brianti, PhD Candidate, Boston College, Department of Economics, August 8, 2018
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear
close all

% Reading Data
filename                    = 'Quarterly';
sheet                       = 'Quarterly Data';
range                       = 'B1:BG274';
do_truncation               = 1; %Do not truncate data. You will have many NaN
[dataset, var_names]        = read_data(filename, sheet, range, do_truncation);
tf                          = isreal(dataset);
if tf == 0
      warning('Dataset has complex variables in it.')
end
dataset                     = real(dataset);
time_start                  = dataset(1,1);
time_end                    = dataset(end,1);
[~, DatasetHP]              = hpfilter(dataset,1600);
for iif = 3:length(dataset)
      [~ , dataset_HPgen]   = hpfilter(dataset(1:iif,:),1600);
      DatasetHP1S(iif,:)    = dataset_HPgen(end,:);
end

% Obtain Principal Components
filename                    = 'DatasetPC';
sheet                       = 'Quarterly';
range                       = 'B2:DA288';
do_truncation_PC            = 1; %Do not truncate data. You will have many NaN
dataPC                      = read_data(filename,sheet,range,do_truncation_PC);
tfPC                        = isreal(dataset);
if tfPC == 0
      warning('DatasetPC has complex variables in it.')
end
dataPC                      = real(dataPC);
time_start_PC               = dataPC(1,1);
time_end_PC                 = dataPC(end,1);

% Align the two datasets
align_datasets = 1;
if align_datasets == 1
      if time_start < time_start_PC
            loc_start = find(dataset(:,1) == time_start_PC);
            dataset = dataset(loc_start:end,:);
      elseif time_start > time_start_PC
            loc_start = find(dataPC(:,1) == time_start);
            dataPC = dataPC(loc_start:end,:);
      end
      if time_end < time_end_PC
            loc_end = find(dataPC(:,1) == time_end);
            dataPC = dataPC(1:loc_end,:);
      elseif time_end > time_end_PC
            loc_end = find(dataset(:,1) == time_end);
            dataset = dataset(1:loc_end,:);
      end
end

% Assess names to each variable as an array
for i = 1:size(dataset,2)
      eval([var_names{i} ' = dataset(:,i);']);
end

% Assess names to each variable as an array
for i = 1:size(dataset,2)
      eval([var_names{i} 'HP = DatasetHP(:,i);']);
end

% Assess names to each variable as an array
for i = 1:size(dataset,2)
      eval([var_names{i} 'HP1S = DatasetHP1S(:,i);']);
end

% Proper Transformations - All the variables should be in logs
SP5001            = SP5001 - GDPDef;
SP5002            = SP5002 - GDPDef;
ProfTransfers     = ProfitsTransfers - Dividends;
OtherCF           = CashFlow - CorpProfitsAdj - CorpProfitsAdj;
CashFlow          = CashFlow - CorpProfitsAdj;
Dividends         = Dividends - CorpProfitsAdj;
ConsFixedK        = ConsFixedK - CorpProfitsAdj;
CPAdj             = CorpProfitsAdj - GDPDef;
NetKTransfers     = NetKTransfers./CorpProfitsAdj;
Tax               = CorpProfitsbefTax - CorpProfitsAdj;
TenYTreasury      = TenYTreasury;

% Obtaine Principal Components
Zscore                      = 1; %remove mean and divide over the variance each series
pc                          = get_principal_components(dataPC(:,2:end),Zscore);
pc1                         = pc(:,1);
pc2                         = pc(:,2);
pc3                         = pc(:,3);
pc4                         = pc(:,4);
pc5                         = pc(:,5);
pc6                         = pc(:,6);

% Step 1 - Get Innovations in both EBP and MacroUncert
nlags1 = 4;
yEBP = GZSpread(1+nlags1:end);
yJLN = MacroUncertH3(1+nlags1:end);
PC   = [pc(:,1:4) GZSpread MacroUncertH3];
k1   = 1;
for j = 1:nlags1
      xPC(:,k1:k1+size(PC,2)-1) = [PC(1+nlags1-j:end-j,:)];
      k1           = k1 + size(PC,2);
end
[~, ~, resEBP] = quick_ols(yEBP,xPC);
[~, ~, resJLN] = quick_ols(yJLN,xPC);

% Step 2 - Regress CashFlow on resEBP and resJLN
nlags = nlags1;
Y     = Cash2Equity(1+nlags+nlags1:end);
%X     = [GDP Investment Consumption SP5002 Hours MacroUncertH3 EBP CashFlow];
X     = [PC Cash2Equity];
k     = 1;
for j = 1:nlags
      XX(:,k:k+size(X,2)-1) = [X(1+nlags-j+nlags1:end-j,:)];
      k           = k + size(X,2);
end
[~, ~, resCF]  = quick_ols(Y,XX);
XX             = [XX resEBP(1+nlags:end) resJLN(1+nlags:end)];%
LM             = fitlm(XX,Y,'linear')

clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Creat Figure
figure
hold on
set(gcf,'color','w');
plot(Time,zscore(MacroUncertH3),'--','Linewidth',3)
%plot(Time,zscore(RV),'--','Linewidth',3)
%plot(Time,zscore(GZSpread),'-','Linewidth',1.5)
plot(Time,zscore(GZSpread),'-','Linewidth',2.25)
%plot(Time,zscore(MoodySpreadAaa),'-','Linewidth',1.5)
grid on
LGD          = legend('Ut - Jurado et al. (2015) - Uncertainty','Ft - Gilchrist and Zakrajsek (2012) - Credit Spread','Location','northwest');
LGD.FontSize = 32;
legend boxoff
axis tight
xt = get(gca, 'XTick');
set(gca, 'FontSize', 20)
set(gca,'yticklabel',{[]}) 
xlabel('Quarters','fontsize',32)
%ylabel('Standard Deviations','fontsize',32)

%export_fig('Financial_Uncertainty')
% ZZ = [MacroUncertH3 RV GZSpread EBP MoodySpreadAaa];
% corr(ZZ);


azsxdcghj


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% HP1S w/o EBP
Y         = CashFlowHP1S;
X         = [MacroUncertH3HP1S GDPHP1S];
%X         = [VXOHP1S GDPHP1S];
LM        = fitlm(X,Y,'linear')
% HP1S with EBP
Y         = CashFlowHP1S;
X         = [MacroUncertH3HP1S EBPHP1S GDPHP1S];
%X         = [VXOHP1S EBPHP1S GDPHP1S];
LM        = fitlm(X,Y,'linear')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% HP w/o EBP
Y         = CashFlowHP;
X         = [MacroUncertH3HP GDPHP];
%X         = [VXOHP GDPHP];
LM        = fitlm(X,Y,'linear')
% HP with EBP
Y         = CashFlowHP;
X         = [MacroUncertH3HP EBPHP GDPHP];
%X         = [VXOHP EBPHP GDPHP];
LM        = fitlm(X,Y,'linear')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nlags = 5;
% diff w/o EBP
clear X
difference = 0;
if difference == 1
      Y = diff(CashFlow(1+nlags:end));
else
      Y = CashFlow(1+nlags:end);
end
k = 1;
for j = 1:nlags+1
      X(:,k:k+1) = [MacroUncertH1(1+nlags-j+1:end-j+1)...
            GDP(1+nlags-j+1:end-j+1)];
      %X(:,k:k) = [MacroUncertH1(2+nlags-j+1:end-j+1)];
      %X(:,k:k+1) = [VXO(1+nlags-j+1:end-j+1)...
      %GDP(1+nlags-j+1:end-j+1)];
      k = k + 2;
end
LM        = fitlm(X,Y,'linear')
% diff with EBP
clear X
k = 1;
for j = 1:nlags+1
      X(:,k:k+2) = [MacroUncertH1(1+nlags-j+1:end-j+1)...
            GDP(1+nlags-j+1:end-j+1) EBP(1+nlags-j+1:end-j+1)];
      %       X(:,k:k+1) = [MacroUncertH1(2+nlags-j+1:end-j+1) EBP(2+nlags-j+1:end-j+1)];
      %X(:,k:k+2) = [VXO(1+nlags-j+1:end-j+1)...
      %GDP(1+nlags-j+1:end-j+1) EBP(1+nlags-j+1:end-j+1)];
      k = k + 3;
end
LM        = fitlm(X,Y,'linear')





