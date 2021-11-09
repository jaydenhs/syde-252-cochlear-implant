% stop existing playback
clear sound;

% loop through given filenames and run routine for each one
filenames={'Female Voice.mp3'};
for i=1:length(filenames)
    routine(filenames{i}, i*2)
end

function void = routine(filename, index)
    %% Step 3.1
    % https://www.mathworks.com/help/matlab/ref/audioread.html
    [y,Fs] = audioread(filename);

    % optionally play original audio file
    % https://www.mathworks.com/help/matlab/ref/sound.html
    % sound(y,Fs);

    % optionally print sampling rate to command window
    % Fs

    %% Step 3.2
    % if input is stereo, add the two columns to make it a single channel
    size(y, 2)
    if size(y, 2) == 2
       y = sum(y, 2) / size(y, 2);
       % y = (y(:,1)+y(:,2))/2;
    end

    %% Step 3.6
    % downsample input signal to 16 kHz
    % https://www.mathworks.com/help/signal/ug/changing-signal-sample-rate.html
    Fs_new = 16000;
    [Numer, Denom] = rat(Fs_new/Fs);

    % might need to install the signal processing toolbox on your own matlab 
    % https://www.mathworks.com/matlabcentral/answers/694975-check-for-missing-argument-or-incorrect-argument-data-type-in-call-to-function-resample
    y_new = resample(y, Numer, Denom);


    %% Step 3.3
    % play downsampled sound
    sound(y_new, Fs_new);


    %% Step 3.4
    % destructure filename to isolate non-extension
    [filepath,name,ext] = fileparts(filename);

    % recreate name, standardizing output to .wav
    new_filename = "16 kHz " + name + ".wav"

    % write the sound to a new file
    audiowrite(new_filename,y_new,Fs_new);

        
    %% Step 3.5
    figure(index)

    % create x-axis based on samples of the input signal
    time=(1:length(y_new))/Fs_new;
    plot(time,y_new);
    legend(filename, 'Location', 'southwest')
    title(filename + " - Step 3.5")
    xlabel ('Time (sec)')
    ylabel('Signal amplitude')
        
        
    %% Step 3.7
    figure(index + 1)

    dt = 1/Fs_new; % seconds per sample
    F = 1000; % desired frequency
    T = 1/F; % time per period
    tt = 0:dt:2*T; % two cycles with calculated sample rate
    d = cos(2*pi*F*tt); % 1 kHz cosine wave
    plot(tt,d,'-o');
    
    legend('Cosine Wave', 'Location', 'southwest')
    title("1 kHz Cosine wave sampled at 16 kHz - Step 3.7")
    xlabel ('Time (sec)')
    ylabel('Signal amplitude')
    
    % play full sound, not capped to two waveforms
    % has the same array length as the input signal (16kHz * sample duration)
    % also has same time duration
    d_full = cos(2*pi*F*time);
    length(d_full)
    sound(d_full, Fs_new);
end



    


