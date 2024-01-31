clear all;
% B_a1 = readtable("LateralForceBump_a1_LH.csv");D_a1 = readtable("LateralForceDent_a1_LH.csv"); B=B_d1; D=D_d1;
% B_a2 = readtable("LateralForceBump_a2_LH.csv");D_a2 = readtable("LateralForceDent_a2_LH.csv"); B=B_d2; D=D_d2; 
% B_a3 = readtable("LateralForceBump_a3_LH.csv");D_a3 = readtable("LateralForceDent_a3_LH.csv"); B=B_d3; D=D_d3;
% B_b1 = readtable("LateralForceBump_b1_LH.csv");D_b1 = readtable("LateralForceDent_b1_LH.csv"); B=B_e1; D=D_e1;
% B_b2 = readtable("LateralForceBump_b2_LH.csv");D_b2 = readtable("LateralForceDent_b2_LH.csv"); B=B_e2; D=D_e2;
% B_b3 = readtable("LateralForceBump_b3_LH.csv");D_b3 = readtable("LateralForceDent_b3_LH.csv"); B=B_e3; D=D_e3;
% B_c1 = readtable("LateralForceBump_c1_LH.csv");D_c1 = readtable("LateralForceDent_c1_LH.csv"); B=B_f1; D=D_f1;
% B_c2 = readtable("LateralForceBump_c2_LH.csv");D_c2 = readtable("LateralForceDent_c2_LH.csv"); B=B_f2; D=D_f2;
% B_c3 = readtable("LateralForceBump_c3_LH.csv");D_c3 = readtable("LateralForceDent_c3_LH.csv"); B=B_f3; D=D_f3;


%%%%[LateralForce_right, LateralForce_left, position, timestamps];
B_d1 = readtable("LateralForceBump_d1_LH.csv"); D_d1 = readtable("LateralForceDent_d1_LH.csv"); B=B_d1; D=D_d1;
% B_d2 = readtable("LateralForceBump_d2_LH.csv"); D_d2 = readtable("LateralForceDent_d2_LH.csv"); B=B_d2; D=D_d2; 
% B_d3 = readtable("LateralForceBump_d3_LH.csv"); D_d3 = readtable("LateralForceDent_d3_LH.csv"); B=B_d3; D=D_d3;
% B_e1 = readtable("LateralForceBump_e1_LH.csv"); D_e1 = readtable("LateralForceDent_e1_LH.csv"); B=B_e1; D=D_e1;
% B_e2 = readtable("LateralForceBump_e2_LH.csv"); D_e2 = readtable("LateralForceDent_e2_LH.csv"); B=B_e2; D=D_e2;
% B_e3 = readtable("LateralForceBump_e3_LH.csv"); D_e3 = readtable("LateralForceDent_e3_LH.csv"); B=B_e3; D=D_e3;
% B_f1 = readtable("LateralForceBump_f1_LH.csv"); D_f1 = readtable("LateralForceDent_f1_LH.csv"); B=B_f1; D=D_f1;
% B_f2 = readtable("LateralForceBump_f2_LH.csv"); D_f2 = readtable("LateralForceDent_f2_LH.csv"); B=B_f2; D=D_f2;
% B_f3 = readtable("LateralForceBump_f3_LH.csv"); D_f3 = readtable("LateralForceDent_f3_LH.csv"); B=B_f3; D=D_f3;


%%change below by hand
B = B{:,:};
D = D{:,:};
B_SEP = 54682;     %lowとhighを区切るデータの点
D_SEP = 63421;

%%キャリブレーション間違っていたので補正(a~cのみ)
% B(:,1:2) = B(:,1:2) * 0.00981;
% D(:,1:2) = D(:,1:2) * 0.00981;
speedB = zeros(length(B(:,3)),1);
speedD = zeros(length(D(:,3)),1);

%%5kでサンプリングしていたので，mm/sの速度単位に補正
i = 1;
for j = 1:1:length(B(:,3))-499
    speedB(i,1) = (B(i+499,3) - B(i,3))*10;
    i = i + 1;
