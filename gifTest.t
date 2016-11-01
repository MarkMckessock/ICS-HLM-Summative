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

%When an enemy sees player save their location and navigate to it then search or return to loop
View.Set("graphics:1260,900,offscreenonly") % Release
const spongebob :int := Pic.FileNew("../ICS-HLM-Summative/mainLevel.jpg")

type vector:
record
    x, y :int
end record

type inputEffect:
record
    input :char
    effect :vector
end record

var camera :vector :=init(0, 0)

var spongebobPos :vector := init(0, 0)

var inputEffects :array 1 .. 4 of inputEffect := init(init('a', init(6, 0)), init('d', init(-6, 0)), init('w', init(0, -6)), init('s', init(0, 6)))

var key :array char of boolean

var lastInputCheck :int := 0


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
var enemyPos : array 1 .. 3,1 .. 2 of int
var absEnemyPos : array 1 .. 3,1 .. 2 of int
enemyPos(1,1) := 500
enemyPos(1,2) := 500
absEnemyPos(1,1) := 375
absEnemyPos(1,2) := 700
var sightRange : int := 300
var dist : real
var playerRoom : string
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
Input.KeyDown(key)
    
    if Time.Elapsed - lastInputCheck > 1 then
        lastInputCheck := Time.Elapsed
        for i : 1 .. upper(inputEffects)
            if key(inputEffects(i).input) then
                camera.x += inputEffects(i).effect.x
                camera.y += inputEffects(i).effect.y
            end if
        end for 
    end if 
    cls
    
    Pic.Draw(spongebob, spongebobPos.x + camera.x, spongebobPos.y + camera.y, picCopy)
    Font.Draw("Camera X: " + intstr(camera.x), 0, 600, font1, black)
    Font.Draw("Camera Y: " + intstr(camera.y), 0, 570, font1, black)
    Draw.Oval(maxx div 2,maxy div 2,50,50,black)
    %Draw.Oval(camera.x,camera.y,50,50,black)
    Font.Draw("Spongebob X: " + intstr(spongebobPos.x), 0, 400, font1, black)
    Font.Draw("Spongebob Y: " + intstr(spongebobPos.y), 0, 370, font1, black)
    View.Update
end movement

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

Sprite.SetPosition(enemy,enemyPos(1,1),enemyPos(1,2),true)


procedure enemyShoot
    var roll : int := Rand.Int(1,2)
    var roll2 : int := Rand.Int(1,2)
    var missX : int := Rand.Int(0,100)
    var missY : int := Rand.Int(0,100)
    if roll = 1 then
        Draw.Line(enemyPos(1,1),enemyPos(1,2),maxx div 2,maxy div 2,black)
        locate(1,1)
        %put "You Died!"
        %Animate Bullet
        %Change to dead sprite
        %Game over procedure
    else
        if roll2 = 1 then
            Draw.Line(enemyPos(1,1),enemyPos(1,2),(maxx div 2)-missX,(maxy div 2) + missY,black)
        else
            Draw.Line(enemyPos(1,1),enemyPos(1,2),(maxx div 2)+missX, (maxy div 2) - missY,black)
        end if
    end if
end enemyShoot


