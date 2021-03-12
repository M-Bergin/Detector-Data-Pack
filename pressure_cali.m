P_samp_cali=[1.5e-9,3e-9,4e-9,6.4e-9,8.3e-9,1.02e-8,1.4e-8,2.04e-8,2.55e-8,3.7e-8,4.5e-8,6.6e-8,7.8e-8,8.8e-8,1.12e-7,1.65e-7,2.05e-7,9.8e-8,8e-8,7.2e-8,6e-8,5e-8,3.8e-8,2.6e-8,9.9e-8];
P_op_cali=[2.58,2.60,2.63,2.7,2.75,2.79,2.87,3.01,3.12,3.37,3.54,4.1,4.38,4.62,5.16,6.42,7.35,4.82,4.41,4.25,3.96,3.71,3.43,3.15,4.84]*1e-11;

%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( P_samp_cali, P_op_cali );

% Set up fittype and options.
ft = fittype( 'poly1' );

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft );

m_P=fitresult.p1;

