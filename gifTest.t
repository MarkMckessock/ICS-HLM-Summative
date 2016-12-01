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

type enemyType:
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
    SPR : int
    tempPX : int
    tempPY : int
    noiseSearch : boolean
    setPlayerPos : boolean
    newPath : boolean
    count : int
    initialize : boolean
    goalX : int
    goalY : int
    start : coordinate
    goal : coordinate
    openX : int
    openY : int
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
var shoot : boolean := false % true when player is shooting
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
var enemy : array 1 .. 3 of enemyType
var enemy1Q : flexible array 1 .. 0 of arrayElement
var enemy1Searched : flexible array 1 .. 0 of arrayElement
var enemy2Q : flexible array 1 .. 0 of arrayElement
var enemy2Searched : flexible array 1 .. 0 of arrayElement
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
var pathfound : boolean := false
var x,y, speed, mousex, mousey, button: int
var map1 : int := Pic.FileNew("mainLevel.jpg")
var ratio, angle : real
var font1 : int := Font.New("serif:12")
var playerFrame : int := 1
var enemyFrame : int := 1
var tempPX,tempPY : int := 0
var bulletPos : array 1 .. 3 of vector
    enemy(1).x := 1330
enemy(2).x := 2200
enemy(1).y := 350
enemy(2).y := 350

var sightRange : int := 300
var dist : real
var playerRoom : string := ""
enemy(1).enemyPath := false
enemy(2).enemyPath := false
var walls : array 1 .. 24 of wall
var shootDirection : int := 0
speed := 2
x := -942
y := 359
bulletPos(1).x := maxx div 2
bulletPos(1).y := maxy div 2
eBulletPos(1).x := maxx div 2
eBulletPos(1).y := maxy div 2
enemy(1).timeOnTarget := 0
enemy(2).timeOnTarget := 0
Pic.FileNewFrames ("walkGIFbluetrans.gif", pics, delayTime)
Pic.FileNewFrames ("walkGIFbluetransEnemy.gif", enemySprite, delayTime2)
% Sets all elements to 0 to see when the array elements start
enemy(1).dead := false
enemy(1).pLast.x := -1
enemy(1).pLast.y := -1
enemy(1).shootDelay := 0
enemy(1).shooting := false
enemy(1).bullet := Sprite.New(bulletIMG)
enemy(1).status := "neutral"
enemy(1).noiseSearch := false
enemy(1).setPlayerPos := true
enemy(1).initialize := true
enemy(1).newPath := false
enemy(1).eyesOn := false

enemy(2).dead := false
enemy(2).pLast.x := -1
enemy(2).pLast.y := -1
enemy(2).shootDelay := 0
enemy(2).shooting := false
enemy(2).bullet := Sprite.New(bulletIMG)
enemy(2).status := "neutral"
enemy(2).noiseSearch := false
enemy(2).setPlayerPos := true
enemy(2).initialize := true
enemy(2).newPath := false
enemy(2).eyesOn := false
for i : 1 .. upper(enemy(1).path)
    enemy(1).path(i).x := 0
    enemy(1).path(i).y := 0
end for
    enemy(1).SPR := Sprite.New(enemySprite(1))
enemy(2).SPR := Sprite.New(enemySprite(1))
var player: int := Sprite.New(pics(1))

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
    walls(3).x.upper := 1433 + camera.x
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
    Font.Draw("Player X: " + intstr(maxx div 2 - camera.x),0,690,font1,white)
    Font.Draw("Player Y: " + intstr(maxy div 2 - camera.y),0,720,font1,white)
    Font.Draw("Enemy2 x " + intstr(enemy(2).x),0,660,font1,white)
    Font.Draw("Enemy2 y " + intstr(enemy(2).y),0,630,font1,white)
    if enemy(1).noiseSearch then
        Font.Draw("Enemy 1 NoiseSearch ", 0, 600, font1, black)
    end if
    if enemy(1).noiseSearch then
        Font.Draw("Enemy 2 NoiseSearch", 0, 570, font1, black)
    end if
    if shoot then
        Font.Draw("Player Shoot",0,510,font1,black)
    end if
    Font.Draw("Enemy 1 Status: " + enemy(1).status,0,480,font1,black)
    Font.Draw("Enemy 2 Status: " + enemy(2).status,0,450,font1,white)
    if enemy(1).eyesOn then
        Font.Draw("Enemy 1 Eyes on",0,420,font1,white)  
    end if
    if enemy(2).eyesOn then
        Font.Draw("Enemy 2 Eyes on",0,390,font1,white)  
    end if
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

