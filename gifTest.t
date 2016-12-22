    %%%%% Bonus %%%%%
% Add sitting animations

%When an enemy sees player save their location and navigate to it then search or return to loop
View.Set("graphics:1260,900,offscreenonly,nocursor") % Release
%View.Set("graphics:1260,900") % Release
const mainLevel :int := Pic.FileNew("mainLevel.jpg")
var reset_time : int := Time.Elapsed
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
var debug : boolean := false
var debug_time : int := Time.Elapsed
var down_arrow :int := Pic.FileNew("go_down.gif")
type parent_type:
    record
        enemy1 : coordinate
        enemy2 : coordinate
        enemy3 : coordinate
        enemy4 : coordinate
    end record
var menu_time : int := Time.Elapsed
var level_time : int
var start_time : int
type score:
    record
        time_string : string
        miliseconds : int
        player_first_name : string
        player_last_name : string
    end record
var scores : array 1 .. 11 of score

type enemyType:
record
    x : int
    y : int
    randMove : int
    moveDirection : string
    shoot_direction : string
    dead : boolean
    pLast : vector
    path : array 1 .. 200 of coordinate
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
    bulletPos : coordinate
    start_room : int
    init_shoot_dir : boolean
end record
var menu_exit : boolean := false
var background_frame : int := 1
type box:
record
    start : boolean
    goal : boolean
    leftB  : coordinate
    rightB : coordinate
    leftT  : coordinate
    rightT : coordinate
    wall   : boolean
    parent : parent_type
    
end record
var menu_selection : int

type arrayElement:
    record
        a : int
        b : int
        fScore : int
        direction : string
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
var pathing : boolean := false
var counter :int := 0
var pathfind : boolean := false
var loops : int := 0
var shoot : boolean := false % true when player is shooting
var grid : array 1..60,1..53 of box
var camera : vector := init(0, 0)
var quit_sprite : int 
var gridUpdate : int := Time.Elapsed
var shootDelay : int := Time.Elapsed
var spongebobPos :vector := init(0, 0)
var eKill1IMG : int := Pic.FileNew("enemy_dead_guts.gif")
var eKill1SPR : int := Sprite.New(eKill1IMG)
var enemyDead : boolean := false
var inputEffects :array 1 .. 4 of inputEffect := init(init('a', init(6, 0)), init('d', init(-6, 0)), init('w', init(0, -6)), init('s', init(0,6)))
var key :array char of boolean
var bullet_img : array 1 .. 8 of int
var lastInputCheck :int := 0
var lastFrame : int := 0
var lastEnemyFrame : int := 0
var playerDirection : int
var postMove : vector
    var scores_sprite : int 
var player_num_frames := Pic.Frames ("player_walk_new.gif")
var enemy_num_frames := Pic.Frames ("enemy_shoot_0.gif")
var delayTime,delayTime2 : int
var test : int := Pic.FileNew("sprPWalkDoubleBarrel_0.bmp")
const num_enemies : int := 4
var enemy : array 1 .. num_enemies of enemyType
var logo_sprite : int
var enemy1Q : flexible array 1 .. 0 of arrayElement
var enemy1Searched : flexible array 1 .. 0 of arrayElement
var enemy2Q : flexible array 1 .. 0 of arrayElement
var enemy2Searched : flexible array 1 .. 0 of arrayElement
var enemy3Q : flexible array 1 .. 0 of arrayElement
var enemy3Searched : flexible array 1 .. 0 of arrayElement
var enemy4Q : flexible array 1 .. 0 of arrayElement
var enemy4Searched : flexible array 1 .. 0 of arrayElement
var chars: array char of boolean
var x,y, speed, mousex, mousey, button: int
var map1 : int := Pic.FileNew("mainLevel.jpg")
var ratio, angle : real
var font1 : int := Font.New("serif:12")
var font2 : int := Font.New("serif:50")
var playerFrame : int := 1
var play_sprite : int
var enemyFrame : int := 1

var bulletPos : array 1 .. 3 of vector
enemy(1).x := 0
enemy(2).x := 0
enemy(1).y := 0
enemy(2).y := 0
enemy(3).x := 0
enemy(4).x := 0
enemy(3).y := 0
enemy(4).y := 0
var sightRange : int := 300
var dist : real
var playerRoom : string := ""

var walls : array 1 .. 27 of wall
var shootDirection : int := 0
speed := 2
x := -942
y := 359
bulletPos(1).x := maxx div 2
bulletPos(1).y := maxy div 2

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
    elsif enemyNum = 3 then
        new enemy3Q, 0 
        new enemy3Searched, 0
        enemy(3).openX := 0
        enemy(3).openY := 0
    elsif enemyNum = 4 then
        new enemy4Q, 0 
        new enemy4Searched, 0
        enemy(4).openX := 0
        enemy(4).openY := 0
    end if
    enemy(enemyNum).initialize := true
    enemy(enemyNum).setPlayerPos := true
end resetAStar  

% Sets all elements to 0 to see when the array elements start
proc reset_game_vars
    for i : 1 .. num_enemies
        enemy(i).count := 1
        enemy(i).dead := false
        enemy(i).pLast.x := -1
        enemy(i).pLast.y := -1
        enemy(i).shootDelay := 0
        enemy(i).shooting := false
        enemy(i).status := "neutral"
        enemy(i).noiseSearch := false
        enemy(i).setPlayerPos := true
        enemy(i).initialize := true
        enemy(i).newPath := false
        enemy(i).eyesOn := false
        enemy(i).bulletPos.x := enemy(1).x
        enemy(i).bulletPos.y := enemy(1).y
        enemy(i).enemyRoom := "null"
        enemy(i).timeOnTarget := 0
        enemy(i).enemyPath := false
        enemy(i).init_shoot_dir := true
        resetAStar(i)
        for j : 1 .. upper(enemy(i).path)
            enemy(i).path(j).x := 0
            enemy(i).path(j).y := 0
        end for
    end for
    camera.x := -930
    camera.y := 300
end reset_game_vars
reset_game_vars
cls
var enemy_walk_frames_0    : array 1 .. enemy_num_frames of int
Pic.FileNewFrames ("enemy_walk_0.gif", enemy_walk_frames_0, delayTime)
var enemy_walk_frames_90  : array 1 .. enemy_num_frames of int
Pic.FileNewFrames ("enemy_walk_90.gif", enemy_walk_frames_90, delayTime)
var enemy_walk_frames_180 : array 1 .. enemy_num_frames of int
Pic.FileNewFrames ("enemy_walk_180.gif", enemy_walk_frames_180, delayTime)
var enemy_walk_frames_270 : array 1 .. enemy_num_frames of int
Pic.FileNewFrames ("enemy_walk_270.gif", enemy_walk_frames_270, delayTime)

var player_walk_frames_0    : array 1 .. player_num_frames of int
Pic.FileNewFrames ("player_walk_new.gif", player_walk_frames_0, delayTime)
var player_walk_frames_45 : array 1 .. player_num_frames of int
Pic.FileNewFrames("player_walk_new_45.gif",player_walk_frames_45,delayTime)
var player_walk_frames_90 : array 1 .. player_num_frames of int
Pic.FileNewFrames("player_walk_new_90.gif",player_walk_frames_90,delayTime)
var player_walk_frames_135 : array 1 .. player_num_frames of int
Pic.FileNewFrames("player_walk_new_135.gif",player_walk_frames_135,delayTime)
var player_walk_frames_180 : array 1 .. player_num_frames of int
Pic.FileNewFrames("player_walk_new_180.gif",player_walk_frames_180,delayTime)
var player_walk_frames_225 : array 1 .. player_num_frames of int
Pic.FileNewFrames("player_walk_new_225.gif",player_walk_frames_225,delayTime)
var player_walk_frames_270 : array 1 .. player_num_frames of int
Pic.FileNewFrames("player_walk_new_270.gif",player_walk_frames_270,delayTime)
var player_walk_frames_315 : array 1 .. player_num_frames of int
Pic.FileNewFrames("player_walk_new_315.gif",player_walk_frames_315,delayTime)
var player_dead_pics : array 1 .. 3 of int
player_dead_pics(1) := Pic.FileNew("_img/player_dead_1.gif")
player_dead_pics(2) := Pic.FileNew("_img/player_dead_2.gif")
player_dead_pics(3) := Pic.FileNew("_img/player_dead_3.gif")
bullet_img(1) := Pic.FileNew("bullet.gif")
bullet_img(2) := Pic.FileNew("bullet45.gif")
bullet_img(3) := Pic.FileNew("bullet90.gif")
bullet_img(4) := Pic.FileNew("bullet135.gif")
bullet_img(5) := Pic.FileNew("bullet180.gif")
bullet_img(6) := Pic.FileNew("bullet225.gif")
bullet_img(7) := Pic.FileNew("bullet270.gif")
bullet_img(8) := Pic.FileNew("bullet315.gif")
var player: int := Sprite.New(player_walk_frames_0(1))

var bulletSPR : int := Sprite.New(bullet_img(1))

for i : 1 .. num_enemies
    enemy(i).bullet := Sprite.New(bullet_img(1))
    enemy(i).SPR := Sprite.New(enemy_walk_frames_0(1))
end for
    
/*
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
    */
process play_audio(track_name : string)
    if track_name = "Game" then
        Music.PlayFile("_audio/05 - Vengeance.mp3")
    elsif track_name = "gunshot" then
        Music.PlayFile("_audio/shotgunFire.mp3")
        Music.PlayFile("_audio/shotgunReload.mp3")
    elsif track_name = "menu" then
        Music.PlayFile("_audio/03 - Paris.mp3")
    end if
end play_audio 

proc set_enemy_room
    enemy(1).start_room := Rand.Int(1,7)
    loop
        enemy(2).start_room := Rand.Int(1,7)
        exit when enemy(2).start_room ~= enemy(1).start_room
    end loop
    loop
        enemy(3).start_room := Rand.Int(1,7)
        exit when enemy(3).start_room ~= enemy(1).start_room and enemy(3).start_room ~= enemy(2).start_room
    end loop
    loop
        enemy(4).start_room := Rand.Int(1,7)
        exit when enemy(4).start_room ~= enemy(1).start_room and enemy(4).start_room ~= enemy(2).start_room and enemy(4).start_room ~= enemy(3).start_room
    end loop
    for enemy_num : 1 .. num_enemies
        if enemy(enemy_num).start_room = 1 then % Carbon
            enemy(enemy_num).x := Rand.Int(650,1340)
            enemy(enemy_num).y := Rand.Int(300,930)
        elsif enemy(enemy_num).start_room = 2 then % Wood
            enemy(enemy_num).x := Rand.Int(775,1340)
            enemy(enemy_num).y := Rand.Int(1020,1765)
        elsif enemy(enemy_num).start_room = 3 then % Long Vert Hall
            enemy(enemy_num).x := Rand.Int(1453,1756)
            enemy(enemy_num).y := Rand.Int(308,2155)
        elsif enemy(enemy_num).start_room = 4 then % Short Vert Hall
            enemy(enemy_num).x := Rand.Int(365,666)
            enemy(enemy_num).y := Rand.Int(1045,2155)
        elsif enemy(enemy_num).start_room = 5 then % Red
            enemy(enemy_num).x := Rand.Int(1867,2356)
            enemy(enemy_num).y := Rand.Int(308,1334)
        elsif enemy(enemy_num).start_room = 6 then % Purple
            enemy(enemy_num).x := Rand.Int(2467,2899)
            enemy(enemy_num).y := Rand.Int(1445,1765)
        elsif enemy(enemy_num).start_room = 7 then % Long Horz Hall
            enemy(enemy_num).x := Rand.Int(651,2899)
            enemy(enemy_num).y := Rand.Int(1876,2155)
        end if
    end for
