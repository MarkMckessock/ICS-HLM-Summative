% Rebuild getangle function
% Resize character - DONE
% Make new character in photoshop (4 frames/image)
% Wall collision detection - DONE
% Shooting
%Make bullet sprite for 8 directions
% Build function for 8 directions
% Make transparent sprites for enemy
% Enemy pathing
% Enemy Shooting
% Eliminate processes
%%%%% Bonus %%%%%
% Add sitting animations

%When an enemy sees player save their location and navigate to it then search or return to loop
View.Set("graphics:1260,900,offscreenonly") % Release
const mainLevel :int := Pic.FileNew("mainLevel.jpg")

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
var eKill1IMG : int := Pic.FileNew("enemyKill1.bmp")
var eKill1SPR : int := Sprite.New(eKill1IMG)
var enemyDead : boolean := false
var inputEffects :array 1 .. 4 of inputEffect := init(init('a', init(6, 0)), init('d', init(-6, 0)), init('w', init(0, -6)), init('s', init(0,6)))
var shoot : boolean := false
var key :array char of boolean
var bulletIMG : int := Pic.FileNew("bullet.gif")
var bulletSPR : int := Sprite.New(bulletIMG)
var lastInputCheck :int := 0
var lastFrame : int := 0
var lastEnemyFrame : int := 0
var playerDirection : int
var postMove : vector
    camera.x := -930
camera.y := 300
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
var enemyPos : array 1 .. 3 of vector
    var bulletPos : array 1 .. 3 of vector
    enemyPos(1).x := 1330
enemyPos(1).y := 350
var sightRange : int := 300
var dist : real
var playerRoom : string := ""
var shootDirection : int := 0
speed := 2
x := -942
y := 359
bulletPos(1).x := maxx div 2
bulletPos(1).y := maxy div 2

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

