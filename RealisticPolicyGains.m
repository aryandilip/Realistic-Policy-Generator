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
        [s,r] = size(B);
        Modal_Gains_Equation = ModalControl(A,B);
        if r>1
            fprintf(2, 'Press any key to proceed ');
            pause;
            fprintf('\n');
            for i = 1:r-1                
                disp('The program will run for finding gains for other input(s) i.e. state variable');
                pause(4);                
                prompt = 'Input new Plant matrix or A matrix: ';
                A1 = input(prompt);
                prompt = 'input B Matrix: ';
                B1 = input(prompt);
                Modal_Gains_Equation_for_other_inputs = ModalControl(A1,B1);
            end
        else
            return
        end        
    case 'Optimal Control Theory'
        %% Asking user to input A and B matrix
        prompt = 'Input Plant matrix or A matrix: ';
        A = input(prompt);
        prompt = 'input B Matrix: ';
        B = input(prompt);
        Optimal_Feedback_Gains_Matrix = OptimalGainsCalculator(A,B);
    case 'Stop the program'
        return
end
