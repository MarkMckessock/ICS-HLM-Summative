% Rebuild getangle function
% Make new character in photoshop (4 frames/image)
% Shooting
% Make bullet sprite for 8 directions
% Build function for 8 directions
% Make transparent sprites for enemy
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
    enemyRoom : string
    eyesOn : boolean
    timeOnTarget : int
    bullet : int
    shootDelay : int
    targetLocation : coordinate
    shooting : boolean
    status : string
    speed : real
    selfLocation : coordinate
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

type range:
    record
        lower : int
        upper : int
    end record
type wall: 
    record
        x: range
        y : range
    end record
var eBulletPos : array 1 .. 3 of coordinate
var pathing : boolean := false
var counter :int := 0
var pathfind : boolean := false
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
var divVal : int := 2
var detect : string := ""
var pics    : array 1 .. numFrames of int
var pics180 : array 1 .. numFrames of int
var pics45  : array 1 .. numFrames of int
var pics90  : array 1 .. numFrames of int
var pics135 : array 1 .. numFrames of int
var pics270 : array 1 .. numFrames of int
var pics225 : array 1 .. numFrames of int
var pics315 : array 1 .. numFrames of int
var chars: array char of boolean
var setPlayerPos : boolean := true
var openX,openY : int
var pathfound : boolean := false
var x,y, speed, mousex, mousey, button: int
var map1 : int := Pic.FileNew("mainLevel.jpg")
var ratio, angle : real
var font1 : int := Font.New("serif:12")
var playerFrame : int := 1
var enemyFrame : int := 1
var enemyPos : array 1 .. 3 of vector
    var tempPX,tempPY : int := 0
var bulletPos : array 1 .. 3 of vector
    enemyPos(1).x := 1330
