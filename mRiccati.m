function dXdt = mRiccati(t, X, A, B, Q, R)
[sa, ta] = size(A);
[sb, tb] = size(B);

X = reshape(X, sa,sa); %Convert from "n^2"-by-1 to "n"-by-"n"
dXdt = A.'*X + X*A - X*(B*(R^-1)*B.')*X + Q; %Determine derivative
dXdt = dXdt(:); %Convert from "n"-by-"n" to "n^2"-by-1