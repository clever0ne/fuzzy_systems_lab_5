%   ���������� ������� ��������� ������
%   � ������ ��������� ������                           (LR_5_KomSintFIS.m)
%==========================================================================
clear all       % ������� ������ (leaving the workspace empty)
clc             % ������� ���������� ����  (Clear Command Window) 
%--------------------------------------------------------------------------
%  ����� ������������� � ������ ��������� ������ ������� ��������� ������,
%  ������� ����� (LR_1) ���� ������� � ����� GUI Fuzzy Logic Toolbox 
%  � ��������� �� ����� ��� ������ firstM.fis
% ---------------------------------------
% fuzzy
fis = readfis('firstM');        % �������� �������� ������� � �����
% fuzzy(fis)
% getfis(fis);
% showfis(fis);
% -------------------------------------------------------------------------
% ���������� ������� ��ר����� ������

fisK = newfis('firstMK');       % ����.����� ���.���.���. � ������ 'firstMK'

fisK.input(1).name = 'x1';      % ��� ������ ������� ����������
fisK.input(1).range = [-7 3];   % ������� ������ ������� ����������

fisK.input(1).mf(1).name = '������';        % ��� ����.�����.����. ����.��.�����.
fisK.input(1).mf(1).type = 'trimf';         % ��� ����.�����.����. ����.��.�����.
fisK.input(1).mf(1).params = [-11 -7 -3];	% ��������� ����.�����.����. ����.��.�����.

fisK.input(1).mf(2).name = '�������';       % ������ �����. ����. ����.��.�����.
fisK.input(1).mf(2).type = 'trimf';         
fisK.input(1).mf(2).params = [-6 -2 2];

fisK.input(1).mf(3).name = '�������';       % ������ �����. ����. ����.��.�����.
fisK.input(1).mf(3).type = 'trimf';         
fisK.input(1).mf(3).params = [-1 3 7];

fisK.input(2).name = 'x2';      % ������ ������� ����������
fisK.input(2).range = [-4.4 1.7];   

fisK.input(2).mf(1).name = '������';        
fisK.input(2).mf(1).type = 'trimf';         
fisK.input(2).mf(1).params = [-6.84 -4.4 -1.96];	

fisK.input(2).mf(2).name = '�������';       
fisK.input(2).mf(2).type = 'trimf';         
fisK.input(2).mf(2).params = [-3.79 -1.35 1.09];

fisK.input(2).mf(3).name = '�������';       
fisK.input(2).mf(3).type = 'trimf';         
fisK.input(2).mf(3).params = [-0.74 1.7 4.14];

fisK.output(1).name = 'y';      % �������� ���������� 
fisK.output(1).range = [-50 50];  

fisK.output(1).mf(1).name = '������';        
fisK.output(1).mf(1).type = 'gaussmf';         
fisK.output(1).mf(1).params = [10.62 -50];	

fisK.output(1).mf(2).name = '������������';        
fisK.output(1).mf(2).type = 'gaussmf';         
fisK.output(1).mf(2).params = [10.62 -25];	

fisK.output(1).mf(3).name = '�������';        
fisK.output(1).mf(3).type = 'gaussmf';         
fisK.output(1).mf(3).params =  [10.62 -2.22e-16];
fisK.output(1).mf(4).name = '������������';        
fisK.output(1).mf(4).type = 'gaussmf';         
fisK.output(1).mf(4).params = [10.62 25];	

fisK.output(1).mf(5).name = '�������';        
fisK.output(1).mf(5).type = 'gaussmf';         
fisK.output(1).mf(5).params = [10.62 50];	

% ����� ���� ������
fisK.rule(1).antecedent = [1 1];   % ���.����.����.: ���.�����.����.��.�����.
fisK.rule(1).connection = 1;       % �����.����.����.����.: 1-AND, 2-OR
fisK.rule(1).consequent = [5];     % ����.����.����.: ���.���.����.���.�����.
fisK.rule(1).weight = 1;           % ��� ������� �������

fisK.rule(2).antecedent = [1 2];   % ������ �������
fisK.rule(2).connection = 1;       
fisK.rule(2).consequent = [1];     
fisK.rule(2).weight = 1;           

fisK.rule(3).antecedent = [1 3];   % 3 �������
fisK.rule(3).connection = 1;       
fisK.rule(3).consequent = [5];     
fisK.rule(3).weight = 1;           

fisK.rule(4).antecedent = [2 0];   % 4 �������
fisK.rule(4).connection = 1;       
fisK.rule(4).consequent = [3];     
fisK.rule(4).weight = 1;           

fisK.rule(5).antecedent = [3 1];   % 5 �������
fisK.rule(5).connection = 1;       
fisK.rule(5).consequent = [4];     
fisK.rule(5).weight = 1;           

fisK.rule(6).antecedent = [3 2];   % 6 �������
fisK.rule(6).connection = 1;       
fisK.rule(6).consequent = [2];     
fisK.rule(6).weight = 1;           

fisK.rule(7).antecedent = [3 3];   % 7 �������
fisK.rule(7).connection = 1;       
fisK.rule(7).consequent = [4];     
fisK.rule(7).weight = 1;           

% ---------------------------------------
writefis(fisK,'firstMK')    % ���������� ������������� FIS �� �����
% fuzzy(fisK)
% -------------------------------------------------------------------------
% ��������� ���� ������ ��ר����� ������ (�������� ������������)

n = 15;         % ���������� ����� �������������
x1 = linspace(-7,     3, n);
x2 = linspace(-4.4, 1.7, n);

yM  = zeros(n, n);
yMK = zeros(n, n);
for i = 1:n
    yM(i,:)  = evalfis([x1; ones(size(x1))*x2(i)], fis);   
    yMK(i,:) = evalfis([x1; ones(size(x1))*x2(i)], fisK);  
end  

% ---------------------------------------
h1 = figure(1);
set(h1,'Position',[13   553   524   407])
surf(x1, x2, yM)
axis([-10     5 ...
      -6	2 ...
      -50   50]); 
view(-40,30)
xlabel('x_1');   ylabel('x_2');   zlabel('y');
title('�������� ������� ��������� ������ ������� - firstM.fis') 

h2 = figure(2);
set(h2,'Position',[539   553   524   407])
surf(x1, x2, yMK)
axis([-10     5 ...
      -6	2 ...
      -50   50]); 
view(-40,30)
xlabel('x_1');   ylabel('x_2');   zlabel('y');
title('��������� � ������ ��������� ������ FIS - firstMK.fis') 

% ---------------------------------------
% ������������ ���������� ��������� �������� FIS

maxER = max(max(yM-yMK));

disp(' ')
disp('����. ����. ������ ��������. � ������ ���.���. FIS �� ��������:')
disp([' maxER = ',  num2str(maxER)])
disp(' ')
% -------------------------------------------------------------------------





