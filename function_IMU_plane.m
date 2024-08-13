%% FUNCTION IMU-TO-IMAGE PLANE
% IMU to image plane representation


function [u_dot_m,v_dot_m] = function_IMU_plane(resolution_rows,resolution_cols, mesh_size_x,mesh_size_y,wx_in,wy_in,wz_in,exposure_time)

        wx = deg2rad( sum(wx_in)/10*exposure_time);
        wy = deg2rad( sum(wy_in)/10*exposure_time);
        wz = deg2rad( sum(wz_in)/10*exposure_time);

        f=14*10^-3;
        uc=3.39e-6;


        row_point_density = resolution_rows; 
        col_point_density = resolution_cols; 
        % 
        [X,Y] = meshgrid( -resolution_cols/2 : resolution_cols/col_point_density : resolution_cols/2, ...
                                     -resolution_rows/2 : resolution_rows/row_point_density : resolution_rows/2 );


        X_sensor = X * uc;
        Y_sensor = Y * uc;

        z=1000;

        % m/s
        vx = 0.0;
        vy = 0.00;
        vz = 0.00;

       
       % Define the matrices... 
       
        u_ahmt = X_sensor(ceil(mesh_size_y/2):mesh_size_y:size(X,1),ceil(mesh_size_x/2):mesh_size_x:size(X,2));
        v_ahmt = Y_sensor(ceil(mesh_size_y/2):mesh_size_y:size(X,1),ceil(mesh_size_x/2):mesh_size_x:size(X,2));

        u_dot_ahmt  =  wz*(v_ahmt)   - wy*f - wy*(u_ahmt.*u_ahmt)/f + wx*u_ahmt.*v_ahmt/f  ; % - f/z*vx + u_ahmt/z*vz;    disable since they are 0  
        v_dot_ahmt  = -wz*(u_ahmt)   + wx*f - wy* u_ahmt.*v_ahmt/f  + wx*(v_ahmt.*v_ahmt)/f ; % - f/z*vy + v_ahmt/z*vz ;


        % Displacement vectors    
        u_dot_m =  u_dot_ahmt/uc;
        v_dot_m =  v_dot_ahmt/uc;
      
%%
% Disable plotting for speed
%                     hFig = figure;
%                     set(gcf,'PaperPositionMode','auto')
%                     set(hFig, 'Position', [300 200 640*3/5 480*3/5])  
%                     xlabel('Image Sensor U Axis (mm)');
%                     ylabel('Image Sensor V Axis (mm)');
%                     hold on
%                     sf = 1/uc;%1000;    % *1000 to convert m/s to mm/s   
%                     point_spacing = 64; 
% 
%                     for aj = 1 : ceil(resolution_cols/mesh_size_x)
%                         for ai = 1 : ceil(resolution_rows/mesh_size_y)
%                             %abc =[(ai-1)*mesh_size_y+ceil(mesh_size_y/2) (aj-1)*mesh_size_x+ceil(mesh_size_x/2)]
%                             u_dot_end = X_sensor((ai-1)*mesh_size_y+ceil(mesh_size_y/2),(aj-1)*mesh_size_x+ceil(mesh_size_x/2)) + u_dot_new(ai,aj);
%                             v_dot_end = Y_sensor((ai-1)*mesh_size_y+ceil(mesh_size_y/2),(aj-1)*mesh_size_x+ceil(mesh_size_x/2)) + v_dot_new(ai,aj);
%                             plot([X_sensor((ai-1)*mesh_size_y+ceil(mesh_size_y/2),(aj-1)*mesh_size_x+ceil(mesh_size_x/2))*sf ; u_dot_end*sf],[Y_sensor((ai-1)*mesh_size_y+ceil(mesh_size_y/2),(aj-1)*mesh_size_x+ceil(mesh_size_x/2))*sf ; v_dot_end*sf]);
%                             plot(X_sensor((ai-1)*mesh_size_y+ceil(mesh_size_y/2),(aj-1)*mesh_size_x+ceil(mesh_size_x/2))*sf ,Y_sensor((ai-1)*mesh_size_y+ceil(mesh_size_y/2),(aj-1)*mesh_size_x+ceil(mesh_size_x/2))*sf,'ro','MarkerSize',4);
%                         
%                         
%                         end
%                     end
%                     
%                     
%                     
%                     axis([umin*sf umax*sf vmin*sf vmax*sf])
%                     set(gca,'box','on','ticklength',[0.02 0.05]) % üst taraflarý da çerçeveye alýr
%                     
%                     grid on
                    
                    % Plotting end                    
                    % ************/////////

                    
%             u_dot_m = (u_dot_new/uc);  % Along x direction
%             v_dot_m = v_dot_new/uc ;  % Along y direction        


end