end set_enemy_room  
set_enemy_room

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
    walls(4).y.lower := 952  + camera.y
    walls(4).y.upper := 1025 + camera.y
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
    % Top wall of elevator
    walls(25).x.lower := 1377 + camera.x
    walls(25).x.upper := 1829 + camera.x
    walls(25).y.lower := 2572 + camera.y
    walls(25).y.upper := 2604 + camera.y
    % Right wall of elevator
    walls(26).x.lower := 1377 + camera.x
    walls(26).x.upper := 1412 + camera.x
    walls(26).y.lower := 2175  + camera.y
    walls(26).y.upper := 2604 + camera.y
    % Left wall of elevator
    walls(27).x.lower := 1795 + camera.x
    walls(27).x.upper := 1829 + camera.x
    walls(27).y.lower := 2175  + camera.y
    walls(27).y.upper := 2604  + camera.y
    
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
            if collisionDetect(grid(i,j).leftB.x+camera.x, grid(i,j).leftB.y+camera.y,true)  or
                    collisionDetect(grid(i,j).rightB.x+camera.x,grid(i,j).rightB.y+camera.y,true) or
                    collisionDetect(grid(i,j).leftT.x+camera.x,grid(i,j).leftT.y+camera.y,true) or
                    collisionDetect(grid(i,j).rightT.x+camera.x,grid(i,j).rightT.y+camera.y,true) then
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
    if debug then
    Font.Draw("Enemy #1: ",0,maxy-20,font1,white)
    Font.Draw("Position: X: "+intstr(enemy(1).x) + " Y: " + intstr(enemy(1).y),0,maxy-40,font1,white)
    Font.Draw("Enemy Status: "+enemy(1).status,0,maxy-60,font1,white)
    if enemy(1).noiseSearch then
        Font.Draw("Enemy noiseSearch: true ", 0, maxy-80, font1, white)
    else
        Font.Draw("Enemy noiseSearch: false ", 0, maxy-80, font1, white)
    end if
    Font.Draw("Enemy room: " + enemy(1).enemyRoom,0,maxy-100,font1,white)
    if enemy(1).eyesOn then
        Font.Draw("Enemy 1 Eyes-on: true",0,maxy-120,font1,white) 
    else 
        Font.Draw("Enemy 1 Eyes-on: false",0,maxy-120,font1,white)
    end if
    Font.Draw(intstr(upper(enemy1Q)) + " items in Q",0,maxy-140,font1,white)
    Font.Draw(intstr(upper(enemy1Searched)) + " items in Searched",0,maxy-160,font1,white)
    Font.Draw("Current item in path: " + intstr(enemy(1).count),0,maxy-180,font1,white)
    if enemy(1).status = "searching" then
        Font.Draw("Next element in path: X: " + intstr(grid(enemy(1).path(enemy(1).count).x,enemy(1).path(enemy(1).count).y).leftB.x) + " Y: " + intstr(grid(enemy(1).path(enemy(1).count).x,enemy(1).path(enemy(1).count).y).leftB.y),0,maxy-200,font1,white)
    else
        Font.Draw("Not searching",0,maxy-200,font1,white)
    end if
    Font.Draw("Enemy count: " + intstr(enemy(1).count),0,maxy-220,font1,white)
    %Font.Draw("------------------------------",0,maxy-220,font1,black)
    Font.Draw("Enemy #2: ",0,maxy-240,font1,white)
    Font.Draw("Position: X: "+intstr(enemy(2).x) + " Y: " + intstr(enemy(2).y),0,maxy-260,font1,white)
    Font.Draw("Enemy Status: "+enemy(2).status,0,maxy-280,font1,white)
    if enemy(2).noiseSearch then
        Font.Draw("Enemy noiseSearch: true ", 0, maxy-300, font1, white)
    else
        Font.Draw("Enemy noiseSearch: false ", 0, maxy-300, font1, white)
    end if
    Font.Draw("Enemy room: " + enemy(2).enemyRoom,0,maxy-320,font1,white)
    if enemy(2).eyesOn then
        Font.Draw("Enemy 2 Eyes-on: true",0,maxy-340,font1,white) 
    else 
        Font.Draw("Enemy 2 Eyes-on: false",0,maxy-340,font1,white)
    end if
    Font.Draw(intstr(upper(enemy2Q)) + " items in Q",0,maxy-360,font1,white)
    Font.Draw(intstr(upper(enemy2Searched)) + " items in Searched",0,maxy-380,font1,white)
    Font.Draw("Current item in path: " + intstr(enemy(2).count),0,maxy-400,font1,white)
    if enemy(2).status = "searching" then
        Font.Draw("Next element in path: X: " + intstr(grid(enemy(2).path(enemy(2).count).x,enemy(2).path(enemy(2).count).y).leftB.x) + " Y: " + intstr(grid(enemy(2).path(enemy(2).count).x,enemy(2).path(enemy(2).count).y).leftB.y),0,maxy-420,font1,white)
    else
        Font.Draw("Not searching",0,maxy-420,font1,white)
    end if
    Font.Draw("Enemy count: " + intstr(enemy(2).count),0,maxy-440,font1,white)
    Font.Draw("Player Room " + playerRoom,0,400,font1,black)
    Font.Draw("Player X: " + intstr(maxx div 2 - camera.x) + " Y: " + intstr(maxy div 2 - camera.y),0,370,font1,white)
    end if
    View.Update
    
end movement

function contains (x,y,enemyNum : int,list :string) : boolean
    if enemyNum = 1 then
        if list = "q" then
            for i : 1 .. upper(enemy1Q)
                if enemy1Q(i).a = x and enemy1Q(i).b = y then
                    result true
                end if
            end for
            result false
        elsif list = "searched" then
            for i : 1 .. upper(enemy1Searched)
                if enemy1Searched(i).a = x and enemy1Searched(i).b = y then
                    result true
                end if
            end for
            result false
        end if
    elsif enemyNum = 2 then
        if list = "q" then
            for i : 1 .. upper(enemy2Q)-1
                if enemy2Q(i).a = x and enemy2Q(i).b = y then
                    result true
                end if
            end for
            result false
        elsif list = "searched" then
            for i : 1 .. upper(enemy2Searched)
                if enemy2Searched(i).a = x and enemy2Searched(i).b = y then
                    result true
                end if
            end for
            result false
        end if
    elsif enemyNum = 3 then
        if list = "q" then
            for i : 1 .. upper(enemy3Q)
                if enemy3Q(i).a = x and enemy3Q(i).b = y then
                    result true
                end if
            end for
            result false
        elsif list = "searched" then
            for i : 1 .. upper(enemy3Searched)
                if enemy3Searched(i).a = x and enemy3Searched(i).b = y then
                    result true
                end if
            end for
            result false
        end if
    elsif enemyNum = 4 then
        if list = "q" then
            for i : 1 .. upper(enemy4Q)
                if enemy4Q(i).a = x and enemy4Q(i).b = y then
                    result true
                end if
            end for
            result false
        elsif list = "searched" then
            for i : 1 .. upper(enemy4Searched)
                if enemy4Searched(i).a = x and enemy4Searched(i).b = y then
                    result true
                end if
            end for
            result false
        end if
    end if
end contains


