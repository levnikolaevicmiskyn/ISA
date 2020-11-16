%% Retiming algorithm
% This script finds a solution to the retiming problem by means of an
% auxiliary constraint graph
% Usage: Each inequality in the form
% r(i) - r(j) + d(ij) >= C(ij)
% is added to the system by adding 
% - a row (i,j) in the edges matrix
% - d(ij) in the corresponding index in vector D
% - C(ij) in the vector C0

%% Step 1: Build the inequality matrix
N=7; % Number of nodes (operators)
% edges is a Nx2 matrix containing the list of directed edges where (i;j)
% corresponds to edge i->j
edges = [1 8; 2 8; 2 1; 3, 2; 3, 4; 4, 3; 5, 3; 6, 3; 7, 5; 7, 6];

Delta=3; % Number of pipeline stages

% The number of registers (delays) on each edges are listed in vector D
D = [Delta, Delta, 1, 0, 0, 2, 0, 1, 0, 0]';

E=size(edges, 1);
% Omega is one if the path containing two adders is considered critical and
% zero otherwise.
omega = 1;
C0 = [0, 0, 1, omega, 1, 1, 1, 1, 1, 1]';

W = D-C0; % Weights
%% Step 2: Build the constraint graph
% Adjacency matrix
M=Inf*ones(N+1, N+1);
for ii = 1:size(edges, 1)
    M(edges(ii,1), edges(ii,2)) = W(ii);
end
M(N+1, 1:N) = 0;

%% Step 4: Run Floyd Warshall algorithm on the constraint graph
M={M};
for ii = 1:N+1
    Mp = Inf*ones(N+1, N+1);
    for vv=1:N+1
        for uu = 1:N+1
            Mp(uu,vv)=M{ii}(uu,vv);
            if Mp(uu,vv) > M{ii}(uu,ii) + M{ii}(ii,vv)
                Mp(uu,vv) = M{ii}(uu,ii) + M{ii}(ii,vv);
            end
        end
    end
    M{ii+1} = Mp;
    if any(diag(Mp) < 0)
        % If any of the diagonal elements in matrix Mp is negative, there
        % is a negative cycle and this algorithm fails to find a solution
        disp(['Negative cycle ' int2str(ii+1)])
    end
end

%% Solution
M{end}(end, 1:N)