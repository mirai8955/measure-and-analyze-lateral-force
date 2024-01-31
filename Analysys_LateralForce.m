% B_a1 = readtable("LateralForceBump_a1.csv");
% B_a2 = readtable("LateralForceBump_a2.csv");
% B_a3 = readtable("LateralForceBump_a3.csv");
B_b1 = readtable("LateralForceBump_b1.csv");
% B_b2 = readtable("LateralForceBump_b2.csv");
% B_b3 = readtable("LateralForceBump_b3.csv");
% B_c1 = readtable("LateralForceBump_c1.csv");
% B_c2 = readtable("LateralForceBump_c2.csv");
% B_c3 = readtable("LateralForceBump_c3.csv");
% D_a1 = readtable("LateralForceDent_a1.csv");
% D_a2 = readtable("LateralForceDent_a2.csv");
% D_a3 = readtable("LateralForceDent_a3.csv");
D_b1 = readtable("LateralForceDent_b1.csv");
% D_b2 = readtable("LateralForceDent_b2.csv");
% D_b3 = readtable("LateralForceDent_b3.csv");
% D_c1 = readtable("LateralForceDent_c1.csv");
% D_c2 = readtable("LateralForceDent_c2.csv");
% D_c3 = readtable("LateralForceDent_c3.csv");


% B_d1 = readtable("LateralForceBump_d1.csv");
% B_d2 = readtable("LateralForceBump_d2.csv");
% B_d3 = readtable("LateralForceBump_d3.csv");
% B_e1 = readtable("LateralForceBump_e1.csv");
% B_e2 = readtable("LateralForceBump_e2.csv");
% B_e3 = readtable("LateralForceBump_e3.csv");
% B_f1 = readtable("LateralForceBump_f1.csv");
% B_f2 = readtable("LateralForceBump_f2.csv");
% B_f3 = readtable("LateralForceBump_f3.csv");
% D_d1 = readtable("LateralForceDent_d1.csv");
% D_d2 = readtable("LateralForceDent_d2.csv");
% D_d3 = readtable("LateralForceDent_d3.csv");
% D_e1 = readtable("LateralForceDent_e1.csv");
% D_e2 = readtable("LateralForceDent_e2.csv");
% D_e3 = readtable("LateralForceDent_e3.csv");
% D_f1 = readtable("LateralForceDent_f1.csv");
% D_f2 = readtable("LateralForceDent_f2.csv");
% D_f3 = readtable("LateralForceDent_f3.csv");

%%%%%%%%%%table to numerous%%%%%%%%%%%%%%
B = B_b1;
PositionData_bump = zeros(size(B));
PositionData_bump(:,1) = B{:,1};
PositionData_bump(:,2) = B{:,2};
PositionData_bump(:,3) = B{:,3};
PositionData_bump(:,4) = B{:,4};

D = D_b1;
PositionData_dent = zeros(size(D));
PositionData_dent(:,1) = D{:,1};
PositionData_dent(:,2) = D{:,2};
PositionData_dent(:,3) = D{:,3};
PositionData_dent(:,4) = D{:,4};

%%%%%%%%%%AD%%%%%%%%%%%%%%

% time = PositionData(:,4);
% 
% V_right = PositionData{:,1};
% V_left = PositionData{:,2};

%%%%%%%%%%filter%%%%%%%%%%%%%%
% windowSize = 50; %%%%キャリブレーションの時は大きくてよい
% b = (1/windowSize)*ones(1,windowSize);
% a = 1;
% V_left_filtered = filter(b,a,V_left);
% V_right_filtered = filter(b,a,V_right);

%%%%%%%%%%calibrating and converting sensor's readings to newtons%%%%%%%%%%%%%%
% Weight_left = 0.2324 * V_left_filtered;  %% 0.2324 = calibration
% Weight_right = 0.2438 * V_right_filtered;  %% 0.2438 = calibration
% LateralForce_left = Weight_left / 0.00981;  
% LateralForce_right = Weight_right / 0.00981;  

% counterNBits = 32;
% signedThreshold = 2^(counterNBits-1);
% signedData = PositionData{:,3};
% signedData(signedData > signedThreshold) = signedData(signedData > signedThreshold) - 2^counterNBits;
% position = signedData / 4 / 500 * 13*pi;
% PositionData = zeros(size(PositionData));
% PositionData(:,1) = LateralForce_right;
% PositionData(:,2) = LateralForce_left;
% PositionData(:,3) = position;
% PositionData(:,4) = time;


