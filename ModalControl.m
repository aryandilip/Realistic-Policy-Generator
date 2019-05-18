function [ModalControlResults] = ModalControl(A,B)

% %% Asking user to input A and B matrix
% prompt = 'Input Plant matrix or A matrix: ';
% A = input(prompt);
% prompt = 'input B Matrix: ';
% B = input(prompt);

%% Calculations for Jordan Matrix Starts
[x y] = size(A);
v = sym('v%d%d', [x x]);
%Determining transpose of matrix A%
AT = transpose(A);
%Eigen Values of matrix A%
e = eig(A);
E = real(e)

%% Sorting the eigen values of matrix A in descending order for creating jordan blocks
Srt = sort(E);
size(Srt);
%-------------------------------------------------------%
%% Algorithm to sort the jordon blocks based on the increasing order of matrix size

uniq = unique(Srt);
[siuniq, swap] = size(uniq);    %%Determining the number of unique eigenvalues
siuniq;
Ncount = histc(Srt, uniq)    %%The number of repeatition for each unique eigenvalue.
[SizeNcount, swap2] = size(Ncount)
% % % % % nulljordansort = zeros(x,1);
% % % % % jordonsortnullvalue = 0;
% % % % % 
% % % % % for i=1:siuniq-1
% % % % %     
% % % % %         if Ncount(i,1) >= Ncount(i+1,1)
% % % % %             for k = 1:Ncount(i+1,1)
% % % % %                 nulljordansort(k + jordonsortnullvalue,1) = uniq(i+1,1);
% % % % %             end
% % % % %             jordonsortnullvalue = jordonsortnullvalue + Ncount(i+1,1);
% % % % %   
% % % % %             for k = 1:Ncount(i,1)
% % % % %                 nulljordansort(k + jordonsortnullvalue,1) = uniq(i,1);
% % % % %             end
% % % % %             Ncount([i i+1]) = Ncount([i+1 i]);
% % % % %             uniq([i i+1]) = uniq([i+1 i]);
% % % % %             
% % % % %         else
% % % % %              for k = 1:Ncount(i,1)
% % % % %                 nulljordansort(k + jordonsortnullvalue,1) = uniq(i,1);
% % % % %              end
% % % % %              for k = 1:Ncount(i+1,1)
% % % % %                 nulljordansort(k + jordonsortnullvalue,1) = uniq(i+1,1);
% % % % %             end
% % % % %              jordonsortnullvalue = jordonsortnullvalue + Ncount(i,1);
% % % % %         end
% % % % % end
% % % % % Srt = nulljordansort
% % % % % Ncount
% % % % % unique_after = unique(Srt);






%-------------------------------------------------------%
%finding same eigen values for jordon block
uniq;
%substituting values of eignevalues on diagonal positions%
J = zeros(x);
    for j = 1:x
        J(j,j) = Srt(j,1);
    end
%check if the substitution was successful
J;
%making a null variable so that 1 is positioned just on the subdiagonal
%matrix of joran matrix rather that the whole matrix J
Null = 0;
Ncount;
%substiuting 1 at the subdiagonal of respective jordan matrices%
for i = 1:siuniq
   for j = 1:Ncount(i,1)-1
       J(Null+j,Null+j+1) = 1;
   end
   Null = Null+Ncount(i,1); 
end
%check if the substitution was successful
J
%Determining transpost of J matrix
JT = transpose(J);
%To calculate modal matrix v, we have to compute AT*v = v*JT, computing
%leftside and right side differently, we get:
left_side = AT*v;
%vpa is used to to approximate the symbolic expression to decimal form
leftside = vpa(left_side);
right_side = v*JT;
%vpa is used to to approximate the symbolic expression to decimal form
rightside = vpa(right_side);
%bringing rightside to the leftside, the equation will be net = 0
net = leftside-rightside;
RES = zeros(x,1);
%numeric::solve(net = RES , v)
xsqr = x^2;
eqn = sym('eqn', [1 xsqr]);
eqn(1,1);
k = 0;
bnull = 0;
for i = 1:x
    for j = 1:x
        eqn(1,j + bnull) = net(i,j) == 0;
    end
    bnull = bnull+x;
