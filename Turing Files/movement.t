% Movement and World Animation Control
    
procedure movement
    if accept_input then
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
    end if
    cls
    Pic.Draw(level_1, level_pos.x + camera.x, level_pos.y + camera.y, picCopy)
    Pic.Draw(road_img,900+camera.x,-370+camera.y,0)  
    Pic.Draw(road_img,2340+camera.x,-370+camera.y,0)  
    Pic.Draw(road_img,-540+camera.x,-370+camera.y,0)
    Pic.Draw(road_img,3780+camera.x,-370+camera.y,0)  
    Pic.Draw(road_img,5220+camera.x,-370+camera.y,0)
    level_time := Time.Elapsed - start_time
    if level_time < 1000 then
        Font.Draw("00:00:"+intstr(level_time),0,maxy-30,font3,black)
    elsif level_time < 60000 then
        if level_time div 1000 < 10 then
            Font.Draw("00:"+"0"+intstr(level_time div 1000)+":"+ intstr((level_time-(level_time div 1000)*1000)),0,maxy-30,font3,black)
        else 
            Font.Draw("00:"+intstr(level_time div 1000)+":"+ intstr((level_time-(level_time div 1000)*1000)),0,maxy-30,font3,black)
        end if
    elsif level_time > 60000 then
        if(level_time -((level_time div 60000) * 60000))div 1000 < 10 then
            Font.Draw(intstr(level_time div 60000)+":"+"0"+intstr((level_time -((level_time div 60000) * 60000))div 1000)+":"+ intstr((level_time-(level_time div 1000)*1000)),0,maxy-30,font3,black)
        else
            Font.Draw(intstr(level_time div 60000)+":"+intstr((level_time -((level_time div 60000) * 60000))div 1000)+":"+ intstr((level_time-(level_time div 1000)*1000)),0,maxy-30,font3,black)
        end if
    end if
    if enemy(1).dead = false or enemy(2).dead = false or enemy(3).dead = false or enemy(4).dead = false or (maxx div 2 - camera.x >= 1577 and maxx div 2 - camera.x<= 1637 and maxy div 2 - camera.y <= - 37 and maxy div 2 - camera.x >= -121  ) = false then
        if end_animate = false then
            Sprite.Animate(van_sprite,van_frames(num_frames_van),1400+camera.x,-80+camera.y,false)
            Sprite.SetHeight(van_sprite,10)
            Sprite.Show(van_sprite)
        end if
    end if
    if enemy(1).dead and enemy(2).dead and enemy(3).dead and enemy(4).dead then
        Font.Draw("You Win!",maxx div 2-150,maxy div 2+70,font2,black)
        Font.Draw("Get out!",maxx div 2-120,maxy div 2+20,font2,black)
        %1577,59
        if (maxx div 2 - camera.x >= 1577 and maxx div 2 - camera.x <= 1637 and maxy div 2 - camera.y <= - 37)  or end_animate then
            end_animate := true
            Sprite.Hide(player)
            accept_input := false
                camera.x -= 20
                delay(45)
            if current_van_frame > 1 then
                current_van_frame -= 1
            end if            
            Sprite.Animate(van_sprite,van_frames(current_van_frame),maxx div 2-10,maxy div 2+40,true)
        else
            if 1577 + camera.x > 50 and 1755 + camera.x < (maxx+50)then
                if 60 + camera.y > 0 then
                    Pic.Draw(down_arrow,1577+camera.x,60+camera.y,2)
                else
                    Pic.Draw(down_arrow,1577+camera.x,0,2)
                end if
            elsif 1577 + camera.x <= 50 then
                if 60 + camera.y > 0 then
                    Pic.Draw(left_arrow,50,60+camera.y,2)
                else
                    Pic.Draw(down_arrow,50,0,2)
                end if
            elsif 1577 + camera.x >= (maxx - 150) then
                if 60 + camera.y > 0 then
                    Pic.Draw(right_arrow,maxx-150,60+camera.y,2)
                else
                    Pic.Draw(down_arrow,maxx-150,0,2)
                end if
            end if
        end if
        View.Update
    end if
    include "debug.t"
    View.Update
end movement