proc aStar(startX,startY,goalX,goalY,enemyNum:int)
    if enemyNum = 1 then
        if enemy(enemyNum).initialize then
            for i : 1 .. 60
                for j : 1 .. 53
                    if startX >= grid(i,j).leftB.x and 
                            startX < grid(i,j).rightB.x and 
                            startY >= grid(i,j).leftB.y and 
                            startY < grid(i,j).leftT.y then
                        enemy(enemyNum).start.x := i
                        enemy(enemyNum).start.y := j
                        grid(i,j).start := true
                        new enemy1Q, upper(enemy1Q)+1
                        enemy1Q(upper(enemy1Q)).a := i
                        enemy1Q(upper(enemy1Q)).b := j
                    end if
                    if goalX >= grid(i,j).leftB.x and 
                        goalX < grid(i,j).rightB.x and
                        goalY >= grid(i,j).leftB.y and
                        goalY < grid(i,j).leftT.y then
                        grid(i,j).goal := true
                        grid(i,j).wall := false
                        enemy(enemyNum).goal.x := i
                        enemy(enemyNum).goal.y := j
                    end if
                end for
            end for
                enemy(enemyNum).initialize := false
        end if
    
    if enemy(enemyNum).goal.x not= enemy(enemyNum).start.x or 
            enemy(enemyNum).goal.y not= enemy(enemyNum).start.y then
        %Open first item in queue and remove from list
        enemy(enemyNum).openX := enemy1Q(lower(enemy1Q)).a
        enemy(enemyNum).openY := enemy1Q(lower(enemy1Q)).b
        new enemy1Searched, upper(enemy1Searched) + 1
        enemy1Searched(upper(enemy1Searched)) := enemy1Q(lower(enemy1Q))
        for i : 1 .. upper(enemy1Q)-1
            enemy1Q(i) := enemy1Q(i+1)
        end for
            new enemy1Q, upper(enemy1Q)-1
        %Add surrounding tiles to queue
        %Up Tile
        if enemy(enemyNum).openX+1 <= upper(grid,1) then
            if grid(enemy(enemyNum).openX+1,enemy(enemyNum).openY). wall = false and 
                    contains(enemy(enemyNum).openX+1,enemy(enemyNum).openY,1,'searched') = false and 
                    contains(enemy(enemyNum).openX+1,enemy(enemyNum).openY,1,'q') = false then
                new enemy1Q, upper(enemy1Q) + 1
                enemy1Q(upper(enemy1Q)).a := enemy(enemyNum).openX + 1
                enemy1Q(upper(enemy1Q)).b := enemy(enemyNum).openY
                grid(enemy(enemyNum).openX+1,enemy(enemyNum).openY).parent.enemy1.x := enemy(enemyNum).openX
                grid(enemy(enemyNum).openX+1,enemy(enemyNum).openY).parent.enemy1.y := enemy(enemyNum).openY
                enemy1Q(upper(enemy1Q)).fScore := round( 8*(abs(enemy(enemyNum).openX+1 - enemy(enemyNum).goal.x) + abs(enemy(enemyNum).openY   - enemy(enemyNum).goal.y)) + abs(enemy(enemyNum).openX+1 - enemy(enemyNum).start.x) + abs(enemy(enemyNum).openY   - enemy(enemyNum).start.y))
                enemy1Q(upper(enemy1Q)).direction := "up"
                put enemy1Q(upper(enemy1Q)).fScore
            end if
        end if
        %Down Tile
        if enemy(1).openX-1 >= 1 then
            if grid(enemy(1).openX-1,enemy(enemyNum).openY). wall = false and contains(enemy(enemyNum).openX-1,enemy(1).openY,1,'searched') = false and contains(enemy(enemyNum).openX-1,enemy(enemyNum).openY,1,'q') = false then
                new enemy1Q, upper(enemy1Q) + 1
                enemy1Q(upper(enemy1Q)).a := enemy(enemyNum).openX - 1
                enemy1Q(upper(enemy1Q)).b := enemy(enemyNum).openY
                grid(enemy(enemyNum).openX-1,enemy(enemyNum).openY).parent.enemy1.x := enemy(enemyNum).openX
                grid(enemy(enemyNum).openX-1,enemy(enemyNum).openY).parent.enemy1.y := enemy(enemyNum).openY
                enemy1Q(upper(enemy1Q)).fScore := round( 8*(abs((enemy(enemyNum).openX-1)-enemy(enemyNum).goal.x) + abs(enemy(enemyNum).openY-enemy(enemyNum).goal.y)) + (abs((enemy(enemyNum).openX-1)-enemy(enemyNum).start.x) + abs(enemy(enemyNum).openY-enemy(enemyNum).start.y)))
                enemy1Q(upper(enemy1Q)).direction := "down"
                put enemy1Q(upper(enemy1Q)).fScore
            end if
        end if
        %Left Tile
        if enemy(enemyNum).openY+1 <= upper(grid,2) then
            if grid(enemy(enemyNum).openX,enemy(enemyNum).openY+1). wall = false and contains(enemy(enemyNum).openX,enemy(enemyNum).openY+1,1,'searched') = false and contains(enemy(enemyNum).openX,enemy(enemyNum).openY+1,1,'q') = false then
                new enemy1Q, upper(enemy1Q) + 1
                enemy1Q(upper(enemy1Q)).a := enemy(enemyNum).openX
                enemy1Q(upper(enemy1Q)).b := enemy(enemyNum).openY + 1
                grid(enemy(enemyNum).openX,enemy(enemyNum).openY+1).parent.enemy1.x := enemy(enemyNum).openX
                grid(enemy(enemyNum).openX,enemy(enemyNum).openY+1).parent.enemy1.y := enemy(enemyNum).openY
                enemy1Q(upper(enemy1Q)).fScore := round( 8*(abs(enemy(enemyNum).openX-enemy(enemyNum).goal.x) + abs((enemy(enemyNum).openY+1)-enemy(enemyNum).goal.y)) + (abs(enemy(enemyNum).openX-enemy(enemyNum).start.x) + abs((enemy(enemyNum).openY+1)-enemy(enemyNum).start.y)))
                enemy1Q(upper(enemy1Q)).direction := 'left'
                put "fscore ", enemy1Q(upper(enemy1Q)).fScore
            end if
        end if
        %Right Tile
        if enemy(enemyNum).openY-1 >= lower(grid,1) then            
            if grid(enemy(enemyNum).openX,enemy(enemyNum).openY-1). wall = false and contains(enemy(enemyNum).openX,enemy(enemyNum).openY-1,1,'searched') = false and contains(enemy(enemyNum).openX,enemy(enemyNum).openY-1,1,'q') = false then
                new enemy1Q, upper(enemy1Q) + 1
                enemy1Q(upper(enemy1Q)).a := enemy(enemyNum).openX
                enemy1Q(upper(enemy1Q)).b := enemy(enemyNum).openY - 1
                grid(enemy(enemyNum).openX,enemy(enemyNum).openY-1).parent.enemy1.x := enemy(enemyNum).openX
                grid(enemy(enemyNum).openX,enemy(enemyNum).openY-1).parent.enemy1.y := enemy(enemyNum).openY
                enemy1Q(upper(enemy1Q)).fScore := round( 8*(abs(enemy(enemyNum).openX-enemy(enemyNum).goal.x) + abs((enemy(enemyNum).openY-1)-enemy(enemyNum).goal.y)) + (abs(enemy(enemyNum).openX-enemy(enemyNum).start.x) + abs((enemy(enemyNum).openY-1)-enemy(enemyNum).start.y)))
                 enemy1Q(upper(enemy1Q)).direction := 'left'
                put "fscore ", enemy1Q(upper(enemy1Q)).fScore
            end if
        end if
        if enemy(enemyNum).goal.x not= enemy(enemyNum).openX then
            %Sort
            if debug then
             for j : 1 .. upper(enemy1Q)-1
                        put "enemy4 ",j..
                        put " upper: ",upper(enemy1Q)..
                       put " ",enemy1Q(j).a, " ",enemy1Q(j).b..
                       put "direction: ",enemy1Q(j).direction
                        put " fScore ",enemy1Q(j).fScore
                        View.Update
                    end for
                end if
            var temp : arrayElement
            for a : 1 .. upper(enemy1Q)
                for i : 1 .. (upper(enemy1Q)-1)
                    if debug then
                         put enemy1Q(i).a
                    end if
                    if enemy1Q(i).fScore > enemy1Q(i+1).fScore then
                        temp := enemy1Q(i)
                        enemy1Q(i) := enemy1Q(i+1)
                        enemy1Q(i+1) := temp
                    end if
                end for
            end for
        end if
        if enemy(enemyNum).openX = enemy(enemyNum).goal.x and enemy(enemyNum).openY = enemy(enemyNum).goal.y then
            enemy(enemyNum).path(200).x := enemy(enemyNum).openX
            enemy(enemyNum).path(200).y := enemy(enemyNum).openY
            enemy(enemyNum).path(199).x := grid(enemy(enemyNum).openX,enemy(enemyNum).openY).parent.enemy1.x
            enemy(enemyNum).path(199).y := grid(enemy(enemyNum).openX,enemy(enemyNum).openY).parent.enemy1.y
            enemy(enemyNum).count := 198
            loop/*
                put "enemyNum ",enemyNum..
                put ' count' ,enemy(enemyNum).count..
                put  " x val: ",grid(enemy(enemyNum).path(enemy(enemyNum).count+1).x, enemy(enemyNum).path(enemy(enemyNum).count+1).y).leftB.x..
                put " y val: ",grid(enemy(enemyNum).path(enemy(enemyNum).count+1).x, enemy(enemyNum).path(enemy(enemyNum).count+1).y).leftB.y..
                put " Goal X: ", goalX..
                put " Y: ", goalY..
                put " Goal X: ",enemy(enemyNum).goal.x..
                put" Y: ",enemy(enemyNum).goal.y..
                put " current X: ",enemy(enemyNum).path(enemy(enemyNum).count+1).x..
                put " Y: ",enemy(enemyNum).path(enemy(enemyNum).count+1).y
                put "Grid at current X: ", grid(enemy(enemyNum).path(enemy(enemyNum).count+1).x,enemy(enemyNum).path(enemy(enemyNum).count+1).y).leftB.x..
                 put "Y: ", grid(enemy(enemyNum).path(enemy(enemyNum).count+1).x,enemy(enemyNum).path(enemy(enemyNum).count+1).y).leftB.y
                put contains(enemy(enemyNum).path(enemy(enemyNum).count+1).x,enemy(enemyNum).path(enemy(enemyNum).count+1).y,1,'searched')
                View.Update*/
                enemy(enemyNum).path(enemy(enemyNum).count).x := grid(enemy(enemyNum).path(enemy(enemyNum).count+1).x, enemy(enemyNum).path(enemy(enemyNum).count+1).y).parent.enemy1.x
                enemy(enemyNum).path(enemy(enemyNum).count).y := grid(enemy(enemyNum).path(enemy(enemyNum).count+1).x, enemy(enemyNum).path(enemy(enemyNum).count+1).y).parent.enemy1.y
                enemy(enemyNum).count -= 1
                if enemy(enemyNum).path(enemy(enemyNum).count+1).x = enemy(enemyNum).start.x and 
                        enemy(enemyNum).path(enemy(enemyNum).count+1).y = enemy(enemyNum).start.y then
                    exit
                end if
                if enemy(enemyNum).count = 1 then
                    resetAStar(enemyNum)
                    exit
                end if
            end loop
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
    elsif enemyNum =2 then
        if enemy(enemyNum).initialize then
            for i : 1 .. 60
                for j : 1 .. 53
                    if startX >= grid(i,j).leftB.x and 
                            startX < grid(i,j).rightB.x and 
                            startY >= grid(i,j).leftB.y and 
                            startY < grid(i,j).leftT.y then
                        enemy(enemyNum).start.x := i
                        enemy(enemyNum).start.y := j
                        grid(i,j).start := true
                        new enemy2Q, upper(enemy2Q)+1
                        enemy2Q(upper(enemy2Q)).a := i
                        enemy2Q(upper(enemy2Q)).b := j
                    end if
                    if goalX >= grid(i,j).leftB.x and 
                        goalX < grid(i,j).rightB.x and
                        goalY >= grid(i,j).leftB.y and
                        goalY < grid(i,j).leftT.y then
                        grid(i,j).goal := true
                        grid(i,j).wall := false
                        enemy(enemyNum).goal.x := i
                        enemy(enemyNum).goal.y := j
                    end if
                end for
            end for
                enemy(enemyNum).initialize := false
        end if
    
    if enemy(enemyNum).goal.x not= enemy(enemyNum).start.x or 
            enemy(enemyNum).goal.y not= enemy(enemyNum).start.y then
        %Open first item in queue and remove from list
        enemy(enemyNum).openX := enemy2Q(lower(enemy2Q)).a
        enemy(enemyNum).openY := enemy2Q(lower(enemy2Q)).b
        new enemy2Searched, upper(enemy2Searched) + 1
        enemy2Searched(upper(enemy2Searched)) := enemy2Q(lower(enemy2Q))
        for i : 1 .. upper(enemy2Q)-1
            enemy2Q(i) := enemy2Q(i+1)
        end for
        new enemy2Q, upper(enemy2Q)-1
        %Add surrounding tiles to queue
        %Up Tile
        if enemy(enemyNum).openX+1 <= upper(grid,1) then
            if grid(enemy(enemyNum).openX+1,enemy(enemyNum).openY). wall = false and 
                    contains(enemy(enemyNum).openX+1,enemy(enemyNum).openY,2,'searched') = false and 
                    contains(enemy(enemyNum).openX+1,enemy(enemyNum).openY,2,'q') = false then
                new enemy2Q, upper(enemy2Q) + 1
                enemy2Q(upper(enemy2Q)).a := enemy(enemyNum).openX + 1
                enemy2Q(upper(enemy2Q)).b := enemy(enemyNum).openY
                grid(enemy(enemyNum).openX+1,enemy(enemyNum).openY).parent.enemy2.x := enemy(enemyNum).openX
                grid(enemy(enemyNum).openX+1,enemy(enemyNum).openY).parent.enemy2.y := enemy(enemyNum).openY
                enemy2Q(upper(enemy2Q)).fScore := round( 8*(abs(enemy(enemyNum).openX+1 - enemy(enemyNum).goal.x) + 
                abs(enemy(enemyNum).openY   - enemy(enemyNum).goal.y)) + 
                abs(enemy(enemyNum).openX+1 - enemy(enemyNum).start.x) + 
                abs(enemy(enemyNum).openY   - enemy(enemyNum).start.y))
                enemy2Q(upper(enemy2Q)).direction := 'up'
                put enemy2Q(upper(enemy2Q)).fScore
            end if
        end if
        %Down Tile
        if enemy(enemyNum).openX-1 >= 1 then
            if grid(enemy(enemyNum).openX-1,enemy(enemyNum).openY). wall = false and contains(enemy(enemyNum).openX-1,enemy(enemyNum).openY,2,'searched') = false and contains(enemy(enemyNum).openX-1,enemy(enemyNum).openY,2,'q') = false then
                new enemy2Q, upper(enemy2Q) + 1
                enemy2Q(upper(enemy2Q)).a := enemy(enemyNum).openX - 1
                enemy2Q(upper(enemy2Q)).b := enemy(enemyNum).openY
                grid(enemy(enemyNum).openX-1,enemy(enemyNum).openY).parent.enemy2.x := enemy(enemyNum).openX
                grid(enemy(enemyNum).openX-1,enemy(enemyNum).openY).parent.enemy2.y := enemy(enemyNum).openY
                enemy2Q(upper(enemy2Q)).fScore := round( 8*(abs((enemy(enemyNum).openX-1)-enemy(enemyNum).goal.x) + abs(enemy(enemyNum).openY-enemy(enemyNum).goal.y)) + (abs((enemy(enemyNum).openX-1)-enemy(enemyNum).start.x) + abs(enemy(enemyNum).openY-enemy(enemyNum).start.y)))
                enemy2Q(upper(enemy2Q)).direction := 'down'
                put enemy2Q(upper(enemy2Q)).fScore
            end if
        end if
        %Left Tile
        if enemy(enemyNum).openY+1 <= upper(grid,2) then
            if grid(enemy(enemyNum).openX,enemy(enemyNum).openY+1). wall = false and contains(enemy(enemyNum).openX,enemy(enemyNum).openY+1,2,'searched') = false and contains(enemy(enemyNum).openX,enemy(enemyNum).openY+1,2,'q') = false then
                new enemy2Q, upper(enemy2Q) + 1
                enemy2Q(upper(enemy2Q)).a := enemy(enemyNum).openX
                enemy2Q(upper(enemy2Q)).b := enemy(enemyNum).openY + 1
                grid(enemy(enemyNum).openX,enemy(enemyNum).openY+1).parent.enemy2.x := enemy(enemyNum).openX
                grid(enemy(enemyNum).openX,enemy(enemyNum).openY+1).parent.enemy2.y := enemy(enemyNum).openY
                enemy2Q(upper(enemy2Q)).fScore := round( 8*(abs(enemy(enemyNum).openX-enemy(enemyNum).goal.x) + abs((enemy(enemyNum).openY+1)-enemy(enemyNum).goal.y)) + (abs(enemy(enemyNum).openX-enemy(enemyNum).start.x) + abs((enemy(enemyNum).openY+1)-enemy(enemyNum).start.y)))
                enemy2Q(upper(enemy2Q)).direction := 'left'
                put enemy2Q(upper(enemy2Q)).fScore
            end if
        end if
        %Right Tile
        if enemy(enemyNum).openY-1 >= lower(grid,1) then            
            if grid(enemy(enemyNum).openX,enemy(enemyNum).openY-1). wall = false and contains(enemy(enemyNum).openX,enemy(enemyNum).openY-1,2,'searched') = false and contains(enemy(enemyNum).openX,enemy(enemyNum).openY-1,2,'q') = false then
                new enemy2Q, upper(enemy2Q) + 1
                enemy2Q(upper(enemy2Q)).a := enemy(enemyNum).openX
                enemy2Q(upper(enemy2Q)).b := enemy(enemyNum).openY - 1
                grid(enemy(enemyNum).openX,enemy(enemyNum).openY-1).parent.enemy2.x := enemy(enemyNum).openX
                grid(enemy(enemyNum).openX,enemy(enemyNum).openY-1).parent.enemy2.y := enemy(enemyNum).openY
                enemy2Q(upper(enemy2Q)).fScore := round( 8*(abs(enemy(enemyNum).openX-enemy(enemyNum).goal.x) + abs((enemy(enemyNum).openY-1)-enemy(enemyNum).goal.y)) + (abs(enemy(enemyNum).openX-enemy(enemyNum).start.x) + abs((enemy(enemyNum).openY-1)-enemy(enemyNum).start.y)))
                enemy2Q(upper(enemy2Q)).direction := 'right'
                put enemy2Q(upper(enemy2Q)).fScore
            end if
        end if
        if enemy(enemyNum).goal.x not= enemy(enemyNum).openX then
        if debug then
        for j : 1 .. upper(enemy2Q)-1
                        put "enemy4 ",j..
                        put " upper: ",upper(enemy2Q)..
                       put " ",enemy2Q(j).a, " ",enemy2Q(j).b..
                       put "direction: ",enemy2Q(j).direction
                        put " fScore ",enemy2Q(j).fScore
                        View.Update
                    end for
                    end if
            %Sort
            var temp : arrayElement
            for a : 1 .. upper(enemy2Q)
                for i : 1 .. (upper(enemy2Q)-1)
                    if enemy2Q(i).fScore > enemy2Q(i+1).fScore then
                        temp := enemy2Q(i)
                        enemy2Q(i) := enemy2Q(i+1)
                        enemy2Q(i+1) := temp
                    end if
                end for
            end for
        end if
        if enemy(enemyNum).openX = enemy(enemyNum).goal.x and enemy(enemyNum).openY = enemy(enemyNum).goal.y then
            enemy(enemyNum).path(200).x := enemy(enemyNum).openX
            enemy(enemyNum).path(200).y := enemy(enemyNum).openY
            enemy(enemyNum).path(199).x := grid(enemy(enemyNum).openX,enemy(enemyNum).openY).parent.enemy2.x
            enemy(enemyNum).path(199).y := grid(enemy(enemyNum).openX,enemy(enemyNum).openY).parent.enemy2.y
            enemy(enemyNum).count := 198
            loop/*
                put "enemyNum ",enemyNum..
                put ' count' ,enemy(enemyNum).count..
                put  " x val: ",grid(enemy(enemyNum).path(enemy(enemyNum).count+1).x, enemy(enemyNum).path(enemy(enemyNum).count+1).y).leftB.x..
                put " y val: ",grid(enemy(enemyNum).path(enemy(enemyNum).count+1).x, enemy(enemyNum).path(enemy(enemyNum).count+1).y).leftB.y..
                put " Goal X: ", goalX..
                put " Y: ", goalY..
                put " Goal X: ",enemy(enemyNum).goal.x..
                put" Y: ",enemy(enemyNum).goal.y..
                put " current X: ",enemy(enemyNum).path(enemy(enemyNum).count+1).x..
                put " Y: ",enemy(enemyNum).path(enemy(enemyNum).count+1).y..
                put contains(enemy(enemyNum).path(enemy(enemyNum).count+1).x,enemy(enemyNum).path(enemy(enemyNum).count+1).y,2,'searched')
                View.Update*/
                enemy(enemyNum).path(enemy(enemyNum).count).x := grid(enemy(enemyNum).path(enemy(enemyNum).count+1).x, enemy(enemyNum).path(enemy(enemyNum).count+1).y).parent.enemy2.x
                enemy(enemyNum).path(enemy(enemyNum).count).y := grid(enemy(enemyNum).path(enemy(enemyNum).count+1).x, enemy(enemyNum).path(enemy(enemyNum).count+1).y).parent.enemy2.y
                enemy(enemyNum).count -= 1
                if enemy(enemyNum).path(enemy(enemyNum).count+1).x = enemy(enemyNum).start.x and 
                    enemy(enemyNum).path(enemy(enemyNum).count+1).y = enemy(enemyNum).start.y then
                    exit
                end if
                if enemy(enemyNum).count = 1 then
                    resetAStar(enemyNum)
                    exit
                end if
            end loop
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
    elsif enemyNum = 3 then
        if enemy(enemyNum).initialize then
            for i : 1 .. 60
                for j : 1 .. 53
                    if startX >= grid(i,j).leftB.x and 
                            startX < grid(i,j).rightB.x and 
                            startY >= grid(i,j).leftB.y and 
                            startY < grid(i,j).leftT.y then
                        enemy(enemyNum).start.x := i
                        enemy(enemyNum).start.y := j
                        grid(i,j).start := true
                        new enemy3Q, upper(enemy3Q)+1
                        enemy3Q(upper(enemy3Q)).a := i
                        enemy3Q(upper(enemy3Q)).b := j
                    end if
                    if goalX >= grid(i,j).leftB.x and 
                        goalX < grid(i,j).rightB.x and
                        goalY >= grid(i,j).leftB.y and
                        goalY < grid(i,j).leftT.y then
                        grid(i,j).goal := true
                        grid(i,j).wall := false
                        enemy(enemyNum).goal.x := i
                        enemy(enemyNum).goal.y := j
                    end if
                end for
            end for
                enemy(enemyNum).initialize := false
        end if
    
    if enemy(enemyNum).goal.x not= enemy(enemyNum).start.x or 
            enemy(enemyNum).goal.y not= enemy(enemyNum).start.y then
        %Open first item in queue and remove from list
        enemy(enemyNum).openX := enemy3Q(lower(enemy3Q)).a
        enemy(enemyNum).openY := enemy3Q(lower(enemy3Q)).b
        new enemy3Searched, upper(enemy3Searched) + 1
        enemy3Searched(upper(enemy3Searched)) := enemy3Q(lower(enemy3Q))
        for i : 1 .. upper(enemy3Q)-1
            enemy3Q(i) := enemy3Q(i+1)
        end for
            new enemy3Q, upper(enemy3Q)-1
        %Add surrounding tiles to queue
        %Up Tile
        if enemy(enemyNum).openX+1 <= upper(grid,1) then
            if grid(enemy(enemyNum).openX+1,enemy(enemyNum).openY). wall = false and 
                    contains(enemy(enemyNum).openX+1,enemy(enemyNum).openY,3,'searched') = false and 
                    contains(enemy(enemyNum).openX+1,enemy(enemyNum).openY,3,'q') = false then
                new enemy3Q, upper(enemy3Q) + 1
                enemy3Q(upper(enemy3Q)).a := enemy(enemyNum).openX + 1
                enemy3Q(upper(enemy3Q)).b := enemy(enemyNum).openY
                grid(enemy(enemyNum).openX+1,enemy(enemyNum).openY).parent.enemy3.x := enemy(enemyNum).openX
                grid(enemy(enemyNum).openX+1,enemy(enemyNum).openY).parent.enemy3.y := enemy(enemyNum).openY
                enemy3Q(upper(enemy3Q)).fScore := round( 8*(abs(enemy(enemyNum).openX+1 - enemy(enemyNum).goal.x) + 
                abs(enemy(enemyNum).openY   - enemy(enemyNum).goal.y)) + 
                abs(enemy(enemyNum).openX+1 - enemy(enemyNum).start.x) + 
                abs(enemy(enemyNum).openY   - enemy(enemyNum).start.y))
            end if
        end if
        %Down Tile
        if enemy(enemyNum).openX-1 >= 1 then
            if grid(enemy(enemyNum).openX-1,enemy(enemyNum).openY). wall = false and contains(enemy(enemyNum).openX-1,enemy(enemyNum).openY,3,'searched') = false and contains(enemy(enemyNum).openX-1,enemy(enemyNum).openY,3,'q') = false then
                new enemy3Q, upper(enemy3Q) + 1
                enemy3Q(upper(enemy3Q)).a := enemy(enemyNum).openX - 1
                enemy3Q(upper(enemy3Q)).b := enemy(enemyNum).openY
                grid(enemy(enemyNum).openX-1,enemy(enemyNum).openY).parent.enemy3.x := enemy(enemyNum).openX
                grid(enemy(enemyNum).openX-1,enemy(enemyNum).openY).parent.enemy3.y := enemy(enemyNum).openY
                enemy3Q(upper(enemy3Q)).fScore := round( 8*(abs((enemy(enemyNum).openX-1)-enemy(enemyNum).goal.x) + abs(enemy(enemyNum).openY-enemy(enemyNum).goal.y)) + (abs((enemy(enemyNum).openX-1)-enemy(enemyNum).start.x) + abs(enemy(enemyNum).openY-enemy(enemyNum).start.y)))
            end if
        end if
        %Left Tile
        if enemy(enemyNum).openY+1 <= upper(grid,2) then
            if grid(enemy(enemyNum).openX,enemy(enemyNum).openY+1). wall = false and contains(enemy(enemyNum).openX,enemy(enemyNum).openY+1,3,'searched') = false and contains(enemy(enemyNum).openX,enemy(enemyNum).openY+1,3,'q') = false then
                new enemy3Q, upper(enemy3Q) + 1
                enemy3Q(upper(enemy3Q)).a := enemy(enemyNum).openX
                enemy3Q(upper(enemy3Q)).b := enemy(enemyNum).openY + 1
                grid(enemy(enemyNum).openX,enemy(enemyNum).openY+1).parent.enemy3.x := enemy(enemyNum).openX
                grid(enemy(enemyNum).openX,enemy(enemyNum).openY+1).parent.enemy3.y := enemy(enemyNum).openY
                enemy3Q(upper(enemy3Q)).fScore := round( 8*(abs(enemy(enemyNum).openX-enemy(enemyNum).goal.x) + abs((enemy(enemyNum).openY+1)-enemy(enemyNum).goal.y)) + (abs(enemy(enemyNum).openX-enemy(enemyNum).start.x) + abs((enemy(enemyNum).openY+1)-enemy(enemyNum).start.y)))
            end if
        end if
        %Right Tile
        if enemy(enemyNum).openY-1 >= lower(grid,1) then            
            if grid(enemy(enemyNum).openX,enemy(enemyNum).openY-1). wall = false and contains(enemy(enemyNum).openX,enemy(enemyNum).openY-1,3,'searched') = false and contains(enemy(enemyNum).openX,enemy(enemyNum).openY-1,3,'q') = false then
                new enemy3Q, upper(enemy3Q) + 1
                enemy3Q(upper(enemy3Q)).a := enemy(enemyNum).openX
                enemy3Q(upper(enemy3Q)).b := enemy(enemyNum).openY - 1
                grid(enemy(enemyNum).openX,enemy(enemyNum).openY-1).parent.enemy3.x := enemy(enemyNum).openX
                grid(enemy(enemyNum).openX,enemy(enemyNum).openY-1).parent.enemy3.y := enemy(enemyNum).openY
                enemy3Q(upper(enemy3Q)).fScore := round( 8*(abs(enemy(enemyNum).openX-enemy(enemyNum).goal.x) + abs((enemy(enemyNum).openY-1)-enemy(enemyNum).goal.y)) + (abs(enemy(enemyNum).openX-enemy(enemyNum).start.x) + abs((enemy(enemyNum).openY-1)-enemy(enemyNum).start.y)))
            end if
        end if
        if enemy(enemyNum).goal.x not= enemy(enemyNum).openX then
            %Sort
            if debug then
            for j : 1 .. upper(enemy3Q)-2
                locate(1,1)
                        put "enemy3Q ",j , " upper: ",upper(enemy3Q), " ",enemy3Q(j).a, " ",enemy3Q(j).b," "..
                        put enemy3Q(j).fScore
                        View.Update
                    end for
                end if
            var temp : arrayElement
            for a : 1 .. upper(enemy3Q)
                for i : 1 .. (upper(enemy3Q)-2)
                    if enemy3Q(i).fScore > enemy3Q(i+1).fScore then
                        temp := enemy3Q(i)
                        enemy3Q(i) := enemy3Q(i+1)
                        enemy3Q(i+1) := temp
                    end if
                end for
            end for
        end if
        if enemy(enemyNum).openX = enemy(enemyNum).goal.x and enemy(enemyNum).openY = enemy(enemyNum).goal.y then
            enemy(enemyNum).path(200).x := enemy(enemyNum).openX
            enemy(enemyNum).path(200).y := enemy(enemyNum).openY
            enemy(enemyNum).path(199).x := grid(enemy(enemyNum).openX,enemy(enemyNum).openY).parent.enemy3.x
            enemy(enemyNum).path(199).y := grid(enemy(enemyNum).openX,enemy(enemyNum).openY).parent.enemy3.y
            enemy(enemyNum).count := 198
            loop/*
                put "enemyNum ",enemyNum..
                put ' count' ,enemy(enemyNum).count..
                put  " x val: ",grid(enemy(enemyNum).path(enemy(enemyNum).count+1).x, enemy(enemyNum).path(enemy(enemyNum).count+1).y).leftB.x..
                put " y val: ",grid(enemy(enemyNum).path(enemy(enemyNum).count+1).x, enemy(enemyNum).path(enemy(enemyNum).count+1).y).leftB.y..
                put " Goal X: ", goalX..
                put " Y: ", goalY..
                put " Goal X: ",enemy(enemyNum).goal.x..
                put" Y: ",enemy(enemyNum).goal.y..
                put " current X: ",enemy(enemyNum).path(enemy(enemyNum).count+1).x..
                put " Y: ",enemy(enemyNum).path(enemy(enemyNum).count+1).y
                put "Grid at current X: ", grid(enemy(enemyNum).path(enemy(enemyNum).count+1).x,enemy(enemyNum).path(enemy(enemyNum).count+1).y).leftB.x..
                put "Y: ", grid(enemy(enemyNum).path(enemy(enemyNum).count+1).x,enemy(enemyNum).path(enemy(enemyNum).count+1).y).leftB.y..
                put contains(enemy(enemyNum).path(enemy(enemyNum).count+1).x,enemy(enemyNum).path(enemy(enemyNum).count+1).y,3,'searched')
                put "parent.x ",grid(enemy(enemyNum).path(enemy(enemyNum).count+1).x, enemy(enemyNum).path(enemy(enemyNum).count+1).y).parent.enemy3.x
                put "parent.y ",grid(enemy(enemyNum).path(enemy(enemyNum).count+1).x, enemy(enemyNum).path(enemy(enemyNum).count+1).y).parent.enemy3.y..
                
                View.Update
                delay(100)*/
                enemy(enemyNum).path(enemy(enemyNum).count).x := grid(enemy(enemyNum).path(enemy(enemyNum).count+1).x, enemy(enemyNum).path(enemy(enemyNum).count+1).y).parent.enemy3.x
                enemy(enemyNum).path(enemy(enemyNum).count).y := grid(enemy(enemyNum).path(enemy(enemyNum).count+1).x, enemy(enemyNum).path(enemy(enemyNum).count+1).y).parent.enemy3.y
                enemy(enemyNum).count -= 1
                if enemy(enemyNum).path(enemy(enemyNum).count+1).x = enemy(enemyNum).start.x and 
                        enemy(enemyNum).path(enemy(enemyNum).count+1).y = enemy(enemyNum).start.y then
                    exit
                end if
                if enemy(enemyNum).count = 1 then
                    resetAStar(enemyNum)
                    exit
                end if
            end loop
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
    elsif enemyNum = 4 then
        if enemy(enemyNum).initialize then
            for i : 1 .. 60
                for j : 1 .. 53
                    if startX >= grid(i,j).leftB.x and 
                            startX < grid(i,j).rightB.x and 
                            startY >= grid(i,j).leftB.y and 
                            startY < grid(i,j).leftT.y then
                        enemy(enemyNum).start.x := i
                        enemy(enemyNum).start.y := j
                        grid(i,j).start := true
                        new enemy4Q, upper(enemy4Q)+1
                        enemy4Q(upper(enemy4Q)).a := i
                        enemy4Q(upper(enemy4Q)).b := j
                    end if
                    if goalX >= grid(i,j).leftB.x and 
                        goalX < grid(i,j).rightB.x and
                        goalY >= grid(i,j).leftB.y and
                        goalY < grid(i,j).leftT.y then
                        grid(i,j).goal := true
                        grid(i,j).wall := false
                        enemy(enemyNum).goal.x := i
                        enemy(enemyNum).goal.y := j
                    end if
                end for
            end for
                enemy(enemyNum).initialize := false
        end if
    
    if enemy(enemyNum).goal.x not= enemy(enemyNum).start.x or 
            enemy(enemyNum).goal.y not= enemy(enemyNum).start.y then
        %Open first item in queue and remove from list
        if debug then
            put enemy4Q(lower(enemy4Q)).a
        end if
        enemy(enemyNum).openX := enemy4Q(lower(enemy4Q)).a
        enemy(enemyNum).openY := enemy4Q(lower(enemy4Q)).b
        new enemy4Searched, upper(enemy4Searched) + 1
        enemy4Searched(upper(enemy4Searched)) := enemy4Q(lower(enemy4Q))
        for i : 1 .. upper(enemy4Q)-1
            enemy4Q(i) := enemy4Q(i+1)
        end for
            new enemy4Q, upper(enemy4Q)-1
        %Add surrounding tiles to queue
        %Up Tile
        if enemy(enemyNum).openX+1 <= upper(grid,1) then
            if grid(enemy(enemyNum).openX+1,enemy(enemyNum).openY). wall = false and 
                    contains(enemy(enemyNum).openX+1,enemy(enemyNum).openY,4,'searched') = false and 
                    contains(enemy(enemyNum).openX+1,enemy(enemyNum).openY,4,'q') = false then
                new enemy4Q, upper(enemy4Q) + 1
                enemy4Q(upper(enemy4Q)).a := enemy(enemyNum).openX + 1
                enemy4Q(upper(enemy4Q)).b := enemy(enemyNum).openY
                grid(enemy(enemyNum).openX+1,enemy(enemyNum).openY).parent.enemy4.x := enemy(enemyNum).openX
                grid(enemy(enemyNum).openX+1,enemy(enemyNum).openY).parent.enemy4.y := enemy(enemyNum).openY
                enemy4Q(upper(enemy4Q)).fScore := round( 8*(abs(enemy(enemyNum).openX+1 - enemy(enemyNum).goal.x) +abs(enemy(enemyNum).openY - enemy(enemyNum).goal.y)) + abs(enemy(enemyNum).openX+1 - enemy(enemyNum).start.x) + abs(enemy(enemyNum).openY - enemy(enemyNum).start.y))
                enemy4Q(upper(enemy4Q)).direction := 'up'
            end if
        end if
        %Down Tile
        if enemy(enemyNum).openX-1 >= 1 then
            if grid(enemy(enemyNum).openX-1,enemy(enemyNum).openY). wall = false and contains(enemy(enemyNum).openX-1,enemy(enemyNum).openY,4,'searched') = false and contains(enemy(enemyNum).openX-1,enemy(enemyNum).openY,4,'q') = false then
                new enemy4Q, upper(enemy4Q) + 1
                enemy4Q(upper(enemy4Q)).a := enemy(enemyNum).openX - 1
                enemy4Q(upper(enemy4Q)).b := enemy(enemyNum).openY
                grid(enemy(enemyNum).openX-1,enemy(enemyNum).openY).parent.enemy4.x := enemy(enemyNum).openX
                grid(enemy(enemyNum).openX-1,enemy(enemyNum).openY).parent.enemy4.y := enemy(enemyNum).openY
                enemy4Q(upper(enemy4Q)).fScore := round( 8*(abs((enemy(enemyNum).openX-1)-enemy(enemyNum).goal.x) + abs(enemy(enemyNum).openY-enemy(enemyNum).goal.y)) + (abs((enemy(enemyNum).openX-1)-enemy(enemyNum).start.x) + abs(enemy(enemyNum).openY-enemy(enemyNum).start.y)))
                enemy4Q(upper(enemy4Q)).direction := 'down'
            end if
        end if
        %Left Tile
        if enemy(enemyNum).openY+1 <= upper(grid,2) then
            if grid(enemy(enemyNum).openX,enemy(enemyNum).openY+1). wall = false and contains(enemy(enemyNum).openX,enemy(enemyNum).openY+1,4,'searched') = false and contains(enemy(enemyNum).openX,enemy(enemyNum).openY+1,4,'q') = false then
                new enemy4Q, upper(enemy4Q) + 1
                enemy4Q(upper(enemy4Q)).a := enemy(enemyNum).openX
                enemy4Q(upper(enemy4Q)).b := enemy(enemyNum).openY + 1
                grid(enemy(enemyNum).openX,enemy(enemyNum).openY+1).parent.enemy4.x := enemy(enemyNum).openX
                grid(enemy(enemyNum).openX,enemy(enemyNum).openY+1).parent.enemy4.y := enemy(enemyNum).openY
                enemy4Q(upper(enemy4Q)).fScore := round( 8*(abs(enemy(enemyNum).openX-enemy(enemyNum).goal.x) + abs((enemy(enemyNum).openY+1)-enemy(enemyNum).goal.y)) + (abs(enemy(enemyNum).openX-enemy(enemyNum).start.x) + abs((enemy(enemyNum).openY+1)-enemy(enemyNum).start.y)))
                enemy4Q(upper(enemy4Q)).direction := 'left'
            end if
        end if
        %Right Tile
        if enemy(enemyNum).openY-1 >= lower(grid,1) then            
            if grid(enemy(enemyNum).openX,enemy(enemyNum).openY-1). wall = false and contains(enemy(enemyNum).openX,enemy(enemyNum).openY-1,4,'searched') = false and contains(enemy(enemyNum).openX,enemy(enemyNum).openY-1,4,'q') = false then
                new enemy4Q, upper(enemy4Q) + 1
                enemy4Q(upper(enemy4Q)).a := enemy(enemyNum).openX
                enemy4Q(upper(enemy4Q)).b := enemy(enemyNum).openY - 1
                grid(enemy(enemyNum).openX,enemy(enemyNum).openY-1).parent.enemy4.x := enemy(enemyNum).openX
                grid(enemy(enemyNum).openX,enemy(enemyNum).openY-1).parent.enemy4.y := enemy(enemyNum).openY
                enemy4Q(upper(enemy4Q)).fScore := round( 8*(abs(enemy(enemyNum).openX-enemy(enemyNum).goal.x) + abs((enemy(enemyNum).openY-1)-enemy(enemyNum).goal.y)) + (abs(enemy(enemyNum).openX-enemy(enemyNum).start.x) + abs((enemy(enemyNum).openY-1)-enemy(enemyNum).start.y)))
                enemy4Q(upper(enemy4Q)).direction := 'right'
            end if
        end if
        if enemy(enemyNum).goal.x not= enemy(enemyNum).openX then
            %Sort
            if debug then
            for j : 1 .. upper(enemy4Q)-1
                        put "enemy4 ",j..
                        put " upper: ",upper(enemy4Q)..
                       put " ",enemy4Q(j).a, " ",enemy4Q(j).b..
                       put "direction: ",enemy4Q(j).direction
                        put " fScore ",enemy4Q(j).fScore
                        View.Update
                    end for
            end if
            var temp : arrayElement
            for a : 1 .. upper(enemy4Q)
                for i : 1 .. (upper(enemy4Q)-1)
                    if enemy4Q(i).fScore > enemy4Q(i+1).fScore then
                        temp := enemy4Q(i)
                        enemy4Q(i) := enemy4Q(i+1)
                        enemy4Q(i+1) := temp
                    end if
                end for
            end for
        end if
        if enemy(enemyNum).openX = enemy(enemyNum).goal.x and enemy(enemyNum).openY = enemy(enemyNum).goal.y then
            enemy(enemyNum).path(200).x := enemy(enemyNum).openX
            enemy(enemyNum).path(200).y := enemy(enemyNum).openY
            enemy(enemyNum).path(199).x := grid(enemy(enemyNum).openX,enemy(enemyNum).openY).parent.enemy4.x
            enemy(enemyNum).path(199).y := grid(enemy(enemyNum).openX,enemy(enemyNum).openY).parent.enemy4.y
            enemy(enemyNum).count := 198
            loop/*
                put "enemyNum ",enemyNum..
                put ' count' ,enemy(enemyNum).count..
                put  " x val: ",grid(enemy(enemyNum).path(enemy(enemyNum).count+1).x, enemy(enemyNum).path(enemy(enemyNum).count+1).y).leftB.x..
                put " y val: ",grid(enemy(enemyNum).path(enemy(enemyNum).count+1).x, enemy(enemyNum).path(enemy(enemyNum).count+1).y).leftB.y..
                put " Goal X: ", goalX..
                put " Y: ", goalY..
                put " Goal X: ",enemy(enemyNum).goal.x..
                put" Y: ",enemy(enemyNum).goal.y..
                put " current X: ",enemy(enemyNum).path(enemy(enemyNum).count+1).x..
                put " Y: ",enemy(enemyNum).path(enemy(enemyNum).count+1).y
                put "Grid at current X: ", grid(enemy(enemyNum).path(enemy(enemyNum).count+1).x,enemy(enemyNum).path(enemy(enemyNum).count+1).y).leftB.x..
                put "Y: ", grid(enemy(enemyNum).path(enemy(enemyNum).count+1).x,enemy(enemyNum).path(enemy(enemyNum).count+1).y).leftB.y..
                put contains(enemy(enemyNum).path(enemy(enemyNum).count+1).x,enemy(enemyNum).path(enemy(enemyNum).count+1).y,4,'searched')
                View.Update
                delay(100)*/
                enemy(enemyNum).path(enemy(enemyNum).count).x := grid(enemy(enemyNum).path(enemy(enemyNum).count+1).x, enemy(enemyNum).path(enemy(enemyNum).count+1).y).parent.enemy4.x
                enemy(enemyNum).path(enemy(enemyNum).count).y := grid(enemy(enemyNum).path(enemy(enemyNum).count+1).x, enemy(enemyNum).path(enemy(enemyNum).count+1).y).parent.enemy4.      y
                enemy(enemyNum).count -= 1
                if enemy(enemyNum).path(enemy(enemyNum).count+1).x = enemy(enemyNum).start.x and 
                        enemy(enemyNum).path(enemy(enemyNum).count+1).y = enemy(enemyNum).start.y then
                    exit
                end if
            end loop
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
    end if
