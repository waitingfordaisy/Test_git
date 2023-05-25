
function [figure_comp_fig]=composite_curve(resi_segm,cph,cpc,sortTd,Nsort, Nh, Nc,deltaT,N,enth)

% enthalpies of hot streams and cold streams
% use flexible-size matrix for T and Enthalpies because the nr of T segments for hot hot streams or cold streams is unkown

enthc(1) = 0;
enthh(1) = 0;
ih = 1;
ic = 1;

for i = 1:Nsort-1
    % Like FEM nop --> logical vector for certain temperature segment
    nop = resi_segm(i,1:end);
    
    % stop looping until an empty element
    if isempty(cph(nop(1:Nh))) == 0
        cphtot = sum(cph(nop(1:Nh)));
        Th(ih) = sortTd(i) + deltaT/2;
        Th(ih+1) = sortTd(i+1) + deltaT/2;
        enthh(ih+1) =  enthh(ih) - cphtot*(sortTd(i)-sortTd(i+1));
        ih = ih + 1;
        
    end
    
    if isempty(cpc(nop(Nh+1:N))) == 0
        cpctot = sum(cpc(nop(Nh+1:N)));
        Tc(ic) = sortTd(i) - deltaT/2;
        Tc(ic+1) = sortTd(i+1) - deltaT/2;
        enthc(ic+1) = enthc(ic) - cpctot*(sortTd(i)-sortTd(i+1));
        ic = ic + 1;
    end
    
end

enthh = enthh + max(abs(enthh));
enthc = enthc + max(abs(enthc));
enthc=enthc + enth(end);

figure_comp_fig=figure
plot(enthh./1000,Th,'r','LineWidth',4)
hold on
plot(enthc./1000,Tc,'b','LineWidth',4)
grid on
ylabel('$$ T  (K) $$','Fontsize',15,'interpreter','latex')
set(gca,'FontSize',15)
set(gca,'TickLabelInterpreter','latex')
title('Temperature - Enthalpy Diagram','Fontsize',20,'interpreter','latex')
xlabel('$$ Heat (kW) $$','Fontsize',15,'interpreter','latex')
hold on


end