% Rebuild getangle function
% Resize character - DONE
% Make new character in photoshop (4 frames/image)
% Wall collision detection - DONE
% Shooting
% Enemy pathing
% Enemy Shooting
% Eliminate processes
%%%%% Bonus %%%%%
% Add sitting animations 
View.Set("graphics:1260,900,offscreenonly") % Release 

var numFrames := Pic.Frames ("walkGIFbluetrans.gif")
var numFramesEnemy := Pic.Frames ("walkGIFbluetransEnemy.gif")
var delayTime,delayTime2 : int
var enemySprite    : array 1 .. numFramesEnemy of int
var enemySprite90  : array 1 .. numFramesEnemy of int
var enemySprite180 : array 1 .. numFramesEnemy of int
var enemySprite270 : array 1 .. numFramesEnemy of int
var test : int := Pic.FileNew("sprPWalkDoubleBarrel_0.bmp")
var pics    : array 1 .. numFrames of int
var pics180 : array 1 .. numFrames of int
var pics45  : array 1 .. numFrames of int
var pics90  : array 1 .. numFrames of int
var pics135 : array 1 .. numFrames of int
var pics270 : array 1 .. numFrames of int
var pics225 : array 1 .. numFrames of int
var pics315 : array 1 .. numFrames of int
var chars: array char of boolean
var x,y, speed, mousex, mousey, button: int
var map1 : int := Pic.FileNew("mainLevel.jpg")
var ratio, angle : real
var font1 : int := Font.New("serif:12")
var playerFrame : int := 1
var enemyFrame : int := 1
var enemyX : int := 375
var enemyY : int := 700
var sightRange : int := 300
var dist : real
speed := 2
x := -942 
y := 359 


Pic.FileNewFrames ("walkGIFbluetrans.gif", pics, delayTime)
Pic.FileNewFrames ("walkGIFbluetransEnemy.gif", enemySprite, delayTime2)

var player: int := Sprite.New(pics(1))
var enemy : int := Sprite.New(enemySprite(1))

cls

for c : 1 .. numFramesEnemy
    enemySprite90(c) := Pic.Rotate(enemySprite(c),90,-1,-1)
end for
    for c : 1 .. numFramesEnemy
    enemySprite180(c) := Pic.Rotate(enemySprite(c),180,-1,-1)
end for
    for c : 1 .. numFramesEnemy
    enemySprite270(c) := Pic.Rotate(enemySprite(c),270,-1,-1)
end for
    
for c : 1 .. numFrames
    pics180(c) := Pic.Rotate(pics(c),180,-1,-1)
end for
    for c : 1 .. numFrames
    pics45(c) := Pic.Rotate(pics(c),45,-1,-1)
end for
    for c : 1 .. numFrames
    pics90(c) := Pic.Rotate(pics(c),90,-1,-1)
end for
    for c : 1 .. numFrames
    pics135(c) := Pic.Rotate(pics(c),135,-1,-1)
end for
    for c : 1 .. numFrames
    pics270(c) := Pic.Rotate(pics(c),270,-1,-1)
end for
    for c : 1 .. numFrames
    pics225(c) := Pic.Rotate(pics(c),225,-1,-1)
end for
    for c : 1 .. numFrames
    pics315(c) := Pic.Rotate(pics(c),315,-1,-1)
end for
    

function whatAngle (xvalue, yvalue : int) : int 
    mousewhere(mousex, mousey, button)
    mousex -= xvalue
    mousey -= yvalue 
    if mousex not= 0 then 
        ratio := mousey / mousex 
    else 
        ratio := mousey / 0.001 
    end if 
    angle := arctand (abs (ratio)) 
    if mousex < 0 then 
        angle := 180 - angle 
    end if 
    if mousey < 0 then 
        angle := 360 - angle 
    end if 
    result round (angle) 
end whatAngle 

function whatAngleEnemy (xvalue, yvalue : int) : int
    var playerX : int := maxx div 2
    var playerY : int := maxy div 2
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
    locate(1,1)
    put angle
    result round (angle) 
end whatAngleEnemy 