enemyPos(1).y := 350
var sightRange : int := 300
var dist : real
var playerRoom : string := ""
enemy1.enemyPath := false
var initialize : boolean := true
var noiseSearch : boolean := false
var walls : array 1 .. 24 of wall
var shootDirection : int := 0
speed := 2
x := -942
y := 359
bulletPos(1).x := maxx div 2
bulletPos(1).y := maxy div 2
eBulletPos(1).x := maxx div 2
eBulletPos(1).y := maxy div 2
enemy1.timeOnTarget := 0
Pic.FileNewFrames ("walkGIFbluetrans.gif", pics, delayTime)
Pic.FileNewFrames ("walkGIFbluetransEnemy.gif", enemySprite, delayTime2)
% Sets all elements to 0 to see when the array elements start
enemy1.dead := false
enemy1.pLast.x := -1
enemy1.pLast.y := -1
enemy1.shootDelay := 0
enemy1.shooting := false
enemy1.bullet := Sprite.New(bulletIMG)
enemy1.status := "neutral"
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
var wallHit : int
function collisionDetect (x,y: int,character : boolean) : boolean %checks if the currect coordinates collide with a wall
    % Bottom, left Brick wall
    walls(1).x.lower := 560  + camera.x
    walls(1).x.upper := 1530 + camera.x
    walls(1).y.lower := 217  + camera.y
    walls(1).y.upper := 288  + camera.y
    % Left, Top wall of hardwood
    walls(2).x.lower := 686  + camera.x
    walls(2).x.upper := 750  + camera.x
    walls(2).y.lower := 1384 + camera.y
    walls(2).y.upper := 1857 + camera.y
    % Top Wall of hardwood 
    walls(3).x.lower := 686  + camera.x
    walls(3).x.upper := 750  + camera.x
    walls(3).y.lower := 1785 + camera.y
    walls(3).y.upper := 1857 + camera.y
    % Top,Right wall of carbon
    walls(4).x.lower := 1071 + camera.x
    walls(4).x.upper := 1433 + camera.x
    walls(4).y.lower := 925  + camera.y
    walls(4).y.upper := 1045 + camera.y
    % Right, Top wall of hardwood room
    walls(5).x.lower := 1360 + camera.x
    walls(5).x.upper := 1433 + camera.x
    walls(5).y.lower := 1657 + camera.y
    walls(5).y.upper := 1857 + camera.y
    % Right, Bottom Wall of carbon room
    walls(6).x.lower := 1360 + camera.x
    walls(6).x.upper := 1433 + camera.x
    walls(6).y.lower := 217  + camera.y
    walls(6).y.upper := 578  + camera.y
    % Right, Top Wall of carbon room
    walls(7).x.lower := 1360 + camera.x
    walls(7).x.upper := 1433 + camera.x
    walls(7).y.lower := 665  + camera.y
    walls(7).y.upper := 1573 + camera.y
    % Bottom, Left wall of hardwood room
    walls(8).x.lower := 271  + camera.x
    walls(8).x.upper := 985  + camera.x
    walls(8).y.lower := 952  + camera.y
    walls(8).y.upper := 1025 + camera.y
    % Left, Bottom wall of hardwood room
    walls(9).x.lower := 686  + camera.x
    walls(9).x.upper := 750  + camera.x
    walls(9).y.lower := 952  + camera.y
    walls(9).y.upper := 1297 + camera.y
    % Left wall of carbon room
    walls(10).x.lower := 560  + camera.x
    walls(10).x.upper := 631  + camera.x
    walls(10).y.lower := 217  + camera.y
    walls(10).y.upper := 1025 + camera.y
    % Left-most wall
    walls(11).x.lower := 272  + camera.x
    walls(11).x.upper := 345  + camera.x
    walls(11).y.lower := 952  + camera.y
    walls(11).y.upper := 2247 + camera.y
    % Top, Left wall
    walls(12).x.lower := 272  + camera.x
    walls(12).x.upper := 1552 + camera.x
    walls(12).y.lower := 2175 + camera.y
    walls(12).y.upper := 2247 + camera.y
    % Top, Right wall
    walls(13).x.lower := 1637 + camera.x
    walls(13).x.upper := 2990 + camera.x
    walls(13).y.lower := 2175 + camera.y
    walls(13).y.upper := 2247 + camera.y
    % Bottom, Right Wall
    walls(14).x.lower := 1616 + camera.x
    walls(14).x.upper := 2449 + camera.x
    walls(14).y.lower := 217  + camera.y
    walls(14).y.upper := 288  + camera.y
    % Left, Bottom Wall of red room
    walls(15).x.lower := 1776 + camera.x
    walls(15).x.upper := 1849 + camera.x
    walls(15).y.lower := 217  + camera.y
    walls(15).y.upper := 993  + camera.y
    % Right Wall of red room
    walls(16).x.lower := 2375 + camera.x
    walls(16).x.upper := 2448 + camera.x
    walls(16).y.lower := 217  + camera.y
    walls(16).y.upper := 1425 + camera.y
    % Left, Top Wall of red room / Left wall of purple room
    walls(17).x.lower := 1776 + camera.x
    walls(17).x.upper := 1849 + camera.x
    walls(17).y.lower := 1080 + camera.y
    walls(17).y.upper := 1857 + camera.y
    % Left wall between red and purple room
    walls(18).x.lower := 1776 + camera.x
    walls(18).x.upper := 2129 + camera.x
    walls(18).y.lower := 1352 + camera.y
    walls(18).y.upper := 1425 + camera.y
    % Right wall between red and purple room
    walls(19).x.lower := 2217 + camera.x
    walls(19).x.upper := 2448 + camera.x
    walls(19).y.lower := 1352 + camera.y
    walls(19).y.upper := 1425 + camera.y
    % Top, Left wall of purple room
    walls(20).x.lower := 1776 + camera.x
    walls(20).x.upper := 2535 + camera.x
    walls(20).y.lower := 1784 + camera.y
    walls(20).y.upper := 1857 + camera.y
    % Top, Right wall of purple room
    walls(21).x.lower := 2632 + camera.x
    walls(21).x.upper := 2992 + camera.x
    walls(21).y.lower := 1784 + camera.y
    walls(21).y.upper := 1857 + camera.y
    % Right, Top wall of purple room
    walls(22).x.lower := 2917 + camera.x
    walls(22).x.upper := 2991 + camera.x
    walls(22).y.lower := 1673 + camera.y
    walls(22).y.upper := 2247 + camera.y
    % Right, Bottom wall of purple room
    walls(23).x.lower := 2917 + camera.x
    walls(23).x.upper := 2991 + camera.x
    walls(23).y.lower := 920  + camera.y
    walls(23).y.upper := 1584 + camera.y
    % Bottom wall of purple room
    walls(24).x.lower := 2377 + camera.x
    walls(24).x.upper := 2991 + camera.x
    walls(24).y.lower := 920  + camera.y
    walls(24).y.upper := 990  + camera.y
    
    postMove.x := x
    postMove.y := y
    if x = maxx div 2 and y = maxy div 2 then
        Input.KeyDown(key)
        for i : 1 .. upper(inputEffects)
            if key(inputEffects(i).input) then
                postMove.x -= inputEffects(i).effect.x
                postMove.y -= inputEffects(i).effect.y
            end if
        end for
    end if
    
    if character = false    then
        for i : 1 .. upper(walls)
            walls(i).x.lower += 20
            walls(i).x.upper -= 20
            walls(i).y.lower += 20
            walls(i).y.upper -= 20
        end for
    end if
    
    for i : 1 .. upper(walls)
        if postMove.x > walls(i).x.lower and postMove.x < walls(i).x.upper and postMove.y >  walls(i).y.lower and postMove.y < walls(i).y.upper then
            wallHit := i
            result true
        end if
    end for
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
            if collisionDetect(grid(i,j).leftB.x+camera.x, grid(i,j).leftB.y+camera.y,true)  or collisionDetect(grid(i,j).rightB.x+camera.x,grid(i,j).rightB.y+camera.y,true) or collisionDetect(grid(i,j).leftT.x+camera.x,grid(i,j).leftT.y+camera.y,true) or collisionDetect(grid(i,j).rightT.x+camera.x,grid(i,j).rightT.y+camera.y,true)then
                grid(i,j).wall := true
            end if
        end for
    end for
