function significance = get_results_values(param1,param2)

files = dir(['results/results*' param1 '*' param2 '.mat']);

nb_cases = length(files);
nb_trials = 30;
% sensitivity = zeros(nb_trials,nb_cases);
% specificity = zeros(nb_trials,nb_cases);
accuracy = zeros(nb_trials,nb_cases);
% avgDist = zeros(30,nb_cases);

method = {};
montages ={};
for k = 1:length(files)
    
    load(['results/' files(k).name],'results')
    
    sp  = split(files(k).name,["_",".mat"]);
    method{k} = char(join(sp(2:3),"_"));
    montages{k} = char(join(sp(4:end-3),"_"));%% end-x?!!!
    
    results_param = fieldnames(results);
    
    order{k} =sp{end-3};
    
    accuracy(:,k) = [results.accuracy];
    
end

order = cellfun(@str2num,order);
[~,I] = sort(order);

accuracy = accuracy(:,I);

% accuracy(nb_trials+1,:) = mean(accuracy,1);
% accuracy(nb_trials+2,:) = std(accuracy,1);
% if ismember(param,montages{1})
%     var_names = method;
% else
%     var_names = {"19 Channels", "32 Channels", '64 Channels', '128 Channels', '256 Channels'};
% end
% 
if exist('results_values','dir') ~= 7
    mkdir('results_values')
end
% accuracy_table = array2table(accuracy,'VariableNames',string(var_names));
% save(['results_values/accuracy_' param '_' char(sp(end-1)) '.mat'],'accuracy')
save(['results_values/accuracy_' param1 '_' param2 '.mat'],'accuracy')
% writetable(accuracy_table,['results_values/accuracy_' param '_' sp(end-1)])





end
