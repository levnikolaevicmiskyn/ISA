% This script finds a solution to the retiming problem by means of an
% auxiliary constraint graph

%% Step 1: Build the inequality matrix
N=7; % Number of nodes
edges = [1 8; 2 8; 2 1; 3, 2; 3, 4; 4, 3; 5, 3; 6, 3; 7, 5; 7, 6];
Delta=2; % Number of pipeline stages
D = [Delta, Delta, 1, 0, 0, 2, 1, 2, 0, 0]'; % Delay list

E=size(edges, 1);
%A=zeros(E, N+1);
%A(edges(:, 1)) = -1;
%A(edges(:, 2)) = 1;
%A=A(E, 1:N);
omega = 1;
C0 = [0, 0, 1, omega, 1, 1, 1, 1, 1, 1]';
W = D-C0; % Weights
%% Build the constraint graph
% Adjacency matrix
M=Inf*ones(N+1, N+1);
for ii = 1:size(edges, 1)
    M(edges(ii,1), edges(ii,2)) = W(ii);
end
M(N+1, 1:N) = 0;

%% Run Floyd Warshall algorithm
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
        disp(['Negative cycle ' int2str(ii+1)])
    end
end

%% Solution
M{end}(end, 1:N)