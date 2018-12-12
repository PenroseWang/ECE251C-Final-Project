clc; clear variables;

%% m sequence (LFSR)
% pn0 = PNGenerator([3, 2], 0);
% pn1 = PNGenerator([3, 1], 0);
pn0 = PNGenerator([14, 13, 8, 4], 0);
pn1 = PNGenerator([14, 13, 12, 2], 0);

figure(1);
subplot(131);
stem(cxcorr(pn0, pn0));
subplot(132);
stem(cxcorr(pn1, pn1));
subplot(133);
stem(cxcorr(double(pn0), double(pn1)));

%% Gold Code
PN0 = circshift(pn0, 0).*circshift(pn1, 394);
PN1 = circshift(pn0, 0).*circshift(pn1, 6);
figure(2);
subplot(131);
stem(cxcorr(PN0, PN0));
subplot(132);
stem(cxcorr(PN1, PN1));
subplot(133);
stem(cxcorr(double(PN0), double(PN1)));
