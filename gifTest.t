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
%View.Set("graphics:1260,900") % Release
const mainLevel :int := Pic.FileNew("mainLevel.jpg")
%record items for enemy : player last seen position, dead?
type vector:
record
    x, y :int
end record
var count : int
type inputEffect:
record
    input :char
    effect :vector
end record

type coordinate:
record
    x : int
    y : int
end record

type enemy:
record
    x : int
    y : int
    randMove : int
    moveDirection : string
    dead : boolean
    pLast : vector
    path : array 1 .. 100 of coordinate
    firstMove : int
    enemyPath : boolean
end record

type box:
record
    start : boolean
    goal : boolean
    leftB  : coordinate
    rightB : coordinate
    leftT  : coordinate
    rightT : coordinate
    wall   : boolean
    parent : coordinate
end record

type arrayElement:
record
    a : int
    b : int
    fScore : int
end record
var pathing : boolean := false
var counter :int := 0
var pathfind : boolean := true
var loops : int := 0
var grid : array 1..60,1..53 of box
var q : flexible array 1 .. 0 of arrayElement
var searched : flexible array 1 .. 0 of arrayElement
var camera : vector := init(0, 0)
var gridUpdate : int := Time.Elapsed
var shootDelay : int := Time.Elapsed
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
var start,goal : coordinate
var postMove : vector
    camera.x := -930
camera.y := 300
var newPath : boolean := false
var numFrames := Pic.Frames ("walkGIFbluetrans.gif")
var numFramesEnemy := Pic.Frames ("walkGIFbluetransEnemy.gif")
var delayTime,delayTime2 : int
var enemySprite    : array 1 .. numFramesEnemy of int
var enemySprite90  : array 1 .. numFramesEnemy of int
var enemySprite180 : array 1 .. numFramesEnemy of int
var enemySprite270 : array 1 .. numFramesEnemy of int
var test : int := Pic.FileNew("sprPWalkDoubleBarrel_0.bmp")
var enemy1 : enemy
var pics    : array 1 .. numFrames of int
var pics180 : array 1 .. numFrames of int
var pics45  : array 1 .. numFrames of int
var pics90  : array 1 .. numFrames of int
var pics135 : array 1 .. numFrames of int
var pics270 : array 1 .. numFrames of int
var pics225 : array 1 .. numFrames of int
var pics315 : array 1 .. numFrames of int
var chars: array char of boolean
var openX,openY : int
var pathfound : boolean := false
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
enemy1.enemyPath := false
var initialize : boolean := true

var shootDirection : int := 0
speed := 2
x := -942
y := 359
bulletPos(1).x := maxx div 2
bulletPos(1).y := maxy div 2

Pic.FileNewFrames ("walkGIFbluetrans.gif", pics, delayTime)
Pic.FileNewFrames ("walkGIFbluetransEnemy.gif", enemySprite, delayTime2)
% Sets all elements to 0 to see when the array elements start
for i : 1 .. upper(enemy1.path)
    enemy1.path(i).x := 0
    enemy1.path(i).y := 0
end for
    var player: int := Sprite.New(pics(1))
var enemySPR : int := Sprite.New(enemySprite(1))

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
    
process gunShot
    Music.PlayFile("_audio/shotgunFire.mp3")
    Music.PlayFile("_audio/shotgunReload.mp3")
