classdef DOT
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    properties
        color = [1 1 1];
        radius = 5;
        
        pos_x = 0; 
        pos_y = 0
        rect = 5.*[-1; -1; 1; 1];
        
        direction   = 0;
        velocity    = 1;   % pixels per screen flip

        age = 0;        % age, in number of screen flips, of the dot
        maxlifetime  = 10;   % life time, in screen flips
        lifeRemaining = 10;   
        flag = 0;
    end
    
   methods
       function obj = DOT(cx,cy, th, flag) % constructer
       
        rng('shuffle');     
        obj.pos_x = cx;
        obj.pos_y = cy;
        obj.direction = th;
        obj.flag = flag;
        obj.rect = [cx-obj.radius; cy-obj.radius; cx+obj.radius; cy+obj.radius];
 
       end

      

   end
    
end

