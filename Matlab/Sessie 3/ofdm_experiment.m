%% Cleanup
clear; clc; close all;

%% Parameters
SNR = 1; % Signal-to-noise ratio [dB]
M = 16; % QAM constellation size
N = 1002; % Number of symbols per OFDM frame, i.e., the DFT size
L = 12000; % Binary sequence length [samples]
Lcp = 50; % Cyclic prefix length [Samples] (you can ignore this until exercise 3.2.4)
fs=16000;
%% OFDM experiment
% Generate a pseudo random binary sequence of a user defined length.
bit_seq = randi([0,1],L,1);

% Modulate bit sequence.
QAM_seq = qammod(bit_seq,M,'InputType','bit');

% Modulate QAM sequence using OFDM.
OFDM_seq = ofdm_mod(QAM_seq,N,Lcp);

% Add white Gaussian noise.
rec_OFDM_seq  = awgn(OFDM_seq,SNR,"measured");

% Demodulate OFDM sequence.
rec_QAM_seq = ofdm_demod(rec_OFDM_seq,N,Lcp);
rec_QAM_seq=reshape(rec_QAM_seq,size(rec_QAM_seq,1)*size(rec_QAM_seq,2),1);
% Demodulate QAM sequence.
rec_bit_seq = qamdemod(rec_QAM_seq,M,"OutputType","bit");

% Calculate BER.
BER = ber(rec_bit_seq',bit_seq');
datarate=log2(M)*(N/2-1)*fs/(N+L);