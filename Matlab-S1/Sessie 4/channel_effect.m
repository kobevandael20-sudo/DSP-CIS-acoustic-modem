%% Cleanup
clear; close all; clc;

%% Parameters
Nq=6;
M = 2^Nq; % QAM constellation size
channel = [0,1,0]; % Impulse response of channel
N =1202 ; % Total number of symbols in a single OFDM frame, i.e., the DFT size
Lcp=50;
%% Channel effect experiment
% bit stream 
%bitSeq = randi([0,1],Nq,1); % Generate the bit sequence corresponding to 1 QAM symbol

%bitStream = repmat(bitSeq,N/2-1,1); % Repeat this bit sequence to fill 1 OFDM frame
bitStream = randi([0,1],Nq*(N/2-1),1); % Generate the bit sequence corresponding to 1 QAM symbol

% QAM modulation
qamStream = qam_mod(bitStream',M); % Should be of length N/2-1X1. Each symbol should be the same

% QAM constellation visualization
scatterplot(qamStream); % 
% OFDM modulation
ofdmStream = ofdm_mod(qamStream,N,Lcp); % Should be of length N+LcpX1
% Channel
rxOfdmStream = fftfilt(channel,ofdmStream);
rxOfdmStream = awgn(rxOfdmStream,2500,"measured");

% OFDM demodulation
rxQamStream = ofdm_demod(rxOfdmStream,N,Lcp);

% QAM constellation visualization
scatterplot(rxQamStream);

% QAM demodulation
rxBitStream = qam_demod(rxQamStream,M);

% Compute BER
berTransmission = ber(rxBitStream',bitStream');