proc resetAStar(enemyNum : int)
    if enemyNum = 1 then
        new enemy1Q, 0 
        new enemy1Searched, 0
        enemy(1).openX := 0
        enemy(1).openY := 0
    elsif enemyNum = 2 then
        new enemy2Q, 0 
        new enemy2Searched, 0
        enemy(2).openX := 0
        enemy(2).openY := 0
    end if
    enemy(enemyNum).initialize := true
    enemy(enemyNum).setPlayerPos := true
end resetAStar

proc aStar(startX,startY,goalX,goalY,enemyNum:int)
    new q, 0
    new searched, 0
    if enemyNum = 1 then
        new q, upper(enemy1Q)
        new searched, upper(enemy1Searched)
        for i : 1 .. upper(q)
            q(i) := enemy1Q(i)
        end for
        for i : 1 .. upper(searched)
            searched(i) := enemy1Searched(i)
        end for
    elsif enemyNum = 2 then
        new q, upper(enemy2Q)
        new searched, upper(enemy2Searched)
        for i : 1 .. upper(q)
            q(i) := enemy2Q(i)
        end for
        for i : 1 .. upper(searched)
            searched(i) := enemy2Searched(i)
        end for
    end if
    if enemy(enemyNum).initialize then
        for i : 1 .. 60
            for j : 1 .. 53
                if startX >= grid(i,j).leftB.x and startX < grid(i,j).rightB.x and startY >= grid(i,j).leftB.y and startY < grid(i,j).leftT.y then
                    enemy(enemyNum).start.x := i
                    enemy(enemyNum).start.y := j
                    grid(i,j).start := true
                    new q, upper(q)+1
                    q(upper(q)).a := i
                    q(upper(q)).b := j
                end if
                if goalX >= grid(i,j).leftB.x and goalX < grid(i,j).rightB.x and goalY >= grid(i,j).leftB.y and goalY < grid(i,j).leftT.y then
                    grid(i,j).goal := true
                    grid(i,j).wall := false
                    enemy(enemyNum).goal.x := i
                    enemy(enemyNum).goal.y := j
                end if
            end for
        end for
            enemy(enemyNum).initialize := false
    end if
    if enemy(enemyNum).goal.x not= enemy(enemyNum).start.x and enemy(enemyNum).goal.y not= enemy(enemyNum).start.y then
        %Open first item in queue and remove from list
        enemy(enemyNum).openX := q(lower(q)).a
        enemy(enemyNum).openY := q(lower(q)).b
        new searched, upper(searched) + 1
        searched(upper(searched)) := q(lower(q))
        for i : 1 .. upper(q)-1
            q(i) := q(i+1)
        end for
            new q, upper(q)-1
        %Draw.FillBox(grid(enemy(enemyNum).openX,enemy(enemyNum).openY).leftB.x+camera.x,grid(enemy(enemyNum).openX,enemy(enemyNum).openY).leftB.y+camera.y,grid(enemy(enemyNum).openX,enemy(enemyNum).openY).rightT.x+camera.x,grid(enemy(enemyNum).openX,enemy(enemyNum).openY).rightT.y+camera.y,yellow)
        View.Update
        %Add surrounding tiles to queue
        %Up Tile
        if enemy(enemyNum).openX+1 <= upper(grid,1) then
            if grid(enemy(enemyNum).openX+1,enemy(enemyNum).openY). wall = false and contains(enemy(enemyNum).openX+1,enemy(enemyNum).openY,searched) = false and contains(enemy(enemyNum).openX+1,enemy(enemyNum).openY,q) = false then
                new q, upper(q) + 1
                q(upper(q)).a := enemy(enemyNum).openX + 1
                q(upper(q)).b := enemy(enemyNum).openY
                grid(enemy(enemyNum).openX+1,enemy(enemyNum).openY).parent.x := enemy(enemyNum).openX
                grid(enemy(enemyNum).openX+1,enemy(enemyNum).openY).parent.y := enemy(enemyNum).openY
                q(upper(q)).fScore := round( 8*(abs((enemy(enemyNum).openX+1)-enemy(enemyNum).goal.x) + abs(enemy(enemyNum).openY-enemy(enemyNum).goal.y)) + (abs((enemy(enemyNum).openX+1)-enemy(enemyNum).start.x) + abs(enemy(enemyNum).openY-enemy(enemyNum).start.y)))
            end if
        end if
        %Down Tile
        if enemy(enemyNum).openX-1 >= 1 then
            if grid(enemy(enemyNum).openX-1,enemy(enemyNum).openY). wall = false and contains(enemy(enemyNum).openX-1,enemy(enemyNum).openY,searched) = false and contains(enemy(enemyNum).openX-1,enemy(enemyNum).openY,q) = false then
                new q, upper(q) + 1
                q(upper(q)).a := enemy(enemyNum).openX - 1
                q(upper(q)).b := enemy(enemyNum).openY
                grid(enemy(enemyNum).openX-1,enemy(enemyNum).openY).parent.x := enemy(enemyNum).openX
                grid(enemy(enemyNum).openX-1,enemy(enemyNum).openY).parent.y := enemy(enemyNum).openY
                q(upper(q)).fScore := round( 8*(abs((enemy(enemyNum).openX-1)-enemy(enemyNum).goal.x) + abs(enemy(enemyNum).openY-enemy(enemyNum).goal.y)) + (abs((enemy(enemyNum).openX-1)-enemy(enemyNum).start.x) + abs(enemy(enemyNum).openY-enemy(enemyNum).start.y)))
            end if
        end if
        %Left Tile
        if enemy(enemyNum).openY+1 <= upper(grid,2) then
            if grid(enemy(enemyNum).openX,enemy(enemyNum).openY+1). wall = false and contains(enemy(enemyNum).openX,enemy(enemyNum).openY+1,searched) = false and contains(enemy(enemyNum).openX,enemy(enemyNum).openY+1,q) = false then
                new q, upper(q) + 1
                q(upper(q)).a := enemy(enemyNum).openX
                q(upper(q)).b := enemy(enemyNum).openY + 1
                grid(enemy(enemyNum).openX,enemy(enemyNum).openY+1).parent.x := enemy(enemyNum).openX
                    grid(enemy(enemyNum).openX,enemy(enemyNum).openY+1).parent.y := enemy(enemyNum).openY
                q(upper(q)).fScore := round( 8*(abs(enemy(enemyNum).openX-enemy(enemyNum).goal.x) + abs((enemy(enemyNum).openY+1)-enemy(enemyNum).goal.y)) + (abs(enemy(enemyNum).openX-enemy(enemyNum).start.x) + abs((enemy(enemyNum).openY+1)-enemy(enemyNum).start.y)))
            end if
        end if
        %Right Tile
        if enemy(enemyNum).openY-1 >= lower(grid,1) then            
            if grid(enemy(enemyNum).openX,enemy(enemyNum).openY-1). wall = false and contains(enemy(enemyNum).openX,enemy(enemyNum).openY-1,searched) = false and contains(enemy(enemyNum).openX,enemy(enemyNum).openY-1,q) = false then
                new q, upper(q) + 1
                q(upper(q)).a := enemy(enemyNum).openX
                q(upper(q)).b := enemy(enemyNum).openY - 1
                grid(enemy(enemyNum).openX,enemy(enemyNum).openY-1).parent.x := enemy(enemyNum).openX
                grid(enemy(enemyNum).openX,enemy(enemyNum).openY-1).parent.y := enemy(enemyNum).openY
                q(upper(q)).fScore := round( 8*(abs(enemy(enemyNum).openX-enemy(enemyNum).goal.x) + abs((enemy(enemyNum).openY-1)-enemy(enemyNum).goal.y)) + (abs(enemy(enemyNum).openX-enemy(enemyNum).start.x) + abs((enemy(enemyNum).openY-1)-enemy(enemyNum).start.y)))
            end if
        end if
        if enemy(enemyNum).goal.x not= enemy(enemyNum).openX then
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
        end if
            if enemy(enemyNum).openX = enemy(enemyNum).goal.x and enemy(enemyNum).openY = enemy(enemyNum).goal.y then
            enemy(enemyNum).path(100).x := enemy(enemyNum).openX
            enemy(enemyNum).path(100).y := enemy(enemyNum).openY
            enemy(enemyNum).path(99).x := grid(enemy(enemyNum).openX,enemy(enemyNum).openY).parent.x
            enemy(enemyNum).path(99).y := grid(enemy(enemyNum).openX,enemy(enemyNum).openY).parent.y
            enemy(enemyNum).count := 98
            loop
                enemy(enemyNum).path(enemy(enemyNum).count).x := grid(enemy(enemyNum).path(enemy(enemyNum).count+1).x, enemy(enemyNum).path(enemy(enemyNum).count+1).y).parent.x
                enemy(enemyNum).path(enemy(enemyNum).count).y := grid(enemy(enemyNum).path(enemy(enemyNum).count+1).x, enemy(enemyNum).path(enemy(enemyNum).count+1).y).parent.y
                enemy(enemyNum).count -= 1
                if enemy(enemyNum).path(enemy(enemyNum).count+1).x = enemy(enemyNum).start.x and enemy(enemyNum).path(enemy(enemyNum).count+1).y = enemy(enemyNum).start.y then
                    exit
                end if
            end loop
        end if
        
        if enemyNum = 1 then
        new enemy1Q, upper(q)
        new enemy1Searched, upper(searched)
        for i : 1 .. upper(q)
            enemy1Q(i) := q(i)
        end for
            for i : 1 .. upper(searched)
            enemy1Searched(i) := searched(i)
        end for
        elsif enemyNum = 2 then
        new enemy2Q, upper(q)
        new enemy2Searched, upper(searched)
        for i : 1 .. upper(q)
            enemy2Q(i) := q(i)
        end for
            for i : 1 .. upper(searched)
            enemy2Searched(i) := searched(i)
        end for
        end if
    
        if enemy(enemyNum).openX = enemy(enemyNum).goal.x and enemy(enemyNum).openY = enemy(enemyNum).goal.y then
            %enemy(enemyNum).firstMove := counter
            enemy(enemyNum).enemyPath := true
            %newPath := true
            %pathing := true
            resetAStar(enemyNum)
            enemy(enemyNum).count := enemy(enemyNum).count + 1
            enemy(enemyNum).pLast.x := -1
            enemy(enemyNum).pLast.y := -1
            enemy(enemyNum).status := "searching"
            enemy(enemyNum).noiseSearch := false
        end if
    end if
    %% Get data back from 'q' and 'searched' arrays and return to specific enemy arrays.
    
    new q, 0
    new searched, 0
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

