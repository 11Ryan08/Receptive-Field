%% My course work submission

%% Exercise 1.1 Rectify (10%)           

A=[-1 0 3;4.5 6 Inf];
A=rectify(A); % rectify all values less than 0 in the A matrix to 0                    
disp(A)

%% Exercise 1.2 Creating a two-dimensional sine wave (15%) 

[X]=meshgrid(-5:.2:5,-5:.2:5);% Create a square grid with a width of 5 and a spacing of 0.2.  Returns the coordinates (x, x) of each point in the grid      . 
z=cosine2D(X,2);% Scale the values of each coordinate point(x,x) by cosin2x 
imagesc(z)% Converts matrix z to an image where different colours represent different values. 
xlabel('X')
ylabel('X')
title('two-dimensional sine wave')

% The colours in each column of the image periodically warm and cool from left to right
% This is exactly what I expect to see, the value of u follows the cycle of the cosine2D function, rising and falling

%% Exercise 1.3 Creating a two-dimensional Gaussian bump (15%)

%The gauss2D function is written in advance so that sigma_x defaults to 3 and sigma_y defaults to 4 when no free parameters are provided
[X,Y]=meshgrid(-5:.2:5,-5:.2:5);% Generate a grid with a length and width of 5 and a spacing of 0.2。 Returns the coordinates (x, y) of each point in the grid                                                                        
sigma_x=1;
sigma_y=2;
z1=gauss2D(sigma_x,sigma_y,X,Y);% Let the value z of each point(x,y) in the grid follow a two-dimensional Gaussian distribution. This generates a bell-shaped surface that decreases in height as the distance of the coordinate points from the centre increases.   
imagesc(z1) % Converts matrix z1 to an image where different colours represent different values.
xlabel('X')
ylabel('Y')
title('two-dimensional Gaussian bump')

% This produces a vertical ellipse, with the colour getting progressively colder from the centre outwards

%% Testing other parameters   

sigma_x=2;
z2=gauss2D(sigma_x,sigma_y,X,Y);
imagesc(z2)
xlabel('X')
ylabel('Y')
title('two-dimensional Gaussian bump')

% As sigma_x increases, the ellipse in the image widens horizontally

%%

sigma_y=6;
z3=gauss2D(sigma_x,sigma_y,X,Y);
imagesc(z3)
xlabel('X')
ylabel('Y')
title('two-dimensional Gaussian bump')

% As sigma_y increases, the ellipse in the image widens vertically                           

%% Exercise 2.1: Generating the Gabor filter (5%)

gabor=z1.*cosine2D(X,2); % create gabor filter
imagesc(gabor) % plot gabor filter
title('Gabor Filter')

%% Exercise 2.2 Plot the neuron's tuning curve (20%)

firing_rate=zeros(1,72); % Create a matrix to store the firing rate of each image.              
for i=1:72
    response=squeeze(ms(i,:,:)).*gabor; % Calculate the response of the gabor filter for each image
    firing_rate(i)=sum(sum(response)); % Calculate the firing rate of the gabor filter for each image. 
end
plot(theta,firing_rate) % Plot a tuning curves to see the different firing rates of the gabor filter for different angles of the image
xlabel('Theta')
ylabel('Firing Rate')
title('Tuning Curve')

% As we saw in the tuning curve, neurons responded most to 0, 180 and 360 degrees. Because gabor filtter follows a period from cos2x that reaches extremes at 0, 180, and 360 degrees
% The receptive fields of neurons indicate that neurons respond most to horizontal edges. 
%% Use matrix multiplication to run the computations more efficiently

gabor_reshape=reshape(gabor,[1,51*51]); % reshape the 2D Gabor into a 1D vector
ms_reshape=reshape(ms,[72,51*51]); % reshape the 72 images into one large 2D matrix 
firing_rate_reshape=ms_reshape*gabor_reshape'; % determine the appropriate arrangement of rows and columns and then apply matrix multiplication to obtain the firing rate of the model neuron to each image
plot(theta,firing_rate_reshape)   
xlabel('Theta')
ylabel('Firing Rate')
title('Tuning Curve')

% Compare the two tuning curves, they are totaly the same.

%% Exercise 2.3 Determine the neuron's receptive field experimentally (20%)

rand_image = rand(50000, 51,51); % Create 50,000 random images of size 51*51            
weighted_sum = zeros(51,51); % Set the initial value of weighted_sum to a 51*51 null matrix                                 
firingrate_sum = 0; % Set the initial value of firingrate_sum to 0           
for i = 1:50000
    response = squeeze(rand_image(i, :, :)); % Reduce dimensions with dimension size 1 in rand_image                   
    firing_rate = sum(sum(response .* gabor)); % Calculate the firing rate of the gabor filter for each image
    firing_rate = rectify(firing_rate); % Rectify values less than 0 in firing rate            
    weighted_sum = weighted_sum + response.*firing_rate; % Accumulated value(response)*weight(firing_rate)      
    firingrate_sum = firingrate_sum + firing_rate; % Accumulated weight(firing_rate)      
end
receptive_field = weighted_sum ./ firingrate_sum; % Perform a weighted average
imagesc(receptive_field); % plot receptive field
title('Receptive Field')

% Observed a more fuzzy and more random image than the image in 2.1
% This method is effective because 1. by randomising the images, all possible image stimuli are presented . 2. by weighted averaging, it reinforces the influence of the image features that best drive the neurons.

%% Exerccise 2.4 Modelling the responses to natural stimuli (15%)

imagesc(im) % Drawing an image that shows a forest
xlabel('j')
ylabel('i')
title('Tree')

%%
activation_map=zeros(600-50,1000-50); % Creating matrix storage activation map
% Next by loop, let the receptive field response to each pixel of the image                            
for i = 1:(600-50) % i loop, indicates that the patch slides one step in the i direction.                       
    for j = 1:(1000-50) % i loop, indicates that the patch slides one step in the i direction.                       
        patch = im(i:i+50, j:j+50); % Set the size of each patch to 51*51                             
        firing_rate = sum(sum(patch.*receptive_field)); % The firing rate of the neuron for the current patch is calculated by multiplying the patch with the sensory field obtained above  
        activation_map(i, j) = rectify(firing_rate); % Rectify all firing rates less than 0 and store in activation map       
    end
end
imagesc(activation_map); % Plot the activation map consisting of the firing rate of neurons for each patch 
xlabel('j')
ylabel('i')
title('Activation Map')

% I see a fuzzy image in which the vertical edges are blurred.
% The reason for this is that the receptive field is only sensitive to horizontal edges, so it doesn't respond well to vertical edges.                    