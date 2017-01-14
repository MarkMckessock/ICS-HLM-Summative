% Player Animation and Logic
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


proc playerShoot
    if (chars(' ') or button = 1) and (Time.Elapsed - shootDelay) > 1000 then
        shootDelay := Time.Elapsed
        shoot := true
        resetAStar(1)
        resetAStar(2)
        resetAStar(3)
        resetAStar(4)
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

proc player_kill
    for j : 1 .. num_enemies
        Sprite.Hide(enemy(j).bullet)
    end for
    Music.PlayFileStop
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
            new_game := true
            reset_game_vars
            start_time := Time.Elapsed
            exit
        end if
    end loop
end player_kill