end aStar

procedure playerAnimate
    Sprite.SetPosition (player, maxx div 2, maxy div 2, true)
    Sprite.Show (player)
    if Time.Elapsed - lastFrame > 100 then
        lastFrame := Time.Elapsed
        if whatAngle(maxx div 2,maxy div 2) < 22.5 or whatAngle(maxx div 2,maxy div 2) >= 337.5 then
            Sprite.ChangePic(player, player_walk_frames_0(playerFrame))
            playerDirection := 1 %Facing Right
        elsif whatAngle(maxx div 2,maxy div 2) >= 22.5 and whatAngle(maxx div 2,maxy div 2) < 67.5 then
            Sprite.ChangePic(player, player_walk_frames_45(playerFrame))
            playerDirection := 2 % Facing Right and Up
        elsif whatAngle(maxx div 2,maxy div 2) >= 67.5 and whatAngle(maxx div 2,maxy div 2) < 112.5 then
            Sprite.ChangePic(player, player_walk_frames_90(playerFrame))
            playerDirection := 3 % Facing Up
        elsif whatAngle(maxx div 2,maxy div 2) >= 112.5 and whatAngle(maxx div 2,maxy div 2) < 157.5 then
            Sprite.ChangePic(player, player_walk_frames_135(playerFrame))
            playerDirection := 4 % Facing Left and Up
        elsif whatAngle(maxx div 2,maxy div 2) >= 157.5 and whatAngle(maxx div 2,maxy div 2) < 202.5 then
            Sprite.ChangePic(player, player_walk_frames_180(playerFrame))
            playerDirection:=  5 % Facing Left
        elsif whatAngle(maxx div 2,maxy div 2) >= 202.5 and whatAngle(maxx div 2,maxy div 2) < 247.5 then
            Sprite.ChangePic(player, player_walk_frames_225(playerFrame))
            playerDirection := 6 % Facing Left and Down
        elsif whatAngle(maxx div 2,maxy div 2) >= 247.5 and whatAngle(maxx div 2,maxy div 2) < 292.5 then
            Sprite.ChangePic(player, player_walk_frames_270(playerFrame))
            playerDirection := 7 % Facing Down
        elsif whatAngle(maxx div 2,maxy div 2) >= 292.5 and whatAngle(maxx div 2,maxy div 2) < 337.5 then
            Sprite.ChangePic(player, player_walk_frames_315(playerFrame))
            playerDirection := 8 % Facing Right and Down
        end if
        
        if playerFrame = player_num_frames then
            playerFrame := 0
        end if
        playerFrame += 1
    end if
