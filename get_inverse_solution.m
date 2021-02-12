function [filters] = get_inverse_solution(eeg,srate,inv_meth,montage,noiseCov)

% compute EEG inverse solution using eLORETA and wMNE
% inputs: eeg: nb_channels*nb_samples
% srate: sampling rate
% montage: montage based on which EEg data was computed. {'EGI_HydroCel_256',
% 'EGI_HydroCel_128','EGI_HydroCel_64','EGI_HydroCel_32','10-20_19'}.

% Outputs: filters: 2*nb_regions*nb_channels, nb_regions denotes the number
% of cortical sources, nb_channels denotes the number of EEG channels. The
% first dimension refers to the inverse solution (1=eLORETA, 2=wMNE)

% This code was originally developped by Sahar Allouch.
% contact: saharallouch@gmail.com


load('inputs/sources','sources') % sources location and orientation
load(['inputs/ftChannels_' montage],'elec') % channel file
load('inputs/ftHeadmodel','ftHeadmodel') % headmodel
load(['inputs/ftLeadfield_' montage],'ftLeadfield') % leadfield

%% noise covariance
% noiseCov = inverse.CalculateNoiseCovarianceTimeWindow(eeg(:,1:5*srate));%0.5-->1.5

%%
epoch_length = size(eeg,2)/srate;
filters = [];

ftData.trial{1} = eeg;
ftData.time{1}  = 0:1/srate:epoch_length-1/srate;
ftData.elec = elec;
ftData.label = elec.label';
ftData.fsample = srate;
clear eeg

if inv_meth == "eloreta"
    %% eLORETA
    % prepare fieldtrip data structure (ftData)
    %     ftData.trial{1} = eeg;
    %     ftData.time{1}  = 0:1/srate:epoch_length-1/srate;
    %     ftData.elec = elec;
    %     ftData.label = elec.label';
    %     ftData.fsample = srate;
    %     clear eeg
    
    cfg                     = [];
    cfg.method              = 'eloreta';
    cfg.sourcemodel         = ftLeadfield;
    cfg.sourcemodel.mom     = transpose(sources.Orient);
    cfg.headmodel           = ftHeadmodel;
    cfg.eloreta.keepfilter  = 'yes';
    cfg.eloreta.keepmom     = 'no';
    cfg.eloreta.lambda      = 0.05; % default in ft = 0.05
    src                     = ft_sourceanalysis(cfg,ftData);
    
    filters(:,:)            = cell2mat(transpose(src.avg.filter));
    
elseif inv_meth == "wmne"
    %% wMNE
    weightExp = 0.5;
    weightLimit = 10;
    SNR = 3;
    
    Gain=cell2mat(ftLeadfield.leadfield);
    GridLoc = sources.Loc;
    GridOrient = sources.Orient;
    
    filters(:,:) = inverse.ComputeWMNE(noiseCov,Gain,GridLoc,GridOrient,weightExp,weightLimit,SNR); 
end
end
