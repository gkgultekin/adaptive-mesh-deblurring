%% OVERLAPPING FUNCTION - MODIFIED FOR DIFFERENT OVERLAP SÝZES

% Removes the overlepping regions from all meshes 

function [result_im] = function_intersection_modified(cell_column,cell_row,overlap,deblurred_mesh)  


    % Define the image cells for cutted parts of the extended image
    cell_image = cell (cell_row, cell_column) ; 

    if cell_column == 1 && cell_row == 1

        cell_image{1,1} = deblurred_mesh{1,1} ;

    else
        %
        for i = 1:1:cell_row
            for j = 1:1:cell_column

                % Select the related mesh
                im_dum          = deblurred_mesh{i,j} ;
                olap            = overlap(i,j)     ;

                % For first row
                if i == 1

                    % Seperate first meshes
                    if j == 1
                        cell_image{i,j} = im_dum( 1:end-olap, 1:end-olap ) ;
                    end

                    % Intermediate meshes
                    if j>1 && j< cell_column
                        cell_image{i,j} = im_dum( 1:end-olap, olap+1:end-olap) ;
                    end

                    %  last mesh
                    if j == cell_column
                        cell_image{i,j} = im_dum(1:end-olap,olap+1:end) ;
                    end

                end


                % For first colomn
                if j == 1 && i ~= 1
                    %i = 1 , j = 1 found in firts part no need second computation

                    % Last mesh
                    if i == cell_row
                        cell_image{i,j} = im_dum( olap+1:end, 1:end-olap ) ;
                    end

                    % Intermidiate meshes
                    if i>1 && i< cell_row
                        cell_image{i,j} = im_dum( olap+1:end-olap, 1:end-olap ) ;
                    end
                end



                % For Last Row
                if i == cell_row && j ~= 1

                    % Last col mesh
                    if j == cell_column
                        cell_image{i,j} = im_dum( olap+1:end, olap+1:end ) ;
                    end

                    % Intermidiate meshes
                    if j>1 && j< cell_row
                        cell_image{i,j} = im_dum( olap+1:end, olap+1:end-olap) ;
                    end
                end

                % For Last Colomn
                if j == cell_column && i ~= 1 && j~= 1 && i ~= cell_row
                    %i = 1 , j = 1 found in before no need second computation

                    % Intermidiate meshes
                    cell_image{i,j} = im_dum( olap+1:end-olap, olap+1:end ) ;
                end


                % Meshes at the center location
                if i > 1 && i< cell_row && j >1 && j < cell_column
                    cell_image{i,j} = im_dum( olap+1:end-olap, olap+1:end-olap ) ;
                end

            end
        end

    end

    result_im = cell2mat(cell_image) ;

end