end playerAnimate

%Sprite.SetPosition(enemySPR,enemy(1).x,enemy(1).y,true)
for i : 1 .. num_enemies
    enemy(i).moveDirection := "null"
end for

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
                Sprite.Animate(enemy(enemyNum).SPR,enemy_walk_frames_0(enemyFrame),enemy(enemyNum).x+camera.x,enemy(enemyNum).y+camera.y,true)
                enemy(enemyNum).x += 2
            else
                enemy(enemyNum).moveDirection := "null"
            end if
        elsif enemy(enemyNum).moveDirection = "down" then
            if collisionDetect(enemy(enemyNum).x+camera.x,enemy(enemyNum).y+camera.y-20,true) = false then
                Sprite.Animate(enemy(enemyNum).SPR,enemy_walk_frames_270(enemyFrame),enemy(enemyNum).x+camera.x,enemy(enemyNum).y+camera.y,true)
                enemy(enemyNum).y -= 2
            else
                enemy(enemyNum).moveDirection := "null"
            end if
        elsif enemy(enemyNum).moveDirection = "up" then
            if collisionDetect(enemy(enemyNum).x+camera.x,enemy(enemyNum).y+camera.y+20,true) = false then
                Sprite.Animate(enemy(enemyNum).SPR,enemy_walk_frames_90(enemyFrame),enemy(enemyNum).x+camera.x,enemy(enemyNum).y+camera.y,true)
                enemy(enemyNum).y += 2
            else
                enemy(enemyNum).moveDirection := "null"
            end if
        elsif enemy(enemyNum).moveDirection = "left" then
            if collisionDetect(enemy(enemyNum).x+camera.x-20,enemy(enemyNum).y+camera.y,true) = false then
                Sprite.Animate(enemy(enemyNum).SPR,enemy_walk_frames_180(enemyFrame),enemy(enemyNum).x+camera.x,enemy(enemyNum).y+camera.y,true)
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
        Sprite.SetHeight(enemy(enemyNum).SPR,0)
        Sprite.Animate(enemy(enemyNum).SPR,eKill1IMG,enemy(enemyNum).x+camera.x,enemy(enemyNum).y+camera.y,true)
    end if
