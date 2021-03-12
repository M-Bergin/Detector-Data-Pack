%Script to generate trajectories of helium ions and electrons as they enter
%the dynode assembly.

%% Get the data
load('Data\Lorentz_Traj_Dynode.mat')


N_lines=length(L_dynode_traj);


%% Plot the trajectories
figure

hold on
%Plot the electron trajectories
for n=1:150
    plot3(L_dynode_traj(n).XData,L_dynode_traj(n).YData,L_dynode_traj(n).ZData,'r','LineWidth',1)
end
%Plot the helium trajectories
for n=151:N_lines
    plot3(L_dynode_traj(n).XData,L_dynode_traj(n).YData,L_dynode_traj(n).ZData,'b','LineWidth',1)
end



%% Plot the model
model = createpde;
importGeometry(model,'Dynode_Assembly_Dynode_Arc Lorentz v2.stl');

pdegplot(model)


fig_h=gcf;
fig_h.PaperPositionMode='auto';

xlim([0 21])
zlim([-100 0])
ylim([-30 45])
view([-110,15])


ax = gca;


ax.Position=[0 0 1 1];
fig_h.Position=[1160 408 300 420];

axis off 

%fig_h.Renderer='painters';

%print -depsc2 Run9_dynode2.eps

%print(fig_h,'Run9_dynode2.png','-dpng','-r2000')