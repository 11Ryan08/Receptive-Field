

function [z]=gauss2D(sigma_x,sigma_y,x,y)
if isempty(sigma_x)
    sigma_x=3;
end
if isempty(sigma_y)
    sigma_y=4;
end
z=(1/(2*sigma_x*sigma_y*pi))*exp(-(x.^2/(2*sigma_x^2)+y.^2/(2*sigma_y^2)));
end

