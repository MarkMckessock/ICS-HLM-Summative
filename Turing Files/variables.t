%%%%%%%%%%%% MAIN GLOBAL VARIABLE DECLARATION FILE %%%%%%%%%%%%%%%%%%%

%%%%%%% RECORDS %%%%%%%%%
    % Represents x and y coordinates
        type coordinate:
            record
                x : int
                y : int
            end record
    % Represents keyboard input + movement result
        type inputEffect:
            record
                input :char
                effect :coordinate
            end record
    % Represents the grid space that came before the current space in pathfinding
        type parent_type:
            record
                enemy1 : coordinate
                enemy2 : coordinate
                enemy3 : coordinate
                enemy4 : coordinate
            end record
    % Represents high score values        
        type score: 
            record
                time_string : string
                miliseconds : int
                player_first_name : string
                player_last_name : string
            end record
    % Represents an enemy entity
        type enemyType:
        record
            x : int
            y : int
            randMove : int
            moveDirection : string
            shoot_direction : string
            dead : boolean
            pLast : coordinate
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
            death_animation : int
        end record
    % Represents a box on the pathfinding grid
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
    % Represents an element of the array of items that are checked during pathfinding
        type arrayElement:
            record
                a : int % X coordinate on the grid
                b : int % Y coordinate on the grid
                fScore : int % Score based on manhattan distance to the destination and from the origin
                direction : string % Indicates the direction on this space relative to the previous.
            end record
    % Represents a possible maximum and minimum value
        type range:
            record
                lower : int
                upper : int
            end record
    % Represents an individual peice of wall
        type wall: 
            record
                x: range 
                y : range
            end record

%%%%%% IMAGE/SPRITE DECLARATION %%%%%%%
    % Level Image
        var level_1 : int := Pic.FileNew("_img/environment/level_1.jpg") 
    % Directional Arrows
        var down_arrow : int := Pic.FileNew("_img/environment/go_down.gif")
        var left_arrow : int := Pic.FileNew("_img/environment/go_left.gif")
        var right_arrow : int := Pic.FileNew("_img/environment/go_right.gif")
    %Road
        var road_img : int := Pic.FileNew("_img/environment/road.jpg")
    % Enemy Death Images
        var enemy_dead_img : array 1 .. 4 of int
        enemy_dead_img(1) := Pic.FileNew("_img/characters/enemy/dead/enemy_dead_arm.gif")
        enemy_dead_img(2) := Pic.FileNew("_img/characters/enemy/dead/enemy_dead_chest.gif")
        enemy_dead_img(3) := Pic.FileNew("_img/characters/enemy/dead/enemy_dead_guts.gif")
        enemy_dead_img(4) := Pic.FileNew("_img/characters/enemy/dead/enemy_dead_head.gif")
    % Player Death Images
        var player_dead_pics : array 1 .. 3 of int
        player_dead_pics(1) := Pic.FileNew("_img/characters/player/dead/player_dead_1.gif")
        player_dead_pics(2) := Pic.FileNew("_img/characters/player/dead/player_dead_2.gif")
        player_dead_pics(3) := Pic.FileNew("_img/characters/player/dead/player_dead_3.gif")
    % Bullet Images
        var bullet_img : array 1 .. 8 of int
        bullet_img(1) := Pic.FileNew("_img/objects/bullet/bullet.gif")
        bullet_img(2) := Pic.FileNew("_img/objects/bullet/bullet45.gif")
        bullet_img(3) := Pic.FileNew("_img/objects/bullet/bullet90.gif")
        bullet_img(4) := Pic.FileNew("_img/objects/bullet/bullet135.gif")
        bullet_img(5) := Pic.FileNew("_img/objects/bullet/bullet180.gif")
        bullet_img(6) := Pic.FileNew("_img/objects/bullet/bullet225.gif")
        bullet_img(7) := Pic.FileNew("_img/objects/bullet/bullet270.gif")
        bullet_img(8) := Pic.FileNew("_img/objects/bullet/bullet315.gif")
        var bulletSPR : int := Sprite.New(bullet_img(1))
    % Enemy Walk Animation
        var delayTime : int
        var enemy_num_frames := Pic.Frames ("_img/characters/enemy/walk/enemy_walk_0.gif")
        var enemy_walk_frames_0 : array 1 .. enemy_num_frames of int
        Pic.FileNewFrames ("_img/characters/enemy/walk/enemy_walk_0.gif", enemy_walk_frames_0, delayTime)
        var enemy_walk_frames_90  : array 1 .. enemy_num_frames of int
        Pic.FileNewFrames ("_img/characters/enemy/walk/enemy_walk_90.gif", enemy_walk_frames_90, delayTime)
        var enemy_walk_frames_180 : array 1 .. enemy_num_frames of int
        Pic.FileNewFrames ("_img/characters/enemy/walk/enemy_walk_180.gif", enemy_walk_frames_180, delayTime)
        var enemy_walk_frames_270 : array 1 .. enemy_num_frames of int
        Pic.FileNewFrames ("_img/characters/enemy/walk/enemy_walk_270.gif", enemy_walk_frames_270, delayTime)
    % Player Walk Animation
        var player_num_frames := Pic.Frames ("_img/characters/player/walk/player_walk_0.gif")
        var player_walk_frames_0    : array 1 .. player_num_frames of int
        Pic.FileNewFrames ("_img/characters/player/walk/player_walk_0.gif", player_walk_frames_0, delayTime)
        var player_walk_frames_45 : array 1 .. player_num_frames of int
        Pic.FileNewFrames("_img/characters/player/walk/player_walk_45.gif",player_walk_frames_45,delayTime)
        var player_walk_frames_90 : array 1 .. player_num_frames of int
        Pic.FileNewFrames("_img/characters/player/walk/player_walk_90.gif",player_walk_frames_90,delayTime)
        var player_walk_frames_135 : array 1 .. player_num_frames of int
        Pic.FileNewFrames("_img/characters/player/walk/player_walk_135.gif",player_walk_frames_135,delayTime)
        var player_walk_frames_180 : array 1 .. player_num_frames of int
        Pic.FileNewFrames("_img/characters/player/walk/player_walk_180.gif",player_walk_frames_180,delayTime)
        var player_walk_frames_225 : array 1 .. player_num_frames of int
        Pic.FileNewFrames("_img/characters/player/walk/player_walk_225.gif",player_walk_frames_225,delayTime)
        var player_walk_frames_270 : array 1 .. player_num_frames of int
        Pic.FileNewFrames("_img/characters/player/walk/player_walk_270.gif",player_walk_frames_270,delayTime)
        var player_walk_frames_315 : array 1 .. player_num_frames of int
        Pic.FileNewFrames("_img/characters/player/walk/player_walk_315.gif",player_walk_frames_315,delayTime)
        var player: int := Sprite.New(player_walk_frames_0(1))
    % Van Animation
        var num_frames_van : int := Pic.Frames("_img/objects/van.gif")
        var van_frames : array 1 .. num_frames_van of int
        Pic.FileNewFrames("_img/objects/van.gif",van_frames,delayTime)
        var van_sprite := Sprite.New(van_frames(num_frames_van))