function collisionDetect (x,y: int) : boolean %checks if the currect coordinates collide with a wall
    %postMove.x := camera.x
    postMove.x := x
    %postMove.y := camera.y
    postMove.y := y
    Input.KeyDown(key)
    for i : 1 .. upper(inputEffects)
        if key(inputEffects(i).input) then
            postMove.x -= inputEffects(i).effect.x
            postMove.y -= inputEffects(i).effect.y
        end if
    end for
        %if moveDirection  = "x" then
    if (postMove.x > 560+camera.x) and (postMove.x < 1530+camera.x) and (postMove.y > 217+camera.y) and (postMove.y < 288+camera.y) then % Bottom, left Brick wall
        result true
    elsif (postMove.x > 686+camera.x) and (postMove.x < 750+camera.x) and (postMove.y > 1384+camera.y) and (postMove.y < 1857+camera.y) then % Left, Top wall of hardwood
        result true
    elsif (postMove.x > 686+camera.x) and (postMove.x < 1433+camera.x) and (postMove.y > 1785+camera.y) and (postMove.y < 1857+camera.y) then % Top Wall of hardwood 
        result true
    elsif (postMove.x > 1071+camera.x) and (postMove.x < 1433+camera.x) and (postMove.y > 952+camera.y) and (postMove.y < 1025+camera.y) then % Top,Right wall of carbon
        result true
    elsif (postMove.x > 1360+camera.x) and (postMove.x < 1433+camera.x) and (postMove.y > 1657+camera.y) and (postMove.y < 1856+camera.y) then % Right, Top wall of hardwood room
        result true
    elsif (postMove.x > 1360+camera.x) and (postMove.x < 1433+camera.x) and (postMove.y > 217+camera.y) and (postMove.y < 578+camera.y) then % Right, Bottom Wall of carbon room
        result true
    elsif (postMove.x > 1360+camera.x) and (postMove.x < 1433+camera.x) and (postMove.y > 665+camera.y) and (postMove.y < 1573+camera.y) then % Right, Top Wall of carbon room
        result true
    elsif (postMove.x > 271+camera.x) and (postMove.x < 985+camera.x) and (postMove.y > 952+camera.y) and (postMove.y < 1025+camera.y) then % Bottom, Left wall of hardwood room
        result true
    elsif (postMove.x > 686+camera.x) and (postMove.x < 750+camera.x) and (postMove.y > 952+camera.y) and (postMove.y < 1297+camera.y) then % Left, Bottom wall of hardwood room
        result true
    elsif (postMove.x > 560+camera.x) and (postMove.x < 631+camera.x) and (postMove.y > 217+camera.y) and (postMove.y < 1025+camera.y) then % Left wall of carbon room
        result true
    elsif (postMove.x > 272+camera.x) and (postMove.x < 345+camera.x) and (postMove.y > 952+camera.y) and (postMove.y < 2247+camera.y) then % Left-most wall
        result true
    elsif (postMove.x > 272+camera.x) and (postMove.x < 1552+camera.x) and (postMove.y > 2175+camera.y) and (postMove.y < 2247+camera.y) then % Top, Left wall
        result true
    elsif (postMove.x > 1637+camera.x) and (postMove.x < 2990+camera.x) and (postMove.y > 2175+camera.y) and (postMove.y < 2247+camera.y) then % Top, Right wall
        result true
    elsif (postMove.x > 1616+camera.x) and (postMove.x < 2449+camera.x) and (postMove.y > 217+camera.y) and (postMove.y < 288+camera.y) then % Bottom, Right Wall
        result true
    elsif (postMove.x > 1776+camera.x) and (postMove.x < 1849+camera.x) and (postMove.y > 217+camera.y) and (postMove.y < 993+camera.y) then % Left, Bottom Wall of red room
        result true
    elsif (postMove.x > 2375+camera.x) and (postMove.x < 2448+camera.x) and (postMove.y > 217+camera.y) and (postMove.y < 1425+camera.y) then % Right Wall of red room
        result true
        /*
    elsif (postMove.x > -1230) and (postMove.x < -1152) and (postMove.y > -1419) and (postMove.y < -627) then % Left, Top Wall of red room / Left wall of purple room
        result true
    elsif (postMove.x > -1506) and (postMove.x < -1152) and (postMove.y > -983) and (postMove.y < -887) then % Left wall between red and purple room
        result true
    elsif (postMove.x > -1816) and (postMove.x < -1574) and (postMove.y > -983) and (postMove.y < -887) then % Right wall between red and purple room
        result true
    elsif (postMove.x > -1924) and (postMove.x < -1152) and (postMove.y > -1415) and (postMove.y < -1319) then % Top, Left wall of purple room
        result true
    elsif (postMove.x > -2366) and (postMove.x < -1986) and (postMove.y > -1415) and (postMove.y < -1319) then % Top, Right wall of purple room
        result true
    elsif (postMove.x > -2370) and (postMove.x < -2278) and (postMove.y > -1801) and (postMove.y < -1213) then % Right, Top wall of purple room
        result true
    elsif (postMove.x > -2370) and (postMove.x < -2278) and (postMove.y > -1147) and (postMove.y < -463) then % Right, Bottom wall of purple room
        result true
    elsif (postMove.x > -2370) and (postMove.x < -1735) and (postMove.y > -555) and (postMove.y < -459 ) then % Bottom wall of purple room
        result true
    elsif (postMove.x > -812) and (postMove.x < -716) and (postMove.y > -2179) and (postMove.y < -1729 ) then % Left wall of elevator
            result true
    elsif (postMove.x > -1226) and (postMove.x < -1136) and (postMove.y > -2179) and (postMove.y < -1729 ) then % Right wall of elevator
            result true
    elsif (postMove.x > -1226) and (postMove.x < -716) and (postMove.y > -2179) and (postMove.y < -2089) then % Top wall of elevator
            result true
        */
    end if
    result false
end collisionDetect

procedure movement
    Input.KeyDown(key)
    
    %if Time.Elapsed - lastInputCheck > 1 then
    lastInputCheck := Time.Elapsed
    for i : 1 .. upper(inputEffects)
        if key(inputEffects(i).input) then
            if collisionDetect(maxx div 2,maxy div 2)=false then
                camera.x += inputEffects(i).effect.x
                camera.y += inputEffects(i).effect.y
            end if
        end if
    end for 
        %end if 
    cls
    Pic.Draw(mainLevel, spongebobPos.x + camera.x, spongebobPos.y + camera.y, picCopy)
    Font.Draw("Camera X: " + intstr(camera.x), 0, 600, font1, black)
    Font.Draw("Camera Y: " + intstr(camera.y), 0, 570, font1, black)
    Font.Draw(playerRoom,0,540,font1,black)
    Font.Draw("Enemy X: " + intstr(enemyPos(1).x),0,510,font1,black)
    Font.Draw("Enemy Y: " + intstr(enemyPos(1).y),0,480,font1,black)
    Font.Draw("Bullet Y: " + intstr(bulletPos(1).y),0,450,font1,black)
    Font.Draw("Bullet X: " + intstr(bulletPos(1).x),0,420,font1,black)
    Draw.Box(maxx div 2 - 30,maxy div 2 - 30,maxx div 2 + 30,maxy div 2 + 30,black)
    View.Update