end draw
draw

procedure movement
    Input.KeyDown(key)
    
    if Time.Elapsed - lastInputCheck > 15 then
    lastInputCheck := Time.Elapsed
    for i : 1 .. upper(inputEffects)
        if key(inputEffects(i).input) then
            if collisionDetect(maxx div 2,maxy div 2,true)=false then
                camera.x += inputEffects(i).effect.x
                camera.y += inputEffects(i).effect.y
            end if
        end if
    end for 
    end if 
    cls
    Pic.Draw(mainLevel, spongebobPos.x + camera.x, spongebobPos.y + camera.y, picCopy)
    Font.Draw("Player X: " + intstr(maxx div 2 -camera.x), 0, 600, font1, black)
    Font.Draw("Player Y: " + intstr(maxy div 2 -camera.y), 0, 570, font1, black)
    Font.Draw("Enemy X: " + intstr(enemyPos(1).x),0,510,font1,black)
    Font.Draw("Enemy Y: " + intstr(enemyPos(1).y),0,480,font1,black)
    Font.Draw("Test #1: " + intstr(walls(wallHit).x.lower)+"< " + intstr(eBulletPos(1).x)+ "< "+intstr(walls(wallHit).x.upper),0,450,font1,white)
    Font.Draw("Test #2: " + intstr(walls(wallHit).y.lower)+"< " + intstr(eBulletPos(1).y )+ " < "+intstr(walls(wallHit).y.upper),0,420,font1,white)  
    if postMove.x > walls(wallHit).x.lower and postMove.x < walls(wallHit).x.upper then
        Font.Draw("Wall X",0,390,font1,black)
    end if
    if postMove.y >  walls(wallHit).y.lower and postMove.y < walls(wallHit).y.upper then
        Font.Draw("Wall Y",0,360,font1,black)
    end if
    if pathfind then
        %Draw.FillBox(grid(goal.x,goal.y).leftB.x+camera.x,grid(goal.x,goal.y).leftB.y+camera.y,grid(goal.x,goal.y).rightT.x+camera.x,grid(goal.x,goal.y).rightT.y+camera.y,yellow)
    end if
    %Font.Draw(intstr(q(lower(q)).fScore)+" "+intstr(openX)+" "+intstr(openY),0,640,font1,black)
    
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

