clear;clc;close all
global X0 accumulation_method model_equation error_style n nf;

%% 导入数据
X=Input_data();
nf=ceil(numel(X)*0.3); %预测外推值的个数
X0=X(1:end-nf,:);
n=numel(X0);

%% 选择模型及误差标准
accumulation_method='RF累加';    %可选填 '一阶累加','分数阶累加','CF累加','HF累加','NIP累加','邻近累加','阻尼累加'
model_equation='传统GM(1,1)';       %可选填 '传统GM(1,1)','DGM(1,1)','NDGM','Verhulst','离散Verhulst'
error_style='MAPE';         %可选填 'MAPE','MAE','RMSE','R2'
%% 计算结果
[r]=PSO();
[MAPE,X0F]=GM(r);
disp('计算成功')

%% 计算误差
MAPE=[calculate_error(X0,X0F(1:n,1)),calculate_error(X(n+1:end,1),X0F(n+1:end,1))]

%% 画图
plot(X0);hold on;plot(X0F);


