% Set an initial guess and initialize a couple variables
x = [0;0;0]; % Initial guess
allx = []; % Here we will accumulate all our x estimates through iterations
allf = []; % Here we will accumulate all our f values through iterations
niter = 500; % Max number of iterations

% Pick an algorithm (1: SD, 2: CG, 3: Newton)
ALGO = 1;
switch ALGO
    case 1
        % Steepest descent with golden section search
          disp(['Algorithm = Steepest Descent'])
       for k=1:niter
            [f,g,H] = evalGradients(x);
            if norm(g)>1e-6
                d = -g;
                a0 = 0;
                b0 = 1;
                for kg=1:200
                    a1 = x + d*a0 + d*(b0-a0)*0.382;
                    b1 = x + d*a0 + d*(b0-a0)*0.618;
                    fa1 = evalGradients(a1);
                    fb1 = evalGradients(b1);
                    if fb1<fa1
                        a0 = a0 + 0.382*(b0-a0);
                    else
                        b0 = a0 + 0.618*(b0-a0);
                    end
                end
                alpha = (a0+b0)/2;
                allx = [allx,x];
                allf = [allf,f];
                x = x +alpha*d;
            end
        end
        
        [f,g,H] = evalGradients(x);
        allx = [allx,x];
        allf = [allf,f];    
        
    case 2
        
        % Conjugate Gradients
        disp(['Algorithm = Conjugate Gradients'])
        k=0;
        [f,g,Q] = evalGradients(x);
        allx = [allx,x];
        allf = [allf,f];    
        if norm(g)>1e-6
            d = -g;
            while k<=niter
                a = -(g'*d)/(d'*Q*d);
                x = x + a*d;
                [f,g,Q] = evalGradients(x);
                allx = [allx,x];
                allf = [allf,f];    
                if norm(g)>1e-6
                    b = (g'*Q*d)/(d'*Q*d);
                    d = -g + b*d;
                else
                    k=niter;
                end
                k=k+1;
            end
        end
        
        
        
    case 3
        % Newton's algorithm
        disp(['Algorithm = Newton'])
        for k=1:niter
            [f,g,H] = evalGradients(x);
            if norm(g)>1e-6
                allx = [allx,x];
                allf = [allf,f];
                x = x - inv(H)*g;
            end
        end
        
        [f,g,H] = evalGradients(x);
        allx = [allx,x];
        allf = [allf,f];
end

% Display results
fs = 18; % Font Size
figure(1); % Show values of x through the iterations
subplot(3,1,1);plot(0:(length(allf)-1),allx(1,:),'LineWidth',2); 
xlabel('Iteration','FontSize',fs),ylabel('x_1','FontSize',fs),set(gca,'FontSize',fs)
subplot(3,1,2);plot(0:(length(allf)-1),allx(2,:),'LineWidth',2); 
xlabel('Iteration','FontSize',fs),ylabel('x_2','FontSize',fs),set(gca,'FontSize',fs)
subplot(3,1,3);plot(0:(length(allf)-1),allx(3,:),'LineWidth',2); 
xlabel('Iteration','FontSize',fs),ylabel('x_3','FontSize',fs),set(gca,'FontSize',fs)
figure(2); % Show value of f through the iterations
plot(0:(length(allf)-1),allf,'LineWidth',3); xlabel('Iteration','FontSize',fs),ylabel('f(x)','FontSize',fs), set(gca,'FontSize',fs)
% Display final results (values of x and f(x))
disp(['Final value of x: (' num2str(allx(1,end).','%3.3f') ' , ' num2str(allx(2,end).','%3.3f') ' , ' num2str(allx(3,end).','%3.3f') ')'])
disp(['Final value of f(x): ' num2str(allf(end).','%3.3f') ])








