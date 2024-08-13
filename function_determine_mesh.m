
function [variance_r,r_vect,theta_vect] = function_determine_mesh(resolution_rows,resolution_cols, mesh_size_x,mesh_size_y,wx_in,wy_in,wz_in,exposure_time)


    % Camera Parameters
    f  = 14*10^-3;
    uc = 3.39e-6 ;

    % Rotational Measurements
    wx = deg2rad( sum(wx_in)/10*exposure_time);
    wy = deg2rad( sum(wy_in)/10*exposure_time);
    wz = deg2rad( sum(wz_in)/10*exposure_time);


    row_point_density = resolution_rows;    % Optical Flow Vertical  Resolution
    col_point_density = resolution_cols;    % Optical Flow Horizontal Resolution
    
    % 
    [X,Y] = meshgrid( -resolution_cols/2 : resolution_cols/col_point_density : resolution_cols/2, ...
                                 -resolution_rows/2 : resolution_rows/row_point_density : resolution_rows/2 );

    X_sensor = X * uc;
    Y_sensor = Y * uc;
    
    % Distance (meter)
    z=1000;

    % Only Rotational movement taken into account
    vx = 0.00;
    vy = 0.00;
    vz = 0.00;

    index1    = 1:mesh_size_x:resolution_rows+1 ;
    index2    = 1:mesh_size_y:resolution_cols+1 ;

    
    u_a = X_sensor( index1, index2  );
    v_a = Y_sensor( index1, index2  );

    u_dot_a  =  wz*(v_a)   - wy*f - wy*(u_a.*u_a)/f + wx*(u_a.*v_a)/f  ; % - f/z*vx + u_ahmt/z*vz;    disable since they are 0
    v_dot_a  = -wz*(u_a)   + wx*f - wy*(u_a.*v_a)/f + wx*(v_a.*v_a)/f  ; % - f/z*vy + v_ahmt/z*vz ;

    % Displacement vectors
    u_dot_m =  u_dot_a/uc;
    v_dot_m =  v_dot_a/uc;

    % Determining the radious and angle

    size_row = size(u_dot_m,1);
    size_col = size(u_dot_m,2);

    for i = 1:1:size_row
        for j=1:1:size_col

            [theta_rad,r(i,j)] =  cart2pol( u_dot_m(size_row+1-i,j), v_dot_m(size_row+1-i,j), 1); % (u,v) cartesian to polar convertion
            theta_deg(i,j)     =  theta_rad / pi * 180;                                           % Rad to degree convertion

        end
    end

    r_vect         = r(:);
    theta_vect     = theta_deg(:) ;
    
    variance_r     = var(r_vect) ;

 
end




