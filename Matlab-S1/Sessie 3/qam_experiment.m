%% Cleanup
clear; clc; close all;

%% Parameters
L = 12000; % Scalar length of binary sequence [samples]
SNRs = [1,4,8,120]; % List of SNR values to consider [dB]
N = [2,3,4,6]; % List of number of bits per QAM symbol to consider
%% Calculate BER for each constellation-SNR combination.
BERs = zeros(size(N,2),size(SNRs,2)); % Placeholder for BERs
avgPower=zeros(size(N));
for n= 1:size(N,2)% Loop across values of N
    M = 2^N(n); % QAM constellation size
    % Generate a pseudo random binary sequence of a user defined length.
    bit_seq = randi([0,1],1,L);

    % Modulate bit sequence.
    QAM_seq = qam_mod(bit_seq,M);
    %scatterplot(QAM_seq)
    title(sprintf('%s QAM %d',n))
    avgPower(n)=mean(abs(QAM_seq).^2);

    for SNRidx = 1:size(SNRs,2) % Loop across SNR values
        % Initialize simulation parameters.

        SNR = SNRs(SNRidx); % SNR
        

        
        % Add white Gaussian noise.
        req_QAM_seq  = awgn(QAM_seq,SNR,"measured");        
        
        % Demodulate QAM sequence.
        rec_bit_seq = qam_demod(req_QAM_seq,M);
        scatterplot(req_QAM_seq)
        % Calculate BER.
        BERs(n,SNRidx) = ber(rec_bit_seq',bit_seq);
    end
end

% Plot results.
semilogy(SNRs,BERs);
%ylabel();
%xlabel();  