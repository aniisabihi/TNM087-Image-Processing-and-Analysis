function sfunction = AutoFocus(FStack)
%TNM087Template General Template for TNM087 Lab Tasks
%   Everybody has to use this template
%
%% Who has done it
%
% Author: Aniisa Bihi, anibi335
% Co-author: Molly Middagsfjell, moljo321
%
%% Syntax of the function
%
% Input arguments: FStack is the input variable with the 192 images of size
% 
% Output arguments: sfunction is the output variable that contains the sharpness function  
% sfunction(l) is the sharpness value = normed frequency content of image l
% in FStack
%
% You MUST NEVER change the first line
%
%% Basic version control (in case you need more than one attempt)
%
% Version: 2
% Date: 14/01/2018
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

%% Size of images and number of images
%
[sx,sy,noimages] = size(FStack);

%% Generate a grid, convert the Euclidean to polar coordinates
%

ir = 1:sx;
ic = 1:sy;

cx = ir - sx/2 - 0.5;
cy = ic - sy/2 - 0.5;

[X, Y] = meshgrid(cy,cx);
[TH,R] = cart2pol(X,Y);

%% Number of COMPLETE rings in the Fourier domain 
% ignore the points in the corners

norings = 8; %Change this if you want
r = sx/2; %radie

RQ = floor((R/r*norings)+1);%this is the quantized version of R where 
% the pixel value is the index of the ring 
% (origin = 0, and the point (0,r) has index norings  
%...

maxindex = max(RQ(:));

%% Number of grid points in each ring

ptsperring = zeros(norings,1);
for ringno = 1:norings 
    ptsperring(ringno) = sum(RQ(:) == ringno);  
end

%% Sum of fft magnitude per image - per ring

absfftsums = zeros(noimages,norings);

for imno = 1:noimages
    padimage = padarray(FStack(:,:,imno),[16 16]); % Read about zero-padding
    ftplan = fft2(padimage); % 2D fft
    cftplan = fftshift(ftplan); % move origin to the center
    
    for ringno = 1:norings
        ringmask = (RQ == ringno); %this is a logical array defining the ring
        paddedmask = padarray(ringmask,[16 16]);
        magnitude = sum(abs(cftplan(paddedmask(:))));
        absfftsums(imno,ringno) = magnitude/ptsperring(ringno); % average over Fourier magnitude in ring
    end
end
    
%% Compute weighted average over the ring sums
%

meanfreqcontent = zeros(noimages,1);

w = 1:norings; % here you may use the ring index, radius or something you define

for imno = 1:noimages
    meanfreqcontent(imno) = (absfftsums(imno,:) * w');% combine w and absfftsums
end

%% Requested result
% default solution but you can invent something else if you want
sfunction = meanfreqcontent;

end

