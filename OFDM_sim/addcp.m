% =========================================================================
% Title       : Adding cyclic prefix of Simulation for OFDM IEEE 802.11a
% File        : addcp.m
% -------------------------------------------------------------------------
% Description :
%   This file adds the cyclic prefix for OFDM symbols
% -------------------------------------------------------------------------
% Revisions   :
%   Date                 Author            Description
%   24-Apr-2022    Jiaxin Lyu        file adapted from large sim-environment
% -------------------------------------------------------------------------
%   Author: Jiaxin Lyu (e-mail: ljx981120@sjtu.edu.cn)
% =========================================================================

function data_out = addcp(data_in, OFDM)

%****************** variables *************************
% data_in    : Input ch data
% data_out  : Output ch data
% fftlen   : Length of FFT (points)
% len_of_gi    : Length of guard interval (points)
% *****************************************************

% add the trailing data of data_in as a cycle prefix
data_out = [data_in(OFDM.fftlen - OFDM.len_of_gi + 1 : OFDM.fftlen, :); data_in];

end

%******************** end of file ***************************

