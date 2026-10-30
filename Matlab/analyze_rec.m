% Plays and records signals, which are subsequently analyzed by looking at
% the spectrograms, and the power spectral densities.

%% Cleanup
clear; close all;

%% Initialize script parameters
% These global parameters are used as arguments in the function calls
% below.
fs = 16000; % Sampling frequency [Hz]
%fs=44100;
N = fs*2; % Discrete Fourier Transform (DFT) size [Samples] 
% Overlap length between subsequent frames in the
% short-time-Fourier-transform (STFT) used to plot the spectrogram [samples]
Noverlap = fs; 

%% Construct signals
sig = [sin(2*pi*100*(0:1/fs:2))]';
sig=sig+[sin(2*pi*200*(0:1/fs:2))]';
sig=sig+[sin(2*pi*500*(0:1/fs:2))]';
sig=sig+[sin(2*pi*1000*(0:1/fs:2))]';
sig=sig+[sin(2*pi*1500*(0:1/fs:2))]';
sig=sig+[sin(2*pi*2000*(0:1/fs:2))]';
sig=sig+[sin(2*pi*4000*(0:1/fs:2))]';
sig=sig+[sin(2*pi*6000*(0:1/fs:2))]';
sig=sig(1:fs*2);
%% Play and record.
% Call to initparams()
[simin,nbsecs] = initparams(sig,fs);
% Call to recplay.mdl to play simin and record simout
sim('recplay');% Retrieve recorded output
out=simout.signals.values(:,1);
out_cut=out(6.125*fs:(8.125*fs-1));%16000Hz
%out_cut=out(1.625*fs:(3.625*fs-1)); %44100Hz

%out geeft om een of andere reden een signaal van ongeveer 13s, waarbij het
%effectieve signaal zich ongeveer tussen 6.125 en 8.125 zit. Voor 44100Hz
%is dat 1.625 tot 3.625

%% Compute and plot the spectrogram
% Input signal
figure; subplot(3,1,1)
spectrogram(sig, N/2, Noverlap/4, [], fs, 'xaxis');title('Input signal.')

% Output signal
subplot(3,1,2)
spectrogram(out_cut,N/2,Noverlap/4,[],fs,'xaxis');
title('Output signal.')
load('recorded_noise16k.mat','noise'); %ik heb twee ruisfragmenten opgenomen en opgeslagen, voor beide frequenties
%load('recorded_noise44k.mat','noise');
noise=noise(1:fs*2);
subplot(3,1,3)
spectrogram(noise,N/2,Noverlap/4,[],fs,'xaxis');
title('Noise.')

%% Compute and plot the power spectral density (PSD)...
% ...Using Welch's method 
PSD = pwelch(sig,N,Noverlap);
PSDout = pwelch(out,N,Noverlap);
figure;
figure; subplot(2,2,1)
plot(pow2db(PSD));
subplot(2,2,2)
plot(pow2db(PSDout));
xlabel('Frequency (kHz)');
ylabel('Power/frequency (dB/Hz)')
title('Output signal.')
sgtitle('Power Spectral Density estimate')

Cchannel=compute_shannon(sig,noise,fs,N); %176,4482 voor 16khz 173,393 voor 44.1kHz. Heel erg laag, weet niet of dit klopt
