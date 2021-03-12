%Script to plot the ion trajectories as they exit the ioniser and pass
%through the magnet for mass filtering.

%Load in the trajectories
load('Data\Lorentz_Traj.mat')


%Plot the model of the detector
model = createpde;
importGeometry(model,'ChamberWithOptics_sfl_180.stl');
fig_h2=figure;pdegplot(model)
axis equal tight
hold on
view(2);%([0,90])
xlim([-1 643])
ylim([-52 151])

%Position of magnet sector centre
x_cent=426; %430
y_cent=50;
gap_size=7.5;

x_cross=[];
y_cross=[];

%Debug plot
% theta=[-pi/2:0.01:pi/2];
% x_wall=(y_cent-gap_size)*cos(theta)+x_cent;
% y_wall=(y_cent-gap_size)*sin(theta)+y_cent;
% plot(x_wall,y_wall);
% 
% x_wall=(gap_size+y_cent)*cos(theta)+x_cent;
% y_wall=(gap_size+y_cent)*sin(theta)+y_cent;
% plot(x_wall,y_wall);

%Loop over each trajectory and plot the result
for n=3:1:801%801
    
    x_traj=L_traj(n).XData;
    y_traj=L_traj(n).YData;
    z_traj=L_traj(n).ZData;
    
    start_ind=find(x_traj>x_cent,1);
    end_ind=[];
    
    
    
    if ~isempty(start_ind)
        try
            end_ind=find((sqrt((x_traj(start_ind:end)-x_cent).^2+(y_traj(start_ind:end)-y_cent).^2))<(y_cent-gap_size) & x_traj(start_ind:end)>x_cent,1)-1;
            
            if ~isempty(end_ind)
                m_line=(y_traj(end_ind+start_ind)-y_traj(end_ind+start_ind-1))/(x_traj(end_ind+start_ind)-x_traj(end_ind+start_ind-1));
                c_line=y_traj(end_ind+start_ind-1)-m_line*x_traj(end_ind+start_ind-1);
                
                a=1+m_line^2;
                b=(2*m_line*(c_line-y_cent)-2*x_cent);
                c=x_cent^2+(c_line-y_cent)^2-(y_cent-gap_size)^2;
                
                if x_traj(end_ind+start_ind)>x_traj(end_ind+start_ind-1)
                    x_cross=(-b-sqrt(b^2-4*a*c))/(2*a);
                    y_cross=m_line*x_cross+c_line;
                else
                    x_cross=(-b+sqrt(b^2-4*a*c))/(2*a);
                    y_cross=m_line*x_cross+c_line;
                end
            end
            
            
            
            if isempty(end_ind)
                end_ind=find((sqrt((x_traj(start_ind:end)-x_cent).^2+(y_traj(start_ind:end)-y_cent).^2))>(y_cent+gap_size) & x_traj(start_ind:end)>x_cent,1)-1;
                
                if ~isempty(end_ind)
                    m_line=(y_traj(end_ind+start_ind)-y_traj(end_ind+start_ind-1))/(x_traj(end_ind+start_ind)-x_traj(end_ind+start_ind-1));
                    c_line=y_traj(end_ind+start_ind-1)-m_line*x_traj(end_ind+start_ind-1);
                    
                    a=1+m_line^2;
                    b=(2*m_line*(c_line-y_cent)-2*x_cent);
                    c=x_cent^2+(c_line-y_cent)^2-(y_cent+gap_size)^2;
                    
                    if x_traj(end_ind+start_ind)>x_traj(end_ind+start_ind-1)
                        x_cross=(-b-sqrt(b^2-4*a*c))/(2*a);
                        y_cross=m_line*x_cross+c_line;
                    else
                        x_cross=(-b-sqrt(b^2-4*a*c))/(2*a); %+?
                        y_cross=m_line*x_cross+c_line;
                    end
                    
                else %Catch rays escaping at the end when they shouldn't
                    end_ind2=find((sqrt((x_traj(start_ind:end)-x_cent).^2+(y_traj(start_ind:end)-y_cent).^2))>(y_cent+gap_size),1)-1;
                    if ~isempty(end_ind2)
                        if x_traj(end_ind2+start_ind-1)>x_cent
                            m_line=(y_traj(end_ind2+start_ind)-y_traj(end_ind2+start_ind-1))/(x_traj(end_ind2+start_ind)-x_traj(end_ind2+start_ind-1));
                            c_line=y_traj(end_ind2+start_ind-1)-m_line*x_traj(end_ind2+start_ind-1);
                            
                            a=1+m_line^2;
                            b=(2*m_line*(c_line-y_cent)-2*x_cent);
                            c=x_cent^2+(c_line-y_cent)^2-(y_cent+gap_size)^2;
                            
                            x_cross2=(-b-sqrt(b^2-4*a*c))/(2*a);
                            
                            if x_cross2>x_cent
                                end_ind=end_ind2;
                                x_cross=x_cross2;
                                y_cross=m_line*x_cross+c_line;
                            end
                        
                        end
                    end
                end
            end
        catch
            end_ind=length(x_traj(start_ind:end))-1;
        end
    end
    
    if isempty(end_ind)
        end_ind=length(x_traj(start_ind:end))-1;
    else
        %disp(n)
        %disp(end_ind)
        %disp(x_cross)
        %disp(y_cross)
    end
    
    if isempty(x_cross)
        plot3(x_traj(1:end_ind+start_ind),y_traj(1:end_ind+start_ind),z_traj(1:end_ind+start_ind),'Color',L_traj(n).Color)
    else
        %plot3(x_traj(1:end_ind+start_ind-1),y_traj(1:end_ind+start_ind-1),z_traj(1:end_ind+start_ind-1),'Color',fig_h.CurrentAxes.Children(n).Color)
        
        plot3([x_traj(1:end_ind+start_ind-1),x_cross],[y_traj(1:end_ind+start_ind-1),y_cross],z_traj(1:end_ind+start_ind),'Color',L_traj(n).Color)
        plot3([x_cross,x_traj(end_ind+start_ind:end)],[y_cross,y_traj(end_ind+start_ind:end)],[z_traj(end_ind+start_ind), z_traj(end_ind+start_ind:end)],'Color',[L_traj(n).Color,0.03])
    end
    
    x_cross=[];
    y_cross=[];
    
end






%Clean up the figure
fig_h2.PaperPositionMode='auto';



axis off


set(gca,'units','pixels') % set the axes units to pixels
x = get(gca,'position'); % get the position of the axes
set(gcf,'units','pixels') % set the figure units to pixels
y = get(gcf,'position'); % get the figure position
set(gcf,'position',[y(1) y(2) x(3) x(4)])% set the position of the figure to the length and width of the axes
set(gca,'units','normalized','position',[0 0 1 1]) % set the axes units to pixels



ax = gca;
ax.Position=[0 0 1 1];
fig_h2.Position=[3        330       1914        611];


%print(fig_h2,'DJW_Traj3_5.png','-dpng','-r500')









