# comp-epi
Evaluation of the effect of:

- five different electrode densities: 256, 128, 64, 32, 19
- two inverse solution algorithms: 
    1. weighted minimum norm estimate (wMNE) 
    2. exact low resolution electromagnetic tomography (eLORETA)
- two functional connectivity measures: 
    1. phase locking value (PLV) 
    2. weighted minimum norm estimate (wPLI)


General pipeline:
1. Cortical sources ('inputs/sources_50_9_noId.mat') are computed using COALIA model (Bensaid, S., Modolo, J., Merlet, I., Wendling, F., & Benquet, P. (2019). COALIA: A Computational Model of Human EEG for Consciousness Research. Frontiers in Systems Neuroscience, 13, 1–18. https://doi.org/10.3389/fnsys.2019.00059)

PLEASE DOWNLOAD THE DATA FROM (https://drive.google.com/drive/folders/1yDwdoLwSOg9UZrdDf6AzpT78Ve5HJRxT?usp=sharing) and ADD IT TO THE "inputs" FOLDER RUNNING THE CODE.

2. Scalp EEG are generated by solving the EEG direct problem.
3. Inverse solution are computed to reconstruct cortical sources.
4. Functional connectivity is assessed.
5. Accuracy of the estimaetd networks are computed.

Main script = 'run_example.m'
