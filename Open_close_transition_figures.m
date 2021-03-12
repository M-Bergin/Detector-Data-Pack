%Scipt to generate figures illustrating what happens at the open/close
%transition of the detector.

%Load the emission data data
load('Data\open_close_sweep.mat')

%Plot
figure;plot(quad_v,Ie,'x','MarkerSize',12,'LineWidth',1.5)
hold on
plot(quad_v,Il,'.','MarkerSize',16,'LineWidth',1.5)

%Max values
max_I=[0,0.9];%get(gca,'YLim');

%Plot electron energy
plot([500 500],max_I,'r--','LineWidth',1.5)



xlabel('Mean extraction voltage/V')
ylabel('Electron current/mA')
legend('Emission current','Liner current','Location','SouthWest')

annotation('textbox', [0.19, 1, 0.4, 0], 'string', '\itClosed mode','FontSize',14,'LineStyle','none')
annotation('textbox', [0.585, 1, 0.4, 0], 'string', '\itOpen mode','FontSize',14,'LineStyle','none')


xlim([350 700])
ylim([0 0.8])
set(gca,'FontSize',14)
set(gca,'LineWidth',1)

% print -depsc2 ..\Figures\open_close_sweep.eps
% savefig('..\Figures\open_close_sweep.fig')




%Load the ion current data
load('Data\Fil000027.mat') 

%Plot data
figure;plot(Electron_E,current_avg(:,6)*1e9,'x','MarkerSize',12,'LineWidth',1.5)
hold on
plot([128,128],[0,3],'r--','LineWidth',1.5)
xlim([80 200])
ylim([0.6,2.4])
%ylim([0.6e-9,2.9e-9])
xlabel('Electron energy/V')
ylabel('Ion current/nA')
set(gca,'FontSize',14,'LineWidth',1)


annotation('textbox', [0.17, 1, 0.4, 0], 'string', '\itClosed mode','FontSize',14,'LineStyle','none')
annotation('textbox', [0.57, 1, 0.4, 0], 'string', '\itOpen mode','FontSize',14,'LineStyle','none')



% print -depsc2 ..\Figures\rep_scan_ion_line.eps
% savefig('..\Figures\rep_scan_ion_line.fig')