procedure enemyAnimate
    Sprite.Animate(enemy,enemySprite90(enemyFrame),enemyPos(1,1),enemyPos(1,2),true) %Animate
    /*
    if (chars (KEY_UP_ARROW) or chars('w')) and collisionDetect(x,y) = 0 then
        enemyPos(1,2) := enemyPos(1,2) - (speed * 6)
    elsif (chars (KEY_DOWN_ARROW) or chars('s')) and collisionDetect(x,y) = 0 then
        enemyPos(1,2) := enemyPos(1,2) + (speed * 6)
    elsif (chars (KEY_LEFT_ARROW) or chars('a')) and collisionDetect(x,y) = 0 then
        enemyPos(1,1) := enemyPos(1,1) + (speed * 6)
    elsif (chars (KEY_RIGHT_ARROW) or chars('d')) and collisionDetect(x,y) = 0 then
        enemyPos(1,1) := enemyPos(1,1) - (speed * 6)
    end if
    %Draw.Oval(x+1300,y+900,100,100,red)
    %Sprite.ChangePic(enemy,enemySprite(enemyFrame))
    Sprite.Show(enemy)
    if enemyPos(1,2) < y + 900 and enemyPos(1,1) > x + 1300 then % Walking up
        enemyPos(1,2) += 6 % Move upwards
        absEnemyPos(1,2) += 6
        Sprite.Animate(enemy,enemySprite90(enemyFrame),enemyPos(1,1),enemyPos(1,2),true) %Animate
        %for i : 1 .. sightRange by 3
        dist := Math.DistancePointLine(maxx div 2,maxy div 2,enemyPos(1,1),enemyPos(1,2),enemyPos(1,1),enemyPos(1,2) + sightRange)
        Draw.Line(enemyPos(1,1),enemyPos(1,2),enemyPos(1,1),enemyPos(1,2) + sightRange,black)
        %put whatAngleEnemy(enemyPos(1,1),enemyPos(1,2))
        if dist < sightRange and whatAngleEnemy(enemyPos(1,1),enemyPos(1,2)) > 0 and whatAngleEnemy(enemyPos(1,1),enemyPos(1,2)) < 180 then
            enemyShoot
        end if
        %end for
    elsif enemyPos(1,2) > y + 900 and enemyPos(1,1) > x + 680 then
        enemyPos(1,1) -= 6
        absEnemyPos(1,1) -= 6
        Sprite.Animate(enemy,enemySprite180(enemyFrame),enemyPos(1,1),enemyPos(1,2),true)
        dist := Math.DistancePointLine(maxx div 2,maxy div 2,enemyPos(1,1),enemyPos(1,2),enemyPos(1,1) - sightRange,enemyPos(1,2))
        Draw.Line(enemyPos(1,1),enemyPos(1,2),enemyPos(1,1) - 300,enemyPos(1,2),black)
        %put whatAngleEnemy(enemyPos(1,1),enemyPos(1,2))
        if dist < sightRange and whatAngleEnemy(enemyPos(1,1),enemyPos(1,2)) > 90 and whatAngleEnemy(enemyPos(1,1),enemyPos(1,2)) < 270 then %if player is within range and in front on enemy he sees him
            enemyShoot
        end if
    elsif enemyPos(1,1) <= x + 680 and enemyPos(1,2) > y + 320 then
        Sprite.Animate(enemy,enemySprite270(enemyFrame),enemyPos(1,1),enemyPos(1,2),true)
        enemyPos(1,2) -= 6
        absEnemyPos(1,2) -= 6
        dist := Math.DistancePointLine(maxx div 2,maxy div 2,enemyPos(1,1),enemyPos(1,2),enemyPos(1,1),enemyPos(1,2) - sightRange)
        Draw.Line(enemyPos(1,1),enemyPos(1,2),enemyPos(1,1),enemyPos(1,2) - 300,black)
        %put whatAngleEnemy(enemyPos(1,1),enemyPos(1,2))
        if dist < sightRange and whatAngleEnemy(enemyPos(1,1),enemyPos(1,2)) > 180 and whatAngleEnemy(enemyPos(1,1),enemyPos(1,2)) < 360 then %if player is within range and in front on enemy he sees him
            enemyShoot
        end if
    elsif enemyPos(1,1) < x + 1300 and enemyPos(1,2) <= y + 320 then
        enemyPos(1,1) += 6
        absEnemyPos(1,1) += 6
        Sprite.Animate(enemy,enemySprite(enemyFrame),enemyPos(1,1),enemyPos(1,2),true)
        dist := Math.DistancePointLine(maxx div 2,maxy div 2,enemyPos(1,1),enemyPos(1,2),enemyPos(1,1) + sightRange,enemyPos(1,2))
        Draw.Line(enemyPos(1,1),enemyPos(1,2),enemyPos(1,1) + 300,enemyPos(1,2),black)
        %put whatAngleEnemy(enemyPos(1,1),enemyPos(1,2))
        %put dist < sightRange, whatAngleEnemy(enemyPos(1,1),enemyPos(1,2)) > 270
        if dist < sightRange and whatAngleEnemy(enemyPos(1,1),enemyPos(1,2)) > 270 or  whatAngleEnemy(enemyPos(1,1),enemyPos(1,2)) < 90 then %if player is within range and in front on enemy he sees him
            enemyShoot
        end if
    else
        locate(2,1)
        put enemyPos(1,2) < y + 900, " and ", enemyPos(1,1) > x + 1300
        locate(3,1)
        put enemyPos(1,2) < y + 900, " and ", enemyPos(1,1) > x + 680
        locate(4,1)
        put enemyPos(1,2) < y + 320, " and ", enemyPos(1,1) > x + 680
        locate(5,1)
        put enemyPos(1,2) < y + 320, " and ", enemyPos(1,1) > x + 1300
    end if
    */

end enemyAnimate

% 563,623

loop
    %Pic.Draw(pics(1),500+camera.x,500+camera.y,0)
    Sprite.SetPosition(enemy,500,500,true)
    Sprite.Show(enemy)
    Sprite.SetHeight(enemy,2)
    Sprite.Animate(enemy,enemySprite(1),enemyPos(1,1),enemyPos(1,2),true)
    View.Update
    enemyPos(1,1) += 6
    mousewhere(mousex,mousey,button)
    if absEnemyPos(1,2) > 950 and absEnemyPos(1,2) < 1050 and absEnemyPos(1,1) < -255 then
        locate(2,1)
        put "carbon2Hall"
        View.Update
        delay(50)
    end if
    if x > -1152 and x < 10 and y > -213 and y < -141 then
      playerRoom := "carbon2Hall"
    elsif x > -438 and x < -360 and y < 155 and y > -1355 then
      playerRoom := "carbon2Wood"
    elsif x > -800 and x < 10 and y < 155 and y > -513 then
      playerRoom := "carbon"
    end if
    playerAnimate
    movement
    enemyAnimate
    View.Update
    Sprite.SetPosition (player, maxx div 2, maxy div 2, true)
    Sprite.Show (player)
    locate(1,1)
    put absEnemyPos(1,1),"and",absEnemyPos(1,2)
    %put mousex + 942,"and",mousey - 359
    %put x,"and",y
    %put dist, "dist", whatAngleEnemy(enemy(1,1),enemy(1,2))
    View.Update
    delay(50)
end loop
%x := -942
%y := 359
