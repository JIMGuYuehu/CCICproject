clc
clear

%founction KK=niheCAT(a,b,c,CAT)%噪音感觉加不加无所谓

%for i = 1:length(CAT)
    
%    KK(i) = e^(a + b*(i-1)+ c*(CAT(i)))

%end

%founction KK2=niheCDD(a2,b2,c2，CDD)


%for i = 1:length(CAT)
    
%    KK2(i) = e^(a2 + b2*(i-1)+ c2*(CDD(i)))

%end




%founction main
MA = cell2mat(struct2cell(load('C:\Users\78653\Desktop\ccicproject\CCIC Statistics\monthlyMEANA.mat')));
AA = cell2mat(struct2cell(load('C:\Users\78653\Desktop\ccicproject\CCIC Statistics\A.mat')));
%"rr","tg","tn","tx" 第一行降水 第二行平均温度 第三行最小 第四行最大

AA(2,:) = AA(2,:)*0.1;
AA(3:4,:) = AA(3:4,:)*0.01;


startyear = 1981;
endyear = 2020;
yeargap = endyear - startyear +1;
startdate = datenum(join([string(startyear),'-1-1']));
enddate = datenum(join([string(endyear),'-12-31']));

startday = '-5-1';
endday = '-8-31';


dn = linspace(startdate,enddate,length(AA(2,:)));

dn2 = linspace(startdate,enddate,length(MA(2,:)));
%plot(dn,AA(2,:))
%dateaxis('x',1)
%plot(dn2,MA(2,:))
%%%%%%%%%%%%dateaxis('x',12) 这个是年-月显示，太乱了
%datetick('x','yyyy')


%定义累积指数
CAT = zeros(1,yeargap);
for i = 1:yeargap
    for j = (datenum(join([string(startyear+i-1),startday]))-startdate+1) :  (datenum(join([string(startyear-1+i),endday]))-startdate+1)

        CAT(i) = CAT(i)+AA(2,j);

    end
end
CDD= zeros(1,yeargap);
for i = 1:yeargap
    for j = (datenum(join([string(startyear+i-1),startday]))-startdate+1) :  (datenum(join([string(startyear+i-1),endday]))-startdate+1)
        if (AA(1,j)>18)
        CDD(i) = CDD(i)+AA(2,j)-18;
        end

    end
end


dataid = fopen('C:\Users\78653\Desktop\ccicproject\CCIC Statistics\Romania.csv');
C = textscan(dataid,'%s%s%d%s%d%s%d%s%d%d%s%d%s%s%f%f%f','Delimiter',',','HeaderLines',1);
%YY = cell2mat(C(12));%ha好像是每公顷产量，看这玩意更靠谱些
%YY = YY(1:60);
YY = cell2mat(C(17));
YY = YY(startyear-1960:60);
CDD = CDD';
CAT = CAT';
years = linspace(1,length(YY),length(YY))';
ft = fittype('exp(a+b*years+c*CDD)','independent',{'years','CDD'},'dependent','YY');
curve = fit([years,CDD],YY,ft);
%plot(curve,[years,CDD],YY)
RESULT = exp(curve.a+(curve.b)*years+(curve.c)*CDD);
plot(YY)
hold on 
plot(RESULT)


