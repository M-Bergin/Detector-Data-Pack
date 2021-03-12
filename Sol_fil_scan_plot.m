%Script to plot how the efficiency changes with filament current for a
%given solenoid current. 


%Get pressure calibration
pressure_cali

%files=[70,69,63,67];
%files=[70,67];
files=67;
N_files=length(files);

load('Data\Fil000067.mat')

N=length(filcur_avg);

current_mat=NaN*zeros(N_files,N);
current_err_mat=NaN*zeros(N_files,N);
emi_mat=NaN*zeros(N_files,N);
samp_p_mat=NaN*zeros(N_files,N);
p_mat=NaN*zeros(N_files,N);
legend_text=[];
legend_text{N_files}=[];
counter=1;

%I_sol=[10,15,20,25];
I_sol=[10,25];

for n_files=1:N_files
    load(['Data\Fil0000',num2str(files(n_files)),'.mat'])
    
    current_mat(n_files,:)=current_avg;
    current_err_mat(n_files,:)=current_std;
    emi_mat(n_files,:)=emicur_avg;
    samp_p_mat(n_files,:)=samp_pressure;
    p_mat(n_files,:)=pressure_avg;
    
    legend_text{counter}=['I_{s}= ',num2str(I_sol(n_files)),' A'];
    counter=counter+1;
    
end

%Sort the filament current
[sorted_fil,sort_ind_emi]=sort(I_fil);


%Plot the emission current
%figure;imagesc(sorted_fil,I_sol,emi_mat(:,sort_ind))
% figure;plot(2*filcur_avg,2*emi_mat,'x','MarkerSize',12,'LineWidth',1)
% legend(legend_text,'Location','NorthWest')
% set(gca,'FontSize',12)
% set(gca,'LineWidth',1)
% %xlim([2.05 2.4])

%Plot the ion current
k_B=1.38064852e-23;
el_e=1.60217662e-19;
conv_factor=k_B*(273+25)/(el_e*215e-3*100);

%figure;imagesc(sorted_fil,I_sol,current_mat(:,sort_ind))
figure;plot(2*filcur_avg(sort_ind_emi),current_mat(:,sort_ind_emi)./(samp_p_mat(:,sort_ind_emi)*m_P/0.18)*conv_factor,'x','MarkerSize',6,'LineWidth',1.5) 
% figure;hold on
% for n_files=1:N_files
%     errorbar(2*filcur_avg(sort_ind_emi),current_mat(n_files,sort_ind_emi)./(samp_p_mat(n_files,sort_ind_emi)*m_P/0.18)*conv_factor,current_err_mat(n_files,sort_ind_emi)./(samp_p_mat(n_files,sort_ind_emi)*m_P/0.18)*conv_factor,'-','MarkerSize',12,'LineWidth',1)
% end

%legend(legend_text,'Location','NorthWest')
xlabel('Filament current/A')
ylabel('Faraday Cup Efficiency')
set(gca,'FontSize',12)
set(gca,'LineWidth',1)

% print('..\Figures\eff_noisy3.eps', '-depsc2')
% print('..\Figures\eff_noisy3.png', '-dpng','-r200')
% savefig('..\Figures\eff_noisy3.fig')

%max(max(current_err_mat./(samp_p_mat*m_P/0.18)*conv_factor)) %5e-5

%print -depsc2 C:\Users\mberg\Dropbox\Thesis\Detector\Figures\eff_noisy.eps

%Sort the filament current

% figure
% for n_files=1:N_files
%     [sorted_emi,sort_ind_emi]=sort(emi_mat(n_files,:));
%     %plot(2*emi_mat(n_files,:),current_mat(n_files,:)./(samp_p_mat(n_files,:)*m_P/0.18)*conv_factor,'-','MarkerSize',12,'LineWidth',1)
%     plot(2*emi_mat(n_files,sort_ind_emi),current_mat(n_files,sort_ind_emi)./(samp_p_mat(n_files,sort_ind_emi)*m_P/0.18)*conv_factor,'-','MarkerSize',12,'LineWidth',1.5)
%     %errorbar(2*emi_mat(n_files,sort_ind_emi),current_mat(n_files,sort_ind_emi)./(samp_p_mat(n_files,sort_ind_emi)*m_P/0.18)*conv_factor,current_err_mat(n_files,sort_ind_emi)./(samp_p_mat(n_files,sort_ind_emi)*m_P/0.18)*conv_factor,'-','MarkerSize',12,'LineWidth',1)
%     hold on
% end
% set(gca,'XScale','log')
% legend(legend_text,'Location','NorthWest')
% xlabel('Emission current/mA')
% ylabel('Faraday Cup Efficiency')
% set(gca,'FontSize',12)
% set(gca,'LineWidth',1)
% xlim([0.07 6])


%print -depsc2 C:\Users\mberg\Dropbox\Thesis\Detector\Figures\eff_emi_noisy.eps



%Plot the pressure
%figure;plot(filcur_avg,p_mat,'x') 


    