end

i = 1;
for j = 1:1:length(D(:,3))-499
    speedD(i,1) = (D(i+499,3) - D(i,3))*10;
    i = i + 1;
end

B = [B,speedB];
B_SEP = B_SEP;
B_High = B(1:B_SEP,:);
B_Low = B(B_SEP:length(B(:,3)),:);

D = [D,speedD];
D_SEP = D_SEP;
D_High = D(1:D_SEP,:);
D_Low = D(D_SEP:length(D(:,3)),:);


%%%%%%%%%%Data Process%%%%%%%%%%%%%%
B_Low(B_Low(:,3)>150,:) = [];
D_Low(D_Low(:,3)>150,:) = [];


%%%%%%%%%%One direction only　左のロードセル方向に触察した横力のデータのみ%%%%%%%%%%%%%%
%%%%%%%%bump%%%%%%%%%%%%
temp_pos = B_Low(:,3);                                   
for i = length(B_Low(:,3)):-500:500                      %1から行削除を行うとインデックスがずれる
    diff_pos500 = temp_pos(i,1) - temp_pos(i-499,1);
    if diff_pos500 < 0                                   %右方向への触察データは削除,B_Lowには左方向の触察分だけ,マイナスの時が左方向だから<0
        B_Low(i-499:i,:) = [];
    end
end

temp_pos = B_High(:,3);
for i = length(B_High(:,3)):-500:500
    diff_pos500 = temp_pos(i,1) - temp_pos(i-499,1);
    if diff_pos500 < 0
        B_High(i-499:i,:) = [];
    end
end


%%%%%%%%dent%%%%%%%%%%%%
temp_pos = D_Low(:,3);
for i = length(D_Low(:,3)):-500:500
    diff_pos500 = temp_pos(i-499,1) - temp_pos(i,1);
    if diff_pos500 < 0
        D_Low(i-499:i,:) = [];
    end
end

temp_pos = D_High(:,3);
for i = length(D_High(:,3)):-500:500
    diff_pos500 = temp_pos(i-499,1) - temp_pos(i,1);
    if diff_pos500 < 0
        D_High(i-499:i,:) = [];
    end
end


%%%%%%%%1mmごとの接線力の平均観測値を計算%%%%%%%%
LeftForce_index_bump_Low = fit(B_Low);                           %fit関数は下に定義: 1mmごとに，その位置で観測されたデータを平均
LeftForce_index_bump_High = fit(B_High);
LeftForce_index_dent_Low = fit(D_Low);
LeftForce_index_dent_High = fit(D_High);

MAXPOS_BUMP_LOW = int8(max(B_Low(:,3)));
MINPOS_BUMP_LOW = int8(min(B_Low(:,3)));
SLIDELENGTH_BUMP_LOW = MINPOS_BUMP_LOW:1:MAXPOS_BUMP_LOW;

MAXPOS_BUMP_HIGH = int8(max(B_High(:,3)));
MINPOS_BUMP_HIGH = int8(min(B_High(:,3)));
SLIDELENGTH_BUMP_HIGH = MINPOS_BUMP_HIGH:1:MAXPOS_BUMP_HIGH;

MAXPOS_DENT_LOW = int8(max(D_Low(:,3)));
MINPOS_DENT_LOW = int8(min(D_Low(:,3)));
SLIDELENGTH_DENT_LOW = MINPOS_DENT_LOW:1:MAXPOS_DENT_LOW;

MAXPOS_DENT_HIGH = int8(max(D_High(:,3)));
MINPOS_DENT_HIGH = int8(min(D_High(:,3)));
SLIDELENGTH_DENT_HIGH = MINPOS_DENT_HIGH:1:MAXPOS_DENT_HIGH;


