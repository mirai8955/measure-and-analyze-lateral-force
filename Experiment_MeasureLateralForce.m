clc
all clear
clear
close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dq = daq('ni');
% d = daqlist("ni");
% deviceInfo = d{1,"DeviceInfo"};

ch1 = addinput(dq, "Dev1", "ai1", "Voltage");
ch2 = addinput(dq, "Dev1", "ai2", "Voltage");
ch3 = addinput(dq, "Dev1", "ctr0", "Position");

% encoderPosition = read(dq, 1, 'OutputFormat','Matrix');

ch3.EncoderType = 'X4';

encoderPosition = read(dq,1);

encoderCPR = 500; %%2r=7.5
encoderPositionDeg = encoderPosition.Dev1_ctr0 * 2 * pi / encoderCPR; 
% encoderPositionDeg = encoderPosition.Dev1_ctr0 * 2* pi / encoderCPR;  %6.5???%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dq.Rate = 5000; %%Sampling Rate 2 kHz
daqDuration = seconds(40);
% s.DurationInSeconds = 50; %%Sampling Duration 50s
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[positionData, timestamps] = read(dq, daqDuration, 'OutputFormat', 'matrix');

V_right = positionData(:,1);
V_left = positionData(:,2);

%%%%%%%%%%filter%%%%%%%%%%%%%%
windowSize = 45; 
b = (1/windowSize)*ones(1,windowSize);
a = 1;
V_left_filtered = filter(b,a,V_left);
V_right_filtered = filter(b,a,V_right);

%%%%%%%%%%calibrating and converting sensor's readings to newtons%%%%%%%%%%%%%%
% Weight_left = 0.2324 * V_left_filtered;  %% 0.2324 = calibration
% Weight_right = 0.2438 * V_right_filtered;  %% 0.2438 = calibration
% LateralForce_left = Weight_left / 0.00981;  
% LateralForce_right = Weight_right / 0.00981;  
LateralForce_left = 0.2324 * V_left_filtered;  
LateralForce_right = 0.2438 * V_right_filtered;  

%%%%%%%%%%for calibration%%%%%%%%%%%%%%
% str = sprintf('left is %f, right is %f', mean(LateralForce_left), mean(LateralForce_right))

counterNBits = 32;
signedThreshold = 2^(counterNBits-1);
signedData = positionData(:,3);
signedData(signedData > signedThreshold) = signedData(signedData > signedThreshold) - 2^counterNBits;

position = signedData / 4 / 500 * 13*pi;

%%%%%%%%%plot%%%%%%%%%%%%%%
figure(1);
clf
plot(position, LateralForce_left)
ylabel("Force (N)");
xlabel("Position (mm)")
title('LateralForceLeft')

figure(2);
plot(position, LateralForce_right)
ylabel("Force (N)");
xlabel("Position (mm)")
title('LateralForceRight')

figure(3)
plot( timestamps, position )

figure(4)
subplot(2,1,1)
plot(timestamps, LateralForce_right)
title('LateralForceRight')
subplot(2,1,2)
plot(timestamps, LateralForce_left)
title('LateralForceLeft')


MeasurementData = [LateralForce_right, LateralForce_left, position, timestamps];
csvwrite('LateralForceBump_f1_LH.csv', MeasurementData);
% csvwrite('LateralForceDent_f2_LH.csv', MeasurementData);


