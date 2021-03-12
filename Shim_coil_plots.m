%Script to plot how the efficiency varies when the secondary coil currents
%are changed


%% Calibrate pressures
load('Data\Sc000500.mat')
[xData, yData] = prepareCurveData( samp_pressure, pressure_avg );

% Set up fittype and options.
ft = fittype( 'poly1' );

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft );

m_P=fitresult.p1;
c_P=fitresult.p2;

errors=confint(fitresult,0.68);

dm=(errors(2,1)-errors(1,1))/2;

dc=(errors(2,2)-errors(1,2))/2;


x_plot=[0:1e-8:1.2e-7];
y_plot=fitresult.p1*x_plot+fitresult.p2;


% figure
% 
% plot(samp_pressure,pressure_avg,'bx','MarkerSize',12,'LineWidth',1)
% 
% hold on
% 
% plot(x_plot,y_plot,'k','LineWidth',1)
% 
% set(gca,'FontSize',12,'LineWidth',1)
% 
% xlabel('Sample chamber pressure/mbar')
% ylabel('Optics chamber pressure/mbar')

%m=(1.119 \pm 0.007) e-3
%c=(1.04 \pm 0.04) e-11







%% Analyse low emission data

start_file=422;%439; %422
end_file=437;%452; %437

files=[start_file:end_file];

N_files=length(files);
I_main=NaN*zeros(N_files,1);

load(['Data\Sc000',num2str(files(1))])
I_shim=Var_values;
N_shim=length(Var_values);

emi_mat=NaN*zeros(N_files,N_shim);
cur_mat=NaN*zeros(N_files,N_shim);
p_mat=NaN*zeros(N_files,N_shim);
samp_p_mat=NaN*zeros(N_files,N_shim);

for n=1:N_files
    
    load(['Data\Sc000',num2str(files(n))])
    I_main(n)=round(det_params.solenoidI);
    emi_mat(n,:)=2*emicur_avg;
    cur_mat(n,:)=current_avg;
    p_mat(n,:)=pressure_avg;
    samp_p_mat(n,:)=samp_pressure;
    
end

%remove strange pressure readings
[ind_i,ind_j]=find(p_mat>1);
p_mat(ind_i,ind_j)=NaN;

%Sort the data
[sorted_I_main,sort_main_ind]=sort(I_main);
[sorted_I_shim,sort_shim_ind]=sort(I_shim);

emi_mat_sorted=emi_mat(sort_main_ind,:);
emi_mat_sorted_low=emi_mat_sorted(:,sort_shim_ind);

cur_mat_sorted=cur_mat(sort_main_ind,:);
cur_mat_sorted_low=cur_mat_sorted(:,sort_shim_ind);

p_mat_sorted=p_mat(sort_main_ind,:);
p_mat_sorted_low=p_mat_sorted(:,sort_shim_ind);

samp_p_mat_sorted=samp_p_mat(sort_main_ind,:);
samp_p_mat_sorted_low=samp_p_mat_sorted(:,sort_shim_ind);

k_B=1.38064852e-23;
el_e=1.60217662e-19;
conv_factor=k_B*(273+25)/(el_e*215e-3*100);

eff_mat_low=cur_mat_sorted_low./((samp_p_mat_sorted_low*m_P)/0.18)*conv_factor;

% figure;
% subplot(3,1,1)
% imagesc(sorted_I_shim,sorted_I_main,emi_mat_sorted_low);set(gca,'XDir','normal','YDir','normal'); axis tight;
% xlabel('Shim Current/A')
% ylabel('Main Current/A')
% title('Emission Current/mA')
% colorbar
% 
% subplot(3,1,2)
% imagesc(sorted_I_shim,sorted_I_main,cur_mat_sorted_low);set(gca,'XDir','normal','YDir','normal'); axis tight;
% xlabel('Shim Current/A')
% ylabel('Main Current/A')
% title('Ion Current/A')
% colorbar
% 
% subplot(3,1,3)
% imagesc(sorted_I_shim,sorted_I_main,p_mat_sorted_low);set(gca,'XDir','normal','YDir','normal'); axis tight;
% xlabel('Shim Current/A')
% ylabel('Main Current/A')
% title('Pressure/mbar')
% colorbar



% figure
% imagesc(sorted_I_shim,sorted_I_main,emi_mat_sorted_low);set(gca,'XDir','normal','YDir','normal'); axis equal tight;
% xlabel('Shim Current/A')
% ylabel('Main Current/A')
% %title('Emission Current/mA')
% colorbar
% set(gca,'FontSize',12)





%% Analyse high emission data


start_file=439;%439; %422
end_file=452;%452; %437

files=[start_file:end_file];

N_files=length(files);
I_main=NaN*zeros(N_files,1);

load(['Data\Sc000',num2str(files(1))])
I_shim=Var_values;
N_shim=length(Var_values);

