%% 02/25/19: In class
x = [1 2 3 4]'; % original image
F = dftmtx(4); % Fourier matrix

x2 = F*x % FT of image

x2b = fft(x) % FT of image

% Start subsampling
A = [1 0 0 0;0 0 1 0]; % subsampling matrix
B = A*F; % composite matrix
d = B*x

% Subsample with the second approach
b2 = zeros(320,320); b2(m) = b;
D2 = kron(I,D) + kron(D,I)
x2b = fft(x);
mask = sum(A,1).'>0
db = x2b(mask)

%
y = B'*d
d2b = zeros(4,1);d2b(mask) = d;
N = 4; % scaling factor
yb = N*ifft(d2b)