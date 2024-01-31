clc
all clear
clear
close all;
% encoderPosition = read(dq, 1, 'OutputFormat','Matrix');
dq = daq('ni');
% dq.ScansAvailableFcn = @(src, evt) logData(src, evt, fid1)


% ch3 = addinput(dq, 'Dev1', 'ctr0', 'position');
% addinput(dq, 'Dev1', 'ai1', 'Voltage'); %use external clock
ch3 = addinput(dq, 'Dev2', 'ctr0', 'position');
addinput(dq, 'Dev2', 'ai1', 'Voltage'); %use external clock
dq.Channels

ch3.EncoderType = 'X4';

encoderPosition = read(dq,1);

encoderCPR = 4096; %% or 1024 ??    %%RE30Eだと1回転当たり1024??もしかしたら違う
% encoderPositionDeg = encoderPosition.Dev1_ctr0 * 2 * pi / encoderCPR; 
encoderPositionDeg = encoderPosition.Dev2_ctr0 * 2 * pi / encoderCPR; 
% encoderPositionDeg = encoderPosition.Dev1_ctr0 * 2* pi / encoderCPR;  %6.5???%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dq.Rate = 10000; %%Sampling Rate 2 kHz
daqDuration = seconds(5);
% s.DurationInSeconds = 50; %%Sampling Duration 50s
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[positionData, timestamps] = read(dq, daqDuration, 'OutputFormat', 'Matrix');