proc resetAStar
    new searched, 0
    new q, 0
    initialize := true
    setPlayerPos := true
end resetAStar

proc aStar(startX,startY,goalX,goalY:int)
    loops += 1
    if initialize then
        for i : 1 .. 60
            for j : 1 .. 53
                if startX >= grid(i,j).leftB.x and startX < grid(i,j).rightB.x and startY >= grid(i,j).leftB.y and startY < grid(i,j).leftT.y then
                    
                    start.x := i
                    start.y := j
                    grid(i,j).start := true
                    new q, upper(q)+1
                    q(upper(q)).a := i
                    q(upper(q)).b := j
                end if
                if goalX >= grid(i,j).leftB.x and goalX < grid(i,j).rightB.x and goalY >= grid(i,j).leftB.y and goalY < grid(i,j).leftT.y then
                    grid(i,j).goal := true
                    grid(i,j).wall := false
                    goal.x := i
                    goal.y := j
                end if
            end for
        end for
            initialize := false
    end if
    if goal.x not= start.x and goal.y not= start.y then
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
        end if
    
    if openX = goal.x and openY = goal.y then
        enemy1.firstMove := counter
        enemy1.enemyPath := true
        newPath := true
        pathing := true
        resetAStar
        count := enemy1.firstMove + 1
        enemy1.pLast.x := -1
        enemy1.pLast.y := -1
        enemy1.status := "searching"
        noiseSearch := false
    end if
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

enemy1.moveDirection := "null"

proc AISearch (var enemyNum : enemy)
    if enemyNum.dead = false then
        Sprite.Show(enemySPR)
        Sprite.SetHeight(enemySPR,2)
        enemyNum.randMove := Rand.Int(1,4)
        if enemyNum.moveDirection = "null" then
            if enemyNum.randMove = 1 then
                if collisionDetect(enemyPos(1).x+camera.x,enemyPos(1).y+camera.y+20,true) = false then
                    enemyNum.moveDirection := "up"
                end if
            elsif enemyNum.randMove = 2 then
                if collisionDetect(enemyPos(1).x+camera.x+20,enemyPos(1).y+camera.y,true) = false then
                    enemyNum.moveDirection := "right"
                end if
            elsif enemyNum.randMove = 3 then
                if collisionDetect(enemyPos(1).x+camera.x-20,enemyPos(1).y+camera.y,true) = false then
                    enemyNum.moveDirection := "left"
                end if
            elsif enemyNum.randMove = 4 then
                if collisionDetect(enemyPos(1).x+camera.x,enemyPos(1).y+camera.y-20,true) = false then
                    enemyNum.moveDirection:= "down"
                end if
            end if
        end if
        if enemyNum.moveDirection = "right" then
            if collisionDetect(enemyPos(1).x+camera.x+20,enemyPos(1).y+camera.y,true) = false then
                Sprite.Animate(enemySPR,enemySprite(enemyFrame),enemyPos(1).x+camera.x,enemyPos(1).y+camera.y,true)
                enemyPos(1).x += 2
            else
                enemyNum.moveDirection := "null"
            end if
        elsif enemyNum.moveDirection = "down" then
            if collisionDetect(enemyPos(1).x+camera.x,enemyPos(1).y+camera.y-20,true) = false then
                Sprite.Animate(enemySPR,enemySprite270(enemyFrame),enemyPos(1).x+camera.x,enemyPos(1).y+camera.y,true)
                enemyPos(1).y -= 2
            else
                enemyNum.moveDirection := "null"
            end if
        elsif enemyNum.moveDirection = "up" then
            if collisionDetect(enemyPos(1).x+camera.x,enemyPos(1).y+camera.y+20,true) = false then
                Sprite.Animate(enemySPR,enemySprite90(enemyFrame),enemyPos(1).x+camera.x,enemyPos(1).y+camera.y,true)
                enemyPos(1).y += 2
            else
                enemyNum.moveDirection := "null"
            end if
        elsif enemyNum.moveDirection = "left" then
            if collisionDetect(enemyPos(1).x+camera.x-20,enemyPos(1).y+camera.y,true) = false then
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
    else
        Sprite.Animate(enemySPR,eKill1IMG,enemyPos(1).x+camera.x,enemyPos(1).y+camera.y,true)
    end if
