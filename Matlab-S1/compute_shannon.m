function Cchannel = compute_shannon(signal, noise, fs)


%% Remove DC component

%signal = signal - mean(signal);
%noise  = noise - mean(noise);

%% Number of frequency bins

K = floor(N/2);

%% DFT

S  = fft(signal, N);
Nf = fft(noise, N);

%% Power spectra

% Power in each DFT bin
Psignal_noise = abs(S).^2 / N;
Pnoise        = abs(Nf).^2 / N;

%% Keep positive-frequency bins

Psignal_noise = Psignal_noise(1:K);
Pnoise        = Pnoise(1:K);

%% Estimate signal power

% P(signal + noise) = P(signal) + P(noise)
% assuming signal and noise are uncorrelated.

Psignal = Psignal_noise - Pnoise;

% Prevent small numerical negative values
Psignal(Psignal < 0) = 0;

%% Frequency resolution

df = fs / N;

%% Shannon capacity

% C = sum df * log2(1 + Ps/Pn)

valid = Pnoise > 0;

Cchannel = df * sum( ...
    log2(1 + Psignal(valid) ./ Pnoise(valid)) ...
    );

end