

function [heat_HDPE_sav]=HI_HDPE

% This script integrates heat in HDPE ASPEN process models
% solution 1
% input paths to RUN_ASPEN
% Output values
% save values in a stream table

cd U:\Git

addpath U:\Git

node_in_path="\Data\Streams\1\Input\TOTFLOW\MIXED";
node_in_value=6;

% input stream number
no_s=18;

% start to loop required value path
% havent figured out how to have values of needed streams
% try to access to all streams then
% Enthalpy and T

% create empty string array
node_out_path=strings(2*no_s,1);
%

i=1;
j=1;
for i=1:no_s
    
    try 
    % form all paths of streams
    % even streams are temperature, odd streams are enthalpy
    % obtain stream temperature
    name_temp=strcat('\Data\Streams\',string(i),'\Output\TEMP_OUT\MIXED');
    node_out_path(2*j-1)=name_temp;
    % obtain stream enthalpy
    name_temp=strcat('\Data\Streams\',string(i),'\Output\HMX_FLOW\MIXED');
    node_out_path(2*j)=name_temp;
    j=j+1;
    catch  
    display(strcat("node value is not found"))
    node_out_value(i)=NaN;
    end
    
end

file_name='HDPE';
% node_out_path

% run ASPEN to obtain stream information
[node_out_value]=run_ASPEN(file_name,node_in_path, node_in_value, node_out_path)

% cold streams
% 16-11
% hot streams
% 17-10
IDh(1)={'HDPE 17-10'};
Tinh(1)=node_out_value(33);
Touth(1)=node_out_value(19);
cph(1)=1;
enthh(1)=node_out_value(34)-node_out_value(20);

IDc(1)={'HDPE 16-11'};
Tinc(1)=node_out_value(31);
Toutc(1)=node_out_value(21);
cpc(1)=1;
enthc(1)=node_out_value(32)-node_out_value(22);

% Table_hot(:,:) = [] ;
Table_hot = table([string(IDh)]', [Tinh]', [Touth]', ...
    [cph]',[enthh]','VariableNames',{'IDh', 'Tinh', 'Touth', 'cph', 'Enthalpy'})


% Table_cold(:,:) = [] ;
Table_cold = table([string(IDc)]', [Tinc]', [Toutc]', ...
    [cpc]',[enthc]','VariableNames',{'IDc', 'Tinc', 'Toutc', 'cpc','Enthalpy'})


writetable(Table_hot,'Table_hot.xlsx')
writetable(Table_cold,'Table_cold.xlsx')

cd U:\Git 
[MERc, MERh,Tph,MERsav ,Tpc,figure_comp_fig] = MER(10)

heat_HDPE_sav=MERsav

end

