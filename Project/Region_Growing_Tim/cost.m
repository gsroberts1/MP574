% SUMMARY
% computes the cost of a specific segmentation based on the simplified 
% mumford shah functional
%
% INPUTS
% - f: segmentation
% - g: actual image
% - L: length of all regions in the segmentation
% - nu: edge weighting parameter
%
% OUTPUTS
% E: total energy
% data_term: data-regularization term
% edge_term: edge term

function [E,data_term,edge_term] = cost(f,g,L,nu)

data_term = norm(f-g);
edge_term = nu*L;

E = data_term + edge_term;

end

