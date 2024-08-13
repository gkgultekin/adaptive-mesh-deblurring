%% IMU-Aided Adaptive Mesh-Grid Based Video Motion Deblurring -  NEW - METHOD
% AHMET ARSLAN, GOKHAN KORAY GULTEKIN, AFSAR SARANLI

clc;
clear all;
close all;

% Functions Path (Deblurring, Mesh division, mesh extension, mesh removal functions) 
addpath('Functions/');

% File Paths
 blurred_im_path   = 'DataSets\CastleDataset\blurred_castle\' ;
 deblurred_im_path = 'Results\Results Castle A\' ;
 original_im_path  = 'DataSets\CastleDataset\Original_castle\' ;

% IMU dataset and time stamps
 load('DataSets\ýmu_datas\fast_walk.mat');
 total_num_image = 50 ; 
 startsamp       = 8400 ;

% IMU scale ratio
 roll_mult       = 1 ;
 yaw_mult        = 1   ;
 pitch_mult      = 1   ;
 
% Exposure Time of the camera 
exposure_time   = 0.01;

% Number of IMU Samples for per exposure
sample_num      = 10 ;

% IMU readings
G_Pitch   = fastwalk.VarName1(:);  % Pitch
G_Roll    = fastwalk.VarName2(:);  % Roll
G_Yaw     = fastwalk.VarName3(:);  % Yaw


%% DIVIDING IMAGE INTO MESHES

% Common Dividers of the image size
common_div = find_div(480,480) ;
outer_loop = 1;

