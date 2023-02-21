clear;clc 
snr = 20;
modulation =[ 8, 16, 32];
ml= dictionary(1, "test", 3, "train");
base_path =sprintf('/Users/asamarka/paper/data/fusion/paper/%dc',snr);
disp(base_path);
mkdir(sprintf('%dc', snr));
cd (sprintf('%dc', snr))
for operation= [1 3]
    for p =1:length(modulation)
        mkdir(sprintf('%s/%d',ml(operation), modulation(p)))
    end    
end
channel = comm.AWGNChannel('NoiseMethod','Signal to noise ratio (SNR)','SNR',snr);
for m = [1 3]
    for j=1:length(modulation)
        M = modulation(j);
        k = log2(M);
        for i = 1:m
            rng shuffle;
            dataIn = randi([0 1],1000*k,1); 
            dataInMatrix = reshape(dataIn,length(dataIn)/k,k);
            dataSymbolsIn = bi2de(dataInMatrix);
            QAM = qammod(dataSymbolsIn,M); 
            noise =channel(QAM);
            scatterplot(noise,1,0,'b.')
            title('')
            xlabel('') 
            ylabel('')    
            set(gca,'xtick',[])
            set(gca,'ytick',[])
            set(groot,'defaultFigureVisible','off');
            set(gca,'Color','w');
            f = gcf;
            fname = strcat('QAM', num2str(i),'.png');
            file = fullfile(base_path,ml(m) ,string(modulation(j)),fname);
            exportgraphics (f , (file) );
        end 
    end
end
%}
sound(sin(1:1000));
clear
cd ..
