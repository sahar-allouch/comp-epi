% an example to run the full pipeline
% This code was originally developped by Sahar Allouch.
% contact: saharallouch@gmail.com

montage = 'EGI_HydroCel_256';   %'EGI_HydroCel_256,'EGI_HydroCel_128','EGI_HydroCel_64','EGI_HydroCel_32','10-20_19'};
inv_meth = 'wmne';  %"eloreta", "wmne"
conn_meth = 'PLV';  %'PLV' or 'wPLI'
lambda = 1; % noisy scalp EEG = lambda * Clean EEG + (1-lambda) * Gaussian noise

run_all_pipeline(inv_meth,conn_meth,montage,lambda)

%%
% to obtain all accuracy values obtained using eLORETA/wPLI for all
% electrode montages, uncomment the line below

% get_results_values('eloreta_wPLI', 'lambda1_snr3')