end movement

procedure playerAnimate
    Sprite.SetPosition (player, maxx div 2, maxy div 2, true)
    Sprite.Show (player)
    if Time.Elapsed - lastFrame > 100 then
        lastFrame := Time.Elapsed
        if whatAngle(maxx div 2,maxy div 2) < 22.5 or whatAngle(maxx div 2,maxy div 2) >= 337.5 then
            Sprite.ChangePic(player, pics(playerFrame))
            playerDirection := 1 %Facing Right
        elsif whatAngle(maxx div 2,maxy div 2) >= 22.5 and whatAngle(maxx div 2,maxy div 2) < 67.5 then
            Sprite.ChangePic(player, pics45(playerFrame))
            playerDirection := 2 % Facing Right and Up
        elsif whatAngle(maxx div 2,maxy div 2) >= 67.5 and whatAngle(maxx div 2,maxy div 2) < 112.5 then
            Sprite.ChangePic(player, pics90(playerFrame))
            playerDirection := 3 % Facing Up
        elsif whatAngle(maxx div 2,maxy div 2) >= 112.5 and whatAngle(maxx div 2,maxy div 2) < 157.5 then
            Sprite.ChangePic(player, pics135(playerFrame))
            playerDirection := 4 % Facing Left and Up
        elsif whatAngle(maxx div 2,maxy div 2) >= 157.5 and whatAngle(maxx div 2,maxy div 2) < 202.5 then
            Sprite.ChangePic(player, pics180(playerFrame))
            playerDirection:=  5 % Facing Left
        elsif whatAngle(maxx div 2,maxy div 2) >= 202.5 and whatAngle(maxx div 2,maxy div 2) < 247.5 then
            Sprite.ChangePic(player, pics225(playerFrame))
            playerDirection := 6 % Facing Left and Down
        elsif whatAngle(maxx div 2,maxy div 2) >= 247.5 and whatAngle(maxx div 2,maxy div 2) < 292.5 then
            Sprite.ChangePic(player, pics270(playerFrame))
            playerDirection := 7 % Facing Down
        elsif whatAngle(maxx div 2,maxy div 2) >= 292.5 and whatAngle(maxx div 2,maxy div 2) < 337.5 then
            Sprite.ChangePic(player, pics315(playerFrame))
            playerDirection := 8 % Facing Right and Down
        end if
        
        if playerFrame = 8 then
            playerFrame := 0
        end if
        playerFrame += 1
    end if
end playerAnimate

Sprite.SetPosition(enemy,enemyPos(1).x,enemyPos(1).y,true)


procedure enemyShoot
    var roll : int := Rand.Int(1,2)
    var roll2 : int := Rand.Int(1,2)
    var missX : int := Rand.Int(0,100)
    var missY : int := Rand.Int(0,100)
    if roll = 1 then
        Draw.Line(enemyPos(1).x,enemyPos(1).y,maxx div 2,maxy div 2,black)
        locate(1,1)
        %put "You Died!"
        %Animate Bullet
        %Change to dead sprite
        %Game over procedure
    else
        if roll2 = 1 then
            Draw.Line(enemyPos(1).x,enemyPos(1).y,(maxx div 2)-missX,(maxy div 2) + missY,black)
        else
            Draw.Line(enemyPos(1).x,enemyPos(1).y,(maxx div 2)+missX, (maxy div 2) - missY,black)
        end if
    end if
end enemyShoot