end
eqn_original = eqn; %for testing only

fid = fopen('Equations.txt', 'wt');

for i=1:xsqr
    fprintf(fid, '%s\n', char(eqn(1,i)));
    fprintf(fid, '\n');
end
    

fclose(fid)


eqn(1,10); %for testing only


%This solution is not accurate as it assumes two equal variables as zero
[F, G] = equationsToMatrix([eqn(1,:)], v(:));


L = linsolve(F, G);

V = zeros(x);
vnull = 0;

for i=1:x
    for j = 1:x
        V(i,j) = L(j+vnull,1);
    end
    vnull = vnull + x;
end
V;
disp('The v matrix obtained from the above algorithm is not recommended for finding mode controllability matrix as it tries to use trivial solutions for the equations.')
disp('It is recommended to calculate v-matrix by hand')
fprintf('\n')
fprintf('\n')
fprintf(2, 'Press any key to proceed ')
pause

fprintf('\n')
fprintf('\n')

vmatrix_answer = questdlg('Do you want to proceed with the V-Matrix suggested by the algorithm?', 'V-Matrix', 'yes', 'Manually write the vmatrix', 'Stop the program', 'Manually write the vmatrix');
%Handle response%
switch vmatrix_answer
    case 'yes'
        disp('The V-Matrix is. ')
        V_choosen = V;
    case 'Manually write the vmatrix'
        disp('The equations are given below for manual solving')
        eqn
        prompt = 'Enter the manually calculated v-matrix: ';
        fprintf('\n')
        V_byhand = input( prompt );
        fprintf('\n')
        V_choosen = V_byhand;
    case 'Stop the program'
        return
end

fprintf(2, 'Press any key to proceed ')
pause
fprintf('\n')
fprintf('\n')
fprintf('The mode controllability matrix p given by Transpose(V)*B is: ');
p= transpose(V_choosen)*B

[swap3, NumberOfInputs] = size(p);    %To determine the number of inputs in the system which might be controlled.

disp('The order of jordan Block is given below'); disp(Ncount)

%% Creating a loop statement to show the different mode controllability matrix for different Jordon Blocks
%-----------------------------%

NullForDistinguishingJordonBlocks = 0;

for i = 1:siuniq
    disp(['Block [' num2str(i) '] is shown below:']);
    TemporaryUseOfJordanBlock = p(NullForDistinguishingJordonBlocks + 1: NullForDistinguishingJordonBlocks + Ncount(i,1), 1:NumberOfInputs);
    disp(TemporaryUseOfJordanBlock)
    NullForDistinguishingJordonBlocks = NullForDistinguishingJordonBlocks + Ncount(i,1);
end
pause(2)

%-----------------------------%
%% Finding which jordon block can control the inputs  
for i = 1:NumberOfInputs
    NullForControllabilityCheck = 0;
    for j = 1:siuniq
        
        
            NonZero = all(p(NullForControllabilityCheck+1:NullForControllabilityCheck+Ncount(j,1),i));
            NonZeroMinusOne = all(p(NullForControllabilityCheck+1:NullForControllabilityCheck+Ncount(j,1)-1,i));
            if NonZero == 1
            disp(['Block [' num2str(j) '] of the Jordon Matrix is controllable by input [' num2str(i) '], i.e. colummn [' num2str(i) '] of the mode controllability matrix p.']);
            elseif (NonZero == 0) && (NonZeroMinusOne == 1)
                disp(['Block [' num2str(j) '] of the Jordon Matrix is partially controllable by input [' num2str(i) '], i.e. colummn [' num2str(i) '] of the mode controllability matrix p.']);
            else
                fprintf(['Block [' num2str(j) '] of the Jordon Matrix is ']);fprintf(2, 'not controllable '); disp([' by input [' num2str(i) '], i.e. colummn [' num2str(i) '] of the mode controllability matrix p.']);
            end
        
    NullForControllabilityCheck = NullForControllabilityCheck + Ncount(j,1);
    end
    fprintf('\n')
