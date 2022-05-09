% Simulation program to realize OFDM transmission system

% =========================================================================
% Title       : Simulation platform of OFDM IEEE 802.11a
% File        : ofdm.m
% -------------------------------------------------------------------------
% Description :
%   This file is used as teaching software for the 
%   Digital Communication and VLSI Design course
% -------------------------------------------------------------------------
% Revisions   :
%   Date                 Author            Description
%   24-Apr-2022    Jiaxin Lyu        file adapted from large sim-environment
% -------------------------------------------------------------------------
%   Author: Jiaxin Lyu (e-mail: ljx981120@sjtu.edu.cn)
% =========================================================================

clear;
clc;
addpath(genpath(pwd)); % prepends all folder to the current matlabpath.
tic;
%% -- system configuration
OFDM.para = 48;                                                                % Number of parallel channel to transmit (points)
OFDM.nr_of_pilot = 4;                                                        % Number of pilot symbols in one OFDM symbol
OFDM.nr_of_emptysymb = 12;                                           % Number of empty symbols in one OFDM symbol
OFDM.fftlen = 64;                                                               % FFT length
OFDM.Nd = 6;                                                                     % Number of information OFDM symbol for one loop

OFDM.mod_lev = 6;                                                            % Modulation level : (1) BPSK; (2) QPSK; (4) 16-QAM; (6) 64-QAM
OFDM.mod_order = 2^(OFDM.mod_lev);                          % Modulation order : (2) BPSK; (4) QPSK; (16) 16-QAM; (64) 64-QAM
OFDM.mod_type = '64-QAM';                                            % Modulation type : BPSK/QPSK/16-QAM/64-QAM

OFDM.symb_rate = 250000;                                                % OFDM symbol rate (250 ksyombol/s)
OFDM.ToneMap = [2:7, 9:21, 23:27, 39:43, 45:57, 59:64];                        % Location of data subcarriers for OFDM mapping
OFDM.subcarrier_order = [25:30, 31:43, 44:48, 1:5, 6:18, 19:24];             % Order of data subcarriers
OFDM.bit_rate = OFDM.symb_rate * OFDM.mod_lev;      % Bit rate per carrier
OFDM.len_of_gi = 16;                                                        % Length of guard interval (points)
OFDM.nr_of_pbits = OFDM.para * OFDM.Nd * OFDM.mod_lev;                 % Number of bits per loop
EbN0_dB_list = 0 : 1 : 11;                                                 % Eb/N0 in a dB scale
EbN0_linear_list = 10.^(EbN0_dB_list ./ 10);                      % Eb/N0 in a linear scale

BER_res = zeros(1, length(EbN0_dB_list));                      % store the BER results

%************************** main loop part **************************

nr_of_loop = 10000;  % Number of simulation loops

%% --start simulation！
fprintf('Simulation starts at %s: \n', datestr(now));
fprintf('Simulation introduction: an uncoded OFDM system under IEEE 802.11a, modulated by %s \n', OFDM.mod_type);
fprintf('Number of simulation loop = %d, Number of bits per packet = %d, Total bits = %d \n', nr_of_loop, OFDM.nr_of_pbits, nr_of_loop * OFDM.nr_of_pbits);
% --begin SNR loop
for cnt = 1 : length(EbN0_dB_list)
        fprintf('Begin the simulation of Eb/N0 = %d dB;\n', EbN0_dB_list(cnt));
        nr_of_errorbits = 0;    % Number of error bits
        nr_of_totalbits = 0;    % Number of total bits
        %% transmitter 
        for iii = 1 : nr_of_loop % --begin OFDM loop
                %% data generation
                seridata = rand(1, OFDM.nr_of_pbits) > 0.5;
           
                %% serial to parallel convertion
                disp('size(seridata)')
                disp(size(seridata))
                paradata = reshape(seridata, OFDM.para, OFDM.Nd * OFDM.mod_lev);
                disp(size(paradata))
                
                %% modulation
                ch = ofdmmod(paradata, OFDM);
                disp(size(ch))
                
                %% pilot symbol Insertion and OFDM symbol mapping ( input data switching for IFFT)
                ch1 = ofdmmap(ch,  OFDM);

                %%  IFFT(IDFT)
                ch2 = ifft(ch1);

                %% Guard interval insertion
                ch3 = addcp(ch2, OFDM);

                %%  parallel to serial convertion
                ch3 = reshape(ch3, 1, (OFDM.fftlen + OFDM.len_of_gi) * OFDM.Nd);

                %% Noise power calculation by the definition of Eb/N0
                Es = sum(abs(ch3).^2) / (OFDM.Nd * OFDM.para); % Es is the average symbol power
                N0 = (Es / OFDM.mod_lev) / EbN0_linear_list(cnt);  % use Eb/N0 to calculate N0, Eb = Es / mod_lev
                
                %% AWGN addition
                ch4 = comb(ch3, N0);
                
                %% serial to parallel convertion
                ch4 = reshape(ch4, (OFDM.fftlen + OFDM.len_of_gi), OFDM.Nd);
                
                %% Guard interval removal
                ch5 = removecp(ch4, OFDM.len_of_gi);
                
                %% FFT(DFT)
                ch6 = fft(ch5);
                
                %%  pilot data removal and  OFDM symbol demapping
                ch7 = ofdmdemap(ch6, OFDM);

                %%  demoduration
                demod_data = ofdmdemod(ch7, OFDM);
%                 disp('demod_data')
%                 disp(demod_data)
%                 disp(size(demod_data))
                
                %%  parallel to serial convertion and obtain the estimate of source bits
                seridata_hat = reshape(demod_data, 1, OFDM.nr_of_pbits);
                
                %% obtain the number of  bit error by comparison
                noe = sum(seridata_hat ~= seridata);
                
                % for calculating BER        
                nr_of_errorbits = nr_of_errorbits + noe;
                nr_of_totalbits = nr_of_totalbits + OFDM.nr_of_pbits;
                
        end % end OFDM loop
        % calculating BER     
        BER_res(cnt) = nr_of_errorbits / nr_of_totalbits;
end % end SNR loop

%% --Simulation is over! Output result
fprintf('Simulation end. The BER of the system is: \n');
disp(BER_res);
% plot it~
semilogy(EbN0_dB_list, BER_res, 'LineStyle','-', 'Marker','o', 'Color', [0 0 0],'MarkerSize', 11, 'LineWidth', 2);
legend_label = [OFDM.mod_type, ' OFDM'];
legend(legend_label)
xlabel('$E_b / N_0\, \mathrm{(dB)}$','interpreter','latex', 'FontSize', 11);
ylabel('BER');
title('IEEE 802.11a OFDM Simulation');
grid on

%end of file *