end AISearch

proc sightCheck
    if (enemy1.enemyRoom = playerRoom) or (enemy1.enemyRoom = "carbon" and playerRoom = "CARBON2wood") or (enemy1.enemyRoom = "carbon" and playerRoom = "lvh2CARBON") or (enemy1.enemyRoom = "CARBON2wood" and playerRoom = "carbon") or (enemy1.enemyRoom = "lvh2CARBON" and playerRoom = "carbon") or (enemy1.enemyRoom = "lvh2CARBON" and playerRoom = "CARBON2wood") or (enemy1.enemyRoom = "CARBON2wood" and playerRoom = "lvh2CARBON") or (enemy1.enemyRoom = "CARBON2wood" and playerRoom = "carbon2WOOD") or (enemy1.enemyRoom = "carbon2WOOD" and playerRoom = "CARBON2wood") or (enemy1.enemyRoom = "lvh2CARBON" and playerRoom = "LVH2carbon") or (enemy1.enemyRoom = "LVH2carbon" and playerRoom = "lvh2CARBON")then
        if enemy1.moveDirection = "up" then
            if whatAngleEnemy(enemyPos(1).x,enemyPos(1).y) > 0 and whatAngleEnemy(enemyPos(1).x,enemyPos(1).y) < 180 then
                enemy1.eyesOn := true
            else
                enemy1.eyesOn := false
            end if
        elsif enemy1.moveDirection = "right" then
            if whatAngleEnemy(enemyPos(1).x,enemyPos(1).y) < 80 or whatAngleEnemy(enemyPos(1).x,enemyPos(1).y) > 270 then
                enemy1.eyesOn := true
            else
                enemy1.eyesOn := false
            end if
        elsif enemy1.moveDirection = "down" then
            if whatAngleEnemy(enemyPos(1).x,enemyPos(1).y) < 360 and whatAngleEnemy(enemyPos(1).x,enemyPos(1).y) > 180 then
                enemy1.eyesOn := true
            else
                enemy1.eyesOn := false
            end if
        elsif enemy1.moveDirection = "left" then
            if whatAngleEnemy(enemyPos(1).x,enemyPos(1).y) > 80 and whatAngleEnemy(enemyPos(1).x,enemyPos(1).y) < 270 then
                enemy1.eyesOn := true
            else
                enemy1.eyesOn := false
            end if
        end if
    else
        enemy1.eyesOn := false
    end if
end sightCheck