end gunShot    

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
    postMove.x := x
    postMove.y := y
    Input.KeyDown(key)
    for i : 1 .. upper(inputEffects)
        if key(inputEffects(i).input) then
            postMove.x -= inputEffects(i).effect.x
            postMove.y -= inputEffects(i).effect.y
        end if
    end for
        
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
%12,5
proc draw
    for i : 1 .. 60
        for j : 1 .. 53
            grid(i,j).wall := false
            grid(i,j).start := false
            grid(i,j).goal := false
            grid(i,j).leftB.x := i*50-50
            grid(i,j).leftB.y := j*50-50
            grid(i,j).rightB.x := i*50
            grid(i,j).rightB.y := j*50-50
            grid(i,j).rightT.x := i*50
            grid(i,j).rightT.y := j*50
            grid(i,j).leftT.x := i*50-50
            grid(i,j).leftT.y :=j*50
            if collisionDetect(grid(i,j).leftB.x+camera.x, grid(i,j).leftB.y+camera.y)  or collisionDetect(grid(i,j).rightB.x+camera.x,grid(i,j).rightB.y+camera.y) or collisionDetect(grid(i,j).leftT.x+camera.x,grid(i,j).leftT.y+camera.y) or collisionDetect(grid(i,j).rightT.x+camera.x,grid(i,j).rightT.y+camera.y)then
                grid(i,j).wall := true
            end if
        end for
    end for
end draw
draw

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
    Font.Draw("Bullet Y: " + intstr(grid(6,20).leftB.y),0,450,font1,black)
    Font.Draw("Bullet X: " + intstr(grid(6,20).leftB.x),0,420,font1,black)
    Font.Draw(intstr(upper(searched)),0,670,font1,black)
    Draw.FillBox(grid(goal.x,goal.y).leftB.x+camera.x,grid(goal.x,goal.y).leftB.y+camera.y,grid(goal.x,goal.y).rightT.x+camera.x,grid(goal.x,goal.y).rightT.y+camera.y,yellow)
    Font.Draw(intstr(q(lower(q)).fScore)+" "+intstr(openX)+" "+intstr(openY),0,640,font1,black)

        View.Update
    
end movement

function contains (x,y : int, list : array 1..* of arrayElement) : boolean
    for i : 1 .. upper(list)
        if list(i).a = x and list(i).b = y then
            result true
        end if
    end for
        result false
end contains