end AISearch

proc sightCheck(enemyNum : int)
    if (enemy(enemyNum).enemyRoom = playerRoom) or 
    %Block for carbon room
        (enemy(enemyNum).enemyRoom = "carbon" and playerRoom = "CARBON2wood") or 
        (enemy(enemyNum).enemyRoom = "carbon" and playerRoom = "lvh2CARBON") or 
        (enemy(enemyNum).enemyRoom = "CARBON2wood" and playerRoom = "carbon") or 
        (enemy(enemyNum).enemyRoom = "lvh2CARBON" and playerRoom = "carbon") or
        (enemy(enemyNum).enemyRoom = "lvh2CARBON" and playerRoom = "CARBON2wood") or 
        (enemy(enemyNum).enemyRoom = "CARBON2wood" and playerRoom = "lvh2CARBON") or 
        (enemy(enemyNum).enemyRoom = "CARBON2wood" and playerRoom = "carbon2WOOD") or 
        (enemy(enemyNum).enemyRoom = "carbon2WOOD" and playerRoom = "CARBON2wood") or 
        (enemy(enemyNum).enemyRoom = "lvh2CARBON" and playerRoom = "LVH2carbon") or 
        (enemy(enemyNum).enemyRoom = "LVH2carbon" and playerRoom = "lvh2CARBON") or 
    %Block for Long vert Hall
        (enemy(enemyNum).enemyRoom = "longVertHall" and playerRoom = "LVH2red") or 
        (enemy(enemyNum).enemyRoom = "longVertHall" and playerRoom = "LVH2wood") or 
        (enemy(enemyNum).enemyRoom = "longVertHall" and playerRoom = "LVH2carbon") or 
        (enemy(enemyNum).enemyRoom = "longVertHall" and playerRoom = "intLVH&LHH") or 
        (enemy(enemyNum).enemyRoom = "LVH2red" and playerRoom = "longVertHall") or
        (enemy(enemyNum).enemyRoom = "LVH2red" and playerRoom = "LVH2wood") or
        (enemy(enemyNum).enemyRoom = "LVH2red" and playerRoom = "LVH2carbon") or
        (enemy(enemyNum).enemyRoom = "LVH2red" and playerRoom = "intLVH&LHH") or
        (enemy(enemyNum).enemyRoom = "LVH2carbon" and playerRoom = "longVertHall") or
        (enemy(enemyNum).enemyRoom = "LVH2carbon" and playerRoom = "LVH2wood") or
        (enemy(enemyNum).enemyRoom = "LVH2carbon" and playerRoom = "LVH2carbon") or
        (enemy(enemyNum).enemyRoom = "LVH2carbon" and playerRoom = "intLVH&LHH") or
        (enemy(enemyNum).enemyRoom = "LVH2wood" and playerRoom = "longVertHall") or
        (enemy(enemyNum).enemyRoom = "LVH2wood" and playerRoom = "LVH2carbon") or
        (enemy(enemyNum).enemyRoom = "LVH2wood" and playerRoom = "intLVH&LHH") or
        (enemy(enemyNum).enemyRoom = "LVH2wood" and playerRoom = "LVH2red") or
        (enemy(enemyNum).enemyRoom = "intLVH&LHH" and playerRoom = "LVH2wood") or
        (enemy(enemyNum).enemyRoom = "intLVH&LHH" and playerRoom = "LVH2red") or
        (enemy(enemyNum).enemyRoom = "intLVH&LHH" and playerRoom = "LVH2carbon") or
        (enemy(enemyNum).enemyRoom = "intLVH&LHH" and playerRoom = "longVertHall") or
    %Block for Wood room
        (enemy(enemyNum).enemyRoom = "wood" and playerRoom = "WOOD2svh") or
        (enemy(enemyNum).enemyRoom = "wood" and playerRoom = "carbon2WOOD") or
        (enemy(enemyNum).enemyRoom = "wood" and playerRoom = "lvh2WOOD") or
        (enemy(enemyNum).enemyRoom = "WOOD2svh" and playerRoom = "wood2SVH") or
        (enemy(enemyNum).enemyRoom = "wood2SVH" and playerRoom = "WOOD2svh") or
        (enemy(enemyNum).enemyRoom = "carbon2WOOD" and playerRoom = "CARBON2wood") or
        (enemy(enemyNum).enemyRoom = "CARBON2wood" and playerRoom = "carbon2WOOD") or
        (enemy(enemyNum).enemyRoom = "WOOD2svh" and playerRoom = "wood") or
        (enemy(enemyNum).enemyRoom = "WOOD2svh" and playerRoom = "carbon2WOOD") or
        (enemy(enemyNum).enemyRoom = "WOOD2svh" and playerRoom = "lvh2WOOD") or
        (enemy(enemyNum).enemyRoom = "carbon2WOOD" and playerRoom = "wood") or
        (enemy(enemyNum).enemyRoom = "carbon2WOOD" and playerRoom = "WOOD2svh") or
        (enemy(enemyNum).enemyRoom = "carbon2WOOD" and playerRoom = "lvh2WOOD") or
        (enemy(enemyNum).enemyRoom = "lvh2WOOD" and playerRoom = "wood") or
        (enemy(enemyNum).enemyRoom = "lvh2WOOD" and playerRoom = "WOOD2svh") or
        (enemy(enemyNum).enemyRoom = "lvh2WOOD" and playerRoom = "carbon2WOOD") or
    %Block for Long horizontal hall
        (enemy(enemyNum).enemyRoom = "longHorzHall" and playerRoom = "intLVH&LHH") or
        (enemy(enemyNum).enemyRoom = "longHorzHall" and playerRoom = "intSVH&LHH") or
        (enemy(enemyNum).enemyRoom = "longHorzHall" and playerRoom = "PURPLE2lhh") or
        (enemy(enemyNum).enemyRoom = "intLVH&LHH" and playerRoom = "longHorzHall") or
        (enemy(enemyNum).enemyRoom = "intLVH&LHH" and playerRoom = "intSVH&LHH") or
        (enemy(enemyNum).enemyRoom = "intLVH&LHH" and playerRoom = "PURPLE2lhh") or
        (enemy(enemyNum).enemyRoom = "intSVH&LHH" and playerRoom = "longHorzHall") or
        (enemy(enemyNum).enemyRoom = "intSVH&LHH" and playerRoom = "PURPLE2lhh") or
        (enemy(enemyNum).enemyRoom = "intSVH&LHH" and playerRoom = "intLVH&LHH") or
        (enemy(enemyNum).enemyRoom = "purple2LHH" and playerRoom = "longHorzHall") or
        (enemy(enemyNum).enemyRoom = "purple2LHH" and playerRoom = "intLVH&LHH") or
        (enemy(enemyNum).enemyRoom = "purple2LHH" and playerRoom = "intSVH&LHH") or
    %Block for purple room
        (enemy(enemyNum).enemyRoom = "PurpleUpper" and playerRoom = "intPurple") or
        (enemy(enemyNum).enemyRoom = "PurpleUpper" and playerRoom = "red2PURPLE") or
        (enemy(enemyNum).enemyRoom = "PurpleUpper" and playerRoom = "PURPLE2lhh") or
        (enemy(enemyNum).enemyRoom = "intPurple" and playerRoom = "PurpleUpper") or
        (enemy(enemyNum).enemyRoom = "intPurple" and playerRoom = "PurpleLower") or
        (enemy(enemyNum).enemyRoom = "intPurple" and playerRoom = "PURPLE2lhh") or
        (enemy(enemyNum).enemyRoom = "intPurple" and playerRoom = "red2PURPLE") or
        (enemy(enemyNum).enemyRoom = "PurpleLower" and playerRoom = "intPurple") or
        (enemy(enemyNum).enemyRoom = "PurpleLower" and playerRoom = "PURPLE2lhh") or
        (enemy(enemyNum).enemyRoom = "PURPLE2red" and playerRoom = "PurpleUpper") or
        (enemy(enemyNum).enemyRoom = "PURPLE2red" and playerRoom = "intPurple") or
        (enemy(enemyNum).enemyRoom = "PURPLE2lhh" and playerRoom = "intPurple") or
        (enemy(enemyNum).enemyRoom = "PURPLE2lhh" and playerRoom = "PurpleUpper") or
        (enemy(enemyNum).enemyRoom = "PURPLE2lhh" and playerRoom = "PurpleLower") or
        (enemy(enemyNum).enemyRoom = "PURPLE2lhh" and playerRoom = "red2PURPLE") or
        (enemy(enemyNum).enemyRoom = "PURPLE2lhh" and playerRoom = "purple2LHH") or
        (enemy(enemyNum).enemyRoom = "LHH2purple" and playerRoom = "PURPLE2lhh") or
    %Block for red room
        (enemy(enemyNum).enemyRoom = "red" and playerRoom = "RED2purple") or
        (enemy(enemyNum).enemyRoom = "red" and playerRoom = "lvh2RED") or
        (enemy(enemyNum).enemyRoom = "RED2purple" and playerRoom = "red") or
        (enemy(enemyNum).enemyRoom = "RED2purple" and playerRoom = "lvh2RED") or
        (enemy(enemyNum).enemyRoom = "lvh2RED" and playerRoom = "red") or
        (enemy(enemyNum).enemyRoom = "lvh2RED" and playerRoom = "RED2purple") or
        (enemy(enemyNum).enemyRoom = "lvh2RED" and playerRoom = "LVH2red") or
        (enemy(enemyNum).enemyRoom = "LVH2red" and playerRoom = "lvh2RED") or
        (enemy(enemyNum).enemyRoom = "red2PURPLE" and playerRoom = "RED2purple") or
        (enemy(enemyNum).enemyRoom = "RED2purple" and playerRoom = "red2PURPLE") or
    %Block for Short vert Hall
        (enemy(enemyNum).enemyRoom = "shortVertHall" and playerRoom = "intSVH&LHH") or
        (enemy(enemyNum).enemyRoom = "shortVertHall" and playerRoom = "wood2SVH") or
        (enemy(enemyNum).enemyRoom = "intSVH&LHH" and playerRoom = "shortVertHall") or
        (enemy(enemyNum).enemyRoom = "intSVH&LHH" and playerRoom = "wood2SVH") or
        (enemy(enemyNum).enemyRoom = "wood2SVH" and playerRoom = "shortVertHall") or
        (enemy(enemyNum).enemyRoom = "wood2SVH" and playerRoom = "intSVH&LHH")
        then
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
    if enemy(enemyNum).x - grid(enemy(enemyNum).path(enemy(enemyNum).count).x,enemy(enemyNum).path(enemy(enemyNum).count).y).leftB.x < -1 then
        enemy(enemyNum).x += 2
        enemy(enemyNum).moveDirection := "right"
        Sprite.Animate(enemy(enemyNum).SPR,enemy_walk_frames_0(enemyFrame),enemy(enemyNum).x+camera.x,enemy(enemyNum).y+camera.y,true)
    elsif enemy(enemyNum).x - grid(enemy(enemyNum).path(enemy(enemyNum).count).x,enemy(enemyNum).path(enemy(enemyNum).count).y).leftB.x > 1 then
        enemy(enemyNum).x -= 2
        enemy(enemyNum).moveDirection := "left"
        Sprite.Animate(enemy(enemyNum).SPR,enemy_walk_frames_180(enemyFrame),enemy(enemyNum).x+camera.x,enemy(enemyNum).y+camera.y,true)
    elsif enemy(enemyNum).y - grid(enemy(enemyNum).path(enemy(enemyNum).count).x,enemy(enemyNum).path(enemy(enemyNum).count).y).leftB.y < -1 then
        enemy(enemyNum).y += 2
        enemy(enemyNum).moveDirection := "up"
        Sprite.Animate(enemy(enemyNum).SPR,enemy_walk_frames_90(enemyFrame),enemy(enemyNum).x+camera.x,enemy(enemyNum).y+camera.y,true)
    elsif enemy(enemyNum).y - grid(enemy(enemyNum).path(enemy(enemyNum).count).x,enemy(enemyNum).path(enemy(enemyNum).count).y).leftB.y > 1 then
        enemy(enemyNum).y -= 2
        enemy(enemyNum).moveDirection := "down"
        Sprite.Animate(enemy(enemyNum).SPR,enemy_walk_frames_270(enemyFrame),enemy(enemyNum).x+camera.x,enemy(enemyNum).y+camera.y,true)
    end if
    
    if enemy(enemyNum).x - grid(enemy(enemyNum).path(enemy(enemyNum).count).x,enemy(enemyNum).path(enemy(enemyNum).count).y).leftB.x >= -1 and enemy(enemyNum).x - grid(enemy(enemyNum).path(enemy(enemyNum).count).x,enemy(enemyNum).path(enemy(enemyNum).count).y).leftB.x <= 1 and enemy(enemyNum).y - grid(enemy(enemyNum).path(enemy(enemyNum).count).x,enemy(enemyNum).path(enemy(enemyNum).count).y).leftB.y >= -1 and enemy(enemyNum).y - grid(enemy(enemyNum).path(enemy(enemyNum).count).x,enemy(enemyNum).path(enemy(enemyNum).count).y).leftB.y <= 1 then
        enemy(enemyNum).count += 1
    end if
    if enemy(enemyNum).count > 200 then 
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
    if (key(' ') or button = 1) and (Time.Elapsed - shootDelay) > 1000 then
        shootDelay := Time.Elapsed
        shoot := true
        resetAStar(1)
        resetAStar(2)
        resetAStar(3)
        resetAStar(4)
        fork play_audio("Game")
    end if
    if shoot then
        if shootDirection not= playerDirection and shootDirection not= 0 then
            playerDirection := shootDirection
        end if
        Sprite.Show(bulletSPR)
        if playerDirection = 1 then
            shootDirection := 1
            bulletPos(1).x += 40
            %Sprite.ChangePic(bulletSPR,bullet_img(1))
            Sprite.Animate(bulletSPR,bullet_img(1),bulletPos(1).x,bulletPos(1).y,true)
            if bulletPos(1).x > maxx + 50 or collisionDetect(bulletPos(1).x+10,bulletPos(1).y,false) or collisionDetect(bulletPos(1).x+20 ,bulletPos(1).y,false) then
                shoot:= false
                bulletPos(1).x := maxx div 2
                Sprite.Hide(bulletSPR)
                shootDirection := 0
            end if
        elsif playerDirection = 2 then
            shootDirection := 2
            bulletPos(1).y += 40
            bulletPos(1).x += 40
            Sprite.Animate(bulletSPR,bullet_img(2),bulletPos(1).x,bulletPos(1).y,true)
            if bulletPos(1).y > maxy or collisionDetect(bulletPos(1).x-20,bulletPos(1).y,false) or collisionDetect(bulletPos(1).x,bulletPos(1).y,false)then
                shoot:= false
                bulletPos(1).y := maxy div 2
                bulletPos(1).x := maxx div 2
                Sprite.Hide(bulletSPR)
                shootDirection := 0
            end if
        elsif playerDirection = 3 then
            shootDirection := 3
            bulletPos(1).y += 40
            %Sprite.ChangePic(bulletSPR,bullet_img(3))
            Sprite.Animate(bulletSPR,bullet_img(3),bulletPos(1).x,bulletPos(1).y,true)
            if bulletPos(1).y > maxy or collisionDetect(bulletPos(1).x,bulletPos(1).y-50,false) then
                shoot:= false
                bulletPos(1).y := maxy div 2
                Sprite.Hide(bulletSPR)
                shootDirection := 0
            end if
        elsif playerDirection = 4 then
            shootDirection := 4
            bulletPos(1).x -= 40
            bulletPos(1).y += 40
            %Sprite.ChangePic(bulletSPR,bullet_img(4))
            Sprite.Animate(bulletSPR,bullet_img(4),bulletPos(1).x,bulletPos(1).y,true)
            if bulletPos(1).x < -20 or collisionDetect(bulletPos(1).x+20,bulletPos(1).y-50,false) or collisionDetect(bulletPos(1).x,bulletPos(1).y,false)then
                shoot:= false
                bulletPos(1).x := maxx div 2
                bulletPos(1).y := maxy div 2
                Sprite.Hide(bulletSPR)
                shootDirection := 0
            end if 
        elsif playerDirection = 5 then
            shootDirection := 5
            bulletPos(1).x -= 40
            %Sprite.ChangePic(bulletSPR,bullet_img(5))
            Sprite.Animate(bulletSPR,bullet_img(5),bulletPos(1).x,bulletPos(1).y,true)
            if bulletPos(1).x < -20 or collisionDetect(bulletPos(1).x-20,bulletPos(1).y,false) or collisionDetect(bulletPos(1).x-5,bulletPos(1).y,false) then
                shoot:= false
                bulletPos(1).x := maxx div 2
                Sprite.Hide(bulletSPR)
                shootDirection := 0
            end if 
        elsif playerDirection = 6 then
            shootDirection := 6
            bulletPos(1).x -= 40
            bulletPos(1).y -= 40
            %Sprite.ChangePic(bulletSPR,bullet_img(6))
            Sprite.Animate(bulletSPR,bullet_img(6),bulletPos(1).x,bulletPos(1).y,true)
            if bulletPos(1).x < -20 or collisionDetect(bulletPos(1).x-20,bulletPos(1).y,false) or collisionDetect(bulletPos(1).x-5,bulletPos(1).y,false) then
                shoot:= false
                bulletPos(1).x := maxx div 2
                bulletPos(1).y := maxy div 2
                Sprite.Hide(bulletSPR)
                shootDirection := 0
            end if 
        elsif playerDirection = 7 then
            shootDirection := 7
            bulletPos(1).y -= 40
            %Sprite.ChangePic(bulletSPR,bullet_img(7))
            Sprite.Animate(bulletSPR,bullet_img(7),bulletPos(1).x,bulletPos(1).y,true)
            if bulletPos(1).y < -20 or collisionDetect(bulletPos(1).x-20,bulletPos(1).y,false) or collisionDetect(bulletPos(1).x-5,bulletPos(1).y,false) then
                shoot:= false
                bulletPos(1).y := maxy div 2
                Sprite.Hide(bulletSPR)
                shootDirection := 0
            end if 
        elsif playerDirection = 8 then
            shootDirection := 8
            bulletPos(1).y -= 40
            bulletPos(1).x += 40
            %Sprite.ChangePic(bulletSPR,bullet_img(8))
            Sprite.Animate(bulletSPR,bullet_img(8),bulletPos(1).x,bulletPos(1).y,true)
            if bulletPos(1).x < -20 or collisionDetect(bulletPos(1).x-20,bulletPos(1).y,false) or collisionDetect(bulletPos(1).x-5,bulletPos(1).y,false) then
                shoot:= false
                bulletPos(1).x := maxx div 2
                bulletPos(1).y := maxy div 2
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
    elsif x >= 1427+camera.x  and x <= 1775+camera.x and y >= 1577+camera.y and y <= 1655+camera.y then
        result "LVH2wood"
    elsif x >= 755+camera.x and x <= 1426+camera.x and y >= 1577+camera.y and y <= 1655+camera.y then
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
    elsif x >= 1413+camera.x and x <= 1776+camera.x and y >= 288+camera.y  and y <= 2175+camera.y then
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
        enemy(enemyNum).bulletPos.x := enemy(enemyNum).x
        enemy(enemyNum).bulletPos.y := enemy(enemyNum).y
        enemy(enemyNum).targetLocation.x := (maxx div 2 - camera.x)
        enemy(enemyNum).targetLocation.y := (maxy div 2 - camera.y)
        enemy(enemyNum).selfLocation.x := enemy(enemyNum).x
        enemy(enemyNum).selfLocation.y := enemy(enemyNum).y
        enemy(enemyNum).speed := 0.1
    else
        %If the bullet is fired incread x and y pos
        enemy(enemyNum).shootDelay := 0
        enemy(enemyNum).bulletPos.x -= round((enemy(enemyNum).selfLocation.x - enemy(enemyNum).targetLocation.x) * enemy(enemyNum).speed) %div 2
        enemy(enemyNum).bulletPos.y -= round((enemy(enemyNum).selfLocation.y - enemy(enemyNum).targetLocation.y) * enemy(enemyNum).speed) %div 2
        if abs(round((enemy(enemyNum).selfLocation.x - enemy(enemyNum).targetLocation.x) * enemy(enemyNum).speed) div 2) > 35 or 
                abs(round((enemy(enemyNum).selfLocation.y - enemy(enemyNum).targetLocation.y) * enemy(enemyNum).speed) div 2) > 35 then
            enemy(enemyNum).speed -= 0.1
        end if
        enemy(enemyNum).speed += 0.001
        Sprite.Show(enemy(enemyNum).bullet)
    end if
    %Animate Bullet
    if whatAngleEnemy(enemy(enemyNum).x,enemy(enemyNum).y) >= 315 or whatAngleEnemy(enemy(enemyNum).x,enemy(enemyNum).y) < 45 then
        Sprite.Animate(enemy(enemyNum).SPR,enemy_walk_frames_0(enemyFrame),enemy(enemyNum).x+camera.x,enemy(enemyNum).y+camera.y,true)
     elsif whatAngleEnemy(enemy(enemyNum).x,enemy(enemyNum).y) >= 45 and whatAngleEnemy(enemy(enemyNum).x,enemy(enemyNum).y) < 135 then
        Sprite.Animate(enemy(enemyNum).SPR,enemy_walk_frames_90(enemyFrame),enemy(enemyNum).x+camera.x,enemy(enemyNum).y+camera.y,true)
     elsif whatAngleEnemy(enemy(enemyNum).x,enemy(enemyNum).y) >=135 and whatAngleEnemy(enemy(enemyNum).x,enemy(enemyNum).y) < 225 then
        Sprite.Animate(enemy(enemyNum).SPR,enemy_walk_frames_180(enemyFrame),enemy(enemyNum).x+camera.x,enemy(enemyNum).y+camera.y,true)
     elsif whatAngleEnemy(enemy(enemyNum).x,enemy(enemyNum).y) >= 225 and whatAngleEnemy(enemy(enemyNum).x,enemy(enemyNum).y) < 315 then
        Sprite.Animate(enemy(enemyNum).SPR,enemy_walk_frames_270(enemyFrame),enemy(enemyNum).x+camera.x,enemy(enemyNum).y+camera.y,true)
     end if
     
    if enemy(enemyNum).shooting and enemy(enemyNum).init_shoot_dir then
        enemy(enemyNum).init_shoot_dir := false
        if whatAngleEnemy(enemy(enemyNum).x,enemy(enemyNum).y) >= 315 or whatAngleEnemy(enemy(enemyNum).x,enemy(enemyNum).y) < 45 then
            enemy(enemyNum).shoot_direction := "right"
        elsif whatAngleEnemy(enemy(enemyNum).x,enemy(enemyNum).y) >= 45 and whatAngleEnemy(enemy(enemyNum).x,enemy(enemyNum).y) < 135 then
            enemy(enemyNum).shoot_direction := "up"
        elsif whatAngleEnemy(enemy(enemyNum).x,enemy(enemyNum).y) >=135 and whatAngleEnemy(enemy(enemyNum).x,enemy(enemyNum).y) < 225 then
            enemy(enemyNum).shoot_direction := "left"
        elsif whatAngleEnemy(enemy(enemyNum).x,enemy(enemyNum).y) >= 225 and whatAngleEnemy(enemy(enemyNum).x,enemy(enemyNum).y) < 315 then
            enemy(enemyNum).shoot_direction := "down"
        end if
    end if
    
    if enemy(enemyNum).shooting then
        if enemy(enemyNum).shoot_direction = "right" then
            Sprite.Animate(enemy(enemyNum).bullet,bullet_img(1),enemy(enemyNum).bulletPos.x+camera.x,enemy(enemyNum).bulletPos.y+camera.y,true)
        elsif enemy(enemyNum).shoot_direction = "up" then
            Sprite.Animate(enemy(enemyNum).bullet,bullet_img(3),enemy(enemyNum).bulletPos.x+camera.x,enemy(enemyNum).bulletPos.y+camera.y,true)
        elsif enemy(enemyNum).shoot_direction = "left" then
            Sprite.Animate(enemy(enemyNum).bullet,bullet_img(5),enemy(enemyNum).bulletPos.x+camera.x,enemy(enemyNum).bulletPos.y+camera.y,true)
        elsif enemy(enemyNum).shoot_direction = "down" then
            Sprite.Animate(enemy(enemyNum).bullet,bullet_img(7),enemy(enemyNum).bulletPos.x+camera.x,enemy(enemyNum).bulletPos.y+camera.y,true)
        end if
    end if
