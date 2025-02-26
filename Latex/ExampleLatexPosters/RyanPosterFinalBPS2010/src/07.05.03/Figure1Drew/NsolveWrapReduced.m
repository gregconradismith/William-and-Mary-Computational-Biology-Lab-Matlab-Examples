function NsolveWrapReduced(N,M,cinf,C,Kp,Km,u,NAME,max_its,method_num,sim_num)


Kp = full(Kp); Km = full(Km); u = full(u);
u = u(:);
Io = diag(u);

for n = 1:1:N %N different automaton

    fid = fopen([NAME,num2str(n),'.mat'],'w');
    fprintf(fid,'#Num of matrices in file\n');
    fprintf(fid,'%3.0f\n', N^2-(N-1)^2 + 1);
    fprintf(fid,'#partition groups\n');
    fprintf(fid,'%3.0f\n', 1);
    fprintf(fid,'#Size: first element always 0, 2nd element num rows + 1\n');
    fprintf(fid,'%3.0f\n', 0);
    fprintf(fid,'%3.0f\n', M);


    MatrixID = 0;
    X = Km+cinf*Kp;
    fprintf(fid,'#Matrix ID:\n');
    fprintf(fid,'%3.0f\n', MatrixID);
    for ii =1:M
        fprintf(fid,['#Number of non-zero entries in row ',num2str(ii-1),':\n']);
        N_nonzero_ii = sum(X(ii,:)~=0);
        fprintf(fid,'%3.0f\n', N_nonzero_ii);
        for jj = find(X(ii,:) ~= 0)
            fprintf(fid,'#Col jj has entry X(ii,jj)\n');
            fprintf(fid,'%3.0f ',jj-1); %column entries run 0:N-1
            fprintf(fid,'%3.20f\n',X(ii,jj));
        end
    end


    %generate individual matrices for kron prod


    MatrixID = 1; %since we only have kron_prod
    for j = 1:N
        for i = 1:N

            if i==j
                if i==n
                    X = C(i,i)*Io*Kp; %Ad
                else
                    X = eye(M,M);
                end
            else
                if i==n
                    X = Io;
                elseif j==n
                    X = C(i,j)*Kp; %Astar
                else
                    X = eye(M,M);
                end
            end

            if sum(sum(X == eye(M,M))) ~= M^2

                fprintf(fid,'#Matrix ID:\n');
                fprintf(fid,'%3.0f\n', MatrixID);

                for ii =1:M
                    fprintf(fid,['#Number of non-zero entries in row ',num2str(ii-1),':\n']);
                    N_nonzero_ii = sum(X(ii,:)~=0);
                    fprintf(fid,'%3.0f\n', N_nonzero_ii);
                    for jj = find(X(ii,:) ~= 0)
                        fprintf(fid,'#Col jj has entry X(ii,jj)\n');
                        fprintf(fid,'%3.0f ',jj-1); %column entries run 0:N-1
                        fprintf(fid,'%3.20f\n',X(ii,jj));
                    end
                end

            end
            MatrixID = MatrixID + 1;

        end


    end
end

fclose(fid);

%make Name0.mat

fid = fopen([NAME '0.mat'],'w');
fprintf(fid,'# Number of matrices in file\n');
fprintf(fid,'%g\n', 1);
fprintf(fid,'# Number of parts\n');
fprintf(fid,'%g\n', 1);
fprintf(fid,'# Partition\n');
fprintf(fid,'%g\n', 0);
fprintf(fid,'%g\n', 1);
fprintf(fid,'#State transitions due to synchronized transitions\n');
fprintf(fid,'%g\n', N^2);

fprintf(fid,['# Reached state, identifier, rate of transition\n']);
for n = 1:N^2
    fprintf(fid,'%g',0);
    fprintf(fid,' %g',n);
    fprintf(fid,' %10e\n',1);
end

fclose(fid);

%make Name.comp

