clc;clear;

tic;

model = 1; %user can choose between a few models 1 = three state, 2 = FPD, 3 = six state

if model == 1

    %threestate with sequential Ca binding
    NAME = 'ThreeState';
    kap = 1.5; kam = 50; kbp = 150; kbm = 1.5;
    [ Kp, Km, u] = kthreestate(kap,kam,kbp,kbm);

elseif model == 2
    %FraimanPonceDawson Model
    NAME = 'FPD';
    Ca_lum = 30; % luminal [Ca] in uM
    IP3 = 0.1; % [IP3] in uM
    kp12 = 5;kp67 = 5; kp89 = 0.5; kp1314 = 0.06;
    kmlower = [ 0.001 0.7 0.1 0.15 0.25 0.02 0 0.667 0.33 1.5 2.0 0.4 0.016 0];
    kmupper = [0 0 0.0003 0.5 5*Ca_lum 3 0 0 0  1.8 0.133 0.07*Ca_lum 0.63 0];
    km18 = 6.67*IP3;
    km29 = 1.54*IP3;
    km92 = 0.018;
    clockwise =  kp12*km29*0.667;
    counterclockwise = kp89*km92*0.001*km18;
    km81 = counterclockwise/clockwise; % detailed balance
    [ Kp, Km, u] = kFPD(kp12,kp67,kp89,kp1314,kmlower,kmupper,km18,km29,km81,km92);

else
    % six state model with sequential Ca binding (from traditional 3 state)
    NAME = 'SixState';
    kap = 1.5; kam = 24.75; kep = 150; kem = 3; kdp = 0.015; kdm = 0.12375; kfp = 1.5; kfm = 0.03; kbm = kdm; kcp = kep; kcm = kem;
    kbp = (kbm*kep*kdp*kcm)/(2*kcp*kdm*kem);
    [ Kp, Km, u ] = ksixstate(kap,kam,kbp,kbm,kcp,kcm,kdp,kdm,kep,kem,kfp,kfm);
end

Kp = full(Kp); Km = full(Km); u = full(u);
[M,M]=size(Kp);

N = 10;
Radius_Mat = [0 0.1000 0.3728 0.5179 0.7197 1.0000 1.0000 1.0000 1.3895 1.9307 1.9307 1.9307 1.9307 2.6827 2.6827 2.6827 2.6827 2.6827 ];
R = Radius_Mat(N);

%standard release site parameters
cinf = 0.05;
ra = 0.050; D = 250; ica = 0.1; tau_buf = 0.1; lambda = sqrt(D*tau_buf);
if 1
    load('figure2_channels.mat');
else
    [ xch, ych ] = chanpos3(N,'uniform',R);
    save('figure2_channels.mat', 'xch', 'ych');
end
[ C ] = coupling2(xch,ych,ica,D,lambda,ra); % this does not include cainf!

method_numvec = [222];    % 113: SOR, 152: PRE_ARNOLDI, 157: BSOR_BICGSTAB
max_itsvec{1} = unique(round(logspace(0, log10(100), 50)));

simu = cell(1, length(method_numvec));
for jj = 1:length(method_numvec)

    fprintf('Method #%d/%d [%d]\n', jj, length(method_numvec), method_numvec(jj));
    
    method_num = method_numvec(jj);
    
    for ii = 1:length(max_itsvec{jj})

        max_its = max_itsvec{jj}(ii);

        [statdist,statdistpermute,projectionsN,pnstate,score,histVec] = NsolveWrapIterations(N,M,cinf,C,Kp,Km,u,NAME,max_its,method_num,ii);

        fprintf('  NSOLVE OUTPUT: Iterations = %d, Score = %g\n', max_its, score);
        scoreMat(ii) = score;
        histMat(:,ii) = histVec;

    end

    simu{jj}.method_num = method_num;
    simu{jj}.scoreMat = scoreMat;
%     simu{jj}.IterationsMat = IterationsMat;
%     simu{jj}.TimeCPUMat = TimeCPUMat;
%     simu{jj}.WallClockMat = WallClockMat;
%     simu{jj}.Resids_MaxMat = Resids_MaxMat;
%     simu{jj}.Resids_SumMat = Resids_SumMat;
    simu{jj}.histMat = histMat;

    clear scoreMat histMat;

    save('figure2.mat', 'simu');
    
end

%Day = date;
%save(['HISTSMethodNum=',num2str(method_num),'RangeIterationsDataM=',num2str(M),'N=',num2str(N),'Date',num2str(Day),'.mat'], 'simu');

toc