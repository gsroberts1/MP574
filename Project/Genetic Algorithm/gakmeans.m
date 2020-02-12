function gakmeans

clc;close all; clear all;

% sds  - sampled dataset  
global sds;

[im,map]=imread('phant256noisy003Filt.png');
if ( size(im,3)==3)
 im=rgb2gray(im);
end

im=im2double(im);
[row,col]=size(im);
nc=5; %

L= row*col;
rns=(10/100)*L; 
rp=randperm(L);
sds=im(rp(1:rns));
sds=im(rp(1:7));

options=gaoptimset('PopulationSize',20,'PopulationType','doubleVector', ... 
                   'CrossoverFraction',0.7, 'Generations',100,'EliteCount',2, ...
                   'SelectionFcn', @selectionroulette,'CrossoverFcn',@crossoverarithmetic,...
                   'MutationFcn',@mutationadaptfeasible,'PlotFcns',@gaplotbestf) ;

               
% lower bound limit               
lb=zeros(nc,1);
% upper bound limit
ub=ones(nc,1);

[gics,gfv,exf] =ga(@objfunc,nc,[],[],[],[],lb,ub,[],options);

[idx,cs,egr]=kmeanseg(im,gics);
gsim=coloring(cs,idx);
gsim=reshape(gsim,row,col,3);

figure;
imshow(gsim);
title('GA-Kmeans');





function egr=objfunc(cs)

global sds
  nc = size(cs,2);
  [row,col]=size(sds);
  D=zeros(row,col,nc);
  % Euclidean distance between centroids and image's pixel 
  for c=1: nc 
    D(:,:,c)=   (sds - cs(c)).^2 ;     
  end        
 % assign members (image pixels) to clusters  
 [mv,~]=min(D,[],3);  
 egr=sum(mv(:));
 
 
function gsim=coloring(cs,idx)

nc = length(cs);
[~,ind]=sort(cs);
gidx=zeros(size(idx));

for s=1: nc
 gidx(idx==ind(s)) =s;   
end

colors = hsv(nc);
gsim= colors(gidx,:);




 
function [idx,cs,egr]=kmeanseg(im,cs)

%number of Iteration
T= 50; t=0; 

nc=length(cs);
[row,col]=size(im);
D=zeros(row,col,nc);

pcs=cs;
egr =[];
eps=1.e-8; cmx=1;

while ( t<T  && cmx>eps )   
                 
    % Euclidean distance between centroids and image's pixel 
    for c=1: nc 
      D(:,:,c)=   (im - cs(c)).^2 ;     
    end
            
    % assign members (image pixels) to clusters  
    [mv,idx]=min(D,[],3);
    
     % cluster centroid updation
    for c=1: nc 
      I = (idx==c);  
      cs(c) = mean( mean(im(I)) );    
    end
    
    % find if any member label changes between current and previous iteration     
     cmx = max( abs(cs-pcs) );
     pcs = cs;
         
     t= t+1;
     
    %sum difference between centroid and their members 
    % and store it for ploting energy minimization functions
    egr= [egr; sum(mv(:)) ];
                         
end
        
 