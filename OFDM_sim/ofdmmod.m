% =========================================================================
% Title       : Modulation of Simulation for OFDM IEEE 802.11a
% File        : ofdmmod.m
% -------------------------------------------------------------------------
% Description :
%   This file prepares constellation symbols with the (Gray) mapping, and
%   generate the transmitted symbols
% -------------------------------------------------------------------------
% Revisions   :
%   Date                 Author            Description
%   24-Apr-2022    Jiaxin Lyu        file adapted from large sim-environment
% -------------------------------------------------------------------------
%   Author: Jiaxin Lyu (e-mail: ljx981120@sjtu.edu.cn)
% =========================================================================

function ch = ofdmmod(paradata, OFDM)
   % initialize the tx signal
    ch = zeros(OFDM.para, OFDM.Nd);
    % -- construct IEEE 802.11a-compliant mapping/constellation points
    % -- Gray mapping verision
    switch (OFDM.mod_lev)
        case 1 % BPSK
            OFDM.Constellations = [-1, 1];
        case 2 % 4-QAM / QPSK
            OFDM.Constellations = [-1- 1i, -1+1i, ...
                                   +1-1i, +1+1i];
        case 4 % 16-QAM
            I=[-3,-1,3,1];
            Q=[-3,-1,3,1];
            [x, y] = meshgrid(I, Q);%笛卡尔积 
            OFDM.Constellations = reshape([complex(x(:), y(:))],1,[]); % you should fix it; 复数和reshape拉平
        case 6 % 64-QAM
            I=[-7,-5,-1,-3,7,5,1,3];
            Q=[-7,-5,-1,-3,7,5,1,3];
            [x, y] = meshgrid(I, Q);
            OFDM.Constellations = reshape([complex(x(:), y(:))],1,[]); % you should fix it;
%             I=[1,2,3]
%             Q=[4,5,6]
%             [x, y] = meshgrid(I, Q);
%             [x(:), y(:)]
        otherwise
            error('Modulation order for 11a mapping not supported.')
    end

    % modulation / bit mapping to the constellation symbol
    for i = 1 : OFDM.para
        bit_idx = reshape(paradata(i, :), OFDM.mod_lev, OFDM.Nd).';
        dec_idx = bi2de(fliplr(bit_idx)) + 1;
        ch(i, :) = OFDM.Constellations(dec_idx);
    end


    return
