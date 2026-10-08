% Plays and records signals, which are subsequently analyzed by looking at
% the spectrograms, and the power spectral densities.

%% Cleanup
clear; close all;

%% Initialize script parameters
% These global parameters are used as arguments in the function calls
% below.
fs = 16000; % Sampling frequency [Hz]
N = fs*2; % Discrete Fourier Transform (DFT) size [Samples] 
% Overlap length between subsequent frames in the
% short-time-Fourier-transform (STFT) used to plot the spectrogram [samples]
Noverlap = 0; 

%% Construct signals
sig = [sin(2*pi*100*(0:1/fs:2))]';
sig=sig+[sin(2*pi*200*(0:1/fs:2))]';
sig=sig+[sin(2*pi*500*(0:1/fs:2))]';
sig=sig+[sin(2*pi*1000*(0:1/fs:2))]';
sig=sig+[sin(2*pi*1500*(0:1/fs:2))]';
sig=sig+[sin(2*pi*2000*(0:1/fs:2))]';
sig=sig+[sin(2*pi*4000*(0:1/fs:2))]';
sig=sig+[sin(2*pi*6000*(0:1/fs:2))]';
sig=zeros(fs*5,1);
sig=awgn(sig,1)
%% Play and record.
% Call to initparams()
[simin,nbsecs] = initparams(sig,fs);
% Call to recplay.mdl to play simin and record simout
sim('recplay');
% Retrieve recorded output
out=simout.signals.values(:,1);

%% Compute and plot the spectrogram
% Input signal
figure; subplot(2,1,1)
spectrogram(sig, N/4, Noverlap/4, [], fs, 'xaxis');title('Input signal.')

% Output signal
subplot(2,1,2)
spectrogram(out,N/8,Noverlap,[],fs,'xaxis');
title('Output signal.')

%% Select input and output signals to compute PSD
% Ideally the output signal should be trimmed such that only periods where
% the signal is active are considered as the PSD assumes stationarity. 
% Else, the PSD will be biased due to the inclusion of silence.%
%in = ;
%out1 = ;

%% Compute and plot the power spectral density (PSD)...
% ...Using Welch's method 
PSD = pwelch(sig,N,Noverlap);
PSDout = pwelch(out,N,Noverlap);

% Plot results
figure;
% Input signal
figure; subplot(2,2,1)
plot(pow2db(PSD));
%xlabel('Frequency (kHz)');
%ylabel('Power/frequency (dB/Hz)')
%title('Input signal.')
% Output signal
subplot(2,2,2)
plot(pow2db(PSDout));
xlabel('Frequency (kHz)');
ylabel('Power/frequency (dB/Hz)')
title('Output signal.')
sgtitle('Power Spectral Density estimate')