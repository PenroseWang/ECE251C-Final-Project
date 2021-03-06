clc; clear variables;

%% m sequence (LFSR)
pn0 = PNGenerator([3, 2], 0);
pn1 = PNGenerator([3, 1], 0);
figure(1);
subplot(131);
stem(cxcorr(pn0, pn0));
subplot(132);
stem(cxcorr(pn1, pn1));
subplot(133);
stem(cxcorr(double(pn0), double(pn1)));

%% Gold Code
PN0 = circshift(pn0, 0).*circshift(pn1, 5);
PN1 = circshift(pn0, 0).*circshift(pn1, 6);
PN0 = [1 1 1 1 1 1 1];
PN1 = [1 -1 1 -1 1 -1 1];
figure(2);
subplot(131);
stem(cxcorr(PN0, PN0));
subplot(132);
stem(cxcorr(PN1, PN1));
subplot(133);
stem(cxcorr(double(PN0), double(PN1)));
