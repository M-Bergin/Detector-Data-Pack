%Script to show how the ratio of the mass 4 to mass 3 peak varies as the
%electron energy is changed.


%Initialie variables

files=[372:380,382];
N_files=length(files);
E=NaN*zeros(N_files,1);
V_chan=NaN*zeros(N_files,1);
P=NaN*zeros(N_files,1);

mass4_peak=NaN*zeros(N_files,1);
mass3_peak=NaN*zeros(N_files,1);
mass4_peak_fit=NaN*zeros(N_files,1);
mass3_peak_fit=NaN*zeros(N_files,1);
mass4_peak_ind=NaN*zeros(N_files,1);
mass3_peak_ind=NaN*zeros(N_files,1);
mass4_peak_std=NaN*zeros(N_files,1);
mass3_peak_std=NaN*zeros(N_files,1);

zero_offset=3.22e-12;

%figure
%hold on

%Loop over each mass scan
for n_files=1:N_files
    load(['Data\Sc000' num2str(files(n_files),'%03.f') '.mat']);
    
    E(n_files)=det_params.det_vars(3,2);
    V_chan(n_files)=det_params.det_vars(11,2);
    P(n_files)=mean(pressure_avg);
    
    %Remove outliers
    switch n_files
        case 1
            del_inds=10;
        case 2
            del_inds=[14,32];
        case 3
            del_inds=20;
        case 4
            del_inds=[8,20,40];
        case 5
            del_inds=[1,20];
        case 6
            del_inds=[];
        case 7
            del_inds=[9,10];
        case 8
            del_inds=[5,6];
        case 9
            del_inds=22;
        %case 10
         %   del_inds=[];
        case 10
            del_inds=36;
    end
    
    Var_values_plot=Var_values;
    current_avg_plot=current_avg;
    current_std_plot=current_std;
    
    Var_values(del_inds)=[];%[];
    current_avg(del_inds)=[];%[];
    current_std(del_inds)=[];%[];
    
    Var_values_plot(del_inds)=NaN;%[];
    current_avg_plot(del_inds)=NaN;%[];
    current_std_plot(del_inds)=NaN;%[];
    
    
    %Find the peak at mass 4 and 3
    peak_4_inds=find(Var_values>675 & Var_values<750);
    peak_3_inds=find(Var_values>870 & Var_values<990);
    
    mass4_peak(n_files)=max(current_avg(peak_4_inds))+zero_offset;
    mass3_peak(n_files)=max(current_avg(peak_3_inds))+zero_offset;
    
    [~,ind_4]=max(current_avg(peak_4_inds));
    [~,ind_3]=max(current_avg(peak_3_inds));
    
    mass4_peak_ind(n_files)=peak_4_inds(ind_4);
    mass3_peak_ind(n_files)=peak_3_inds(ind_3);
    
    if n_files==8 
        ind_range4=[ mass4_peak_ind(n_files)-1: mass4_peak_ind(n_files)+2];
    else
    ind_range4=[ mass4_peak_ind(n_files)-2: mass4_peak_ind(n_files)+2];
    end
    ind_range3=[ mass3_peak_ind(n_files)-2: mass3_peak_ind(n_files)+2];
    
    %Record properites of the mass peaks
    mass4_V=Var_values(ind_range4);
    mass4_I=current_avg(ind_range4);
    mass4_std=current_std(ind_range4);
    mass4_w=1./mass4_std.^2;
    
    mass3_V=Var_values(ind_range3);
    mass3_I=current_avg(ind_range3);
    mass3_std=current_std(ind_range3);
    mass3_w=1./mass3_std.^2;
    
    mass4_peak_std(n_files)=current_std(mass4_peak_ind(n_files));
    mass3_peak_std(n_files)=current_std(mass3_peak_ind(n_files));
    
    
    
    
    
