% DMT-OFDM transmission scheme
%% Cleanup
clear; close all; clc;
Nq=4;
M=2^Nq;
N=2050;
Lcp=500;
L=300;
SNR=15;
BWusage=0.1;
%channel=randi([0,20],L,1)/20;
channel=[1; zeros(30,1)]
%channel=[sinc(-10:1/15:10-1/15)]';
load("channel_session4.mat","channel");
channelfreq=fft(channel,N/2-1);
[~,indexes]=sort(abs(channelfreq),'descend');
N_active_bins=floor(BWusage*size(indexes,1));
mask=[ones(N_active_bins,1);zeros(size(channelfreq,1)-N_active_bins,1)];
filtered_indexes=mask.*indexes;
ON_OFF_MASK=zeros(size(channelfreq,1),1);
for i=1:size(channelfreq,1)
    if filtered_indexes(i)~=0
        ON_OFF_MASK(filtered_indexes(i)) = 1;
    end
end
% Convert BMP image to bitstream
[bitStream, imageData, colorMap, imageSize, bitsPerPixel] = imagetobitstream('image.bmp');

% QAM modulation
qamStream = qam_mod(bitStream,M);
%scatterplot(qamStream)
% OFDM modulation
ofdmStream = ofdm_mod(qamStream,N,Lcp,ON_OFF_MASK);

% Channel
rxOfdmStream = fftfilt(channel,ofdmStream);
rxOfdmStream = awgn(rxOfdmStream,SNR,"measured");

% OFDM demodulation
[rxQamStream,old_qamstream] = ofdm_demod(rxOfdmStream,N,Lcp,numel(qamStream),channel,1,ON_OFF_MASK);
%figure;
%scatterplot(qamStream)
%figure;
%scatterplot(rxQamStream)
% QAM demodulation
rxBitStream = qam_demod(rxQamStream,M);

% Compute BER
berTransmission = ber(bitStream',rxBitStream');
figure;
plot(abs(channelfreq), 'b');
hold on;
plot(find(ON_OFF_MASK==1), ...
    abs(channelfreq(ON_OFF_MASK==1)), 'ro');

legend('All bins','Selected bins');
xlabel('Frequency bin');
ylabel('|H(k)|');
grid on;
% Construct image from bitstream
imageRx = bitstreamtoimage(rxBitStream, imageSize, bitsPerPixel);

% Plot images
figure;
subplot(2,1,1); colormap(colorMap); image(imageData); axis image; title('Original image'); drawnow;
subplot(2,1,2); colormap(colorMap); image(imageRx); axis image; title(['Received image']); drawnow;
fprintf('Active bins: %d / %d\n', ...
    sum(ON_OFF_MASK), length(ON_OFF_MASK));

fprintf('Average selected channel magnitude: %.4f\n', ...
    mean(abs(channelfreq(ON_OFF_MASK==1))));

fprintf('Average unselected channel magnitude: %.4f\n', ...
    mean(abs(channelfreq(ON_OFF_MASK==0))));