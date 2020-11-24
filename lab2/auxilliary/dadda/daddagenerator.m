function [] = daddagenerator(N)
%N = 32;

%% Determine number of dots in each column (N even)
% Standard dots
ntmp = [floor(1:0.5:(N/2+0.5)), N/2+1, flip(floor(1.5:0.5:(N/2+0.5)))];
% Add sign extension bits
ntmp(N+2:end) = ntmp(N+2:end)+1;
ntmp(N+4) = ntmp(N+4)+1;
% Add 1 LSB
ntmp(1:2:N) = ntmp(1:2:N)+1;

noperands = N/2+1;
%% Determine dj
j = find(arrayfun(@(x) d(x), 1:N) >= noperands, 1, 'first');

n = zeros(j,length(ntmp));
a = n;
b = n;
c = n;

n(j, :) = ntmp;
fid_comps = fopen('comps.txt', 'w');

%% Iterate
for jj=flip(1:j-1)
    dj = d(jj);
    
    for ii = 1:2*N
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
        off_fa = n(jj,ii);
        n(jj,ii) = n(jj, ii) + a(jj+1, ii) + b(jj+1,ii) + c(jj+1, ii);
        n(jj,ii+1) = a(jj+1, ii) + b(jj+1,ii); % Carry
        
        % Connect all full adders of this column (ii) in stage jj+1
        for kk = 0:a(jj+1, ii)-1
            if ii <2*N
               nextcolout = getSigName(jj, ii+1, kk);
            else
                nextcolout = 'open';
            end
            str = ['fa' int2str(kk) 'st' int2str(jj+1) 'col' int2str(ii) ': FA port map(' getSigName(jj+1, ii, 3*kk) ',' ...
                getSigName(jj+1, ii, 3*kk+1) ',' getSigName(jj+1, ii, 3*kk+2) ',' getSigName(jj, ii, off_fa+kk) ',' ...
                nextcolout ');'];
            fprintf(fid_comps, '%s\n', str);
        end
        
        % Connect half adders
        if b(jj+1, ii) == 1
            if ii < 2*N
               nextcolout = getSigName(jj, ii+1, a(jj+1, ii));
            else
                nextcolout = 'open';
            end
            str = ['ha1st' int2str(jj+1) 'col' int2str(ii) ': HA port map(' getSigName(jj+1, ii, 3*a(jj+1, ii)) ','...
                getSigName(jj+1, ii, 3*a(jj+1, ii)+1) ',' getSigName(jj, ii, off_fa + a(jj+1, ii)) ',' nextcolout ');'];
            fprintf(fid_comps, '%s\n', str);
        end
        
        % Connect remaining signals
        for kk = 0:c(jj+1, ii)-1
            str = [getSigName(jj, ii, off_fa+a(jj+1, ii)+b(jj+1, ii) + kk) '<=' getSigName(jj+1, ii, 3*a(jj+1, ii) + 2*b(jj+1, ii) + kk) ';'];
            fprintf(fid_comps, '%s\n', str);
        end
        
    end
end 

n = n(:, 1:2*N);

% Connect input partial products to first stage
col_count = zeros(1, 2*N);
for ii = 1:N/2+1
    % For each partial product
    for jj = 1:N+1
        if ii == N/2+1 && jj == N+1
            continue;
        end
        col = 2*(ii-1)+jj;
        str = ['st' int2str(j) 'col' int2str(col) '(' int2str(col_count(col)) ') <= pprod(' int2str(ii-1) ') (' int2str(jj-1) ');'];
        col_count(col) = col_count(col)+1;
        fprintf(fid_comps, '%s\n', str);
    end
    
    if ii <= N/2
        col = 2*(ii-1)+1;
        str = ['st' int2str(j) 'col' int2str(col) '(' int2str(col_count(col)) ') <= S(' num2str(ii-1) ');'];
        col_count(col) = col_count(col)+1;
        fprintf(fid_comps, '%s\n', str);
    end
    
    if ii == 1
        str = ['st' int2str(j) 'col' int2str(N+2) '(' int2str(col_count(N+2)) ') <= S(' num2str(ii-1) ');'];
        fprintf(fid_comps, '%s\n', str);
        col_count(N+2)=col_count(N+2)+1;
        str = ['st' int2str(j) 'col' int2str(N+3) '(' int2str(col_count(N+3)) ') <= S(' num2str(ii-1) ');'];
        fprintf(fid_comps, '%s\n', str);
        col_count(N+3) = col_count(N+3)+1;
        str = ['st' int2str(j) 'col' int2str(N+4) '(' int2str(col_count(N+4)) ') <= not S(' num2str(ii-1) ');'];
        fprintf(fid_comps, '%s\n', str);
        col_count(N+4) = col_count(N+4)+1;
    elseif ii == N/2
        str = ['st' int2str(j) 'col' int2str(2*N) '(' int2str(col_count(2*N)) ') <= not S(' num2str(ii-1) ');'];
        fprintf(fid_comps, '%s\n', str);
        col_count(2*N) = col_count(2*N)+1;
    elseif ii < N/2
        col = 2*(ii-1) + N + 2;
        str = ['st' int2str(j) 'col' int2str(col) '(' int2str(col_count(col)) ') <= not S(' num2str(ii-1) ');'];
        fprintf(fid_comps, '%s\n', str);
        col_count(col) = col_count(col)+1;
        str = ['st' int2str(j) 'col' int2str(col+1) '(' int2str(col_count(col+1)) ') <= ''1'';'];
        fprintf(fid_comps, '%s\n', str);
        col_count(col+1) = col_count(col+1)+1;
    end
end

str_a = ['res_a <= st1col' int2str(size(n,2)) '(0)'];
for ii = flip(1:size(n,2)-1)
    str_a = [str_a ' & st1col' int2str(ii) '(0)'];
end
str_a = [str_a ';'];
fprintf(fid_comps, '%s\n', str_a);

str_b = ['res_b <= st1col' int2str(size(n,2)) '(1)']; 
for ii = flip(1:size(n,2)-1)
    if n(1, ii) == 2
        str_b = [str_b ' & st1col' int2str(ii) '(1)'];
    else 
        str_b = [str_b ' & ''0'''];
    end
end
str_b = [str_b ';'];
fprintf(fid_comps, '%s\n', str_b);

fid_decl = fopen('decl.txt', 'w');
% For each stage
for ii = 1:size(n, 1)
    % For each column in this stage
    for jj = 1:size(n,2)
        % Declare an array containing the dots in this column
        str = ['signal st' int2str(ii) 'col' int2str(jj) ': std_logic_vector(' int2str(n(ii, jj)) '-1 downto 0);'];
        fprintf(fid_decl, '%s\n', str);
    end
end
fclose(fid_comps);
fclose(fid_decl);
end

function r = d(j)   
        if j > 1
            r = floor(3/2*d(j-1));
        else
            r = 2;
        end
end

function str=getSigName(stage, col, ii)
    str = ['st' int2str(stage) 'col' int2str(col) '(' int2str(ii) ')'];
end
