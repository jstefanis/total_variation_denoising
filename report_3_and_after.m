name = 'lena' ;
f0 = load_image(name) ;
rho=.3 ;
n=256;
Lambda = randn(n,n) > rho;
f1 = rescale(crop(f0,n));
Phi = @(f)f.*Lambda;

y = Phi(f1);
imageplot(y);
% applying soft thresholding operator!
SoftThresh = @(x,T)x.*max(0, 1-T./max(abs(x),1e-10));
Jmax = log2(n)-1
Jmin = Jmax-3

options.ti = 0; %use orthogonality

Psi = @(a)perform_wavelet_transf(a, Jmin, -1,options);
PsiS = @(f)perform_wavelet_transf(f, Jmin, +1,options);

SoftThreshPsi = @(f,T)Psi(SoftThresh(PsiS(f),T ));


%save_res(name,0.05)
img_name=name
step=0.05


% imageplot(clamp(SoftThreshPsi(f1, 0.1) ));

save_path=strcat('regularisation_denoising_results','/',img_name,'/','rho',num2str(rho))

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
    
%         p = psnr(x,y,vmax);
        result=clamp(SoftThreshPsi(f1, threshold) )
        p = snr(f1(:),result(:) );
    imageplot(result);
    hold on
    title(['Threshold is: ',num2str(threshold),sprintf('\n'), ' signal-to-noise ratio =',num2str(p),' db'])
    legend(['Threshold is: ',num2str(threshold)])
    drawnow
    hold off
    resulting_img =strcat(save_path,'/', thres,'-thresh.png')
     saveas(gcf,resulting_img);
    
end

