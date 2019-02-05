% Create some true signal
N = 128;
im = phantom(N);
xtrue = im(end/2,:).'; %Take a slice halfway through and transpose;

% Generate Fourier samples of this signal (dtrue = fftshift(fft(ifftshift(xtrue)));)
A = dftmtx(N)/sqrt(N); % DFT matrix, normalized
A = fftshift(ifftshift(A,1),2); % Apply FFTSHIFTS, just for visualization
A = [real(A);imag(A)]; % Separate the real and imaginary components
dtrue = A*xtrue;

% Add some noise
sigma = 0; % 0 -> Noiseless case
dnoisy = dtrue + sigma*randn(size(dtrue));

% Solve basic linear system
xhat_direct = A\dnoisy;

% Solve the constrained problem min || Ax - d ||_2^2 such that ||x||_2^2<c
c = 4;
fun = @(x)norm(A*x-dnoisy)^2;
x0 = zeros(size(xtrue));
xhat_constr = fmincon(fun,x0,[],[],[],[],[],[],@(x)normconstraint(x,c));


% Solve the unconstrained problem min || Ax - d ||_2^2 + lambda*||x||_2^2
lambdas = [0.1,0.4,1:6];
for kl = 1:length(lambdas)
    lambda = lambdas(kl);
    fun = @(x)(norm(A*x-dnoisy)^2 + lambda*norm(x)^2);
    x0 = zeros(size(xtrue));
    xhat_unc(:,kl) = fminunc(fun,x0);
    legend_text{kl} = ['lambda = ' num2str(lambda)];
end

% Display some results
subplot(1,2,1);
plot(1:N,xhat_direct,'b--','LineWidth',1);hold on
plot(1:N,xhat_constr,'k','LineWidth',2);hold off
axis([1,  N, -0.1, 1.1]); 
legend0_text{1} = 'Direct solution';
legend0_text{2} = ['Constrained c = ' num2str(c)];
legend(legend0_text,'Location','North');
title('Direct and constrained solutions')
set(gca,'FontSize',14)

subplot(1,2,2);
plot(1:N,xhat_unc,'LineWidth',2);
axis([1,  N, -0.1, 1.1]); 
legend(legend_text,'Location','North');
title('Unconstrained solutions')
set(gca,'FontSize',14)

