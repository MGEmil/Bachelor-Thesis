%% environment fără obstacole -> Algoritmul Bézier clasic
tic;

xlim([0 3.5])
ylim([0 3])
zlim([0 2])
t = linspace(0,1,101);

% 7  puncte
% matrix_points = [0.4,1.2,1.5,2,1.7,1.3,0.4; 0.8,0.3,1,0.8,1.5,1.1,0.8; 0.4,0.4,0.4,0.8,0.8,0.8,0.8;];

% 10 puncte
matrix_points = [0.5,0.9,1.4,0.8,0.65,1,1.3,0.9,0.8,1; 1,0.75,1.1,1.2,0.95,0.85,1.05,1.1,0.9,1; 0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1,1.1;];


plot3(matrix_points(1,:),matrix_points(2,:),matrix_points(3,:),'o','MarkerFaceColor','k');
hold on
grid on;

nr_puncte = 0;
i = 1;
j = 1;
last_value = zeros(3,1);
matrix_aux = zeros(3,4);
var = 1;
lung_traiectorie= 0;
pts_final = 0;

while i<=length(matrix_points)
    matrix_aux = zeros(3,4);
    if var ~= 1
        matrix_aux(:,1) = last_value; 
    end
    while var<=4
        if(i<=length(matrix_points))
            matrix_aux(:,var) = matrix_points(:,i);
            var = var+1;
            i = i+1;
        else
            break;
        end
    end
    last_value = matrix_aux(:,4);
    pts = kron((1-t).^3,matrix_aux(:,1)) + kron(3*(1-t).^2.*t,matrix_aux(:,2)) + kron(3*(1-t).*t.^2,matrix_aux(:,3)) + kron(t.^3,matrix_aux(:,4));
    if(pts_final == 0)
        pts_final = pts;
    else
        pts_final = horzcat(pts_final,pts);
    end
    var = 2;
end
plot3(pts_final(1,:),pts_final(2,:),pts_final(3,:));

size_pts = size(pts_final);
nr_puncte = size_pts(2);
while j < size_pts(2)
    first_point = pts_final(:,j);
    second_point = pts_final(:,j + 1);
    lung_traiectorie = lung_traiectorie + sqrt((second_point(1,1) - first_point(1,1))^2 + (second_point(2,1) - first_point(2,1))^2 + (second_point(3,1) - first_point(3,1))^2);
    j = j + 1;
end


elapsed_time = toc;
disp(['Lungimea traiectoriei: ' , num2str(lung_traiectorie) , ' metri']);
disp(['Durata de execuție: ', num2str(elapsed_time), ' secunde']);
disp(['Numarul de puncte utilizat:' , num2str(nr_puncte)]);

% csvwrite('data_normal_without_obst.csv', pts_final); 
% Salvarea traiectorie într-un fișier de tip csv

%% environment cu obstacole -> Algoritmul Bézier clasic

tic;
xlim([0 3.5])
ylim([0 3])
zlim([0 2])
t = linspace(0,1,101);

% 7 puncte
% matrix_points = [0.3,1.2,1.4,1.8,1.4,1.3,0.8; 0.8,0.6,0.2,0.8,1,1.4,1.3; 0.4,0.4,0.4,0.7,0.7,0.7,0.7];

% 10 puncte
matrix_points = [0.4,0.6,0.9,1.2,1.4,1.7,1.9,1.8,2.1,1.5; 0.9,1.5,1.1,1.4,1,1.4,1.1,1.9,2,2.1; 0.4,0.4,0.4,0.4,0.7,0.7,0.7,0.7,0.3,0.3];

plot3(matrix_points(1,:),matrix_points(2,:),matrix_points(3,:),'o','MarkerFaceColor','k');
hold on
grid on;

% Obstacol 1
length_obs = 1.1;
width_obs = 0.75;
height_obs = 1;

vertices = [
    1 1 0; 
    length_obs 1 0; 
    length_obs width_obs 0; 
    1 width_obs 0; 
    1 1 height_obs; 
    length_obs 1 height_obs; 
    length_obs width_obs height_obs; 
    1 width_obs height_obs
];


faces = [
    1 2 6 5; 
    2 3 7 6; 
    3 4 8 7; 
    4 1 5 8; 
    1 2 3 4; 
    5 6 7 8  
];

patch('Vertices', vertices, 'Faces', faces, 'FaceColor', 'cyan', 'EdgeColor', 'black');
hold on

% Obstacol 2
length_obs = 1.6;
width_obs = 1.45;
height_obs = 1;

vertices = [
    1.5 1.7 0; 
    length_obs 1.7 0; 
    length_obs width_obs 0; 
    1.5 width_obs 0; 
    1.5 1.7 height_obs; 
    length_obs 1.7 height_obs; 
    length_obs width_obs height_obs; 
    1.5 width_obs height_obs
];


faces = [
    1 2 6 5; 
    2 3 7 6; 
    3 4 8 7; 
    4 1 5 8; 
    1 2 3 4; 
    5 6 7 8  
];

patch('Vertices', vertices, 'Faces', faces, 'FaceColor', 'cyan', 'EdgeColor', 'black');
hold on


nr_puncte = 0;
i = 1;
j = 1;
last_value = zeros(3,1);
matrix_aux = zeros(3,4);
var = 1;
lung_traiectorie= 0;
pts_final = 0;

while i<=length(matrix_points)
    matrix_aux = zeros(3,4);
    if var ~= 1
        matrix_aux(:,1) = last_value; 
    end
    while var<=4
        if(i<=length(matrix_points))
            matrix_aux(:,var) = matrix_points(:,i);
            var = var+1;
            i = i+1;
        else
            break;
        end
    end
    last_value = matrix_aux(:,4);
    pts = kron((1-t).^3,matrix_aux(:,1)) + kron(3*(1-t).^2.*t,matrix_aux(:,2)) + kron(3*(1-t).*t.^2,matrix_aux(:,3)) + kron(t.^3,matrix_aux(:,4));
    if(pts_final == 0)
        pts_final = pts;
    else
        pts_final = horzcat(pts_final,pts);
    end
    var = 2;
end

plot3(pts_final(1,:),pts_final(2,:),pts_final(3,:));

size_pts = size(pts_final);
nr_puncte = size_pts(2);
while j < size_pts(2)
    first_point = pts_final(:,j);
    second_point = pts_final(:,j + 1);
    lung_traiectorie = lung_traiectorie + sqrt((second_point(1,1) - first_point(1,1))^2 + (second_point(2,1) - first_point(2,1))^2 + (second_point(3,1) - first_point(3,1))^2);
    j = j + 1;
end


elapsed_time = toc;
disp(['Lungimea traiectoriei: ' , num2str(lung_traiectorie) , ' metri']);
disp(['Durata de execuție: ', num2str(elapsed_time), ' secunde']);
disp(['Numarul de puncte utilizat:' , num2str(nr_puncte)]);


% csvwrite('data_normal_obst.csv', pts_final);
% Salvarea traiectorie într-un fișier de tip csv