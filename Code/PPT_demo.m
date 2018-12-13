%% PPT Demos
clc; close all; clear variables;

image = imread('lena512.bmp');

%% 2-level DWT
[LL1, HL1, LH1, HH1] = haart2(image, 1);
[LL2, HL2, LH2, HH2] = haart2(LL1, 1);
figure;
imshow([[double2im(LL2) double2im(HL2); double2im(LH2) double2im(HH2)]...
    double2im(HL1); double2im(LH1) double2im(HH1)]);

%% DWT shift invariance
[LL1, HL1, LH1, HH1] = haart2(circshift(image, [40 40]), 1);
figure;
imshow([double2im(LL1) double2im(HL1); double2im(LH1) double2im(HH1)]);

[LL1, HL1, LH1, HH1] = swt2(circshift(image, [0 0]), 1, 'sym4');
subplot(311);
imshow([double2im(LL1) double2im(HL1) double2im(LH1) double2im(HH1)]);

[LL1, HL1, LH1, HH1] = swt2(circshift(image, [10 10]), 1, 'sym4');
subplot(312);
imshow([double2im(LL1) double2im(HL1) double2im(LH1) double2im(HH1)]);

[LL1, HL1, LH1, HH1] = swt2(circshift(image, [20 20]), 1, 'sym4');
subplot(313);
imshow([double2im(LL1) double2im(HL1) double2im(LH1) double2im(HH1)]);


function img = double2im(mat)

img = uint8(255*mat2gray(mat));
end