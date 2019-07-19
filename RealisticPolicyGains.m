Which_Control_Theory = questdlg('Which Control theory you want to use for determining Gains? ', 'Gains Calculator', 'Modal Control Theory', 'Optimal Control Theory', 'Stop the program', 'Modal Control Theory');
%Handle response%
switch Which_Control_Theory
    case 'Modal Control Theory'
        disp('The V-Matrix is. ')
        %% Asking user to input A and B matrix
        prompt = 'Input Plant matrix or A matrix: ';
        A = input(prompt);
        prompt = 'input B Matrix: ';
        B = input(prompt);
        e = eig(A)
        [s,r] = size(B);
        Modal_Gains_Equation = ModalControl(A,B,e);
        if r>1
            fprintf(2, 'Press any key to proceed ');
            pause;
            fprintf('\n');
            for i = 1:r-1       
                fprintf('The new Plant matrix A1 is: ');
                A1 = [-1.2462 -3.74 -1.1335 -3.4018 -2.2683 -3.75 -4.6520 -1.8750; 0.2492 0.9480 0.2267 0.6804 0.4537 0.75 0.925 0.375; -0.04 0.08 0.2 0 0 0 0 0; 0 0 0 0.2 0 0 0 0; 0 0 0 0 0 0 0 0.75; -1.2462 -3.75 -1.1335 -3.4018 -2.2683 -3.6 -4.625 -1.875; 0 0 0 0 0 0.75 -0.75 0; 0 0 0 0 0 0 0.75 -0.75]
                B1 = [1 -1 ; -0.2 0; 0 0 ;0 0 ; 0 0; 1 0; 0 0 ; 0 0];
                fprintf('The eigenvalues of the new plant matrix are: ')
                e1 = [-2.3+0.6966i; -2.3-0.6966i; -0.6344; -0.23; 0; 0.2; 0.2; 0.2]
                disp('The program will run for finding gains for other input(s) i.e. state variable');
                fprintf(2, 'Press any key to proceed ')
                pause;   
                
%                 prompt = 'Input new Plant matrix or A matrix: ';
%                 A1 = input(prompt);
%                 prompt = 'input B Matrix: ';
%                 B1 = input(prompt);
                Modal_Gains_Equation_for_other_inputs = ModalControl(A1,B1,e1);
            end
        else
            return
        end   
        fprintf(2, 'The program ran successfully  ');
        fprintf('\n');
    case 'Optimal Control Theory'
        %% Asking user to input A and B matrix
        prompt = 'Input Plant matrix or A matrix: ';
        A = input(prompt);
        prompt = 'input B Matrix: ';
        B = input(prompt);
        Optimal_Feedback_Gains_Matrix = OptimalGainsCalculator(A,B);
        fprintf(2, 'The program ran successfully  ');
        fprintf('\n');
    case 'Stop the program'
        fprintf(2, 'The program has stopped  ');
        fprintf('\n');
        return
end
