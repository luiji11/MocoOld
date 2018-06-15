classdef DotPop < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
        dots 
        numDots     = 100;
        coherence   = 90;
        radius      = 12;
        velocity    = 6;
        color       = [0 0 0];
        rectList
        directionList
        
        maxCx = 1920;
        maxCy = 1080;
        
        signalDots_Ids
        noiseDots_Ids
        deadDot_Ids
        
        signalDots_direction = 0;
        lifeTime             = 10;
    end
    
    
    methods
        
        function obj = DotPop(varargin)            
            keyList = varargin(1:2:end);
            valList = varargin(2:2:end);
            
            for i = 1:numel(keyList)
                switch keyList{i}
                    case 'numdots'
                        obj.numDots  = valList{i};                            
                    case 'coherence'
                        obj.coherence= valList{i};
                    case 'maxwidth'
                         obj.maxCx  = valList{i};
                    case 'maxheight'
                         obj.maxCy  = valList{i};
                    case 'lifetime'
                        obj.lifeTime = valList{i};
                    otherwise
                        error('Unkown argument')
                end
            end
            
            obj.dots= repmat(struct('cx', [], 'cy', [], 'rect', [], 'direction', [], 'age', 0), obj.numDots, 1);
            obj     = randomizeDotPosition(obj, 1:obj.numDots); % sets position of dots on the screen
            obj     = setCoherence(obj, obj.coherence);            
        end
        
        function obj = randomizeDotPosition(obj, dotIds)
            for i = dotIds
                d       =   obj.dots(i);
                d.cx    =   randi(obj.maxCx);           
                d.cy    =   randi(obj.maxCy);  
                d.rect  =   [d.cx-obj.radius;...
                            d.cy-obj.radius;...
                            d.cx+obj.radius;...
                            d.cy+obj.radius]; 
                obj.dots(i) = d;                        
            end
            obj.rectList    = [obj.dots(:).rect];   
        end 
        
         
        function obj = setCoherence(obj, coherence)
            obj.coherence   = coherence;   
            obj = setDotTypeAtRandom(obj); % randomly assign dot to be a noise dot or signal dot  (based on coherence)
        end
        
        function obj = setDotTypeAtRandom(obj)
            dotIds                  = randperm(obj.numDots);
            
            obj.signalDots_Ids      = dotIds(1:obj.coherence);
            obj.noiseDots_Ids       = dotIds(obj.coherence+1:end);
            
            obj = setSignalDotDirection(obj, obj.signalDots_direction); % set the direction of signal dots 
            obj = setNoiseDotDirections(obj) ;  % set direction of random dots
        end
        
        function obj = setSignalDotDirection(obj, direction)
            obj.signalDots_direction = direction;
            for i = obj.signalDots_Ids
                obj.dots(i).direction = obj.signalDots_direction;
            end
            obj.directionList           = [obj.dots(:).direction];              
        end
        
        function obj = setNoiseDotDirections(obj)           
            for i = obj.noiseDots_Ids
                obj.dots(i).direction = randi(360);
            end
            obj.directionList   = [obj.dots(:).direction];              
        end         
        
        function obj = moveDots(obj, dotIds, wrapDots)
            for i = dotIds
                d = obj.dots(i);
                d.cx =   [d.cx] +  obj.velocity*cosd(d.direction);               
                d.cy =   [d.cy] +  obj.velocity*sind(d.direction);
                isSignalDot = any(i == obj.signalDots_Ids);
                if wrapDots 
                    if isSignalDot
                        if d.cx > obj.maxCx 
                            d.cx = 1;
                        elseif d.cx < 1
                            d.cx = obj.maxCx;
                        end
                        if d.cy > obj.maxCy 
                            d.cx = 1;
                        elseif d.cy < 1
                            d.cx = obj.maxCy;                        
                        end
                    else
                        if d.cx > obj.maxCx || d.cx < 1 || d.cy > obj.maxCy || d.cy < 1
                             d.cx    =   randi(obj.maxCx);           
                             d.cy    =   randi(obj.maxCy);  
                             d.rect  =   [  d.cx-obj.radius;...
                                            d.cy-obj.radius;...
                                            d.cx+obj.radius;...
                                            d.cy+obj.radius]; 
                        end
                    end
                end
                d.rect =    [d.cx-obj.radius;...
                            d.cy-obj.radius;...
                            d.cx+obj.radius;...
                            d.cy+obj.radius]; 
                obj.dots(i) = d;                        
            end
            obj.rectList    = [obj.dots(:).rect];   
            
        end

        function obj = incrementDotAge(obj, dotIds)
            for i = dotIds
                obj.dots(i).age = obj.dots(i).age + 1;                       
            end             
        end
        
        function obj = zeroDotAge(obj, dotIds)
            for i = dotIds
                obj.dots(i).age = 0;                       
            end           
        end
        
        function obj = check4DeadDots(obj) % check which dots exceeded their lifetime
            obj.deadDot_Ids = find( [obj.dots(:).age] >= obj.maxlifetime ); 
        end
        

 
        

        
        
    end
    
end
%%


 
    
    function [sel, ptheta] = resultant(resp, f, thvals_inDeg)
    result          = sum(resp.*exp(1i*f*thvals_inDeg*pi/180));
    
    sel      = abs(result)/sum(abs(resp));
    
    ptheta    = rad2deg(angle(result)/f);
    ptheta(ptheta < 0) = ptheta(ptheta < 0) +  360/f;

end
    