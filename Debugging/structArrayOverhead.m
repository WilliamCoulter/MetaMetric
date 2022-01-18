clear
clc
% SArray = struct(3,3);
S.b = 1;
for i = 1:300
    for j = 1:300
        SArray(i,j).f1 = i*j;
        SArray(i,j).f2 = 1:99;
        SArray(i,j).f3 = {'test1','test2'};
    end
end
%%
bsMath = 0;
for count = 1:10000
    bsMath = bsMath + sum( (SArray(1,1).f1).* (SArray(1,1).f2) );
end