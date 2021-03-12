%Script to generate mass scan with and without a helium leak.

%Load data for background mass scan
load('Data\Sc000388.mat')

%Remove outliers due to power supply control issues
ind_rem=[48,53];

back_V=Var_values;
back_I=current_avg;
back_std=current_std;

back_V(ind_rem)=[];
back_I(ind_rem)=[];
back_std(ind_rem)=[];

figure;errorbar(back_V,back_I,back_std,'LineWidth',1)


hold on

%Load data from helium leak
load('Data\Sc000387.mat')

errorbar(Var_values,current_avg,current_std,'r','LineWidth',1)

xlabel('Liner voltage/V')
ylabel('Current/A')

set(gca,'FontSize',12)
set(gca,'LineWidth',1)
set(gca,'YScale','log')

%print -depsc2 ..\Figures\mass_scan_example.eps

