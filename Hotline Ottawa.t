%Written by Mark Mckessock for ICS3UG
View.Set("graphics:1260,900,offscreenonly,nocursor")
Pic.ScreenLoad("_img/menu/loading_crop.jpg",0,0,0)
View.Update

include "Turing Files/audio.t"
include "Turing Files/variables.t"
include "Turing Files/mouse_calculations.t"
include "Turing Files/game_setup.t"
include "Turing Files/pathfinding.t" 
include "Turing Files/reset_game.t"
include "Turing Files/movement.t"
include "Turing Files/menu.t"
include "Turing Files/player.t"
include "Turing Files/enemy.t"
include "Turing Files/sight_control.t"
include "Turing Files/debug.t"

cls

loop
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Setup parameters for first loop.
    if new_game then 
        fork play_audio("Game")
        new_game := false
        Sprite.Show(van_sprite)
        Sprite.Hide(quit_sprite)
        Sprite.Hide(logo_sprite)
        Sprite.Hide(scores_sprite)
        Sprite.Hide(play_sprite)
        Sprite.Hide(background_slider_sprite)
        Sprite.Hide(background_img_sprite)
        Sprite.Show(player)
    end if
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Call scores when all enemies are dead and the player gets off the far right of the screen.
    if enemy(1).dead and enemy(2).dead and enemy(3).dead and enemy(4).dead and camera.x < -3500 then
        score_screen('win')
        main_menu
    end if

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Player Based Procedures(only run once)
        % Get mouse and keyboard input
        mousewhere(mouse_x,mouse_y,button)
        Input.KeyDown(chars)
        % Don't let player shoot while van is driving.
        if end_animate = false then
            playerShoot
        end if
        %Set player room
        playerRoom := roomAssign(maxx div 2,maxy div 2)
        % Move camera and animate player
        playerAnimate
        movement
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Reset the game with 'r' at any time.
    if Time.Elapsed - reset_time > 300 then
        reset_time := Time.Elapsed
        if chars('r') then
            reset_game_vars
            start_time := Time.Elapsed
        end if
    end if
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Enable debug mode with '~' key
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
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Player kill 
    for i : 1 .. num_enemies
        if (Math.Distance(enemy(i).bulletPos.x+camera.x,enemy(i).bulletPos.y+camera.y,maxx div 2,maxy div 2) < 50 and enemy(i).shooting and enemy(i).dead = false) then
            player_kill
        end if
    end for
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Enemy control
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
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    View.Update
end loop