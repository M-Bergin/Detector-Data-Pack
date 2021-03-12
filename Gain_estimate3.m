%Script to plot the gain of the electron multiplier and dynode assembly.

%% Find gain of channeltron alone across wide range

%Load first set of data with higher gas flux
load('Data\Sc000201.mat')
V1=Var_values;
current1=max(current_avg)-current_avg;
current1_cut=current1(31:36);
current1_std=current_std(31:36);
current1_std_full=current_std;
V_cut=V1(31:36);


%Load dataset with reduced gas flux
load('Data\Sc000205.mat')
V2=Var_values;
current2=max(current_avg)-current_avg;
current2_cut=current2(1:6);
current2_std=current_std(1:6);
current2_std_full=current_std;

%Minimise the overlap of the gains

fun=@(y)sum((current1_cut-y(1)*(current2_cut-y(2))).^2);
y0=[100,0];
y=fminsearch(fun,y0);

gain1=current1/(4.92e-12-3.19e-12);
gain2=y(1)*(current2-y(2))/(4.92e-12-3.19e-12);

error1=current1_std_full/(4.92e-12-3.19e-12);
error2=y(1)*(current2_std_full)/(4.92e-12-3.19e-12);


%Plot the result
figure
plot(V1,gain1,'LineWidth',1) %'Color',[0.85 0.33 0.1]
hold on
plot(V2,gain2,'Color',[0.49 0.18 0.56],'LineWidth',1) %'r'

% figure
% errorbar(V1,gain1,error1,'LineWidth',1) %'Color',[0.85 0.33 0.1]
% hold on
% errorbar(V2,gain2,error2,'Color',[0.49 0.18 0.56],'LineWidth',1) %'r'


gain=y(1)*(current2-y(2))/(4.92e-12-3.19e-12);

set(gca,'yscale','log','LineWidth',1,'FontSize',12)
xlabel('V_{Multiplier}/V')
ylabel('Total gain')
ylim([1 2e6])

% print -depsc2 C:\Users\mberg\Dropbox\Thesis\Detector\Figures\Chan_gain2.eps
% savefig('C:\Users\mberg\Dropbox\Thesis\Detector\Figures\Chan_gain2.fig')



