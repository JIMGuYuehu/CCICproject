clc
clear
RX = cell2mat(struct2cell(load('C:\Users\78653\Desktop\ccicproject\CCIC Statistics\rx.mat')));
RY = cell2mat(struct2cell(load('C:\Users\78653\Desktop\ccicproject\CCIC Statistics\ry.mat')));
% % % % % 
% % % % % cd  'E:\matlab\toolbox\nctoolbox-1.1.3'
% % % % % 
% % % % % setup_nctoolbox
% % % % %data = ncdataset(filename)