%%%%%%%%%%Data Process%%%%%%%%%%%%%%
PositionData_bump(PositionData_bump(:,3)>150,:) = [];
PositionData_dent(PositionData_dent(:,3)>150,:) = [];

%%%%%%%%%%One direction only　左のロードセル方向に触察した横力のデータのみ%%%%%%%%%%%%%%
%%%%%%%%bump%%%%%%%%%%%%
temp_pos = PositionData_bump(:,3);
for i = 150000:-500:500                          %1から行削除を行うとインデックスがずれる
    diff_pos500 = temp_pos(i,1) - temp_pos(i-499,1);
    if diff_pos500 < 0
        PositionData_bump(i-499:i,:) = [];
    end
end

%%%%%%%%dent%%%%%%%%%%%%
temp_pos = PositionData_dent(:,3);
for i = 150000:-500:500                          %1から行削除を行うとインデックスがずれる
    diff_pos500 = temp_pos(i-499,1) - temp_pos(i,1);
    if diff_pos500 < 0
        PositionData_dent(i-499:i,:) = [];
    end
end


% %%外れ値削除
% PositionData(PositionData(:,2)>5,:) = [];
% cond1 = PositionData(:,2) > 2 & PositionData(:,3) < 40;
% PositionData(cond1,:) = [];
% cond2 = PositionData(:,2) < -12 & PositionData(:,3) < 40;
% PositionData(cond2,:) = [];
% cond3 = PositionData(:,2) > -5 & PositionData(:,3) > 70;
% PositionData(cond3,:) = [];


%%位置ごとに平均近似
LeftForce_index_bump = fit(PositionData_bump);
LeftForce_index_dent = fit(PositionData_dent);

MAXPOS_BUMP = int8(max(PositionData_bump(:,3)));
MINPOS_BUMP = int8(min(PositionData_bump(:,3)));
SLIDELENGTH_BUMP = MAXPOS_BUMP - MINPOS_BUMP;

MAXPOS_DENT = int8(max(PositionData_dent(:,3)));
MINPOS_DENT = int8(min(PositionData_dent(:,3)));
SLIDELENGTH_DENT = MAXPOS_DENT - MINPOS_DENT;

%%%変数調整
position = PositionData_bump(:,3);
LateralForce_left = PositionData_bump(:,2);
position_interval_bump = MINPOS_BUMP:1:MAXPOS_BUMP;
position_interval_bump(:,length(position_interval_bump)-(length(position_interval_bump)-length(LeftForce_index_bump)-1):length(position_interval_bump)) = [];
position_interval_dent = MINPOS_DENT:1:MAXPOS_DENT;
position_interval_dent(:,length(position_interval_dent)-(length(position_interval_dent)-length(LeftForce_index_dent)-1):length(position_interval_dent)) = [];
position_interval_dent = -position_interval_dent;

close all
figure(1)
plot(position_interval_bump,LeftForce_index_bump,position_interval_dent + 73,LeftForce_index_dent+15)
xlabel('Position (mm)','FontSize',16,'FontWeight','normal')
ylabel('Force (N)','FontSize',16,'FontWeight','normal')
legend('bump','dent')
title('a3','FontSize',16,'FontWeight','normal')


function LeftForce_index_bump = fit(Data)
    MAXPOS = int8(max(Data(:,3)));
    MINPOS = int8(min(Data(:,3)));
    SLIDELENGTH = MAXPOS - MINPOS + 1;
    LeftForce_index = zeros(SLIDELENGTH,1);
    
    for i = MINPOS:1:MAXPOS
        temp_PositionData = Data;
        j = i - MINPOS + 1;
    
        Cond_index = temp_PositionData(:,3) >= i & temp_PositionData(:,3) < i+1;
        temp_LeftForce_index = temp_PositionData(Cond_index,2);
        temp_LeftForce_index = rmoutliers(temp_LeftForce_index); %標準偏差の3倍以上を外れ値削除
        LeftForce_index(j,1) = mean(temp_LeftForce_index);
    end

    LeftForce_index_bump = LeftForce_index;
end