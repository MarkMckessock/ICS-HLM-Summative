%%%Includes functions for calculating the angle of the line fromed between either the player and the mouse or the enemy and the mouse%%%
var ratio, angle : real
var relative_x,relative_y : int
function whatAngle (xvalue, yvalue : int) : int
    mousewhere(mouse_x, mouse_y, button)
    relative_x := mouse_x - xvalue
    relative_y := mouse_y - yvalue
    if relative_x not= 0 then
        ratio := relative_y / relative_x
    else
        ratio := relative_y / 0.001
    end if
    angle := arctand (abs (ratio))
    if relative_x < 0 then
        angle := 180 - angle
    end if
    if relative_y < 0 then
        angle := 360 - angle
    end if
    result round (angle)
end whatAngle

function whatAngleEnemy (xvalue, yvalue : int) : int
    var playerX : int := maxx div 2+25-camera.x
    var playerY : int := maxy div 2+25-camera.y
    playerX -= xvalue
    playerY -= yvalue
    if playerX not= 0 then
        ratio := playerY / playerX
    else
        ratio := playerY / 0.001
    end if
    angle := arctand (abs (ratio))
    if playerX < 0 then
        angle := 180 - angle
    end if
    if playerY < 0 then
        angle := 360 - angle
    end if
    result round (angle)
end whatAngleEnemy