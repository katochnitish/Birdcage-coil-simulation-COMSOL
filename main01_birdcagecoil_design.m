clear;close all;clc;
datapath = 'Data/';
%% Coil dimensions and Operational parameters
model_parameters.f0        = 128;                    % Larmor frequency
model_parameters.r_coil    = 24e-2;                  % Radius of birdcage coil
model_parameters.h_coil    = 30e-2;                  % Height of birdcage coil
model_parameters.l_element = 1e-2;                   % length of rungs
model_parameters.t_ring    = 1.5e-2;                 % Thickness of rungs
model_parameters.Ncoil     = 16;  tem = 360/model_parameters.Ncoil; %Number of recieve channels
model_parameters.Nrings    = 0:tem:360;
model_parameters.Nrings    = model_parameters.Nrings(1:model_parameters.Ncoil);
clear tem;

if model_parameters.f0 == 128 && model_parameters.Ncoil == 8
    model_parameters.c_value   = 5.41e-12;               % Capacitance of lump element
elseif model_parameters.f0 == 128 && model_parameters.Ncoil == 16
    model_parameters.c_value   = 1e-10;               % Capacitance of lump element
end
%% ============================================================ %%
model_parameters.parametricS      = 0;             % Imaging matrix size
model_parameters.imSize           = 128;           % Imaging matrix size
model_parameters.Nslices          = 10;            % number of slices
model_parameters.FOV              = 35e-2;         % field of view in millimeter
model_parameters.ht               = 5e-3;          % FOVz in Z-directions
model_parameters.SliceThickness   = model_parameters.ht /model_parameters.Nslices;  % slice thickness in millimeter
model_parameters.VoxelSize        = [model_parameters.FOV/model_parameters.imSize ...
    model_parameters.FOV/model_parameters.imSize model_parameters.SliceThickness];
%% ============================================================ %%
[B1p, B1n, sigma] = mri_birdcage_sim (model_parameters);
%% ============================================================ %%
maxB1 = max([abs(B1p(:)); abs(B1n(:))]);
for ii = 1:model_parameters.Nslices
    % B1+ plot
    figure()
    subplot(1,2,1);imagesc(angle(B1p(:,:,ii)));    title('B_1^+ field (dB)');
    caxis([-pi pi]);
    xlabel('x -->');    ylabel('y -->');
    axis equal tight
    % B1- plot
    subplot(1,2,2);imagesc(angle(B1n(:,:,ii)));   title('B_1^- field (dB)');
    caxis([-pi pi]);
    xlabel('x -->');    ylabel('y -->');
    axis equal tight
end
%%
% for ii = 1:model_parameters.Nslices
%     figure;imagesc(sigma(:,:,ii));axis off image;colormap gray;
% end

% [0,0.0140000000000000,0.0280000000000000,0.0420000000000000,0.0560000000000000,0.0700000000000000,0.0840000000000000,0.0980000000000000,0.112000000000000,0.126000000000000]