%     
%     %Plots
%     [xData, yData] = prepareCurveData( mass4_V, mass4_I );
%     
%     % Set up fittype and options.
%     ft = fittype( 'poly2' );
%     
%     % Fit model to data.
%     [fitresult, gof] = fit( xData, yData, ft );
%     
%     % Plot fit with data.
%     
%     h = plot( fitresult, xData, yData );
%     
%     mass4_peak_fit(n_files)=fitresult.p3-(fitresult.p2^2)/(4*fitresult.p1);
%     
%     
%     
%     [xData, yData] = prepareCurveData( mass3_V, mass3_I );
%     
%     % Set up fittype and options.
%     ft = fittype( 'poly2' );
%     
%     % Fit model to data.
%     [fitresult, gof] = fit( xData, yData, ft );
%     
%     % Plot fit with data.
%     
%     h = plot( fitresult, xData, yData );
%     
%     mass3_peak_fit(n_files)=fitresult.p3-(fitresult.p2^2)/(4*fitresult.p1);
%     
%     plot(Var_values_plot,current_avg_plot,'LineWidth',1)
end

%set(gca,'YScale','log')

%Calculate ratio of peak sizes
mass4_peak_fit=mass4_peak_fit+zero_offset;
mass3_peak_fit=mass3_peak_fit+zero_offset;
peak_ratio_fit=mass4_peak_fit./mass3_peak_fit;

peak_ratio=mass4_peak./mass3_peak;
peak_ratio_std=peak_ratio.*sqrt((mass4_peak_std./mass4_peak).^2+ (mass3_peak_std./mass3_peak).^2);

%Plot peak ratios
figure;errorbar(E,peak_ratio,peak_ratio_std,'x','LineWidth',1,'MarkerSize',12)
xlabel('Electron energy/eV')
ylabel('Ratio of m/z=4 to m/z=3')

set(gca,'YScale','log')
set(gca,'FontSize',12)
set(gca,'LineWidth',1)

xlim([40 310])

% print('..\Figures\back_peak_ratio.eps', '-depsc2' )
%  savefig('..\Figures\back_peak_ratio.fig')

%Calibrate multiplier gain out
% Gain_estimate3
% 
% N_chan=length(V_chan);
% gain_cali=NaN*V_chan;
% 
% for n_chan=1:N_chan
%     ind=find(V2==V_chan(n_chan));
%     gain_cali(n_chan)=gain(ind);
% end
% 
%  figure;plot(E,(mass4_peak./gain_cali),'x')
%  hold on
%  plot(E,mass3_peak./gain_cali,'x')
%  set(gca,'YScale','log')



%Plot all the mass scans (figure not used in paper)
files=[372:378];
%files=[372:382];
N_files=length(files);

figure
E=NaN*zeros(N_files,1);
legend_text=[];
legend_text{N_files}=[];

for n_files=1:N_files
    load(['Data\Sc000' num2str(files(n_files),'%03.f') '.mat']);
    
    switch n_files
        case 1
            del_inds=10;
        case 2
            del_inds=[14,32];
        case 3
            del_inds=20;
        case 4
            del_inds=[8,20,40];
        case 5
            del_inds=[1,20];
        case 6
            del_inds=[];
        case 7
            del_inds=[9,10];
        case 8
            del_inds=[5,6];
        case 9
            del_inds=22;
        case 10
            del_inds=[];
        case 11
            del_inds=36;
    end
    
    
    Var_values(del_inds)=NaN;
    current_avg(del_inds)=NaN;
    current_std(del_inds)=NaN;
    
    plot(Var_values,current_avg,'LineWidth',1)
    %errorbar(Var_values,current_avg,current_std,'LineWidth',1)
    
    E(n_files)=det_params.det_vars(3,2);
    legend_text{n_files}=['V_e= ',num2str(E(n_files)),' V'];
    
    hold on
    
%     plot(Var_values(mass4_peak_ind(n_files)),current_avg(mass4_peak_ind(n_files)),'x')
%     plot(Var_values(mass3_peak_ind(n_files)),current_avg(mass3_peak_ind(n_files)),'x')
    
end


set(gca,'YScale','log')
legend(legend_text,'Location','best')
xlabel('Liner voltage/V')
ylabel('Current/A')
set(gca,'FontSize',12)
set(gca,'LineWidth',1)
% print -depsc2 C:\Users\mberg\Dropbox\Thesis\Detector\Figures\back_mass_scan.eps