end

fprintf(2, 'Press any key to proceed ')
pause
fprintf('\n')
fprintf('\n')

% % %Just for testing again
% % %please remove me-----------------%
% % V_choosen;
% % %  -----------------------------%
% % % Block = sym('Block', [1 siuniq]);
% % % %%Asking user to select the jordon blocks to be used for controlling the
% % % %%respective input(policy variable) i.e. column
% % % Block;
% % % Block_string = char(Block);
% % % % str = ["Block1", "Block2", "Block3"];


%% Creating an Input dialog box to determine which jordan block is to be controlled by which input

prompt = {'Which input (i.e. column of matrix-p) to be used for determining control gains ','Enter the jordan block to be controlled by input', 'if another jordan block is to be controlled (enter 0 if not)'}; %Enter 0 if not
dlgtitle = 'Jordan Block Stability';
dims = [1 100];
definput = {'1','3', '0'};
JordanBlockSTABILITY = inputdlg(prompt,dlgtitle,dims,definput);
InputPreferred = str2double(JordanBlockSTABILITY(1,1));
output = str2double(JordanBlockSTABILITY(2,1));

%% Providing inputs to JordanBlockStability function and determining the gains equation

[inputvar, Gains, Modal_Control_Final_Result] = ModalGainsCalculator(V_choosen, InputPreferred, swap3, Ncount, output, p, uniq, siuniq);
fprintf('\n')
fprintf('\n')
fprintf(2, 'Press any key to proceed ')
pause
fprintf('\n')
fprintf('\n')

%% Determining if the user has asked for another jordan block to be controlled for a particular input
IfAny = str2double(JordanBlockSTABILITY(3,1));

if IfAny == 0
    ModalControlResults = Modal_Control_Final_Result;
    disp('The Modal Feedback Gains Equation is: ');
    disp(ModalControlResults);
    
elseif IfAny > 0
    disp('The program will now determine gains for the other Jordan Block')
    other_output = IfAny;
    [other_inputvar, other_Gains, other_Modal_Control_Final_Result] = ModalGainsCalculator(V_choosen, InputPreferred, swap3, Ncount, other_output, p, uniq, siuniq);
    fprintf('\n')
    fprintf('\n')
    disp('The Gains equation from other Jordan Block is: ')
    disp(other_Modal_Control_Final_Result)
    fprintf('\n')
    fprintf('\n')
    disp('The combined gains equations will then be: ')
    Combined_equation = Modal_Control_Final_Result + other_Modal_Control_Final_Result;
    %Making a input statemnent asking user if any other jordan block is to
    %be controlled
    extrauniq = siuniq-2;
    if extrauniq > 0
        
        for i = 1:extrauniq
            prompt = 'Is there any other Jordan Block to be controlled by the input:  {yes/no}'
            another_jordan_block = input(prompt, 's');
            
            if strcmp(another_jordan_block,'yes')                
                prompt = 'Enter the Block number of the Jordan Block';
                another_output = input(prompt);
                [another_inputvar, another_Gains, another_Modal_Control_Final_Result] = ModalGainsCalculator(V_choosen, InputPreferred, swap3, Ncount, another_output, p, uniq, siuniq);
                fprintf('\n')
                fprintf('\n')
                disp('The Gains equation from other Jordan Block is: ')
                disp(another_Modal_Control_Final_Result)
                fprintf('\n')
                fprintf('\n')
                disp('The combined gains equations will then be: ')
                Combined_equation = Combined_equation + another_Modal_Control_Final_Result;
                
            elseif strcmp(another_jordan_block, 'no')
                break               
            end
        end
        
    end
    ModalControlResults = Modal_Control_Final_Result;
    disp('The net Modal Feedback Gains Equation is: ');
    disp(ModalControlResults);
    
else
    disp('The program will now determine gains for the other Jordan Block')
    fprintf(2, 'ERROR: Only Non-Negative inputs are allowed ')
end