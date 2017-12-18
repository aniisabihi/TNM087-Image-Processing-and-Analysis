function MImage = EllipticMask(FImage)
%EllipsMask Generate a mask for one eye and the complete face
%   Change pixel color for one eye and extract the face
%
%% Who has done it
%
% Author: Aniisa Bihi, anibi335
% Co-author: Molly Middagsfjell, moljo321
%
%% Syntax of the function
%
% Input arguments:  Fimage: Image containing a face 
%
% Output argument:  Mimage: Image with elliptical mask and a red eye
%
% You MUST NEVER change the first line
%
%% Basic version control (in case you need more than one attempt)
%
% Version: 2
% Date: 05/12/2017
%
% Gives a history of your submission to Lisam.
% Version and date for this function have to be updated before each
% submission to Lisam (in case you need more than one attempt)
%
%% General rules
%
% 1) Don't change the structure of the template by removing %% lines
%
% 2) Document what you are doing using comments
%
% 3) Before submitting make the code readable by using automatic indentation
%       ctrl-a / ctrl-i
%
% 4) In case a task requires that you have to submit more than one function
%       save every function in a single file and collect all of them in a
%       zip-archive and upload that to Lisam. NO RAR, NO GZ, ONLY ZIP!
%       All non-zip archives will be rejected automatically
%
% 5) Often you must do something else between the given commands in the
%       template
%
%

%% Your code starts here
%

%% create the output image (RGB!) which is a copy of the original image
% Use einstein.jpg as your FImage
% FImage is the IMAGE = numerical array and NOT THE FILENAME!
[sr,sc] = size(FImage);
MImage = FImage; 

%% Generate the coordinates of the grid points
 [C R] = meshgrid((1:sc),(1:sr));
% Remember the matlab convention regarding rows, columns, x and y coordinates. Feel free to use 
% [Y,X] = meshgrid((1:sx),(1:sy)) or whatever notation instead if you feel more comfortable with that notation


%% Pick three points that define the elliptical mask of the face
% Read more about ellipses at https://en.wikipedia.org/wiki/Ellipse
% Your solution must at least be able to solve the problem for the case 
% where the axes of the ellipse are parallel to the coordinate axes
%
imshow(FImage); 
fpts = ginput(3);

% Two points that specify the major axis
X_center = fpts(1,2);
Y_center = fpts(1,1); 

% Third point that specify the radius between the major azis and the third
% point
X_radius = abs(fpts(1,2)-fpts(2,2)); 
Y_radius = abs(fpts(1,1)-fpts(3,1)); 

% Specifies an ellipse 
Ellipse = ((C - Y_center).^2 ./ Y_radius^2) + ((R - X_center).^2 ./ X_radius^2) <=1;

%
%% Generate the elliptical mask and 
% set all points in MImage outside the mask to black 

fmask = Ellipse; % this is the mask use C and R to generate it
MImage(~fmask) = 0;% here you modify the image using fmask

%% Pick two points defining one eye, generate the eyemask, paint it red

epts = ginput(2);

% Center point
X_Cpoint = epts(1,2); 
Y_Cpoint = epts(1,1);

% Boundary point
X_bound = epts(1,1);
Y_bound = epts(2,1); 

% Circle 
Radius = abs(X_bound-Y_bound); 
Circle = (R-X_Cpoint).^2 + (C-Y_Cpoint).^2 <= Radius^2; 

emask = Circle; % circular eye mask again, use C and R

channels = repmat(MImage,1);
Red = channels(:,:,1); % replace eye points with red pixels
Green = channels(:,:,1);
Blue = channels(:,:,1);

Red(emask) = 255;
Green(emask) = 0;
Blue(emask) = 0; 

MImage = cat(3, Red, Green, Blue); 

%% Display result if you want
%
imshow(MImage);

end

