clear all;


for i = 1:1:9

    switch i
        case 1 
            fignameb = "Bump~Gradient=0.0833~Width=0.500";
            fignamed = "Dent~Gradient=0.0833~Width=0.500";
        case 2 
            fignameb = "Bump~Gradient=0.109~Width=0.500.fig";
            fignamed = "Dent~Gradient=0.109~Width=0.500.fig";
        case 3 
            fignameb = "Bump~Gradient=0.144~Width=0.500.fig";
            fignamed = "Dent~Gradient=0.144~Width=0.500.fig";
        case 4 
            fignameb = "Bump~Gradient=0.0833~Width=0.840.fig";
            fignamed = "Dent~Gradient=0.0833~Width=0.840.fig";
        case 5 
            fignameb = "Bump~Gradient=0.109~Width=0.840.fig";
            fignamed = "Dent~Gradient=0.109~Width=0.840.fig";
        case 6 
            fignameb = "Bump~Gradient=0.144~Width=0.840.fig";
            fignamed = "Dent~Gradient=0.144~Width=0.840.fig";
        case 7
            fignameb = "Bump~Gradient=0.0833~Width=1.414.fig";
            fignamed = "Dent~Gradient=0.0833~Width=1.414.fig";
        case 8 
            fignameb = "Bump~Gradient=0.109~Width=1.414.fig";
            fignamed = "Dent~Gradient=0.109~Width=1.414.fig";
        case 9 
            fignameb = "Bump~Gradient=0.144~Width=1.414.fig";
            fignamed = "Dent~Gradient=0.144~Width=1.414.fig";
    end

    retrieveMethod = "samely";
    run("LoadExcelDataByShape.m")
    
    %%change below by hand
    B = B{:,:};
    D = D{:,:};
    B(B(:,3)>100000,:) = [];
    D(D(:,3)>100000,:) = [];
    
    if min(B(:,3))<-30
        B(:,3) = B(:,3) -min(B(:,3));
    end
    
    if min(D(:,3))<-30
        D(:,3) = D(:,3) -min(D(:,3));
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    %%%%%%%%%%左のロードセル方向に触察した横力のデータのみ%%%%%%%%%%%%%%
    %%%%%%%%bump%%%%%%%%%%%%
    B = AnalyzeForceFunction.onlyOneDirectionForce(B,3,500);    %(Alldata, positionの列番号, データの間隔)
    D = AnalyzeForceFunction.onlyOneDirectionForce(D,3,500);    %(Alldata, positionの列番号, データの間隔)
    
    
    %%%%%%%%1mmごとの接線力の平均観測値を計算%%%%%%%%
    LeftForce_index_bump = AnalyzeForceFunction.makeIndexedForce(B);
    LeftForce_index_dent = AnalyzeForceFunction.makeIndexedForce(D);
    
    
    %%%%%%%%plot用の変数%%%%%%%%
    MAXPOS_BUMP = int8(max(B(:,3)));
    MINPOS_BUMP = int8(min(B(:,3)));
    SLIDELENGTH_BUMP = MINPOS_BUMP:1:MAXPOS_BUMP;
    
    MAXPOS_DENT = int8(max(D(:,3)));
    MINPOS_DENT = int8(min(D(:,3)));
    SLIDELENGTH_DENT = MINPOS_DENT:1:MAXPOS_DENT;
    
    
    %%%%%%%%Bump graph
    % close all
    %ベクトルの数が合わないから,最後の方のインデックスは削除して，ベクトルの次元を合わせる
    SLIDELENGTH_BUMP(:,length(SLIDELENGTH_BUMP)-(length(SLIDELENGTH_BUMP)-length(LeftForce_index_bump)-1):length(SLIDELENGTH_BUMP)) = [];
    SLIDELENGTH_DENT(:,length(SLIDELENGTH_DENT)-(length(SLIDELENGTH_DENT)-length(LeftForce_index_dent)-1):length(SLIDELENGTH_DENT)) = [];
    
    %%%%%Average
    % averageBump = mean(LeftForce_index_bump)
    % averageDent = mean(LeftForce_index_dent)
    
    close all
    figure;
    hold on
    %%%%%%%%vertical hosei
    % i = min(length(LeftForce_index_bump_High),length(LeftForce_index_bump_Low));
    % temp_A = LeftForce_index_bump_High(1:i,1) - LeftForce_index_bump_Low(1:i,1);
    % diff_LH = mean(temp_A,'all');
    % LeftForce_index_bump_High = LeftForce_index_bump_High - diff_LH;
    
    plot(SLIDELENGTH_BUMP,LeftForce_index_bump,Color="#0072BD")
    % scatter(SLIDELENGTH_BUMP_LOW,LeftForce_index_bump_Low,"red",'o')
    % scatter(SLIDELENGTH_BUMP_HIGH,LeftForce_index_bump_High,"blue","+")
    xlabel('Position (mm)','FontSize',16,'FontWeight','normal','FontName','Times')
    ylabel('Force (N)','FontSize',16,'FontWeight','normal','FontName','Times')
    xlim([0 130])
    xticks([0 50 100])
    ylim([-0.25 0.26])
    yticks([-0.2 -0.1 0 0.1 0.2])
    set(gca,'FontSize', 14, 'FontName', 'Times')
    % legend('Bump','Dent')
    % title('Bump (a3)','FontSize',16,'FontWeight','normal')
    hold off
