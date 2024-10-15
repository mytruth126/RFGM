clear;clc;close all
global X0 accumulation_method model_equation error_style n nf;

%% ��������
X=Input_data();
nf=ceil(numel(X)*0.3); %Ԥ������ֵ�ĸ���
X0=X(1:end-nf,:);
n=numel(X0);

%% ѡ��ģ�ͼ�����׼
accumulation_method='RF�ۼ�';    %��ѡ�� 'һ���ۼ�','�������ۼ�','CF�ۼ�','HF�ۼ�','NIP�ۼ�','�ڽ��ۼ�','�����ۼ�'
model_equation='��ͳGM(1,1)';       %��ѡ�� '��ͳGM(1,1)','DGM(1,1)','NDGM','Verhulst','��ɢVerhulst'
error_style='MAPE';         %��ѡ�� 'MAPE','MAE','RMSE','R2'
%% ������
[r]=PSO();
[MAPE,X0F]=GM(r);
disp('����ɹ�')

%% �������
MAPE=[calculate_error(X0,X0F(1:n,1)),calculate_error(X(n+1:end,1),X0F(n+1:end,1))]

%% ��ͼ
plot(X0);hold on;plot(X0F);


