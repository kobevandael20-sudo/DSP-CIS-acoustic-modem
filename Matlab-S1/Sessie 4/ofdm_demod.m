function [ data_seq,data_seq_old, CHANNELS ] = ofdm_demod( OFDM_seq, N, Lcp, channel,varargin )
% OFDM demodulation
%
% INPUT:
% OFDM_seq      T1X1            Time domain OFDM sequence of length T1 samples.
% N             1X1             Total number of symbols in a single OFDM frame.
% Lcp           1X1             Cyclic prefix length [samples] (you can ignore this until exercise 3.2.4)
% varargin  
% For Session 3 
% empty
%
% For Session 4
% streamLength  1X1             Length of QAM sequence after call to qammod [samples].
% channel       T2X1            Impulse response of channel.
% equalization  1X1             If 1 channel equalization is performed, if 0 no
%                               channel equalization is performed.
%
% For Session 5.1
% streamLength  1X1             Length of QAM sequence after call to qammod [samples].
% channel       T2X1            Impulse response of channel.
% equalization  1X1             If 1 channel equalization is performed, if 0 no
%                               channel equalization is performed.
% ON_OFF_mask   (N/2-1)X1       Mask denoting the bins to use in range (X_1...X_(N/2-1)) with a 1 denothing
%                               that a bin should be used and a 0 denoting that a bin should not be used.
%                               (you can ignore this until exercise 5.1)
% equalization  1X1             If 1 channel equalization is performed, if 0 no
%                               channel equalization is performed.
% For session 5.2 and Session 6
% streamLength  1X1             Length of QAM sequence after call to qammod [samples].
% ON_OFF_mask   (N/2-1)X1       Mask denoting the bins to use in range (X_1...X_(N/2-1)) with a 1 denothing
%                               that a bin should be used and a 0 denoting that a bin should not be used.
%                               (you can ignore this until exercise 6.1.1)
% trainblock    T3X1            Training block of T3 QAM symbols (you can
%                               ignore this until exercise 6.1.1)
%
% For Session 7
% streamLength  1X1             Length of QAM sequence after call to qammod [samples].
% ON_OFF_mask   (N/2-1)X1       Mask denoting the bins to use in range (X_1...X_(N/2-1)) with a 1 denothing
%                               that a bin should be used and a 0 denoting that a bin should not be used.
%                               (you can ignore this until exercise 5.1)
% trainblock    T3X1            Training block of T3 QAM symbols (you can
%                               ignore this until exercise 7.1.1)
% Lt            1X1             Number of training frames (you can ignore this
%                               until exercise 7.1.1)
% Ld            1X1             Number of data frames (you can ignore this
%                               until exercise 7.1.1)
% nbPackets     1X1             Number of packets, where one packet consist of
%                               a training and data frame. (you can ignore 
%                               this until exercise 7.1.1)
% OUTPUT:
% data_seq      T4X1            QAM sequence of T3 symbols.
% CHANNELS      N/2-1XP         Frequency domain estimated channel with P either nbPackets or 1. (
%                               you can ignore this until exercise 5.2.4)      

%% Extract input arguments
if nargin == 6 && (islogical(varargin{3}) || isscalar(varargin{3})) % Session 3 and Session 4
    streamLength = varargin{1};
    channel = varargin{2};
    equalization = varargin{3};
elseif nargin == 7 % Session 5.1
    streamLength = varargin{1};
    channel = varargin{2};
    equalization = varargin{3};    
    ON_OFF_mask = varargin{4};    
elseif nargin == 6 % Session 5.2 and Session 6
    streamLength = varargin{1};
    ON_OFF_mask = varargin{2};
    trainblock = varargin{3};
elseif nargin == 9 % Session 7
    streamLength = varargin{1};
    ON_OFF_mask = varargin{2};
    trainblock = varargin{3};
    Lt = varargin{4};
    Ld = varargin{5};
    nbPackets = varargin{6};
end


%% Perform OFDM demodulation
% Reshape the received OFDM sequence (serial to parallel conversion)
OFDM_matrix = reshape(OFDM_seq,N+Lcp,[]);

% Remove the cyclic prefix (you can ignore this until exercise 3.2.4)
OFDM_matrix = OFDM_matrix(Lcp+1:end,:);

% Apply fft operation
QAM_matrix = fft(OFDM_matrix);
% Remove the redundant parts of QAM_matrix
QAM_matrix = QAM_matrix(2:N/2,1:size(QAM_matrix,2));
QAM_matrix_old=QAM_matrix;
% Apply channel equalisation (you can ignore this until exercise 4.2.3)
CHANNELS = 0;
channel_freq_full = fft(channel, N);
channel_freq = channel_freq_full(2:N/2);
QAM_matrix = QAM_matrix./channel_freq;

% Apply on-off mask (you can ignore this until exercise 5.1)
% QAM_matrix = ;

% Supply streamLength number of symbols (you can ignore this until exercise 4.2)
data_seq_old=reshape(QAM_matrix_old,[],1);
data_seq = reshape(QAM_matrix,[],1);

end