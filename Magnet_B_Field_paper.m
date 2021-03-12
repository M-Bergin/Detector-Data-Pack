%Script to plot the B field from the magnet

%Recorded data points
d1=[0:15];
B1=[3.0,3.78,4.81,5.96,7.68,9.97,13.71,20.83,29.3,58.6,120.0,159.2,162.3,162.3,162.3,162.3];

d2=[15:-1:0];
B2=[162.9,162,162.2,162.3,162.4,162.6,162.3,162.3,162.3,157.5,70.5,49.4,23.61,11.84,8.1,4.5];

L_Ruler=15;
L_box=9.37;


%Plot the data
h_fig=420;
w_fig=560;
%fig_h=figure('Position',[440 438 w_fig h_fig]);
figure
plot((d2-(L_Ruler-L_box))*10,B2,'x','MarkerSize',12,'LineWidth',1.5)
xlabel('D /mm')
ylabel('Magnetic field /mT')

%Load the simulated data from Lorentz, then plot
load('Data\Lorentz B Field.mat')
hold on
plot(x-437,B*1e3,'LineWidth',1.5) %437 is coordinate of start of magnet in lorentz

legend('Experimental','Simulation','Location', 'NorthWest' )

set(gca,'fontsize',16,'LineWidth',1.5)


% print ('..\Figures\B_field.eps','-depsc2')
% savefig('..\Figures\B_field.fig')


%Sanity check on values
B=162e-3;
R=50e-3;
q=1.60217662e-19;
m=4.0026*1.660539040e-27;
%m=5*1.660539040e-27;

V=(R*B)^2*(q/(2*m));
