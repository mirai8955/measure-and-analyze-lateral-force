clc
all clear
clear
close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
d = daqlist;
d(1,:)
s = daq.createSession('ni');
% 
% 
ch1 = addCounterInputChannel(s, 'Dev1', 'ctr0', 'Frequency'); %% left encoder output -> DAQ ch 1
% ch2 = addCounterInputChannel(s, 'Dev1', 1, 'Position'); %% right encoder output -> DAQ ch 2
% ch3 = addAnalogInputChannel(s, 'Dev1', 4, 'Voltage'); %% horizontal sensor -> DAQ ch 4
% ch4 = addAnalogInputChannel(s, 'Dev1', 3, 'Voltage'); %% vertical sensor 1 -> DAQ ch 3
% ch5 = addAnalogInputChannel(s, 'Dev1', 5, 'Voltage'); %% vertical sensor 2 -> DAQ ch 5

%ch5 = addAnalogInputChannel(s, 'Dev1', 'ai5', 'Voltage'); %% vertical sensor 2 -> DAQ ch 5

ch1.TerminalConfig='SingleEnded';
ch4.TerminalConfig='SingleEnded';
ch5.TerminalConfig='SingleEnded';

ch1.EncoderType = 'X4';
ch2.EncoderType = 'X4';

ch1.ZResetEnable = false;
ch2.ZResetEnable = false;

encoderPosition = inputSingleScan(s);

encoderCPR = 6000; %% or 1024 ??    %%RE30E‚¾‚Æ1‰ñ“]“–‚½‚è1024??
encoderPositionDeg = encoderPosition * 2* pi / encoderCPR;  %6.5???%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
s.Rate = 2000; %%Sampling Rate 2 kHz
s.DurationInSeconds = 5; %%Sampling Duration 50s
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[positionData, timestamps] = startForeground(s);

%%%%%%% reasigning DAQ reading %%%%%%
sensorl1 = positionData(:,1);
signedData2 = positionData(:,2);

sensorh = positionData(:,3);
sensorv1 = positionData(:,4);
sensorv2 = positionData(:,5);

figure;
plot(signedData);
figure;
plot(signedData2);
figure;
plot(sensorh);
figure;
plot(sensorv1);
figure;
plot(sensorv2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
%% calibrating and converting sensor's readings to newtons %%
forcel1 = sensorl1 * 0.95 ; %% the sensitivity is 10 N/V
forceh = sensorh * 0.95 ; %% the sensitivity is 10 N/V 
forcev1 = (sensorv1) * 11 ; %% the sensitivity is 10 N/V dual amp
forcev2 = (sensorv2) * 11 ;%% the sensitivity is 10 N/V dual amp 
% 9.5‚ÍZ³Žž‚É‘I‚ñ‚¾

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
averageforcev = (forcev1 + forcev2);
forcev = forceh/(forcev1 + forcev2);

windowSize = 50; 
b = (1/windowSize)*ones(1,windowSize);
a = 1; 
averageforcev1 = filter(b,a,forcev1);
averageforcev2 = filter(b,a,forcev2);
forcevsummation = (averageforcev1 + averageforcev2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% –@ü—Í‚ÌˆÚ“®•½‹Ï

counterNBits = 32;
signedThreshold = 2^(counterNBits-1);
 
signedData(signedData > signedThreshold) = signedData(signedData > signedThreshold) - 2^counterNBits;
signedData2(signedData2 > signedThreshold) = signedData2(signedData2 > signedThreshold) - 2^counterNBits;
 
%%computing angular distance from encoder's count %%%% 
positionDataDeg = signedData * 2* pi/encoderCPR;
positionDataDeg2 = signedData2 * 2* pi/encoderCPR;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% calibrating encoder's reading and computing ditance moved %%
deltax = positionDataDeg * 60 / (2 * pi) ; %% the radius is 10 mm
deltax2 = positionDataDeg2 * 60 / (2 * pi); %% the radius is 10 mm
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
%%%%%%%%%%% average position from bith encoders%%%%%%%%%%%%%%%%%%%%%%%%%%
averagedelta = (deltax - deltax2) / 2 ; %% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
%%%%%speed calculation%%%%%%%%
speedx = diff(deltax) * 2000;
speedx2 = diff(deltax2) * 2000;
speed = ((speedx - speedx2)/2);

Fs = 2000;
d_f = designfilt('lowpassiir','FilterOrder',3,'HalfPowerFrequency',200,'DesignMethod','butter','SampleRate',Fs);
speed = filtfilt(d_f,speed);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addAnalogInputChannel(s, 'Dev2', 0, 'Voltage'); %% DAQ channel 0 is reserved for the first encoder 
addAnalogInputChannel(s, 'Dev2', 1, 'Voltage'); %% DAQ channel 1 is reserved for the first encoder

 
%%%%%%standard deviation calculation%%%%
deltaz(1,:) = deltax;
deltaz(2,:) = deltax2;
deltastd =  std(deltaz, 0,1); 
deltastd =  deltastd';  %% standard deviation calculation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
%%%standard error calculation%%%%%%%%%%%%%%%%%%%%%%%
deltastderror = deltastd / sqrt(length(deltastd));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
figure; plot(timestamps, positionDataDeg);
xlabel('Time (s)');
ylabel('Angular position1 (rad.)');

figure; plot(timestamps, positionDataDeg2);
xlabel('Time (s)');
ylabel('Angular position2 (rad.)');

figure; plot(timestamps, deltax);
xlabel('Time (s)');
ylabel ('position1 (mm)');

figure; plot(timestamps, deltax2);
xlabel('Time (s)');
ylabel ('position2 (mm)');

figure; plot(timestamps, averagedelta);
xlabel('Time (s)');
ylabel ('finger displacement from the first position in mm');

figure; plot(timestamps(1:length(timestamps)-1), speed);
xlabel('Time (s)');
ylabel ('average speed from both encoders in mm / s');
axis([0 length(timestamps) -0.02 0.02]);

figure; plot(timestamps, forcel1);
xlabel('Time (s)');
ylabel ('Lateral force (N)');

figure; plot(timestamps, forcev1);
xlabel('Time (s)');
ylabel ('Vertical force1 (N)');

figure; plot(timestamps, forcev2 );
xlabel('Time (s)');
ylabel ('Vertical force2 (N)');

figure; plot( timestamps, averageforcev);
xlabel('Time (s)');
ylabel ('Average vertical force (N)');

figure; plot(timestamps, forcev);
xlabel('Time (s)');
ylabel('Coefficient of friction(-)')


figure; plot(timestamps, deltastd);
xlabel('Time (s)');
ylabel ('standard deviation of position readings in mm'); 

figure; plot(timestamps, deltastderror);
xlabel('Time (s)');
ylabel ('standard deviation error of position readings in mm');

%filename = 'C:User\Haptic\Mydocument\tactile_display\friction'
speed1 = [speed ; 0];
m = [timestamps deltax deltax2 averagedelta deltastderror speed1 forceh forcev1 forcev2 averageforcev];
csvwrite('Speed_Force.csv',m);