proc enemyPathing
    %Sprite.Hide(enemy1.bullet)
    if enemy1.enemyPath and newPath then
        newPath := false
    end if
    if enemyPos(1).x - grid(enemy1.path(count).x,enemy1.path(count).y).leftB.x < 0 then
        enemyPos(1).x += 2
        enemy1.moveDirection := "right"
        Sprite.Animate(enemySPR,enemySprite(enemyFrame),enemyPos(1).x+camera.x,enemyPos(1).y+camera.y,true)
    elsif enemyPos(1).x - grid(enemy1.path(count).x,enemy1.path(count).y).leftB.x > 0 then
        enemyPos(1).x -= 2
        enemy1.moveDirection := "left"
        Sprite.Animate(enemySPR,enemySprite180(enemyFrame),enemyPos(1).x+camera.x,enemyPos(1).y+camera.y,true)
    elsif enemyPos(1).y - grid(enemy1.path(count).x,enemy1.path(count).y).leftB.y < 0 then
        enemyPos(1).y += 2
        enemy1.moveDirection := "up"
        Sprite.Animate(enemySPR,enemySprite90(enemyFrame),enemyPos(1).x+camera.x,enemyPos(1).y+camera.y,true)
    elsif enemyPos(1).y - grid(enemy1.path(count).x,enemy1.path(count).y).leftB.y > 0 then
        enemyPos(1).y -= 2
        enemy1.moveDirection := "down"
        Sprite.Animate(enemySPR,enemySprite270(enemyFrame),enemyPos(1).x+camera.x,enemyPos(1).y+camera.y,true)
    end if
    
    if enemyPos(1).x - grid(enemy1.path(count).x,enemy1.path(count).y).leftB.x > -1 and enemyPos(1).x - grid(enemy1.path(count).x,enemy1.path(count).y).leftB.x < 1 and enemyPos(1).y - grid(enemy1.path(count).x,enemy1.path(count).y).leftB.y > -1 and enemyPos(1).y - grid(enemy1.path(count).x,enemy1.path(count).y).leftB.y < 1 then
        count += 1
    end if
    if count = 101 then 
        enemy1.status := "neutral"
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
    if key(' ') and (Time.Elapsed - shootDelay) > 1000 then
        shootDelay := Time.Elapsed
        shoot := true
    end if
    if shoot then
        if shootDirection not= playerDirection and shootDirection not= 0 then
            playerDirection := shootDirection
        end if
        Sprite.Show(bulletSPR)
        Sprite.Animate(bulletSPR,bulletIMG,bulletPos(1).x,bulletPos(1).y,true)
        if playerDirection = 1 then
            shootDirection := 1
            bulletPos(1).x += 50
            if bulletPos(1).x > maxx + 50 or collisionDetect(bulletPos(1).x-10,bulletPos(1).y,false) then
                shoot:= false
                bulletPos(1).x := maxx div 2
                Sprite.Hide(bulletSPR)
                shootDirection := 0
            end if
        elsif playerDirection = 2 then
            shootDirection := 2
            bulletPos(1).y += 50
            bulletPos(1).x += 50
            if bulletPos(1).y > maxy or collisionDetect(bulletPos(1).x-20,bulletPos(1).y,false) then
                shoot:= false
                bulletPos(1).y := maxy div 2
                bulletPos(1).x := maxx div 2
                Sprite.Hide(bulletSPR)
                shootDirection := 0
            end if
        elsif playerDirection = 3 then
            shootDirection := 3
            bulletPos(1).y += 50
            if bulletPos(1).y > maxy or collisionDetect(bulletPos(1).x,bulletPos(1).y-50,false) then
                shoot:= false
                bulletPos(1).y := maxy div 2
                Sprite.Hide(bulletSPR)
                shootDirection := 0
            end if
        elsif playerDirection = 4 then
            shootDirection := 4
            bulletPos(1).x -= 50
            bulletPos(1).y += 50
            if bulletPos(1).x < -20 or collisionDetect(bulletPos(1).x+20,bulletPos(1).y-50,false) then
                shoot:= false
                bulletPos(1).x := maxx div 2
                bulletPos(1).y := maxy div 2
                Sprite.Hide(bulletSPR)
                shootDirection := 0
            end if 
        elsif playerDirection = 5 then
            shootDirection := 5
            bulletPos(1).x -= 50
            if bulletPos(1).x < -20 or collisionDetect(bulletPos(1).x+20,bulletPos(1).y,false) then
                shoot:= false
                bulletPos(1).x := maxx div 2
                Sprite.Hide(bulletSPR)
                shootDirection := 0
            end if 
        end if
    end if
end playerShoot

