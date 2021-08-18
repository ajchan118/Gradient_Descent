function [] = Optimization()
% Determines the local max/min of the function given.
%% Plot
x = -3:1/10:3;
y = -3:1/10:3;
[Xf, Yf] = meshgrid(x, y);
func = (3.*(1-Xf).^2.*exp(-Xf.^2-(Yf+1).^2)) - ...
    10.*((Xf/5)-Xf.^3-Yf.^5).*exp(-Xf.^2-Yf.^2) - ...
    (1/3).*exp(-(Xf+Yf).^2-Yf.^2);
surfc(x(:), y(:), func);
hold on

%% Solving
% Function
syms f(X,Y)
f(X,Y) = (3.*(1-X).^2.*exp(-X.^2-(Y+1).^2)) - ...
    10.*((X/5)-X.^3-Y.^5).*exp(-X.^2-Y.^2) - ...
    (1/3).*exp(-(X+Y).^2-Y.^2);

% Differentials
dX = diff(f, X, 1);
dX2 = diff(f, X, 2);
dY = diff(f, Y, 1);
dY2 = diff(f, Y, 2);
dXY = diff(f, X, Y);

% Inputs
x0 = 1;
y0 = -1;
local = 'max'; % either max or min
step = 0.04;

% Conditions
next = [x0; y0];
grad = [1; 1]; % initialize gradient
tol = 1e-6; % emulate zero because gradient will never reach exactly 0.
count = 0; % number of takes to reach local max/min

% debug
% plot
plot3(next(1), next(2), f(next(1),next(2)), 'mo', 'MarkerSize', 8, 'LineWidth', 3);

% Find Local
while (abs(grad(1)) >= tol && abs(grad(2)) >= tol) ... % stop when it reaches "zero"
        && (abs(next(1)) <= 3 && abs(next(2)) <= 3) ... % prevent it going out of bounds
        && (count < 500) % prevent it from going on forever
    count = count + 1;
    grad = [double(dX(next(1),next(2))); ...
        double(dY(next(1),next(2)))];
    if strcmp(local, 'min')
        next = next - step*(grad);
    elseif strcmp(local, 'max')
        next = next + step*(grad);
    end
    % debug
    % disp(next);
    plot3(next(1), next(2), f(next(1),next(2)), 'ro', 'MarkerSize', 8, 'LineWidth', 2); 
end

Hess = [double(dX2(next(1),next(2))), double(dXY(next(1),next(2))); ...
    double(dXY(next(1),next(2))), double(dY2(next(1),next(2)))];
detHess = det(Hess);

% debug
% disp(Hess);

% Determine Case
if detHess < 0
    disp("Saddle at: ");
    disp(next);
    disp("Steps to convergence: ");
    disp(count);
elseif detHess == 0
    disp("Inconclusive");
else
    if double(dX2(next(1),next(2))) > 0
        disp("Local min at: ");
        disp(next);
        disp("Steps to convergence: ");
        disp(count);
    else
        disp("Local max at: ");
        disp(next);
        disp("Steps to convergence: ");
        disp(count);
    end
end

end