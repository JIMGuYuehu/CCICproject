clc
clear

MA = cell2mat(struct2cell(load('C:\Users\78653\Desktop\ccicproject\CCIC Statistics\monthlyMEANA.mat')));
AA = cell2mat(struct2cell(load('C:\Users\78653\Desktop\ccicproject\CCIC Statistics\A.mat')));

AMA = cell2mat(struct2cell(load('C:\Users\78653\Desktop\ccicproject\CCIC Statistics\AVTEMM.mat')));
AAA = cell2mat(struct2cell(load('C:\Users\78653\Desktop\ccicproject\CCIC Statistics\AVTEMD.mat')));

F = cell2mat(struct2cell(load('C:\Users\78653\Desktop\ccicproject\CCIC Statistics\monthlyMEANA.mat')));
AYA = cell2mat(struct2cell(load('C:\Users\78653\Desktop\ccicproject\CCIC Statistics\AVTEMY.mat')));

RX = cell2mat(struct2cell(load('C:\Users\78653\Desktop\ccicproject\CCIC Statistics\rx.mat')));
RY = cell2mat(struct2cell(load('C:\Users\78653\Desktop\ccicproject\CCIC Statistics\ry.mat')));

AYA(:,:,:) = (AYA(:,:,:)-32)/1.8;
% gapbetween2020and1961 = (AYA(:,:,60) - AYA(:,:,1))*0.01 ;
% gapbetween2020and1981 = (AYA(:,:,60) - AYA(:,:,21))*0.01 ;
gapbetween2020and2001 =(AYA(:,:,60) - AYA(:,:,41)) ;
% gapbetween2020and2011 = (AYA(:,:,60) - AYA(:,:,51) )*0.01;

ave = mean(mean(AYA,1),2);
ave2 = squeeze(ave);
plot(ave2);
% f1=figure
% contourf(gapbetween2020and1961)
% close(f1)
% f2=figure
% contourf(gapbetween2020and1981)
% close(f2)
% MAXTEM=max(AYA)
% MINTEM=min(AYA)
 for i = 1:60
 f=figure
 contourf(AYA(:,:,i))
 colorbar('southoutside')
 caxis([35 47])
 filename=['C:\Users\78653\Desktop\cm project\gif\',num2str(i),'.png'];
 print(gcf,'-dpng',filename)
 close(f)
 end

colorbar



