
function [node_out_value]=run_ASPEN(file_name,node_in_path, node_in_value, node_out_path)

name = strcat(pwd,'/',file_name,'.bkp')
Aspen = actxserver('Apwn.Document')
Aspen.InitFromArchive2(name)

i=1
for i=1:length(node_in_path)
    Aspen.Tree.FindNode(node_in_path(i)).Value=node_in_value(i);
    i=1+i;
end
i=1

max_time=100;

tic ;
state=0;
current_time=0;

while current_time <= max_time;
    if state==0 && Aspen.Engine.Ready;
        Aspen.Engine.Run2(true);
        state=1;
    end
    if Aspen.Engine.IsRunning==0;
        break
    end
    current_time=toc;
end
if current_time>=max_time;
    disp('Max time reached, Aspen will be stopped');
    taskkill = sprintf('taskkill /F /pid %s',num2str(Aspen.ProcessId));
    system(taskkill);
    pause(2);
    disp('Aspen has been killed');
end
pause(3);

for i=1:length(node_out_path);
    node_out_value(i)=Aspen.Tree.FindNode(node_out_path(i)).Value;
    i=1+i;
end
i=1;

Aspen.Close;
Aspen.Quit;


end % function end