%Sprite.SetPosition(enemySPR,enemy(1).x,enemy(1).y,true)

enemy(1).moveDirection := "null"
enemy(2).moveDirection := "null"

proc AISearch (enemyNum : int)
    Sprite.Hide(enemy(enemyNum).bullet)
    if enemy(enemyNum).dead = false then
        Sprite.Show(enemy(enemyNum).SPR)
        Sprite.SetHeight(enemy(enemyNum).SPR,2)
        enemy(enemyNum).randMove := Rand.Int(1,4)
        if enemy(enemyNum).moveDirection = "null" then
            if enemy(enemyNum).randMove = 1 then
                if collisionDetect(enemy(enemyNum).x+camera.x,enemy(enemyNum).y+camera.y+20,true) = false then
                    enemy(enemyNum).moveDirection := "up"
                end if
            elsif enemy(enemyNum).randMove = 2 then
                if collisionDetect(enemy(enemyNum).x+camera.x+20,enemy(enemyNum).y+camera.y,true) = false then
                    enemy(enemyNum).moveDirection := "right"
                end if
            elsif enemy(enemyNum).randMove = 3 then
                if collisionDetect(enemy(enemyNum).x+camera.x-20,enemy(enemyNum).y+camera.y,true) = false then
                    enemy(enemyNum).moveDirection := "left"
                end if
            elsif enemy(enemyNum).randMove = 4 then
                if collisionDetect(enemy(enemyNum).x+camera.x,enemy(enemyNum).y+camera.y-20,true) = false then
                    enemy(enemyNum).moveDirection:= "down"
                end if
            end if
        end if
        if enemy(enemyNum).moveDirection = "right" then
            if collisionDetect(enemy(enemyNum).x+camera.x+20,enemy(enemyNum).y+camera.y,true) = false then
                Sprite.Animate(enemy(enemyNum).SPR,enemySprite(enemyFrame),enemy(enemyNum).x+camera.x,enemy(enemyNum).y+camera.y,true)
                enemy(enemyNum).x += 2
            else
                enemy(enemyNum).moveDirection := "null"
            end if
        elsif enemy(enemyNum).moveDirection = "down" then
            if collisionDetect(enemy(enemyNum).x+camera.x,enemy(enemyNum).y+camera.y-20,true) = false then
                Sprite.Animate(enemy(enemyNum).SPR,enemySprite270(enemyFrame),enemy(enemyNum).x+camera.x,enemy(enemyNum).y+camera.y,true)
                enemy(enemyNum).y -= 2
            else
                enemy(enemyNum).moveDirection := "null"
            end if
        elsif enemy(enemyNum).moveDirection = "up" then
            if collisionDetect(enemy(enemyNum).x+camera.x,enemy(enemyNum).y+camera.y+20,true) = false then
                Sprite.Animate(enemy(enemyNum).SPR,enemySprite90(enemyFrame),enemy(enemyNum).x+camera.x,enemy(enemyNum).y+camera.y,true)
                enemy(enemyNum).y += 2
            else
                enemy(enemyNum).moveDirection := "null"
            end if
        elsif enemy(enemyNum).moveDirection = "left" then
            if collisionDetect(enemy(enemyNum).x+camera.x-20,enemy(enemyNum).y+camera.y,true) = false then
                Sprite.Animate(enemy(enemyNum).SPR,enemySprite180(enemyFrame),enemy(enemyNum).x+camera.x,enemy(enemyNum).y+camera.y,true)
                enemy(enemyNum).x -= 2
            else
                enemy(enemyNum).moveDirection := "null"
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
        Sprite.Animate(enemy(enemyNum).SPR,eKill1IMG,enemy(enemyNum).x+camera.x,enemy(enemyNum).y+camera.y,true)
    end if