%If the bullet hits a wall or the player, hide it and reset the shooting proc
if collisionDetect(enemy(enemyNum).bulletPos.x+camera.x,enemy(enemyNum).bulletPos.y+camera.y,false) or enemy(enemyNum).bulletPos.x+camera.x < -100 or enemy(enemyNum).bulletPos.x+camera.x > maxx + 100 or enemy(enemyNum).bulletPos.y+camera.y > maxy+100 or enemy(enemyNum).bulletPos.y+camera.y < -100 then
    enemy(enemyNum).shooting := false
    enemy(enemyNum).init_shoot_dir := true
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
enemy(enemyNum).bulletPos.x := enemy(enemyNum).x
enemy(enemyNum).bulletPos.y := enemy(enemyNum).y
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

%Declare Menu Gifs
%Logo Frames
var num_frames_logo : int := Pic.Frames("gifs/hotlineottawa-120.gif")
var delayTime3 : int
var logo_pics : array 1 .. num_frames_logo of int
Pic.FileNewFrames("gifs/hotlineottawa-120.gif",logo_pics,delayTime3)

%Play Selected Frames
var num_frames_play : int := Pic.Frames("gifs/play-selected-120.gif")
var delayTime4 : int
var play_selected_pics : array 1 .. num_frames_play of int
Pic.FileNewFrames("gifs/play-selected-120.gif",play_selected_pics,delayTime4)
%Play Unselected Frames
var num_frames_play_blank : int := Pic.Frames("gifs/play-blank-test.gif")
var delayTime5 : int
var play_unselected_pics : array 1 .. num_frames_play_blank of int
Pic.FileNewFrames("gifs/play-blank-test.gif",play_unselected_pics,delayTime5)

%Selected Scores Frames
var num_frames_scores_selected : int := Pic.Frames("gifs/scores-selected-120.gif")
var scores_selected_pics : array 1 .. num_frames_scores_selected of int
Pic.FileNewFrames("gifs/scores-selected-120.gif",scores_selected_pics,delayTime)
%Unselected Scores Frames
var num_frames_scores_unselected : int := Pic.Frames("gifs/scores-blank-120-test.gif")
var scores_unselected_pics : array 1 .. num_frames_scores_unselected of int
Pic.FileNewFrames("gifs/scores-blank-120-test.gif",scores_unselected_pics,delayTime)

