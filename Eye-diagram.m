clear;clc 
snr = 20;
modulation =[ 8, 16, 32];
ml= dictionary(1, "test", 3, "train");
base_path =sprintf('/Users/asamarka/paper/data/fusion/paper/eye%d',snr);
disp(base_path);
mkdir(sprintf('eye%d', snr));
cd (sprintf('eye%d', snr))
%
for operation= [1 3]
    for p =1:length(modulation)
        mkdir(sprintf('%s/%d',ml(operation), modulation(p)))
    end    
end
%}
Nsym = 8;                       % Filter span in symbol durations
beta = 0.85;                    % Roll-off factor
sampsPerSym = 24;               % Upsampling factor
awgnchan = comm.AWGNChannel('NoiseMethod', 'Signal to noise ratio (SNR)',...
                                        'SNR',snr);
txfilter = comm.RaisedCosineTransmitFilter(...
    'Shape','Normal', ...
    'RolloffFactor',beta, ...
    'FilterSpanInSymbols',Nsym, ...
    'OutputSamplesPerSymbol',sampsPerSym);
 for m = [1 3]
    for j=1:length(modulation)
        M = modulation(j);
        for i = 1:m
            rng shuffle;
            data = randi([0 M-1],1000,1); 
            modSig = qammod(data,M);
            mod = awgnchan(modSig);
            % ======== filter for eye diagram shape
            rxSig = txfilter(mod);
            % ====== plot the eye diagaram of Quadrture =====
            e= eyediagram(imag(rxSig), 24*2, 1,0, 'b-');
            title('')
            xlabel('') 
            ylabel('') 
            set(gca,'xtick',[])
            set(gca,'ytick',[])
            axis([-0.5 0.5 -2 2])
            set(e, 'visible','off');
            set(gca,'Color','w')

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
sound(sin(1:1000));
clear
cd ..
