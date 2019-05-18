function [inputvar, Gains, Modal_Control_Final_Result] = ModalGainsCalculator(V_choosen, InputPreferred, swap3, Ncount, output, p, uniq, siuniq)



%% Finding P Matrix corresponding to Jordan Block
value = 0;
if output == 1
    value = 0;
else
    for i = 1:output-1
        value = value + Ncount(i,1);
    end
end
P = p(value+1:value + Ncount(output,1), InputPreferred)
[SizeOfRow, swap4] = size(P);
P_main = zeros(SizeOfRow);

%To find the v gains matrix
V_gains = V_choosen(value + 1: value + Ncount(output,1), value + 1: value + Ncount(output,1))
%------------------------------%

for i =1:SizeOfRow
    for j = i:SizeOfRow
        P_main(i,j-i+1) = P(j,1);
    end
end
P_main

%% Ask user for the input variable they will be using for input;
inputvar = sym('inputvar%d', [1 Ncount(output,1)]);
eigenvalueinputvar = zeros(1, Ncount(output,1));
for i = 1:Ncount(output,1)
    
    disp(['Enter the input variable you are using for the mode [' num2str(i) '] of the jordan block and its corresponding Eigenvalue '])
    fprintf(2, 'Press Enter ')
    pause
    prompt = {'Input Variable','EigenValue of Input Variable', 'Desired EigenValue of Input Variable'};
    dlgtitle = 'Input';
    dims = [1 100];
    definput = {'OBL','0', '-1.25'};
    inputanswer = inputdlg(prompt,dlgtitle, dims, definput);
    inputvar(1,i) = inputanswer(1,1);
    eigenvalueinputvar(1,i) = str2double(inputanswer(2,1));
    DesiredEignValue(i,1) = str2double(inputanswer(3,1));
    fprintf(1, '\n');
    fprintf(1, '\n');
    
end
% % inputvar
% % eigenvalueinputvar
% % DesiredEignValue

%% R Matrix    
R = zeros(SizeOfRow);
for i = 1:SizeOfRow
    MultiplyingValue = 1;
    for j = 1:SizeOfRow
        
        R(i,j) = 1/(MultiplyingValue*(DesiredEignValue(i,1) -eigenvalueinputvar(1,i)));
        MultiplyingValue = MultiplyingValue*(DesiredEignValue(i,1) -eigenvalueinputvar(1,i));
    end
end
R

%% K matrix
I = ones(SizeOfRow,1);
K = P_main^(-1)*R^(-1)*I

%% Gains corresponding to Input Variables
Gains = (K')*V_gains;
disp(['The Input Variables and the corresponding Modal Gains are: ']);
fprintf('\n')
disp(inputvar); 
disp(Gains);
ModalControlFinalResult = Gains*(inputvar.');
Modal_Control_Final_Result = vpa(ModalControlFinalResult);