procedure enemyAnimate
    %Sprite.Animate(enemy,enemySprite90(enemyFrame),enemyPos.x,enemyPos.y,true) %Animate
    /*
    if (chars (KEY_UP_ARROW) or chars('w')) and collisionDetect(x,y) = 0 then
    enemyPos.y := enemyPos.y - (speed * 6)
elsif (chars (KEY_DOWN_ARROW) or chars('s')) and collisionDetect(x,y) = 0 then
    enemyPos.y := enemyPos.y + (speed * 6)
elsif (chars (KEY_LEFT_ARROW) or chars('a')) and collisionDetect(x,y) = 0 then
    enemyPos.x := enemyPos.x + (speed * 6)
elsif (chars (KEY_RIGHT_ARROW) or chars('d')) and collisionDetect(x,y) = 0 then
    enemyPos.x := enemyPos.x - (speed * 6)
    end if
    %Draw.Oval(x+1300,y+900,100,100,red)
    %Sprite.ChangePic(enemy,enemySprite(enemyFrame))
    Sprite.Show(enemy)
    if enemyPos.y < y + 900 and enemyPos.x > x + 1300 then % Walking up
    enemyPos.y += 6 % Move upwards
    absEnemyPos(1,2) += 6
    Sprite.Animate(enemy,enemySprite90(enemyFrame),enemyPos.x,enemyPos.y,true) %Animate
    %for i : 1 .. sightRange by 3
    dist := Math.DistancePointLine(maxx div 2,maxy div 2,enemyPos.x,enemyPos.y,enemyPos.x,enemyPos.y + sightRange)
    Draw.Line(enemyPos.x,enemyPos.y,enemyPos.x,enemyPos.y + sightRange,black)
    %put whatAngleEnemy(enemyPos.x,enemyPos.y)
    if dist < sightRange and whatAngleEnemy(enemyPos.x,enemyPos.y) > 0 and whatAngleEnemy(enemyPos.x,enemyPos.y) < 180 then
    enemyShoot
    end if
    %end for
    elsif enemyPos.y > y + 900 and enemyPos.x > x + 680 then
    enemyPos.x -= 6
    absEnemyPos(1,1) -= 6
    Sprite.Animate(enemy,enemySprite180(enemyFrame),enemyPos.x,enemyPos.y,true)
    dist := Math.DistancePointLine(maxx div 2,maxy div 2,enemyPos.x,enemyPos.y,enemyPos.x - sightRange,enemyPos.y)
    Draw.Line(enemyPos.x,enemyPos.y,enemyPos.x - 300,enemyPos.y,black)
    %put whatAngleEnemy(enemyPos.x,enemyPos.y)
    if dist < sightRange and whatAngleEnemy(enemyPos.x,enemyPos.y) > 90 and whatAngleEnemy(enemyPos.x,enemyPos.y) < 270 then %if player is within range and in front on enemy he sees him
    enemyShoot
    end if
elsif enemyPos.x <= x + 680 and enemyPos.y > y + 320 then
    Sprite.Animate(enemy,enemySprite270(enemyFrame),enemyPos.x,enemyPos.y,true)
    enemyPos.y -= 6
    absEnemyPos(1,2) -= 6
    dist := Math.DistancePointLine(maxx div 2,maxy div 2,enemyPos.x,enemyPos.y,enemyPos.x,enemyPos.y - sightRange)
    Draw.Line(enemyPos.x,enemyPos.y,enemyPos.x,enemyPos.y - 300,black)
    %put whatAngleEnemy(enemyPos.x,enemyPos.y)
    if dist < sightRange and whatAngleEnemy(enemyPos.x,enemyPos.y) > 180 and whatAngleEnemy(enemyPos.x,enemyPos.y) < 360 then %if player is within range and in front on enemy he sees him
    enemyShoot
    end if
elsif enemyPos.x < x + 1300 and enemyPos.y <= y + 320 then
    enemyPos.x += 6
    absEnemyPos(1,1) += 6
    Sprite.Animate(enemy,enemySprite(enemyFrame),enemyPos.x,enemyPos.y,true)
    dist := Math.DistancePointLine(maxx div 2,maxy div 2,enemyPos.x,enemyPos.y,enemyPos.x + sightRange,enemyPos.y)
    Draw.Line(enemyPos.x,enemyPos.y,enemyPos.x + 300,enemyPos.y,black)
    %put whatAngleEnemy(enemyPos.x,enemyPos.y)
    %put dist < sightRange, whatAngleEnemy(enemyPos.x,enemyPos.y) > 270
    if dist < sightRange and whatAngleEnemy(enemyPos.x,enemyPos.y) > 270 or  whatAngleEnemy(enemyPos.x,enemyPos.y) < 90 then %if player is within range and in front on enemy he sees him
    enemyShoot
    end if
else
    locate(2,1)
    put enemyPos.y < y + 900, " and ", enemyPos.x > x + 1300
    locate(3,1)
    put enemyPos.y < y + 900, " and ", enemyPos.x > x + 680
    locate(4,1)
    put enemyPos.y < y + 320, " and ", enemyPos.x > x + 680
    locate(5,1)
    put enemyPos.y < y + 320, " and ", enemyPos.x > x + 1300
    end if
    */
    %Pic.Draw(pics(1),500+camera.x,500+camera.y,0)
    if enemyDead = false then
        Sprite.SetPosition(enemy,500-camera.x,500-camera.y,true)
        Sprite.Show(enemy)
        Sprite.SetHeight(enemy,2)
        if enemyPos(1).y < 930 and enemyPos(1).x = 1330 then
            Sprite.Animate(enemy,enemySprite90(enemyFrame),enemyPos(1).x+camera.x,enemyPos(1).y+camera.y,true)
            enemyPos(1).y += 1
        elsif enemyPos(1).y = 930 and enemyPos(1).x > 660 then
            Sprite.Animate(enemy,enemySprite180(enemyFrame),enemyPos(1).x+camera.x,enemyPos(1).y+camera.y,true)
            enemyPos(1).x -= 1
        elsif enemyPos(1).x = 660 and enemyPos(1).y > 320 then
            Sprite.Animate(enemy,enemySprite270(enemyFrame),enemyPos(1).x+camera.x,enemyPos(1).y+camera.y,true)
            enemyPos(1).y -= 1
        elsif enemyPos(1).x >= 660 and enemyPos(1).y <= 320 then
            Sprite.Animate(enemy,enemySprite(enemyFrame),enemyPos(1).x+camera.x,enemyPos(1).y+camera.y,true)
            enemyPos(1).x += 1
        end if
        View.Update
        
        
        if Time.Elapsed - lastEnemyFrame > 100 then
            lastEnemyFrame := Time.Elapsed
            if enemyFrame = 8 then
                enemyFrame := 0
            end if
            enemyFrame += 1
        end if
    elsif enemyDead then
        Sprite.Animate(enemy,eKill1IMG,enemyPos(1).x+camera.x,enemyPos(1).y+camera.y,true)
        View.Update
    end if
    if Math.Distance(enemyPos(1).x+camera.x,enemyPos(1).y+camera.y,bulletPos(1).x,bulletPos(1).y) < 50 and shoot then
        enemyDead := true
    end if