function roomAssign(x,y:int) :string
    if    x >= 1433+camera.x and x <= 1776+camera.x and y >= 1856+camera.y and y <= 2175+camera.y then
        result "intLVH&LHH"
    elsif x >= 1433+camera.x and x <= 1776+camera.x and y >= 578+camera.y  and y <= 665 +camera.y then
        result "LVH2carbon"
    elsif x >= 631+camera.x  and x <= 1432+camera.x and y >= 578+camera.y  and y <= 665 +camera.y then
        result "lvh2CARBON"
    elsif x >= 985+camera.x  and x <= 1071+camera.x and y >= 288+camera.y  and y <= 1019+camera.y then
        result "CARBON2wood"
    elsif x >= 985+camera.x  and x <= 1071+camera.x and y >= 1020+camera.y and y <= 1785+camera.y then
        result "carbon2WOOD"
    elsif x >= 347+camera.x  and x <= 683+camera.x  and y >= 1301+camera.y and y <= 1379+camera.y then
        result "wood2SVH"
    elsif x >= 684+camera.x  and x <= 1355+camera.x and y >= 1301+camera.y and y <= 1379+camera.y then
        result "WOOD2svh"
    elsif x >= 755+camera.x  and x <= 1426+camera.x and y >= 1577+camera.y and y <= 1655+camera.y then
        result "LVH2wood"
    elsif x >= 1427+camera.x and x <= 1775+camera.x and y >= 1577+camera.y and y <= 1655+camera.y then
        result "lvh2WOOD"
    elsif x >= 1776+camera.x and x <= 2375+camera.x and y >= 995+camera.y  and y <= 1079+camera.y then
        result "lvh2RED"
    elsif x >= 1433+camera.x and x <= 1775+camera.x and y >= 995+camera.y  and y <= 1079+camera.y then
        result "LVH2red"
    elsif x >= 2129+camera.x and x <= 2213+camera.x and y >= 1427+camera.y and y <= 1781+camera.y then
        result "red2PURPLE"
    elsif x >= 2129+camera.x and x <= 2213+camera.x and y >= 293+camera.y  and y <= 1426+camera.y then
        result "RED2purple"
    elsif x >= 2537+camera.x and x <= 2627+camera.x and y >= 995+camera.y  and y <= 1858+camera.y then
        result "PURPLE2lhh"
    elsif x >= 2537+camera.x and x <= 2627+camera.x and y >= 1859+camera.y and y <= 2177+camera.y then
        result "purple2LHH"
    elsif x >= 345+camera.x  and x <= 686+camera.x  and y >= 1856+camera.y and y <= 2175+camera.y then
        result "intSVH&LHH"
    elsif x >= 2447+camera.x and x <= 2918+camera.x and y >= 1425+camera.y and y <= 1785+camera.y then
        result "intPurple"
    elsif x >= 1433+camera.x and x <= 1776+camera.x and y >= 288+camera.y  and y <= 2175+camera.y then
        result "longVertHall"
    elsif x >= 631+camera.x  and x <= 1360+camera.x and y >= 288+camera.y  and y <= 952+camera.y  then
        result "carbon"
    elsif x >= 755+camera.x  and x <= 1360+camera.x and y >= 1000+camera.y and y <= 1785+camera.y then
        result "wood"
    elsif x >= 345+camera.x  and x <= 686+camera.x  and y >= 1025+camera.y and y <= 2175+camera.y then
        result "shortVertHall"
    elsif x >= 631+camera.x  and x <= 2918+camera.x and y >= 1856+camera.y and y <= 2175+camera.y then
        result "longHorzHall"
    elsif x >= 1847+camera.x and x <= 2376+camera.x and y >= 288+camera.y  and y <= 1354+camera.y then
        result "red"
    elsif x >= 1847+camera.x and x <= 2918+camera.x and y >= 1425+camera.y and y <= 1785+camera.y then
        result "purpleUpper"
    elsif x >= 2447+camera.x and x <= 2918+camera.x and y >= 922+camera.y  and y <= 1785+camera.y then
        result "purpleLower"
    else
        result "outside"
    end if
end roomAssign

