clear
close all

% Set path to all subfolders
addpath(genpath('.'));

scanner_type = 1; % 1 - TOPCON; 2 - Big Vision

CR = 20; % [4 7 10 20 30 40];

if scanner_type == 1
    I1=480; I2=512; I3=64;
    J1=20; J2=24; J3=16; J4=32;
    load 20440_aligned
    X = double(data); clear data
    oct_name = "20440_TOPCON";
elseif scanner_type == 2
    I1=1024; I2=512; I3=100;
    J1=32; J2=32; J3=16; J4=32;
    load 080827_align.mat 
    X = double(OCT_align); clear OCT_align
    oct_name = "080827_BVS";
end

sX = size(X);
rX= [J1 J2 J3 J4 I3]; % MERA 5D tensor dimensions

if CR >= I3
    CR = I3-1;
    display(append('CR has to be less than ',num2str(I3)))
end
a = CR;
b = CR*(I1 + I2*I3);
c = (CR - I3)*I1*I2;

d = sqrt(b*b - 4*a*c);
R1 = (-b + d)/2/a;

R = round(R1);
num = I1*I2*I3;
den = I1*R + I2*I3*R + I1*I2 + R*R;

Rh = R;
CRh = num/den;

% MERA approximation
R_mera{1} = [Rh Rh];

% low MERA rank approximaton
[Xh]=low_rank_MERA(reshape(X,rX),R_mera,sX);

figure
for i3=1:I3
    subplot(1,2,1)
    imagesc(X(:,:,i3))
    colormap('gray')
    title('Original')
    subplot(1,2,2)
    imagesc(Xh(:,:,i3))
    colormap('gray')
    title(strcat('MERA approximation CR=',num2str(CR)))
    pause(2)
end

savefile=strcat(oct_name,"_MERA_CR_",num2str(CR),".mat");
save(savefile,"Xh");

% % Components of MERA network
% C=mera.layers{1};
% U=C.U;  % disantangler
% W=C.W; W1=W{1}; W2=W{2}; % isometries
% G=mera.top; % top core