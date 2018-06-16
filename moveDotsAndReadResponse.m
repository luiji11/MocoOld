function [correctResponse,...
          brokeWithEscButton] = moveDotsAndReadResponse(drw, dts, whl, turnSpeedThreshold)
    whl.readTurnSpeed;
    brokeWithEscButton  = false;
    correctResponse     = false;
    while 1
        Screen('FillOval', drw.windowPtr, dts.color, dts.getDotRectList); 
        drw.flipScreen;

        % update and save the current speed & direction of the wheel turn
        whl.readTurnSpeed;
        turnSpeed           = whl.turnSpeed; 
        turnDirection       = whl.turnDirection;
        turnedWheel         = abs(turnSpeed) > turnSpeedThreshold;           

        if turnedWheel
            correctResponse = turnDirection == dts.signalDots_direction;
            break
        end        
        dts.moveDots; 
        
        
        if strcmp(readKey, 'esc')
           disp('Experimenter pressed escape button');
           brokeWithEscButton = true;
           break;
        end            
        
    end  
        
end