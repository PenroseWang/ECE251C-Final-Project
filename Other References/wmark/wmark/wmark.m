%Abhijith. S, PAACET, India.

%Implementing Watermarking using discrete 2-D wavelet transform.
%Input image is watermarked with a key having Mean = 0 & Variance = 1

clc;clear all;close all;

img  = imread('home.jpg'); %Get the input image 
img  = rgb2gray(img);      %Convert to grayscale image

img  = double(img);
c = 0.01; %Initialise the weight of Watermarking

figure,imshow(uint8(img)),title('Original Image');
[p, q] = size(img);

%Generate the key 
n = awgn(zeros(size(img)),4,3,'linear');
N = imabsdiff(n,img);
figure,imshow(double(N)),title('Key');


[Lo_D,Hi_D,Lo_R,Hi_R] = wfilters('haar');%Obtain the fiters associated with haar
[ca,ch,cv,cd] = dwt2(img,Lo_D,Hi_D);     %Compute 2D wavelet transform

%Perform the watermarking
y = [ca ch;cv cd];
Y = y + c*abs(y).* N; 
p=p/2;q=q/2;
for i=1:p
    for j=1:q
        nca(i,j) = Y(i,j);
        ncv(i,j) = Y(i+p,j);
        nch(i,j) = Y(i,j+q);
        ncd(i,j) =  Y (i+p,j+q);
    end
end

%Display the Watermarked image
wimg = idwt2(nca,nch,ncv,ncd,Lo_R,Hi_R);
figure,imshow(uint8(wimg)),title('Watermarked Image');

diff = imabsdiff(wimg,img);
figure,imshow(double(diff));title('Differences');