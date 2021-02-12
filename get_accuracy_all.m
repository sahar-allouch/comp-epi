load('results_values/accuracy_eloreta_PLV_lambda1_snr3.mat','accuracy')
pe = accuracy(1:30,:);
clear accuracy

load('results_values/accuracy_wmne_PLV_lambda1_snr3.mat','accuracy')
pw = accuracy(1:30,:);
clear accuracy

load('results_values/accuracy_eloreta_wPLI_lambda1_snr3.mat','accuracy')
we = accuracy(1:30,:);
clear accuracy

load('results_values/accuracy_wmne_wPLI_lambda1_snr3.mat','accuracy')
ww = accuracy(1:30,:);
clear accuracy


Source_method = {};
Connectivity_method = {};

d=1;

for i=1:30
   Epoch(d) = i;
   Montage (d) = 256;
   Source_method {d} = 'eLORETA';
   Connectivity_method {d} = 'PLV';
   Accuracy(d) = pe(i,5);
   d = d+1;
   
   Epoch(d) = i;
   Montage (d) = 128;
   Source_method {d} = 'eLORETA';
   Connectivity_method {d} = 'PLV';
   Accuracy(d) = pe(i,4);
   d = d+1;
   
   Epoch(d) = i;
   Montage (d) = 64;
   Source_method {d} = 'eLORETA';
   Connectivity_method {d} = 'PLV';
   Accuracy(d) = pe(i,3);
   d = d+1;
   
   Epoch(d) = i;
   Montage (d) = 32;
   Source_method {d} = 'eLORETA';
   Connectivity_method {d} = 'PLV';
   Accuracy(d) = pe(i,2);
   d = d+1;
   
   Epoch(d) = i;
   Montage (d) = 19;
   Source_method {d} = 'eLORETA';
   Connectivity_method {d} = 'PLV';
   Accuracy(d) = pe(i,1);
   d = d+1;
   
     
   Epoch(d) = i;
   Montage (d) = 256;
   Source_method {d} = 'wMNE';
   Connectivity_method {d} = 'PLV';
   Accuracy(d) = pw(i,5);
   d = d+1;
   
   Epoch(d) = i;
   Montage (d) = 128;
   Source_method {d} = 'wMNE';
   Connectivity_method {d} = 'PLV';
   Accuracy(d) = pw(i,4);
   d = d+1;
   
   Epoch(d) = i;
   Montage (d) = 64;
   Source_method {d} = 'wMNE';
   Connectivity_method {d} = 'PLV';
   Accuracy(d) = pw(i,3);
   d = d+1;
   
   Epoch(d) = i;
   Montage (d) = 32;
   Source_method {d} = 'wMNE';
   Connectivity_method {d} = 'PLV';
   Accuracy(d) = pw(i,2);
   d = d+1;
   
   Epoch(d) = i;
   Montage (d) = 19;
   Source_method {d} = 'wMNE';
   Connectivity_method {d} = 'PLV';
   Accuracy(d) = pw(i,1);
   d = d+1;
   
   Epoch(d) = i;
   Montage (d) = 256;
   Source_method {d} = 'eLORETA';
   Connectivity_method {d} = 'wPLI';
   Accuracy(d) = we(i,5);
   d = d+1;
   
   Epoch(d) = i;
   Montage (d) = 128;
   Source_method {d} = 'eLORETA';
   Connectivity_method {d} = 'wPLI';
   Accuracy(d) = we(i,4);
   d = d+1;
   
   Epoch(d) = i;
   Montage (d) = 64;
   Source_method {d} = 'eLORETA';
   Connectivity_method {d} = 'wPLI';
   Accuracy(d) = we(i,3);
   d = d+1;
   
   Epoch(d) = i;
   Montage (d) = 32;
   Source_method {d} = 'eLORETA';
   Connectivity_method {d} = 'wPLI';
   Accuracy(d) = we(i,2);
   d = d+1;
   
   Epoch(d) = i;
   Montage (d) = 19;
   Source_method {d} = 'eLORETA';
   Connectivity_method {d} = 'wPLI';
   Accuracy(d) = we(i,1);
   d = d+1;
   
   Epoch(d) = i;
   Montage (d) = 256;
   Source_method {d} = 'wMNE';
   Connectivity_method {d} = 'wPLI';
   Accuracy(d) = ww(i,5);
   d = d+1;
   
   Epoch(d) = i;
   Montage (d) = 128;
   Source_method {d} = 'wMNE';
   Connectivity_method {d} = 'wPLI';
   Accuracy(d) = ww(i,4);
   d = d+1;
   
   Epoch(d) = i;
   Montage (d) = 64;
   Source_method {d} = 'wMNE';
   Connectivity_method {d} = 'wPLI';
   Accuracy(d) = ww(i,3);
   d = d+1;
   
   Epoch(d) = i;
   Montage (d) = 32;
   Source_method {d} = 'wMNE';
   Connectivity_method {d} = 'wPLI';
   Accuracy(d) = ww(i,2);
   d = d+1;
   
   Epoch(d) = i;
   Montage (d) = 19;
   Source_method {d} = 'wMNE';
   Connectivity_method {d} = 'wPLI';
   Accuracy(d) = ww(i,1);
   d = d+1;
    
end

data = table(Epoch',Montage',Source_method',Connectivity_method',Accuracy');

writetable(data,'results_values/all_results_major_revision')