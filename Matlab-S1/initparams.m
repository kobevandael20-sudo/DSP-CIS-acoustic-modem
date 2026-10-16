function [ simin,nbsecs ] = initparams( toplay, fs, varargin )
% Creates simin from toplay that will be supplied to recplay.mdl
%
% INPUT:
% toplay     T1x1    Signal supplied as a column vector of T1 samples.
% fs         1x1     Sampling frequency [Hz].
% varargin:
% sync_pulse T2x1    Synchronization pulse (you can ignore this until
%                    exercise 6.1.1)
%
% OUTPUT:
% simin      T2x2   Signal to be supplied to recplay.mdl consisting of a
%                   signal to be played in column 1 and zeros in column 2.
% nbsecs     1x1    Length of simin [s].

%% Extract inputs
if nargin == 3
    sync_pulse = varargin{1};
end

%% Asserting assumption of toplay being a column vector
[r,c] = size(toplay);
assert(c==1,'toplay is not a column vector');

%% Add a synchronisation pulse
% you can ignore this until exercise 6.1.1
if nargin == 3
    % Append the synchronisation pulse and zeros at least equal to the length
    % of the IR before toplay
    toplay;
end

%% Append silence to toplay
% Insert 2s of silence at the beginning of toplay and 1s of silcence at the end of toplay
toplay = [zeros(2*fs,1);toplay;zeros(fs,1)];

% Scale toplay to be between [-1,1] -
% -> You can leave this commented until exercise 1.2.6
toplay =toplay/max(toplay);

%% Create simin
% Two column matrix: one column is toplay, one column is silence
simin = [toplay zeros(size(toplay,1),1)];

%% Calculate number of seconds in simin
nbsecs = (size(toplay,1)/fs);

%% Asserting correctness of the dimensions of simin
% nbsecs should be a scalar
assert(max(size(nbsecs))==1,'nbsecs is the wrong dimension');
% simin should be at least the length of toplay and 3s of silence 
assert(length(simin(1,:))==2 || length(simin) >= (r+3*fs),'simin has the wrong dimensions');
end