%     pass = uigetdir;
%     save(fullfile(pass,fignameb));
    
    
    %%%%%%%%Dent graph
    %ベクトルの数が合わないから
    % SLIDELENGTH_DENT_LOW(:,length(SLIDELENGTH_DENT_LOW)-(length(SLIDELENGTH_DENT_LOW)-length(LeftForce_index_dent_Low)-1):length(SLIDELENGTH_DENT_LOW)) = [];
    % SLIDELENGTH_DENT_HIGH(:,length(SLIDELENGTH_DENT_HIGH)-(length(SLIDELENGTH_DENT_HIGH)-length(LeftForce_index_dent_High)-1):length(SLIDELENGTH_DENT_HIGH)) = [];
    % figure(2)
    % % i = min(length(LeftForce_index_dent_High),length(LeftForce_index_dent_Low));
    % % temp_A = LeftForce_index_dent_High(1:i,1) - LeftForce_index_dent_Low(1:i,1);
    % % diff_LH = mean(temp_A,'all');
    % % LeftForce_index_dent_High = LeftForce_index_dent_High - diff_LH;
    % 
    
    figure;
    hold on
    plot(SLIDELENGTH_DENT,LeftForce_index_dent,Color="#D95319")
    xlabel('Position (mm)','FontSize',16,'FontWeight','normal','FontName','Times')
    ylabel('Force (N)','FontSize',16,'FontWeight','normal','FontName','Times')
    xlim([0 130])
    xticks([0 50 100])
    ylim([-0.25 0.26])
    yticks([-0.2 -0.1 0 0.1 0.2])
    set(gca,'FontSize', 14, 'FontName', 'Times')
    % title('Dent (a3)','FontSize',16,'FontWeight','normal')
    % legend('Bump','Dent')
    hold off
    % plot(SLIDELENGTH_DENT_LOW,LeftForce_index_dent_Low,SLIDELENGTH_DENT_HIGH,LeftForce_index_dent_High)
    % % scatter(SLIDELENGTH_DENT_LOW,LeftForce_index_dent_Low,SLIDELENGTH_DENT_HIGH,LeftForce_index_dent_High)
    % xlabel('Position (mm)','FontSize',16,'FontWeight','normal')
    % ylabel('Force (N)','FontSize',16,'FontWeight','normal')
    % legend('Low','High')
    % title('Dent (a3)','FontSize',16,'FontWeight','normal')
%     pass = uigetdir;
%     save(fullfile(pass,fignamed),gcf);
end





