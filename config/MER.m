function [MERc, MERh,Tph,MERsav ,Tpc,figure_comp_fig] = MER(deltaT)
% [MERc, MERh,Tph, Tpc] = MER_cal(Tinh, Touth, cph, Tinc, Toutc, cpc, deltaT)
% input
% read table

% % deltaT=10;

% writetable(T,'Excel_Template.xlsx')

% % read names of column
% % table does not read the first row

Tabh = readtable('Table_hot.xlsx');
Tabc = readtable('Table_cold.xlsx');

IDh = Tabh{:,1};
Tinh = Tabh{:,2};
Touth = Tabh{:,3};
cph = Tabh{:,4};
% () output element; {} output values
Enthh = Tabh{:,5};

IDc = Tabc{:,1};
Tinc= Tabc{:,2};
Toutc = Tabc{:,3};
cpc= Tabc{:,4};
Enthc = Tabc{:,5};

% MER target
% minimun enrgy requirement

% calculate average heat capacity
addpath U:\one_route_example_class\Heat_integration
cd U:\one_route_example_class\Heat_integration

[cpc,cph]=cp(Tinh, Touth, Tinc, Toutc,Enthc,Enthh);

addpath U:\Git
cd U:\Git

% relocate all streams
Tincd=Tinc+deltaT/2;
Toutcd=Toutc+deltaT/2;
Tinhd=Tinh-deltaT/2;
Touthd=Touth-deltaT/2;

% sort relocated temperature/temparature integral
% repeated values may appear
sortTd1=unique([Tinhd', Touthd', Tincd', Toutcd']');
sortTd=sort(sortTd1, 'descend');

Nsort=length(sortTd);
% hot/cold stream number
Nh=length(Tinh);
Nc=length(Tinc);
N=Nc+Nh;

% identifly if stream temperature covers the temperature segments
resi_segm = false(Nsort-1,N);
Tinter= zeros(Nsort-1, 1);
i=1;
j=1;

for i=1:Nsort-1
    % for each temperature interval
    % Ti is the highest temperature
    % Tin is the next highest temperature
    Ti=sortTd(i);
    Tin=sortTd(i+1);
    % array of temperature interval
    Tinter(i)=Ti-Tin;
    
    for j=1:Nh
        if (Tinhd(j)>=Ti) && (Touthd(j)<=Tin)
            resi_segm(i,j) = true;
        end
    end
    
    j=1;
    for j=Nh+1:N
        if (Tincd(j-Nh)<=Tin) && (Toutcd(j-Nh)>=Ti)
            resi_segm(i,j) = true;
        end
    end
end

% calculate enthalpy per temperature interval
i=1;

enth=zeros(Nsort,1);
for i = 1:Nsort-1
    nop = resi_segm(i,1:end); % Like FEM nop --> logical vector for certain temperature segment
    cphtot = sum(cph(nop(1:Nh)));
    cpctot = sum(cpc(nop(Nh+1:N)));
    enth(i+1) = enth(i) - (cpctot-cphtot)*Tinter(i);
end

Tp = sortTd(enth <(-10^-10));
Tp = max(Tp);
Tph = Tp + deltaT/2;
Tpc = Tp - deltaT/2;


enthmax=-min(enth);
MERsav=-min(enth);
enth=enthmax+enth;
MERc=enth(Nsort);
MERh=enth(2);

delete Tabh
delete Tabc

% % composite figure
[figure_comp_fig]=composite_curve(resi_segm,cph,cpc,sortTd,Nsort, Nh, Nc,deltaT,N,enth)

end

