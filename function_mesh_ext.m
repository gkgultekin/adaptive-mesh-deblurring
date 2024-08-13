
function [ext_mesh] = function_mesh_ext(cell_row, cell_column, mesh_size , image , overlap)

% Define the extended mesh structure
ext_mesh = cell (cell_row , cell_column) ; 

if cell_row == 1 && cell_column == 1
    
    ext_mesh{1,1} = image ;
    
    
else
    for i = 1:1:cell_row
        for j = 1:1:cell_column
            
            olap = overlap(i,j) ;
            
            % For the first row
            if i == 1
                
                % Seperate first mesh
                if j==1
                    ext_mesh{i,j} = image( 1:mesh_size + olap , 1:mesh_size + olap ) ;
                end
                
                % Intermediate meshes
                if j>1 && j< cell_column
                    ext_mesh{i,j} = image( 1:mesh_size + olap , (j-1)*mesh_size - olap +1 : j* mesh_size + olap ) ;
                end
                
                % Last mesh
                if j == cell_column
                    ext_mesh{i,j} = image( 1:mesh_size + olap , (j-1)*mesh_size - olap +1 : j*mesh_size ) ;
                end
                
            end
            
            % For first colomn
            if j == 1 && i ~= 1
                %i = 1 , j = 1 found in firts part no need second complitation
                
                % Last mesh
                if i == cell_row
                    ext_mesh{i,j} = image( (i-1)*mesh_size - olap +1:i*mesh_size , 1: mesh_size + olap ) ;
                end
                
                % Intermidiate meshes
                if i>1 && i< cell_row
                    ext_mesh{i,j} = image( (i-1)*mesh_size - olap +1: i* mesh_size + olap, 1:mesh_size + olap ) ;
                end
                
            end
            
            
            % For Last Row
            if i == cell_row && j ~= 1
                
                % Last col mesh
                if j == cell_column
                    ext_mesh{i,j} = image( end - mesh_size - olap +1 :end , (j-1)*mesh_size - olap +1 : j*mesh_size ) ;
                end
                
                % Intermediate meshes
                if j>1 && j< cell_column
                    ext_mesh{i,j} = image( end - mesh_size - olap +1:end , (j-1)*mesh_size - olap +1 : j* mesh_size + olap ) ;
                end
                
            end
            
            
            % For Last Colomn
            if j == cell_column && i ~= 1 && j~= 1 && i ~= cell_row
                %i = 1 , j = 1 found in before no need second computation
                
                % Intermidiate meshes
                ext_mesh{i,j} = image( (i-1)*mesh_size - olap +1: i* mesh_size + olap, end - mesh_size - olap +1 :end ) ;
            end
            
            
            % Meshes at the center location
            if i > 1 && i< cell_row && j >1 && j < cell_column
                ext_mesh{i,j} = image( (i-1)*mesh_size - olap +1: i* mesh_size + olap,(j-1)*mesh_size - olap +1 : j* mesh_size + olap ) ;
            end
            
        end
    end
end
end