emi_mat=NaN*zeros(N_files,N_shim);
cur_mat=NaN*zeros(N_files,N_shim);
p_mat=NaN*zeros(N_files,N_shim);
samp_p_mat=NaN*zeros(N_files,N_shim);

for n=1:N_files
    
    load(['Data\Sc000',num2str(files(n))])
    I_main(n)=round(det_params.solenoidI);
    emi_mat(n,:)=2*emicur_avg;
    cur_mat(n,:)=current_avg;
    p_mat(n,:)=pressure_avg;
    samp_p_mat(n,:)=samp_pressure;
    
end

%remove strange pressure readings
[ind_i,ind_j]=find(p_mat>1);
p_mat(ind_i,ind_j)=NaN;

%Sort the data
[sorted_I_main,sort_main_ind]=sort(I_main);
[sorted_I_shim,sort_shim_ind]=sort(I_shim);

emi_mat_sorted=emi_mat(sort_main_ind,:);
emi_mat_sorted=emi_mat_sorted(:,sort_shim_ind);

cur_mat_sorted=cur_mat(sort_main_ind,:);
cur_mat_sorted=cur_mat_sorted(:,sort_shim_ind);

p_mat_sorted=p_mat(sort_main_ind,:);
p_mat_sorted=p_mat_sorted(:,sort_shim_ind);

samp_p_mat_sorted=samp_p_mat(sort_main_ind,:);
samp_p_mat_sorted=samp_p_mat_sorted(:,sort_shim_ind);

k_B=1.38064852e-23;
el_e=1.60217662e-19;
conv_factor=k_B*(273+25)/(el_e*215e-3*100);

eff_mat=cur_mat_sorted./((samp_p_mat_sorted*m_P)/0.18)*conv_factor;

% figure;
% subplot(3,1,1)
% imagesc(sorted_I_shim,sorted_I_main,emi_mat_sorted);set(gca,'XDir','normal','YDir','normal'); axis tight;
% xlabel('Shim Current/A')
% ylabel('Main Current/A')
% title('Emission Current/mA')
% colorbar
% 
% subplot(3,1,2)
% imagesc(sorted_I_shim,sorted_I_main,cur_mat_sorted);set(gca,'XDir','normal','YDir','normal'); axis tight;
% xlabel('Shim Current/A')
% ylabel('Main Current/A')
% title('Ion Current/A')
% colorbar
% 
% subplot(3,1,3)
% imagesc(sorted_I_shim,sorted_I_main,p_mat_sorted);set(gca,'XDir','normal','YDir','normal'); axis tight;
% xlabel('Shim Current/A')
% ylabel('Main Current/A')
% title('Pressure/mbar')
% colorbar



% figure
% imagesc(sorted_I_shim,sorted_I_main,emi_mat_sorted);set(gca,'XDir','normal','YDir','normal'); axis equal tight;
% xlabel('Shim Current/A')
% ylabel('Main Current/A')
% %title('Emission Current/mA')
% colorbar
% set(gca,'FontSize',12)






em_min=min([emi_mat_sorted_low(:);emi_mat_sorted(:)]);
em_max=max([emi_mat_sorted_low(:);emi_mat_sorted(:)]);
eff_min=min([eff_mat_low(:);eff_mat(:)]);
eff_max=max([eff_mat_low(:);eff_mat(:)]);



%% Plot the data for paper

figure
imagesc(sorted_I_shim,sorted_I_main,eff_mat_low);set(gca,'XDir','normal','YDir','normal'); axis tight;
xlabel('Secondary current/A')
ylabel('Main current/A')
caxis([eff_min,eff_max])
%title('Detection efficiency')
c1 = colorbar;
c1.LineWidth=2;

set(gca,'FontSize',24,'LineWidth',2)
hold on
plot([0,40],[0,40],'--','LineWidth',2,'Color',[0.8500, 0.3250, 0.0980])
xlim([-0.5000 40.5000])
ylim([11.5667 25.4333])




% Requires R2020a or later
%  exportgraphics(gca,'..\Figures\eff_mat_low.pdf')%,'Resolution',500) 
%  savefig('eff_mat_low.fig')



figure
imagesc(sorted_I_shim,sorted_I_main,eff_mat);set(gca,'XDir','normal','YDir','normal'); axis tight;
xlabel('Secondary current/A')
ylabel('Main current/A')
caxis([eff_min,eff_max])
%title('Detection efficiency')
c2 = colorbar;
c2.LineWidth=2;

set(gca,'FontSize',24,'LineWidth',2)
hold on
plot([0,40],[0,40],'--','LineWidth',2,'Color',[0.8500, 0.3250, 0.0980])
xlim([-0.5000 40.5000])
ylim([11.5667 25.4333])


% 
% Requires R2020a or later
%  exportgraphics(gca,'..\Figures\eff_mat.pdf')%,'Resolution',500) 
%  savefig('eff_mat.fig')