%Declare Menu Gifs
    %Background Image
        var background_img : int := Pic.FileNew("_img/menu/background.jpg")
        var background_img_sprite : int := Sprite.New(background_img)
        Sprite.SetPosition(background_img_sprite,0,0,false)
    %Slider Frames
        var num_frames_background : int := Pic.Frames("_img/menu/background-2fps.gif")
        var background_pics : array 1 .. num_frames_background of int
        Pic.FileNewFrames("_img/menu/background-2fps.gif",background_pics,delayTime)
        var background_slider_sprite : int := Sprite.New(background_pics(1))
        Sprite.SetPosition(background_slider_sprite,0,0,false)
    %Logo Frames
        var num_frames_logo : int := Pic.Frames("_img/menu/logo.gif")
        var logo_pics : array 1 .. num_frames_logo of int
        Pic.FileNewFrames("_img/menu/logo.gif",logo_pics,delayTime)
        var logo_sprite : int := Sprite.New(logo_pics(1))
        Sprite.SetPosition(logo_sprite,maxx div 2,maxy div 2+200,true)  
    %Play Selected Frames
        var num_frames_play : int := Pic.Frames("_img/menu/play-selected.gif")
        var play_selected_pics : array 1 .. num_frames_play of int
        Pic.FileNewFrames("_img/menu/play-selected.gif",play_selected_pics,delayTime)
        %play_sprite := Sprite.New(logo_pics(1))
        var play_sprite : int := Sprite.New(play_selected_pics(1))
        Sprite.SetPosition(play_sprite,maxx div 2,maxy div 2+75,true)
    %Play Unselected Frames
        var num_frames_play_blank : int := Pic.Frames("_img/menu/play-unselected.gif")
        var play_unselected_pics : array 1 .. num_frames_play_blank of int
        Pic.FileNewFrames("_img/menu/play-unselected.gif",play_unselected_pics,delayTime)
    %Selected Scores Frames
        var num_frames_scores_selected : int := Pic.Frames("_img/menu/scores-selected.gif")
        var scores_selected_pics : array 1 .. num_frames_scores_selected of int
        Pic.FileNewFrames("_img/menu/scores-selected.gif",scores_selected_pics,delayTime)
        var scores_sprite : int := Sprite.New(scores_selected_pics(1))
        Sprite.SetPosition(scores_sprite,maxx div 2, maxy div 2-25,true)
    %Unselected Scores Frames
        var num_frames_scores_unselected : int := Pic.Frames("_img/menu/scores-unselected.gif")
        var scores_unselected_pics : array 1 .. num_frames_scores_unselected of int
        Pic.FileNewFrames("_img/menu/scores-unselected.gif",scores_unselected_pics,delayTime)
    %Selected Quit Frames
        var quit_selected_pic : int := Pic.FileNew("_img/menu/quit-selected.gif")
        var quit_sprite : int := Sprite.New(quit_selected_pic)
        Sprite.SetPosition(quit_sprite,maxx div 2, maxy div 2-130,true)
    %Unselected Quit Frames
        var quit_unselected_pic : int := Pic.FileNew("_img/menu/quit-unselected.gif")
