clear
clc 
%%
sps = 2;                                        % Number of samples per symbol (oversampling factor)
fs = 10;                                        % sampling rate to 100 Hz
prf = 1;                                        % pulse repetition frequency to 1 Hz
filtlen = 10;                                   % Filter length in symbols
rolloff = 0.25;                                 % Filter rolloff factor
rrcFilter = rcosdesign(rolloff,filtlen,sps);    % Raised cosine FIR pulse-shaping filter design

total= 150; 
%%
modulation =[ 8, 16, 32];
base_path ='/Users/asamarka/paper/data/fusion/-15AF/test';
subfolder{1} = '8';
subfolder{2} = '16';
subfolder{3} = '32';
%
mkdir test/8 ;
mkdir test/16 ;
mkdir test/32 ;
mkdir train/8 ;
mkdir train/16 ;
mkdir train/32 ;
%}
%%
%%
for j=1:length(modulation)
    M = modulation(j);
    k = log2(M);
    numBits = 2*k;                                   % Number of bits to process
    for i=1:total
        rng shuffle;                                        % Use default random number generator
        dataIn = randi([0 M-1],numBits,1); 
        disp(i);
        dataMod = pskmod(dataIn,M);
        %%
        txFiltSignal = upfirdn(dataMod,rrcFilter,sps,1);
        snr = -15; 
        rxSignal = awgn(txFiltSignal ,snr,'measured');
        x = rxSignal();
        [afmag,delay,doppler] = ambgfun(x,fs,prf);
        e=contour(delay,doppler,afmag);
        %axis([-2 2 -30 30])
        title(' ')
        %xlabel(' ')
        %ylabel(' ')
        set(gca,'xtick',[])
        set(gca,'ytick',[])
        set(gcf,'visible','off');
        f = gcf;
        fname = strcat('QAM', num2str(i),'.png');
        file = fullfile(base_path,subfolder{j},fname);
        exportgraphics (f , (file));

    end
end

sound(sin(1:1000));