end AISearch

proc sightCheck(enemyNum : int)
    if (enemy(enemyNum).enemyRoom = playerRoom) or (enemy(enemyNum).enemyRoom = "carbon" and playerRoom = "CARBON2wood") or (enemy(enemyNum).enemyRoom = "carbon" and playerRoom = "lvh2CARBON") or (enemy(enemyNum).enemyRoom = "CARBON2wood" and playerRoom = "carbon") or (enemy(enemyNum).enemyRoom = "lvh2CARBON" and playerRoom = "carbon") or (enemy(enemyNum).enemyRoom = "lvh2CARBON" and playerRoom = "CARBON2wood") or (enemy(enemyNum).enemyRoom = "CARBON2wood" and playerRoom = "lvh2CARBON") or (enemy(enemyNum).enemyRoom = "CARBON2wood" and playerRoom = "carbon2WOOD") or (enemy(enemyNum).enemyRoom = "carbon2WOOD" and playerRoom = "CARBON2wood") or (enemy(enemyNum).enemyRoom = "lvh2CARBON" and playerRoom = "LVH2carbon") or (enemy(enemyNum).enemyRoom = "LVH2carbon" and playerRoom = "lvh2CARBON")then
        if enemy(enemyNum).moveDirection = "up" then
            if whatAngleEnemy(enemy(enemyNum).x,enemy(enemyNum).y) > 0 and whatAngleEnemy(enemy(enemyNum).x,enemy(enemyNum).y) < 180 then
                enemy(enemyNum).eyesOn := true
            else
                enemy(enemyNum).eyesOn := false
            end if
        elsif enemy(enemyNum).moveDirection = "right" then
            if whatAngleEnemy(enemy(enemyNum).x,enemy(enemyNum).y) < 80 or whatAngleEnemy(enemy(enemyNum).x,enemy(enemyNum).y) > 270 then
                enemy(enemyNum).eyesOn := true
            else
                enemy(enemyNum).eyesOn := false
            end if
        elsif enemy(enemyNum).moveDirection = "down" then
            if whatAngleEnemy(enemy(enemyNum).x,enemy(enemyNum).y) < 360 and whatAngleEnemy(enemy(enemyNum).x,enemy(enemyNum).y) > 180 then
                enemy(enemyNum).eyesOn := true
            else
                enemy(enemyNum).eyesOn := false
            end if
        elsif enemy(enemyNum).moveDirection = "left" then
            if whatAngleEnemy(enemy(enemyNum).x,enemy(enemyNum).y) > 80 and whatAngleEnemy(enemy(enemyNum).x,enemy(enemyNum).y) < 270 then
                enemy(enemyNum).eyesOn := true
            else
                enemy(enemyNum).eyesOn := false
            end if
        end if
    else
        enemy(enemyNum).eyesOn := false
    end if