proc aStar(startX,startY,goalX,goalY:int)
    loops += 1
    if initialize then
        for i : 1 .. 60
            for j : 1 .. 53
                %put grid(i,j).leftB.x, "<=", goalX,"<", grid(i,j).rightB.x, " ", grid(i,j).leftB.y,"<=",goalY ,"<",grid(i,j).leftT.y
                if grid(i,j).leftB.x > 1200 then
                    %delay(100)
                end if
                if startX >= grid(i,j).leftB.x and startX < grid(i,j).rightB.x and startY >= grid(i,j).leftB.y and startY < grid(i,j).leftT.y then
                    put "test"
                    delay(500)
                    start.x := i
                    start.y := j
                    grid(i,j).start := true
                    new q, upper(q)+1
                    q(upper(q)).a := i
                    q(upper(q)).b := j
                end if
                if goalX >= grid(i,j).leftB.x and goalX < grid(i,j).rightB.x and goalY >= grid(i,j).leftB.y and goalY < grid(i,j).leftT.y then
                    put "Goal!"
                    delay(1000)
                    grid(i,j).goal := true
                    goal.x := i
                    goal.y := j
                end if
            end for
        end for
            initialize := false
    end if
    %Open first item in queue and remove from list
    openX := q(lower(q)).a
    openY := q(lower(q)).b
    new searched, upper(searched) + 1
    searched(upper(searched)) := q(lower(q))
    for i : 1 .. upper(q)-1
        q(i) := q(i+1)
    end for
        new q, upper(q)-1
    %Draw.FillBox(grid(openX,openY).leftB.x+camera.x,grid(openX,openY).leftB.y+camera.y,grid(openX,openY).rightT.x+camera.x,grid(openX,openY).rightT.y+camera.y,yellow)
    View.Update
    %Add surrounding tiles to queue
    %Up Tile
    if openX+1 <= upper(grid,1) then
        if grid(openX+1,openY). wall = false and contains(openX+1,openY,searched) = false and contains(openX+1,openY,q) = false then
            new q, upper(q) + 1
            q(upper(q)).a := openX + 1
            q(upper(q)).b := openY
            grid(openX+1,openY).parent.x := openX
            grid(openX+1,openY).parent.y := openY
            q(upper(q)).fScore := round( 8*(abs((openX+1)-goal.x) + abs(openY-goal.y)) + (abs((openX+1)-start.x) + abs(openY-start.y)))
        end if
    end if
    %Down Tile
    if openX-1 >= 1 then
        if grid(openX-1,openY). wall = false and contains(openX-1,openY,searched) = false and contains(openX-1,openY,q) = false then
            new q, upper(q) + 1
            q(upper(q)).a := openX - 1
            q(upper(q)).b := openY
            grid(openX-1,openY).parent.x := openX
            grid(openX-1,openY).parent.y := openY
            q(upper(q)).fScore := round( 8*(abs((openX-1)-goal.x) + abs(openY-goal.y)) + (abs((openX-1)-start.x) + abs(openY-start.y)))
        end if
    end if
    %Left Tile
    if openY+1 <= upper(grid,2) then
        if grid(openX,openY+1). wall = false and contains(openX,openY+1,searched) = false and contains(openX,openY+1,q) = false then
            new q, upper(q) + 1
            q(upper(q)).a := openX
            q(upper(q)).b := openY + 1
            grid(openX,openY+1).parent.x := openX
            grid(openX,openY+1).parent.y := openY
            q(upper(q)).fScore := round( 8*(abs(openX-goal.x) + abs((openY+1)-goal.y)) + (abs(openX-start.x) + abs((openY+1)-start.y)))
        end if
    end if
    %Right Tile
    if openY-1 >= lower(grid,1) then            
        if grid(openX,openY-1). wall = false and contains(openX,openY-1,searched) = false and contains(openX,openY-1,q) = false then
            new q, upper(q) + 1
            q(upper(q)).a := openX
            q(upper(q)).b := openY - 1
            grid(openX,openY-1).parent.x := openX
            grid(openX,openY-1).parent.y := openY
            q(upper(q)).fScore := round( 8*(abs(openX-goal.x) + abs((openY-1)-goal.y)) + (abs(openX-start.x) + abs((openY-1)-start.y)))
        end if
    end if
    %Sort
    var temp : arrayElement
    for a : 1 .. upper(q)
        for i : 1 .. (upper(q)-1)
            if q(i).fScore > q(i+1).fScore then
                temp := q(i)
                q(i) := q(i+1)
                q(i+1) := temp
            end if
        end for
    end for
    if openX = goal.x and openY = goal.y then
        enemy1.path(100).x := openX
        enemy1.path(100).y := openY
        enemy1.path(99).x := grid(openX,openY).parent.x
        enemy1.path(99).y := grid(openX,openY).parent.y
        counter := 98
        loop
            enemy1.path(counter).x := grid(enemy1.path(counter+1).x, enemy1.path(counter+1).y).parent.x
            enemy1.path(counter).y := grid(enemy1.path(counter+1).x, enemy1.path(counter+1).y).parent.y
            counter -= 1
            if enemy1.path(counter+1).x = start.x and enemy1.path(counter+1).y = start.y then
                pathfind := false
                exit
            end if

        end loop
        enemy1.firstMove := counter
        enemy1.enemyPath := true
        newPath := true
        pathing := true
        count := enemy1.firstMove + 1
    end if
end aStar

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

Sprite.SetPosition(enemySPR,enemyPos(1).x,enemyPos(1).y,true)


procedure enemyShoot
    enemy1.pLast.x := maxx div 2 - camera.x
    enemy1.pLast.y := maxy div 2 - camera.y
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

enemy1.moveDirection := "null"

