function [holdar] = boxpl( vector, color )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%For troubleshooting
% vector = cube(1,2:7)
% color = colorfinal(1,:)


color = [color' color' color' color'];

hold on
x1 = vector(1);
x2 = vector(4);
y1 = vector(2);
y2 = vector(5);
z1 = vector(3);
z2 = vector(6);


fill3([x1; x2; x2; x1],[y1; y1; y1; y1],[z1; z1; z2; z2],color);
fill3([x2; x2; x2; x2],[y1; y2; y2; y1],[z1; z1; z2; z2],color);
fill3([x1; x2; x2; x1],[y2; y2; y2; y2],[z1; z1; z2; z2],color);
fill3([x1; x1; x1; x1],[y1; y2; y2; y1],[z1; z1; z2; z2],color);
fill3([x1; x2; x2; x1],[y1; y1; y2; y2],[z1; z1; z1; z1],color);
fill3([x1; x2; x2; x1],[y1; y1; y2; y2],[z2; z2; z2; z2],color);

holdar = 1
end