proc enemyShooting
    enemy1.status := "shooting"
    %Starts timer is it is 0
    if enemy1.shootDelay = 0 then
        enemy1.shootDelay := Time.Elapsed
    end if
    %If time > 0.5 seconds then activte shooting
    if Time.Elapsed - enemy1.shootDelay > 500 then
        enemy1.shooting := true        
    end if
    if enemy1.shooting = false then
        %Keep bullet origin and speed stuck to enemy, stop them changing once fired
        eBulletPos(1).x := enemyPos(1).x
        eBulletPos(1).y := enemyPos(1).y
        enemy1.targetLocation.x := (maxx div 2 - camera.x)
        enemy1.targetLocation.y := (maxy div 2 - camera.y)
        enemy1.selfLocation.x := enemyPos(1).x
        enemy1.selfLocation.y := enemyPos(1).y
        enemy1.speed := 0.1
    else
        %If the bullet is fired incread x and y pos
        enemy1.shootDelay := 0
        eBulletPos(1).x -= round((enemy1.selfLocation.x - enemy1.targetLocation.x) * enemy1.speed) div 2
        eBulletPos(1).y -= round((enemy1.selfLocation.y - enemy1.targetLocation.y) * enemy1.speed) div 2
        if abs(round((enemy1.selfLocation.x - enemy1.targetLocation.x) * enemy1.speed) div 2) > 35 or abs(round((enemy1.selfLocation.y - enemy1.targetLocation.y) * enemy1.speed) div 2) > 35 then
            enemy1.speed -= 0.05
        end if
        enemy1.speed += 0.001
        Sprite.Show(enemy1.bullet)
    end if
    Font.Draw(intstr(round((enemy1.selfLocation.x - enemy1.targetLocation.x) * enemy1.speed) div 2),0,800,font1,white)
    View.Update
%Animate Bullet

    Sprite.Animate(enemy1.bullet,bulletIMG,eBulletPos(1).x+camera.x,eBulletPos(1).y+camera.y,true)
    Sprite.Animate(enemySPR,enemySprite270(enemyFrame),enemyPos(1).x+camera.x,enemyPos(1).y+camera.y,true)
    %If the bullet hits a wall or the player, hide it and reset the shooting proc
    if collisionDetect(eBulletPos(1).x+camera.x,eBulletPos(1).y+camera.y,false) or key('p')/*or Math.Distance(eBulletPos(1).x-20,eBulletPos(1).y-20,maxx div 2-camera.x,maxy div 2-camera.x) < 50 */then
        enemy1.shooting := false
        Sprite.Hide(enemy1.bullet)
    end if
end enemyShooting

proc enemyReact
    if enemy1.eyesOn then
        enemy1.pLast.x := maxx div 2 - camera.x
        enemy1.pLast.y := maxy div 2 - camera.y
    end if
    if enemy1.eyesOn then
        enemyShooting
    end if
    if enemy1.eyesOn = false then
        if enemy1.pLast.x not= -1 then
            enemy1.status := "neutral"
            aStar(enemyPos(1).x,enemyPos(1).y,enemy1.pLast.x,enemy1.pLast.y)
        end if    
    end if
    if shoot or noiseSearch and enemy1.eyesOn = false then
        noiseSearch := true
        if setPlayerPos then
            tempPX := maxx div 2 - camera.x
            tempPY := maxy div 2 - camera.y
        setPlayerPos := false
        end if
        aStar(enemyPos(1).x,enemyPos(1).y,tempPX,tempPY)
    end if
end enemyReact

loop
    if Math.Distance(bulletPos(1).x-camera.x,bulletPos(1).y-camera.y,enemyPos(1).x,enemyPos(1).y) < 50 and shoot then
        enemy1.dead := true
        enemy1.status := "neutral"
    end if
    if Math.Distance(eBulletPos(1).x+camera.x,eBulletPos(1).y+camera.y,maxx div 2,maxy div 2) < 50 and enemy1.shooting then
        quit
    end if
    mousewhere(mousex,mousey,button)
    playerRoom := roomAssign(maxx div 2,maxy div 2)
    enemy1.enemyRoom := roomAssign(enemyPos(1).x+camera.x,enemyPos(1).y+camera.y)
    if enemy1.dead = false then
        sightCheck
        enemyReact
        if enemy1.status = "searching" then
            enemyPathing
        end if
    end if
    playerAnimate
    movement
    playerShoot
    if enemy1.status = "neutral" then
        AISearch(enemy1)
    end if
end loop