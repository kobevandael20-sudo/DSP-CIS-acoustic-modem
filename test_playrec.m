% Tests the functionality of initparams() and recplay.mdl

%% Generate a sinewave
fs = 16000; % Sampling rate [Hz]
f0 = 844*2; % Frequency of sinewave [Hz]
t_max = 2; % Length of the signal [s]

% Generate sinewave
sinewave = [sin(2*pi*f0*(0:1/fs:t_max))]';
% Call to initparams()
[simin,nbsecs] = initparams(sinewave,fs);

%% Play and record signal
% Call to recplay.mdl to play simin and record simout
sim('recplay'); 

% Retrieve recorded output
out=simout.signals.values; 

%% Playback
% Play the sound using sound() or soundsc()
soundsc(out,fs)