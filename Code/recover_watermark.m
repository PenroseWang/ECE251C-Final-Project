%% Recover Watermark
M = size(lena,1);

[LL_wm, LH_wm, HL_wm, HH_wm] = haart2(lena_wm,1);
[~,S1_wm,~] = svd(LH_wm);
[~,S2_wm,~] = svd(HL_wm);

D1 = U1_W*S1_wm*V1_W';
D2 = U2_W*S2_wm*V2_W';

W1_rec = (D1-S1)/alpha;
W2_rec = (D2-S2)/alpha;

watermark_rec = W1_rec + W2_rec;

figure
colormap gray
imagesc(watermark_rec);