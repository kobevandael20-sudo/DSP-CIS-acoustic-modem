function Cchannel = compute_shannon(signal, noise, fs,N )
signal = signal - mean(signal);
noise  = noise - mean(noise);
K = floor(N/2);
S  = fft(signal, N);
Nf = fft(noise, N);
Psignal_noise = abs(S).^2 / N;
Pnoise        = abs(Nf).^2 / N;
Psignal_noise = Psignal_noise(1:K);
Pnoise        = Pnoise(1:K);
Psignal = Psignal_noise - Pnoise;
Psignal(Psignal < 0) = 0;
valid = Pnoise > 0;
Cchannel = fs/N *sum(log2(1 + (Psignal(valid) ./ Pnoise(valid))),1);

end