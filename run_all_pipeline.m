function [] = run_all_pipeline(inv_meth,conn_meth,montage,lambda)
% main script
% Steps:
% 1) loading simulated cortical sources, remove dc offset, bandpass filtering [1-45], extract trials
% 2) Functional connectivity, plot simulated networks
% 3) EEG direct problem
% 4) EEG inverse problem
% 5) Functional connectivity, plot estimated networks
% 6) Accuracy assessment

% This code was originally developped by Sahar Allouch.
% contact: saharallouch@gmail.com

%% add fieldtrip path
addpath S:\Matlab_Toolboxes\fieldtrip-20200423
ft_defaults

%%
srate = 2048;
fmin = 1;
fmax = 45;
epoch_length = 10;
p = 0.12; % threshold = 12%

% lambda = 1; % snr = lambda / (1-lambda)
% inv_meth = 'eloreta';
% conn_meth = 'PLV'; % 'PLV' or 'wPLI'
% montage = {'EGI_HydroCel_256'};%,'EGI_HydroCel_128','EGI_HydroCel_64',...
% %'EGI_HydroCel_32','10-20_19'};

%% loading simulations + remove DC offset + bandpass filter
% load simulations
sim_fname = 'inputs/simulated_sources';
load(sim_fname,'sim');
nb_rois = size(sim.sources,1);

% remove DC offset
sim_signals = remove_DC_offset(sim.sources);

% bandpass filter
% sim_signals = bandpass_filter(sim_signals,srate,fmin,fmax);

clear sim_fname sim

%% get trials
nb_trials = 36;
for i=1:nb_trials
    % get epoch #i, epoch length = 10 sec
    trial = sim_signals(:,1+srate*(epoch_length*(i-1)):srate*(epoch_length*i));
    trials(i,:,:) = trial;
end
clear sim_signals trial

load('inputs/good_trials','good_trials')
nb_trials = 30;
trials = trials(good_trials(1:nb_trials),:,:);

%% get connectivity matrix of each trial + threshold + compute scalp EEG + add sensor noise
cmat_ref = zeros(nb_trials,nb_rois,nb_rois);
cmat_ref_thre = zeros(nb_trials,nb_rois,nb_rois);
% eeg_trials_noisy = zeros(nb_trials,nb_rois,nb_samples);
for i=1:nb_trials
    % get epoch #i
    trial = reshape(trials(i,:,:),[nb_rois,epoch_length*srate]);
    % get connectivity matrix for epoch #i
    cmat = get_connectivity(trial,srate,fmin,fmax,conn_meth);
    cmat_ref(i,:,:) = cmat;
%     thresholding connectivity matrices
    cmat_ref_thre(i,:,:) = threshold_strength(cmat,p);
    % scalp EEG
    eeg_trial = compute_eeg(trial,montage);
    % additive noise
    eeg_trial = additive_noise(eeg_trial,lambda);
    eeg_trials_noisy (i,:,:) = bandpass_filter(eeg_trial,srate,fmin,fmax);
end

if exist('results/cmat','dir') ~= 7
    mkdir('results/cmat')
end
save(['results/cmat/cmat_ref_' inv_meth '_' conn_meth '_' montage '_lambda' num2str(lambda) '_snr3.mat'],'cmat_ref');
save(['results/cmat/cmat_ref_thre_' inv_meth '_' conn_meth '_' montage '_lambda' num2str(lambda) '_snr3.mat'],'cmat_ref_thre');
clear trial cmat eeg_trial

[~,nb_channels,nb_samples] = size(eeg_trials_noisy);

%% plot reference networks in BrainNet Viewer (BNV)
% 
% for i = 1:nb_trials
%     cmat = reshape(cmat_ref_thre(i,:,:),[nb_rois,nb_rois]);
%     plot_BNV(cmat,['simul_' conn_meth '_lambda' num2str(lambda) '_trial' num2str(i)]);
% end

%% inverse solution
eeg = reshape(eeg_trials_noisy(1,:,:),[nb_channels,nb_samples]);

baseline = reshape(eeg_trials_noisy(1,:,1:4*srate),[nb_channels,4*srate]);
for i=2:nb_trials
baseline = [baseline, reshape(eeg_trials_noisy(i,:,1:4*srate),[nb_channels,4*srate])];
end
noiseCov = inverse.CalculateNoiseCovarianceTimeWindow(baseline);%0.5-->1.5

filters = get_inverse_solution(eeg,srate,inv_meth,montage,noiseCov);
clear eeg

%%
cmat_est = zeros(nb_trials,nb_rois,nb_rois);
cmat_est_thre = zeros(nb_trials,nb_rois,nb_rois);
for i=1:nb_trials
    
    % get estimated epoch #i
    trial = reshape(eeg_trials_noisy(i,:,:),[nb_channels,nb_samples]);
    trial = filters*trial;
    % get connectivity matrix of epoch #i
    cmat = get_connectivity(trial,srate,fmin,fmax,conn_meth);
    cmat_est(i,:,:) = cmat;
    % thresholding connectivity matrices
    cmat_est_thre(i,:,:) = threshold_strength(cmat,p);
    
end
if exist('results/cmat','dir') ~= 7
    mkdir('results/cmat')
end

save(['results/cmat/cmat_est_' inv_meth '_' conn_meth '_' montage '_lambda' num2str(lambda) '_snr3.mat'],'cmat_est');
save(['results/cmat/cmat_est_thre_' inv_meth '_' conn_meth '_' montage '_lambda' num2str(lambda) '_snr3.mat'],'cmat_est_thre');
clear trial cmat

%% plot estimated networks in BrainNet Viewer (BNV)
% for i = 1:nb_trials
%     cmat = reshape(cmat_est_thre(i,:,:),[nb_rois,nb_rois]);
%     plot_BNV(cmat,['est_' inv_meth '_' conn_meth '_' montage '_lambda' num2str(lambda) '_trial' num2str(i) '.mat']);
% end

%% get the accuracy of estimated networks
results = struct('sensitivity',[],'specificity',[],'accuracy',[]);

for i =1:nb_trials
    tmp_ref = reshape(cmat_ref_thre(i,:,:),[nb_rois,nb_rois]);
    tmp_est = reshape(cmat_est_thre(i,:,:),[nb_rois,nb_rois]);
    
    results(i)= get_results_quantif(tmp_ref,tmp_est);
end
if exist('results','dir') ~= 7
    mkdir('results')
end
save(['results/results_' inv_meth '_' conn_meth '_' montage '_lambda' num2str(lambda) '_snr3.mat'],'results');



