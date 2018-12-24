% function [ output_args ] = untitled( input_args )
function  success = save_res(img_name,step)
save_path='regularisation_denoising_results/'

if exist(save_path, 'dir')
    warningMessage = sprintf('The folder %s already exists!', save_path);
    uiwait(warndlg(warningMessage));
else
    mkdir(save_path);
end
figure;
% loop for creation of results
i=0.01
for threshold = 0.01:step:1 % step .05 for tresholding
    % threshold =i+0.05
    thres =sprintf('%.2f',threshold);
    
    imageplot(clamp(SoftThreshPsi(f1, threshold) ));
    
    resulting_img =strcat(save_path,img_name,'/-', thres,'-thresh.png')
%     saveas(gcf,resulting_img);
    
end


end

