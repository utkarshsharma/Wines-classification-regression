function label = ourkmeans(X)
% Perform k-means clustering.
%   X: d x n data matrix
%   k: number of seeds
% Written by Michael Chen (sth4nth@gmail.com).
n = size(X,2);
last = 0;
label = floor(2*rand(1,n));  % random initialization
while any(label ~= last)
    E = sparse(1:n,label,1,n,2,n);  % transform label into indicator matrix
    m = X*(E*spdiags(1./sum(E,1)',0,2,2));    % compute m of each cluster
    last = label;
    [~,label] = max(bsxfun(@minus,m'*X,dot(m,m,1)'/2),[],1); % assign samples to the nearest centers
end