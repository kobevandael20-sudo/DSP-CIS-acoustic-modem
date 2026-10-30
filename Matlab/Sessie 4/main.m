% DMT-OFDM transmission scheme
%% Cleanup
clear; close all; clc;
Nq=4;
M=2^Nq;
N=2050;
Lcp=500;
L=300;
SNR=15;
channel=randi([0,20],L,1)/20;
%channel=[1; zeros(30,1)]
load("channel_session4.mat","channel");
% Convert BMP image to bitstream
[bitStream, imageData, colorMap, imageSize, bitsPerPixel] = imagetobitstream('image.bmp');

% QAM modulation
qamStream = qam_mod(bitStream,M);
qamStream=awgn(qamStream,SNR,"measured");
%scatterplot(qamStream)
% OFDM modulation
ofdmStream = ofdm_mod(qamStream,N,Lcp);

% Channel
rxOfdmStream = fftfilt(channel,ofdmStream);

% OFDM demodulation
[rxQamStream,old_qamstream] = ofdm_demod(rxOfdmStream,N,Lcp,channel,numel(qamStream));
%figure;
%scatterplot(qamStream)
%figure;
%scatterplot(rxQamStream)
% QAM demodulation
rxBitStream = qam_demod(rxQamStream,M);

% Compute BER
berTransmission = ber(bitStream',rxBitStream');

% Construct image from bitstream
imageRx = bitstreamtoimage(rxBitStream, imageSize, bitsPerPixel);

% Plot images
figure;
subplot(2,1,1); colormap(colorMap); image(imageData); axis image; title('Original image'); drawnow;
subplot(2,1,2); colormap(colorMap); image(imageRx); axis image; title(['Received image']); drawnow;
