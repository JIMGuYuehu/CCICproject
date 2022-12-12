clear
clc
cd 'C:\Users\78653\Desktop\ccicproject\CCIC Statistics';
files=dir('*.nc');
m=size(files,1)-1; 
World = shaperead('world map china line.shp'); %world map
Rx = [World(152).X];Ry = [World(152).Y]; %Romanian border data

variables=["rr","tg","tn","tx"]; %Four variables in four NC files to be extracted
% find romanian
source='C:\Users\78653\Desktop\ccicproject\CCIC Statistics\TN.nc';
lon=ncread(source,'longitude');
lat=ncread(source,'latitude');
time=ncread(source,'time');
[~,JIon] = min(abs(lon-min(Rx)));
[~,GIon] = min(abs(lon-max(Rx)));
[~,JIat] = min(abs(lat-min(Ry)));
[~,GIat] = min(abs(lat-max(Ry)));
lon=lon(JIon:GIon);            %Select a rectangle slightly larger than Romania
lat=lat(JIat:GIat);
time=double(time);
format = 'dd mm yyyy';
cc = datenum('1950-1-1') + time;
dstr = datestr(datenum('1950-1-1') + time,format);
startyear=1961;
endyear = 2020;
yeargap = endyear - startyear +1;
startdate =  find(cc==datenum(join([string(startyear),'-1-1'])));
enddate =  find(cc==datenum(join([string(endyear),'-12-31'])));
clear cc
months=double(string(dstr(startdate:enddate,4:5)));
year=double(string(dstr(startdate:enddate,7:10)));

%Extract variable data in a rectangle
for i=1:m
    em=variables(i);
    em=string(em);
    cfiles=files(i);
    source=string(cfiles.name);
    fid=netcdf.open(source);
    vid=netcdf.inqVarID(fid,em);
startLoc = [JIon JIat startdate]; 
count  = [length(lon) length(lat) (enddate - startdate + 1 )];  %The duration is 1961-2020
stride=[1 1 1];
data=netcdf.getVar(fid,vid,startLoc,count,stride,'int16');
data=squeeze(data);
[ind1,ind2] = find (data == -9999);
data(ind1,ind2) = nan;
    F(i,:,:,:)=data;
    if(i==2)
        gg=data*0.01;
    end

end

%Judge whether coordinates of data is located within the polygonal area enclosed by the Romanian border. If not, it is nan
for i=1:length(lat)
    for j=1:length(lon)
        [in,on] = inpolygon(lon(j),lat(i),Rx,Ry);
        if in~=1
F(:,j,i,:)=nan;
gg(:,j,i,:) = nan;
        end
    end
end



%Calculate the average value of each month, ignoring the nan value
s=0;
for i=1:yeargap
            loc1=find(year==1960+i);
        M=months(loc1);
    for j=1:12
        loc2=find(M==j);        
        loc2=loc2+s;
        for n=1:4
        A(n,j+i*12-12)=nanmean(F(n,:,:,loc2),'all');
        end
    end
            [sloc1,~]=size(loc1);
        s=sloc1+s;
end

for i = 1 : (enddate - startdate + 1)
    for n = 1:m
        CC(n,i) = mean(F(n,:,:,i),'all');
    end
end

s=0;
weui = zeros(size(data(:,:,1)),'like',data(:,:,1));
for i=1:yeargap
    weui = 0
    for j=1:12
        loc1=find(year==1960+i);
        M=months(loc1);
        loc2=find(M==j);        
        loc2=loc2+s;
        ggg(:,:,j+i*12-12)=nanmean(F(2,:,:,loc2),4);
        [sloc1,~]=size(loc1);
        s=size(sloc1)+s;
        weui = weui + ggg(:,:,j+i*12-12)
    end
    gggg(:,:,i) = weui/12;
end
ggggg(:,:) = gggg(:,:,60) - gggg(:,:,40);



A(2:4,:)=A(2:4,:)*0.01;  %scale factor
A(1,:)=A(1,:)*0.1;
%AA = A(:,1:720);
%squeeze%删除维度为1的维度
save('C:\Users\78653\Desktop\ccicproject\CCIC Statistics\monthlyMEANA.mat','A','-mat')
save('C:\Users\78653\Desktop\ccicproject\CCIC Statistics\A.mat','CC','-mat');

save('C:\Users\78653\Desktop\ccicproject\CCIC Statistics\AVTEMD.mat','gg','-mat');
save('C:\Users\78653\Desktop\ccicproject\CCIC Statistics\AVTEMM.mat','ggg','-mat');

save('C:\Users\78653\Desktop\ccicproject\CCIC Statistics\AVTEMY.mat','gggg','-mat');
save('C:\Users\78653\Desktop\ccicproject\CCIC Statistics\F.mat','F','-mat');

save('C:\Users\78653\Desktop\ccicproject\CCIC Statistics\rx.mat','Rx','-mat');
save('C:\Users\78653\Desktop\ccicproject\CCIC Statistics\ry.mat','Ry','-mat');