%%%%%%%%Bump graph
close all
%ベクトルの数が合わないから,最後の方のインデックスは削除して，ベクトルの次元を合わせる
SLIDELENGTH_BUMP_LOW(:,length(SLIDELENGTH_BUMP_LOW)-(length(SLIDELENGTH_BUMP_LOW)-length(LeftForce_index_bump_Low)-1):length(SLIDELENGTH_BUMP_LOW)) = [];
SLIDELENGTH_BUMP_HIGH(:,length(SLIDELENGTH_BUMP_HIGH)-(length(SLIDELENGTH_BUMP_HIGH)-length(LeftForce_index_bump_High)-1):length(SLIDELENGTH_BUMP_HIGH)) = [];

figure(1)
hold on
%%%%%%%%vertical hosei
% i = min(length(LeftForce_index_bump_High),length(LeftForce_index_bump_Low));
% temp_A = LeftForce_index_bump_High(1:i,1) - LeftForce_index_bump_Low(1:i,1);
% diff_LH = mean(temp_A,'all');
% LeftForce_index_bump_High = LeftForce_index_bump_High - diff_LH;

for i = 1:1:length(LeftForce_index_dent_High)
    
end

plot(SLIDELENGTH_BUMP_LOW,LeftForce_index_bump_Low,SLIDELENGTH_BUMP_HIGH,LeftForce_index_bump_High)
% scatter(SLIDELENGTH_BUMP_LOW,LeftForce_index_bump_Low,"red",'o')
% scatter(SLIDELENGTH_BUMP_HIGH,LeftForce_index_bump_High,"blue","+")
xlabel('Position (mm)','FontSize',16,'FontWeight','normal')
ylabel('Force (N)','FontSize',16,'FontWeight','normal')
legend('Low','High')
% title('Bump (a3)','FontSize',16,'FontWeight','normal')
hold off


%%%%%%%%Dent graph
%ベクトルの数が合わないから
SLIDELENGTH_DENT_LOW(:,length(SLIDELENGTH_DENT_LOW)-(length(SLIDELENGTH_DENT_LOW)-length(LeftForce_index_dent_Low)-1):length(SLIDELENGTH_DENT_LOW)) = [];
SLIDELENGTH_DENT_HIGH(:,length(SLIDELENGTH_DENT_HIGH)-(length(SLIDELENGTH_DENT_HIGH)-length(LeftForce_index_dent_High)-1):length(SLIDELENGTH_DENT_HIGH)) = [];
figure(2)
% i = min(length(LeftForce_index_dent_High),length(LeftForce_index_dent_Low));
% temp_A = LeftForce_index_dent_High(1:i,1) - LeftForce_index_dent_Low(1:i,1);
% diff_LH = mean(temp_A,'all');
% LeftForce_index_dent_High = LeftForce_index_dent_High - diff_LH;

plot(SLIDELENGTH_DENT_LOW,LeftForce_index_dent_Low,SLIDELENGTH_DENT_HIGH,LeftForce_index_dent_High)
% scatter(SLIDELENGTH_DENT_LOW,LeftForce_index_dent_Low,SLIDELENGTH_DENT_HIGH,LeftForce_index_dent_High)
xlabel('Position (mm)','FontSize',16,'FontWeight','normal')
ylabel('Force (N)','FontSize',16,'FontWeight','normal')
legend('Low','High')
% title('Dent (a3)','FontSize',16,'FontWeight','normal')



function LeftForce_index_bump = fit(Data)
    MAXPOS = int8(max(Data(:,3)));
    MINPOS = int8(min(Data(:,3)));
    SLIDELENGTH = MAXPOS - MINPOS + 1;
    LeftForce_index = zeros(SLIDELENGTH,1);
    
    for i = MINPOS:1:MAXPOS
        temp_PositionData = Data;
        j = i - MINPOS + 1;
    
        Cond_index = temp_PositionData(:,3) >= i & temp_PositionData(:,3) < i+1;
        if any(Cond_index) 
            temp_LeftForce_index = temp_PositionData(Cond_index,2);
            temp_LeftForce_index = rmoutliers(temp_LeftForce_index); %標準偏差の3倍以上を外れ値削除
            LeftForce_index(j,1) = mean(temp_LeftForce_index,'all');
        end
    end

    LeftForce_index_bump = LeftForce_index;
end