end sightCheck

proc enemyPathing(enemyNum : int)
    %Sprite.Hide(enemy1.bullet)
    if enemy(enemyNum).enemyPath and enemy(enemyNum).newPath then
        enemy(enemyNum).newPath := false
    end if
    if enemy(enemyNum).x - grid(enemy(enemyNum).path(enemy(enemyNum).count).x,enemy(enemyNum).path(enemy(enemyNum).count).y).leftB.x < 0 then
        enemy(enemyNum).x += 2
        enemy(enemyNum).moveDirection := "right"
        Sprite.Animate(enemy(enemyNum).SPR,enemySprite(enemyFrame),enemy(1).x+camera.x,enemy(enemyNum).y+camera.y,true)
    elsif enemy(enemyNum).x - grid(enemy(enemyNum).path(enemy(enemyNum).count).x,enemy(enemyNum).path(enemy(enemyNum).count).y).leftB.x > 0 then
        enemy(enemyNum).x -= 2
        enemy(enemyNum).moveDirection := "left"
        Sprite.Animate(enemy(enemyNum).SPR,enemySprite180(enemyFrame),enemy(enemyNum).x+camera.x,enemy(enemyNum).y+camera.y,true)
    elsif enemy(enemyNum).y - grid(enemy(enemyNum).path(enemy(enemyNum).count).x,enemy(enemyNum).path(enemy(enemyNum).count).y).leftB.y < 0 then
        enemy(enemyNum).y += 2
        enemy(enemyNum).moveDirection := "up"
        Sprite.Animate(enemy(enemyNum).SPR,enemySprite90(enemyFrame),enemy(enemyNum).x+camera.x,enemy(enemyNum).y+camera.y,true)
    elsif enemy(enemyNum).y - grid(enemy(enemyNum).path(enemy(enemyNum).count).x,enemy(enemyNum).path(enemy(enemyNum).count).y).leftB.y > 0 then
        enemy(enemyNum).y -= 2
        enemy(enemyNum).moveDirection := "down"
        Sprite.Animate(enemy(enemyNum).SPR,enemySprite270(enemyFrame),enemy(enemyNum).x+camera.x,enemy(enemyNum).y+camera.y,true)
    end if
    
    if enemy(enemyNum).x - grid(enemy(enemyNum).path(enemy(enemyNum).count).x,enemy(enemyNum).path(enemy(enemyNum).count).y).leftB.x > -1 and enemy(enemyNum).x - grid(enemy(enemyNum).path(enemy(enemyNum).count).x,enemy(enemyNum).path(enemy(enemyNum).count).y).leftB.x < 1 and enemy(enemyNum).y - grid(enemy(enemyNum).path(enemy(enemyNum).count).x,enemy(enemyNum).path(enemy(enemyNum).count).y).leftB.y > -1 and enemy(enemyNum).y - grid(enemy(enemyNum).path(enemy(enemyNum).count).x,enemy(enemyNum).path(enemy(enemyNum).count).y).leftB.y < 1 then
        enemy(enemyNum).count += 1
    end if
    if enemy(enemyNum).count = 101 then 
        enemy(enemyNum).status := "neutral"
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

