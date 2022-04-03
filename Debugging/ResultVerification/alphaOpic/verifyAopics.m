rng(4)
spd = rand(401,1);
wl = (380:1:780)';
Snest = channelPercentsToSPDNestedStruct(spd);
myAopics = struct2table(Snest.AOpics)

writetable( array2table([wl,spd]),'randTest.csv' );

spd2 = readtable('randTest.csv');
%%
K_D65_smlmelr = [0.8173, 1.4558, 1.6289, 1.3262, 1.4497];
myAopics{1,:}.*K_D65_smlmelr
%%
s.Power.s = spd;
sOut = spdToAlphaOpics(s)