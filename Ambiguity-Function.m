clear;clc 
snr = 20;
modulation =[ 8, 16, 32];
ml= dictionary(1, "test", 3, "train");
base_path =sprintf('/Users/asamarka/paper/data/fusion/paper/AF%d',snr);
disp(base_path);
mkdir(sprintf('AF%d', snr));
cd (sprintf('AF%d', snr))
%
for operation= [1 3]
    for p =1:length(modulation)
        mkdir(sprintf('%s/%d',ml(operation), modulation(p)))
    end    
end
%}
sps = 1;                                        % Number of samples per symbol (oversampling factor)
fs = 20;                                        % sampling rate to 100 Hz
prf = 1;                                        % pulse repetition frequency to 1 Hz
filtlen = 20;                                   % Filter length in symbols
rolloff = 1;                                 % Filter rolloff factor
rrcFilter = rcosdesign(rolloff,filtlen,sps);    % Raised cosine FIR pulse-shaping filter design
%%
 for m = [1 3]
    for j=1:length(modulation)
        M = modulation(j);
        k = log2(M);
        numBits = 2*k; 
        for i = 1:m
            rng shuffle;                                        % Use default random number generator
            dataIn = randi([0 M-1],numBits,1); 
            disp(i);
            dataMod = pskmod(dataIn,M);
            %%
            txFiltSignal = upfirdn(dataMod,rrcFilter,sps,1);
            rxSignal = awgn(txFiltSignal ,snr,'measured');
            x = rxSignal();
            [afmag,delay,doppler] = ambgfun(x,fs,prf);
            e=contour(delay,doppler,afmag);
            %axis([-2 2 -30 30])
            xlabel(' ')
            ylabel(' ')
            set(gca,'xtick',[])
            set(gca,'ytick',[])
            set(gcf,'visible','off');
            f = gcf;
            fname = strcat('QAM', num2str(i),'.png');
            file = fullfile(base_path,ml(m) ,string(modulation(j)),fname);
            exportgraphics (f , (file) );
            disp(j)
            disp(i)
        end 
    end
end
%}
sound(sin(1:50));
clear
cd ..