proc enemyShooting(enemyNum : int)
    enemy(enemyNum).status := "shooting"
    %Starts timer if it is 0
    if enemy(enemyNum).shootDelay = 0 then
        enemy(enemyNum).shootDelay := Time.Elapsed
    end if
    %If time > 0.5 seconds then activte shooting
    if Time.Elapsed - enemy(enemyNum).shootDelay > 500 then
        enemy(enemyNum).shooting := true        
    end if
    if enemy(enemyNum).shooting = false then
        %Keep bullet origin and speed stuck to enemy, stop them changing once fired
        eBulletPos(enemyNum).x := enemy(enemyNum).x
        eBulletPos(enemyNum).y := enemy(enemyNum).y
        enemy(enemyNum).targetLocation.x := (maxx div 2 - camera.x)
        enemy(enemyNum).targetLocation.y := (maxy div 2 - camera.y)
        enemy(enemyNum).selfLocation.x := enemy(enemyNum).x
        enemy(enemyNum).selfLocation.y := enemy(enemyNum).y
        enemy(enemyNum).speed := 0.1
    else
        %If the bullet is fired incread x and y pos
        enemy(enemyNum).shootDelay := 0
        eBulletPos(enemyNum).x -= round((enemy(enemyNum).selfLocation.x - enemy(enemyNum).targetLocation.x) * enemy(enemyNum).speed) div 2
        eBulletPos(enemyNum).y -= round((enemy(enemyNum).selfLocation.y - enemy(enemyNum).targetLocation.y) * enemy(enemyNum).speed) div 2
        if abs(round((enemy(enemyNum).selfLocation.x - enemy(enemyNum).targetLocation.x) * enemy(enemyNum).speed) div 2) > 35 or abs(round((enemy(enemyNum).selfLocation.y - enemy(enemyNum).targetLocation.y) * enemy(enemyNum).speed) div 2) > 35 then
            enemy(enemyNum).speed -= 0.05
        end if
        enemy(enemyNum).speed += 0.001
        Sprite.Show(enemy(enemyNum).bullet)
    end if