end enemyAnimate

proc playerShoot
    if shootDirection not= playerDirection and shootDirection not= 0 then
        playerDirection := shootDirection
    end if
        Sprite.Show(bulletSPR)
        Sprite.Animate(bulletSPR,bulletIMG,bulletPos(1).x,bulletPos(1).y,true)
        if playerDirection = 1 then
            shootDirection := 1
            bulletPos(1).x += 50
            if bulletPos(1).x > maxx or collisionDetect(bulletPos(1).x-10,bulletPos(1).y) then
                shoot:= false
                bulletPos(1).x := maxx div 2
                Sprite.Hide(bulletSPR)
                shootDirection := 0
            end if
        elsif playerDirection = 2 then
            shootDirection := 2
            bulletPos(1).y += 50
            bulletPos(1).x += 50
            if bulletPos(1).y > maxy or collisionDetect(bulletPos(1).x-20,bulletPos(1).y) then
                shoot:= false
                bulletPos(1).y := maxy div 2
                bulletPos(1).x := maxx div 2
                Sprite.Hide(bulletSPR)
                shootDirection := 0
            end if
        elsif playerDirection = 3 then
            shootDirection := 3
            bulletPos(1).y += 50
            if bulletPos(1).y > maxy or collisionDetect(bulletPos(1).x,bulletPos(1).y-50) then
                shoot:= false
                bulletPos(1).y := maxy div 2
                Sprite.Hide(bulletSPR)
                shootDirection := 0
            end if
        elsif playerDirection = 5 then
            shootDirection := 5
            bulletPos(1).x -= 50
            if bulletPos(1).x < -20 or collisionDetect(bulletPos(1).x+20,bulletPos(1).y) then
                shoot:= false
                bulletPos(1).x := maxx div 2
                Sprite.Hide(bulletSPR)
                shootDirection := 0
            end if 
        end if
   
end playerShoot
% 563,623

loop
    mousewhere(mousex,mousey,button)
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
    if key(' ') then
        shoot := true
    end if
    if shoot then
        playerShoot
    end if
    View.Update
    x:= camera.x
    y:=camera.y
    %put mousex + 942,"and",mousey - 359
    %put x,"and",y
    %put dist, "dist", whatAngleEnemy(enemy(1,1),enemy(1,2))
    View.Update
end loop
%x := -942
%y := 359