% Declare Enemies
    const num_enemies : int := 4
    var enemy : array 1 .. num_enemies of enemyType
    for i : 1 .. num_enemies
        enemy(i).bullet := Sprite.New(bullet_img(1))
        enemy(i).SPR := Sprite.New(enemy_walk_frames_0(1))
    end for
% Arrays for pathfinding data
    var enemy1Q : flexible array 1 .. 0 of arrayElement
    var enemy1Searched : flexible array 1 .. 0 of arrayElement
    var enemy2Q : flexible array 1 .. 0 of arrayElement
    var enemy2Searched : flexible array 1 .. 0 of arrayElement
    var enemy3Q : flexible array 1 .. 0 of arrayElement
    var enemy3Searched : flexible array 1 .. 0 of arrayElement
    var enemy4Q : flexible array 1 .. 0 of arrayElement
    var enemy4Searched : flexible array 1 .. 0 of arrayElement
    
% Timing varialbes
    var reset_time : int := Time.Elapsed % Time of last game reset
    var debug_time : int := Time.Elapsed % Time of last debug toggle
    var menu_time : int := Time.Elapsed % Time of last menu item change
    var level_time : int % Final time of level completion
    var start_time : int % Time at which a new game is started(resets upon new game)
    var shootDelay : int := Time.Elapsed % useless variable that Pic.FileNewFrames wants
    var lastInputCheck : int := 0 % Time of last character movement

% Boolean Switches
    var debug : boolean := false % Debug Mode (On/Off)
    var accept_input : boolean := true % Accepting keyboard input for movement (True/False)
    var menu_exit : boolean := false % Did the user just come from the menu?
    var shoot : boolean := false % true when player is shooting
    var end_animate : boolean := false % Is the end of game driving animation playing (True/False)
    var type_exit : boolean := false % Exit the text input mode of the scores screen
% Arrays
    var scores : array 1 .. 11 of score
    var grid : array 1..60,1..53 of box
    var inputEffects :array 1 .. 4 of inputEffect := init(init('a', init(6, 0)), init('d', init(-6, 0)), init('w', init(0, -6)), init('s', init(0,6)))
    var bulletPos : array 1 .. 3 of coordinate
    
% Fonts
    var font1 : int := Font.New("serif:12")
    var font2 : int := Font.New("serif:50")
    var font3 : int := Font.New("sans serif:25")
    
%Iterators and Frame counters
    var background_frame : int := 1
    var current_van_frame : int := num_frames_van
    var lastFrame : int := 0 % Move to animation module
    var lastEnemyFrame : int := 0 % Move to animation module
    var playerDirection : int % Move to animation module
    var playerFrame : int := 1 % Move to animation module
    var enemyFrame : int := 1 % Move to animation module
    
    var menu_selection : int % Move to menu module

    var camera : coordinate := init(0, 0)

    
    var level_pos : coordinate := init(0, 0)


var postMove : coordinate
    var walls : array 1 .. 30 of wall
var key :array char of boolean
var chars: array char of boolean


var mouse_x,mouse_y,button : int

var sightRange : int := 300
var dist : real
var playerRoom : string := ""

var shootDirection : int := 0

