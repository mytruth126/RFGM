clear;clc;close all
global error_style
Y=[889.7
1077.9
1117.2
];
Y1=[957.1547175	1018.299267	953.4940628	937.0406189	971.4332012	957.6836409	1008.406518	1019.071572
1015.030926	1106.276073	1003.004422	973.2772145	1034.255687	1012.52282	1091.209716	1107.066565
1075.91851	1201.853707	1051.884989	1005.144988	1099.76134	1068.53677	1180.812125	1202.659767
];
error_style='MAPE';
for i=1:size(Y1,2)
mape(i)=calculate_error(Y,Y1(:,i));
end
error_style='MAE';
for i=1:size(Y1,2)
mae(i)=calculate_error(Y,Y1(:,i));
end
error_style='RMSE';
for i=1:size(Y1,2)
rmse(i)=calculate_error(Y,Y1(:,i));
end
error=[mape*100;rmse]