Font.Draw(intstr(round((enemy(enemyNum).selfLocation.x - enemy(enemyNum).targetLocation.x) * enemy(enemyNum).speed) div 2),0,800,font1,white)
View.Update
%Animate Bullet

Sprite.Animate(enemy(enemyNum).bullet,bulletIMG,eBulletPos(enemyNum).x+camera.x,eBulletPos(enemyNum).y+camera.y,true)
Sprite.Animate(enemy(enemyNum).SPR,enemySprite270(enemyFrame),enemy(enemyNum).x+camera.x,enemy(enemyNum).y+camera.y,true)
%If the bullet hits a wall or the player, hide it and reset the shooting proc
if collisionDetect(eBulletPos(enemyNum).x+camera.x,eBulletPos(enemyNum).y+camera.y,false) or key('p')/*or Math.Distance(eBulletPos(1).x-20,eBulletPos(1).y-20,maxx div 2-camera.x,maxy div 2-camera.x) < 50 */then
enemy(enemyNum).shooting := false
Sprite.Hide(enemy(enemyNum).bullet)
end if
end enemyShooting

proc enemyReact(enemyNum : int)
    if enemy(enemyNum).eyesOn then
        enemy(enemyNum).pLast.x := maxx div 2 - camera.x
        enemy(enemyNum).pLast.y := maxy div 2 - camera.y
    end if
    if enemy(enemyNum).eyesOn then
        enemyShooting(enemyNum)
    end if
    if enemy(enemyNum).eyesOn = false then
        if enemy(enemyNum).pLast.x not= -1 then
            enemy(enemyNum).status := "neutral"
            aStar(enemy(enemyNum).x,enemy(enemyNum).y,enemy(enemyNum).pLast.x,enemy(enemyNum).pLast.y,enemyNum)
        end if    
    end if
    if shoot or enemy(enemyNum).noiseSearch and enemy(enemyNum).eyesOn = false then
        enemy(enemyNum).noiseSearch := true
        if enemy(enemyNum).setPlayerPos then
            enemy(enemyNum).tempPX := maxx div 2 - camera.x
            enemy(enemyNum).tempPY := maxy div 2 - camera.y
            enemy(enemyNum).setPlayerPos := false
        end if
        aStar(enemy(enemyNum).x,enemy(enemyNum).y,enemy(enemyNum).tempPX,enemy(enemyNum).tempPY,enemyNum)
    end if
end enemyReact

loop
% Player Based Procedures(only run once)
    mousewhere(mousex,mousey,button)
    playerAnimate
    movement
    playerShoot
    playerRoom := roomAssign(maxx div 2,maxy div 2)
    if enemy(1).dead = false then
        if Math.Distance(eBulletPos(1).x+camera.x,eBulletPos(1).y+camera.y,maxx div 2,maxy div 2) < 50 and enemy(1).shooting then
            quit
            %Main Menu/Retry
        end if
    end if
    %%%%%%%%%%%%%%%%%%%%%
    for i : 1 .. 2
        % Default Walk loop while not engaged with player
        if enemy(i).status = "neutral" then
            AISearch(i)
        end if
        % Assign a room based on enemy position
        enemy(i).enemyRoom := roomAssign(enemy(i).x+camera.x,enemy(i).y+camera.y)
        % Check if enemy has been hit with bullet
        if Math.Distance(bulletPos(1).x-camera.x,bulletPos(1).y-camera.y,enemy(i).x,enemy(i).y) < 50 and shoot then
            enemy(i).dead := true
            enemy(i).status := "neutral"
        end if
        % Search for player and shoot back
        if enemy(i).dead = false then
            sightCheck(i)
            enemyReact(i)
            if enemy(i).status = "searching" then
                enemyPathing(i)
            end if
        end if
    end for
    View.Update
end loop