proc AISearch (var enemyNum : enemy)
    Sprite.Show(enemySPR)
    Sprite.SetHeight(enemySPR,2)
    enemyNum.randMove := Rand.Int(1,4)
    if enemyNum.moveDirection = "null" then
        if enemyNum.randMove = 1 then
            if collisionDetect(enemyPos(1).x+camera.x,enemyPos(1).y+camera.y+20) = false then
                enemyNum.moveDirection := "up"
            end if
        elsif enemyNum.randMove = 2 then
            if collisionDetect(enemyPos(1).x+camera.x+20,enemyPos(1).y+camera.y) = false then
                enemyNum.moveDirection := "right"
            end if
        elsif enemyNum.randMove = 3 then
            if collisionDetect(enemyPos(1).x+camera.x-20,enemyPos(1).y+camera.y) = false then
                enemyNum.moveDirection := "left"
            end if
        elsif enemyNum.randMove = 4 then
            if collisionDetect(enemyPos(1).x+camera.x,enemyPos(1).y+camera.y-20) = false then
                enemyNum.moveDirection:= "down"
            end if
        end if
    end if
    if enemyNum.moveDirection = "right" then
        if collisionDetect(enemyPos(1).x+camera.x+20,enemyPos(1).y+camera.y) = false then
            Sprite.Animate(enemySPR,enemySprite(enemyFrame),enemyPos(1).x+camera.x,enemyPos(1).y+camera.y,true)
            enemyPos(1).x += 2
        else
            enemyNum.moveDirection := "null"
        end if
    elsif enemyNum.moveDirection = "down" then
        if collisionDetect(enemyPos(1).x+camera.x,enemyPos(1).y+camera.y-20) = false then
            Sprite.Animate(enemySPR,enemySprite270(enemyFrame),enemyPos(1).x+camera.x,enemyPos(1).y+camera.y,true)
            enemyPos(1).y -= 2
        else
            enemyNum.moveDirection := "null"
        end if
    elsif enemyNum.moveDirection = "up" then
        if collisionDetect(enemyPos(1).x+camera.x,enemyPos(1).y+camera.y+20) = false then
            Sprite.Animate(enemySPR,enemySprite90(enemyFrame),enemyPos(1).x+camera.x,enemyPos(1).y+camera.y,true)
            enemyPos(1).y += 2
        else
            enemyNum.moveDirection := "null"
        end if
    elsif enemyNum.moveDirection = "left" then
        if collisionDetect(enemyPos(1).x+camera.x-20,enemyPos(1).y+camera.y) = false then
            Sprite.Animate(enemySPR,enemySprite180(enemyFrame),enemyPos(1).x+camera.x,enemyPos(1).y+camera.y,true)
            enemyPos(1).x -= 2
        else
            enemyNum.moveDirection := "null"
        end if
    end if
    if Time.Elapsed - lastEnemyFrame > 100 then
        lastEnemyFrame := Time.Elapsed
        if enemyFrame = 8 then
            enemyFrame := 0
        end if
        enemyFrame += 1
    end if
end AISearch

procedure enemyAnimate
    if enemyDead = false and key('v')=false then
        Sprite.SetPosition(enemySPR,500-camera.x,500-camera.y,true)
        Sprite.Show(enemySPR)
        Sprite.SetHeight(enemySPR,2)
        if enemyPos(1).y < 930 and enemyPos(1).x = 1330 then
            Sprite.Animate(enemySPR,enemySprite90(enemyFrame),enemyPos(1).x+camera.x,enemyPos(1).y+camera.y,true)
            enemyPos(1).y += 1
        elsif enemyPos(1).y = 930 and enemyPos(1).x > 660 then
            Sprite.Animate(enemySPR,enemySprite180(enemyFrame),enemyPos(1).x+camera.x,enemyPos(1).y+camera.y,true)
            enemyPos(1).x -= 1
        elsif enemyPos(1).x = 660 and enemyPos(1).y > 320 then
            Sprite.Animate(enemySPR,enemySprite270(enemyFrame),enemyPos(1).x+camera.x,enemyPos(1).y+camera.y,true)
            enemyPos(1).y -= 1
        elsif enemyPos(1).x >= 660 and enemyPos(1).y <= 320 then
            Sprite.Animate(enemySPR,enemySprite(enemyFrame),enemyPos(1).x+camera.x,enemyPos(1).y+camera.y,true)
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
        Sprite.Animate(enemySPR,eKill1IMG,enemyPos(1).x+camera.x,enemyPos(1).y+camera.y,true)
        View.Update
    end if
    if Math.Distance(enemyPos(1).x+camera.x,enemyPos(1).y+camera.y,bulletPos(1).x,bulletPos(1).y) < 50 and shoot then
        enemyDead := true
    end if
