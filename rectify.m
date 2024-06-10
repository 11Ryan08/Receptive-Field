function [T]=rectify(T)
T(T<0)=0;% Index all the values in the matrix T that are less than 0, and change those values to 0
end