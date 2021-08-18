function [] = GradientDescent(x0, y0, alpha, local)
    %% Function Definition

    syms x y
    f = @(x,y) 3.*((1-x).^2).*exp(-((x).^2)-(y+1).^2) - ...
        10.*((x./5)-(x.^3)-(y.^5)).*exp(-(x.^2)-(y.^2)) - ...
        (1/3).*exp(-((x+y).^2)-(y.^2));
    
    %% Derivatives and Constants
    
    % 1st Derivatives
    d_x = eval(['@(x,y)' char(diff(f,x))]);
    d_y = eval(['@(x,y)' char(diff(f,y))]);
    % 2nd Derivatives
    d_x_2 = eval(['@(x,y)' char(diff(f,x,2))]);
    d_y_2 = eval(['@(x,y)' char(diff(f,y,2))]);
    d_x_y = eval(['@(x,y)' char(diff(d_x,y))]);
    d_y_x = eval(['@(x,y)' char(diff(d_y,x))]);

    % Domain
    xD = -3:0.1:3;
    yD = -3:0.1:3;

    % Plot of the objective funtion
    [X,Y] = meshgrid(xD,yD);
    F = f(X,Y);
    surfc(X,Y,F)
    hold on

    %% Constraints
    tol = 1e-6;
    maxIter = 5000;
    count = 0;
    next = [x0; y0];
    grad = [d_x(x0,y0); d_y(x0,y0)];

    %% Find Critical Point and Plot

    % Plot the initial guess
    plot3(next(1), next(2), f(next(1),next(2)), 'mo', 'MarkerSize', 8, 'LineWidth', 2);

    % Start iteration
    while (abs(grad(1)) >= tol && abs(grad(2)) >= tol) ...
            && (abs(next(1)) <= 3 && abs(next(2)) <= 3)

        count = count + 1;
        grad = [double(d_x(next(1),next(2))); double(d_y(next(1),next(2)))];

        % Check if maximum iterations is reached
        if (count > maxIter)
            disp('Maximum Iterations exceeded!')
            break
        else
            % Check for gradient descent or ascent
            if strcmp(local, 'min')
                next = next - alpha*(grad);
            elseif strcmp(local, 'max')
                next = next + alpha*(grad);
            else 
                error("Please enter max or min only");
            end
        end
        
        % Plot each entry for visualization
        plot3(next(1), next(2), f(next(1),next(2)), 'ro', 'MarkerSize', 8, 'LineWidth', 2); 
    end

    % Hessian Matrix and the determinant
    Hess = [double(d_x_2(next(1),next(2))), double(d_x_y(next(1),next(2))); ...
        double(d_y_x(next(1),next(2))), double(d_y_2(next(1),next(2)))];
    detHess = det(Hess);

    %% Determine Case
    disp("Initial guess: ");
    disp([x0;y0]);
    if detHess < 0
        disp("Saddle at: ");
        disp(next);
    elseif detHess == 0
        disp("Inconclusive");
    else
        if double(d_x_2(next(1),next(2))) > 0
            disp("Local min at: ");
            disp(next);
        else
            disp("Local max at: ");
            disp(next);
        end
    end
    disp("Steps to convergence: ");
    disp(count);
end