end enemyAnimate
   
proc enemyPathing
    if enemy1.enemyPath and newPath then
        newPath := false
    end if
%(grid(enemy1.path(count).x,enemy1.path(count).y).leftB.x+25,grid(enemy1.path(count).x,enemy1.path(count).y).leftB.y+25
    if enemyPos(1).x - grid(enemy1.path(count).x,enemy1.path(count).y).leftB.x < 0 then
        enemyPos(1).x += 2
    elsif enemyPos(1).x - grid(enemy1.path(count).x,enemy1.path(count).y).leftB.x > 0 then
        enemyPos(1).x -= 2
    end if
    
    if enemyPos(1).y - grid(enemy1.path(count).x,enemy1.path(count).y).leftB.y < 0 then
        enemyPos(1).y += 2
    elsif enemyPos(1).y - grid(enemy1.path(count).x,enemy1.path(count).y).leftB.y > 0 then
        enemyPos(1).y -= 2
    end if
    Sprite.Animate(enemySPR,enemySprite(enemyFrame),enemyPos(1).x+camera.x,enemyPos(1).y+camera.y,true)
    if enemyPos(1).x - grid(enemy1.path(count).x,enemy1.path(count).y).leftB.x > -1 and enemyPos(1).x - grid(enemy1.path(count).x,enemy1.path(count).y).leftB.x < 1 and enemyPos(1).y - grid(enemy1.path(count).x,enemy1.path(count).y).leftB.y > -1 and enemyPos(1).y - grid(enemy1.path(count).x,enemy1.path(count).y).leftB.y < 1 then
        count += 1
    end if
    if count = 101 then 
        pathing := false
    end if
    if Time.Elapsed - lastEnemyFrame > 100 then
        lastEnemyFrame := Time.Elapsed
        if enemyFrame = 8 then
            enemyFrame := 0
        end if
        enemyFrame += 1
    end if
end enemyPathing
proc playerShoot
    %fork gunShot
    if shootDirection not= playerDirection and shootDirection not= 0 then
        playerDirection := shootDirection
    end if
    Sprite.Show(bulletSPR)
    Sprite.Animate(bulletSPR,bulletIMG,bulletPos(1).x,bulletPos(1).y,true)
    if playerDirection = 1 then
        shootDirection := 1
        bulletPos(1).x += 50
        if bulletPos(1).x > maxx + 50 or collisionDetect(bulletPos(1).x-10,bulletPos(1).y) then
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
    elsif playerDirection = 4 then
        shootDirection := 4
        bulletPos(1).x -= 50
        bulletPos(1).y += 50
        if bulletPos(1).x < -20 or collisionDetect(bulletPos(1).x+20,bulletPos(1).y-50) then
            shoot:= false
            bulletPos(1).x := maxx div 2
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
    %draw
    if pathfind then
        aStar(enemyPos(1).x,enemyPos(1).y,2001,705)
    end if        
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
    %enemyAnimate
    if key(' ') and (Time.Elapsed - shootDelay) > 1000 then
        shootDelay := Time.Elapsed
        shoot := true
    end if
    if shoot then
        playerShoot
    end if
    if pathing = false then
        AISearch(enemy1)
    end if
    if pathing then
        enemyPathing
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
