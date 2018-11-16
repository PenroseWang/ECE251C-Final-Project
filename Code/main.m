%% Main
clc; close all; clear all;

%% Read in lena and watermark
lena = imread('lena512.bmp');
wm = imread('Copyright.png');
figure;
subplot(121);
imshow(lena);
title('Lena');
subplot(122);
imshow(wm);
title('Copyright');