for im_num = 1:1:total_num_image % total_num_image
    
    im_num
    
    % Original Image
    im_or    = imread([original_im_path  num2str(im_num) '.bmp']); % 480 x 480
    im_or    = im2double(im_or) ;

    size_im  = size(im_or);
    
    % Blurred Image
    im_blur = imread([blurred_im_path  num2str(im_num) '.bmp']);
    im_blur = im_blur(1:end-1,1:end-1);
   
    inner_loop = 1;
    
    % Taking the IMU samples for each Frame
    wx_in = G_Pitch( startsamp + (im_num-1)*sample_num : startsamp +im_num*sample_num  )*pitch_mult ;              % Camera Pitch
    wy_in = G_Yaw  ( startsamp + (im_num-1)*sample_num : startsamp +im_num*sample_num  )*yaw_mult   ;              % Camera Yaw
    wz_in = G_Roll ( startsamp + (im_num-1)*sample_num : startsamp +im_num*sample_num  )*roll_mult  ;              % Camera Roll
    
    %% MESH-SIZE DETERMINATION
    
	% Loop through the dividers
    for ab = 6:1:size(common_div,2)
          
        % Define the mesh-sizes
        mesh_size     = common_div(ab);
        im_matrix     = im_blur;
        mesh_size_x   = mesh_size;
        mesh_size_y   = mesh_size;
        
        row_or        = size_im(1) ;
        colum_or      = size_im(2) ;
        
        cell_column   = floor(colum_or/mesh_size_x )   ;
        cell_row      = floor(row_or  /mesh_size_y )   ;
        
        % Finding the blur magnitudes
        [variance_frame,r_vect,theta_vect] = function_determine_mesh( size(im_or,1) , size(im_or,2) , 48, 48, wx_in,wy_in,wz_in,exposure_time);
    
        % Vector Calculation
        [u_dot_m,v_dot_m]   = function_IMU_plane(row_or,colum_or, mesh_size_x,mesh_size_y,wx_in,wy_in,wz_in,exposure_time);
        resultss_method2    = cell([cell_row cell_column]);
        
        % PSF Generation & Angle & Radious Calculation of each mesh
        theta_deg     = zeros(cell_row,cell_column) ;
        r             = zeros(cell_row,cell_column) ;
        PSF           = cell (cell_row,cell_column) ;
        overlap_store = zeros(cell_row,cell_column) ;
        Max_PSF_size  = zeros(cell_row,cell_column);
        
        
        for i = 1:1:cell_row
            for j=1:1:cell_column
             
                [theta_rad,r(i,j)] =  cart2pol( u_dot_m(cell_row+1-i,j), v_dot_m(cell_row+1-i,j), 1);
                theta_deg(i,j)     =  theta_rad / pi * 180; 
                
                if( r(i,j) > 1 )
                    PSF{i,j} = fspecial ( 'motion' , r(i,j), theta_deg(i,j) ); 
                else
                    PSF_d     = zeros(3);
                    PSF_d(2,2)= 1;
                    PSF{i,j}  = PSF_d ;
                end
                
                % Determining the overlap size for each mesh
                max_dim_psf        = max( size(PSF{i,j}) ) ;
                overlap_store(i,j) = 2*max_dim_psf ; 
                Max_PSF_size(i,j)  = max_dim_psf ;
                
                % Smallest value for overlap
                if overlap_store(i,j) < 10
                    overlap_store(i,j) = 10 ;
                end            
            end
        end
        
        max_dimm = max(max(Max_PSF_size)) ;
        %% Mesh-Content Region Selection
        
        if max(max(overlap_store)) < round(  mesh_size  )
		
        % Extend the selected mesh size by overlapping region  
        extend_mesh = function_mesh_ext(cell_row, cell_column, mesh_size , im_matrix , overlap_store) ;
     
        %% Deblurring Process
        
        % Finding the total number of pixels processed
        sum_of_pix = 0 ;
        
        tic;
        for i=1:1:cell_row
            for j=1:1:cell_column
             
                % Deblurring
                resultss_method2{i,j}     = function_deblur_m2(extend_mesh{i,j},PSF{i,j})    ; % Krishnan Method
                
                % Number of Processed Total Pixels
                pix_num                 = size( extend_mesh{i,j},1) * size( extend_mesh{i,j},2) ;
                sum_of_pix              = sum_of_pix  +  pix_num ;
                              
            end
        end
        
        
        t_frame = toc;
        %% Removing the Intersections
        image_deblurred_reduced_Method2 =  function_intersection_modified(cell_column,cell_row,overlap_store,resultss_method2);
        
        %% PSNR Calculation
        
        cut_sz = 30 ;
             
        size_eq_1 = size(image_deblurred_reduced_Method2,1) ;
        size_eq_2 = size(image_deblurred_reduced_Method2,2) ;
        
        
        ref                = im2double( im_or   );
        blurred_image_or   = im2double( im_blur );
        combined_image     = cat(2,ref,blurred_image_or,image_deblurred_reduced_Method2);
        
        ref                = ref             (cut_sz:end-cut_sz,cut_sz:end-cut_sz);
        blurred_image_or   = blurred_image_or(cut_sz:end-cut_sz,cut_sz:end-cut_sz);
        
        deblurred_method_2 = image_deblurred_reduced_Method2(cut_sz:end-cut_sz,cut_sz:end-cut_sz);
        
        % Writing Deblurred Image
        
        imwrite(image_deblurred_reduced_Method2,[deblurred_im_path 'res_' num2str(im_num) '_mz_' num2str(mesh_size) '.bmp']);
        imwrite(combined_image,[deblurred_im_path  num2str(im_num) '_mz_' num2str(mesh_size) '.bmp']);
        
        % PSNRs
        % Blurred Image PSNR
        [blurred_psnr, ~]         = psnr(blurred_image_or, ref);
        
        % Deblurred Image PSNR
        [deblurred_psnr_krish, ~] = psnr(deblurred_method_2, ref);
        
        % SSIM        
        blurred_ssm   = ssim(blurred_image_or  ,ref) ;
        deblurred_ssm = ssim(deblurred_method_2,ref) ;
        
        
        % Storing the Variables for saving
        result_psnr(inner_loop,1)   = mesh_size                         ;
        result_psnr(inner_loop,2)   = blurred_psnr                      ;
        result_psnr(inner_loop,3)   = deblurred_psnr_krish              ;
        result_psnr(inner_loop,4)   = deblurred_psnr_krish-blurred_psnr ;
        result_psnr(inner_loop,5)   = t_frame         ;
        result_psnr(inner_loop,6)   = sum(wx_in*0.001); % Camera Pitch
        result_psnr(inner_loop,7)   = sum(wy_in*0.001); % Camera Yaw
        result_psnr(inner_loop,8)   = sum(wz_in*0.001); % Camera Roll
        result_psnr(inner_loop,9)   = blurred_ssm   ;
        result_psnr(inner_loop,10)  = deblurred_ssm ;
        result_psnr(inner_loop,11)  = sum_of_pix    ; 
        result_psnr(inner_loop,12)  = variance_frame;

        
        else
          
        result_psnr(inner_loop,1)    = mesh_size ;
        result_psnr(inner_loop,2:11) = 0         ;
        result_psnr(inner_loop,12)   = variance_frame;
        
        end
        % Separetely store the overlap stores
        store_overlap{inner_loop,1} =  overlap_store ;
       
        
        inner_loop = inner_loop + 1;
    end
    
    PSNR_res{outer_loop,1} = result_psnr ;
    PSNR_res{outer_loop,2} = store_overlap;
    
    
    outer_loop             = outer_loop+1;
end
save([deblurred_im_path 'PSNR_result' ],'PSNR_res') ;




%% FUNCTIONS
%% Determining the divider numbers
function [common] = find_div(row,col)
% Select the minimum div number as 10 and search the min of the row and
% col for max number

    if row < col
        lim = row;
    else
        lim = col;
    end

    i = 1;
    for x = 10:1:lim

        x_row = mod(row,x);
        x_col = mod(col,x);

        if  x_row == x_col & x_col == 0

            common(i) = x ;
            i=i+1;

        end
    end
    
end