function collisionDetect (posx,posy : int) : int %checks if the currect coordinates collide with a wall
    var newx : int := posx
    var newy : int := posy
    if chars(KEY_UP_ARROW) or chars('w') then % finds what the coordinates will be after the user's requested action
        newy := newy - speed
    elsif chars(KEY_DOWN_ARROW) or chars('s') then
        newy := newy + speed
    elsif chars(KEY_LEFT_ARROW) or chars('a') then
        newx := newx + speed
    elsif chars(KEY_RIGHT_ARROW) or chars('d') then
        newx := newx - speed
    end if
    %if moveDirection  = "x" then
    if    (newx > -906) and (newx < 66) and (newy > 155) and (newy < 227) then % Bottom, left Brick wall
        result 1
    elsif (newx > -802) and (newx < -726) and (newy > -141) and (newy < 160) then % Bottom, left inside wall
        result 1
    elsif (newx > -802) and (newx < -726) and (newy < -213) and (newy > -1125) then % Right wall of carbon and hardwood rooms
        result 1
    elsif (newx > -802) and (newx < -438) and (newy < -501) and (newy > -575) then % Right wall between carbon and hardwood room
        result 1
    elsif (newx > -802) and (newx < -726) and (newy < -1207) and (newy > -1403) then % Right, Top wall of hardwood room
        result 1
    elsif (newx > -802) and (newx < -48) and (newy > -1403) and (newy < -1355) then % Top wall of hardwood room
        result 1
    elsif (newx > -134) and (newx < -48) and (newy > -1403) and (newy < -923) then % Left, Top wall of hardwood room
        result 1
    elsif (newx > -134) and (newx < -48) and (newy > -843) and (newy < -513) then % Left, Bottom wall of hardwood room
        result 1
    elsif (newx > -360) and (newx < 358) and (newy > -583) and (newy < -513) then % Bottom, Left wall of hardwood room
        result 1
    elsif (newx > 10) and (newx < 70) and (newy > -583) and (newy < 227) then % Left wall of carbon room
        result 1
    elsif (newx > 284) and (newx < 358) and (newy > -1797) and (newy < -513) then % Right-most wall
        result 1
    elsif (newx > -920) and (newx < 358) and (newy > -1797) and (newy < -1729) then % Top, Left wall
        result 1
    elsif (newx > -2354) and (newx < -1018) and (newy > -1797) and (newy < -1729) then % Top, Right wall
        result 1
    elsif (newx > -1816) and (newx < -986) and (newy > 155) and (newy < 227) then % Bottom, Right Wall
        result 1
    elsif (newx > -1230) and (newx < -1152) and (newy > -533) and (newy < 227) then % Left, Bottom Wall of red room
        result 1
    elsif (newx > -1816) and (newx < -1735) and (newy > -997) and (newy < 227) then % Right, Bottom Wall of red room
        result 1
    elsif (newx > -1230) and (newx < -1152) and (newy > -1419) and (newy < -627) then % Left, Top Wall of red room / Left wall of purple room
        result 1
    elsif (newx > -1506) and (newx < -1152) and (newy > -983) and (newy < -887) then % Left wall between red and purple room
        result 1
    elsif (newx > -1816) and (newx < -1574) and (newy > -983) and (newy < -887) then % Right wall between red and purple room
        result 1
    elsif (newx > -1924) and (newx < -1152) and (newy > -1415) and (newy < -1319) then % Top, Left wall of purple room
        result 1
    elsif (newx > -2366) and (newx < -1986) and (newy > -1415) and (newy < -1319) then % Top, Right wall of purple room
        result 1
    elsif (newx > -2370) and (newx < -2278) and (newy > -1801) and (newy < -1213) then % Right, Top wall of purple room
        result 1
    elsif (newx > -2370) and (newx < -2278) and (newy > -1147) and (newy < -463) then % Right, Bottom wall of purple room
        result 1
    elsif (newx > -2370) and (newx < -1735) and (newy > -555) and (newy < -459 ) then % Bottom wall of purple room
        result 1
    elsif (newx > -812) and (newx < -716) and (newy > -2179) and (newy < -1729 ) then % Left wall of elevator
            result 1
    elsif (newx > -1226) and (newx < -1136) and (newy > -2179) and (newy < -1729 ) then % Right wall of elevator
            result 1
    elsif (newx > -1226) and (newx < -716) and (newy > -2179) and (newy < -2089) then % Top wall of elevator
            result 1
    end if
    result 0
