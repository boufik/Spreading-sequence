clc
clear all

%% MAIN FUNCTION
% Information bits to chips
SF = 7;
info = [0, 1, 1];
LEN = 3;
information = zeros(1, LEN * SF);
NEW_LEN = SF * LEN;
for i = 1:LEN
    for j = 1:SF
        information((i-1)*SF + j) = info(i);
    end
end
information = from_01_to_ones(information)

% Spreading Sequence and transmission
spreading = generate_list(NEW_LEN)
transmitted = information .* spreading
% Random interefering user and received signal
interference = generate_list(NEW_LEN)
received = transmitted + interference


% Despreaded
despreaded = spreading .* received
% Integrator
%If after the multiplication exist more 1's, I will conclude 1, otherwise
%-1
integrator = zeros(1, LEN);
for i = 1:LEN
    bitstream = despreaded((i-1)*SF + 1 : i*SF);
    SUM = sum(bitstream);
    if SUM > 0
        integrator(i) = 1;
    elseif SUM < 0
        integrator(i) = -1;
    else
        integrator(i) = (-1) ^ randi([0 1]);
    end
end

info_guess = zeros(1, NEW_LEN);
for i = 1:LEN
    for j = 1:SF
        info_guess((i-1)*SF + j) = integrator(i);
    end
end
info_guess


%% PLOTS
subplot(4,2,1);
result = square_pulse(information);
display("Plot done");
title("Information Chips");
subplot(4,2,3);
result = square_pulse(spreading);
display("Plot done");
title("Spreading Sequence");
subplot(4,2,5);
result = square_pulse(transmitted);
display("Plot done");
title("Transmitted signal");
subplot(4,2,7);
result = square_pulse(interference);
display("Plot done");
title("Intefering user");


subplot(4,2,2);
result = square_pulse(interference);
display("Plot done");
title("Intefering user");
subplot(4,2,4);
result = square_pulse(spreading);
display("Plot done");
title("Spreading Sequence");
subplot(4,2,6);
result = square_pulse(despreaded);
display("Plot done");
title("Despreaded signal");
subplot(4,2,8);
result = square_pulse(info_guess);
display("Plot done");
title("Information guess");


%% AUXILIARY FUNCTIONS
% Generate list with 0's and 1's
function x = random_generate_01(LEN)
    x = zeros(1, LEN);
    for i = 1:LEN
        x(i) = randi([0 1]);
    end
    x;
end


% Convert 0 and 1 to 1 and -1
function y = from_01_to_ones(x)
    y = zeros(1, length(x));
    for i = 1:length(x)
        y(i) = (-1) ^ x(i);
    end
    y;
end

% Generate a list with 1's and -1's
function y = generate_list(LEN)
    x = random_generate_01(LEN);
    y = from_01_to_ones(x);
end

% Create square pulse from a data list
function result = square_pulse(y)
    syms z
    f = 0;
    for i = 1:length(y)
        f = f + y(i) * rectangularPulse(z - (i - 1/2));
    end
    fplot(f, [0 length(y)]);
    result = 1;
end