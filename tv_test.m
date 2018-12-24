%%
%% dual TV
%% 

 rho = .8;
 Lambda = rand(n,n)>rho;
 Phi = @(f)f.*Lambda;

 y = Phi(f0);
 imageplot(y);


name = 'lena' ;
sigma = 0.1;
n = 256;
f0 = load_image(name)
f0 = rescale(crop(f0,n)); % crop the 256x256
K =@(f)grad(f);
KS = @(u) -div(u);
Amplitude =@(u)sqrt(sum(u.^2,3)) ;
F = @(u)sum(sum(Amplitude(u)));

ProxF = @(u,lambda)max(0,1-lambda./repmat(Amplitude(u),[1 1 2])).*u;
ProxFS = @(y,sigma)y-sigma*ProxF(y/sigma,1/sigma);
ProxG = @(f,tau)f + Phi(y - Phi(f));

L = 8;
sigma = 10;
tau = .9/(L*sigma);
theta = 1 ;
f = y;
g = K(y)*0; % initialise it with zero!
f1=f;

for nn = 1:5

    fold = f;
    g = ProxFS(g+sigma*K(f1),sigma);
    f = ProxG(f - tau*KS(g),tau);
    f1 = f + theta * (f- fold);
    
end



%save_res(name,0.05)
img_name=name
step=0.05


% imageplot(clamp(SoftThreshPsi(f1, 0.1) ));

save_path=strcat('primal_dual_tv','/',img_name,'/','rho',num2str(rho))

if exist(save_path, 'dir')
    warningMessage = sprintf('The folder %s already exists!', save_path);
    uiwait(warndlg(warningMessage));
else
    mkdir(save_path);
end

imshowpair(f1,y,'montage'), ...
title(['Original and distorted image with rand. gauss. noise ','rho= ',num2str(rho)]);
saveas(gcf,strcat(save_path,'/',img_name,'-montage.png'));

figure;
% loop for creation of results
% i=0.01

for threshold = 0.01:step:1 % step .05 for tresholding
    % threshold =i+0.05
    thres =sprintf('%.2f',threshold);
    
    imageplot(clamp(SoftThreshPsi(f1, threshold) ));
    hold on
    title(['Threshold is: ',num2str(threshold)])
    legend(['Threshold is: ',num2str(threshold)])
    drawnow
    hold off
    resulting_img =strcat(save_path,'/', thres,'-thresh.png')
     saveas(gcf,resulting_img);
    
end