%Selected Quit Frames
%var num_frames_quit_selected : int := Pic.Frames("gifs/quit-selected-120.gif")
%var quit_selected_pics : array 1 .. num_frames_quit_selected of int
var quit_selected_pics : int := Pic.FileNew("gifs/quit-selected-120.gif")
%Pic.FileNewFrames("gifs/quit-selected-120.gif",quit_selected_pics,delayTime)
%Unselected Quit Frames
%var num_frames_quit_unselected : int := Pic.Frames("gifs/quit-blank-120-black.gif")
%var quit_unselected_pics : array 1 .. num_frames_quit_unselected of int
var quit_unselected_pics : int := Pic.FileNew("gifs/quit-blank-120-black.gif")
%Pic.FileNewFrames("gifs/quit-blank-120-black.gif",quit_unselected_pics,delayTime)

%Background Frames
var num_frames_background : int := Pic.Frames("gifs/background-2fps.gif")
var background_pics : array 1 .. num_frames_background of int
Pic.FileNewFrames("gifs/background-2fps.gif",background_pics,delayTime)

%Background Image
var background_img : int := Pic.FileNew("bg.jpg")
var background_img_sprite : int := Sprite.New(background_img)
Sprite.SetPosition(background_img_sprite,0,0,false)  

var background_slider_sprite : int := Sprite.New(background_pics(1))
Sprite.SetPosition(background_slider_sprite,0,0,false)

logo_sprite := Sprite.New(logo_pics(1))
Sprite.SetPosition(logo_sprite,maxx div 2,maxy div 2+200,true)    

play_sprite := Sprite.New(logo_pics(1))
Sprite.SetPosition(play_sprite,maxx div 2,maxy div 2+75,true)

quit_sprite:= Sprite.New(quit_selected_pics)
Sprite.SetPosition(quit_sprite,maxx div 2, maxy div 2-130,true)

scores_sprite:= Sprite.New(scores_selected_pics(1))
Sprite.SetPosition(scores_sprite,maxx div 2, maxy div 2-25,true)
var type_exit : boolean := false
proc get_char (var field : string) 
    var ch : string(1)
    getch(ch)
    if ord(ch) = 8 then
        if length(field) > 0 then
            field := field(1..(length(field)-1))
            cls
            Pic.Draw(background_img,0,0,0)
        end if
    elsif ord(ch) = 10 then
        type_exit:=true
    else
        field += ch
        cls
        Pic.Draw(background_img,0,0,0)
    end if
end get_char

proc score_screen(mode:string)
    type_exit := false
    View.Set("offscreenonly")
    Sprite.Hide(background_slider_sprite)
    Sprite.Hide(player)
    for i : 1 .. num_enemies
        Sprite.Hide(enemy(i).SPR)
        Sprite.Hide(enemy(i).bullet)
    end for
    Sprite.Hide(bulletSPR)
    Sprite.Hide(player)
    Sprite.Hide(logo_sprite)
    Sprite.Hide(play_sprite)
    Sprite.Hide(background_img_sprite)
    %Sprite.Hide(scores_sprite)
    Sprite.Hide(quit_sprite)
    Pic.Draw(background_img,0,0,0)
    var key_delay : int := Time.Elapsed
    var file_num : int
    open : file_num,"hot_data",read
        read : file_num,scores
    close : file_num
    if mode = "win" then
        if scores(11).player_first_name = 'null' then
            scores(11).player_first_name := ""
        end if
        if scores(11).player_last_name = 'null' then
            scores(11).player_last_name := ""
        end if
        scores(11).miliseconds := level_time
        if scores(11).miliseconds < 1000 then
            scores(11).time_string :=  "00:00:"+intstr(scores(11).miliseconds)
        elsif scores(11).miliseconds < 60000 then
            scores(11).time_string := "00:"+intstr(scores(11).miliseconds div 1000)+":"+ intstr((scores(11).miliseconds-(scores(11).miliseconds div 1000)*1000))
        elsif scores(11).miliseconds > 60000 then
            if scores(11).miliseconds -((scores(11).miliseconds div 60000) * 60000) < 10000 then
                scores(11).time_string :=intstr(scores(11).miliseconds div 60000)+":0"+intstr((scores(11).miliseconds -((scores(11).miliseconds div 60000) * 60000))div 1000)+":"+ intstr((scores(11).miliseconds-(scores(11).miliseconds div 1000)*1000))
            else
                scores(11).time_string :=intstr(scores(11).miliseconds div 60000)+":"+intstr((scores(11).miliseconds -((scores(11).miliseconds div 60000) * 60000))div 1000)+":"+ intstr((scores(11).miliseconds-(scores(11).miliseconds div 1000)*1000))
            end if
        end if
        loop
            Font.Draw(scores(11).player_first_name,maxx div 2,maxy div 2 - 100,font2,black)
            Font.Draw("Please enter your first name: ",maxx div 2,maxy div 2,font2,black)
            get_char(scores(11).player_first_name)
            if type_exit = true then
                type_exit := false
                exit 
            end if
        end loop
            cls
            Pic.Draw(background_img,0,0,0)
        loop
            Font.Draw(scores(11).player_last_name,maxx div 2,maxy div 2 - 100,font2,black)
            Font.Draw("Please enter your last name: ",maxx div 2,maxy div 2,font2,black)
            get_char(scores(11).player_last_name)
            if type_exit = true then
                type_exit := false
                exit 
            end if
        end loop
         for cycles : 1 .. 11
        for items : 1 .. 10
            if scores(items).miliseconds > scores(items+1).miliseconds then
                var temp : score := scores(items)
                scores(items) := scores(items+1)
                scores(items+1) := temp
            end if
        end for
    end for
    open : file_num, "hot_data", write
        write : file_num, scores
    close : file_num
    end if
    cls
    Pic.Draw(background_img,0,0,0)
    Font.Draw("Name:    Time:",50,maxy - 200,font2,black)
    Font.Draw("________________________________________",50,maxy - 220,font2,black)
    for i : 1..11
        if scores(i).player_first_name ~= "null" then
            Font.Draw(scores(i).player_first_name + "           " + scores(i).time_string,50,maxy-220-30*i,font1,white)
        end if
    end for
    loop
        Input.KeyDown(chars)
        if chars(KEY_ESC) then
            menu_selection := 1
            exit
        end if
    end loop
end score_screen
proc main_menu
%View.Set("nooffscreenonly")
fork play_audio("menu")

var logo_frame_count : int := 1
var logo_increase : boolean := true
Sprite.Hide(player)
Sprite.Hide(enemy(1).SPR)
Sprite.Hide(enemy(2).SPR)
Sprite.Hide(enemy(3).SPR)
Sprite.Hide(enemy(4).SPR)
Sprite.Hide(bulletSPR)
Sprite.Hide(enemy(1).bullet)
Sprite.Hide(enemy(2).bullet)
Sprite.Hide(enemy(3).bullet)
Sprite.Hide(enemy(4).bullet)


menu_selection := 1
colorback(red)
cls
var logo_frame_time : int := Time.Elapsed
var background_frame_time : int := Time.Elapsed
loop
Sprite.Show(background_slider_sprite)
Sprite.Show(background_img_sprite)
Sprite.Show(logo_sprite)
Sprite.Show(play_sprite)
Sprite.Show(scores_sprite)
Sprite.Show(quit_sprite)
Input.KeyDown(chars)
Sprite.ChangePic(logo_sprite,logo_pics(logo_frame_count))
Sprite.ChangePic(background_slider_sprite,background_pics(background_frame))
if menu_selection = 1 then
Sprite.ChangePic(play_sprite,play_selected_pics(logo_frame_count))
Sprite.ChangePic(scores_sprite,scores_unselected_pics(logo_frame_count))
Sprite.ChangePic(quit_sprite,quit_unselected_pics)
elsif menu_selection = 2 then
Sprite.ChangePic(play_sprite,play_unselected_pics(logo_frame_count))
Sprite.ChangePic(scores_sprite,scores_selected_pics(logo_frame_count))
Sprite.ChangePic(quit_sprite,quit_unselected_pics)
elsif menu_selection = 3 then
Sprite.ChangePic(play_sprite,play_unselected_pics(logo_frame_count))
Sprite.ChangePic(scores_sprite,scores_unselected_pics(logo_frame_count))
Sprite.ChangePic(quit_sprite,quit_selected_pics)                
end if
if Time.Elapsed - logo_frame_time > 100 then
logo_frame_time := Time.Elapsed
if logo_increase then
logo_frame_count += 1
else 
logo_frame_count -= 1
end if
end if
if logo_frame_count = 85 then
logo_increase := false
elsif logo_frame_count = 1 then
logo_increase := true
end if
if Time.Elapsed - background_frame_time > 100 then
background_frame_time := Time.Elapsed
background_frame += 1
end if
if background_frame = num_frames_background then
background_frame := 1
end if
if chars(KEY_DOWN_ARROW) and Time.Elapsed - menu_time > 300 then
menu_time := Time.Elapsed
if menu_selection = 3 then
menu_selection := 1
else
menu_selection += 1
end if
elsif chars(KEY_UP_ARROW) and Time.Elapsed - menu_time > 300 then
menu_time := Time.Elapsed
if menu_selection = 1 then
menu_selection := 3
else
menu_selection -= 1
end if
end if
if menu_selection = 1 and chars(KEY_ENTER) then
menu_exit := true
%Randomize game
for i : 1 .. num_enemies
    resetAStar(i)
end for
set_enemy_room
reset_game_vars
start_time := Time.Elapsed
exit
elsif menu_selection =2 and chars(KEY_ENTER) then
    score_screen('null')
elsif menu_selection = 3 and chars(KEY_ENTER) then
Window.Hide(Window.GetActive)
quit
end if
end loop
%loop
%mousewhere(mousex,mousey,button)
%end loop
end main_menu
main_menu
start_time := Time.Elapsed
loop
    colorback(purple)
    View.Set("offscreenonly")
    level_time := Time.Elapsed - start_time
    if level_time < 1000 then
        Font.Draw("00:00:"+intstr(level_time),100,500,font1,black)
    elsif level_time < 60000 then
        Font.Draw("00:"+intstr(level_time div 1000)+":"+ intstr((level_time-(level_time div 1000)*1000)),100,500,font1,black)
    elsif level_time > 60000 then
        Font.Draw(intstr(level_time div 60000)+":"+intstr((level_time -((level_time div 60000) * 60000))div 1000)+":"+ intstr((level_time-(level_time div 1000)*1000)),100,500,font1,black)
    end if
    View.Update
    if menu_exit then
        menu_exit := false
        Sprite.Hide(quit_sprite)
        Sprite.Hide(logo_sprite)
        Sprite.Hide(scores_sprite)
        Sprite.Hide(play_sprite)
        Sprite.Hide(background_slider_sprite)
        Sprite.Hide(background_img_sprite)
        Sprite.Show(player)
    end if
    % Player Based Procedures(only run once)
    mousewhere(mousex,mousey,button)
    playerAnimate
    movement
    playerShoot
    playerRoom := roomAssign(maxx div 2,maxy div 2)
    Input.KeyDown(chars)
    if Time.Elapsed - reset_time > 300 then
        reset_time := Time.Elapsed
        if chars('r') then
            set_enemy_room
            reset_game_vars
            start_time := Time.Elapsed
        end if
    end if
    for i : 1 .. num_enemies
        if (Math.Distance(enemy(i).bulletPos.x+camera.x,enemy(i).bulletPos.y+camera.y,maxx div 2,maxy div 2) < 50 and enemy(i).shooting and enemy(i).dead = false) then
            for j : 1 .. num_enemies
                Sprite.Hide(enemy(j).bullet)
            end for
            Sprite.ChangePic(player,player_dead_pics(Rand.Int(1,3)))
            Font.Draw("Press 'r' to restart",maxx div 2,200,font2,black)
            Font.Draw("Press 'esc' to go to menu",maxx div 2,100,font2,black)
            View.Update
            loop
                Input.KeyDown(chars)
                    if chars(KEY_ESC) then
                        main_menu
                        exit
                    elsif chars('r') then
                        set_enemy_room
                        reset_game_vars
                        start_time := Time.Elapsed
                        exit
                    end if
            end loop
        end if
    end for
    if enemy(1).dead and enemy(2).dead and enemy(3).dead and enemy(4).dead then
        Font.Draw("You Win!",maxx div 2,maxy div 2,font2,black)
        Font.Draw("Get out!",maxx div 2,maxy div 2,font2,black)
        %1577,59
        if 1577 + camera.x > 50 and 1755 + camera.x < (maxx - 50) then
            if 60 + camera.y > 0 then
                Pic.Draw(down_arrow,1577+camera.x,60+camera.y,2)
            else
                Pic.Draw(down_arrow,1577+camera.x,0,2)
            end if
        elsif 1577 + camera.x <= 50 then
            Pic.Draw(down_arrow,50,0,2)
        elsif 1577 + camera.x >= (maxx - 50) then
            Pic.Draw(down_arrow,maxx - 50,0,2)
        end if
        View.Update
        %score_screen('win')
        %main_menu
    end if
    if chars('`') then
        if Time.Elapsed - debug_time > 400 then
            debug_time := Time.Elapsed
            if debug = true then
                debug := false
            else
                debug := true
            end if
        end if
    end if
    %%%%%%%%%%%%%%%%%%%%%
    for i : 1 .. num_enemies
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