% disp('demod_data')
% weekmap =containers.Map({-3,-1,1,3},{[0,0],[0,1],[1,1],[1,0]})
% x=[3,1;-1,-1;3,3];
% y=ones(size(x,1),size(x,2));
% disp(size(x,1))
% for i = 1:size(x,1)
%     for j = 1:size(x,2)
%         tmp=x(i,j);
%         result=weekmap(tmp);
%         y(i,j)=result(2);
% %         disp(result(1))
%     end
% endofdmdemod
% 
% disp(y)
x = 0 : 1 : 11; 
 %sim:
disp(size(x))
p1_sim=[0.1027, 0.0781, 0.0555, 0.0370 ,0.0225, 0.0123 ,0.0058, 0.0024 ,0.0008, 0.0002,0.0000 ,0.0000];
p2_sim=[0.1029, 0.077, 0.0555, 0.0369, 0.0225 ,0.0122, 0.0059, 0.0023, 0.0008, 0.0002 ,0.0000 ,0.000];
p3_sim=[0.1905 ,0.1637, 0.1381, 0.1131 ,0.0895 ,0.0676 ,0.0484, 0.0320, 0.0195, 0.0105, 0.0050, 0.0020];
p4_sim=[0.2383    ,0.2138   ,0.1901   , 0.1676  , 0.1463   ,0.1265   ,0.1074   ,0.0892 ,  0.0719   , 0.0554   , 0.0408  ,  0.0280];

%%bertool:
p1_theory=[0.0787, 0.0563, 0.0375, 0.0229 ,0.0125, 0.0060, 0.0024,7.7267e-04,1.9091e-04,3.3627e-05,3.8721e-06,2.6131e-07];
p2_theory=p1_theory;
p3_theory=[0.1410, 0.1190, 0.0977, 0.0775 ,0.0586, 0.0419, 0.0279 ,0.0170 ,0.0092 ,0.0044,0.0018,5.6471e-04];
p4_theory=[0.1998, 0.1779 ,0.1570, 0.1372 ,0.1185, 0.1008, 0.0838, 0.0676 ,0.0523, 0.0385,0.0265,0.0169];
type_ofdm=['BPSK','QPSK','16-QAM','64-QAM'];
semilogy(x, p4_sim, 'LineStyle','-', 'Marker','o', 'Color', 'y','MarkerSize', 11, 'LineWidth', 2);
hold on;
semilogy(x, p4_theory, 'LineStyle','-', 'Marker','o', 'Color', 'r','MarkerSize', 11, 'LineWidth', 2);
hold on;
% semilogy(x, p3, 'LineStyle','-', 'Marker','o', 'Color', 'b','MarkerSize', 11, 'LineWidth', 2);
% hold on;
% semilogy(x, p4, 'LineStyle','-', 'Marker','o', 'Color', 'k','MarkerSize', 11, 'LineWidth', 2);
% legend_label = ('BPSK','QPSK');
legend('64-QAM\_sim','64-QAM\_therory');
xlabel('$E_b / N_0\, \mathrm{(dB)}$','interpreter','latex', 'FontSize', 11);
ylabel('BER');
title('IEEE 802.11a OFDM Simulation');
grid on
% plot(x,p1,'LineWidth',2);
% hold on;
% plot(x,p2,'LineWidth',2);
%             I=[-3,-1,3,1];
%             Q=[-3,-1,3,1];
%             [x, y] = meshgrid(I, Q);
%             wf = reshape([complex(x(:), y(:))],1,[]); % you should fix it;
%             disp(wf);
% size(x)
% a=weekmap(x(:,:))
% a(1)
