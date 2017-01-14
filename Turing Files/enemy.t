% Enemy Animation and Logic

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
        Sprite.Animate(enemy(enemyNum).SPR,enemy_dead_img(enemy(enemyNum).death_animation),enemy(enemyNum).x+camera.x,enemy(enemyNum).y+camera.y,true)
    end if
end AISearch


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
        if enemy(enemyNum).pLast.x not= -1 and playerRoom ~= 'outside' then
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
        if playerRoom ~= "outside" then
            aStar(enemy(enemyNum).x,enemy(enemyNum).y,enemy(enemyNum).tempPX,enemy(enemyNum).tempPY,enemyNum)
        end if
    end if
end enemyReact