fid = fopen([NAME '.comp'],'w');
fprintf(fid,'#Number of components\n');
fprintf(fid,'%g\n',N);

fprintf(fid,'#correlation between component ID and component name:\n');
fprintf(fid,'#(<id> <name>)*\n');

fprintf(fid,'%g',0 );
fprintf(fid,' Highlevel_defaultnet\n');

for n = 1:N
    fprintf(fid,'%g',n);
    fprintf(fid,' ch%g\n',n);
end

fprintf(fid,'#Number of transitions: local + synchronized\n');
fprintf(fid,'%g\n',N^2);

fprintf(fid,'#correlation between transition ID and transition name for synchronized transitions:\n');
fprintf(fid,'#(<id> <name>)*\n');
for n = 1:N^2
    fprintf(fid,'%g',n);
    fprintf(fid,' t%g',n);
    fprintf(fid,' %g\n',0);
end

fclose(fid);


%make Name.conf

eps1 = 1.0e-12;eps2 = 500;eps3=eps2;comptime = 144e02;relax_param = 9.500e-01;HPQN=-2;


fid = fopen([NAME '.conf'],'w');
fprintf(fid,'#Number of components\n');
fprintf(fid,'%g\n',N);

fprintf(fid,'# Method: 111=Str_Power, 112=Str_JOR, 113=Str_BSOR\n');
fprintf(fid,'%g\n',method_num);
fprintf(fid,'# Number of iterations\n');
fprintf(fid,'%g\n',max_its);
fprintf(fid,'# Epsilon 1\n');
fprintf(fid,'%3.3e\n',eps1);
fprintf(fid,'# Epsilon 2\n');
fprintf(fid,'%3.3e\n',eps2);
fprintf(fid,'# Epsilon 3\n');
fprintf(fid,'%3.3e\n',eps3);
fprintf(fid,'# CPU time limit\n');
fprintf(fid,'%3.3e\n',comptime);
fprintf(fid,'# Relaxation Parameter\n');
fprintf(fid,'%3.3e\n',relax_param);

fprintf(fid,'# Ausgabe Loesungsvektor\n');
fprintf(fid,'%g\n',1);

fprintf(fid,'# Ausgabe HQPN Lsg. Vektor\n');
fprintf(fid,'%g\n',0);


for n = 1:N
    fprintf(fid,['# Ausgabe LQPN',num2str(n),' Lsg. Vektor\n']);
    fprintf(fid,'%g\n',1);
end

fprintf(fid,'#Initialzustand HQPN oder -2 bei Gleichverteilung oder -1 zum Einlesen\n');
fprintf(fid,'%g\n',HPQN);

for n = 1:N
    fprintf(fid,['# Initialzustand LQPN',num2str(n),'\n']);
    fprintf(fid,'%g\n',0);
end

fclose(fid);

%make Name.spa

spa = zeros(1,M);
fid = fopen([NAME '.spa'],'w');
fprintf(fid,' %g',spa);
fclose(fid);

%call executable
%command = ['!./Nsolve ', NAME]
%command = ['!./nsolveIntel ', NAME]
%command = ['!./nsolvePowerPC ', NAME]
command = ['!./IntelMlsolveDynamic ', NAME, ' > ResultsM', num2str(M), '/M', num2str(M), 'N', num2str(N),'/stdout', num2str(sim_num), '.log'];
fprintf('%s\n', command);
eval(command);

% load intermediate_status_IterationsCputimeUsertimeMaxresidualSumresidual.txt
% format long
% RawData = intermediate_status_IterationsCputimeUsertimeMaxresidualSumresi;
% 
% Iterations = RawData(end,1);
% TimeCPU = RawData(end,2);
% WallClock = RawData(end,3);
% Resids_Max = RawData(end,4);
% Resids_Sum = RawData(end,5);

%Day = date;
%save(['Nsolve',num2str(M),'N=',num2str(N),'Date',num2str(Day),'.mat'])
%save(['NsolveData.mat'])

return

