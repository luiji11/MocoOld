classdef StimProgram < handle
    %UNTITLED4 Summary of this class goes here
    %   Detailed explanation goes here
     
    properties
        scr
        dts        
        srv
        msgOptions = {  'pause',...
                        'moco', 'newdirection', 'newcoherence',...
                        'whitescreen', 'grayscreen',...
                        'finish'};
        msg
    end
    
    methods

        function obj = StimProgram
            try
                obj.start;
            catch ME                
                if ~isempty(obj.scr)
                    obj.scr.closeScreen
                end
                if ~isempty(obj.srv)
                    obj.srv.closeServer                     
                end
                rethrow(ME)
            end
        end
        
        function start(obj)
            obj.msg = 'waitingforclient';
            while true
                switch obj.msg  
                    case 'waitingforclient'
                        obj.waitForClient
                    case 'pause'
                        obj.pause;
                    case 'moco'
                        obj.moco;
                    case 'newdirection'
                        obj.dts.setNewSignalDirectionAtRandom;
                        obj.msg = 'moco';
                    case 'newcoherence'
                        obj.setcoherence;                        
                        obj.msg = 'moco';
                    case 'whitescreen'
                        obj.coloredScreen([255 255 255]);
                    case 'grayscreen'
                        obj.coloredScreen([127 127 127]);  
                    case 'finish'
                        obj.finish 
                        break;
                end
            end
        end
        
        function obj = waitForClient(obj)
            [obj.dts, obj.scr] = DotPop ;
            obj.drawCenterText(sprintf('Waiting for client')) ;                 
            obj.scr.flipScreen; 
            commandwindow;
            obj.srv = StimServer;        
            obj.drawCenterText(sprintf('CONTACT MADE')) ;                 
            obj.scr.flipScreen; 
            obj.msg = 'pause';
            pause(1.5)
        end
        
        
        function obj = pause(obj)
            tstring = cellfun(@(s) sprintf('\n%s', s) , obj.msgOptions, 'uniformoutput', false);
            tstring = [tstring{:}];
            while true
                obj.drawCenterText(sprintf('Waiting for commands:%s',tstring)) ;                 
                obj.scr.flipScreen; 
                obj.msg = obj.srv.readMessageIfAvailable;
                if any(strcmp(obj.msg, obj.msgOptions))
                   break 
                end             
            end
        end
        
        function obj = setcoherence(obj)
            while true
                obj.drawCenterText('Enter coherence [value from 0 to 1]...') ;                 
                obj.scr.flipScreen;    
                obj.msg = obj.srv.readMessageIfAvailable;
                c= str2num(obj.msg);
                if ~isempty(c) && ~isnan(c)
                    numCoherentDots = round(c*obj.dts.numDots);
                    obj.dts.setCoherence(numCoherentDots);
                    obj.drawCenterText(sprintf('Coherence Set to %.02f',c))  ;                                   
                    obj.scr.flipScreen;  
                    pause(1.25)
                    break 
                end 
            end          
        end


        function obj = moco(obj)
            Screen('FillRect', obj.scr.windowPtr, [127 127 127], obj.scr.dispRect);                        
            while true
                Screen('FillOval', obj.scr.windowPtr, obj.dts.color, obj.dts.getDotRectList);
                obj.scr.flipScreen;    
                obj.dts.moveDots;
                obj.msg = obj.srv.readMessageIfAvailable;
                if any(strcmp(obj.msg, obj.msgOptions))
                   break 
                end 
                commandwindow;
            end                
        
        end
        
        function obj = coloredScreen(obj, color)
            Screen('FillRect', obj.scr.windowPtr, color, obj.scr.dispRect);
            while true
                obj.scr.flipScreen; 
                obj.msg = obj.srv.readMessageIfAvailable;
                if any(strcmp(obj.msg, obj.msgOptions))
                   break 
                end    
            end
        end
        
        
        function obj = drawCenterText(obj, tstring)
            Screen('TextSize', obj.scr.windowPtr, 15);                
            Screen('FillRect', obj.scr.windowPtr, [0 0 0], obj.scr.dispRect);  
            DrawFormattedText(obj.scr.windowPtr, tstring,'center', 'center', [255 0 0])     ;       
        end        
        
        function finish(obj)
            obj.scr.closeScreen
            obj.srv.closeServer 
            disp('Program Ended!!!')
        end        
    end
     
     
     

    
end


