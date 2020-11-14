clear all
close all

N = 5;

%% Determine dj
j = find(arrayfun(@(x) d(x), 1:N) >= N, 1, 'first');

n = zeros(j,2*N-1);
a = n;
b = n;
c = n;
n(j, :) = [1:N, flip(1:N-1)];

fid = fopen('decl.txt', 'w');

%% Iterate
for jj=flip(2:j-1)
    dj = d(jj);
    
    for ii = 1:2*N-1
        % Find number of available seats
        k = dj - n(jj,ii);
        if n(jj+1, ii) <= k
           a(jj+1,ii) = 0;
           b(jj+1,ii) = 0;
        elseif mod(n(jj+1,ii)-k,2) == 0
           a(jj+1,ii) = (n(jj+1,ii)-k)/2;
           b(jj+1,ii) = 0;
        else
            a(jj+1,ii) = floor((n(jj+1,ii)-k)/2);
            b(jj+1,ii) = 1;
        end
        c(jj+1,ii) = n(jj+1,ii)-3*a(jj+1,ii) - 2*b(jj+1,ii);
        n(jj,ii) = n(jj, ii) + a(jj+1, ii) + b(jj+1,ii) + c(jj+1, ii);
        n(jj,ii+1) = a(jj+1, ii) + b(jj+1,ii); % Carry
    end
    
%     for ii = 1:2*N-1
%         writesigdecl(n(jj,1:2*N-1), jj, ii, fid);
%     end
end 

fclose(fid);

n = n(:, 1:2*N-1);

function r = d(j)   
        if j > 1
            r = floor(3/2*d(j-1));
        else
            r = 2;
        end
end

% function writesigdecl(v, jj, col, fid)
%     makestr = (@(x) ['signal st' int2str(jj) 'col' int2str(col) ': std_logic_vector(' x ' downto 0);']);
%        
%     for ii=1:length(v)
%         fprintf(fid, '%s\n', makestr(int2str(v(ii)-1)));
%     end
%     fprintf(fid, '\n');
% end