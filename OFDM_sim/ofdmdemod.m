% =========================================================================
% Title       : Demodulation of Simulation for OFDM IEEE 802.11a
% File        : ofdmdemod.m
% -------------------------------------------------------------------------
% Description :
%   This file demodulates the data for OFDM system
% -------------------------------------------------------------------------
% Revisions   :
%   Date                 Author            Description
%   24-Apr-2022    Jiaxin Lyu        file adapted from large sim-environment
% -------------------------------------------------------------------------
%   Author: Jiaxin Lyu (e-mail: ljx981120@sjtu.edu.cn)
% =========================================================================

function data_out = ofdmdemod(data_in, OFDM)
   % initialize the tx signal
    data_out = zeros(OFDM.para, OFDM.Nd * OFDM.mod_lev);
    switch (OFDM.mod_lev)
        case 1 % BPSK
            data_out = real(data_in) > 0;
        case 2 % 4-QAM / QPSK
%            disp(size(data_in));
           
           data_in_i = real(data_in);
           data_in_q = imag(data_in);
           disp(size(data_in_i));
           data_out(:, 1 : 2 : end - 1) = data_in_i > 0;
           data_out(:, 2 : 2 : end) = data_in_q > 0;

        case 4 % 16-QAM
            % Please determine data_out~
% %             x=[3,1;-1,-1;3,3];
% %             y=ones(size(x,1),size(x,2));
% %             disp(size(x,1))
% %             for i = 1:size(x,1)
% %                 for j = 1:size(x,2)
% %                     tmp=x(i,j);
% %                     result=weekmap(tmp);
% %                     y(i,j)=result(2);
            data_in_i = real(data_in);
            data_in_q = imag(data_in);
% %             qam_16 =containers.Map({-3,-1,1,3},{[0,0],[0,1],[1,1],[1,0]});
%             tmp_i_1=ones(size(data_in_i,1),size(data_in_i,2));
%             tmp_i_2=ones(size(data_in_i,1),size(data_in_i,2));
%             tmp_q_1=ones(size(data_in_q,1),size(data_in_q,2));
%             tmp_q_2=ones(size(data_in_q,1),size(data_in_q,2));
% %             disp(size(x,1))
%             for i = 1:size(data_in_i,1)
%                 for j = 1:size(data_in_i,2)
%                     tmp_i=data_in_i(i,j);
%                     tmp_q=data_in_q(i,j);
%                     result_i=qam_16(tmp_i);
%                     result_q=qam_16(tmp_q);
%                     tmp_i_1(i,j)=result_i(1);
%                     tmp_i_2(i,j)=result_i(2);
%                     tmp_q_1(i,j)=result_q(1);
%                     tmp_q_2(i,j)=result_q(2);
%                 end
%             end
%             data_out(:, 1 : 4 : end - 3) = tmp_i_1;
%             data_out(:, 2 : 4 : end - 2) = tmp_i_2;
%             data_out(:, 3 : 4 : end - 1) = tmp_q_1;
%             data_out(:, 4 : 4 : end) = tmp_q_2;
            data_out(:, 1 : 4 : end - 3) = (data_in_i>=0&data_in_i<=4);%根据编码表编写即可
            data_out(:, 2 : 4 : end - 2) = (data_in_i>=-2&data_in_i<=2);
            data_out(:, 3 : 4 : end - 1) = (data_in_q>=0&data_in_q<=4);
            data_out(:, 4 : 4 : end) = (data_in_q>=-2&data_in_q<=2);
        case 6 % 64-QAM
            % Please determine data_out~
            data_in_i = real(data_in);
            data_in_q = imag(data_in);
            data_out(:, 1 : 6 : end - 5) = (data_in_i>0&data_in_i<=8);
            data_out(:, 2 : 6 : end - 4) = (data_in_i>=-4&data_in_i<=4);
            data_out(:, 3 : 6 : end - 3) = (data_in_i>=-6&data_in_i<-2)|(data_in_i>=2&data_in_i<6);
            data_out(:, 4 : 6 : end - 2) =  (data_in_q>0&data_in_q<=8);
            data_out(:, 5 : 6 : end - 1) = (data_in_q>=-4&data_in_q<=4);
            data_out(:, 6 : 6 : end) = (data_in_q>=-6&data_in_q<-2)|(data_in_q>=2&data_in_q<6);
        otherwise
            error('Modulation order for 11a mapping not supported.')
    end

    return

       function result = qam_16(x)
        if(x>=-4&&x<-2)
            result=[0,0];
        elseif(x>=-2&&x<0)
            result=[0,1];
        elseif(x>=0&&x<2)
            result=[1,1];
        elseif(x>=2&&x<=4)%这里是都是闭区间？
            result=[1,0];
        else
            result=[0,0];
        end
        return;