end collisionDetect

procedure movement
    for i : 1..6
        Input.KeyDown (chars)
        if (chars (KEY_UP_ARROW) or chars('w')) and collisionDetect(x,y) = 0 then
            y := y - speed
        elsif (chars (KEY_DOWN_ARROW) or chars('s')) and collisionDetect(x,y) = 0 then
            y := y + speed
        elsif (chars (KEY_LEFT_ARROW) or chars('a')) and collisionDetect(x,y) = 0 then
            x := x + speed
        elsif (chars (KEY_RIGHT_ARROW) or chars('d')) and collisionDetect(x,y) = 0 then
            x := x - speed
        end if
        Pic.Draw(map1, x, y, picCopy)
    end for
end movement
movement

procedure playerAnimate
    if whatAngle(maxx div 2,maxy div 2) < 22.5 or whatAngle(maxx div 2,maxy div 2) >= 337.5 then
        Sprite.ChangePic(player, pics(playerFrame))
    elsif whatAngle(maxx div 2,maxy div 2) >= 22.5 and whatAngle(maxx div 2,maxy div 2) < 67.5 then
        Sprite.ChangePic(player, pics45(playerFrame))
    elsif whatAngle(maxx div 2,maxy div 2) >= 67.5 and whatAngle(maxx div 2,maxy div 2) < 112.5 then
        Sprite.ChangePic(player, pics90(playerFrame))
    elsif whatAngle(maxx div 2,maxy div 2) >= 112.5 and whatAngle(maxx div 2,maxy div 2) < 157.5 then
        Sprite.ChangePic(player, pics135(playerFrame))
    elsif whatAngle(maxx div 2,maxy div 2) >= 157.5 and whatAngle(maxx div 2,maxy div 2) < 202.5 then
        Sprite.ChangePic(player, pics180(playerFrame))
    elsif whatAngle(maxx div 2,maxy div 2) >= 202.5 and whatAngle(maxx div 2,maxy div 2) < 247.5 then
        Sprite.ChangePic(player, pics225(playerFrame))
    elsif whatAngle(maxx div 2,maxy div 2) >= 247.5 and whatAngle(maxx div 2,maxy div 2) < 292.5 then
        Sprite.ChangePic(player, pics270(playerFrame))
    elsif whatAngle(maxx div 2,maxy div 2) >= 292.5 and whatAngle(maxx div 2,maxy div 2) < 337.5 then
        Sprite.ChangePic(player, pics315(playerFrame))
    end if
    
    if playerFrame = 8 then
        playerFrame := 0
    end if
    playerFrame += 1
end playerAnimate

Sprite.SetPosition(enemy,enemyX,enemyY,true)


procedure enemyShoot
    var roll : int := Rand.Int(1,2)
    var roll2 : int := Rand.Int(1,2)
    var missX : int := Rand.Int(0,100)
    var missY : int := Rand.Int(0,100)
    if roll = 1 then
        Draw.Line(enemyX,enemyY,maxx div 2,maxy div 2,black)
        locate(1,1)
        put "You Died!"
        %Animate Bullet
        %Change to dead sprite
        %Game over procedure
    else 
        if roll2 = 1 then
            Draw.Line(enemyX,enemyY,(maxx div 2)-missX,(maxy div 2) + missY,black)
        else
            Draw.Line(enemyX,enemyY,(maxx div 2)+missX, (maxy div 2) - missY,black)
        end if
    end if
end enemyShoot


