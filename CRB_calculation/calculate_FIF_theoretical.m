%%% calculate the FIF-based SPEB

function [FIF_theoretical,FIF_contribution] = calculate_FIF_theoretical(Txlist,Rxlist,target_list)
    Nt = length(Txlist);
    Nr = length(Rxlist);
    FIF = zeros(Nt,Nr);
    SPEB_pairwise = zeros(Nt,Nr);
    
    for i = 1:Nt
        for j = 1:Nr
            FIM = FIM_calculation(Nt,i,Txlist(i),Rxlist(j),target_list);
            iF = inv(FIM);
            SPEB_pairwise(i,j) = (trace(iF(1:2,1:2)));
            FIF(i,j) = 1/trace(iF(1:2,1:2)); %% optimal FI weight
        end
    end
    
    FIF_contribution = FIF/sum(sum(FIF));
    FIF_theoretical = sum(sum(FIF_contribution.^2.*SPEB_pairwise));
end