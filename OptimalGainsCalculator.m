function [F] = OptimalGainsCalculator(A1,B)
% A1 = [-1 0 0 0 0 0 0 0; 1 -1/8 0 0 0 0 0 0; 0 1/8 -0.5 0 0 0 0 0; 0 0 0.5 -1 0 0 0 0; 0 0 0 1 -1/1.4 0 0 0; 0 0 0 0 0 -1/3.5 0 0; 0 0 0 0 0  1/3.5 -0.5 0; 0 0 0 0 0 0 0 -1/1.4]; 
% B = [1 0 ; 0 0; 0 0 ;0 0 ; 0 0; 0 1; 0 0 ; 0 0]; 
% %% Asking user to input A and B matrix
% prompt = 'Input Plant matrix or A matrix: ';
% A1 = input(prompt);
% prompt = 'input B Matrix: ';
% B = input(prompt);

fprintf('\n')
%% Using the Riccati Equation and Finding the Solution
[l,m] = size(A1);
[n, o] = size(B);
Type_of_Weighting_Matrices = questdlg('Which Weighting criteria would you like to use for Q and R? ', 'Weighting Criterion', 'Unit Weighting', 'Variable Weighting', 'Stop the program', 'Unit Weighting');
switch Type_of_Weighting_Matrices
    case 'Unit Weighting'
    Q = eye(l);
    R = eye(o);
    case 'Variable Weighting'
    prompt = 'Enter the weights of Q corresponding to the input variable/level variables in (N X 1) form: ';
    Q_weights = input(prompt);
    prompt = 'Enter the weights of R corresponding to the policy variables in (N X 1) format: ';
    R_weights = input(prompt);
    Q = zeros(l);
    R = zeros(o);
    for i = 1:l
        Q(i,i) = Q_weights(i,1);
    end
    for i = 1:o
        R(i,i) = R_weights(i,1);
    end
    case 'Stop the program'
        return
end
X0 = eye(l);
[T X] = ode45(@(t,X)mRiccati(t, X, A1, B, Q, R), [0 100], X0);
X(100,:);
Y = zeros(l);
vnull = 0;

for i=1:l
    for j = 1:l
        Y(i,j) = X(100, j+vnull);
    end
    vnull = vnull + l;
end
% Y = [X(100,1:8);X(100,9:16);X(100,17:24);X(100,25:32);X(100,33:40);X(100,41:48);X(100,49:56);X(100,57:64)]; %arranging the equation in matrix form
F = -1*B.'*Y;
disp('The Feedback gain matrix is: ')
F

% obl =  sym('obl');
% asr =  sym('asr');
% aor =  sym('aor');
% apl =  sym('apl');
% inv =  sym('inv');
% l1 =  sym('l1');
% l2 =  sym('l2');
% l3 =  sym('l3');
% inputvar = [obl; asr; aor; apl; inv; l1; l2; l3];
% abcd = F*inputvar;
% abcde = vpa(abcd, 4)