procedure enemyAnimate
    if (chars (KEY_UP_ARROW) or chars('w')) and collisionDetect(x,y) = 0 then 
        enemyY := enemyY - (speed * 6)
    elsif (chars (KEY_DOWN_ARROW) or chars('s')) and collisionDetect(x,y) = 0 then
        enemyY := enemyY + (speed * 6)
    elsif (chars (KEY_LEFT_ARROW) or chars('a')) and collisionDetect(x,y) = 0 then
        enemyX := enemyX + (speed * 6)
    elsif (chars (KEY_RIGHT_ARROW) or chars('d')) and collisionDetect(x,y) = 0 then
        enemyX := enemyX - (speed * 6)
    end if
    %Draw.Oval(x+1300,y+900,100,100,red)
    %Sprite.ChangePic(enemy,enemySprite(enemyFrame))
    Sprite.Show(enemy)
    if enemyY < y + 900 and enemyX > x + 1300 then % Walking up
        enemyY += 6 % Move upwards
        Sprite.Animate(enemy,enemySprite90(enemyFrame),enemyX,enemyY,true) %Animate
        %for i : 1 .. sightRange by 3
        dist := Math.DistancePointLine(maxx div 2,maxy div 2,enemyX,enemyY,enemyX,enemyY + sightRange)
        Draw.Line(enemyX,enemyY,enemyX,enemyY + sightRange,black)
        if dist < sightRange and whatAngleEnemy(enemyX,enemyY) > 0 and whatAngleEnemy(enemyX,enemyY) < 180 then
            enemyShoot
        end if
        %end for
    elsif enemyY > y + 900 and enemyX > x + 680 then
        enemyX -= 6
        Sprite.Animate(enemy,enemySprite180(enemyFrame),enemyX,enemyY,true)
        dist := Math.DistancePointLine(maxx div 2,maxy div 2,enemyX,enemyY,enemyX - sightRange,enemyY)
        Draw.Line(enemyX,enemyY,enemyX - 300,enemyY,black)
        if dist < sightRange and whatAngleEnemy(enemyX,enemyY) > 90 and whatAngleEnemy(enemyX,enemyY) < 270 then %if player is within range and in front on enemy he sees him
            enemyShoot
        end if
    elsif enemyX <= x + 680 and enemyY > y + 320 then
        %enemyY := enemyY - 6
        Sprite.Animate(enemy,enemySprite270(enemyFrame),enemyX,enemyY,true)
        enemyY -= 6
        dist := Math.DistancePointLine(maxx div 2,maxy div 2,enemyX,enemyY,enemyX,enemyY - sightRange)
        Draw.Line(enemyX,enemyY,enemyX,enemyY - 300,black)
        if dist < sightRange and whatAngleEnemy(enemyX,enemyY) > 180 and whatAngleEnemy(enemyX,enemyY) < 360 then %if player is within range and in front on enemy he sees him
            enemyShoot
        end if
    elsif enemyX < x + 1300 and enemyY <= y + 320 then
        enemyX += 6
        Sprite.Animate(enemy,enemySprite(enemyFrame),enemyX,enemyY,true)
        dist := Math.DistancePointLine(maxx div 2,maxy div 2,enemyX,enemyY,enemyX + sightRange,enemyY)
        Draw.Line(enemyX,enemyY,enemyX + 300,enemyY,black)
        if dist < sightRange and whatAngleEnemy(enemyX,enemyY) > 270 and whatAngleEnemy(enemyX,enemyY) < 90 then %if player is within range and in front on enemy he sees him
            enemyShoot
        end if
    else
        locate(1,1)
        put mousex
    end if
    
    if enemyFrame = 8 then
        enemyFrame := 0
    end if
    enemyFrame += 1
    View.Update
end enemyAnimate

% 563,623
% 

loop
    playerAnimate
    movement
    enemyAnimate
    View.Update
    
    Sprite.SetPosition (player, maxx div 2, maxy div 2, true)
    Sprite.Show (player)
    mousewhere(mousex,mousey,button)
    locate(1,1)
    %put enemyX,"and",enemyY
    %put mousex + 942,"and",mousey - 359
    %put x,"and",y
    %put dist, "dist", whatAngleEnemy(enemyX,enemyY)
    View.Update
    delay(50)
end loop
%x := -942 
%y := 359 